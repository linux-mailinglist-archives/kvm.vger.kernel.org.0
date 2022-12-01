Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCC063F63E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiLARiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 12:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiLARiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 12:38:05 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10475447F
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 09:38:03 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s196so2274530pgs.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 09:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EyDI41t1NeKE15ENjmdGv+1pPjGUbXbxbMXr/dY47iA=;
        b=dS5VRBwAuYPr2eDyWkXmcS6dfWU1551TdvN6H/39vN031g/pJMkAQ8miNg3B1IyBSl
         8Lti12Uss12uSiroQr+DDwZdih3lE+RCdcFf8RP9oCmPKlLiDuxMhKxp2XVENKFF1SqO
         Z7Q86pw892/xZToSeTV3WxalbYmFkTI/7A5Swt5bPNuGiPaRRpoJtqzMVO4/DEeZ7geW
         pmFM8YX135AaG125EZJqfVoTfii1SZUvxNO7N5ZvmQeZoUBX12neJwlJmRAIbeN53qv0
         jlcAWH6dvVe8OcSAYszPd5fUGziRK8GKJqa/e0uvGoFyoeAV/hY4B0FxMWEbJ+HUK9m6
         MvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyDI41t1NeKE15ENjmdGv+1pPjGUbXbxbMXr/dY47iA=;
        b=7J1QWujRVbm0DhdTvUlNZNI9u9YfF5eour0XM2Muda1eivpQLm4256nvGFrdksD5Fs
         ID5iq4/xJFpEbctkoq5GudYmhQ5LCenjgONq8AP4jmzLbG8oa8Hvf9jvDI9f1qNJw4SX
         7jHRgyJ1zHKl6YZ56+3cL7EDYBBMdOZLpxGGrIbNDiRtwwdWG4NTxgZmcJn60pVlKkys
         E3BybrVOZl8GH0tTpyDQQbcEb7Z/UfujkMYztC7VKFG0SPZrRZdRnFkFyeKyKJkYu+Bj
         jCmY5OgAXMupmc3+xJGxRLA3I3Ro9b68suBN6l4a17YfgWKvhaZRsyBLeg1kYx9tnNDS
         3Nlw==
X-Gm-Message-State: ANoB5pmncPn7nXvIcfEkJIbNShqG8wvpHCtSYwqaYMhji2p3zTMj4y82
        mZFwv9tId9ySCzFvGNISNyXw7w==
X-Google-Smtp-Source: AA0mqf5+KFQTRVp9TNpbIuvLhnybjPwtKZoMzF7hx5olscu9d9AaCTa1ZdwVFHguUG4P/2DdgzIDmA==
X-Received: by 2002:a62:9409:0:b0:572:ccf6:e7c7 with SMTP id m9-20020a629409000000b00572ccf6e7c7mr50260671pfe.74.1669916283262;
        Thu, 01 Dec 2022 09:38:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b0017f74cab9eesm3935349plh.128.2022.12.01.09.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:38:02 -0800 (PST)
Date:   Thu, 1 Dec 2022 17:37:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 2/3] KVM: SEV: Enable DebugSwap
Message-ID: <Y4jmd2mHRVOnoQ0+@google.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-3-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201021948.9259-3-aik@amd.com>
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

On Thu, Dec 01, 2022, Alexey Kardashevskiy wrote:
> AMD Milan introduces support for the swapping, as type 'B',

Please make the changelog standalone, i.e. don't rely on the shortlog to provide
context.  "the swapping" is inscrutable without the shortlog.

> of DR[0-3] and DR[0-3]_ADDR_MASK registers. It requires that
> SEV_FEATURES[5] be set in the VMSA.

Avoid pronouns in shortlogs, changelogs, and comments, as pronouns tend to be
ambiguous.  "Software can enable DebugSwap by setting SEV_FEATURE[5] in the VMSA."
isn't much more effort to type.

> 
> This requires the KVM to eliminate the intercept of #DB. However,

Same here, e.g. does "this" mean that the architecture requires DB interception
to be disabled to enable DebugSwap?

