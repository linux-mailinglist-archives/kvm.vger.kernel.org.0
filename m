Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4021685D49
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjBACSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjBACSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:18:33 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A733183
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:18:31 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so546484pjb.5
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m7F6dehY1ZAa/JvNBrfumO5G0pYEVgwjvMhShEC5FE0=;
        b=dHT8U5KoAWCFH+obpke8gpQgH73dfYBLMQM9EN5CSmTQIavzz/ruuiu9D8wjBOxc48
         h9o236NdLUsP2x3PGTF0m4aQHaJxcN7psUsAUgpDwIz0vYWjV1Ptl9xMNpmnQ5LUn+zN
         OI77faNtkpdQ1lc2wv7D6V4I81g9DLwEhOwYbVquON/TtgjntC0y3Ycp7Z6XwrOT69gx
         I5GTAH1mfJPVI8EcUVY1Xkuw96bBzEt7T+2cqZmzOGLiZX3olQSrG4+EMRxeq6cNyGle
         vVp03vxcKVFoilCHkdErYfaiC0rxDFDqQ20FTi2ErBtwAiK1+zjLkwnSx1T4i1GKbEQk
         bQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7F6dehY1ZAa/JvNBrfumO5G0pYEVgwjvMhShEC5FE0=;
        b=AFz6igxKnC7oWu9dDxcCo8LTAAWYX2QhjEIxrya67ckXN+a//4wBNqpfdfg/JBhRhj
         dRISPaZaF2LmRBP8WCSfkyDtiilg4JXO4sPAwC3+jVuDTN+baGKjUNxdlb4n8Yq5PIZF
         DzE3zxdMy/6JMBKttwiqAzZEEUONisE+1A43Fz9hmfpcgV5RdTWYI4/1/+9hpIbQlJ4d
         Z/oLZeBTQQLj3ejU0Bj7ZeSpInCsxjkI8vPyQa5DZRI5v4i0qmO+nhIK5y+3uso1QMZf
         9oJhFKcvCr/LW8iHEKxjmBdzCp+hc3PKbN1aTlPVd1X7Wqrr2ipJZQpsq9dkHAhOjnqR
         Vw6w==
X-Gm-Message-State: AO0yUKVxStZFdkdVzkRZlDV7g1QulQaGuT/43LvfbZTdtuuU4Cl3OEuy
        IVcuSIYCwGYjXSrg7Quh06ib1A==
X-Google-Smtp-Source: AK7set84davAhMFRG8FdOvMlp+RdgR6i0Zfp2hV/g/BET4JiRhktWDPA0jNwcvFVunjbbwGrKpjyGg==
X-Received: by 2002:a05:6a20:c1aa:b0:b8:e33c:f160 with SMTP id bg42-20020a056a20c1aa00b000b8e33cf160mr272920pzb.0.1675217910739;
        Tue, 31 Jan 2023 18:18:30 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o125-20020a62cd83000000b00575fbe1cf2esm10113196pfg.109.2023.01.31.18.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 18:18:30 -0800 (PST)
