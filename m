Return-Path: <kvm+bounces-41580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA94A6AB7B
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0611882F2E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1643D2222DC;
	Thu, 20 Mar 2025 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GqmNcf7Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBEA19DF98
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489555; cv=none; b=CFtt59S+bwE0NSfFZjCsB8ml2OTQfc7M9ARWXaXmP6ZmGTStcyqafUpQq2OpMjhHpBZ1b5KFMuxrV/h1Yk2gB7Gwvj/qXbld2wAfOuiEWVq7eEqlyojS9Nl78y2TlQrUD4VU51x95UKl6234hdKZFhNi29eVaPhjFP1QbI6MxZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489555; c=relaxed/simple;
	bh=3CI9YipprVUzL0Kji7dVW+X1XdK3NU/y9ltxvkCpwng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=teFCjd7lo2kq0SE9OcA4NG7vOie5H86EEScxkOj50cybXiFCaI/4xQvKlfclGl3CX5A++gN6iHBZrB7QzMdoJrOoYbgeEglFP3Uetq2lP7JXhrO2bGpczh1l3n/6fdVXyWLk4sQpb/YoVOg/zxGAm/Sw2raQCWdlvwtlb3O9+is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GqmNcf7Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742489551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IVqw8/qQcOmwQTYiX8xmhrO8bBtQ3X5RcfmC2PptBrg=;
	b=GqmNcf7QaSUCs9OIE6J+aYD5SSD5U6+1o3OlzHJ2HLasyIMo/3PYHvPZj0A6GZACUXf9gQ
	7zl90VBzv6hpKEQnI+TNHEd3J/HZr+VpNcKXRrp4KAL+5jb76LjXXr38YAn5MkYj/QroXb
	LfTOwo7UV9HXZfBhUVV3xorSAdRv/Co=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-H8Tv2R1PP8awqX9J8PHVjg-1; Thu,
 20 Mar 2025 12:52:27 -0400
X-MC-Unique: H8Tv2R1PP8awqX9J8PHVjg-1
X-Mimecast-MFC-AGG-ID: H8Tv2R1PP8awqX9J8PHVjg_1742489546
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0858C1944F0A;
	Thu, 20 Mar 2025 16:52:26 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 698CA1955BFE;
	Thu, 20 Mar 2025 16:52:25 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH] selftests: kvm: revamp MONITOR/MWAIT tests
Date: Thu, 20 Mar 2025 12:52:24 -0400
Message-ID: <20250320165224.144373-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Run each testcase in a separate VMs to cover more possibilities;
move WRMSR close to MONITOR/MWAIT to test updating CPUID bits
while in the VM.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86/monitor_mwait_test.c    | 108 +++++++++---------
 1 file changed, 57 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 2b550eff35f1..390ae2d87493 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -7,6 +7,7 @@
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "kselftest.h"
 
 #define CPUID_MWAIT (1u << 3)
 
