Return-Path: <kvm+bounces-11057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30935872631
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53FB21C25D45
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12DA1B59C;
	Tue,  5 Mar 2024 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lx/uVdSM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3307718EB0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661866; cv=none; b=mYv43FSC9TBVhMDzlK1rON5V73dY4HyQg0IMv8lWUQ/dNoBU3uNjpQFch/Nog/n30Tun7vPPxBiIvYYkFtsNt5LBqJ46xRX/liQ2nsOoWGrqegkRJA8aIxuO3C2MoUXIDTYVLi8NhgzB3Y2P/zFg0pdi1RjswmlrsNk5SGHrDww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661866; c=relaxed/simple;
	bh=KlteQmYHydWNBOpxdpzf+ptjubVxDcE/oTAcS8ClTCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EWK4dd7G+RBqkqgABFLiRG5vUl8icAYIY8LJiWrvmg39UWIq16xnpTsSTB/MXay3PIklDi4ozG/DnuIanowJm7h1CmwHMm6KVh/9oSZ2L4z6lDlwNdc0XFo/WBQHI7K7Ab68L7K/3BB5NohYrLajHpihJ9Efv9lpD2jrYtmE/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lx/uVdSM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607c9677a91so98825727b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 10:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709661863; x=1710266663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pEbrJLbsSQI/fw5oAKGC5MieHsStoqch1a0BdEdHBlY=;
        b=Lx/uVdSMQf992dTYkIderi7voShRPjzxBfQcJleun8akA1s316Flk0UoDnRtcO4ujY
         fQZ5op5ngmWIv2bWeSdXOXGtl4JXj9Kpdr3Y8zgWYcxSX2rlwpsGCaXqWcDuovjIlpXw
         PLNAq3TtOamsHeLPsc2fwpSkQpStyv9N11mTrutYPZ+91/FZOohLvHFHGAQxXasM48Jj
         6VEWFbuPEcTcMy5MwqTnLhq59/p/71Y2HA87+mTgy51kvGXXmwwr5LEJEf7s0DxscZVo
         qv4AoFzFE6xGIV4x1yogkHo9XQpCg6GwADtYrnDqHBvOr97T1KeA8N2tt4X9js+fMvZ2
         ySQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709661863; x=1710266663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEbrJLbsSQI/fw5oAKGC5MieHsStoqch1a0BdEdHBlY=;
        b=YWp9ntDDdosIrim/KiguVmKXUOGTbJlKAP+ih63mPrpUTI3HNYi+lBOlxZG8ftHp8n
         EAF8gCoxZoPiequNgDOfRk37XcJUqkv1LXisnv5USS8lwMAPGIu0mHQ2x9ezergwIT1M
         LN9TczXA/0kp82+zdMaEHsUqrpC/7YQWO19HbxbE2aaiauSl2D5f3npC5FkdmYce/upc
         BLJHOcIb95a6uTJ0HwL9tTHnbu2KrOZDPYvGR5ct0td1uz/M7W2YWbDo8MqQxGG6ZeaJ
         4LMcliaCag/XPMwMJv7stUskeBWvy5Ro1ydpT+wtxrXQEPxSxsE6TovzqB7MXV6G+ZOZ
         Mu3w==
X-Forwarded-Encrypted: i=1; AJvYcCVselVmDNzhH/VHcESXVR2/6m0R880KkyMbq7COwFQ6IYodEG1v/bYf42iqbHyybfSPxIu8+BGtp66CWz9TMovKMl1O
X-Gm-Message-State: AOJu0Yzf5OqulU4V+HjY7vcUl+tuGJKhAKqNJR5Et+q1gHkaOI2UUd/b
	boAOUa3vlqGZIP4m5OgPiK6SnDFIkskDjUikw+wcKksATfGr6dXN0OIIY0NhvxD4J6zYl1aj+H7
	QGA==
X-Google-Smtp-Source: AGHT+IHQ9UsEAu7P7/CrKaWcVqX4oXUziFtlmyRIzxiyJyrSWM03oEu21H2c1A1L24BxK1ATy8oHmtOSpnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3507:b0:609:3c79:dbf1 with SMTP id
 fq7-20020a05690c350700b006093c79dbf1mr3570872ywb.8.1709661863151; Tue, 05 Mar
 2024 10:04:23 -0800 (PST)
Date: Tue, 5 Mar 2024 10:04:21 -0800
In-Reply-To: <ZedUwKWW7PNkvUH1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301075007.644152-1-sandipan.das@amd.com> <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com> <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com> <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
 <ZedUwKWW7PNkvUH1@google.com>
Message-ID: <ZedepdnKSl6oFNUq@google.com>
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits correctly
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	pbonzini@redhat.com, mizhang@google.com, jmattson@google.com, 
	ravi.bangoria@amd.com, nikunj.dadhania@amd.com, santosh.shukla@amd.com, 
	manali.shukla@amd.com, babu.moger@amd.com, kvm list <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Like Xu wrote:
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 87cc6c8809ad..f61ce26aeb90 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>   */
>  void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
>  	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
>  		return;
>  
> @@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_pmu_reset(vcpu);
>  
> -	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> +	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>  	static_call(kvm_x86_pmu_refresh)(vcpu);
> +
> +	/*
> +	 * At RESET, both Intel and AMD CPUs set all enable bits for general
> +	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
> +	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
> +	 * in the global controls).  Emulate that behavior when refreshing the
> +	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
> +	 */
> +	if (kvm_pmu_has_perf_global_ctrl(pmu))
> +		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>  }

Doh, this is based on kvm/kvm-uapi, I'll rebase to kvm-x86/next before posting.

I'll also update the changelog to call out that KVM has always clobbered global_ctrl
during PMU refresh, i.e. there is no danger of breaking existing setups by
clobbering a value set by userspace, e.g. during live migration.

Lastly, I'll also update the changelog to call out that KVM *did* actually set
the general purpose counter enable bits in global_ctrl at "RESET" until v6.0,
and that KVM intentionally removed that behavior because of what appears to be
an Intel SDM bug.

Of course, in typical KVM fashion, that old code was also broken in its own way
(the history of this code is a comedy of errors).  Initial vPMU support in commit
f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests") *almost*
got it right, but for some reason only set the bits if the guest PMU was
advertised as v1:

        if (pmu->version == 1) {
                pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
                return;
        }


Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on
reset") then tried to remedy that goof, but botched things and also enabled the
fixed counters:

        pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
                (((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
        pmu->global_ctrl_mask = ~pmu->global_ctrl;

Which was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu: Don't overwrite
the pmu->global_ctrl when refreshing") incorrectly removed *everything*.  Very
ironically, that commit came from Like.

Author: Like Xu <likexu@tencent.com>
Date:   Tue May 10 12:44:07 2022 +0800

    KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
    
    Assigning a value to pmu->global_ctrl just to set the value of
    pmu->global_ctrl_mask is more readable but does not conform to the
    specification. The value is reset to zero on Power up and Reset but
    stays unchanged on INIT, like most other MSRs.

But wait, it gets even better.  Like wasn't making up that behavior, Intel's SDM
circa December 2022 states that "Global Perf Counter Controls" is '0' at Power-Up
and RESET.  But then the March 2023 SDM rolls out and says

  IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.

So presumably someone at Intel noticed that what their CPUs do and what the
documentation says didn't match.

*sigh*

