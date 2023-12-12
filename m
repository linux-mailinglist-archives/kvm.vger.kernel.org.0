Return-Path: <kvm+bounces-4247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8339380F835
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 058201F21273
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9098003C;
	Tue, 12 Dec 2023 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bY9ZQrXE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46FEFD
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:21 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d053953954so30442515ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414041; x=1703018841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QmMEuN8SsdugGRuBIQYyKlPPcc9Vaoj0O+wuwT+Ut3w=;
        b=bY9ZQrXEk9uUqUJX/cR5T0IlFdmHntxqRwEIJsuWPaqXeZINY+2c+mybbTyhCpl7aI
         fP5bdpADnFi/oZsKLR87MfkkS3hffU2rkj3dk8KRIUQ2Ek0vnvhUBTK0/BV0G0lkpxNu
         zspbebX2VkZdQqSY3UP+dJnEH9kBPyx983nuDz7YEe4rg8wPpT/GnLBzcmWQHODqW4ZC
         yb2l/0OnmkGNldfNn7wmyz0Q2VmgSV3+iz39bhexFvr0986y8/CRKBYTnPpAtc6FPyVN
         w5Y1RkBjaajP68j6cUSCkLW2boVOoFAnTu4z/QJBxZyOgYtzkFhQhWyZ2s/1/qimJKof
         dZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414041; x=1703018841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QmMEuN8SsdugGRuBIQYyKlPPcc9Vaoj0O+wuwT+Ut3w=;
        b=LefuAGI+VTEhQlIP7Qxvcqy6MjuONirbfQ1sMqrbIk/BOqSPEnGQB7JpQ3oUNS5zLt
         dHKqIOwa31BMJoM4SxR0Hm8J0GLBcTM6NEEPjkH4vVho3AA9JCeKuruth2a3X2T/Vcyc
         KS4owsEFeJYHisvRGOxJ240Es9EnjyfcAPkNlU5cvpVyV1DBMLZBsBgJ1/RuycfSBvGf
         pUnoYHM/EmP5h8ZtnHqeJc439ZJsED40ezeheYbq1epf45je33DG1dG0tkBrhAEdMr1c
         XkLyzUjabRRFkbsN6QAl4SUzbVZhcoqU74FkVkVHHDHkoUQ1IL8OAFswYvss1a4TjHVh
         kGAg==
X-Gm-Message-State: AOJu0Yyxx2KrFyriS821g89ICZ3naJ5D3deLzRSXpqTG4otqxdzSaQY+
	VLmunwkdG8wVAEIVMXod2ZSc0aCBEA==
X-Google-Smtp-Source: AGHT+IFy2C6taXUGKUls3Pr3kqLUzkOO+fURcZtqBDqd2uoLbbxMihbyeQkPdCeSO4KqCcZOJ/XoDMTusQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:903:41cd:b0:1d2:ebcd:2341 with SMTP id
 u13-20020a17090341cd00b001d2ebcd2341mr54766ple.9.1702414040823; Tue, 12 Dec
 2023 12:47:20 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:27 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-13-sagis@google.com>
Subject: [RFC PATCH v5 12/29] KVM: selftests: TDX: Add basic
 get_td_vmcall_info test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

The test calls get_td_vmcall_info from the guest and verifies the
expected returned values.

Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../selftests/kvm/include/x86_64/tdx/tdx.h    |  3 +
 .../kvm/include/x86_64/tdx/test_util.h        | 27 +++++++
 .../selftests/kvm/lib/x86_64/tdx/tdx.c        | 23 ++++++
 .../selftests/kvm/lib/x86_64/tdx/test_util.c  | 46 +++++++++++
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 80 +++++++++++++++++++
 5 files changed, 179 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
index 1340c1070002..63788012bf94 100644
--- a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
@@ -5,6 +5,7 @@
 #include <stdint.h>
 #include "kvm_util_base.h"
 
