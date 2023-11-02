Return-Path: <kvm+bounces-418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 450C07DF7B1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746131C20FB9
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4132A210E1;
	Thu,  2 Nov 2023 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WhL8CXQK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F1210F6
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:33:27 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA8182;
	Thu,  2 Nov 2023 09:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942803; x=1730478803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=8/hRJyUBNjvleQKE+JOCe0b2zCgJ7MkC7xPhxYSrynY=;
  b=WhL8CXQKbYppnwN6dlgSBJTRe56iJM19HinxDuAV9PF+g7O0lMoEkFU+
   sEuw/tDk38OHGeqVHMWV9RrgVKsIbGYX8dOIayqoDecnsQt6qafmhZZRn
   ZhXmf8fpnH9qpSFy7HowjfBz3W1h1w99IZbmPfJnzpwykbkxn6ec7yXLF
   6DLgIsoa1BtPm5MVqPbl4sHZSG1QjsO+UWNXduk4IksWFGk29Yh3vBjWJ
   J09WSVoIKGkmu3Va+b+i/HE32WwxytIlqS4IGvhTTehh2DJZsHItfBFDe
   JIsl9jbggoCtl+gEAEdNC4tIwrUM4vZ6EHlxmmunYXi+uA4ObacDCUfb1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388570958"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388570958"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448494"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:18 -0700
From: Zeng Guang <guang.zeng@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Zeng Guang <guang.zeng@intel.com>
Subject: [RFC PATCH v1 4/8] KVM : selftests : Adapt selftest cases to kernel canonical linear address
Date: Thu,  2 Nov 2023 23:51:07 +0800
Message-Id: <20231102155111.28821-5-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102155111.28821-1-guang.zeng@intel.com>
References: <20231102155111.28821-1-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Adapt RIP to kernel canonical linear address in test cases
set_memory_region_test/debug_regs/userspace_msr_exit_test.

No functional change intended.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 .../testing/selftests/kvm/set_memory_region_test.c  | 13 ++++++++++---
 tools/testing/selftests/kvm/x86_64/debug_regs.c     |  2 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c  |  9 +++++----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index b32960189f5f..8ab897bae3e0 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -31,6 +31,12 @@
 #define MEM_REGION_GPA		0xc0000000
 #define MEM_REGION_SLOT		10
 
+/*
+ * Offset to execute code at kernel address space
+ */
+#define KERNEL_LNA_OFFSET	0xffff800000000000
+#define CAST_TO_KERN(x)		(x | KERNEL_LNA_OFFSET)
+
 static const uint64_t MMIO_VAL = 0xbeefull;
 
 extern const uint64_t final_rip_start;
@@ -300,10 +306,11 @@ static void test_delete_memory_region(void)
 	 * so the instruction pointer would point to the reset vector.
 	 */
 	if (run->exit_reason == KVM_EXIT_INTERNAL_ERROR)
-		TEST_ASSERT(regs.rip >= final_rip_start &&
-			    regs.rip < final_rip_end,
+		TEST_ASSERT(regs.rip >= CAST_TO_KERN(final_rip_start) &&
+			    regs.rip < CAST_TO_KERN(final_rip_end),
 			    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx\n",
-			    final_rip_start, final_rip_end, regs.rip);
+			    CAST_TO_KERN(final_rip_start), CAST_TO_KERN(final_rip_end),
+			    regs.rip);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index f6b295e0b2d2..73ce373e3299 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -64,7 +64,7 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-#define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
+#define  CAST_TO_RIP(v)  ((unsigned long long)&(v) | KERNEL_LNA_OFFSET)
 
 static void vcpu_skip_insn(struct kvm_vcpu *vcpu, int insn_len)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 3533dc2fbfee..ab6b3f88352f 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -18,6 +18,7 @@
 static int fep_available = 1;
 
 #define MSR_NON_EXISTENT 0x474f4f00
+#define CAST_TO_KERN(x)  (x | KERNEL_LNA_OFFSET)
 
 static u64 deny_bits = 0;
 struct kvm_msr_filter filter_allow = {
@@ -363,12 +364,12 @@ static void __guest_gp_handler(struct ex_regs *regs,
 			       char *r_start, char *r_end,
 			       char *w_start, char *w_end)
 {
-	if (regs->rip == (uintptr_t)r_start) {
-		regs->rip = (uintptr_t)r_end;
+	if (regs->rip == CAST_TO_KERN((uintptr_t)r_start)) {
+		regs->rip = CAST_TO_KERN((uintptr_t)r_end);
 		regs->rax = 0;
 		regs->rdx = 0;
-	} else if (regs->rip == (uintptr_t)w_start) {
-		regs->rip = (uintptr_t)w_end;
+	} else if (regs->rip == CAST_TO_KERN((uintptr_t)w_start)) {
+		regs->rip = CAST_TO_KERN((uintptr_t)w_end);
 	} else {
 		GUEST_ASSERT(!"RIP is at an unknown location!");
 	}
-- 
2.21.3


