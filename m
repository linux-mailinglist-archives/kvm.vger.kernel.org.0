Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C15417C1F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348330AbhIXUGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 16:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348322AbhIXUGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 16:06:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F36C061613
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:05:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t20so7705209pju.5
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7smASSk20sk/dEjIN22giVM2umfwDr5FaFIt4AQIQNU=;
        b=KgW8iGp92Wt+B4rVc/D2LBIdBPKYYjk6X7qeaLEHmLXQ9nMWi/rOFr6rY4QDreXh4D
         fhbPdvEpfpovCeMKsAhfIP8NrKuVZOJP9hXeCr3wcRys1i/A09+WHZBAEubjNvFLgd2r
         +cSVSNGoRN9pRo/qjKgtj3KrcasoWQj2OjvMj0MxCMoJqC+nekmU7JI1hNXBg/yFGsuG
         9sG1ctLgSf32d/2ZJ2TeGDxLZCD5o9WRl9S0OcMYaa7grIFeN7ub3yxa8U2H4VnHyu1R
         TBHq9z5PMTtyh+sK+mTE7EN0xA+HzZ4EvITlFyZzBYD5Curgnj9eo42OUDDJBlYqGoDZ
         gj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7smASSk20sk/dEjIN22giVM2umfwDr5FaFIt4AQIQNU=;
        b=Sn+JYliRoM9+ekPhgTlzbGmk9MzZjApTNYF9588sxPSjj42SbZhmytGEOcIIaVB6wi
         7loKtsSsPiAzzbOLptIkETCP5J7pgnCxI3BQMA1D8z5bPdSV48rGlTFlwzcbpwCHGO9q
         BTszNlo4pWKg1rrX+UShCoVpRKkBWNhYjBf0pw6tgA4CjnNWxGWZSoxAjyF3/t0t9+SJ
         ZSpM6J0WefIAKlWYHq5ASCiG2aKnFT169H2CyfHlEf47wAVlhVu42jl9ItIgIXNDavh3
         S4DRHxKz5Q+HTbZoWXptW1TcANqKdaLw+HXhgmHMcpxC89TQ/2DTl3kFl9l3+GyH4bo3
         VkMg==
X-Gm-Message-State: AOAM5330lM6y8AsuQVd2SEDbofI93d+LyTaldUGVTmdzvcyni/y8Nax+
        Y1jouf7eAbFAssi0WjbL65WH0A==
X-Google-Smtp-Source: ABdhPJwTik+vy0jOgauZgqIBhC3SnH0Oa3IU/AAwBwWdQPatVOVpsREoqShwOXDw3aI5CJO41skJAQ==
X-Received: by 2002:a17:90a:47:: with SMTP id 7mr4425139pjb.46.1632513900051;
        Fri, 24 Sep 2021 13:05:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n19sm9764550pfa.60.2021.09.24.13.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 13:04:59 -0700 (PDT)
Date:   Fri, 24 Sep 2021 20:04:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 1/4] KVM: SVM: Get rid of set_ghcb_msr() and
 *ghcb_msr_bits() functions
Message-ID: <YU4u3Kk1UTQWfWZ4@google.com>
References: <20210913141345.27175-1-joro@8bytes.org>
 <20210913141345.27175-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913141345.27175-2-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021, Joerg Roedel wrote:
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> @@ -2377,16 +2371,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  
>  	switch (ghcb_info) {
>  	case GHCB_MSR_SEV_INFO_REQ:
> -		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
> -						    GHCB_VERSION_MIN,
> -						    sev_enc_bit));
> +		svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
> +								GHCB_VERSION_MIN,
> +								sev_enc_bit);

Nit, "svm->vmcb->control." can be "control->".

