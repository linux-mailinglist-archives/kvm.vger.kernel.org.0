Return-Path: <kvm+bounces-60619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6217DBF5134
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C348518C687C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AEF2D593C;
	Tue, 21 Oct 2025 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qC0hpUFn"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641C29B796
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032926; cv=none; b=I4cwaI8uvMFPFc19ln6UAptp7RYR74gc0PDo4N52Cx4ibPRs6G327bEGNrmQMCDf8AIi6FqwH0FrBn7RDOaBDtqgTKXPW4JEnBEDuToegiXdaYgy0UUw3ZQ3IlH7Yxi56OHaQQHZn09nv68UDNRRzuz3NiPBgV3PAU1dCS2Lpp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032926; c=relaxed/simple;
	bh=ZTFj/EYC4QDe1T7YoQR1FgC56Eg5CQLiqI5uI5zXT9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvs0Vupj0Oc5nrprHuf42AqlL5R1t+x5vWDhv0IDG3LoKkrrB5Oj55rnjlp4Uwm+UbtrLala3zkhnaSVwVc4yvtQNSTsC43lmlvjRzpBBfn/R4JfNLIcz1P6eN3Io0Lx9BKxPadvPypuA03c+/gIpt7r3KoPI8+eax/dJUppvdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qC0hpUFn; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nwEhPwIGoPA94YiE8Cr9z5oYeZSCp28VA4jU8QsCaY=;
	b=qC0hpUFnezC8f2GBOGvkh+JSVIOVqT5slDT+zVEmOZynua9oZcmJgI8nsQSvuk8+Xl8VGM
	+GZTvaQmtRTJphg35xkGgdSTqbvF51u8PcEBnykD7J3r37qpaDtWB6+apGt/nCd9yXruJp
	0vql1dJpNTiPOS2mOzAxX9Yelyo3WHk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 08/23] KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
Date: Tue, 21 Oct 2025 07:47:21 +0000
Message-ID: <20251021074736.1324328-9-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use PAGE_SIZE instead of 4096.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/x86/hyperv_features.c        |  2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c   | 18 +++++++++---------
 .../testing/selftests/kvm/x86/sev_smoke_test.c |  2 +-
 tools/testing/selftests/kvm/x86/state_test.c   |  2 +-
 .../selftests/kvm/x86/userspace_io_test.c      |  2 +-
 .../selftests/kvm/x86/vmx_dirty_log_test.c     | 10 +++++-----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 99d327084172f..130b9ce7e5ddd 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -94,7 +94,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 
 	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
 		input = pgs_gpa;
-		output = pgs_gpa + 4096;
+		output = pgs_gpa + PAGE_SIZE;
 	} else {
 		input = output = 0;
 	}
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 2b5b4bc6ef7ec..ca61836c4e325 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -102,7 +102,7 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	/* 'Slow' HvCallSendSyntheticClusterIpi to RECEIVER_VCPU_ID_1 */
 	ipi->vector = IPI_VECTOR;
 	ipi->cpu_mask = 1 << RECEIVER_VCPU_ID_1;
-	hyperv_hypercall(HVCALL_SEND_IPI, pgs_gpa, pgs_gpa + 4096);
+	hyperv_hypercall(HVCALL_SEND_IPI, pgs_gpa, pgs_gpa + PAGE_SIZE);
 	nop_loop();
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
@@ -116,13 +116,13 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	GUEST_SYNC(stage++);
 
 	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_1 */
-	memset(hcall_page, 0, 4096);
+	memset(hcall_page, 0, PAGE_SIZE);
 	ipi_ex->vector = IPI_VECTOR;
 	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
 	ipi_ex->vp_set.valid_bank_mask = 1 << 0;
 	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
 	hyperv_hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
-			 pgs_gpa, pgs_gpa + 4096);
+			 pgs_gpa, pgs_gpa + PAGE_SIZE);
 	nop_loop();
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
@@ -138,13 +138,13 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	GUEST_SYNC(stage++);
 
 	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_2 */
-	memset(hcall_page, 0, 4096);
+	memset(hcall_page, 0, PAGE_SIZE);
 	ipi_ex->vector = IPI_VECTOR;
 	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
 	ipi_ex->vp_set.valid_bank_mask = 1 << 1;
 	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_2 - 64);
 	hyperv_hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
