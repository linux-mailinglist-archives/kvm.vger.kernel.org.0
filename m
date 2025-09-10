Return-Path: <kvm+bounces-57218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7DAB51F79
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E26457B852E
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91AF33436F;
	Wed, 10 Sep 2025 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jvdVsR8M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD41255F5E
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526623; cv=none; b=trq8JNoQl8IUb3USF/9s83u3+tByG0Ax7agN8xNctPo8gxfmTR4pJ6AsIagzv6MoJ/4E+2ATUIwOzQJjRsVFSew2k5JKIQsyQthktpOWrC0YGOoyrR50c38/8SCYbPJS8l5ASZlZemE35GnpUCX6ueiAvy7VcrVsHqJ8OhS8UaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526623; c=relaxed/simple;
	bh=kPnVJMDAr/6Z3m/fScpPLFT8Oxlrmeg2w8pvxqaiJI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AOFgqF6BYjEaZTBj01BkUUFFTlFdyOtmsIiBv06VQtbP0nqJ++dcGKeAFGEp2be4dMi1iXQgYwEBvfunRvwwQwZOo1JnQxZPslJAvpw4BWBWKAy1q2hxbcxbMzEo3W1kqOqkb9yNdEkDzmSfx+HJLtSE/m7JALHNdRoTmtgVCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jvdVsR8M; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7723d779674so6478161b3a.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 10:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757526621; x=1758131421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IUgfnEy4aH7Vf+d3WQbxgyXPH/BkEH0zY6EdXplzY4A=;
        b=jvdVsR8MAD/2AdHbrYttFysLT1a/tDQB7eV1NH/VzcKcEqwEu91fvHM6TIHN1TjUvG
         KBVY9ExIMTIbFYdx+R9PPtSC9S86kjvT1kjR5A5hO1ZGInRkleTntJ8Z/OLoSYjAeFtI
         Wtz1G+D0Bc983qvFhd9n+9W9crb0YhDR5SfA27HDUoAGHFE6QPlCooOzYROiQROjUUi+
         J9zoe3dZXIXtBT4wIJb39DUrlbh31NMvB/tKk4iR18++Z+qMpL5pb9iOxg6olbunyN+3
         eOYBQf7eZQViBHOEvKDsMcEKRyktgd57an+zMJt2QIVCq2rziLaE+3F8zCFbGw2CvWok
         9T9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757526621; x=1758131421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUgfnEy4aH7Vf+d3WQbxgyXPH/BkEH0zY6EdXplzY4A=;
        b=F9RbKsOtAUlkj7BAou9nOBMWXaR/cazCA/5om3ZgD7IvO2Bu0vAsuT5d1Z/M/sht32
         xzjBmaxBbZkgokTovwRKZ9mmYgG9XUtLZTvYxfV318yDr2xUFlCo8HpmCVRzMfjHQv4/
         ubXsXH4d0cvX3QjaAi/0jNt2YOl1Y8aQDZZwpge3Vu3ZZMca10yEMGgaV/HgNDnjTVpx
         egksFz1nTJUNCQoyZnPjQ8jRKtRqG2uib0MTItP8RW3CAfXo/SygRdg+hn0N/gcMb/R7
         X+U93Hls//soJeJhBgVfxkO5BwsjX9/Hxr7t7PTewjBNjbaXBt3yuvjCIf1qGud48fe8
         GPSg==
X-Forwarded-Encrypted: i=1; AJvYcCX2v4x4/DKlzEcJ6C6YcLWimy2MN7DSx9Z8ALjX0qNvCYUsQhubvB0OMqknRWWIpaLUU1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU2iHHOdS4vUbEt6xqoMUwZeki43tz+SuofiAu3wp1dtXgSvom
	N27Eu632pQWfajZqQGSMXn0wRmS/9tDY1j92JNPjxgVOf0cz99vCMDSLX95/OXZ/vRpozm0rRPA
	I+9mKVQ==
