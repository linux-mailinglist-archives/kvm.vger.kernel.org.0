Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B5490B25
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbiAQPGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:06:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240410AbiAQPGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642431964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bLFvUw5OiL0PwWN1RfLYJMbRWgda2rw0vcjqVwdGBw4=;
        b=QGtnUBJFkKpIt3/4YZ90fzwsg7++mcHSWCGWvtWiTxZEVfEUZ3bR7t8NGrGRs7ZpMrKZHn
        Jhg6lyqwdkbKOqyiP+8uRA1dJFiHF526WMw+kMDrr+e6FJl32ZxVqOpp+CwvPi5+GKmMhb
        srI262JwKrBS4trpbw8+UErAEkSaImw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-O1HyghfuMAqfNzHzVDjykw-1; Mon, 17 Jan 2022 10:06:01 -0500
X-MC-Unique: O1HyghfuMAqfNzHzVDjykw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D65241083F64;
        Mon, 17 Jan 2022 15:05:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7D6A2B59F;
        Mon, 17 Jan 2022 15:05:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
Date:   Mon, 17 Jan 2022 16:05:42 +0100
Message-Id: <20220117150542.2176196-5-vkuznets@redhat.com>
In-Reply-To: <20220117150542.2176196-1-vkuznets@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM forbids KVM_SET_CPUID2 after KVM_RUN was performed on a vCPU unless
the supplied CPUID data is equal to what was previously set. Test this.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++++++++++++---
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 30 +++++++++++++++++
 3 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e94ba0fc67d8..bb013d101c14 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -375,6 +375,8 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index);
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
+int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_cpuid2 *cpuid);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_cpuid2 *cpuid);
 
@@ -418,6 +420,11 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
 			     uint64_t pte);
 
+/*
+ * get_cpuid() - find matching CPUID entry and return pointer to it.
+ */
+struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
+				   uint32_t index);
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index babb0f28575c..d61e2326dc85 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -886,6 +886,17 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
 	return entry;
 }
 
+
+int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_cpuid2 *cpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	return ioctl(vcpu->fd, KVM_SET_CPUID2, cpuid);
+}
+
 /*
  * VM VCPU CPUID Set
  *
@@ -903,12 +914,9 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
 void vcpu_set_cpuid(struct kvm_vm *vm,
 		uint32_t vcpuid, struct kvm_cpuid2 *cpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int rc;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	rc = ioctl(vcpu->fd, KVM_SET_CPUID2, cpuid);
+	rc = __vcpu_set_cpuid(vm, vcpuid, cpuid);
 	TEST_ASSERT(rc == 0, "KVM_SET_CPUID2 failed, rc: %i errno: %i",
 		    rc, errno);
 
@@ -1384,6 +1392,23 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 	}
 }
 
+struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
+				   uint32_t index)
+{
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
+
+		if (cur->function == function && cur->index == index)
+			return cur;
+	}
+
+	TEST_FAIL("CPUID function 0x%x index 0x%x not found ", function, index);
+
+	return NULL;
+}
+
 bool set_cpuid(struct kvm_cpuid2 *cpuid,
 	       struct kvm_cpuid_entry2 *ent)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index a711f83749ea..16d2465c5634 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -154,6 +154,34 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 	return guest_cpuids;
 }
 
+static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
+{
+	struct kvm_cpuid_entry2 *ent;
+	int rc;
+	u32 eax, ebx, x;
+
+	/* Setting unmodified CPUID is allowed */
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
+
+	/* Changing CPU features is forbidden */
+	ent = get_cpuid(cpuid, 0x7, 0);
+	ebx = ent->ebx;
+	ent->ebx--;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing CPU features should fail");
+	ent->ebx = ebx;
+
+	/* Changing MAXPHYADDR is forbidden */
+	ent = get_cpuid(cpuid, 0x80000008, 0);
+	eax = ent->eax;
+	x = eax & 0xff;
+	ent->eax = (eax & ~0xffu) | (x - 1);
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
+	ent->eax = eax;
+}
+
 int main(void)
 {
 	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
@@ -175,5 +203,7 @@ int main(void)
 	for (stage = 0; stage < 3; stage++)
 		run_vcpu(vm, VCPU_ID, stage);
 
+	set_cpuid_after_run(vm, cpuid2);
+
 	kvm_vm_free(vm);
 }
-- 
2.34.1

