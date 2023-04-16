Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513036E358C
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 09:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjDPHFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 03:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDPHFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 03:05:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E405F1FDA;
        Sun, 16 Apr 2023 00:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681628705; x=1713164705;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zWZIdsrMzAkxPqS7a3CB6Ru6apWW6QOJgGEj72lyw84=;
  b=HRdl+8vlLpMzDx8xP9mMl70YJIs1pRzDpd+ycWBSjJ5sPjmnGazlQ1Dg
   uPrT6DMJIH/kmON1+C+MbuUGqVicFMM8jwUPaFjt5RmFQ/cnbaHXWqvW7
   X3VfNW74jndFKOXVxNXMpJBOSDkfp4u7XNoO6X5Xj+I/Ffs51Br7zReZ+
   5pDo2ppZSiwXxmlSNM+ymzMHhcIDuxnYcaikB3Tkzy2BY5DKH2yHVUa4U
   7actpVmOvpczy78bJ7Aw8MD+7dxPsvcNGxfXPCgC08GCbsxLqwJP0bRNk
   Ha4QxrzY+5GG6kP0iy0mIh7bQbfHEUR5reX5ujwGW93SAhehCD4KqRiic
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="333499973"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="333499973"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 00:05:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="779703199"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="779703199"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.212.226]) ([10.254.212.226])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 00:05:01 -0700
Message-ID: <2ff6d934-bd9c-227b-9693-911a85145da7@linux.intel.com>
Date:   Sun, 16 Apr 2023 15:04:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230414062545.270178-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
>
> Add a kvm-only CPUID feature leaf for CPUID.7.2.EDX and RRSBA_CTRL
> as the first feature in the leaf.
>
> RRSBA_CTRL is enumerated by CPUID.7.2.EDX[2]. If supported, RRSBA_DIS_U
> (bit 5) and RRSBA_DIS_S (bit 6) of IA32_SPEC_CTRL MSR can be used to
> disable RRSBA behavior for CPL3 and CPL0/1/2 respectively.
>
> Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
> after a non-zero is written to the MSR. Therefore, guests can already
> toggle the two bits if the host supports RRSBA_CTRL, and no extra code
> is needed to allow guests to toggle the two bits.
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/kvm/cpuid.c         | 22 +++++++++++++++++++---
>   arch/x86/kvm/reverse_cpuid.h |  7 +++++++
>   2 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9583a110cf5f..f024c3ac2203 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -685,6 +685,10 @@ void kvm_set_cpu_caps(void)
>   		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>   	);
>   
> +	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
> +		SF(RRSBA_CTRL)
> +	);
> +

Is it slightly better to put the new added one after

     kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX, ...

to make it in order?


>   	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
>   		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
>   		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> @@ -949,13 +953,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		break;
>   	/* function 7 has additional index. */
>   	case 7:
> -		entry->eax = min(entry->eax, 1u);
> +		entry->eax = min(entry->eax, 2u);
>   		cpuid_entry_override(entry, CPUID_7_0_EBX);
>   		cpuid_entry_override(entry, CPUID_7_ECX);
>   		cpuid_entry_override(entry, CPUID_7_EDX);
>   
> -		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
> -		if (entry->eax == 1) {
> +		max_idx = entry->eax;
> +
> +		if (max_idx >= 1) {
>   			entry = do_host_cpuid(array, function, 1);
>   			if (!entry)
>   				goto out;
> @@ -965,6 +970,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->ebx = 0;
>   			entry->ecx = 0;
>   		}
> +
> +		if (max_idx >= 2) {
> +			entry = do_host_cpuid(array, function, 2);
> +			if (!entry)
> +				goto out;
> +
> +			cpuid_entry_override(entry, CPUID_7_2_EDX);
> +			entry->eax = 0;
> +			entry->ebx = 0;
> +			entry->ecx = 0;
> +		}
>   		break;
>   	case 0xa: { /* Architectural Performance Monitoring */
>   		union cpuid10_eax eax;
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a5717282bb9c..72bad8314a9c 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
>   	CPUID_12_EAX	 = NCAPINTS,
>   	CPUID_7_1_EDX,
>   	CPUID_8000_0007_EDX,
> +	CPUID_7_2_EDX,
>   	NR_KVM_CPU_CAPS,
>   
>   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
>   /* CPUID level 0x80000007 (EDX). */
>   #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
>   
> +/* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
> +#define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
> +
>   struct cpuid_reg {
>   	u32 function;
>   	u32 index;
> @@ -69,6 +73,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>   	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
>   	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>   	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
> +	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
>   	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
>   	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
>   	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
> @@ -108,6 +113,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
>   		return KVM_X86_FEATURE_SGX_EDECCSSA;
>   	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
>   		return KVM_X86_FEATURE_CONSTANT_TSC;
> +	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
> +		return KVM_X86_FEATURE_RRSBA_CTRL;
>   
>   	return x86_feature;
>   }
