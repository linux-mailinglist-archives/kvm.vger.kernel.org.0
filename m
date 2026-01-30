Return-Path: <kvm+bounces-69748-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDm6EX8GfWmpPwIAu9opvQ
	(envelope-from <kvm+bounces-69748-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 20:29:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F5CBE237
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 20:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0FC730417AD
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 19:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6326A388851;
	Fri, 30 Jan 2026 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bn1+XZmM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492C387596
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769801323; cv=none; b=RufsASMm0iX8O5R1nN/xlaxCY/OK4Evxa1SjAIQIaYyHfA0n4wDoSEhb6XRSCMORRaxtwcUTJ77jZkHtukPoa1hPR4TPGQOPksXkPlBda86wea9MIqbJotxKTNW3OkCn1FxpGcdDtsxFyJ4agbKNJj34VJSqYkvPwcbDptxl4gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769801323; c=relaxed/simple;
	bh=xha2tKLV6loVZapX6DrV2TpHDlxU/QfYCAu+9gTx3UM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=laUFOjXpuF6enIXI0ahNmAHiaXAh6mC8mvUNgqCNly+tf/Jtj1qypalOghwLsoQLiKBRDIIehzbmfisbjjeB8jGQ2UPeogni7Ln/B3cQirNXYXmgbmdJuqm0E/kuDdm6XayPMjrp3JEHlawROCzaXwriW67tzBHV4gJqRebM16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bn1+XZmM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c503d6be76fso4718425a12.0
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 11:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769801321; x=1770406121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rjy71wms5szan9FXTuTPKKlYyd/zTVsqWF/S5ag+Qgc=;
        b=Bn1+XZmM4yCpFLf3ngU8Q7fgoD+jgdcNYJ4UGxvD4K80SbUs3jNXMwh9hztVmurzG/
         sY7/PybZq/hw6lRjkdKzTiMq2t8ZwW3+GU6xLyVQkSyM3L1SoQl4fouqsvfMUuWNARcQ
         A7H4UXMeoyZk+cN6KmU0yIuu5Lb6rw0h0FxHTtb2O40QXT+rNpuq16y9w0aoVgdGEmXz
         h9fM3lj0lCe5o/0pYSZwa4JYs7MVscyppP/BK6lMnP/RSdUiGm15JJtGyPqQuYgfWi5E
         ChSfS9tpfqGxa5xyfFLznE8z1tUadQOfOjhW+5K2nnoQS4sCh5A6FMC4GgtnQD+SQ3OX
         cUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769801321; x=1770406121;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjy71wms5szan9FXTuTPKKlYyd/zTVsqWF/S5ag+Qgc=;
        b=EPtPkwDA5MaLDY7K2W/NErXstbRlAYVKzaoLCOJZx7CJ66KatFcfJOUcreX62t2Evc
         8dcxSLX1JdTCcAexg5ZxIOPeECVaBBWiOP0pc76PeeP0amUes0I5yvDtd3ZNgviLvq/t
         fWrignFjqbudrRHDnEcg1qRhqIOS0hC+85OaQAPkhfrG43XFVy29OrhrxV3pFXr7PuwU
         vTD9jyZFMra5ChhPCm20nBTpJrCcfJspAxfwWhymBhOrH2D4VCnRgkuhwV9qQEhtHmjp
         lx7ojdkLZQ8tK7KXt4l41prSf9iiCKV8BykOwAXgcVIEtEUmHMCkrnSNLWNUV+buVR6+
         e7Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXl5V7PWWvNTqD3hyyDdzhafegkDl/8bkKmap5a7CKQ39vgkQhPaqwqX8XUaGjT9uapwIc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9vyoVWKwhbN6nzS/TBDiidjDU3MGCbBgIVRjQ5UdYwwRy0Pkv
	qy1ojan61L2fX43/45pMe7E+6dd8Xm35dPOJwPAfFMbSwo8xnK0cFbhrjC3/J8liHDJp0QYhHoC
	5KS370qXEH7J6zQ==
X-Received: from pgct22.prod.google.com ([2002:a05:6a02:5296:b0:bd9:19be:503c])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a11c:b0:38e:9d3b:470b with SMTP id adf61e73a8af0-392e01096dbmr3663945637.42.1769801321501;
 Fri, 30 Jan 2026 11:28:41 -0800 (PST)
Date: Fri, 30 Jan 2026 19:28:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260130192837.890688-1-jiaqiyan@google.com>
Subject: [PATCH v1] KVM: selftests: Improve sea_to_user test
From: Jiaqi Yan <jiaqiyan@google.com>
To: oupton@kernel.org
Cc: sebott@redhat.com, gshan@redhat.com, yuzenghui@huawei.com, maz@kernel.org, 
	rananta@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69748-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiaqiyan@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B4F5CBE237
X-Rspamd-Action: no action

Several improvments to the test for KVM_EXIT_ARM_SEA:

- Refactor run_vm to catch GUEST_FAIL, instead of causing confusing
  unhandled MMIO kvm exit.

- Sync far_invalid to guest.

- Exit test with KSFT_SKIP or KSFT_FAIL when should.

- Add comment about VM backing memory type.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c | 94 +++++++++++--------
 1 file changed, 53 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8e..4a3511fa1f940 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -12,6 +12,11 @@
  * including the notrigger feature. Otherwise the test will be skipped.
  * The under-test platform's APEI should be unable to claim SEA. Otherwise
  * the test will also be skipped.
+ *
+ * The VM backing memory is tied to HugeTLB 1G hugepage so far. Make sure
+ * there are more than 4 1G hugepage on the system. They can be allocated
+ * at runtime by:
+ *   echo 4 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
  */
 
 #include <signal.h>
@@ -98,11 +103,15 @@ static void write_einj_entry(const char *einj_path, uint64_t val)
 
 static void inject_uer(uint64_t paddr)
 {
-	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1)
-		ksft_test_result_skip("EINJ table no available in firmware");
+	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1) {
+		ksft_test_result_skip("EINJ table not available in firmware\n");
+		exit(KSFT_SKIP);
+	}
 
