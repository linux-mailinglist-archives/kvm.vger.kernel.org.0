Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07E9D0159
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbfJHTnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 15:43:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfJHTnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 15:43:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2BFFD307D989;
        Tue,  8 Oct 2019 19:43:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-92.brq.redhat.com [10.40.204.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D26B5D6A7;
        Tue,  8 Oct 2019 19:43:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 2/3] selftests: kvm: consolidate VMX support checks
Date:   Tue,  8 Oct 2019 21:43:37 +0200
Message-Id: <20191008194338.24159-3-vkuznets@redhat.com>
In-Reply-To: <20191008194338.24159-1-vkuznets@redhat.com>
References: <20191008194338.24159-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 08 Oct 2019 19:43:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_* tests require VMX and three of them implement the same check. Move it
to vmx library.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h       |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c           | 10 ++++++++++
 .../selftests/kvm/x86_64/vmx_close_while_nested_test.c |  6 +-----
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c   |  6 +-----
 .../testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c |  6 +-----
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 6ae5a47fe067..f52e0ba84fed 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -580,6 +580,8 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
 
+void nested_vmx_check_supported(void);
+
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr, uint32_t eptp_memslot);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index fab8f6b0bf52..f6ec97b7eaef 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -376,6 +376,16 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
+void nested_vmx_check_supported(void)
+{
+	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
+
+	if (!(entry->ecx & CPUID_VMX)) {
+		fprintf(stderr, "nested VMX not enabled, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+}
+
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	 	   uint64_t nested_paddr, uint64_t paddr, uint32_t eptp_memslot)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index 3b0ffe01dacd..5dfb53546a26 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -53,12 +53,8 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva;
-	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
-	if (!(entry->ecx & CPUID_VMX)) {
-		fprintf(stderr, "nested VMX not enabled, skipping test\n");
-		exit(KSFT_SKIP);
-	}
+	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index a6d85614ae4d..9ef7fab39d48 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -224,7 +224,6 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_nested_state state;
-	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
 
@@ -237,10 +236,7 @@ int main(int argc, char *argv[])
 	 * AMD currently does not implement set_nested_state, so for now we
 	 * just early out.
 	 */
-	if (!(entry->ecx & CPUID_VMX)) {
-		fprintf(stderr, "nested VMX not enabled, skipping test\n");
-		exit(KSFT_SKIP);
-	}
+	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, 0);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index f36c10eba71e..5590fd2bcf87 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -128,12 +128,8 @@ static void report(int64_t val)
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva;
-	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
-	if (!(entry->ecx & CPUID_VMX)) {
-		fprintf(stderr, "nested VMX not enabled, skipping test\n");
-		exit(KSFT_SKIP);
-	}
+	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-- 
2.20.1

