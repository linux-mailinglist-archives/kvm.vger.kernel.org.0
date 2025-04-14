Return-Path: <kvm+bounces-43295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC92A88E4F
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFEE117647C
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F6621ADC7;
	Mon, 14 Apr 2025 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="leHEaUX1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DB1F4282
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667338; cv=none; b=XBAklYOiLKTCr24O/AMsRQ5FN8OEe89fyWbHT35zhfvv+tFizA90iOpP4xv+a2MUqDoW0UuoMeyPfuXFW+fQLZJjMNV6hO2eNWBDa2GqfkDsNLOGZHMmPyuZ2cNP3C+mXzB9VtehLj5lYANvJW36TPsCmAqQ/CRlcmH6KsWf74I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667338; c=relaxed/simple;
	bh=Nf68Hpj/B0bYkNJ0fi76CIoXX9cOd4n2nffUccXvdbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rxn66GkZSZPrNAS+G81HRW+BncRfXc292wG6e8MEcWJv7kgDzX+gRdVNpFyEPiyWqm2rgWJUfe4cltxl/2uwxaYds6JdN0B0Q1X4bLTTf60JJ+N/om/EbA/0kX+YinX/agCqDF6Pb3xj3X++rBNKFr44uFYT4E2N2P1/S/qufl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=leHEaUX1; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7394792f83cso3457353b3a.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667336; x=1745272136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZnXi8xFdz69Pn6l5zsGjn/cdx88HjbtqpfJijhW+g0=;
        b=leHEaUX18JdtX/CbN4/34XqjtWMNkXF//mfY5gDMU16m25zLLbaFfKrW0DwpcrQriC
         CCmvHOVL8zFqkqFGCoEB6VkMgy+AO01Q8fcN1h/pp86C1LAE6TX9fpUY5l4TlM5Tt3YA
         NB5wmFKpRIdzQp5WBwTTky0AD+0HWMTqhjxvEECaulYa+y+xGYqJKMNEqSO/7k+uS/5I
         Aj60Ot490k5wX0IEjKk1CDhzfJmSL7gQwz6CcREJqDA4FO2R/qFNN2HC80iXXno7UIOW
         Q/LeMV/o+J+sP2ArHxe8KaEoNJj5HKOjfnjSZxzPA8DetODKPef//qtikyGB8RThRtjT
         ykcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667336; x=1745272136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZnXi8xFdz69Pn6l5zsGjn/cdx88HjbtqpfJijhW+g0=;
        b=nBQthw9ViHjX/rmtOxfkeWP1VvMN5VrhcGuu/CkkB11fQ/6qtHoWQi6FYiB2ghjQdc
         oZrqYeQTHiF8TbyJsUWJXc6goUlJYPEYAvs9mxcYPgg66/+oaSGM3zT8SVow6otrNlAQ
         ANw0Cp8o7Kl9sShOh/9glRDv6KLQ8JPOUbVqtZwZsdQNqeTd5cLgpjvkVZukRMp4aZyR
         WfN5Asfn0DJCJiquli/xTLp/uc+MuRCGNPbSdJxBXi1whXICfLLcb7arGum0XzpPCRXc
         wlaCGzroXXqjRkH0aMpKP8W0xaWgzNNrtO/re9sCYRxqVrGB6b5TaDV6/ufxa5Ry1GG9
         pM0w==
X-Forwarded-Encrypted: i=1; AJvYcCUIPEJoH/YalnK7ctiEmHRQVkgGGgla2yLQIY2eOlj/Hgt8Va4jr4BGs0+YN95HD187icg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqCa8cjIkjErUFNocSiq3d7HXgD0K3IOSBsjcS00ZJp4ww37+9
	eDSbhW1d4yc3KJG9UU7aXlREp8N5mDfuA6/wRynCtVtty7o6L1luUECNJmIUgIBwR1tPLuDLZQ=
	=
X-Google-Smtp-Source: AGHT+IHOmm323OTZwKcRLQC0RI7w4RCrLlWXe7PNO4rM1ZH+/bjNb2QH0/SJjqGE8Tg72UQrJ3rjbaVsYg==
X-Received: from pfbgv13.prod.google.com ([2002:a05:6a00:4e8d:b0:730:848d:a5a3])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a9:b0:736:a7ec:a366
 with SMTP id d2e1a72fcca58-73bd11e5925mr14616860b3a.9.1744667336277; Mon, 14
 Apr 2025 14:48:56 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:41 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-13-sagis@google.com>
Subject: [PATCH v6 12/30] KVM: selftests: TDX: Add basic TDX CPUID test
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

The test reads CPUID values from inside a TD VM and compare them
to expected values.

The test targets CPUID values which are virtualized as "As Configured",
"As Configured (if Native)", "Calculated", "Fixed" and "Native"
according to the TDX spec.

Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/test_util.h | 15 +++
 .../selftests/kvm/lib/x86/tdx/test_util.c     | 20 ++++
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 98 ++++++++++++++++++-
 3 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h b/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
index cf11955d56d6..2af6e810ef78 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
@@ -9,6 +9,9 @@
 #define TDX_TEST_SUCCESS_PORT 0x30
 #define TDX_TEST_SUCCESS_SIZE 4
 
+#define TDX_TEST_REPORT_PORT 0x31
+#define TDX_TEST_REPORT_SIZE 4
+
 /* Port I/O direction */
 #define PORT_READ	0
 #define PORT_WRITE	1
@@ -77,4 +80,16 @@ void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa);
  */
 void tdx_assert_error(uint64_t error);
 
