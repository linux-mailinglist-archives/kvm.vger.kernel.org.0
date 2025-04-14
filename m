Return-Path: <kvm+bounces-43302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA57DA88E64
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19F07189ABC7
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C501E22B8D0;
	Mon, 14 Apr 2025 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lacTItdn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274E22248B9
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667349; cv=none; b=K0FzBIwbfHJJXaukENkmqDQFhQwtW0mgc7JOD20D6VoyuaHihTuk7lht/b0VtxhniUo37drNx+yAotGsu0A7wOpbFM0IFPQc8gUR3EvwQ+L0NaA+Qw/6bqh8Gcr3mSMfSFTdFKD6IimsT/nC6I9Y4wFjZPt7iQY2BKm104h2hWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667349; c=relaxed/simple;
	bh=x1VaH9F5+vMVnz4CneZcmMN7Xt0X5BhYmvUMXkdG68o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0h91f7VERgcDoko2N4Q00bH+yT3EuQCfjrGIs29cw0ONz50akIr6q+uXDjdOoMy+DZbdxJLPHtcA+r1TQ1fDeg//WDDd5F6tY9ey9KSk06g5YEtUdmXeEXHE768A52mzhMUhNSR8rxrKv3AUjoFAfwLQWpnjKHjdfLNe82t9Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lacTItdn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736d64c5e16so3827031b3a.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667347; x=1745272147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wQ1PuSmyErNOkFWsMOnUsqVLMdt6kLgvxXDaC6MnH5o=;
        b=lacTItdn8GCEdkoi9f5Hzsr18HjjXJc/2HSC5UHrQTMOIDhKH0TdJ+Sxe9uBpinQZ8
         AvWizh/r6uoQBG1mBG8wxRnYYPwzdW7absYPrKu8wBQ9/5oAHlS+bYbaPeIv2wA/oWRO
         dLVhWPQPFx3QO1AyB4kpsWB38vofbemTQARQr2XTTTwq5Fu7KFXoYTFfIdqQUUIPD5xb
         TzIvrTk80La9dNWnhzVkjuRaFUgU3CM45y8f9F89GGBBvyaCXcRsyJxG10287WAHUs2Q
         TzVXDgtGfINaua4UU6WfyfWEfybT6a+NdSgXsjDH/zH5H0XFxY3Bw233lfeVEu4bi/jJ
         V8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667347; x=1745272147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQ1PuSmyErNOkFWsMOnUsqVLMdt6kLgvxXDaC6MnH5o=;
        b=EDQyyVyCM+Os4xhoCVlmsbTSEi2+TNiaOnt53c3bXu2jdKC21zt5YWWdj8Ivcx5kLM
         tdPrzaKD61r9+tZVP93qcf/GCupBokDBvynjX15t5Y2RzaxqRByEKsTJJc2l1ZcldPCy
         95iqlfZ40nBk2P968huP+cb5SULBLt8w+IA6Gvg5nkZROWfEjoqluSZ1UIwDoUC4jOgj
         hWxQcckQSrdztnhZcxS4j0cdLdS5pNdfFdYg0OuMqjdf8LIuVpZVCBS8Uaz61uf80veW
         OpKzDote99yXCa6HkPCdOYEXddtaudSzcJnfFPQ/Ve9uRXg4T/q21GnHyBf5lFTQuROW
         yFHw==
X-Forwarded-Encrypted: i=1; AJvYcCU/9vXxejIWUDrbhn/u6Owvewxp8cGEuxI18a49LwqQDdECOq6tpr4wbcPvH0O6mh15m9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYN5CLNvOViG/w/UXL6iFLUd0IsIqJqHE56NltI2ofLcMAmyNT
	rubG8aiLCsbEc2DiGPhjH5cTQl7R9rxBv2zuU1E/Jdq/6MK6IeLEcBGAP3D/QoGVyB6wBOKi+w=
	=
X-Google-Smtp-Source: AGHT+IHohqELMYrnXurVE611wEYSQooWuCRzflM6mFF2BktuaOkBSfjCeIISOxqjr3aCMK8urhiWHsJ4NA==
X-Received: from pfgt19.prod.google.com ([2002:a05:6a00:1393:b0:739:56be:f58c])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b8a:b0:736:2ff4:f255
 with SMTP id d2e1a72fcca58-73bd1263c5dmr14790770b3a.15.1744667347274; Mon, 14
 Apr 2025 14:49:07 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:48 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-20-sagis@google.com>
Subject: [PATCH v6 19/30] KVM: selftests: TDX: Add TDX MMIO writes test
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
2.49.0.504.g3bcea36a83-goog


