Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E554BB5E
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351991AbiFNUHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351612AbiFNUH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75246101A
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so5339815plg.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J93edaE74FyBzoZW2rh0wjT0Yg14RVMCKpGZ/ATfHIY=;
        b=epJQbRv6fZOQ46aFKGz/2X1l/u1LHD23Fnu20xpVzGTyWGFNlJNcjtyPdhLPeGbIbz
         UbwfDb/eohWGpYEiayDBNojIksfhX6hSGEXO4xjFsOrNOj3o49C+O5pRGxV6iROiC5AK
         UC2H2j+zbeWKyIh6cr0p6fu8qipwWRzmYiHCMuqA32F+QQKcS9bgzwSEsGzBWgQrM27I
         gMHkoHMYpmKmwqpox104N4kE7DyouJJ+MmF7crj/d6CVvH7EHZKE7smKweTywZUirezP
         oQCQ/VWxTFGb8TsHM4hYSBP0s0gVzEzPFZJc19hqODlQEzcAdv19/JsE8gZCBSVf6Cfg
         DA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J93edaE74FyBzoZW2rh0wjT0Yg14RVMCKpGZ/ATfHIY=;
        b=3M4OuZtiS7DU2N8DJFe72OLpikpxQD3vP3xvigW978rIA2mN45tBhRzwj4gFWJGKS2
         eYhZqiaErllH2PTbMr0KjwOaX7oFAmZ+UZHDF5e/UD6ewmc8hf5APPdbjU5XhAjQNvKv
         osMqLnn7dIIJuL7b1mFUM2M0kmhBHv3l4Ug1UDtb9olWp7X2N8ouQrRHsqIzuMDqWHj1
         x+zBuM6HdYjc7AGDAS9KMAgtaPF9ZD2EU0uBtBPsGWDmbYKvTVv5CE/UkRmPcRmgLTok
         jmAR23Yd9o7anWwks910A5Gav6b4NcycwGka2CFkS3Aqzzw9YcO2mfsYKpCdh0Mo7tYR
         XNEw==
X-Gm-Message-State: AJIora/A1cWXyIdzBFNQA1zhGD/rPoC2zDBergM+DaYBXkFlrPvx/1lW
        SkevId6m8tfN+cV4mBtBZjCKD8ZqHAc=
X-Google-Smtp-Source: AGRyM1tzu39iODqRptuUGTNst3eC6hfAzODozizMM2ZFnewKJZkyLTZhmuNVHR98uQ3Z6vnPmREfEEDLIDM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1104:b0:168:d336:cd1e with SMTP id
 n4-20020a170903110400b00168d336cd1emr5972887plh.72.1655237241883; Tue, 14 Jun
 2022 13:07:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:30 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 05/42] KVM: selftests: Use kvm_cpu_has() for nested SVM checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use kvm_cpu_has() to check for nested SVM support, and drop the helpers
now that their functionality is trivial to implement.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/svm_util.h |  2 --
 tools/testing/selftests/kvm/lib/x86_64/svm.c        | 13 -------------
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c  |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c       |  2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c     |  2 +-
 .../testing/selftests/kvm/x86_64/svm_int_ctl_test.c |  2 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c        |  2 +-
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c  |  2 +-
 8 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 136ba6a5d027..f48806d26989 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -51,8 +51,6 @@ struct svm_test_data {
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
-bool nested_svm_supported(void);
-void nested_svm_check_supported(void);
 
 static inline bool cpu_has_svm(void)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 37e9c0a923e0..6d445886e16c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -164,19 +164,6 @@ void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
 		: "r15", "memory");
 }
 
-bool nested_svm_supported(void)
-{
-	struct kvm_cpuid_entry2 *entry =
-		kvm_get_supported_cpuid_entry(0x80000001);
-
-	return entry->ecx & CPUID_SVM;
-}
-
-void nested_svm_check_supported(void)
-{
-	TEST_REQUIRE(nested_svm_supported());
-}
-
 /*
  * Open SEV_DEV_PATH if available, otherwise exit the entire program.
  *
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index c5cd9835dbd6..ea507510a62f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -127,7 +127,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 
-	TEST_REQUIRE(nested_svm_supported());
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index e89139ce68dd..6b8108bdcead 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -154,7 +154,7 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vcpu, MSR_IA32_SMBASE, SMRAM_GPA);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		if (nested_svm_supported())
+		if (kvm_cpu_has(X86_FEATURE_SVM))
 			vcpu_alloc_svm(vm, &nested_gva);
 		else if (nested_vmx_supported())
 			vcpu_alloc_vmx(vm, &nested_gva);
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index ea878c963065..fe110ce31106 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -170,7 +170,7 @@ int main(int argc, char *argv[])
 	vcpu_regs_get(vcpu, &regs1);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		if (nested_svm_supported())
+		if (kvm_cpu_has(X86_FEATURE_SVM))
 			vcpu_alloc_svm(vm, &nested_gva);
 		else if (nested_vmx_supported())
 			vcpu_alloc_vmx(vm, &nested_gva);
diff --git a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
index 9c68a47b69e1..dc32c347281a 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
@@ -90,7 +90,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	nested_svm_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 051f70167074..3c21b997fe3a 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -200,7 +200,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	nested_svm_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
 	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
 	TEST_ASSERT(cpuid->edx & CPUID_NRIPS,
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
index e6d7191866a5..46ce1bda6599 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -39,7 +39,7 @@ int main(int argc, char *argv[])
 	vm_vaddr_t svm_gva;
 	struct kvm_vm *vm;
 
-	nested_svm_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
-- 
2.36.1.476.g0c4daa206d-goog

