Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B967B48D920
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiAMNho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:37:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235315AbiAMNhi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:37:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKl9dqNtRiuczztGy7zGVwQxTRwX0J1T5ysoMppY1LQ=;
        b=d5cyVdWRCfeeJq0UNsTnu4Ebd/m7HENDpkSlrhUxRDL520HwoTNbcrDA5NVvJd05Yd4SGA
        WgKRoEPxEhuKylZK+PeDEaygJl+RtZ1duxowmh4liGlU48BZeYtD8FUnYXkLsHFM+ozVGm
        D/AMgsD0+MpTbmrmG4u4RwOJG6NcvZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-1WTTa-T6PQCnR-kJZSwEeg-1; Thu, 13 Jan 2022 08:37:33 -0500
X-MC-Unique: 1WTTa-T6PQCnR-kJZSwEeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD75F14759;
        Thu, 13 Jan 2022 13:37:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D2C884A1C;
        Thu, 13 Jan 2022 13:37:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
Date:   Thu, 13 Jan 2022 14:37:03 +0100
Message-Id: <20220113133703.1976665-6-vkuznets@redhat.com>
In-Reply-To: <20220113133703.1976665-1-vkuznets@redhat.com>
References: <20220113133703.1976665-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM keeps an allowlist of things which can be changed with
KVM_SET_CPUID2 after KVM_RUN was performed on a vCPU, changing all
other entries is forbidden. Test this.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++-
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 78 +++++++++++++++++++
 3 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 05e65ca1c30c..5a3a4809b49a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -358,6 +358,8 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index);
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
+int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_cpuid2 *cpuid);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_cpuid2 *cpuid);
 
@@ -401,6 +403,11 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
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
index eef7b34756d5..6441b03c46a9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -847,6 +847,17 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
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
@@ -864,12 +875,9 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
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
 
@@ -1337,6 +1345,23 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
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
index a711f83749ea..8ed09772a741 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -154,6 +154,82 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 	return guest_cpuids;
 }
 
+static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
+{
+	struct kvm_cpuid_entry2 *e;
+	int i;
+
+	for (i = 0; i < nent; i++) {
+		e = &entries[i];
+
+		if (e->function == function &&
+		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
+			return e;
+	}
+
+	return NULL;
+}
+
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
+	/* Changing initial APIC id is allowed */
+	ent = get_cpuid(cpuid, 0x1, 0);
+	x = ent->ebx >> 24;
+	ent->ebx = (ent->ebx & ~0xff000000u) | (x + 2) << 24;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(!rc, "Changing initial APIC id failed: %d", rc);
+
+	/* Changing other bits in CPUID.01H is forbidden */
+	eax = ent->eax;
+	ebx = ent->ebx;
+	ent->eax++;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing CPUID.01H.EAX should fail");
+	ent->eax = eax;
+	ent->ebx++;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing lower bits of CPUID.01H.EBX should fail");
+	ent->ebx = ebx;
+
+	/* Changing x2APIC id is allowed */
+	ent = get_cpuid(cpuid, 0xb, 0);
+	ent->edx += 2;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(!rc, "Changing x2APIC id failed: %d", rc);
+
+	/* Changing MAXPHYADDR is forbidden */
+	ent = get_cpuid(cpuid, 0x80000008, 0);
+	eax = ent->eax;
+	x = eax & 0xff;
+	ent->eax = (eax & ~0xffu) | (x - 1);
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
+	ent->eax = eax;
+
+	/* Changing processor serial number is allowed */
+	ent = get_cpuid(cpuid, 0x3, 0);
+	ent->ecx += 1;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(!rc, "Changing processor serial number failed: %d", rc);
+
+	/* Changing CPU features is forbidden */
+	ent = get_cpuid(cpuid, 0x7, 0);
+	ebx = ent->ebx;
+	ent->ebx--;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing CPU features should fail");
+	ent->ebx = ebx;
+}
+
 int main(void)
 {
 	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
@@ -175,5 +251,7 @@ int main(void)
 	for (stage = 0; stage < 3; stage++)
 		run_vcpu(vm, VCPU_ID, stage);
 
+	set_cpuid_after_run(vm, cpuid2);
+
 	kvm_vm_free(vm);
 }
-- 
2.34.1

