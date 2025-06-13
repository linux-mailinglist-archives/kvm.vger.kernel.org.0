Return-Path: <kvm+bounces-49488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F23EFAD9528
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8711E375A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9562C08B7;
	Fri, 13 Jun 2025 19:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bMtElpHh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900E2BF054
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842070; cv=none; b=dviZUnk9Sv1Ev8GsfXvgt0HKc3wPLxhmu6y88ayf1TyIJD+4par2Twe5lp6iaDnifNvQMPVZh5u1/MM6V7cQDiyQ/ae5mdtU+Qy+bPPHuvBummKE6Qst3jK6TzroBV/mbijNsP9/VIfwR4dJdokUcae5kUXjkV2EVTJcA8kEtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842070; c=relaxed/simple;
	bh=qA4ohxxS+vE8iiREeVJzTRaGY2RbIWWfLxdMUKYZJZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ati/IYkmNTpSP/8jJl5tMJNvBOKp74xvrYXOLYgLKdrlQWLKIO+oyBY44bZnDzE0n9daSdpbQBZnbJQJNm87NzcoJjDXp1yWCUuVqkgAUxlKXmDFG5kSyvcG9Ii3MRxVtX43kzn4YfS4LBbgx5NndpBTtw8ofEbippbpbCC2Fj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bMtElpHh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso2104862a91.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842068; x=1750446868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HociWBs1/0Gsb5gy2IveodPFH7cmxollP6TAWtAYOo0=;
        b=bMtElpHhUBdyiQLpzg57ri3iqCWgL3pGwYvwt7a3uF0Wi/GCKw5t5EYWPcmFXWXGvE
         am2PVSyZAiGT0CUeKNq4ek7vPpsU8UZDvTj4SfyWiu9bcPYB1uQRAKO4yjX/0t504N5M
         hDnwWecuCYOo51C4WV9b3PBWqkjkGjg4HCMwPdvvyVs4dm/D1kgl/YLncyElXiAgiPxB
         +pNxhaPmj8fVEkhvBAAffCxeUufRZFVb9Tf+ly+77gKphgTR3yx40zvXOOu2Xc/QPUVb
         KUuaGOzx2WPk14gR0ike6PvMHp3bWwhcbSqlZvfZ3m6JF/Eud+BmrAvUDELKQmLvZru9
         A4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842068; x=1750446868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HociWBs1/0Gsb5gy2IveodPFH7cmxollP6TAWtAYOo0=;
        b=NCofhrWrIpFNqDnIGHk0lZyZst35h3bf6LWNI1llcEGTM9nX2Q8fKC9HaCiUsrw+Nb
         hr9FHB6yDAgeCTRU6pnjbACrM71GLJ0IGDXmgeFg9hMRS0IaJ5CE1dbGh14IZoGEtoxO
         lr766B9ocjvUZcCOSn+4r3+faQTrxWScxbbf8D2TH4g2aO3++DdZIGeqUHztHigeq/qr
         OGCpayy/x/PIHqCIRbLpSYIvGPZ9W7+5w/rFNWfBuIyqFIXRL5tA7IljbJzSVgPkhqsM
         0JYJjhkv7bbVPrCv5ICxWV7CArdWr4jLcMSkORQ8RH2d57zSe68W3ut5XCZOn8VSd+VK
         cBww==
X-Forwarded-Encrypted: i=1; AJvYcCUg/QNZLVLjYvLaU5eCrGSkbJg3fGsTF8eDML0GFh55NDHBUpVRRzo8lNWKk1mMysstqDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqrXH7D5bc7Dozq2UULbzHJbduB48rq4tUHVh0X65snrKbfkGV
	1pjER6pRmXMcHei6oI5w/Ssz92tUUIo6K4yFOMj6Y5RGAHeGM5jKXQTLHzft4BvVaUpbvh5EHYt
	9UQ==
X-Google-Smtp-Source: AGHT+IF5X+YgI8YMiqLZp24uKESiND+Xjg2x97EcCHeG1WV/H6ywto51kNtjAupUPtcn9jsfx7ZyQMhkBA==
X-Received: from pjwx12.prod.google.com ([2002:a17:90a:c2cc:b0:311:9b25:8e87])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:586b:b0:312:39c1:c9cf
 with SMTP id 98e67ed59e1d1-313f1be1c89mr1323198a91.7.1749842067784; Fri, 13
 Jun 2025 12:14:27 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:37 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-11-sagis@google.com>
Subject: [PATCH v7 10/30] KVM: selftests: TDX: Add report_fatal_error test
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

The test checks report_fatal_error functionality.

TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal error
it has experienced. TD guest is requesting a termination with the error
information that include 16 general-purpose registers.

Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx.h       |  6 ++-
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |  1 +
 .../selftests/kvm/include/x86/tdx/test_util.h | 19 +++++++
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 18 +++++++
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      |  6 +++
 .../selftests/kvm/lib/x86/tdx/test_util.c     | 10 ++++
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 51 ++++++++++++++++++-
 7 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
