Return-Path: <kvm+bounces-24389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEC1954AAE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C946DB2244F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEA51BB6AE;
	Fri, 16 Aug 2024 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZ/UszGP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CC1B9B5B
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723813312; cv=none; b=JFLpRaJZUa1pAqHc0KIfIjFrCoFBDl7aro7P/5+iWoGKh/k9EZqZ1X04Fbv6xIW/5N5viy1LlYIuEsonpsBxbHEj7g/WwahAmoggWABHICz820YT4Ax6VN/W9sBvCsj0SSi/S5ZpckrS0RzQaS8TmY0dy8Y1klyBLjge1oEBB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723813312; c=relaxed/simple;
	bh=qhcu/p5Y0lVrlCoBtAiCYXExYbh2SsjI4qZ3YCL89Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oal/mCFbLtzrN6ZyCvbIiyqG1R025c+t0Bn5cne3asiQqourD65rKSP+FmiqHzSxwBFRhjXvc1gmCGwJECHiNJ7rfWgiBAMiOo4gJZlBHs5gBTc4rK5cC21yAEu+RUCQswnaZ58wO00Fj64Yenzv8FhZuDyISh1SzIunsado2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZ/UszGP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723813309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ivNWicyJPF/QCcWPJiS3wxzNpcxW21UvmpukcvdAFw=;
	b=FZ/UszGPADjp5X7Il3P4+yV7ue0WMSXM/2A2lVIAjq5CVu8IVTg/YcMyNMymwBBqEGXwzJ
	nMf7yaPpgsAUstlNLYPMlNEvVq8hnkli4Pf2oJiSLrvIGhs/Vj0jXx1n9hUKi1YszXiOrg
	eV9WHfOzCJ/mdowfZMkAKFDMhyLbbTE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-beRk_kLXOA29hJ48KCDtHw-1; Fri,
 16 Aug 2024 09:01:45 -0400
X-MC-Unique: beRk_kLXOA29hJ48KCDtHw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C722A1955BFC;
	Fri, 16 Aug 2024 13:01:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.56])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E94351955F35;
	Fri, 16 Aug 2024 13:01:42 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: Move Hyper-V specific functions out of processor.c
Date: Fri, 16 Aug 2024 15:01:38 +0200
Message-ID: <20240816130139.286246-2-vkuznets@redhat.com>
In-Reply-To: <20240816130139.286246-1-vkuznets@redhat.com>
References: <20240816130139.286246-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Since there is 'hyperv.c' for Hyper-V specific functions already, move
Hyper-V specific functions out of processor.c there.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     |  4 ++
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++-
 .../testing/selftests/kvm/lib/x86_64/hyperv.c | 59 ++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 61 -------------------
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  1 +
 5 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index fa65b908b13e..a2e7cf7ee0ad 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -343,4 +343,8 @@ struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 /* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
 #define HV_INVARIANT_TSC_EXPOSED               BIT_ULL(0)
 
+const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
+const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
+void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a0c1440017bb..e247f99e0473 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -25,6 +25,10 @@ extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 extern uint64_t guest_tsc_khz;
 
+#ifndef MAX_NR_CPUID_ENTRIES
+#define MAX_NR_CPUID_ENTRIES 100
+#endif
+
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 
@@ -908,8 +912,6 @@ static inline void vcpu_xcrs_set(struct kvm_vcpu *vcpu, struct kvm_xcrs *xcrs)
 const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 					       uint32_t function, uint32_t index);
 const struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
-const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
-const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
 
 static inline uint32_t kvm_cpu_fms(void)
 {
@@ -1009,7 +1011,6 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 }
 
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
-void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
 
 static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
 							      uint32_t function,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
index efb7e7a1354d..b4a5e4ad7105 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
@@ -8,6 +8,65 @@
 #include "processor.h"
 #include "hyperv.h"
 
+const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid;
+	int kvm_fd;
+
+	if (cpuid)
+		return cpuid;
+
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	kvm_fd = open_kvm_dev_path_or_exit();
+
+	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+
+	close(kvm_fd);
+	return cpuid;
+}
+
+void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
+{
+	static struct kvm_cpuid2 *cpuid_full;
+	const struct kvm_cpuid2 *cpuid_sys, *cpuid_hv;
+	int i, nent = 0;
+
+	if (!cpuid_full) {
+		cpuid_sys = kvm_get_supported_cpuid();
+		cpuid_hv = kvm_get_supported_hv_cpuid();
+
+		cpuid_full = allocate_kvm_cpuid2(cpuid_sys->nent + cpuid_hv->nent);
+		if (!cpuid_full) {
+			perror("malloc");
+			abort();
+		}
+
+		/* Need to skip KVM CPUID leaves 0x400000xx */
+		for (i = 0; i < cpuid_sys->nent; i++) {
+			if (cpuid_sys->entries[i].function >= 0x40000000 &&
+			    cpuid_sys->entries[i].function < 0x40000100)
+				continue;
+			cpuid_full->entries[nent] = cpuid_sys->entries[i];
+			nent++;
+		}
+
+		memcpy(&cpuid_full->entries[nent], cpuid_hv->entries,
+		       cpuid_hv->nent * sizeof(struct kvm_cpuid_entry2));
+		cpuid_full->nent = nent + cpuid_hv->nent;
+	}
+
+	vcpu_init_cpuid(vcpu, cpuid_full);
+}
+
+const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid2 *cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+
+	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+
+	return cpuid;
+}
+
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 						       vm_vaddr_t *p_hv_pages_gva)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 153739f2e201..7876f052ca39 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -19,8 +19,6 @@
 #define KERNEL_DS	0x10
 #define KERNEL_TSS	0x18
 
