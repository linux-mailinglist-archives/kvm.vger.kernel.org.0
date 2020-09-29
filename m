Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3427D235
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 17:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbgI2PKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 11:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgI2PK1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 11:10:27 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601392225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQY/TDx5VDPwtvi1ueBk5n9nYxAtGXDK6XBdjXRtePc=;
        b=hZyxrzoxkR6m9+dBC4M2wCX4+HepKsuBFeUMqEhpvXhpk7QLM2XhQ1/YUiZpgIk2gt2Nzf
        MsgXZTJARh5GbH8fOptGHGaFtjBTe53BQH2+lA4lMPq9+pY3+FNyeo9UkXSr9+fLM9wNJ3
        3nHuLLxdC+Su7Lp28ZfT0H6ln5STw/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-Oh5YDNuwPTqkRedx53HG_w-1; Tue, 29 Sep 2020 11:10:20 -0400
X-MC-Unique: Oh5YDNuwPTqkRedx53HG_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B5A192C8AE;
        Tue, 29 Sep 2020 15:09:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3B3573663;
        Tue, 29 Sep 2020 15:09:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
Date:   Tue, 29 Sep 2020 17:09:44 +0200
Message-Id: <20200929150944.1235688-3-vkuznets@redhat.com>
In-Reply-To: <20200929150944.1235688-1-vkuznets@redhat.com>
References: <20200929150944.1235688-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_HV_CPUID is now supported as both vCPU and VM ioctl,
test that.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 ++++++
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 87 +++++++++++--------
 3 files changed, 77 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..59482e4eb308 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -112,6 +112,8 @@ void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
+void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
+int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..d49e24a15836 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1518,6 +1518,32 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 		cmd, ret, errno, strerror(errno));
 }
 
+/*
+ * KVM system ioctl
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   cmd - Ioctl number
+ *   arg - Argument to pass to the ioctl
+ *
+ * Return: None
+ *
+ * Issues an arbitrary ioctl on a KVM fd.
+ */
+void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+{
+	int ret;
+
+	ret = ioctl(vm->kvm_fd, cmd, arg);
+	TEST_ASSERT(ret == 0, "KVM ioctl %lu failed, rc: %i errno: %i (%s)",
+		cmd, ret, errno, strerror(errno));
+}
+
+int _kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+{
+	return ioctl(vm->kvm_fd, cmd, arg);
+}
+
 /*
  * VM Dump
  *
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 745b708c2d3b..88a595b7fbdd 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -46,19 +46,19 @@ static bool smt_possible(void)
 }
 
 static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
-			  bool evmcs_enabled)
+			  bool evmcs_expected)
 {
 	int i;
 	int nent = 9;
 	u32 test_val;
 
-	if (evmcs_enabled)
+	if (evmcs_expected)
 		nent += 1; /* 0x4000000A */
 
 	TEST_ASSERT(hv_cpuid_entries->nent == nent,
 		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
 		    " with evmcs=%d (returned %d)",
-		    nent, evmcs_enabled, hv_cpuid_entries->nent);
+		    nent, evmcs_expected, hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
@@ -68,7 +68,7 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			    "function %x is our of supported range",
 			    entry->function);
 
-		TEST_ASSERT(evmcs_enabled || (entry->function != 0x4000000A),
+		TEST_ASSERT(evmcs_expected || (entry->function != 0x4000000A),
 			    "0x4000000A leaf should not be reported");
 
 		TEST_ASSERT(entry->index == 0,
@@ -87,7 +87,7 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			TEST_ASSERT(entry->eax == test_val,
 				    "Wrong max leaf report in 0x40000000.EAX: %x"
 				    " (evmcs=%d)",
-				    entry->eax, evmcs_enabled
+				    entry->eax, evmcs_expected
 				);
 			break;
 		case 0x40000004:
@@ -110,20 +110,23 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 
 }
 
-void test_hv_cpuid_e2big(struct kvm_vm *vm)
+void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
 {
 	static struct kvm_cpuid2 cpuid = {.nent = 0};
 	int ret;
 
-	ret = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+	if (!system)
+		ret = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+	else
+		ret = _kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 
 	TEST_ASSERT(ret == -1 && errno == E2BIG,
-		    "KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
-		    " it should have: %d %d", ret, errno);
+		    "%s KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
+		    " it should have: %d %d", system ? "KVM" : "vCPU", ret, errno);
 }
 
 
-struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
+struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm, bool system)
 {
 	int nent = 20; /* should be enough */
 	static struct kvm_cpuid2 *cpuid;
@@ -137,7 +140,10 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 
 	cpuid->nent = nent;
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+	if (!system)
+		vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+	else
+		kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
 	return cpuid;
 }
@@ -146,45 +152,50 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	int rv, stage;
 	struct kvm_cpuid2 *hv_cpuid_entries;
-	bool evmcs_enabled;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	rv = kvm_check_cap(KVM_CAP_HYPERV_CPUID);
-	if (!rv) {
+	if (!kvm_check_cap(KVM_CAP_HYPERV_CPUID)) {
 		print_skip("KVM_CAP_HYPERV_CPUID not supported");
 		exit(KSFT_SKIP);
 	}
 
-	for (stage = 0; stage < 3; stage++) {
-		evmcs_enabled = false;
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-		vm = vm_create_default(VCPU_ID, 0, guest_code);
-		switch (stage) {
-		case 0:
-			test_hv_cpuid_e2big(vm);
-			continue;
-		case 1:
-			break;
-		case 2:
-			if (!nested_vmx_supported() ||
-			    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-				print_skip("Enlightened VMCS is unsupported");
-				continue;
-			}
-			vcpu_enable_evmcs(vm, VCPU_ID);
-			evmcs_enabled = true;
-			break;
-		}
+	/* Test vCPU ioctl version */
+	test_hv_cpuid_e2big(vm, false);
+
+	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, false);
+	test_hv_cpuid(hv_cpuid_entries, false);
+	free(hv_cpuid_entries);
 
-		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled);
-		free(hv_cpuid_entries);
-		kvm_vm_free(vm);
+	if (!nested_vmx_supported() ||
+	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+		print_skip("Enlightened VMCS is unsupported");
+		goto do_sys;
 	}
+	vcpu_enable_evmcs(vm, VCPU_ID);
+	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, false);
+	test_hv_cpuid(hv_cpuid_entries, true);
+	free(hv_cpuid_entries);
+
+do_sys:
+	/* Test system ioctl version */
+	if (!kvm_check_cap(KVM_CAP_SYS_HYPERV_CPUID)) {
+		print_skip("KVM_CAP_SYS_HYPERV_CPUID not supported");
+		goto out;
+	}
+
+	test_hv_cpuid_e2big(vm, true);
+
+	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, true);
+	test_hv_cpuid(hv_cpuid_entries, nested_vmx_supported());
+	free(hv_cpuid_entries);
+
+out:
+	kvm_vm_free(vm);
 
 	return 0;
 }
-- 
2.25.4

