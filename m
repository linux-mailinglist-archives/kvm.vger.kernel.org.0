Return-Path: <kvm+bounces-12179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE89880599
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 20:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F59828460E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F5C3B298;
	Tue, 19 Mar 2024 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2jmdtLS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329739FD8
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877445; cv=none; b=qmP7OWO0QT0DoAER44TSwCc8bB1wacH/U3YxPrHLyL7N/MvEXWOxzgMZXmYsv4FUtfL0dbq5nqWEgX8JXwPO3fsWcFoO1BImnvTk2UQRFboyY1M2S+NikU6VZ9W7K8InQJ1ja07fDkhQPkeh1tAXJOgTfc3UrtX88xuYx86pEG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877445; c=relaxed/simple;
	bh=+TVomNYPOhBFEc8qSZQLdPOeHv8z7BBsGPXWAiK/ybo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxvXANChh5P6WniNlgdIA0Q6v40XSsfOZbXn/kRuT765h9ZuHefKVfefKyw+yUYV9FFzZIqF1FzkxRdYZBD8ki9mtMMeqEhUCV+I/Yn0ULBq5tQ50JAK8ucfFUe9iVfjWV2FD7qfn2TYzexqTXP13tWdNDTJvK7OZaEToUgG/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2jmdtLS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710877442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=258pWO0RU/vVKXiGENv+hyJ/QCdoen7rXCx5gFfg1EU=;
	b=I2jmdtLSzCKfkNdjIozOl4LbknX7pXrsXiO0KHPLbJiW+KFPrG8MZtf9ApqM18DiDFa9cu
	UrSGxF+zVhsLTxC74beKHzuXw9bEV/keOqTrGvgZdqb122HuCV74omRZtcYUq+KtOo2o6J
	6LaAzt2jOIiwsOSBKNVgIWwKIfEcOoQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-T3QF8IkFPKGpEkWuB_W09A-1; Tue,
 19 Mar 2024 15:43:58 -0400
X-MC-Unique: T3QF8IkFPKGpEkWuB_W09A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C73E2932487;
	Tue, 19 Mar 2024 19:43:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B200492BC8;
	Tue, 19 Mar 2024 19:43:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH v4 18/15] selftests: kvm: add test for transferring FPU state into the VMSA
Date: Tue, 19 Mar 2024 15:43:57 -0400
Message-ID: <20240319194357.2766768-3-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Test that CRn, XCR0 and FPU state are correctly moved from KVM's internal
state to the VMSA by SEV_LAUNCH_UPDATE_VMSA.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 234c80dd344d..195150bc5013 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -4,6 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <math.h>
 
 #include "test_util.h"
 #include "kvm_util.h"
@@ -13,6 +14,8 @@
 #include "sev.h"
 
 
+#define XFEATURE_MASK_X87_AVX (XFEATURE_MASK_FP | XFEATURE_MASK_SSE | XFEATURE_MASK_YMM)
+
 static void guest_sev_es_code(void)
 {
 	/* TODO: Check CPUID after GHCB-based hypercall support is added. */
@@ -35,6 +38,84 @@ static void guest_sev_code(void)
 	GUEST_DONE();
 }
 
+/* Stash state passed via VMSA before any compiled code runs.  */
+extern void guest_code_xsave(void);
+asm("guest_code_xsave:\n"
+    "mov $-1, %eax\n"
+    "mov $-1, %edx\n"
+    "xsave (%rdi)\n"
+    "jmp guest_sev_es_code");
+
+static void compare_xsave(u8 *from_host, u8 *from_guest)
+{
+	int i;
+	bool bad = false;
+	for (i = 0; i < 4095; i++) {
+		if (from_host[i] != from_guest[i]) {
+			printf("mismatch at %02hhx | %02hhx %02hhx\n", i, from_host[i], from_guest[i]);
+			bad = true;
+		}
+	}
+
+	if (bad)
+		abort();
+}
+
+static void test_sync_vmsa(uint32_t policy)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t gva;
+	void *hva;
+
+	double x87val = M_PI;
+	struct kvm_xsave __attribute__((aligned(64))) xsave = { 0 };
+	struct kvm_sregs sregs;
+	struct kvm_xcrs xcrs = {
+		.nr_xcrs = 1,
+		.xcrs[0].xcr = 0,
+		.xcrs[0].value = XFEATURE_MASK_X87_AVX,
+	};
+
+	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_code_xsave, &vcpu);
+	gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
+				    MEM_REGION_TEST_DATA);
+	hva = addr_gva2hva(vm, gva);
+
+	vcpu_args_set(vcpu, 1, gva);
+
+	vcpu_sregs_get(vcpu, &sregs);
+	sregs.cr4 |= X86_CR4_OSFXSR | X86_CR4_OSXSAVE;
+	vcpu_sregs_set(vcpu, &sregs);
+
+	vcpu_xcrs_set(vcpu, &xcrs);
+	asm("fninit; fldl %3\n"
+	    "vpcmpeqb %%ymm4, %%ymm4, %%ymm4\n"
+	    "xsave (%2)"
+	    : "=m"(xsave)
+	    : "A"(XFEATURE_MASK_X87_AVX), "r"(&xsave), "m" (x87val)
+	    : "ymm4", "st", "st(1)", "st(2)", "st(3)", "st(4)", "st(5)", "st(6)", "st(7)");
+	vcpu_xsave_set(vcpu, &xsave);
+
+	vm_sev_launch(vm, SEV_POLICY_ES | policy, NULL);
+
+	/* This page is shared, so make it decrypted.  */
+	memset(hva, 0, 4096);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+		    "Wanted SYSTEM_EVENT, got %s",
+		    exit_reason_str(vcpu->run->exit_reason));
+	TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+	TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+
+	compare_xsave((u8 *)&xsave, (u8 *)hva);
+
+	kvm_vm_free(vm);
+}
+
 static void test_sev(void *guest_code, uint64_t policy)
 {
 	struct kvm_vcpu *vcpu;
@@ -87,6 +168,12 @@ int main(int argc, char *argv[])
 	if (kvm_cpu_has(X86_FEATURE_SEV_ES)) {
 		test_sev(guest_sev_es_code, SEV_POLICY_ES | SEV_POLICY_NO_DBG);
 		test_sev(guest_sev_es_code, SEV_POLICY_ES);
+
+		if (kvm_has_cap(KVM_CAP_XCRS) &&
+		    (xgetbv(0) & XFEATURE_MASK_X87_AVX) == XFEATURE_MASK_X87_AVX) {
+			test_sync_vmsa(0);
+			test_sync_vmsa(SEV_POLICY_NO_DBG);
+		}
 	}
 
 	return 0;
-- 
2.43.0