-#define MAX_NR_CPUID_ENTRIES 100
-
 vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
@@ -1195,65 +1193,6 @@ void xen_hypercall(uint64_t nr, uint64_t a0, void *a1)
 	GUEST_ASSERT(!__xen_hypercall(nr, a0, a1));
 }
 
-const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
-{
-	static struct kvm_cpuid2 *cpuid;
-	int kvm_fd;
-
-	if (cpuid)
-		return cpuid;
-
-	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
-	kvm_fd = open_kvm_dev_path_or_exit();
-
-	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
-
-	close(kvm_fd);
-	return cpuid;
-}
-
-void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
-{
-	static struct kvm_cpuid2 *cpuid_full;
-	const struct kvm_cpuid2 *cpuid_sys, *cpuid_hv;
-	int i, nent = 0;
-
-	if (!cpuid_full) {
-		cpuid_sys = kvm_get_supported_cpuid();
-		cpuid_hv = kvm_get_supported_hv_cpuid();
-
-		cpuid_full = allocate_kvm_cpuid2(cpuid_sys->nent + cpuid_hv->nent);
-		if (!cpuid_full) {
-			perror("malloc");
-			abort();
-		}
-
-		/* Need to skip KVM CPUID leaves 0x400000xx */
-		for (i = 0; i < cpuid_sys->nent; i++) {
-			if (cpuid_sys->entries[i].function >= 0x40000000 &&
-			    cpuid_sys->entries[i].function < 0x40000100)
-				continue;
-			cpuid_full->entries[nent] = cpuid_sys->entries[i];
-			nent++;
-		}
-
-		memcpy(&cpuid_full->entries[nent], cpuid_hv->entries,
-		       cpuid_hv->nent * sizeof(struct kvm_cpuid_entry2));
-		cpuid_full->nent = nent + cpuid_hv->nent;
-	}
-
-	vcpu_init_cpuid(vcpu, cpuid_full);
-}
-
-const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid2 *cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
-
-	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
-
-	return cpuid;
-}
-
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index e149d0574961..2585087cdf5c 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -10,6 +10,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "hyperv.h"
 
 #define HCALL_REGION_GPA	0xc0000000ULL
 #define HCALL_REGION_SLOT	10
-- 
2.46.0