index a7161efe4ee2..2acccc9dccf9 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -4,9 +4,13 @@
 
 #include <stdint.h>
 
+#include "kvm_util.h"
+
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR 0x10003
+
 #define TDG_VP_VMCALL_INSTRUCTION_IO 30
 
 uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size,
 				      uint64_t write, uint64_t *data);
-
+void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t data_gpa);
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index 57a2f5893ffe..d66cf17f03ea 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -15,5 +15,6 @@ struct kvm_vm *td_create(void);
 void td_initialize(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		   uint64_t attributes);
 void td_finalize(struct kvm_vm *vm);
+void td_vcpu_run(struct kvm_vcpu *vcpu);
 
 #endif // SELFTESTS_TDX_KVM_UTIL_H
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h b/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
index 07d63bf1ffe1..dafeee9af1dc 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
@@ -38,4 +38,23 @@ bool is_tdx_enabled(void);
 void tdx_test_success(void);
 void tdx_test_assert_success(struct kvm_vcpu *vcpu);
 
+/*
+ * Report an error with @error_code to userspace.
+ *
+ * Return value from tdg_vp_vmcall_report_fatal_error() is ignored since
+ * execution is not expected to continue beyond this point.
+ */
+void tdx_test_fatal(uint64_t error_code);
+
+/*
+ * Report an error with @error_code to userspace.
+ *
+ * @data_gpa may point to an optional shared guest memory holding the error
+ * string.
+ *
+ * Return value from tdg_vp_vmcall_report_fatal_error() is ignored since
+ * execution is not expected to continue beyond this point.
+ */
+void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa);
+
 #endif // SELFTEST_TDX_TEST_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
index f417ee75bee2..ba088bfc1e62 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <string.h>
+
 #include "tdx/tdcall.h"
 #include "tdx/tdx.h"
 
@@ -25,3 +27,19 @@ uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size,
 
 	return ret;
 }
+
+void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t data_gpa)
+{
+	struct tdx_hypercall_args args;
+
+	memset(&args, 0, sizeof(struct tdx_hypercall_args));
+
+	if (data_gpa)
+		error_code |= 0x8000000000000000;
+
+	args.r11 = TDG_VP_VMCALL_REPORT_FATAL_ERROR;
+	args.r12 = error_code;
+	args.r13 = data_gpa;
+
+	__tdx_hypercall(&args, 0);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index e2bf9766dc03..5e4455be828a 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -9,6 +9,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "tdx/td_boot.h"
+#include "tdx/tdx.h"
 #include "test_util.h"
 
 uint64_t tdx_s_bit;
@@ -603,3 +604,8 @@ void td_finalize(struct kvm_vm *vm)
 
 	tdx_td_finalize_mr(vm);
 }
+
+void td_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	vcpu_run(vcpu);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
index 7355b213c344..6c82a0c3bd37 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/test_util.c
@@ -59,3 +59,13 @@ void tdx_test_assert_success(struct kvm_vcpu *vcpu)
 		    vcpu->run->io.port, vcpu->run->io.size,
 		    vcpu->run->io.direction);
 }
+
+void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa)
+{
+	tdg_vp_vmcall_report_fatal_error(error_code, data_gpa);
+}
+
+void tdx_test_fatal(uint64_t error_code)
+{
+	tdx_test_fatal_with_data(error_code, 0);
+}
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index fdb7c40065a6..7d6d71602761 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -3,6 +3,7 @@
 #include <signal.h>
 
 #include "kvm_util.h"
+#include "tdx/tdx.h"
 #include "tdx/tdx_util.h"
 #include "tdx/test_util.h"
 #include "test_util.h"
@@ -24,7 +25,51 @@ static void verify_td_lifecycle(void)
 
 	printf("Verifying TD lifecycle:\n");
 
-	vcpu_run(vcpu);
+	td_vcpu_run(vcpu);
+	tdx_test_assert_success(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
+void guest_code_report_fatal_error(void)
+{
+	uint64_t err;
+
+	/*
+	 * Note: err should follow the GHCI spec definition:
+	 * bits 31:0 should be set to 0.
+	 * bits 62:32 are used for TD-specific extended error code.
+	 * bit 63 is used to mark additional information in shared memory.
+	 */
+	err = 0x0BAAAAAD00000000;
+	tdx_test_fatal(err);
+
+	tdx_test_success();
+}
+
+void verify_report_fatal_error(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_code_report_fatal_error);
+	td_finalize(vm);
+
+	printf("Verifying report_fatal_error:\n");
+
+	td_vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_TDX_FATAL);
+	TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 16);
+
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[12], 0x0BAAAAAD00000000);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[13], 0);
+
+	td_vcpu_run(vcpu);
 	tdx_test_assert_success(vcpu);
 
 	kvm_vm_free(vm);
@@ -38,9 +83,11 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(1);
+	ksft_set_plan(2);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
+	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
+			 "verify_report_fatal_error\n");
 
 	ksft_finished();
 	return 0;
-- 
2.50.0.rc2.692.g299adb8693-goog


