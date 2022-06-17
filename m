Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE154FDEB
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245188AbiFQTwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 15:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiFQTwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 15:52:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB815A0A6
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 12:52:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso2656109pgc.8
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 12:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Lv+NejjYJPAtPZEJ3w1I1cBl7ejfDuSrn7GM/dgRjS8=;
        b=eVdoaGWT3W3S+FNNXUl/8ah2ngDbVZZ/YVNxeA0nZ0gL47rhoODis3BvDFE9yqAcfH
         cs4wBmNz80D72Ms77gB/eJBWKI65CEF42UxNx+XUDwpk9XX1+YDcy7Ml10Gy6s162N36
         +q0K/skwNeIWULDIpliP4IfDnc/kArrCD/nfkLd+9kT5agyG6zFW126D7IOBmCnbe1io
         tSRJbVTndrz4H2ATzb4kUDGeNnpfOsUIjNdxuvHcfYdNauvIzxyizN2KtgwDYL6zitfj
         lQYg+qY4KYC3qrc17OqT3pJZSWV4py9IZJGT/6GCM2Vs7u3JmAmpeyhcSR0v8djKmCTT
         7Rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Lv+NejjYJPAtPZEJ3w1I1cBl7ejfDuSrn7GM/dgRjS8=;
        b=T/yqKHldtlTMhKXKA9Rvaz38OJ8yBG7NG5jl/KXnuKqKy+ZjB5bwvL3WKb3Zg4dTi8
         zTihf1xqcozAkOjU+neD4vYtZgTBQM3lq1S6TtX0cRER/nOTY+hmApG1yA6mK+MXkkx8
         skhZzfo2UP8D+XbqOUrz3k3GTu7JtODRLFSMlHJFXdUCJd1rbJ7JpsRAxGC+KKQDAFNU
         YkZpmHOgua+73sQncMaoz0O4gqwGGQu2/YaQmrpL/0UJ0hjEmxmQnCIkLLhhERHViSIu
         28NwmTQbfau2mMg4fm5SNOksZ0KG8tEb0Jys8ZYggYCyHhAmc3LQUJL2G/DJKGYBWPuU
         faxQ==
X-Gm-Message-State: AJIora9eM1kDlEAQSrGUiSjATOvtJtB8FTZbH6m+BuzgvZqmnNRBj7aL
        /V3tzK3/sqipEMxW9RtK311NseE79uRDex0R4j7SXBLpxTCqa0nHnd38wG3zHf7hlFa1GIGf5Re
        Jp23I2OK4Svls8l8hDMRbvmIOaZZs413HxirSW+YoRErRhL3XT0kSU15o5A==
X-Google-Smtp-Source: AGRyM1vQbx4q8SwKybNxxRMWTFV4usZRF+S42IgTimAM7QW0ZYWAuE2SSWY/hklamaqRNBbXHKxT3w7HMr0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:a27f:324e:df09:e093])
 (user=pgonda job=sendgmr) by 2002:a17:902:f690:b0:163:f8eb:3741 with SMTP id
 l16-20020a170902f69000b00163f8eb3741mr10984379plg.112.1655495532341; Fri, 17
 Jun 2022 12:52:12 -0700 (PDT)
Date:   Fri, 17 Jun 2022 12:51:41 -0700
Message-Id: <20220617195141.2866706-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH] KVM: SEV: Init target VMCBs in sev_migrate_from
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
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

The target VMCBs during an intra-host migration need to correctly setup
for running SEV and SEV-ES guests. Use the sev_es_init_vmcb() to setup
the sev-es VMCBs and refactor out a new sev_init_vmcb() function to
handle SEV only migrations.

Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

I had tested this with the selftests and by backporting patches to our
kernel fork and running on our Vanadium VMM internally. Doing that however
I dropped the requirement that SEV_INIT not be done on the target for
minimal changes to our VMM for testing. This lead to me missing this bug.

Tested by backporting back to our kernel fork and running our intra-host
migration test suite without SEV_INITing the target VM.

---
 arch/x86/kvm/svm/sev.c | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.c |  3 +--
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 655770522471..d483f253fcf5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1666,6 +1666,8 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
 	struct kvm_sev_info *mirror;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 
 	dst->active = true;
 	dst->asid = src->asid;
@@ -1681,6 +1683,10 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
+	kvm_for_each_vcpu(i, vcpu, dst_kvm) {
+		sev_init_vmcb(to_svm(vcpu));
+	}
+
 	/*
 	 * If this VM has mirrors, "transfer" each mirror's refcount of the
 	 * source to the destination (this KVM).  The caller holds a reference
@@ -1739,6 +1745,8 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 		src_svm->vmcb->control.ghcb_gpa = INVALID_PAGE;
 		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 		src_vcpu->arch.guest_state_protected = false;
+
+		sev_es_init_vmcb(dst_svm);
 	}
 	to_kvm_svm(src)->sev_info.es_active = false;
 	to_kvm_svm(dst)->sev_info.es_active = true;
@@ -2914,6 +2922,12 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
+void sev_init_vmcb(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	clr_exception_intercept(svm, UD_VECTOR);
+}
+
 void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12e792389e8b..9b9bbc228a69 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1247,8 +1247,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	}
 
 	if (sev_guest(vcpu->kvm)) {
-		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
+		sev_init_vmcb(svm);
 
 		if (sev_es_guest(vcpu->kvm)) {
 			/* Perform SEV-ES specific VMCB updates */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cd92f4343753..33b6c6dd1a10 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -656,6 +656,7 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-- 
2.36.1.476.g0c4daa206d-goog