With that fixed,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  		break;
>  	case GHCB_MSR_CPUID_REQ: {
>  		u64 cpuid_fn, cpuid_reg, cpuid_value;
>  
> -		cpuid_fn = get_ghcb_msr_bits(svm,
> -					     GHCB_MSR_CPUID_FUNC_MASK,
> -					     GHCB_MSR_CPUID_FUNC_POS);
> +		cpuid_fn = GHCB_MSR_CPUID_FN(control->ghcb_gpa);
>  
>  		/* Initialize the registers needed by the CPUID intercept */
>  		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
> @@ -2398,9 +2390,8 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  			break;
>  		}
>  
> -		cpuid_reg = get_ghcb_msr_bits(svm,
> -					      GHCB_MSR_CPUID_REG_MASK,
> -					      GHCB_MSR_CPUID_REG_POS);
> +		cpuid_reg = GHCB_MSR_CPUID_REG(control->ghcb_gpa);
> +
>  		if (cpuid_reg == 0)
>  			cpuid_value = vcpu->arch.regs[VCPU_REGS_RAX];
>  		else if (cpuid_reg == 1)
> @@ -2410,26 +2401,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  		else
>  			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];
>  
> -		set_ghcb_msr_bits(svm, cpuid_value,
> -				  GHCB_MSR_CPUID_VALUE_MASK,
> -				  GHCB_MSR_CPUID_VALUE_POS);
> +		svm->vmcb->control.ghcb_gpa = ghcb_msr_cpuid_resp(cpuid_reg, cpuid_value);
>  
> -		set_ghcb_msr_bits(svm, GHCB_MSR_CPUID_RESP,
> -				  GHCB_MSR_INFO_MASK,
> -				  GHCB_MSR_INFO_POS);

I don't mind using a helper instead of a macro (I completely agree the helper is
easier to read), but we should be consistent, i.e. get rid of GHCB_MSR_SEV_INFO.
And IMO that helper should handle the min/max version, not the callers.  Add this
after patch 01 (modulo the above nit)?

From 5c329f9e7156948697955a2745f32df024aa5ee6 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 24 Sep 2021 12:58:31 -0700
Subject: [PATCH] KVM: SVM: Add helper to generate GHCB MSR verson info, and
 drop macro

Convert the GHCB_MSR_SEV_INFO macro into a helper function, and have the
helper hardcode the min/max versions instead of relying on the caller to
do the same.  Under no circumstance should different pieces of KVM define
different min/max versions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sev-common.h |  5 -----
 arch/x86/kvm/svm/sev.c            | 24 ++++++++++++++++++------
 arch/x86/kvm/svm/svm.h            |  5 -----
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 8540972cad04..886c36f0cb16 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -24,11 +24,6 @@
 #define GHCB_MSR_VER_MIN_MASK		0xffff
 #define GHCB_MSR_CBIT_POS		24
 #define GHCB_MSR_CBIT_MASK		0xff
-#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
-	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
-	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
-	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
-	 GHCB_MSR_SEV_INFO_RESP)
 #define GHCB_MSR_INFO(v)		((v) & 0xfffUL)
 #define GHCB_MSR_PROTO_MAX(v)		(((v) >> GHCB_MSR_VER_MAX_POS) & GHCB_MSR_VER_MAX_MASK)
 #define GHCB_MSR_PROTO_MIN(v)		(((v) >> GHCB_MSR_VER_MIN_POS) & GHCB_MSR_VER_MIN_MASK)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7aa6ad4c3118..159b22bb74e4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2389,6 +2389,22 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 	return msr;
 }

+/* The min/max GHCB version supported by KVM. */
+#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MIN	1ULL
+
+static u64 ghcb_msr_version_info(void)
+{
+	u64 msr;
+
+	msr  = GHCB_MSR_SEV_INFO_RESP;
+	msr |= GHCB_VERSION_MAX << GHCB_MSR_VER_MAX_POS;
+	msr |= GHCB_VERSION_MIN << GHCB_MSR_VER_MIN_POS;
+	msr |= sev_enc_bit << GHCB_MSR_CBIT_POS;
+
+	return msr;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2403,9 +2419,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)

 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-								GHCB_VERSION_MIN,
-								sev_enc_bit);
+		control->ghcb_gpa = ghcb_msr_version_info();
 		break;
 	case GHCB_MSR_CPUID_REQ: {
 		u64 cpuid_fn, cpuid_reg, cpuid_value;
@@ -2621,9 +2635,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-							GHCB_VERSION_MIN,
-							sev_enc_bit);
+	svm->vmcb->control.ghcb_gpa = ghcb_msr_version_info();
 }

 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..68e5f16a0554 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -544,11 +544,6 @@ void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);

 /* sev.c */
-
-#define GHCB_VERSION_MAX	1ULL
-#define GHCB_VERSION_MIN	1ULL
-
-
 extern unsigned int max_sev_asid;

 void sev_vm_destroy(struct kvm *kvm);
--
2.33.0.685.g46640cef36-goog


