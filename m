Return-Path: <kvm+bounces-43837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3CDA97239
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EDFD401CC3
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACEF2951BE;
	Tue, 22 Apr 2025 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FBeqZkH5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBD293B5D
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338410; cv=none; b=Ig5ZlxDorDBSdWAMw9dxLMZ93ie0QnnlVYlY0e4b0Ck6yKGDD2j1FdO9mk6ZKUrGk35Cvx85QnsCHMhwLXsez3EqtO6A+HmHOQpY3EnPS2p12DG8LvtEAM2v5IPxn2iFazNVS2IBhJH6Lm1apRMr6dlDy1/JYBnyvcSakwzu9kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338410; c=relaxed/simple;
	bh=hdXOQCwoKTHHfPfG+e4+NzmtyorjjOf+cT947lM8l+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNxb2kBcU84UNytZfSVPn4yN5E2YWyVwWouVnH3cR3JrcS1YplyaheIbhgxQ7yMHBjErC4TuDmkhdFoKxd3NE0QpomYcZE16hMRLEUf91VhuZnHHLHHzsQ5oLyu3u7hhldbyxuz2V55QyGWbagii5vGAE1Qqpj0Q9Ysvfrz6Sr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FBeqZkH5; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-227d6b530d8so55181015ad.3
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745338408; x=1745943208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzcWP7HN4V69BqsvByJTA3za0cdW55UiPl0fqxkwA5Q=;
        b=FBeqZkH5WdxZKUEZ+MZJsV79S2Tmnrd6xQ9sFDNCnP1Cuh95tdp762hHseY8t+lrcF
         aUeesZZDmsE686Fs1wTf3Euua6LdE2Glxf5S4VnlDYeRd6OU8o8AC8C+gt8JOUztWv2V
         JQNyR4aXwnY2wlSQL9vFl1kLEMGj3aQlhPAlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338408; x=1745943208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzcWP7HN4V69BqsvByJTA3za0cdW55UiPl0fqxkwA5Q=;
        b=wi//EeZY6q7caPcyrH2BX2ZWrZoje0t6lrkS3muWUQEEfRNx2WwATkCd2+vWHae0gS
         Rf5jtUX74mwjkpwtzECfXzXXmc3fy6V+luvH8Lo9t81fb5kEt6JqHM6325aLyqxf8qkd
         nGQeU0M94Wg5ws++zaaqWVKxi7YpwUpjXXqtzHZtnWxr8FapY860WcKMfYOs5Ua5a0IV
         YDURXDyyZgiPnOdiq0rOTr4aLkce6R+CV3MFIB3ifGRulop2IDraCKCskGU1Vh4fEQDz
         +hUgoiSSzhrgc5Dcuv7mc3YxhfAwPPfA8Z5KqyXDTTu7VyS3UnkJNfsutXNDX83mE7X3
         p3vg==
X-Forwarded-Encrypted: i=1; AJvYcCUKxGa5IxywkQ0Y/6iXc+3sUWu7kK2GPePP/TWKCAtYUGfLySycmaijNRXYwTQ0SIdqd40=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjXPdrZsZThX6NVWm5DwuozGaVbUjVUjqIkjKoRxI8ItihPkZ9
	fCpdynETjiR0zYXzP0uUDMnFxIg6g7Ram1G/pkaxnwtfMfG9GRBDS2in4Ek4+w==
X-Gm-Gg: ASbGnctfvEEvK/ZpbPAG0JcY5cZa6pnrCr2iZk0ADbrA/En/iNoEnTCVotndAwrxxvu
	5m0Ad43+rSgjTpNXpOTk9IKw9ijB8wF+rLB9MrtmypWcXdrQ3vUxDT4JZJtMj6WL7PyApt4Wcyp
	vBfyz0CsTfvCGbc4T5oIbPDlyJadOygG2jSXeS98TameSfpjZXPUsHsNeH9anXyyuvgPq9FpW1T
	+Xxko2jrM7BqLLSyTmNjx5M4p2ES5m4JoD5qGdQ1kEuFxJwuTz3sv0v4+xVHq9xIlBjc4EO3mkP
	gnE4l7vKY7pu3CpZLldkDwtRcyMDQA8j8oNIVCAdV3TMzDSGKLVcpOqHBA749+8rFaA4PV97cnQ
	mFSw9bsB1VotzhbxNNCta/GmpXHP00Pr2
X-Google-Smtp-Source: AGHT+IFXPfVNyaIaH5PkNkJJ4dOx7Q32vB/OT615RZ2uxxOhlp0AcB0WNZrcWG6lGBQwvBg4b2r2Vw==
X-Received: by 2002:a17:903:41ce:b0:224:fa0:36d2 with SMTP id d9443c01a7336-22c535b4960mr208029485ad.26.1745338408384;
        Tue, 22 Apr 2025 09:13:28 -0700 (PDT)
