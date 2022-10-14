Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7B45FF4F8
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJNVE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJNVEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:04:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126F1DC817
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:04:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i3so5978455pfk.9
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ci/sgzHgR3d0PFeCOGERzmh/pNEGWCM51oway6gP1ic=;
        b=bZosADocQdRBlEJI0ayUUpAZrXnpGu+7TB3h17CyYBp8w9gT1qkmP2u1x9Xq56T1mM
         TvzKTXQzKIpBV7rtIrHeCsh1OVMKkUBmbkijlDiJ2GGWxqTUeT/YwfgkDRP2oeEYHRjJ
         Kpm+/b/KjP7JJfS+JqI8y/7mzT0iRshxu3DSlIc2U22Bl7bVlCxVyJQj9bAwuXELCIkd
         698nI2jh1mT+HerTc/h91+7J4N/z5MNIP5BBFOZ6T6z5ZxzVuC7+v7ez4ouXtkzut4oX
         XdQ9FFF34op+c+qhQlaC2ypn6YrhKoIRVT9nO/VpoJcbk8w7Zp4D5BOA236o5VR59RGM
         KG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ci/sgzHgR3d0PFeCOGERzmh/pNEGWCM51oway6gP1ic=;
        b=VrCQu7hKiGvlOvs1xq+d8w6Wz4C48VrX1L6++pBuVkWjprs7vXFZhABHH4ehCOQtpG
         Zx5DUnQtsB0nm8ORzGorkSOcKpS97mBpMl4M5BwKhyfCz/NBDZilALB7pu6Hq6ipvVO/
         5e13MNfT+ctL7BV8DBLLJQ82d/RQPauyGqgGg3il8pg66RJezrxaL/Q9+caqZHWtgo06
         O0qydCzoUilMo6LQThZCEKbzd/nDzmzUu+yzGtcIXXn73Iw9/s6wdLd+OuS1NomhVPOo
         Z1AsvlsB8jBDNMCxZA2DedqkchLjOhf7PaIY5pGKVeWIiLjYrwM7qGuks+fE9BEwVgAK
         vovQ==
X-Gm-Message-State: ACrzQf2Zgr/fhoPplVl4marnRw9TZPbzgRpiUXySXbNJy16QiDIKHdi7
        cUFntPPOM+ZZTX6KXEPmRUeASw==
X-Google-Smtp-Source: AMsMyM4I7xCNIreqlQtGJiS3h42xl7qThTw8N1DikSu2ja1uzqHa+EKcRAIzd6ZsWgQCutT99icVKA==
X-Received: by 2002:a63:8643:0:b0:462:9b02:a0c1 with SMTP id x64-20020a638643000000b004629b02a0c1mr6325633pgd.536.1665781462773;
        Fri, 14 Oct 2022 14:04:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j23-20020a63e757000000b0043a18cef977sm1784619pgk.13.2022.10.14.14.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:04:22 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:04:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        maciej.szmigiero@oracle.com
Subject: Re: [PATCH v2 4/8] KVM: x86: do not go through ctxt->ops when
 emulating rsm
Message-ID: <Y0nO0quQnVFQruPM@google.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
 <20220929172016.319443-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929172016.319443-5-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022, Paolo Bonzini wrote:
> @@ -520,14 +505,14 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>  	u64 smbase;
>  	int ret;
>  
> -	smbase = ctxt->ops->get_smbase(ctxt);
> +	smbase = vcpu->arch.smbase;
>  
> -	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, buf, sizeof(buf));
> -	if (ret != X86EMUL_CONTINUE)
> +	ret = kvm_vcpu_read_guest(vcpu, smbase + 0xfe00, buf, sizeof(buf));
> +	if (ret < 0)
>  		return X86EMUL_UNHANDLEABLE;
>  
> -	if ((ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_INSIDE_NMI_MASK) == 0)
> -		ctxt->ops->set_nmi_mask(ctxt, false);
> +	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
> +		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
>  
>  	kvm_smm_changed(vcpu, false);
>  
> @@ -535,41 +520,41 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>  	 * Get back to real mode, to prepare a safe state in which to load
>  	 * CR0/CR3/CR4/EFER.  It's all a bit more complicated if the vCPU
>  	 * supports long mode.
> -	 *
> -	 * The ctxt->ops callbacks will handle all side effects when writing
> -	 * writing MSRs and CRs, e.g. MMU context resets, CPUID
> -	 * runtime updates, etc.
>  	 */
> -	if (emulator_has_longmode(ctxt)) {
> -		struct desc_struct cs_desc;
> +#ifdef CONFIG_X86_64
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {

To fix the "unused 'efer'" issue and avoid multiple guest_cpuid_has() calls, this
as fixup?  It's not like we care about the code footprint for 32-bit KVM if the
compiler isn't clever enough to optimize away the dead code.

---
 arch/x86/kvm/smm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 41ca128478fc..740fca1cf3a3 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -500,6 +500,8 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
+	bool is_64bit_vcpu = IS_ENABLED(CONFIG_X86_64) &&
+			     guest_cpuid_has(vcpu, X86_FEATURE_LM);
 	unsigned long cr0, cr4, efer;
 	char buf[512];
 	u64 smbase;
@@ -521,8 +523,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 	 * CR0/CR3/CR4/EFER.  It's all a bit more complicated if the vCPU
 	 * supports long mode.
 	 */
-#ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (is_64bit_vcpu) {
 		struct kvm_segment cs_desc;
 
 		/* Zero CR4.PCIDE before CR0.PG.  */
@@ -536,15 +537,13 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		cs_desc.s = cs_desc.g = cs_desc.present = 1;
 		kvm_set_segment(vcpu, &cs_desc, VCPU_SREG_CS);
 	}
-#endif
 
 	/* For the 64-bit case, this will clear EFER.LMA.  */
 	cr0 = kvm_read_cr0(vcpu);
 	if (cr0 & X86_CR0_PE)
 		kvm_set_cr0(vcpu, cr0 & ~(X86_CR0_PG | X86_CR0_PE));
 
-#ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (is_64bit_vcpu) {
 		/* Clear CR4.PAE before clearing EFER.LME. */
 		cr4 = kvm_read_cr4(vcpu);
 		if (cr4 & X86_CR4_PAE)
@@ -554,7 +553,6 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		efer = 0;
 		kvm_set_msr(vcpu, MSR_EFER, efer);
 	}
-#endif
 
 	/*
 	 * Give leave_smm() a chance to make ISA-specific changes to the vCPU
@@ -565,7 +563,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		return X86EMUL_UNHANDLEABLE;
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (is_64bit_vcpu)
 		return rsm_load_state_64(ctxt, buf);
 	else
 #endif

base-commit: 8b86d27cc60a150252b04989de818ad4ec85f899
-- 

