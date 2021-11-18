Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8687D455CA6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKRN26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:28:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbhKRN25 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637241957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kb1ScM+tPjpaRtxM4KUni8Ao9s67vbqfcmBg158Ebpk=;
        b=jNZ/PPsIa2qLfrI8PyvbRUPjFnb9br7oWksxoO7GxKMlpM2YqAOZ9CMhRDw8mJxiCO2xV5
        q8WH3oesIf0E+oEVyv7yniAJHPRLtOboOYB+ZjVzvfr0f7ueVX7Da8hHKCe5oQEH9igMUJ
        kNx37tCDizs2LlY0q77qHPNN9VRBnLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-urWffV7eM2mCNtKSCJvgSA-1; Thu, 18 Nov 2021 08:25:55 -0500
X-MC-Unique: urWffV7eM2mCNtKSCJvgSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB30018D6A36;
        Thu, 18 Nov 2021 13:25:53 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A6C1B5C2;
        Thu, 18 Nov 2021 13:25:33 +0000 (UTC)
Message-ID: <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
Date:   Thu, 18 Nov 2021 14:25:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211117080304.38989-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211117080304.38989-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 09:03, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> For Intel, the guest PMU can be disabled via clearing the PMU CPUID.
> For AMD, all hw implementations support the base set of four
> performance counters, with current mainstream hardware indicating
> the presence of two additional counters via X86_FEATURE_PERFCTR_CORE.
> 
> In the virtualized world, the AMD guest driver may detect
> the presence of at least one counter MSR. Most hypervisor
> vendors would introduce a module param (like lbrv for svm)
> to disable PMU for all guests.
> 
> Another control proposal per-VM is to pass PMU disable information
> via MSR_IA32_PERF_CAPABILITIES or one bit in CPUID Fn4000_00[FF:00].
> Both of methods require some guest-side changes, so a module
> parameter may not be sufficiently granular, but practical enough.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/cpuid.c   |  2 +-
>   arch/x86/kvm/svm/pmu.c |  4 ++++
>   arch/x86/kvm/svm/svm.c | 11 +++++++++++
>   arch/x86/kvm/svm/svm.h |  1 +
>   4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2d70edb0f323..647af2a184ad 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -487,7 +487,7 @@ void kvm_set_cpu_caps(void)
>   		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
>   		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
>   		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
> -		F(TOPOEXT) | F(PERFCTR_CORE)
> +		F(TOPOEXT) | 0 /* PERFCTR_CORE */
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index fdf587f19c5f..a0bcf0144664 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -16,6 +16,7 @@
>   #include "cpuid.h"
>   #include "lapic.h"
>   #include "pmu.h"
> +#include "svm.h"
>   
>   enum pmu_type {
>   	PMU_TYPE_COUNTER = 0,
> @@ -100,6 +101,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   {
>   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>   
> +	if (!pmuv)
> +		return NULL;
> +
>   	switch (msr) {
>   	case MSR_F15H_PERF_CTL0:
>   	case MSR_F15H_PERF_CTL1:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 21bb81710e0f..062e48c191ee 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -190,6 +190,10 @@ module_param(vgif, int, 0444);
>   static int lbrv = true;
>   module_param(lbrv, int, 0444);
>   
> +/* enable/disable PMU virtualization */
> +bool pmuv = true;
> +module_param(pmuv, bool, 0444);
> +
>   static int tsc_scaling = true;
>   module_param(tsc_scaling, int, 0444);
>   
> @@ -952,6 +956,10 @@ static __init void svm_set_cpu_caps(void)
>   	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>   		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>   
> +	/* AMD PMU PERFCTR_CORE CPUID */
> +	if (pmuv && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> +		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
> +
>   	/* CPUID 0x8000001F (SME/SEV features) */
>   	sev_set_cpu_caps();
>   }
> @@ -1085,6 +1093,9 @@ static __init int svm_hardware_setup(void)
>   			pr_info("LBR virtualization supported\n");
>   	}
>   
> +	if (!pmuv)
> +		pr_info("PMU virtualization is disabled\n");
> +
>   	svm_set_cpu_caps();
>   
>   	/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0d7bbe548ac3..08e1c19ffbdf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -32,6 +32,7 @@
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;
>   extern bool intercept_smi;
> +extern bool pmuv;
>   
>   /*
>    * Clean bits in VMCB.
> 

Queued, thanks - just changed the parameter name to "pmu".

Paolo

