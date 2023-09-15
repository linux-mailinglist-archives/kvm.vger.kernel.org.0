Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F697A2140
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbjIOOn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbjIOOn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:43:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD66268A
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:43:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7e8bb74b59so2707217276.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694789031; x=1695393831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KkUfDhNJAI86/Otlne38jn0NUzsEUgWomiFoPN+PaeU=;
        b=l1qYp5ebppwr1XzVvSWrmCWLxA7F3/04Fa2BMdorvA+qOue0brQ5DmlJu+ngysyhQU
         bp2wnFR+hkkZ9dlVW/IGjWdl09GrNWRWaeBpkAJ5kDVmab2qO3CaWZEnm4zOjT04Fo+P
         dhtldavaZav0YzqqERtXhbtOJbxEjPaV49lU/vSJoyLmhsttrFRcv2hFfeoDB1OzsI8u
         p4u0TzYI94jT4tGSYrBnF2TBOlUDuPs1T5T09Dc7torEdv5aIRgym+9AN3+JvckVyIPy
         2OpYWemMIISgisg1Og+G8axwsByHNmr/Kemq/uIfaM/vQZSGNRyDJG7epiU+EHAq8I/U
         lR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694789031; x=1695393831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkUfDhNJAI86/Otlne38jn0NUzsEUgWomiFoPN+PaeU=;
        b=rXT88pCpB6tERuqlob+UH0QYDWKjq5IsA4WnLVUyUvNBdZ306/oJOeETGzi40bVnwu
         RZZM4np70iVQ86BzQsm8OoUWZBmoI7Z63NhzcDS7F5Wkps4PbXE6M91iTYIKNMr32vHm
         AZ2Hirjo1fJwNWg0iajZnZEYDOnUQ2B+AfuyDLSsRWfBhXndvHZM2WI1q/UBW2YrPBf8
         N3q49dxTNY5lVWm9Bzf+wQiWZFBKOtyc6BhdQhSquwz68FNMCiQEOaCEvneEOrh2ky8B
         p4S7Hw6LSBVbuHwyZ7UUN+ZxaF6CokTsiFiDpgnkx2kkjm+MDwY5NgP5frA/DezqxdpW
         Wqxg==
X-Gm-Message-State: AOJu0Yy0xEaytyugxMvpghVLwXy5HsvFaZKHmQPKNY5XRWKkrq9uAZYU
        W9Q78bIYBrP5KHHR1ER9aQvBsj7W2Jo=
X-Google-Smtp-Source: AGHT+IEqdcQ6Sl9wcsNkUPdDK7XuqBNzjunc7R5ApBQwf/haIvzrfE+xHjI8bhuXxEFU/Ilh2dDXptA3oGQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abab:0:b0:d35:bf85:5aa0 with SMTP id
 v40-20020a25abab000000b00d35bf855aa0mr40383ybi.4.1694789031305; Fri, 15 Sep
 2023 07:43:51 -0700 (PDT)
Date:   Fri, 15 Sep 2023 07:43:49 -0700
In-Reply-To: <025fd734d35acbbbbca74c4b3ed671a02d4af628.1694721045.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
References: <cover.1694721045.git.thomas.lendacky@amd.com> <025fd734d35acbbbbca74c4b3ed671a02d4af628.1694721045.git.thomas.lendacky@amd.com>
Message-ID: <ZQRtpVjXTwjeJ5rI@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Do not use user return MSR support for
 virtualized TSC_AUX
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023, Tom Lendacky wrote:
> When the TSC_AUX MSR is virtualized, the TSC_AUX value is swap type "B"
> within the VMSA. This means that the guest value is loaded on VMRUN and
> the host value is restored from the host save area on #VMEXIT.
> 
> Since the value is restored on #VMEXIT, the KVM user return MSR support
> for TSC_AUX can be replaced by populating the host save area with current
> host value of TSC_AUX. This replaces two WRMSR instructions with a single
> RDMSR instruction.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
>  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++----------
>  arch/x86/kvm/svm/svm.h |  4 +++-
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 565c9de87c6d..1bbaae2fed96 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2969,6 +2969,7 @@ static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
>  	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
>  	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
>  	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
> +		svm->v_tsc_aux = true;
>  		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
>  		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> @@ -3071,8 +3072,10 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  					    sev_enc_bit));
>  }
>  
> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>  {
> +	u32 msr_hi;
> +
>  	/*
>  	 * All host state for SEV-ES guests is categorized into three swap types
>  	 * based on how it is handled by hardware during a world switch:
> @@ -3109,6 +3112,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>  		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
>  		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
>  	}
> +
> +	/*
> +	 * If TSC_AUX virtualization is enabled, MSR_TSC_AUX is loaded but NOT
> +	 * saved by the CPU (Type-B). If TSC_AUX is not virtualized, the user
> +	 * return MSR support takes care of restoring MSR_TSC_AUX. This
> +	 * exchanges two WRMSRs for one RDMSR.
> +	 */
> +	if (svm->v_tsc_aux)
> +		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);

IIUC, when V_TSC_AUX is supported, SEV-ES guests context switch MSR_TSC_AUX
regardless of what has been exposed to the guest.  So rather than condition the
hostsa->tsc_aux update on guest CPUID, just do it if V_TSC_AUX is supported.

And then to avoid the RDMSR, which is presumably the motivation for checking
guest CPUID, grab the host value from user return framework.  The host values
are per-CPU, but constant after boot, so the only requirement is that KVM sets
up MSR_TSC_AUX in the user return framework.

>  }
>  
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c58d5632e74a..905b1a2664ed 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1529,13 +1529,13 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  		struct sev_es_save_area *hostsa;
>  		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
>  
> -		sev_es_prepare_switch_to_guest(hostsa);
> +		sev_es_prepare_switch_to_guest(svm, hostsa);
>  	}
>  
>  	if (tsc_scaling)
>  		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
>  
> -	if (likely(tsc_aux_uret_slot >= 0))
> +	if (likely(tsc_aux_uret_slot >= 0) && !svm->v_tsc_aux)

And then this too becomes something like

	if (likely(tsc_aux_uret_slot >= 0) &&
	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))

>  		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
>  
>  	svm->guest_state_loaded = true;
> @@ -3090,15 +3090,21 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		break;
>  	case MSR_TSC_AUX:

And this also is simply:

		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
			break;

Because svm->tsc_aux will never be consumed.

>  		/*
> -		 * TSC_AUX is usually changed only during boot and never read
> -		 * directly.  Intercept TSC_AUX instead of exposing it to the
> -		 * guest via direct_access_msrs, and switch it via user return.
> +		 * If TSC_AUX is being virtualized, do not use the user return
> +		 * MSR support because TSC_AUX is restored on #VMEXIT.
>  		 */
> -		preempt_disable();
> -		ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
> -		preempt_enable();
> -		if (ret)
> -			break;
> +		if (!svm->v_tsc_aux) {
> +			/*
> +			 * TSC_AUX is usually changed only during boot and never read
> +			 * directly.  Intercept TSC_AUX instead of exposing it to the
> +			 * guest via direct_access_msrs, and switch it via user return.
> +			 */
> +			preempt_disable();
> +			ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
> +			preempt_enable();
> +			if (ret)
> +				break;
> +		}
>  
>  		svm->tsc_aux = data;
>  		break;
