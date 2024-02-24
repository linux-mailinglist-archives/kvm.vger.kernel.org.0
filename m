Return-Path: <kvm+bounces-9603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E73BE86261F
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 17:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24BCA1C20E19
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B3F41A87;
	Sat, 24 Feb 2024 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HudwQ5Er"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1E612B69;
	Sat, 24 Feb 2024 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708793340; cv=none; b=PLyhDPT5xOLhmgR03oTLHk7LlyY2Bz1vanQUXOD8dmembe9Y/ueCukNTf8IoabYNnBby4SCFq3mNkft2lFhWcwZ3UMuoZCjPT5zXvx4exTGF0sxdxtsJ+Haj3wztkK8S+GF+XvN2wIx17wCEnSXvdT4ncxKD8qRHmyC/1bSFxFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708793340; c=relaxed/simple;
	bh=F6MSB9VABa4MbtFG0Ul6QlwES73vt/bIlHb9ZQ2Si5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9AlS4zZ6WYJMxZN50uW9CbNs5FKVu6aCd95g+vDzTTxTB0lUJ1NHwCv2hemEJ+54wT/sgsqrGZ7PPpOJBW246im2a2r0vMdFPfYjpXpdIT1JdaCpevkmrpHPVIIZFb257hzmh2uC3JufQUy8NX1cAjIH/cxC37dZE9Y+ZwOONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HudwQ5Er; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708793338; x=1740329338;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F6MSB9VABa4MbtFG0Ul6QlwES73vt/bIlHb9ZQ2Si5I=;
  b=HudwQ5ErbwujZVtVe3CLBJB2s4Qdzrupl9ZCmmVjN1BLi/2Rl6NVabpj
   a/8VuNubrRPQ4LLsE9JWVlMh79jg6e5QnecikYpJRCfN0uh4jDihRirdD
   UELfjHZVTxPFl8m3Q2Ul2GpHzPhGl4MpV9KZ4CamvReLDNLGyaYpxrIhm
   XoQSwiMAdfWlirPUkZdJgy64xDgoG7V84qLPbSkffjiwlZ8VnSLe1O0px
   zrCqwj5ALPYG8NC+6lgaAV+mbAbkGim1tnPni51raheYmNbsAmAqWn4sm
   4amWg+yQH6R57rpA0JyHGvBs5kzLEdZx786iN6M9ic4d2qjknoQsX8lhT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10994"; a="6064434"
X-IronPort-AV: E=Sophos;i="6.06,181,1705392000"; 
   d="scan'208";a="6064434"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2024 08:48:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,181,1705392000"; 
   d="scan'208";a="43682090"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 24 Feb 2024 08:48:55 -0800
Date: Sun, 25 Feb 2024 00:44:55 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Friedrich Weber <f.weber@proxmox.com>,
	Kai Huang <kai.huang@intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZdodB3YbM1bJm+wQ@yilunxu-OptiPlex-7050>
References: <20240222012640.2820927-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222012640.2820927-1-seanjc@google.com>

On Wed, Feb 21, 2024 at 05:26:40PM -0800, Sean Christopherson wrote:
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

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

