Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A052B008
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 03:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiERBmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 21:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiERBmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 21:42:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9D85402E
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 18:42:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so2945235pjb.1
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 18:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6IbrZNf7jtW60Nrdztn2g8OCQmqlbxKofa0AB+lB5iw=;
        b=r02X7VM/XjJFy+/Ecy7q/RvNSrxIQKNulQrRs+z1nSV9l08hB6NHRBrBo7Agqc1YSz
         ImsrTajN4r4joSRdEKoIWQjebdXQ/IWVlHueB3QmRKjvjbZR+r3gnSYJ8Yr7vbWpfYOk
         xDCUt2Sbmi/ETtp/hNdGIF29/dvpSqPZqt2rFoIXn5FYa/OD+sBI60PVw++iZ9KpMt4r
         eYEil0cDwTgYMVZqnFx9PZLhPB9wrRPKR0sbUCZJQg6uFW9EAEEXIFUT1J5MqNNlkr7k
         Kb0zfQEg+P1tCjl7gpigoC92wj+OtTnccjA08QjLeaAzq8S6fSrfVO1xhzRCoG+747+o
         Z2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6IbrZNf7jtW60Nrdztn2g8OCQmqlbxKofa0AB+lB5iw=;
        b=4013rG5PDromzgBDt3T1OUM/G4CrzLzw4B1+ke6aSlWriq1weC7XAOUAO86l/mDUVU
         omUT6N+8w768hpuHDeGGy2fxfLyjnZHGShu1GvHnhkMdEuj98LWI0+PssRekRM8mkeOD
         29HEFVdfnb3UyZQSvrB/dGg83aRNq0kptN8DGDXDXXrzn89ZFGFmI558DfJq3Ko8x+rO
         s50pmpFFeVlx40Wef3GaWQ4y8qcND31g2mDQGbKF9xebffXzm5BxhyF5OUQGTwh5Kq7P
         pSv13kHu5Qrl1nG458FN+mSPd0Ok2KiQeolCn9eqh+Z12TxeZXoSCqql2kIV7eDtSy0s
         4LHg==
X-Gm-Message-State: AOAM532cdxwZQM+QurQXzjwwQuAfZPO20JqUWOJA6EW7eGKEcYWgYkiO
        TcO6Rf9NciHktiwMvBY6LWh/mQ==
X-Google-Smtp-Source: ABdhPJxd+CRJIEzDvmDRGSr6j4b03U5qwpeOar3AelIBlKDP/ruyeK7TKPT66WYlKJQ5TuVXhmK7Xg==
X-Received: by 2002:a17:90a:a410:b0:1dc:d03b:5623 with SMTP id y16-20020a17090aa41000b001dcd03b5623mr28288258pjp.95.1652838162215;
        Tue, 17 May 2022 18:42:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v13-20020a056a00148d00b0050dc76281c8sm387208pfu.162.2022.05.17.18.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 18:42:41 -0700 (PDT)
Date:   Wed, 18 May 2022 01:42:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Message-ID: <YoRPDp/3jfDUE529@google.com>
References: <20220512174427.3608-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512174427.3608-1-jon@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022, Jon Kohler wrote:
> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
> the MSR bitmap.
> 
> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
> once or twice per vCPU on boot, so it is far better to take those
> VM exits on boot than having to read and save this msr on every
> single VM exit forever. This outcome was suggested on Andrea's commit
> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
> however, since interception is still unilaterally disabled, the rdmsr
> tax is still there even after that commit.
> 
> This is a significant win for eIBRS enabled systems as this rdmsr
> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
> by perf top disassembly, and is in the critical path for all
> VM-Exits, including fastpath exits.
> 
> Update relevant comments in vmx_vcpu_run() with appropriate SDM
> references for future onlookers.
> 
> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 46 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d58b763df855..d9da6fcecd8c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2056,6 +2056,25 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (kvm_spec_ctrl_test_value(data))
>  			return 1;
> 
> +		/*
> +		 * For Intel eIBRS, IBRS (SPEC_CTRL_IBRS aka 0x00000048 BIT(0))
> +		 * only needs to be set once and can be left on forever without
> +		 * needing to be constantly toggled. If the guest attempts to
> +		 * write that value, let's not disable interception. Guests
> +		 * with eIBRS awareness should only be writing SPEC_CTRL_IBRS
> +		 * once per vCPU per boot.
> +		 *
> +		 * The guest can still use other SPEC_CTRL features on top of
> +		 * eIBRS such as SSBD, and we should disable interception for

Please don't add comments that say "should" or "need", just state what is being
done.  Just because a comment says XYZ should do something doesn't necessarily
mean that XYZ actually does that thing.

> +		 * those situations to avoid a multitude of VM-Exits's;
> +		 * however, we will need to check SPEC_CTRL on each exit to
> +		 * make sure we restore the host value properly.
> +		 */