+/*
+ * Report a 32 bit value from the guest to user space using TDG.VP.VMCALL
+ * <Instruction.IO> call. Data is reported on port TDX_TEST_REPORT_PORT.
+ */
+uint64_t tdx_test_report_to_user_space(uint32_t data);
+
+/*
+ * Read a 32 bit value from the guest in user space, sent using
+ * tdx_test_report_to_user_space().
+ */
+uint32_t tdx_test_read_report_from_guest(struct kvm_vcpu *vcpu);
+
 #endif // SELFTEST_TDX_TEST_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
index 4ccc5298ba25..f9bde114a8bc 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
@@ -104,3 +104,23 @@ void tdx_assert_error(uint64_t error)
 	if (error)
 		tdx_test_fatal(error);
 }
+
+uint64_t tdx_test_report_to_user_space(uint32_t data)
+{
+	/* Upcast data to match tdg_vp_vmcall_instruction_io() signature */
+	uint64_t data_64 = data;
+
+	return tdg_vp_vmcall_instruction_io(TDX_TEST_REPORT_PORT,
+					    TDX_TEST_REPORT_SIZE, PORT_WRITE,
+					    &data_64);
+}
+
+uint32_t tdx_test_read_report_from_guest(struct kvm_vcpu *vcpu)
+{
+	uint32_t res;
+
+	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, 4, PORT_WRITE);
+	res = *(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset);
+
+	return res;
+}
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 97330e28f236..bbdcca358d71 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -3,6 +3,7 @@
 #include <signal.h>
 
 #include "kvm_util.h"
+#include "processor.h"
 #include "tdx/tdcall.h"
 #include "tdx/tdx.h"
 #include "tdx/tdx_util.h"
@@ -146,6 +147,99 @@ void verify_td_ioexit(void)
 	printf("\t ... PASSED\n");
 }
 
+/*
+ * Verifies CPUID functionality by reading CPUID values in guest. The guest
+ * will then send the values to userspace using an IO write to be checked
+ * against the expected values.
+ */
+void guest_code_cpuid(void)
+{
+	uint32_t ebx, ecx;
+	uint64_t err;
+
+	/* Read CPUID leaf 0x1 */
+	asm volatile ("cpuid"
+		      : "=b" (ebx), "=c" (ecx)
+		      : "a" (0x1)
+		      : "edx");
+
+	err = tdx_test_report_to_user_space(ebx);
+	tdx_assert_error(err);
+
+	err = tdx_test_report_to_user_space(ecx);
+	tdx_assert_error(err);
+
+	tdx_test_success();
+}
+
+void verify_td_cpuid(void)
+{
+	uint32_t guest_max_addressable_ids, host_max_addressable_ids;
+	const struct kvm_cpuid_entry2 *cpuid_entry;
+	uint32_t guest_clflush_line_size;
+	uint32_t guest_initial_apic_id;
+	uint32_t guest_sse3_enabled;
+	uint32_t guest_fma_enabled;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint32_t ebx, ecx;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_code_cpuid);
+	td_finalize(vm);
+
+	printf("Verifying TD CPUID:\n");
+
+	/* Wait for guest to report ebx value */
+	tdx_run(vcpu);
+	ebx = tdx_test_read_report_from_guest(vcpu);
+
+	/* Wait for guest to report either ecx value or error */
+	tdx_run(vcpu);
+	ecx = tdx_test_read_report_from_guest(vcpu);
+
+	/* Wait for guest to complete execution */
+	tdx_run(vcpu);
+	tdx_test_assert_success(vcpu);
+
+	/* Verify the CPUID values received from the guest. */
+	printf("\t ... Verifying CPUID values from guest\n");
+
+	/* Get KVM CPUIDs for reference */
+	cpuid_entry = vcpu_get_cpuid_entry(vcpu, 1);
+	TEST_ASSERT(cpuid_entry, "CPUID entry missing\n");
+
+	host_max_addressable_ids = (cpuid_entry->ebx >> 16) & 0xFF;
+
+	guest_sse3_enabled = ecx & 0x1;  // Native
+	guest_clflush_line_size = (ebx >> 8) & 0xFF;  // Fixed
+	guest_max_addressable_ids = (ebx >> 16) & 0xFF;  // As Configured
+	guest_fma_enabled = (ecx >> 12) & 0x1;  // As Configured (if Native)
+	guest_initial_apic_id = (ebx >> 24) & 0xFF;  // Calculated
+
+	TEST_ASSERT_EQ(guest_sse3_enabled, 1);
+	TEST_ASSERT_EQ(guest_clflush_line_size, 8);
+	TEST_ASSERT_EQ(guest_max_addressable_ids, host_max_addressable_ids);
+
+	/* TODO: This only tests the native value. To properly test
+	 * "As Configured (if Native)" this value needs override in the
+	 * TD params.
+	 */
+	TEST_ASSERT_EQ(guest_fma_enabled, (cpuid_entry->ecx >> 12) & 0x1);
+
+	/* TODO: guest_initial_apic_id is calculated based on the number of
+	 * vCPUs in the TD. From the spec: "Virtual CPU index, starting from 0
+	 * and allocated sequentially on each successful TDH.VP.INIT"
+	 * To test non-trivial values either use a TD with multiple vCPUs
+	 * or pick a different calculated value.
+	 */
+	TEST_ASSERT_EQ(guest_initial_apic_id, 0);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -153,13 +247,15 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(3);
+	ksft_set_plan(4);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
 			 "verify_report_fatal_error\n");
 	ksft_test_result(!run_in_new_process(&verify_td_ioexit),
 			 "verify_td_ioexit\n");
+	ksft_test_result(!run_in_new_process(&verify_td_cpuid),
+			 "verify_td_cpuid\n");
 
 	ksft_finished();
 	return 0;
-- 
2.49.0.504.g3bcea36a83-goog


