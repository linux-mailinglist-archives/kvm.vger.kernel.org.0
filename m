Return-Path: <kvm+bounces-20117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F86910BC7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD32F1C23FE9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E0C1B29B1;
	Thu, 20 Jun 2024 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cWt8BUm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA39D19EEBC
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718900206; cv=none; b=T1I83oLxLWRaIC/PaaAWPZn4YNjWwgkmcvevu63lucT4cS3y3fsWGvPX7iLz0IlRVlcqkMplUoiAC36ISr1I6Sc52pYekk5cRnFa+p5JWp9gRWt3tPpiv0hhsEhX38g8sZWtZUmd4ROftay41n6VtbTlyuBxy8th0Z6dm1Lmg90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718900206; c=relaxed/simple;
	bh=3F25YNJFqKhy4bYsXBenLOYPz74lQQHcEZxBGefIBRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k4BL716U0JaDJpf8yKaPpaK2on7rlRvFqECcgqdFXlRlkUe7+wQDFXvOzxLWnlTHcsVikN+QF01IPi9tsv7rZxEpCQsAmjdTw252E7f+0fiMEQbR26Gqde5fe3h8clLGJfHfW/oyG7SlmlMDzTnJ8LLq/mBRyl1d8cffwZmtu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cWt8BUm8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa73db88dcso1891585276.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 09:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718900202; x=1719505002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BCZKNDHzfJBJVhIBZvZUEBrTAzEooayjC9bbFQcCP8A=;
        b=cWt8BUm8x6qqhvFOl+nu0cuN47U+5GFlCU2pacqruvMtmRDjfiRJqfr7ehGWjOssoK
         qhlmF1sqrS3X1PxYfxLMKH5v/UiZNvausVy+uNhJ/1PYjgHYz3vei/uVQ+eFMLsJVRvZ
         PNOMz7Q/MoDiGqH6zsrI4NFZAskNHq8Ock2j4OwUTnhmRGKLQnXXczlXPJLUw1fXybWN
         iyQhjK3vv7Hg6WdOWUtesXmMUe31lf4N+b9uKAYMNUoXaNzIf4JGBXa/dg/hLVlyfArr
         zoVbFTuXHB3AH4djunUeKtEoaL8sOPdu+5zd4AncyNCWtFDaI7++Oz9yBv1qnsYwv3gI
         JmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718900202; x=1719505002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BCZKNDHzfJBJVhIBZvZUEBrTAzEooayjC9bbFQcCP8A=;
        b=g4+yJ7PXL/0GwtIV8J6iuBeC1jBOrM7yroxyOIoMtZ82Ngcly08YN7+fDVREGNz4JS
         R0Ego2nOMj/Sq8gvlOfMASHfneVd3lMptNGZqicFcaJiB9Dzo0hYFvOX5hu71+IBYjTG
         XZUnyKRQl1XCDfft319231SzxP6DBA919R1ph+O8+oHaOse3/KYzQUtuyGdf6RJr9+mu
         VNAidjJjyUTgM5wPxshSrKofC06RcbY/llGLpkUDtVild0iHwjlUHmZA7vG0vzJgaQ7z
         Xr8tC/cYfPtcgn18Ca9WbIqnmUWz2HD30+WwhVbfvjLlYGL8/28iwJ/e/uITHoBLCzz8
         /k0w==
X-Forwarded-Encrypted: i=1; AJvYcCVZOw9qFP71RpDL0cpYDd/+Kqi0vAg4FzDlP9Sagl+5gQc8s0EzEPDK9KoeYWc0qn1y+L+4Yl1YQ7HMwOXGwZWAHjvm
X-Gm-Message-State: AOJu0YxDSaur8szZtJ7VsW/YnTx84rle7kqce/jXLDpKY66enHlsPs4L
	VGLKeogrOfb8dcpd4AMSoZEyLtX7uko7G+imIWY8ZkdcIic1iPlYfLXNzc3rGjNTDE/tcn3Grti
	L4A==
X-Google-Smtp-Source: AGHT+IHAW5Cu6uLeC2DeFrvw8mg2Wa8Sr6zlHDRn6IX74FBYp/Cbjsm3VmzOc1NPaMgFbVqucolfGz2nfUI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab33:0:b0:df4:d6ca:fed0 with SMTP id
 3f1490d57ef6-e02be133adfmr219127276.4.1718900202676; Thu, 20 Jun 2024
 09:16:42 -0700 (PDT)
