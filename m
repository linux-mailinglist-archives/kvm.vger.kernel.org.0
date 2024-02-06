Return-Path: <kvm+bounces-8100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4799C84B6EF
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 14:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 783F21C23909
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 13:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B1C131750;
	Tue,  6 Feb 2024 13:52:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAAB130ADC;
	Tue,  6 Feb 2024 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707227566; cv=none; b=LkZ02ZKIpiB/d485ec2G+Qu9oLXO6wvDaUHaZVYMuFmAN9aMDf6K5/GDBYJlLzEeaggt8Ez+HxLx80P5HdHJQixQqnl7aRYVb1g5fW4o/+qDUEStlwdpyMKAJ07YEXI+E0943jPFRV4SDdGPxfnF3ioH4ab16DxRHcdyWAlx6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707227566; c=relaxed/simple;
	bh=Ubkt6qIPEv5fuYSFa69M91opwlIb14lKRpWev/uocBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTQ1ndvHu6ryO0PPRrZZHr8mEwcHIrkG4uYw6Oxk7neHY3FDOmY1KZTnmtByDFlf4w6Ee9UF65aB0whgjoAkX4fGw3fxs9kLk8ul2O+Bh39TYMR0uTsfqLsGPw1QD8zoCm9Dm+v/TvYAsbLgIQm6H6Bwp0sZOsNdtTS4A3fueyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 3E8D84481B;
	Tue,  6 Feb 2024 14:52:35 +0100 (CET)
Message-ID: <b9f6e379-f517-4c24-8df4-1e5484515324@proxmox.com>
Date: Tue, 6 Feb 2024 14:52:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>,
 Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
References: <20240203003518.387220-1-seanjc@google.com>
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <20240203003518.387220-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/02/2024 01:35, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock if the resolved gfn is covered
> by an active invalidation.  Contending for mmu_lock is especially
> problematic on preemptible kernels as the mmu_notifier invalidation task
> will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
> invalidation, and ultimately increase the latency of resolving the page
> fault.  And in the worst case scenario, yielding will be accompanied by a
> remote TLB flush, e.g. if the invalidation covers a large range of memory
> and vCPUs are accessing addresses that were already zapped.
[...]

Can confirm this patch fixes temporary guest hangs in combination with
KSM and NUMA balancing I'm seeing [1], which is likely to be the same
issue as described in [2]:

* On this patch's base-commit 60eedcfc from
git.kernel.org/pub/scm/virt/kvm/kvm.git, I can reproduce the hangs (see
[1] for reproducer)
* With this patch applied on top, I cannot reproduce the hangs anymore.

Thanks!

[1]
https://lore.kernel.org/kvm/832697b9-3652-422d-a019-8c0574a188ac@proxmox.com/
[2] https://bugzilla.kernel.org/show_bug.cgi?id=218259


