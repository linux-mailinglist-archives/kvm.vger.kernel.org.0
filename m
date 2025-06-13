Return-Path: <kvm+bounces-49497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AA7AD9540
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3813317586E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69A22E3395;
	Fri, 13 Jun 2025 19:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CH1tQ+Dx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2682E2F1F
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842083; cv=none; b=X7G88SMyk4EDCMw5k1OQYuaArV2rLT7zeDVAk8cb4cL1U1TWSBj4bPbfBZiMEBr4kVC81lM9RyJjnGSML/NXusATgghXFdEXHwUd4oVgEjlF/oi+yijGboC7aYxUrilUfo768w0Pf4kzTUlJBsrgxKvKN4uCQBNZNrOJGW0X+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842083; c=relaxed/simple;
	bh=gB7leVldU3Q+/K2dvULRGODaLqYXhPw7nhUc71aLv2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XVg8EfDN1SqlVJPaVQ85aI4RVA9N4D9qGnO+DEM3VGrP7ntWBFD2QarDOmc8YcY5fZS48hwubBD1TVWHQH8BX6p688HUo59wSsNk6ZSzTC/0pl9Ya9UOs7ytCrKjjQN/WxU52cp6KdXG7C5pCbWDnhvWXbrmqJhxOr62sqPC328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CH1tQ+Dx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so2409479a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842081; x=1750446881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9p4glGj+JFvfl5WfXSVa1QcEpc+ehsxYbyir+NTtj2U=;
        b=CH1tQ+Dx1obdt7QJvYbrt+zwR06qPUcMMXwWvb82HlN0QkGUCL7TW3/DknEZ1HDTe9
         gB5n++qW3Z8/e+34rQW5HGbTEA0trGeZ4IBLWOI7UnAyyTazFilIAzaM3Lces7HvVt8l
         2XOln7GtFidn9IUopgU1qrcGZ+8+Qf05Signjg1OJbF+HN/V9w6oiQ69YvO7cRyinpGP
         OSIxyuH9J2nvQtz7lChf/8OMRK8p1RZ3p9+BS5+Xk+uuZxUBwEzbkNVM4UE68Yj4IAzZ
         J2PMyBNUZYCvT8HVcmhcW3qdalxcTwQsYA56BIUGOsGSzqq/8X8QcGskGlTpsS7EZfL1
         VS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842081; x=1750446881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9p4glGj+JFvfl5WfXSVa1QcEpc+ehsxYbyir+NTtj2U=;
        b=RSJACC+PgK0SjRqI6nvRALFj1tukQhuZDrd+twn8xb8J9dOZmeOwmixEmqNBFHYfej
         jfc/UYHFL116mD22MQupTD+8Vz4+TBkwgIYaUi13tyzqpZnp3sA8KJgm+d+5sXOYHaQi
         JgtTW9mmeb9gFATPwBcALcDA6vlel6DkjcJScxK2HSlMbhCD9802G0Wya9Ec0AkYmyX6
         GdKUPnW2U5HwzNSIyizGkCn1lYvZTDs7CabPmyplo6/iEqY5uXCUkGQcY0mcrsRzQbVA
         yrmO5J/7lKL95jYliCHECeJxw4hQFiNoeNOSk5Pv4h5AJ/zGRmvX42xEAxADHqcqgTaH
         nFFw==
X-Forwarded-Encrypted: i=1; AJvYcCXCl43adLuPBkVNI5126QscWDlsBJOF1fOyTPrHvqZJ2EWQtJHpcTwKPBRaLNRim6eaxwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzPbzH3kXdY0UevhRoz2G3G3Pg0+bKTaMjHbHZVBL3sz0W8HKH
	4gxQGF2FQdSaRLBnn0nNWMOqyKg9zR11rU5OnI2WgbuTkYpQLUyLr5A5Av2F9HBBj1QolUn0LDB
	Wpw==
X-Google-Smtp-Source: AGHT+IHfouRTUogXGPkW4ugX6w/2YUe1t4Q6+8l6WO+bVjHwKE9QByebDntsgccifWGOIya/D+bam5qG5A==
X-Received: from pjbsr4.prod.google.com ([2002:a17:90b:4e84:b0:313:2ad9:17ec])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0a:b0:312:18e:d930
 with SMTP id 98e67ed59e1d1-313f1d4e217mr956309a91.19.1749842081564; Fri, 13
 Jun 2025 12:14:41 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:46 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-20-sagis@google.com>
Subject: [PATCH v7 19/30] KVM: selftests: TDX: Add TDX MMIO writes test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The test verifies MMIO writes of various sizes from the guest to the host.

Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx.h       |  2 +
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 14 +++
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 85 ++++++++++++++++++-
 3 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
