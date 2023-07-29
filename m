Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354A6767AA6
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbjG2BRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbjG2BRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CCE46B4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-585fb08172bso500917b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593396; x=1691198196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5BOuAmsGu5bKSoLgi0ClRVcqN8jZYDkPjN1Ef5oXFc=;
        b=druYUWwg+Cc+LP91WMNQ9dRoa7w6GYwh9GZqzIigWMkFkWk8Uj2z1giZell+k87Zn0
         PFHW1nx+OjdSmtIXMvUq6mrlU8oB2wAeof8STbQvZWoMNx5gf8Lt5GvTkCThnHdv0Y9T
         /yX2rIr0Mn2tNKO4ALpLcsmIl6OZBZrXr2jTpRAv2xGZNeWVyxPcrsmnOuGl08UbY+PG
         MfgsDWIzS5xT5XQyiD5zK2CSnjjONty8UTFlbmujMRzDVveGUy0vsXRBUgQjHFYmmUH3
         xrzZLdJPPEXJ04vuzw/WnBBvgfEs8hokIWiBtaH7Oo5volw8JS5CRBSvj1lzdZrSYM+T
         tdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593396; x=1691198196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y5BOuAmsGu5bKSoLgi0ClRVcqN8jZYDkPjN1Ef5oXFc=;
        b=iL8cUrd6JclY9MAiCBi1aL2GwwZyVdDaou6WW4z8cjgsm9J2CLHMzbmOuM6CIpJ8o1
         qDaMby3IwHG15zpZzGYx02nZ6O/CQF1CtmxTFe9TqmMfsqtxDZa0fk5/7nhWUoB+/e8z
         JrgyY6YWu1H0xcOpXaKQqsxb/IC1a5jrVnGJc6RN0bl50f98PyuqLgFIPZyCWZ3bGBWl
         u77w5eRBK++bZbPqireUr7/UXiUB+624OSgCVv4xll3KMLuyE0TOo9LvXsbABqYFn8rd
         EjXdfoScgQoVXDxYUvhWmlHEOCNcnGiTh+wDmlv0x6WaQ+Vd7Kqn5bU5hHt8lbDAiTgN
         Pq2w==
X-Gm-Message-State: ABy/qLbHvN57O+pnGCLs6ewa+STFDbNlxCtKf9NoyFwlACdMaGEhX9E0
        7RWTC/7IOBsloW5vX1ixcZYgy3swm/4=
X-Google-Smtp-Source: APBJJlEVY2XTgkED7EmJfSyPFRPcLkJ6OIqU6YgZjXhcx6LZTqLNwNhp9SBmAEfpbJhi88U4IVidPoNquCA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db8d:0:b0:d18:73fc:40af with SMTP id
 g135-20020a25db8d000000b00d1873fc40afmr18262ybf.5.1690593396223; Fri, 28 Jul
 2023 18:16:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:59 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-13-seanjc@google.com>
Subject: [PATCH v2 12/21] KVM: x86: Use KVM-governed feature framework to
 track "XSAVES enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the governed feature framework to track if XSAVES is "enabled", i.e.
if XSAVES can be used by the guest.  Add a comment in the SVM code to
explain the very unintuitive logic of deliberately NOT checking if XSAVES
is enumerated in the guest CPUID model.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/svm.c           | 17 ++++++++++++++---
 arch/x86/kvm/vmx/vmx.c           | 32 ++++++++++++++++++--------------
 arch/x86/kvm/x86.c               |  4 ++--
 4 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index b29c15d5e038..b896a64e4ac3 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -6,6 +6,7 @@ BUILD_BUG()
 #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
 
 KVM_GOVERNED_X86_FEATURE(GBPAGES)
+KVM_GOVERNED_X86_FEATURE(XSAVES)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 64092df06f94..d5f8cb402eb7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4204,9 +4204,20 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
 
-	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-				    boot_cpu_has(X86_FEATURE_XSAVE) &&
-				    boot_cpu_has(X86_FEATURE_XSAVES);
+	/*
+	 * SVM doesn't provide a way to disable just XSAVES in the guest, KVM
+	 * can only disable all variants of by disallowing CR4.OSXSAVE from
+	 * being set.  As a result, if the host has XSAVE and XSAVES, and the
+	 * guest has XSAVE enabled, the guest can execute XSAVES without
+	 * faulting.  Treat XSAVES as enabled in this case regardless of
+	 * whether it's advertised to the guest so that KVM context switches
+	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
+	 * the guest read/write access to the host's XSS.
+	 */
+	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
+	    boot_cpu_has(X86_FEATURE_XSAVES) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
+		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
 
 	/* Update nrips enabled cache */
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0a47be2feed..3100ed62615c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4518,16 +4518,19 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
  * based on a single guest CPUID bit, with a dedicated feature bit.  This also
  * verifies that the control is actually supported by KVM and hardware.
  */
-#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
-({									 \
-	bool __enabled;							 \
-									 \
-	if (cpu_has_vmx_##name()) {					 \
-		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
-					    X86_FEATURE_##feat_name);	 \
-		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
-			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
-	}								 \
+#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting)	\
+({												\
+	struct kvm_vcpu *__vcpu = &(vmx)->vcpu;							\
+	bool __enabled;										\
+												\
+	if (cpu_has_vmx_##name()) {								\
+		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
+			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
+		else										\
+			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
+		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
+						  __enabled, exiting);				\
+	}											\
 })
 
 /* More macro magic for ENABLE_/opt-in versus _EXITING/opt-out controls. */
@@ -4587,10 +4590,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
-	if (cpu_has_vmx_xsaves())
-		vmx_adjust_secondary_exec_control(vmx, &exec_control,
-						  SECONDARY_EXEC_ENABLE_XSAVES,
-						  vcpu->arch.xsaves_enabled, false);
+	vmx_adjust_sec_exec_feature(vmx, &exec_control, xsaves, XSAVES);
 
 	/*
 	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
@@ -4609,6 +4609,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 						  SECONDARY_EXEC_ENABLE_RDTSCP,
 						  rdpid_or_rdtscp_enabled, false);
 	}
+
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
@@ -7722,6 +7723,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
 				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
+	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
+		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
 	vmx_setup_uret_msrs(vmx);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a14378ed4e1..201fa957ce9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1012,7 +1012,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
-		if (vcpu->arch.xsaves_enabled &&
+		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
@@ -1043,7 +1043,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
 
-		if (vcpu->arch.xsaves_enabled &&
+		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, host_xss);
 	}
-- 
2.41.0.487.g6d72f3e995-goog

