Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7C558797
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiFWSdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237507AbiFWScz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:32:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353C5D191E
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:34:20 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ob5-20020a17090b390500b001e2f03294a7so1543855pjb.8
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YzBiLCY4klTYtqAR87IAA6VD+HxSLPVS13bS8WvciXc=;
        b=sKnXVkJcT/HWTdp8+iZMbVnsW11LhtEvgOwL4zayP6rwcEwEVSw5XjC4Pc6bVQggsu
         CWbJgUKzOLz7sYZMfFaw3MKvLlkoX6OZ6GS4bewHNc0TZBqwpNGuy5a0WMEi7EetJlhd
         NycAp0WSqSK9tX9WTMon+6/phpGY2LodBWt7jf1LKijODwfjN0eSpMiqjgRmKBJf6N0r
         oeUG90uhZQWqp5yG8KrsoDcjaAKENVm2KRA4r6jgeW8v5HoRLPD6BX1tFihCkxBDRJGr
         0C3E8b7LDbjhzIXXlMIGtnv53sq3giEH62PsnQ676AVr4EBflodtXY9U+FPCRLlB34AG
         /ZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YzBiLCY4klTYtqAR87IAA6VD+HxSLPVS13bS8WvciXc=;
        b=5748a3sLU1dvzFEeuGpt+K7Wr9mbuNEc6+SXLNPZ5tVZYp1op15hHSA0uOhWajJPhh
         jrOqTLd71LmHCrRje6BaSfuxkqQEQ4TiJf4uGWmgbxYG6F4ESSFoE6RmbkXz6DxR0vr5
         LbO0geomemLlRhAO1Sz0ubwnu+vbYIO1okuwJ1a/hVGP7FoSr4Wc/7vf4dIexinjuypH
         X1xAovA29LHQc29p8n3BqyxKuigh3AjLGRSZXCQBcYsAVBy1jtG7ntmxXIharZQ5WfcE
         T0cGlqTsYMWN29pYTHQ4k5Xmib0vppmJOmw5E1XFhPKgoUugXdDi2uhC933eE2f3GaqW
         Hw9A==
X-Gm-Message-State: AJIora9YQSbX+gaV3CUy/Aovjm0RmZzfUAiwTIfcGVKceJd0RZ16ugfl
        /7o0SXL0pAX4D0GalKCxVBTdnD8RLVLKB6Q2UIUdEzkcT5n5fb1pzdDu/nagTrd1RJMMtQDIAHm
        LeCBGzEwxEA0JleJ09wWrEP3hl4qgu+PDKL7VxeN7pHFvMmZ19v7uo2BJeg==
X-Google-Smtp-Source: AGRyM1s7DibOnE7Mbl6KtMM0c/TJRvFVMdwV6LfruY9B46xoaSSmTP191nkYGoiaR70UiIkHPnHJKO9AUic=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:9b6a:a8a1:3593:35c2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1683:b0:4f7:e497:6a55 with SMTP id
 k3-20020a056a00168300b004f7e4976a55mr41576663pfc.21.1656005652667; Thu, 23
 Jun 2022 10:34:12 -0700 (PDT)
Date:   Thu, 23 Jun 2022 10:34:06 -0700
Message-Id: <20220623173406.744645-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH V2] KVM: SEV: Init target VMCBs in sev_migrate_from
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The target VMCBs during an intra-host migration need to correctly setup
for running SEV and SEV-ES guests. Add sev_init_vmcb() function and make
sev_es_init_vmcb() static. sev_init_vmcb() uses the now private function
to init SEV-ES guests VMCBs when needed.

Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

V2
* Refactor of sev_es_init_vmcb() and sev_migrate_from suggested by Sean.

---
 arch/x86/kvm/svm/sev.c | 68 ++++++++++++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c | 11 ++-----
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 309bcdb2f929..d45868031954 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1662,19 +1662,24 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
 	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
 	struct kvm_sev_info *mirror;
+	unsigned long i;
 
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
+	dst->es_active = src->es_active;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
 	src->enc_context_owner = NULL;
+	src->es_active = false;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
@@ -1701,26 +1706,21 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
 	}
-}
 
-static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
-{
-	unsigned long i;
-	struct kvm_vcpu *dst_vcpu, *src_vcpu;
-	struct vcpu_svm *dst_svm, *src_svm;
+	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
+		dst_svm = to_svm(dst_vcpu);
 
-	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
-		return -EINVAL;
+		sev_init_vmcb(dst_svm);
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
-		if (!src_vcpu->arch.guest_state_protected)
-			return -EINVAL;
-	}
+		if (!dst->es_active)
+			continue;
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
+		/*
+		 * Note, the source is not required to have the same number of
+		 * vCPUs as the destination when migrating a vanilla SEV VM.
+		 */
+		src_vcpu = kvm_get_vcpu(dst_kvm, i);
 		src_svm = to_svm(src_vcpu);
-		dst_vcpu = kvm_get_vcpu(dst, i);
-		dst_svm = to_svm(dst_vcpu);
 
 		/*
 		 * Transfer VMSA and GHCB state to the destination.  Nullify and
@@ -1737,8 +1737,23 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 		src_vcpu->arch.guest_state_protected = false;
 	}
-	to_kvm_svm(src)->sev_info.es_active = false;
-	to_kvm_svm(dst)->sev_info.es_active = true;
+}
+
+static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
+{
+	struct kvm_vcpu *src_vcpu;
+	unsigned long i;
+
+	if (!sev_es_guest(src))
+		return 0;
+
+	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		if (!src_vcpu->arch.guest_state_protected)
+			return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1786,11 +1801,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_dst_vcpu;
 
-	if (sev_es_guest(source_kvm)) {
-		ret = sev_es_migrate_from(kvm, source_kvm);
-		if (ret)
-			goto out_source_vcpu;
-	}
+	ret = sev_check_source_vcpus(kvm, source_kvm);
+	if (ret)
+		goto out_source_vcpu;
 
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
@@ -2911,7 +2924,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
-void sev_es_init_vmcb(struct vcpu_svm *svm)
+static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -2964,6 +2977,15 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	}
 }
 
+void sev_init_vmcb(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	clr_exception_intercept(svm, UD_VECTOR);
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_init_vmcb(svm);
+}
+
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 136298cfb3fb..3c0e581676c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1259,15 +1259,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
-	if (sev_guest(vcpu->kvm)) {
-		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
-
-		if (sev_es_guest(vcpu->kvm)) {
-			/* Perform SEV-ES specific VMCB updates */
-			sev_es_init_vmcb(svm);
-		}
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_init_vmcb(svm);
 
 	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d51de3c9264a..0897ce8a4863 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -649,10 +649,10 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
-- 
2.37.0.rc0.104.g0611611a94-goog