index fa0b24873a8f..2fd67c3e5128 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -25,5 +25,7 @@ uint64_t tdg_vp_vmcall_instruction_wrmsr(uint64_t index, uint64_t value);
 uint64_t tdg_vp_vmcall_instruction_hlt(uint64_t interrupt_blocked_flag);
 uint64_t tdg_vp_vmcall_ve_request_mmio_read(uint64_t address, uint64_t size,
 					    uint64_t *data_out);
+uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t size,
+					     uint64_t data_in);
 
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
index 8bf41e667fc1..d61940fe7df4 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -123,3 +123,17 @@ uint64_t tdg_vp_vmcall_ve_request_mmio_read(uint64_t address, uint64_t size,
 
 	return ret;
 }
+
+uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t size,
+					     uint64_t data_in)
+{
+	struct tdx_hypercall_args args = {
+		.r11 = TDG_VP_VMCALL_VE_REQUEST_MMIO,
+		.r12 = size,
+		.r13 = MMIO_WRITE,
+		.r14 = address,
+		.r15 = data_in,
+	};
+
+	return __tdx_hypercall(&args, 0);
+}
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 563f1025c8a3..6ad675a93eeb 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -804,6 +804,87 @@ void verify_mmio_reads(void)
 	printf("\t ... PASSED\n");
 }
 
+void guest_mmio_writes(void)
+{
+	uint64_t mmio_test_addr = TDX_MMIO_TEST_ADDR | tdx_s_bit;
+	uint64_t ret;
+
+	ret = tdg_vp_vmcall_ve_request_mmio_write(mmio_test_addr, 1, 0x12);
+	tdx_assert_error(ret);
+
+	ret = tdg_vp_vmcall_ve_request_mmio_write(mmio_test_addr, 2, 0x1234);
+	tdx_assert_error(ret);
+
+	ret = tdg_vp_vmcall_ve_request_mmio_write(mmio_test_addr, 4, 0x12345678);
+	tdx_assert_error(ret);
+
+	ret = tdg_vp_vmcall_ve_request_mmio_write(mmio_test_addr, 8, 0x1234567890ABCDEF);
+	tdx_assert_error(ret);
+
+	/* Make sure host and guest are synced to the same point of execution */
+	tdx_test_report_to_user_space(MMIO_SYNC_VALUE);
+
+	/* Write across page boundary. */
+	ret = tdg_vp_vmcall_ve_request_mmio_write(PAGE_SIZE - 1, 8, 0);
+	tdx_assert_error(ret);
+
+	tdx_test_success();
+}
+
+/*
+ * Verifies guest MMIO writes.
+ */
+void verify_mmio_writes(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t byte_8;
+	uint32_t byte_4;
+	uint16_t byte_2;
+	uint8_t byte_1;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_mmio_writes);
+	td_finalize(vm);
+
+	printf("Verifying TD MMIO writes:\n");
+
+	tdx_run(vcpu);
+	tdx_test_assert_mmio(vcpu, TDX_MMIO_TEST_ADDR, 1, MMIO_WRITE);
+	byte_1 = *(uint8_t *)(vcpu->run->mmio.data);
+
+	tdx_run(vcpu);
+	tdx_test_assert_mmio(vcpu, TDX_MMIO_TEST_ADDR, 2, MMIO_WRITE);
+	byte_2 = *(uint16_t *)(vcpu->run->mmio.data);
+
+	tdx_run(vcpu);
+	tdx_test_assert_mmio(vcpu, TDX_MMIO_TEST_ADDR, 4, MMIO_WRITE);
+	byte_4 = *(uint32_t *)(vcpu->run->mmio.data);
+
+	tdx_run(vcpu);
+	tdx_test_assert_mmio(vcpu, TDX_MMIO_TEST_ADDR, 8, MMIO_WRITE);
+	byte_8 = *(uint64_t *)(vcpu->run->mmio.data);
+
+	TEST_ASSERT_EQ(byte_1, 0x12);
+	TEST_ASSERT_EQ(byte_2, 0x1234);
+	TEST_ASSERT_EQ(byte_4, 0x12345678);
+	TEST_ASSERT_EQ(byte_8, 0x1234567890ABCDEF);
+
+	tdx_run(vcpu);
+	TEST_ASSERT_EQ(tdx_test_read_report_from_guest(vcpu), MMIO_SYNC_VALUE);
+
+	td_vcpu_run(vcpu);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[12], TDG_VP_VMCALL_INVALID_OPERAND);
+
+	tdx_run(vcpu);
+	tdx_test_assert_success(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -811,7 +892,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(11);
+	ksft_set_plan(12);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -834,6 +915,8 @@ int main(int argc, char **argv)
 			 "verify_guest_hlt\n");
 	ksft_test_result(!run_in_new_process(&verify_mmio_reads),
 			 "verify_mmio_reads\n");
+	ksft_test_result(!run_in_new_process(&verify_mmio_writes),
+			 "verify_mmio_writes\n");
 
 	ksft_finished();
 	return 0;
-- 
2.50.0.rc2.692.g299adb8693-goog