This whole comment can be more succint.  Better yet, merge it with the comment
below (out of sight in this diff) and opportunistically update that comment to
reflect what actually happens if L2 is the first to write a non-zero value (arguably
a bug that should be fixed, but meh).  The IBPB MSR has the same flaw.  :-/

> +		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) && data == BIT(0)) {

Use SPEC_CTRL_IBRS instead of open coding "BIT(0)", then a chunk of the comment
goes away.

> +			vmx->spec_ctrl = data;
> +			break;
> +		}

There's no need for a separate if statement.  And the boot_cpu_has() check can
be dropped, kvm_spec_ctrl_test_value() has already verified the bit is writable
(unless you're worried about bit 0 being used for something else?)

> +
>  		vmx->spec_ctrl = data;
>  		if (!data)
>  			break;
> @@ -6887,19 +6906,22 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vmx_vcpu_enter_exit(vcpu, vmx);
> 
>  	/*
> -	 * We do not use IBRS in the kernel. If this vCPU has used the
> -	 * SPEC_CTRL MSR it may have left it on; save the value and
> -	 * turn it off. This is much more efficient than blindly adding
> -	 * it to the atomic save/restore list. Especially as the former
> -	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
> -	 *
> -	 * For non-nested case:
> -	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
> -	 * save it.
> +	 * SDM 25.1.3 - handle conditional exit for MSR_IA32_SPEC_CTRL.
> +	 * To prevent constant VM exits for SPEC_CTRL, kernel may

Please wrap at 80 chars (ignore the bad examples in KVM).

> +	 * disable interception in the MSR bitmap for SPEC_CTRL MSR,
> +	 * such that the guest can read and write to that MSR without
> +	 * trapping to KVM; however, the guest may set a different
> +	 * value than the host. For exit handling, do rdmsr below if
> +	 * interception is disabled, such that we can save the guest
> +	 * value for restore on VM entry, as it does not get saved
> +	 * automatically per SDM 27.3.1.
>  	 *
> -	 * For nested case:
> -	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> -	 * save it.
> +	 * This behavior is optimized on eIBRS enabled systems, such
> +	 * that the kernel only disables interception for MSR_IA32_SPEC_CTRL
> +	 * when guests choose to use additional SPEC_CTRL features
> +	 * above and beyond IBRS, such as STIBP or SSBD. This
> +	 * optimization allows the kernel to avoid doing the expensive
> +	 * rdmsr below.

I don't see any reason to restate why the MSR may or may not be intercepted, just
explain when the value needs to be read.

E.g. something like this for the whole patch?

---
 arch/x86/kvm/vmx/vmx.c | 60 +++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..70d863a7882d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2057,20 +2057,30 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;

 		vmx->spec_ctrl = data;
-		if (!data)
+
+		/*
+		 * Disable interception on the first non-zero write, unless the
+		 * guest is setting only SPEC_CTRL_IBRS, which is typically set
+		 * once at boot and never touched again.  All other bits are
+		 * often set on a per-task basis, i.e. may change frequently,
+		 * so the benefit of avoiding VM-exits during guest context
+		 * switches outweighs the cost of RDMSR on every VM-Exit to
+		 * save the guest's value.
+		 */
+		if (!data || data == SPEC_CTRL_IBRS)
 			break;

 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging. We update the vmcs01 here for L1 as well
-		 * since it will end up touching the MSR anyway now.
+		 * Update vmcs01.msr_bitmap even if L2 is active, i.e. disable
+		 * interception for the vCPU on the first write regardless of
+		 * whether the WRMSR came from L1 or L2.  vmcs02's bitmap is a
+		 * combination of vmcs01 and vmcs12 bitmaps, and will be
+		 * recomputed by nested_vmx_prepare_msr_bitmap() on the next
+		 * nested VM-Enter.  Note, this does mean that future WRMSRs
+		 * from L2 will be intercepted until the next nested VM-Exit if
+		 * L2 was the first to write, but L1 exposing the MSR to L2
+		 * without first writing it is unlikely and not worth the
+		 * extra bit of complexity.
 		 */
 		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
@@ -2098,15 +2108,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);

 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging.
+		 * Disable interception on the first IBPB, odds are good IBPB
+		 * will be a frequent guest action.  See the comment for
+		 * MSR_IA32_SPEC_CTRL for details on the nested interaction.
 		 */
 		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
@@ -6887,19 +6891,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_vcpu_enter_exit(vcpu, vmx);

 	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
+	 * Save SPEC_CTRL if it may have been written by the guest, the current
+	 * value in hardware is used by x86_spec_ctrl_restore_host() to avoid
+	 * WRMSR if the current value matches the host's desired value.
 	 */
 	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

base-commit: 69b59889b0147aa80098936e383b06fec30cdf5c
--