X-Google-Smtp-Source: AGHT+IE0PBz+CoprrtHW8pDY4jQGWJaV/o6dVyl7o9HIHMuSqSir0HcUrugd2aROC3ZRJusmLA1OpAmyzDs=
X-Received: from pfll7.prod.google.com ([2002:a05:6a00:1587:b0:772:2f71:c54b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2316:b0:772:4759:e45d
 with SMTP id d2e1a72fcca58-7742de8f0e6mr20966795b3a.22.1757526620819; Wed, 10
 Sep 2025 10:50:20 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:50:19 -0700
In-Reply-To: <aMFedyAqac+S38P2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <20250909093953.202028-7-chao.gao@intel.com>
 <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com> <aMFedyAqac+S38P2@intel.com>
Message-ID: <aMG6Wx9k2T47OTge@google.com>
Subject: Re: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	john.allen@amd.com, mingo@kernel.org, mingo@redhat.com, 
	minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org, 
	pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com, 
	shuah@kernel.org, tglx@linutronix.de, weijiang.yang@intel.com, x86@kernel.org, 
	xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Chao Gao wrote:
> On Wed, Sep 10, 2025 at 05:37:50PM +0800, Xiaoyao Li wrote:
> >On 9/9/2025 5:39 PM, Chao Gao wrote:
> >> From: Sean Christopherson <seanjc@google.com>
> >> 
> >> Load the guest's FPU state if userspace is accessing MSRs whose values
> >> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> >> to facilitate access to such kind of MSRs.
> >> 
> >> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> >> the guest MSRs are swapped with host's before vCPU exits to userspace and
> >> after it reenters kernel before next VM-entry.
> >> 
> >> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> >> explicitly check @vcpu is non-null before attempting to load guest state.
> >> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
> >> loading guest FPU state (which doesn't exist).
> >> 
> >> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> >> access MSRs that have not been exposed to the guest, e.g. it might do
> >> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> ...
> 
> >> +	bool fpu_loaded = false;
> >>   	int i;
> >> -	for (i = 0; i < msrs->nmsrs; ++i)
> >> +	for (i = 0; i < msrs->nmsrs; ++i) {
> >> +		/*
> >> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
> >> +		 * temporarily load the guest's FPU state so that the guest's
> >> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
> >> +		 * get/set the MSR via RDMSR/WRMSR.
> >> +		 */
> >> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> >
> >why not check vcpu->arch.guest_supported_xss?
> 
> Looks like Sean anticipated someone would ask this question.

I don't think so, I'm pretty sure querying kvm_caps.supported_xss is a holdover
from the early days of this patch, e.g. before guest_cpu_cap_has() existed, and
potentially even before vcpu->arch.guest_supported_xss existed.

I'm pretty sure we can make this less weird and more accurate:

/*
 * Returns true if the MSR in question is managed via XSTATE, i.e. is context
 * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
 * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
 * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
 * the value saved/restored via XSTATE is always the host's value.  That detail
 * is _extremely_ important, as the guest's S_CET must _never_ be resident in
 * hardware while executing in the host.  Loading guest values for U_CET and
 * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
 * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
 * privilegel levels, i.e. are effectively only consumed by userspace as well.
 */
static bool is_xstate_managed_msr(struct kvm_vcpu *vcpu, u32 msr)
{
	if (!vcpu)
		return false;

	switch (msr) {
	case MSR_IA32_U_CET:
		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ||
		       guest_cpu_cap_has(vcpu, X86_FEATURE_IBT);
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
	default:
		return false;
	}
}

Which is very desirable because the KVM_{G,S}ET_ONE_REG path also needs to
load/put the FPU, as found via a WIP selftest that tripped:

  KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);

And if we simplify is_xstate_managed_msr(), then the accessors can also do:

  KVM_BUG_ON(!is_xstate_managed_msr(vcpu, msr_info->index), vcpu->kvm);