Date: Thu, 20 Jun 2024 09:16:41 -0700
In-Reply-To: <20240619182128.4131355-2-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com> <20240619182128.4131355-2-dapeng1.mi@linux.intel.com>
Message-ID: <ZnRV6XrKkVwZB2TN@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Define KVM_PMC_MAX_GENERIC for platform independence
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Dapeng Mi wrote:
> The existing macro, KVM_INTEL_PMC_MAX_GENERIC, ambiguously represents the
> maximum supported General Purpose (GP) counter number for both Intel and
> AMD platforms. This could lead to issues if AMD begins to support more GP
> counters than Intel.
> 
> To resolve this, a new platform-independent macro, KVM_PMC_MAX_GENERIC,
> is introduced to represent the maximum GP counter number across all x86
> platforms.
> 
> No logic changes are introduced in this patch.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 9 +++++----
>  arch/x86/kvm/svm/pmu.c          | 2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    | 2 ++
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 57440bda4dc4..18137be6504a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -534,11 +534,12 @@ struct kvm_pmc {
>  
>  /* More counters may conflict with other existing Architectural MSRs */
>  #define KVM_INTEL_PMC_MAX_GENERIC	8
> -#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
> -#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
> +#define KVM_AMD_PMC_MAX_GENERIC	6
> +#define KVM_PMC_MAX_GENERIC		KVM_INTEL_PMC_MAX_GENERIC

Since we're changing the macro, maybe take the opportunity to use a better name?
E.g. KVM_MAX_NR_GP_COUNTERS?  And then in a follow-up patch, give fixed counters
the same treatment, e.g. KVM_MAX_NR_FIXED_COUNTERS.  Or maybe KVM_MAX_NR_GP_PMCS
and KVM_MAX_NR_FIXED_PMCS?

> +#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_PMC_MAX_GENERIC - 1)
> +#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_PMC_MAX_GENERIC - 1)

And I'm very, very tempted to say we should simply delete these two, along with
MSR_ARCH_PERFMON_FIXED_CTR_MAX, and just open code the "end" MSR in the one user.
Especially since "KVM" doesn't appear anyone in the name, i.e. because the names
misrepresent KVM's semi-arbitrary max as the *architectural* max.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ad19d913d31..547dfe40d017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7432,17 +7432,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
                     intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2))
                        return;
                break;
-       case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
+       case MSR_ARCH_PERFMON_PERFCTR0 ...
+            MSR_ARCH_PERFMON_PERFCTR0 + KVM_MAX_NR_GP_COUNTERS - 1:
                if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
                    kvm_pmu_cap.num_counters_gp)
                        return;
                break;
-       case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
+       case MSR_ARCH_PERFMON_EVENTSEL0 ...
+            MSR_ARCH_PERFMON_EVENTSEL0 + KVM_MAX_NR_GP_COUNTERS - 1:
                if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
                    kvm_pmu_cap.num_counters_gp)
                        return;
                break;
-       case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+       case MSR_ARCH_PERFMON_FIXED_CTR0 ...
+            MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_MAR_NR_FIXED_COUNTERS - 1:
                if (msr_index - MSR_ARCH_PERFMON_FIXED_CTR0 >=
                    kvm_pmu_cap.num_counters_fixed)
                        return;

>  #define KVM_PMC_MAX_FIXED	3
>  #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
> -#define KVM_AMD_PMC_MAX_GENERIC	6
>  
>  struct kvm_pmu {
>  	u8 version;
> @@ -554,7 +555,7 @@ struct kvm_pmu {
>  	u64 global_status_rsvd;
>  	u64 reserved_bits;
>  	u64 raw_event_mask;
> -	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
> +	struct kvm_pmc gp_counters[KVM_PMC_MAX_GENERIC];
>  	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
>  
>  	/*
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 6e908bdc3310..2fca247798eb 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -218,7 +218,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>  	int i;
>  
>  	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE);
> -	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
> +	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
>  
>  	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
>  		pmu->gp_counters[i].type = KVM_PMC_GP;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index fb5cbd6cbeff..a4b0bee04596 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -570,6 +570,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>  
> +	BUILD_BUG_ON(KVM_INTEL_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);

Rather than BUILD_BUG_ON() for both Intel and AMD, can't we just do?

#define KVM_MAX_NR_GP_COUNTERS max(KVM_INTEL_PMC_MAX_GENERIC, KVM_AMD_PMC_MAX_GENERIC)

> +
>  	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
>  		pmu->gp_counters[i].type = KVM_PMC_GP;
>  		pmu->gp_counters[i].vcpu = vcpu;
> -- 
> 2.34.1
> 

