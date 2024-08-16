Return-Path: <kvm+bounces-24388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FA8954AAC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030981C20A17
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929AE1BB691;
	Fri, 16 Aug 2024 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnjrmpUD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213341B9B4E
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723813311; cv=none; b=mVtSeg3zt8QCLVnaiTdLNhWEJxWj1PV/q2d/5ne2wwfthT7F9r/oC+1Vszwe/mpG4q87XPIgsT3NlIbsQh4vU7+0LtNwmXqojxmuex1RE22PFoQCb/pgV2S96IuFLTIg0TgHivq2zfV6Um0Z+ozOjJM1MzAUN2F5AC0/LCaIy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723813311; c=relaxed/simple;
	bh=mEgP2tc3vMFcEK8rKTT6ilkOYcPdY4qHPG0naGjwrf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YppwNy9FVi8kCpJ5Cn2Vyo8hbQknj4ReAEpuqZgenbIo4j4t0iR1vozqoJHxU+tOmkQ1jDqHyVtna9UBj5UOJXI2R+mv98m0ozgXMAV0IGEsLByQtRA+/+dLZtp5f/qQqkQQiSz4uSDhoggnqH4h5orsgOaa9KzDHp1ihSUNw3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnjrmpUD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723813309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRywQ20dieOYbE4TiZ0Np1Bbhp1CoMBBM+YIuAbOks0=;
	b=QnjrmpUDsltin25gmo1Cg5kjYS28r4YRVhUmJSXt0kiANNoSis+muN3Dqw1VfhKCNjNx/K
	mbLvEWjBW86wrqNzWMoaeQl1dElFXdCNHgJue1Inj1xjW7g4NnBblK9IBlNZu0Kv8h7W7G
	Zt0/USjbCrbiFR7sVvU2JN8lbHy3e7o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-56EMdacBMvydTfdlKV91-g-1; Fri,
 16 Aug 2024 09:01:47 -0400
X-MC-Unique: 56EMdacBMvydTfdlKV91-g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE3271955F3B;
	Fri, 16 Aug 2024 13:01:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.56])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0467F1955F38;
	Fri, 16 Aug 2024 13:01:44 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Re-enable hyperv_evmcs/hyperv_svm_test on bare metal
Date: Fri, 16 Aug 2024 15:01:39 +0200
Message-ID: <20240816130139.286246-3-vkuznets@redhat.com>
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

KVM_CAP_HYPERV_DIRECT_TLBFLUSH is only reported when KVM runs on top of
Hyper-V and hyperv_evmcs/hyperv_svm_test don't need that, these tests check
that the feature is properly emulated for Hyper-V on KVM guests. There's no
corresponding CAP for that, the feature is reported in
KVM_GET_SUPPORTED_HV_CPUID.

Hyper-V specific CPUIDs are not reported by KVM_GET_SUPPORTED_CPUID,
implement dedicated kvm_hv_cpu_has() helper to do the job.

Fixes: 6dac1195181c ("KVM: selftests: Make Hyper-V tests explicitly require KVM Hyper-V support")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/x86_64/hyperv.h  | 14 ++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/hyperv.c    |  8 ++++++++
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |  2 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index a2e7cf7ee0ad..6849e2552f1b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -186,6 +186,18 @@
 #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		\
 	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 14)
 
+/* HYPERV_CPUID_NESTED_FEATURES.EAX */
+#define HV_X64_NESTED_DIRECT_FLUSH			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_NESTED_FEATURES, 0, EAX, 17)
+#define HV_X64_NESTED_GUEST_MAPPING_FLUSH		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_NESTED_FEATURES, 0, EAX, 18)
+#define HV_X64_NESTED_MSR_BITMAP			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_NESTED_FEATURES, 0, EAX, 19)
+
+/* HYPERV_CPUID_NESTED_FEATURES.EBX */
+#define HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_NESTED_FEATURES, 0, EBX, 0)
+
 /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
 #define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	\
 	KVM_X86_CPU_FEATURE(HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0, EAX, 1)
@@ -347,4 +359,6 @@ const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
 const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
 void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
 
+bool kvm_hv_cpu_has(struct kvm_x86_cpu_feature feature);
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
index b4a5e4ad7105..15bc8cd583aa 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
@@ -67,6 +67,14 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 	return cpuid;
 }
 
+bool kvm_hv_cpu_has(struct kvm_x86_cpu_feature feature)
+{
+	if (!kvm_has_cap(KVM_CAP_SYS_HYPERV_CPUID))
+		return false;
+
+	return kvm_cpuid_has(kvm_get_supported_hv_cpuid(), feature);
+}
+
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 						       vm_vaddr_t *p_hv_pages_gva)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index e192720bfe14..74cf19661309 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -242,7 +242,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
+	TEST_REQUIRE(kvm_hv_cpu_has(HV_X64_NESTED_DIRECT_FLUSH));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index b987a3d79715..0ddb63229bcb 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -157,7 +157,7 @@ int main(int argc, char *argv[])
 	int stage;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
+	TEST_REQUIRE(kvm_hv_cpu_has(HV_X64_NESTED_DIRECT_FLUSH));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-- 
2.46.0