> because of the infinite #DB loop DoS that a malicious guest can do,
> it can only be eliminated based if CPUID Fn80000021_EAX[0]

And "it" here.

> (NoNestedDataBp) is set in the host/HV.
> 
> This eliminates #DB intercept, DR7 intercept for SEV-ES/SEV-SNP guest.
> This saves DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN.
> This sets SEV_FEATURES[5] in VMSA.

And all of these "this".  Assuming "this" means "this patch", rewrite these
sentences to be commands that state what changes are being done.

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/svm.h     | 18 +++++++++++-----
>  arch/x86/kvm/svm/sev.c     | 22 +++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c     |  6 ++++--
>  4 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 0361626841bc..373a0edda588 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -273,6 +273,7 @@ enum avic_ipi_failure_cause {
>  #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>  #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>  
> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>  
>  struct vmcb_seg {
>  	u16 selector;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 199a2ecef1ce..4d75b14bffab 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -83,6 +83,7 @@ enum {
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> +	bool debug_swap;        /* SEV-ES Debug swap enabled */
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> @@ -388,6 +389,7 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
>  
>  static inline void set_dr_intercepts(struct vcpu_svm *svm)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  
>  	if (!sev_es_guest(svm->vcpu.kvm)) {
> @@ -407,20 +409,26 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>  	}
>  
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	if (!sev->debug_swap) {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	}
>  
>  	recalc_intercepts(svm);
>  }
>  
>  static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  
>  	vmcb->control.intercepts[INTERCEPT_DR] = 0;
>  
> -	/* DR7 access must remain intercepted for an SEV-ES guest */
> -	if (sev_es_guest(svm->vcpu.kvm)) {
> +	/*
> +	 * DR7 access must remain intercepted for an SEV-ES guest unless
> +	 * the DebugSwap feature is set

Please explain _why_.  

> +	 */
> +	if (sev_es_guest(svm->vcpu.kvm) && !sev->debug_swap) {
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>  	}
> @@ -677,7 +685,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>  void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
> +void sev_es_prepare_switch_to_guest(struct kvm_vcpu *vcpu, struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>  
>  /* vmenter.S */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index efaaef2b7ae1..fac8b48e3162 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -21,6 +21,7 @@
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
> +#include <asm/debugreg.h>
>  
>  #include "mmu.h"
>  #include "x86.h"
> @@ -253,6 +254,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (asid < 0)
>  		goto e_no_asid;
>  	sev->asid = asid;
> +	sev->debug_swap = sev->es_active && 

Enabling DebugSwap should be guarded with a module param so that the admin can
disable the feature if necessary.  And then the per-vCPU variable goes away.

> kvm_cpu_cap_get(KVM_X86_FEATURE_NO_NESTED_DATA_BP);

kvm_cpu_cap_has().

And use X86_FEATURE_* directly, which is the whole point of the __feature_translate()
shenanigans.

>  
>  	ret = sev_platform_init(&argp->error);
>  	if (ret)
> @@ -564,6 +566,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
>  	struct sev_es_save_area *save = svm->sev_es.vmsa;
> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>  
>  	/* Check some debug related fields before encrypting the VMSA */
>  	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
> @@ -604,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  	save->dr6  = svm->vcpu.arch.dr6;
>  
> +	if (sev->debug_swap)
> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;

Resurrecting my objection to "AP Creation NAE event"[*], what happens if a hypervisor
supports GHCB_HV_FT_SNP_AP_CREATION but not DebugSwap?  IIUC, a guest can corrupt
host DRs by enabling DebugSwap in the VMSA of an AP vCPU, e.g. the CPU will load
zeros on VM-Exit if the host hasn't stuffed the host save area fields.

KVM can obviously just make sure to save its DRs if hardware supports DebugSwap,
but what if DebugSwap is buggy and needs to be disabled?  And what about the next
feature that can apparently be enabled by the guest?

[*] https://lore.kernel.org/all/YWnbfCet84Vup6q9@google.com
