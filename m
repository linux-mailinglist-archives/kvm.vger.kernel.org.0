Return-Path: <kvm+bounces-13558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD5C8986FA
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F451F286F9
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623F712C7F7;
	Thu,  4 Apr 2024 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MuPF21G+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A5E12882F
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232820; cv=none; b=LJcJXHfCO5I3sAxLvjyJzm37FRHMuCZAjRugVILXOLszUo9Hl7RTID6CMN+wXv4t1+RhAKTUCcX4PmFSlKNqE25gKhiJ23xz+GSSDjVaDrmmwdv+A4/Fg+yXbnV8X6ioN6b8tXbnO50G/0Ucf5v2vko1MTJg5+6CRidUWC1a4W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232820; c=relaxed/simple;
	bh=4rYSe/0b2YWlMT+jL7AFg0DaRcpMVxRynPPBo/RQ1Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U7MGx9OgRB0eCXWQ38hNs1WKYoiaTc++KBN2Lc1kSS6zmzXGKcXf/Wk2b5y+d3raog5y+RDyygWv/7bsEoiu0SGt8Vq6V8jlCXav2aoTbaE46D4N1AqvY130B8mMUht4c7JcdKtcpI+8ICVlrathCG5E4npCekjxPh2B3xadW68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MuPF21G+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZnn0GoKtYMCAOrEB74QbMNI9YYQjLw/KqwC1+gIE5s=;
	b=MuPF21G+C4st2e/LIrnTZmYLawoo3MiIbpINF1ANYM2SHQziada5Hhs8lxtorLuC7uwoAm
	Y39LtiXjFJqeC6CpKhGDZ2w2zYHqTbLVjiIXu2G+4/r/bFMtZjqP2vW2B3eBUMCw3JA9r5
	IXB9xcXklO1hZDcVSjhxof7LhbnN7NA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-SEV7f9GIP5KXtdH39FfcaQ-1; Thu, 04 Apr 2024 08:13:31 -0400
X-MC-Unique: SEV7f9GIP5KXtdH39FfcaQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9461780A1A8;
	Thu,  4 Apr 2024 12:13:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72083492BC6;
	Thu,  4 Apr 2024 12:13:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 17/17] selftests: kvm: add test for transferring FPU state into VMSA
Date: Thu,  4 Apr 2024 08:13:27 -0400
Message-ID: <20240404121327.3107131-18-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 234c80dd344d..7c70c0da4fb7 100644
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
@@ -35,6 +38,86 @@ static void guest_sev_code(void)
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
+	asm("fninit\n"
+	    "vpcmpeqb %%ymm4, %%ymm4, %%ymm4\n"
+	    "fldl %3\n"
+	    "xsave (%2)\n"
+	    "fstp %%st\n"
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
@@ -87,6 +170,12 @@ int main(int argc, char *argv[])
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