+#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO 0x10000
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR 0x10003
 
 #define TDG_VP_VMCALL_INSTRUCTION_IO 30
@@ -12,5 +13,7 @@ void handle_userspace_tdg_vp_vmcall_exit(struct kvm_vcpu *vcpu);
 uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size,
 				      uint64_t write, uint64_t *data);
 void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t data_gpa);
+uint64_t tdg_vp_vmcall_get_td_vmcall_info(uint64_t *r11, uint64_t *r12,
+					uint64_t *r13, uint64_t *r14);
 
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
index af0ddbfe8d71..8a9b6a1bec3e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
@@ -4,6 +4,7 @@
 
 #include <stdbool.h>
 
+#include "kvm_util_base.h"
 #include "tdcall.h"
 
 #define TDX_TEST_SUCCESS_PORT 0x30
@@ -111,4 +112,30 @@ void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa);
  */
 uint64_t tdx_test_report_to_user_space(uint32_t data);
 
+/**
+ * Report a 64 bit value from the guest to user space using TDG.VP.VMCALL
+ * <Instruction.IO> call.
+ *
+ * Data is sent to host in 2 calls. LSB is sent (and needs to be read) first.
+ */
+uint64_t tdx_test_send_64bit(uint64_t port, uint64_t data);
+
+/**
+ * Report a 64 bit value from the guest to user space using TDG.VP.VMCALL
+ * <Instruction.IO> call. Data is reported on port TDX_TEST_REPORT_PORT.
+ */
+uint64_t tdx_test_report_64bit_to_user_space(uint64_t data);
+
+/**
+ * Read a 64 bit value from the guest in user space, sent using
+ * tdx_test_send_64bit().
+ */
+uint64_t tdx_test_read_64bit(struct kvm_vcpu *vcpu, uint64_t port);
+
+/**
+ * Read a 64 bit value from the guest in user space, sent using
+ * tdx_test_report_64bit_to_user_space.
+ */
+uint64_t tdx_test_read_64bit_report_from_guest(struct kvm_vcpu *vcpu);
+
 #endif // SELFTEST_TDX_TEST_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
index b854c3aa34ff..e5a9e13c62e2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
@@ -64,3 +64,26 @@ void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t data_gpa)
 
 	__tdx_hypercall(&args, 0);
 }
+
+uint64_t tdg_vp_vmcall_get_td_vmcall_info(uint64_t *r11, uint64_t *r12,
+					uint64_t *r13, uint64_t *r14)
+{
+	uint64_t ret;
+	struct tdx_hypercall_args args = {
+		.r11 = TDG_VP_VMCALL_GET_TD_VM_CALL_INFO,
+		.r12 = 0,
+	};
+
+	ret = __tdx_hypercall(&args, TDX_HCALL_HAS_OUTPUT);
+
+	if (r11)
+		*r11 = args.r11;
+	if (r12)
+		*r12 = args.r12;
+	if (r13)
+		*r13 = args.r13;
+	if (r14)
+		*r14 = args.r14;
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/test_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/test_util.c
index 55c5a1e634df..3ae651cd5fac 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/test_util.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 
 #include "kvm_util_base.h"
+#include "tdx/tdcall.h"
 #include "tdx/tdx.h"
 #include "tdx/test_util.h"
 
@@ -53,3 +54,48 @@ uint64_t tdx_test_report_to_user_space(uint32_t data)
 					TDG_VP_VMCALL_INSTRUCTION_IO_WRITE,
 					&data_64);
 }