-	if (access(EINJ_ETYPE, R_OK | W_OK) == -1)
-		ksft_test_result_skip("EINJ module probably not loaded?");
+	if (access(EINJ_ETYPE, R_OK | W_OK) == -1) {
+		ksft_test_result_skip("EINJ module probably not loaded?\n");
+		exit(KSFT_SKIP);
+	}
 
 	write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
 	write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
@@ -123,12 +132,13 @@ static void sigbus_signal_handler(int sig, siginfo_t *si, void *v)
 	ksft_print_msg("SIGBUS (%d) received, dumping siginfo...\n", sig);
 	ksft_print_msg("si_signo=%d, si_errno=%d, si_code=%d, si_addr=%p\n",
 		       si->si_signo, si->si_errno, si->si_code, si->si_addr);
-	if (si->si_code == BUS_MCEERR_AR)
+	if (si->si_code == BUS_MCEERR_AR) {
 		ksft_test_result_skip("SEA is claimed by host APEI\n");
-	else
+		exit(KSFT_SKIP);
+	} else {
 		ksft_test_result_fail("Exit with signal unhandled\n");
-
-	exit(0);
+		exit(KSFT_FAIL);
+	}
 }
 
 static void setup_sigbus_handler(void)
@@ -158,7 +168,6 @@ static void expect_sea_handler(struct ex_regs *regs)
 {
 	u64 esr = read_sysreg(esr_el1);
 	u64 far = read_sysreg(far_el1);
-	bool expect_far_invalid = far_invalid;
 
 	GUEST_PRINTF("Handling Guest SEA\n");
 	GUEST_PRINTF("ESR_EL1=%#lx, FAR_EL1=%#lx\n", esr, far);
@@ -166,7 +175,7 @@ static void expect_sea_handler(struct ex_regs *regs)
 	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
 	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
 
-	if (expect_far_invalid) {
+	if (far_invalid) {
 		GUEST_ASSERT_EQ(esr & ESR_ELx_FnV, ESR_ELx_FnV);
 		GUEST_PRINTF("Guest observed garbage value in FAR\n");
 	} else {
@@ -185,25 +194,19 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
-static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void validate_kvm_exit_arm_sea(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	struct ucall uc;
-	bool guest_done = false;
 	struct kvm_run *run = vcpu->run;
 	u64 esr;
 
-	/* Resume the vCPU after error injection to consume the error. */
-	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
 
-	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
-		       exit_reason_str(run->exit_reason));
+	ksft_print_msg("Dumping kvm_run as arm_sea:\n");
 	ksft_print_msg("kvm_run.arm_sea: esr=%#llx, flags=%#llx\n",
 		       run->arm_sea.esr, run->arm_sea.flags);
 	ksft_print_msg("kvm_run.arm_sea: gva=%#llx, gpa=%#llx\n",
 		       run->arm_sea.gva, run->arm_sea.gpa);
 
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
 	esr = run->arm_sea.esr;
 	TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
 	TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
@@ -211,39 +214,48 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	TEST_ASSERT_EQ((esr & ESR_ELx_INST_SYNDROME), 0);
 	TEST_ASSERT_EQ(esr & ESR_ELx_VNCR, 0);
 
-	if (!(esr & ESR_ELx_FnV)) {
-		ksft_print_msg("Expect gva to match given FnV bit is 0\n");
+	far_invalid = esr & ESR_ELx_FnV;
+	sync_global_to_guest(vm, far_invalid);
+
+	if (!far_invalid) {
+		ksft_print_msg("Expect gva to match\n");
 		TEST_ASSERT_EQ(run->arm_sea.gva, EINJ_GVA);
 	}
 
 	if (run->arm_sea.flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
-		ksft_print_msg("Expect gpa to match given KVM_EXIT_ARM_SEA_FLAG_GPA_VALID is set\n");
+		ksft_print_msg("Expect gpa to match\n");
 		TEST_ASSERT_EQ(run->arm_sea.gpa, einj_gpa & PAGE_ADDR_MASK);
 	}
+}
 
-	far_invalid = esr & ESR_ELx_FnV;
-
-	/* Inject a SEA into guest and expect handled in SEA handler. */
-	vcpu_inject_sea(vcpu);
+static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	bool guest_done = false;
 
 	/* Expect the guest to reach GUEST_DONE gracefully. */
 	do {
 		vcpu_run(vcpu);
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_PRINTF:
-			ksft_print_msg("From guest: %s", uc.buffer);
-			break;
-		case UCALL_DONE:
-			ksft_print_msg("Guest done gracefully!\n");
-			guest_done = 1;
-			break;
-		case UCALL_ABORT:
-			ksft_print_msg("Guest aborted!\n");
-			guest_done = 1;
-			REPORT_GUEST_ASSERT(uc);
-			break;
-		default:
-			TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+		if (vcpu->run->exit_reason == KVM_EXIT_ARM_SEA) {
+			validate_kvm_exit_arm_sea(vm, vcpu);
+			vcpu_inject_sea(vcpu);
+		} else {
+			switch (get_ucall(vcpu, &uc)) {
+			case UCALL_PRINTF:
+				ksft_print_msg("From guest: %s", uc.buffer);
+				break;
+			case UCALL_DONE:
+				ksft_print_msg("Guest done gracefully!\n");
+				guest_done = 1;
+				break;
+			case UCALL_ABORT:
+				ksft_print_msg("Guest aborted!\n");
+				guest_done = 1;
+				REPORT_GUEST_ASSERT(uc);
+				break;
+			default:
+				TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+			}
 		}
 	} while (!guest_done);
 }
-- 
2.53.0.rc2.204.g2597b5adb4-goog


