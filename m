Return-Path: <kvm+bounces-9425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7152B85FE93
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 18:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9BD4B25B7E
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426C1154BED;
	Thu, 22 Feb 2024 16:59:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A1A153BCE;
	Thu, 22 Feb 2024 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708621189; cv=none; b=qoFtupPngJHVGEXcnUGh+iQ5jItvmsuL8RNHCMQpleEwofYnAsdpgaqakgOuCO7ba5t1jLKGD1E/B6M+1Z8gZ5bgJBcdHLfHiBMYEdxM2xOW3fUEmVeKqUNzUTQbdJCsMaix3/Q9S/c68+8BWN32W23W9HV7PTBxwJgV8eMvx/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708621189; c=relaxed/simple;
	bh=mFjlaeGN07dgGRzQB14f7xCSu7QrFn9u6AqzQ15Qs2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PoL54RP0QvHuGz87/NEZnnshhremJAIctAIuCNDMECpD+oK3uq+B2KmWX4AshIrUVHHQr8wuvRxCASOphr7aCFgitCC1qIPiE+wtRsPs+OikF6dBET6MIPrwx7IT9ciCB2+u7nol3172wJhZhxRusnBiVtHoX8fahIKpYzInOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id E5CD544ADC;
	Thu, 22 Feb 2024 17:59:43 +0100 (CET)
Message-ID: <2b0ed3ba-d8da-401e-9495-6b6670d7b418@proxmox.com>
Date: Thu, 22 Feb 2024 17:59:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>,
 Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
References: <20240222012640.2820927-1-seanjc@google.com>
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <20240222012640.2820927-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/02/2024 02:26, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock, and without even faulting
> the page into the primary MMU, if the resolved gfn is covered by an active
> invalidation.  Contending for mmu_lock is especially problematic on
> preemptible kernels as the mmu_notifier invalidation task will yield
> mmu_lock (see rwlock_needbreak()), delay the in-progress invalidation, and
> ultimately increase the latency of resolving the page fault.  And in the
> worst case scenario, yielding will be accompanied by a remote TLB flush,
> e.g. if the invalidation covers a large range of memory and vCPUs are
> accessing addresses that were already zapped.
> 
> Faulting the page into the primary MMU is similarly problematic, as doing
> so may acquire locks that need to be taken for the invalidation to
> complete (the primary MMU has finer grained locks than KVM's MMU), and/or
> may cause unnecessary churn (getting/putting pages, marking them accessed,
> etc).
> 
> Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
> iterators to perform more work before yielding, but that wouldn't solve
> the lock contention and would negatively affect scenarios where a vCPU is
> trying to fault in an address that is NOT covered by the in-progress
> invalidation.
> 
> Add a dedicated lockess version of the range-based retry check to avoid
> false positives on the sanity check on start+end WARN, and so that it's
> super obvious that checking for a racing invalidation without holding
> mmu_lock is unsafe (though obviously useful).
> 
> Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that pre-checking
> invalidation in a loop won't put KVM into an infinite loop, e.g. due to
> caching the in-progress flag and never seeing it go to '0'.
> 
> Force a load of mmu_invalidate_seq as well, even though it isn't strictly
> necessary to avoid an infinite loop, as doing so improves the probability
> that KVM will detect an invalidation that already completed before
> acquiring mmu_lock and bailing anyways.
> 
> Do the pre-check even for non-preemptible kernels, as waiting to detect
> the invalidation until mmu_lock is held guarantees the vCPU will observe
> the worst case latency in terms of handling the fault, and can generate
> even more mmu_lock contention.  E.g. the vCPU will acquire mmu_lock,
> detect retry, drop mmu_lock, re-enter the guest, retake the fault, and
> eventually re-acquire mmu_lock.  This behavior is also why there are no
> new starvation issues due to losing the fairness guarantees provided by
> rwlocks: if the vCPU needs to retry, it _must_ drop mmu_lock, i.e. waiting
> on mmu_lock doesn't guarantee forward progress in the face of _another_
> mmu_notifier invalidation event.
> 
> Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
> may generate a load into a register instead of doing a direct comparison
> (MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
> is a few bytes of code and maaaaybe a cycle or three.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> Reported-by: Friedrich Weber <f.weber@proxmox.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Yuan Yao <yuan.yao@linux.intel.com>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Couldn't find the base-commit 21dbc438 (might not have looked at the
right place though), so I applied this patch on top of c48617fb ("Merge
tag 'kvmarm-fixes-6.8-3' ...") from kvm/kvm.git. Can confirm the patch
fixes the temporary guest hangs in combination with KSM and NUMA
balancing [1]. Thanks!

[1]
https://lore.kernel.org/kvm/832697b9-3652-422d-a019-8c0574a188ac@proxmox.com/


