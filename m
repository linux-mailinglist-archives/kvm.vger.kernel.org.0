Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767544C8434
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiCAGkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiCAGkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:40:07 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0EB32EDC;
        Mon, 28 Feb 2022 22:39:25 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id q11so12682365pln.11;
        Mon, 28 Feb 2022 22:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfqJBImpv6ejxDAentKgdhEmEab1NpVc3AsZ607qoI0=;
        b=f+uwDpknpSowtlzyNOIgRKzipUq5YlqpZKWsCGLO+65fMDFcZXfZ4gB8yKcbWtL0Gb
         SGvnODq5LTJe4ZtIqKzmRhlfL2u1WmF8ENdoM+/bQPqruEoOlkSZzx2HXVPA6udoTWeP
         ZgiVbTVcM+uM0Z9xV0q3vQthmyHIaN/lCZJpzb3Xcg2+oWRPZYiqsKFxLb/A53PhMshG
         skI/f5nlc7bvehhL+qyXYbJjLfcSfRWZ9IqqJ3QkNhn/2sRCJXCs7fMfF4qr5mgFGuBN
         3OjD1gvBeSwMzv0gjNtTCl1QWc91KF64mTUb6hFpkB9Pb65yzns+nJAGOmNkvivODG3o
         K8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfqJBImpv6ejxDAentKgdhEmEab1NpVc3AsZ607qoI0=;
        b=O6nEPPFG5OOMyWuRr+3PHN2f21posghQ0HMI1j053z8MNA7ZsP7mUOruWKhMyBPYEz
         kJhHGNovXrS8024xa5gSbUKjG2EoceDyXSsgnZ07fB3ZyXL2Fe41Y40xBgSTHM/aiuGG
         89hG0orAEueldiBXDCU1qcUCaXXKVbIBt021BkaS08DucOe+Fe4m+Mi81d+H2RWXp+Z4
         qOBqYKpg/si3SHGYytoSebzJlT/IhSFJFQvRF8zNmoxz4ExybOVqnw9cPrsOUwZQTJon
         Q8VP3GJibYxUwZJkxih1V2x0kVwy44miiyZBO3CRDsOpvpBU+7k4qR5b90xa7ia3ZDeb
         FyqQ==
X-Gm-Message-State: AOAM533OICkHgwXJiwdfdo9kkGi/3gmm2WfIKfFif7UUk82LScbLA0bd
        SZ+7wlJRIKBvl1VdEXCLoo8Q6Brn2XYVQgFd
X-Google-Smtp-Source: ABdhPJx5J9VCMYGnMAJSr1VtbocJ3gdfxRVVge9okQ91p3DemgtLEqTnPBdU+ozhd7jRM8/KA3sznQ==
X-Received: by 2002:a17:903:2052:b0:14f:f5fd:d040 with SMTP id q18-20020a170903205200b0014ff5fdd040mr24778131pla.46.1646116765249;
        Mon, 28 Feb 2022 22:39:25 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b004f3f2929d7asm9436704pfc.217.2022.02.28.22.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 22:39:24 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  kvm: x86: Improve virtual machine startup performance
Date:   Tue,  1 Mar 2022 14:37:56 +0800
Message-Id: <20220301063756.16817-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From: Peng Hao <flyingpeng@tencent.com>

vcpu 0 will repeatedly enter/exit the smm state during the startup
phase, and kvm_init_mmu will be called repeatedly during this process.
There are parts of the mmu initialization code that do not need to be
modified after the first initialization.

Statistics on my server, vcpu0 when starting the virtual machine
Calling kvm_init_mmu more than 600 times (due to smm state switching).
The patch can save about 36 microseconds in total.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/mmu.h        |  2 +-
 arch/x86/kvm/mmu/mmu.c    | 39 ++++++++++++++++++++++-----------------
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  2 +-
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ae6168d381e..d263a8ca6d5e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -67,7 +67,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu);
+void kvm_init_mmu(struct kvm_vcpu *vcpu, bool init);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33794379949e..fedc71d9bee2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4738,7 +4738,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, bool init)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
@@ -4749,14 +4749,17 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
-	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = nonpaging_sync_page;
-	context->invlpg = NULL;
-	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
-	context->direct_map = true;
-	context->get_guest_pgd = get_cr3;
-	context->get_pdptr = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
+
+	if (init) {
+		context->page_fault = kvm_tdp_page_fault;
+		context->sync_page = nonpaging_sync_page;
+		context->invlpg = NULL;
+		context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
+		context->direct_map = true;
+		context->get_guest_pgd = get_cr3;
+		context->get_pdptr = kvm_pdptr_read;
+		context->inject_page_fault = kvm_inject_page_fault;
+	}
 	context->root_level = role_regs_to_root_level(&regs);
 
 	if (!is_cr0_pg(context))
@@ -4924,16 +4927,18 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu, bool init)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 
 	kvm_init_shadow_mmu(vcpu, &regs);
 
-	context->get_guest_pgd     = get_cr3;
-	context->get_pdptr         = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
+	if (init) {
+		context->get_guest_pgd     = get_cr3;
+		context->get_pdptr         = kvm_pdptr_read;
+		context->inject_page_fault = kvm_inject_page_fault;
+	}
 }
 
 static union kvm_mmu_role
@@ -4994,14 +4999,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	reset_guest_paging_metadata(vcpu, g_context);
 }
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu)
+void kvm_init_mmu(struct kvm_vcpu *vcpu, bool init)
 {
 	if (mmu_is_nested(vcpu))
 		init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu);
+		init_kvm_tdp_mmu(vcpu, init);
 	else
-		init_kvm_softmmu(vcpu);
+		init_kvm_softmmu(vcpu, init);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
@@ -5054,7 +5059,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	kvm_init_mmu(vcpu);
+	kvm_init_mmu(vcpu, false);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f8b7bc04b3e7..66d70a48e35e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -447,7 +447,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
-	kvm_init_mmu(vcpu);
+	kvm_init_mmu(vcpu, true);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b213ca966d41..28ce73da9150 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1101,7 +1101,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
-	kvm_init_mmu(vcpu);
+	kvm_init_mmu(vcpu, true);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc7eb5fddfd3..fb1e3e945b72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10895,7 +10895,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
-	kvm_init_mmu(vcpu);
+	kvm_init_mmu(vcpu, true);
 	vcpu_put(vcpu);
 	return 0;
 
-- 
2.27.0