Date:   Wed, 1 Feb 2023 02:18:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Message-ID: <Y9nL8iqhiL5+ALa2@google.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230120031047.628097-3-aik@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023, Alexey Kardashevskiy wrote:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4826e6cc611b..61f2cad1cbaf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -389,6 +389,8 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
>  	return test_bit(bit, (unsigned long *)&control->intercepts);
>  }
>  
> +extern bool sev_es_is_debug_swap_enabled(void);
> +
>  static inline void set_dr_intercepts(struct vcpu_svm *svm)
>  {
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -410,8 +412,10 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>  	}
>  
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	if (!sev_es_guest(svm->vcpu.kvm) || !sev_es_is_debug_swap_enabled()) {

Looking below, doesn't this do the wrong thing if set_dr_intercepts() is called
before SVM_SEV_FEAT_DEBUG_SWAP is set?  I.e. when this is called before LAUNCH_UPDATE?
Seems like this should check SVM_SEV_FEAT_DEBUG_SWAP in sev_features regardless
of when SVM_SEV_FEAT_DEBUG_SWAP is set.

And if KVM checks sev_features, then I _think_ we can avoid having to expose
sev_es_debug_swap_enabled to svm.{c,h} (though why on earth {set,clr}_dr_intercepts()
is in svm.h is another question for the future).

Follow-up question: does KVM _have_ to wait until KVM_SEV_LAUNCH_UPDATE_VMSA to
set the flag?

> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	}
>  
>  	recalc_intercepts(svm);
>  }
> @@ -422,8 +426,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>  
>  	vmcb->control.intercepts[INTERCEPT_DR] = 0;
>  
> -	/* DR7 access must remain intercepted for an SEV-ES guest */
> -	if (sev_es_guest(svm->vcpu.kvm)) {
> +	/*
> +	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
> +	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
> +	 * from the #DB handler may trigger infinite loop of #DB's.
> +	 */
> +	if (sev_es_guest(svm->vcpu.kvm) && !sev_es_is_debug_swap_enabled()) {
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>  	}
>
> @@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled = true;
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-ES DebugSwap support */
> +static bool sev_es_debug_swap_enabled = true;
> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);

Module param needs 0444 permissions, i.e. shouldn't be writable after KVM is
loaded.  Though I don't know that providing a module param is warranted in this
case.  KVM provides module params for SEV and SEV-ES because there are legitimate
reasons to turn them off, but at a glance, I don't see why we'd want that for this
feature.

>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
> +#define sev_es_debug_swap false

This needs to be sev_es_debug_swap_enabled, otherwise things fall apart with
CONFIG_KVM_AMD_SEV=n.

arch/x86/kvm/svm/sev.c: In function ‘sev_es_is_debug_swap_enabled’:
arch/x86/kvm/svm/sev.c:69:16: error: ‘sev_es_debug_swap_enabled’ undeclared (first use in this function); did you mean ‘sev_es_is_debug_swap_enabled’?
   69 |         return sev_es_debug_swap_enabled;
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~
      |                sev_es_is_debug_swap_enabled


>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +bool sev_es_is_debug_swap_enabled(void)
> +{
> +	return sev_es_debug_swap_enabled;
> +}

...

> @@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  	save->dr6  = svm->vcpu.arch.dr6;
>  
> +	if (sev_es_is_debug_swap_enabled())
> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
>  	pr_debug("Virtual Machine Save Area (VMSA):\n");
>  	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>  
> @@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
>  out:
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> +	if (sev_es_debug_swap_enabled)
> +		sev_es_debug_swap_enabled = sev_es_enabled &&
> +			cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP);

Slight preference for:

	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
		sev_es_debug_swap_enabled = false;

KVM does short-circuit some checks on module param values, but usually only to
avoid additional setup.

>  #endif
>  }
>  
> @@ -3027,6 +3044,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>  
>  	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>  	hostsa->xss = host_xss;
> +
> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
> +	if (sev_es_is_debug_swap_enabled()) {
> +		hostsa->dr0 = native_get_debugreg(0);
> +		hostsa->dr1 = native_get_debugreg(1);
> +		hostsa->dr2 = native_get_debugreg(2);
> +		hostsa->dr3 = native_get_debugreg(3);
> +		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
> +		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
> +		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
> +		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
> +	}
>  }
>  
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 60c7c880266b..6c54a3c9d442 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1190,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	set_exception_intercept(svm, UD_VECTOR);
>  	set_exception_intercept(svm, MC_VECTOR);
>  	set_exception_intercept(svm, AC_VECTOR);
> -	set_exception_intercept(svm, DB_VECTOR);
> +	if (!sev_es_is_debug_swap_enabled())
> +		set_exception_intercept(svm, DB_VECTOR);

This is wrong.  KVM needs to intercept #DBs when debugging non-SEV-ES VMs.
This _could_ be tied to X86_FEATURE_NO_NESTED_DATA_BP, but the KVM would need to
toggle the intercept depending on whether or not userspace wants to debug the
guest.

Similar to the DR7 interception, can this check sev_features directly?