Received: from localhost.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net. [173.49.113.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb03d2sm87462375ad.142.2025.04.22.09.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:13:28 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: linux-kernel@vger.kernel.org
Cc: Zack Rusin <zack.rusin@broadcom.com>,
	Doug Covelli <doug.covelli@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Joel Stanley <joel@jms.id.au>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: selftests: x86: Add a test for KVM_CAP_X86_VMWARE_HYPERCALL
Date: Tue, 22 Apr 2025 12:12:24 -0400
Message-ID: <20250422161304.579394-6-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250422161304.579394-1-zack.rusin@broadcom.com>
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a testcase to exercise KVM_CAP_X86_VMWARE_HYPERCALL and validate
that KVM exits to userspace on hypercalls and registers are correctly
preserved.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Doug Covelli <doug.covelli@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
---
 tools/include/uapi/linux/kvm.h                |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/vmware_hypercall_test.c | 121 ++++++++++++++++++
 3 files changed, 125 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmware_hypercall_test.c

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 502ea63b5d2e..3b3ad1827245 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -933,6 +933,9 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_X86_VMWARE_BACKDOOR 239
+#define KVM_CAP_X86_VMWARE_HYPERCALL 240
+#define KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0 241
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4277b983cace..9eea93b330e4 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -90,6 +90,7 @@ TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
 TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
+TEST_GEN_PROGS_x86 += x86/vmware_hypercall_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
 TEST_GEN_PROGS_x86 += x86/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86/vmware_hypercall_test.c b/tools/testing/selftests/kvm/x86/vmware_hypercall_test.c
new file mode 100644
index 000000000000..8daca272933c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmware_hypercall_test.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmware_hypercall_test
+ *
+ * Copyright (c) 2025 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ *
+ * Based on:
+ *    xen_vmcall_test.c
+ *
+ *    Copyright © 2020 Amazon.com, Inc. or its affiliates.
+ *
+ * VMware hypercall testing
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define ARGVALUE(x) (0xdeadbeef5a5a0000UL + (x))
+#define RETVALUE(x) (0xcafef00dfbfbffffUL + (x))
+
+static void guest_code(void)
+{
+	uint64_t error_code;
+	uint8_t vector;
+
+	unsigned long rax = ARGVALUE(1);
+	unsigned long rbx = ARGVALUE(2);
+	unsigned long rcx = ARGVALUE(3);
+	unsigned long rdx = ARGVALUE(4);
+	unsigned long rsi = ARGVALUE(5);
+	unsigned long rdi = ARGVALUE(6);
+	register unsigned long rbp __asm__("rbp") = ARGVALUE(7);
+
+	asm volatile(KVM_ASM_SAFE("vmcall")
+		     : "=a"(rax),  "=b"(rbx), "=c"(rcx), "=d"(rdx),
+		       "=S"(rsi), "=D"(rdi),
+		       KVM_ASM_SAFE_OUTPUTS(vector, error_code)
+		     : "a"(rax), "b"(rbx), "c"(rcx), "d"(rdx),
+		       "S"(rsi), "D"(rdi), "r"(rbp)
+		     : KVM_ASM_SAFE_CLOBBERS);
+	GUEST_ASSERT_EQ(rax, RETVALUE(11));
+	GUEST_ASSERT_EQ(rbx, RETVALUE(12));
+	GUEST_ASSERT_EQ(rcx, RETVALUE(13));
+	GUEST_ASSERT_EQ(rdx, RETVALUE(14));
+	GUEST_ASSERT_EQ(rsi, RETVALUE(15));
+	GUEST_ASSERT_EQ(rdi, RETVALUE(16));
+	GUEST_ASSERT_EQ(vector, 12);
+	GUEST_ASSERT_EQ(error_code, 14);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_X86_VMWARE_HYPERCALL)) {
+		print_skip("KVM_CAP_X86_VMWARE_HYPERCALL not available");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_enable_cap(vm, KVM_CAP_X86_VMWARE_HYPERCALL, 1);
+
+	for (;;) {
+		struct kvm_run *run = vcpu->run;
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+
+		if (run->exit_reason == KVM_EXIT_VMWARE) {
+			struct kvm_regs regs;
+
+			TEST_ASSERT_EQ(run->vmware.type, KVM_EXIT_VMWARE_HCALL);
+			TEST_ASSERT_EQ(run->vmware.hcall.longmode, 1);
+			TEST_ASSERT_EQ(run->vmware.hcall.cpl, 0);
+			TEST_ASSERT_EQ(run->vmware.hcall.rax, ARGVALUE(1));
+			TEST_ASSERT_EQ(run->vmware.hcall.rbx, ARGVALUE(2));
+			TEST_ASSERT_EQ(run->vmware.hcall.rcx, ARGVALUE(3));
+			TEST_ASSERT_EQ(run->vmware.hcall.rdx, ARGVALUE(4));
+			TEST_ASSERT_EQ(run->vmware.hcall.rsi, ARGVALUE(5));
+			TEST_ASSERT_EQ(run->vmware.hcall.rdi, ARGVALUE(6));
+			TEST_ASSERT_EQ(run->vmware.hcall.rbp, ARGVALUE(7));
+
+			run->vmware.hcall.exception.inject = 1;
+			run->vmware.hcall.exception.vector = 12;
+			run->vmware.hcall.exception.error_code = 14;
+			run->vmware.hcall.exception.address = 0;
+
+			run->vmware.hcall.result = RETVALUE(11);
+			vcpu_regs_get(vcpu, &regs);
+			regs.rbx = RETVALUE(12);
+			regs.rcx = RETVALUE(13);
+			regs.rdx = RETVALUE(14);
+			regs.rsi = RETVALUE(15);
+			regs.rdi = RETVALUE(16);
+			vcpu_regs_set(vcpu, &regs);
+			continue;
+		}
+
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		}
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.48.1