+
+uint64_t tdx_test_send_64bit(uint64_t port, uint64_t data)
+{
+	uint64_t err;
+	uint64_t data_lo = data & 0xFFFFFFFF;
+	uint64_t data_hi = (data >> 32) & 0xFFFFFFFF;
+
+	err = tdg_vp_vmcall_instruction_io(port, 4,
+					   TDG_VP_VMCALL_INSTRUCTION_IO_WRITE,
+					   &data_lo);
+	if (err)
+		return err;
+
+	return tdg_vp_vmcall_instruction_io(port, 4,
+					    TDG_VP_VMCALL_INSTRUCTION_IO_WRITE,
+					    &data_hi);
+}
+
+uint64_t tdx_test_report_64bit_to_user_space(uint64_t data)
+{
+	return tdx_test_send_64bit(TDX_TEST_REPORT_PORT, data);
+}
+
+uint64_t tdx_test_read_64bit(struct kvm_vcpu *vcpu, uint64_t port)
+{
+	uint32_t lo, hi;
+	uint64_t res;
+
+	TDX_TEST_ASSERT_IO(vcpu, port, 4, TDG_VP_VMCALL_INSTRUCTION_IO_WRITE);
+	lo = *(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	vcpu_run(vcpu);
+
+	TDX_TEST_ASSERT_IO(vcpu, port, 4, TDG_VP_VMCALL_INSTRUCTION_IO_WRITE);
+	hi = *(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	res = hi;
+	res = (res << 32) | lo;
+	return res;
+}
+
+uint64_t tdx_test_read_64bit_report_from_guest(struct kvm_vcpu *vcpu)
+{
+	return tdx_test_read_64bit(vcpu, TDX_TEST_REPORT_PORT);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index 1b30e6f5a569..569c8fb0a59f 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -260,6 +260,85 @@ void verify_td_cpuid(void)
 	printf("\t ... PASSED\n");
 }
 
+/*
+ * Verifies get_td_vmcall_info functionality.
+ */
+void guest_code_get_td_vmcall_info(void)
+{
+	uint64_t err;
+	uint64_t r11, r12, r13, r14;
+
+	err = tdg_vp_vmcall_get_td_vmcall_info(&r11, &r12, &r13, &r14);
+	if (err)
+		tdx_test_fatal(err);
+
+	err = tdx_test_report_64bit_to_user_space(r11);
+	if (err)
+		tdx_test_fatal(err);
+
+	err = tdx_test_report_64bit_to_user_space(r12);
+	if (err)
+		tdx_test_fatal(err);
+
+	err = tdx_test_report_64bit_to_user_space(r13);
+	if (err)
+		tdx_test_fatal(err);
+
+	err = tdx_test_report_64bit_to_user_space(r14);
+	if (err)
+		tdx_test_fatal(err);
+
+	tdx_test_success();
+}
+
+void verify_get_td_vmcall_info(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	uint64_t r11, r12, r13, r14;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_code_get_td_vmcall_info);
+	td_finalize(vm);
+
+	printf("Verifying TD get vmcall info:\n");
+
+	/* Wait for guest to report r11 value */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	r11 = tdx_test_read_64bit_report_from_guest(vcpu);
+
+	/* Wait for guest to report r12 value */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	r12 = tdx_test_read_64bit_report_from_guest(vcpu);
+
+	/* Wait for guest to report r13 value */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	r13 = tdx_test_read_64bit_report_from_guest(vcpu);
+
+	/* Wait for guest to report r14 value */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	r14 = tdx_test_read_64bit_report_from_guest(vcpu);
+
+	TEST_ASSERT_EQ(r11, 0);
+	TEST_ASSERT_EQ(r12, 0);
+	TEST_ASSERT_EQ(r13, 0);
+	TEST_ASSERT_EQ(r14, 0);
+
+	/* Wait for guest to complete execution */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_SUCCESS(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	setbuf(stdout, NULL);
@@ -273,6 +352,7 @@ int main(int argc, char **argv)
 	run_in_new_process(&verify_report_fatal_error);
 	run_in_new_process(&verify_td_ioexit);
 	run_in_new_process(&verify_td_cpuid);
+	run_in_new_process(&verify_get_td_vmcall_info);
 
 	return 0;
 }
-- 
2.43.0.472.g3155946c3a-goog


