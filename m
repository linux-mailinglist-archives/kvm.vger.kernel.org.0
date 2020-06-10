Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E191F5656
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgFJN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:59:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729573AbgFJN7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 09:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591797539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zqN7aOxv4tYIAbVvJMVgvhtAxpCc7lYrNw+p+JSJLQ=;
        b=aFQ63lMI0TBlD3yZRsyNzF+h9NldhxF2Po6pvctwc9e27NKOiVhTqRlYcwz2WhpPWrZ7MA
        MgHv5dw8T1KCUUgWW0wUH7gj2ZybJdjzoATiszrEMYFr2RRodx0OPMxjWZ36EmZnfOOhvb
        HLmQwdQ3us0qk1eg1JOvGv5ZQZ7M0ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-7bJ9JlWGMhiuq4ovUsxOoA-1; Wed, 10 Jun 2020 09:58:56 -0400
X-MC-Unique: 7bJ9JlWGMhiuq4ovUsxOoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D572805731;
        Wed, 10 Jun 2020 13:58:55 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A0B65C298;
        Wed, 10 Jun 2020 13:58:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: do not substitute SVM/VMX check with KVM_CAP_NESTED_STATE check
Date:   Wed, 10 Jun 2020 15:58:46 +0200
Message-Id: <20200610135847.754289-2-vkuznets@redhat.com>
In-Reply-To: <20200610135847.754289-1-vkuznets@redhat.com>
References: <20200610135847.754289-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

state_test/smm_test use KVM_CAP_NESTED_STATE check as an indicator for
nested VMX/SVM presence and this is incorrect. Check for the required
features dirrectly.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/x86_64/svm_util.h |  1 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h    |  1 +
 tools/testing/selftests/kvm/lib/x86_64/svm.c        | 10 +++++++---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c        |  9 +++++++--
 tools/testing/selftests/kvm/x86_64/smm_test.c       | 13 +++++++------
 tools/testing/selftests/kvm/x86_64/state_test.c     | 13 +++++++------
 6 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 674151d24fcf..b7531c83b8ae 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -33,6 +33,7 @@ struct svm_test_data {
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
+bool nested_svm_supported(void);
 void nested_svm_check_supported(void);
 
 static inline bool cpu_has_svm(void)
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 766af9944294..16fa21ebb99c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -603,6 +603,7 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
 
+bool nested_vmx_supported(void);
 void nested_vmx_check_supported(void);
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index c42401068373..3a5c72ed2b79 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -148,14 +148,18 @@ void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
 		: "r15", "memory");
 }
 
-void nested_svm_check_supported(void)
+bool nested_svm_supported(void)
 {
 	struct kvm_cpuid_entry2 *entry =
 		kvm_get_supported_cpuid_entry(0x80000001);
 
-	if (!(entry->ecx & CPUID_SVM)) {
+	return entry->ecx & CPUID_SVM;
+}
+
+void nested_svm_check_supported(void)
+{
+	if (!nested_svm_supported()) {
 		print_skip("nested SVM not enabled");
 		exit(KSFT_SKIP);
 	}
 }
-
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 4ae104f6ce69..f1e00d43eea2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -379,11 +379,16 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-void nested_vmx_check_supported(void)
+bool nested_vmx_supported(void)
 {
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
-	if (!(entry->ecx & CPUID_VMX)) {
+	return entry->ecx & CPUID_VMX;
+}
+
+void nested_vmx_check_supported(void)
+{
+	if (!nested_vmx_supported()) {
 		print_skip("nested VMX not enabled");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 6f8f478b3ceb..36314152943d 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -118,16 +118,17 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
+		if (nested_svm_supported())
 			vcpu_alloc_svm(vm, &nested_gva);
-		else
+		else if (nested_vmx_supported())
 			vcpu_alloc_vmx(vm, &nested_gva);
-		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
-	} else {
-		pr_info("will skip SMM test with VMX enabled\n");
-		vcpu_args_set(vm, VCPU_ID, 1, 0);
 	}
 
+	if (!nested_gva)
+		pr_info("will skip SMM test with VMX enabled\n");
+
+	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+
 	for (stage = 1;; stage++) {
 		_vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index d43b6f99b66c..f6c8b9042f8a 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -171,16 +171,17 @@ int main(int argc, char *argv[])
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
+		if (nested_svm_supported())
 			vcpu_alloc_svm(vm, &nested_gva);
-		else
+		else if (nested_vmx_supported())
 			vcpu_alloc_vmx(vm, &nested_gva);
-		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
-	} else {
-		pr_info("will skip nested state checks\n");
-		vcpu_args_set(vm, VCPU_ID, 1, 0);
 	}
 
+	if (!nested_gva)
+		pr_info("will skip nested state checks\n");
+
+	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+
 	for (stage = 1;; stage++) {
 		_vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-- 
2.25.4