-			 pgs_gpa, pgs_gpa + 4096);
+			 pgs_gpa, pgs_gpa + PAGE_SIZE);
 	nop_loop();
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ipis_expected[0]);
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
@@ -160,14 +160,14 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	GUEST_SYNC(stage++);
 
 	/* 'Slow' HvCallSendSyntheticClusterIpiEx to both RECEIVER_VCPU_ID_{1,2} */
-	memset(hcall_page, 0, 4096);
+	memset(hcall_page, 0, PAGE_SIZE);
 	ipi_ex->vector = IPI_VECTOR;
 	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
 	ipi_ex->vp_set.valid_bank_mask = 1 << 1 | 1;
 	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
 	ipi_ex->vp_set.bank_contents[1] = BIT(RECEIVER_VCPU_ID_2 - 64);
 	hyperv_hypercall(HVCALL_SEND_IPI_EX | (2 << HV_HYPERCALL_VARHEAD_OFFSET),
-			 pgs_gpa, pgs_gpa + 4096);
+			 pgs_gpa, pgs_gpa + PAGE_SIZE);
 	nop_loop();
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
@@ -183,10 +183,10 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	GUEST_SYNC(stage++);
 
 	/* 'Slow' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL */
-	memset(hcall_page, 0, 4096);
+	memset(hcall_page, 0, PAGE_SIZE);
 	ipi_ex->vector = IPI_VECTOR;
 	ipi_ex->vp_set.format = HV_GENERIC_SET_ALL;
-	hyperv_hypercall(HVCALL_SEND_IPI_EX, pgs_gpa, pgs_gpa + 4096);
+	hyperv_hypercall(HVCALL_SEND_IPI_EX, pgs_gpa, pgs_gpa + PAGE_SIZE);
 	nop_loop();
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
 	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 77256c89bb8de..86ad1c7d068f2 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -104,7 +104,7 @@ static void test_sync_vmsa(uint32_t type, uint64_t policy)
 	vm_sev_launch(vm, policy, NULL);
 
 	/* This page is shared, so make it decrypted.  */
-	memset(hva, 0, 4096);
+	memset(hva, 0, PAGE_SIZE);
 
 	vcpu_run(vcpu);
 
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 141b7fc0c965b..f2c7a1c297e37 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -141,7 +141,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 
 	if (this_cpu_has(X86_FEATURE_XSAVE)) {
 		uint64_t supported_xcr0 = this_cpu_supported_xcr0();
-		uint8_t buffer[4096];
+		uint8_t buffer[PAGE_SIZE];
 
 		memset(buffer, 0xcc, sizeof(buffer));
 
diff --git a/tools/testing/selftests/kvm/x86/userspace_io_test.c b/tools/testing/selftests/kvm/x86/userspace_io_test.c
index 9481cbcf284f6..be7d72f3c029f 100644
--- a/tools/testing/selftests/kvm/x86/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_io_test.c
@@ -85,7 +85,7 @@ int main(int argc, char *argv[])
 			regs.rcx = 1;
 		if (regs.rcx == 3)
 			regs.rcx = 8192;
-		memset((void *)run + run->io.data_offset, 0xaa, 4096);
+		memset((void *)run + run->io.data_offset, 0xaa, PAGE_SIZE);
 		vcpu_regs_set(vcpu, &regs);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index fa512d033205f..34a57fe747f64 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -122,15 +122,15 @@ static void test_vmx_dirty_log(bool enable_ept)
 	if (enable_ept) {
 		prepare_eptp(vmx, vm, 0);
 		nested_map_memslot(vmx, vm, 0);
-		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
-		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
+		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
 	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
 
 	while (!done) {
-		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * 4096);
+		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
@@ -153,9 +153,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 			}
 
 			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[4096 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
+			TEST_ASSERT(host_test_mem[PAGE_SIZE / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
 			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[8192 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
+			TEST_ASSERT(host_test_mem[PAGE_SIZE*2 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
 			break;
 		case UCALL_DONE:
 			done = true;
-- 
2.51.0.869.ge66316f041-goog