@@ -14,6 +15,8 @@ enum monitor_mwait_testcases {
 	MWAIT_QUIRK_DISABLED = BIT(0),
 	MISC_ENABLES_QUIRK_DISABLED = BIT(1),
 	MWAIT_DISABLED = BIT(2),
+	CPUID_DISABLED = BIT(3),
+	TEST_MAX = CPUID_DISABLED * 2 - 1,
 };
 
 /*
@@ -35,11 +38,19 @@ do {									\
 			       testcase, vector);			\
 } while (0)
 
-static void guest_monitor_wait(int testcase)
+static void guest_monitor_wait(void *arg)
 {
+	int testcase = (int) (long) arg;
 	u8 vector;
 
-	GUEST_SYNC(testcase);
+	u64 val = rdmsr(MSR_IA32_MISC_ENABLE) & ~MSR_IA32_MISC_ENABLE_MWAIT;
+	if (!(testcase & MWAIT_DISABLED))
+		val |= MSR_IA32_MISC_ENABLE_MWAIT;
+	wrmsr(MSR_IA32_MISC_ENABLE, val);
+
+	__GUEST_ASSERT(this_cpu_has(X86_FEATURE_MWAIT) == !(testcase & MWAIT_DISABLED),
+		       "Expected CPUID.MWAIT %s\n",
+		       (testcase & MWAIT_DISABLED) ? "cleared" : "set");
 
 	/*
 	 * Arbitrarily MONITOR this function, SVM performs fault checks before
@@ -50,19 +61,6 @@ static void guest_monitor_wait(int testcase)
 
 	vector = kvm_asm_safe("mwait", "a"(guest_monitor_wait), "c"(0), "d"(0));
 	GUEST_ASSERT_MONITOR_MWAIT("MWAIT", testcase, vector);
-}
-
-static void guest_code(void)
-{
-	guest_monitor_wait(MWAIT_DISABLED);
-
-	guest_monitor_wait(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
-
-	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
-	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED);
-
-	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
-	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
 
 	GUEST_DONE();
 }
@@ -74,56 +72,64 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int testcase;
+	char test[80];
 
-	TEST_REQUIRE(this_cpu_has(X86_FEATURE_MWAIT));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
+	ksft_print_header();
+	ksft_set_plan(12);
+	for (testcase = 0; testcase <= TEST_MAX; testcase++) {
+		vm = vm_create_with_one_vcpu(&vcpu, guest_monitor_wait);
+		vcpu_args_set(vcpu, 1, (void *)(long)testcase);
+
+		disabled_quirks = 0;
+		if (testcase & MWAIT_QUIRK_DISABLED) {
+			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS;
+			strcpy(test, "MWAIT can fault");
+		} else {
+			strcpy(test, "MWAIT never faults");
+		}
+		if (testcase & MISC_ENABLES_QUIRK_DISABLED) {
+			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
+			strcat(test, ", MISC_ENABLE updates CPUID");
+		} else {
+			strcat(test, ", no CPUID updates");
+		}
+
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
+
+		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED) &&
+		    (!!(testcase & CPUID_DISABLED) ^ !!(testcase & MWAIT_DISABLED)))
+			continue;
+
+		if (testcase & CPUID_DISABLED) {
+			strcat(test, ", CPUID clear");
+			vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
+		} else {
+			strcat(test, ", CPUID set");
+			vcpu_set_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
+		}
+
+		if (testcase & MWAIT_DISABLED)
+			strcat(test, ", MWAIT disabled");
 
-	while (1) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_SYNC:
-			testcase = uc.args[1];
-			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT(uc);
-			goto done;
+			/* Detected in vcpu_run */
+			break;
 		case UCALL_DONE:
-			goto done;
+			ksft_test_result_pass("%s\n", test);
+			break;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
-			goto done;
+			break;
 		}
-
-		disabled_quirks = 0;
-		if (testcase & MWAIT_QUIRK_DISABLED)
-			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS;
-		if (testcase & MISC_ENABLES_QUIRK_DISABLED)
-			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
-		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
-
-		/*
-		 * If the MISC_ENABLES quirk (KVM neglects to update CPUID to
-		 * enable/disable MWAIT) is disabled, toggle the ENABLE_MWAIT
-		 * bit in MISC_ENABLES accordingly.  If the quirk is enabled,
-		 * the only valid configuration is MWAIT disabled, as CPUID
-		 * can't be manually changed after running the vCPU.
-		 */
-		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED)) {
-			TEST_ASSERT(testcase & MWAIT_DISABLED,
-				    "Can't toggle CPUID features after running vCPU");
-			continue;
-		}
-
-		vcpu_set_msr(vcpu, MSR_IA32_MISC_ENABLE,
-			     (testcase & MWAIT_DISABLED) ? 0 : MSR_IA32_MISC_ENABLE_MWAIT);
+		kvm_vm_free(vm);
 	}
+	ksft_finished();
 
-done:
-	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.43.5


