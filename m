Return-Path: <kvm+bounces-54093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A76B1C1D2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 10:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4D51189044D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD9F221278;
	Wed,  6 Aug 2025 08:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DbpVQwVI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEC8220F49;
	Wed,  6 Aug 2025 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754467733; cv=none; b=JMe+UhTtNWFlnQxY1Abc8Yo/1kQTH+HMRI/mCvHQlDdZiRgIBgFv2R3Odk2HjTXN1GuKcMNrjkYe52zpdNfjVLaC1r+92mYZQO+B6HuSLSg98wKrwY4F+EjIZNDWZmubqQJrTbiwIdi6rx6LBYqoaRAyV7eGbYrPsfUuds2Sv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754467733; c=relaxed/simple;
	bh=IirMztWiMYJs6AlUEu+SMZ/Ur9xRr4eUSDCoUJhJTrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QON++gPrRW1D8i0jpWN8RN+vTY12fPhmCdQCXGjnImXvQHktnz0hxxvOcZ8L0r+05HFjNRU+1IAq5XrIpdgGENLZWXs0UViqheSbKcJQxY5g2I5vAsiGCE7Y77ZlDhKbDFEm+mGO/L3F+wOju0etjsyxB8mEzOD27T4UFlVdpAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DbpVQwVI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754467731; x=1786003731;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IirMztWiMYJs6AlUEu+SMZ/Ur9xRr4eUSDCoUJhJTrk=;
  b=DbpVQwVId7Z9Tqeg9azc7Tj2BN0JWk+xbK1Fn1xGLzNpYxYy3OyKhUqk
   ecKrzlVpJDLcn/0kFf2wO5X9XtXB/WI8WHOYY8PMZ0489Ms+U+b2tFvGJ
   rSSErEYXpv70swPnC8KFtAnFKgyXCnS9L12iNMvuzZVHrylmHjghAtYkL
   KRwqVWFNGmOZHvZgl0C3RLutT94CXdY2sMbcp41BA1YdfLlDY2+fDz6wW
   mCvo3DMWsUykRDLBdI2D2rigOrRsIrRUhnjHtyi5GzEvks6gQtwonh57i
   cKnAe+qUA+YXA1kTh7YiUQOoAViy74Bq8rT/VM1FvuPILT6nl7r9lkP3B
   Q==;
X-CSE-ConnectionGUID: RfHlboYMTK2swO51QVMADA==
X-CSE-MsgGUID: HRcGByRMRLmlFJzggCUHVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="79326550"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="79326550"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:08:50 -0700
X-CSE-ConnectionGUID: N7sM4bviR/2oI+w62M6HMw==
X-CSE-MsgGUID: KP290fx6ReaEEeXQfoHzAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="168959525"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:08:49 -0700
Message-ID: <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com>
Date: Wed, 6 Aug 2025 16:08:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into
 kvm_pmu_trigger_event()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-18-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check the
> PMU event filter, to further trim the amount of code that is executed with
> SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can do
> more harm than good due to masking potential bugs, and introducing a new
> SRCU-protected asset to code reachable via kvm_skip_emulated_instruction()
> would be quite notable, i.e. definitely worth auditing.
>
> E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslots
> all but guarantees guest memory may be accessed, accessing guest memory
> can fault, and page faults might sleep, which isn't allowed while IRQs are
> disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep would
> be flagged when running with PROVE_RCU=y, even if DEBUG_ATOMIC_SLEEP=n.
>
> Note, performance is NOT a motivating factor, as SRCU lock/unlock only
> adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
> concern _if_ SRCU protection needs to be extended beyond PMU events, e.g.
> to honor userspace MSR filters.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c |  4 +++-
>  arch/x86/kvm/x86.c | 18 +++++-------------
>  2 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e75671b6e88c..3206412a35a1 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -955,7 +955,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
> -	int i;
> +	int i, idx;
>  
>  	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
>  
> @@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
>  		return;
>  
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);

It looks the asset what "kvm->srcu" protects here is
kvm->arch.pmu_event_filter which is only read by pmc_is_event_allowed().
Besides here, pmc_is_event_allowed() is called by reprogram_counter() but
without srcu_read_lock()/srcu_read_unlock() protection.

So should we shrink the protection range further and move the
srcu_read_lock()/srcu_read_unlock() pair into pmc_is_event_allowed()
helper? The side effect is it would bring some extra overhead since
srcu_read_lock()/srcu_read_unlock() could be called multiple times. An
alternative could be to add srcu_read_lock()/srcu_read_unlock() around
pmc_is_event_allowed() in reprogram_counter() helper as well.

The other part looks good to me.


>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
>  		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);
>  	}
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  }
>  
>  void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f2b2eaaec6f8..a56f83b40a55 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2137,7 +2137,6 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u64 data = kvm_read_edx_eax(vcpu);
>  	u32 msr = kvm_rcx_read(vcpu);
> -	int r;
>  
>  	switch (msr) {
>  	case APIC_BASE_MSR + (APIC_ICR >> 4):
> @@ -2152,13 +2151,12 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>  		return EXIT_FASTPATH_NONE;
>  	}
>  
> -	kvm_vcpu_srcu_read_lock(vcpu);
> -	r = kvm_skip_emulated_instruction(vcpu);
> -	kvm_vcpu_srcu_read_unlock(vcpu);
> -
>  	trace_kvm_msr_write(msr, data);
>  
> -	return r ? EXIT_FASTPATH_REENTER_GUEST : EXIT_FASTPATH_EXIT_USERSPACE;
> +	if (!kvm_skip_emulated_instruction(vcpu))
> +		return EXIT_FASTPATH_EXIT_USERSPACE;
> +
> +	return EXIT_FASTPATH_REENTER_GUEST;
>  }
>  EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
>  
> @@ -11251,13 +11249,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
>  fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu)
>  {
> -	int ret;
> -
> -	kvm_vcpu_srcu_read_lock(vcpu);
> -	ret = kvm_emulate_halt(vcpu);
> -	kvm_vcpu_srcu_read_unlock(vcpu);
> -
> -	if (!ret)
> +	if (!kvm_emulate_halt(vcpu))
>  		return EXIT_FASTPATH_EXIT_USERSPACE;
>  
>  	if (kvm_vcpu_running(vcpu))

