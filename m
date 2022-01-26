Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF61849CDEA
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242743AbiAZPWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:22:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242711AbiAZPWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mdi1x6oMBIyjGligUHuX1SgRn3QEMz4lIBHFRWbBweM=;
        b=CXfWXqsiyoL0/zflV9JdsP5iE6DK0+7sBVNUKihrwG8C5etzuavbUNKBdnu1NK2+KeWQnY
        b8wZTxMo0FDkj8k+YNKny67911wiykXp59xYT5mGv48t/Zvd+RwSKQnLqil6ymd3Ivcfbp
        N+qGfJGDVt7H8pYYiD7K5LykRtyUP14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-KwROlKd1NIyszrJ9_hw3GQ-1; Wed, 26 Jan 2022 10:22:15 -0500
X-MC-Unique: KwROlKd1NIyszrJ9_hw3GQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A50831937FF8;
        Wed, 26 Jan 2022 15:22:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD3C034D5C;
        Wed, 26 Jan 2022 15:22:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yang.zhong@intel.com, seanjc@google.com
Subject: [PATCH 1/3] selftests: kvm: move vm_xsave_req_perm call to amx_test
Date:   Wed, 26 Jan 2022 10:22:08 -0500
Message-Id: <20220126152210.3044876-2-pbonzini@redhat.com>
In-Reply-To: <20220126152210.3044876-1-pbonzini@redhat.com>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need for tests other than amx_test to enable dynamic xsave
states.  Remove the call to vm_xsave_req_perm from generic code,
and move it inside the test.  While at it, allow customizing the bit
that is requested, so that future tests can use it differently.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h  |  1 -
 .../testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c           |  7 -------
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 12 ++++++------
 tools/testing/selftests/kvm/x86_64/amx_test.c        |  2 ++
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 66775de26952..4ed6aa049a91 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -345,7 +345,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
  *   guest_code - The vCPU's entry point
  */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
-void vm_xsave_req_perm(void);
 
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 423d8a61bd2e..8a470da7b71a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -458,6 +458,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
 void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
+void vm_xsave_req_perm(int bit);
 
 enum x86_page_size {
 	X86_PAGE_SIZE_4K = 0,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8c53f96ab7fe..d8cf851ab119 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -393,13 +393,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	struct kvm_vm *vm;
 	int i;
 
-#ifdef __x86_64__
-	/*
-	 * Permission needs to be requested before KVM_SET_CPUID2.
-	 */
-	vm_xsave_req_perm();
-#endif
-
 	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
 	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
 		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5f9d7e91dc69..c1d1c195a838 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -665,16 +665,16 @@ static bool is_xfd_supported(void)
 	return !!(eax & CPUID_XFD_BIT);
 }
 
-void vm_xsave_req_perm(void)
+void vm_xsave_req_perm(int bit)
 {
-	unsigned long bitmask;
+	u64 bitmask;
 	long rc;
 
 	if (!is_xfd_supported())
-		return;
+		exit(KSFT_SKIP);
+
+	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
 
-	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM,
-		     XSTATE_XTILE_DATA_BIT);
 	/*
 	 * The older kernel version(<5.15) can't support
 	 * ARCH_REQ_XCOMP_GUEST_PERM and directly return.
@@ -684,7 +684,7 @@ void vm_xsave_req_perm(void)
 
 	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
 	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
-	TEST_ASSERT(bitmask & XFEATURE_XTILE_MASK,
+	TEST_ASSERT(bitmask & (1ULL << bit),
 		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
 		    bitmask);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 523c1e99ed64..52a3ef6629e8 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -329,6 +329,8 @@ int main(int argc, char *argv[])
 	u32 amx_offset;
 	int stage, ret;
 
+	vm_xsave_req_perm(XSTATE_XTILE_DATA_BIT);
+
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-- 
2.31.1


