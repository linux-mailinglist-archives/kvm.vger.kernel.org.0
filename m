Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8291603527
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJRVqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJRVqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF43B56D6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pj13-20020a17090b4f4d00b0020b0a13cba4so1550243pjb.0
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LfWDRjOSGadEASZhwHf3SBCsJTPgC/7zVshmUPjVH5I=;
        b=fwgdkCGCwDrbXlbDohWAVWvdUlmTxGq32YxAPn36kYs0tvfywan66JQY8Yj6cBmEDf
         XoewEIfYzCu0CO8Gv/ByMOSQvyXCpAbqrKC+K5jnGOxdt96k77rePuL/BPbMyBvThXs2
         ur570ywJYgF1BuXHMo+hEu59VJ78gKR9KMDalGqQ/89POQek1dsn2oX3gX3VFxfgt+DJ
         WGJEDOX91hCOCQT0gPcTGWuWVCYsK7DiUb8tOPng0YNHHi9RiXHiVmE47kGu8k/acHGR
         dSCCl6NfX6ZyO6bYO10TLpdEaORnRbUGlg3JXM9dmaqJllnKhLjB2ebSxzFFfxFbnpNK
         KjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LfWDRjOSGadEASZhwHf3SBCsJTPgC/7zVshmUPjVH5I=;
        b=XTId4GFxIo0GYRVqNciviOXuhoyP0Ofq8eTDMPQz9NL6+HT4Wrgi5Rql6g1y88ZRnO
         NTJEIfaiLkWH6/WKD8dc8PUhwlGosKcNXdaGTvWo9MEqdiLpTMHFMrFZM3xdmZDpJauM
         Q5eKk8D1l4x5QXpUU/Zlzd1GAXqvSGRiaDay0wVSBQgVZRM1rXWl/HHwL5tp6/F39HgL
         p1SaWmOlTczbhF9rKOVAXenw2Q4mCpY/vXQ++1ds4Q2rDYy40LYXwjP3EQ32RUxlYLEt
         OoHRn4pXGyTgxR8nxLOPesfWqG3PJDFhxNDoaWmS+BGm9lBLUgmmY3E2Wd2NT8QNjG4K
         XdTA==
X-Gm-Message-State: ACrzQf3tUr0fPjL+X6J7980gvRa4D5vKP060lPd51sAJi/KfOXePXMvD
        JhDkzi/wUbBaSEWduwv7JdPQ7S3gSbK4Pw==
X-Google-Smtp-Source: AMsMyM6kRzm0H9DaXA3qmxfKPqrZUMRkTXQ6vrERHyJEQje4IWUK+ro+b+WmmWR3RQXupdM2VLrLO9Ow3SiOPQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:15c2:b0:565:bc96:1c75 with SMTP
 id o2-20020a056a0015c200b00565bc961c75mr5221559pfu.23.1666129582419; Tue, 18
 Oct 2022 14:46:22 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:08 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-5-dmatlack@google.com>
Subject: [PATCH v2 4/8] KVM: selftests: Move flds instruction emulation
 failure handling to header
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the flds instruction emulation failure handling code to a header
so it can be re-used in an upcoming test.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  9 +++
 .../selftests/kvm/x86_64/flds_emulation.h     | 67 +++++++++++++++++
 .../smaller_maxphyaddr_emulation_test.c       | 72 ++-----------------
 3 files changed, 81 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..6762bc315464 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -882,4 +882,13 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define XSTATE_XTILE_DATA_MASK		(1ULL << XSTATE_XTILE_DATA_BIT)
 #define XFEATURE_XTILE_MASK		(XSTATE_XTILE_CFG_MASK | \
 					XSTATE_XTILE_DATA_MASK)
+
+/*
+ * Accessors to get R/M, REG, and Mod bits described in the SDM vol 2,
+ * figure 2-2 "Table Interpretation of ModR/M Byte (C8H)".
+ */
+#define GET_RM(insn_byte) ((insn_byte) & 0x7)
+#define GET_REG(insn_byte) (((insn_byte) & 0x38) >> 3)
+#define GET_MOD(insn_byte) (((insn_byte) & 0xc) >> 6)
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
new file mode 100644
index 000000000000..55bb9272f4d0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_FLDS_EMULATION_H
+#define SELFTEST_KVM_FLDS_EMULATION_H
+
+#include "processor.h"
+#include "kvm_util.h"
+
+/*
+ * flds is an instruction that the KVM instruction emulator is known not to
+ * support. This can be used in guest code along with a mechanism to force
+ * KVM to emulate the instruction (e.g. by providing an MMIO address) to
+ * exercise emulation failures.
+ */
+static inline void flds(uint64_t address)
+{
+	__asm__ __volatile__("flds (%0)" :: "r"(address));
+}
+
+static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	uint8_t *insn_bytes;
+	uint8_t insn_size;
+	uint64_t flags;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
+		    "Unexpected exit reason: %u (%s)",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
+		    "Unexpected suberror: %u",
+		    run->emulation_failure.suberror);
+
+	flags = run->emulation_failure.flags;
+	TEST_ASSERT(run->emulation_failure.ndata >= 3 &&
+		    flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES,
+		    "run->emulation_failure is missing instruction bytes");
+
+	insn_size = run->emulation_failure.insn_size;
+	insn_bytes = run->emulation_failure.insn_bytes;
+
+	TEST_ASSERT(insn_size <= 15 && insn_size > 0,
+		    "Unexpected instruction size: %u",
+		    insn_size);
+
+	TEST_ASSERT(insn_size >= 2 &&
+		    insn_bytes[0] == 0xd9 &&
+		    GET_REG(insn_bytes[1]) == 0x0 &&
+		    GET_MOD(insn_bytes[1]) == 0x0 &&
+		    /* Ensure there is no SIB byte. */
+		    GET_RM(insn_bytes[1]) != 0x4 &&
+		    /* Ensure there is no displacement byte. */
+		    GET_RM(insn_bytes[1]) != 0x5,
+		    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
+}
+
+static inline void skip_flds_instruction(struct kvm_vcpu *vcpu)
+{
+	struct kvm_regs regs;
+
+	vcpu_regs_get(vcpu, &regs);
+	regs.rip += 2;
+	vcpu_regs_set(vcpu, &regs);
+}
+
+#endif /* !SELFTEST_KVM_FLDS_EMULATION_H */
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index d6e71549ca08..91a85a00b692 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -8,6 +8,8 @@
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 
+#include "flds_emulation.h"
+
 #include "test_util.h"
 #include "kvm_util.h"
 #include "vmx.h"
@@ -21,75 +23,10 @@
 
 static void guest_code(void)
 {
-	__asm__ __volatile__("flds (%[addr])"
-			     :: [addr]"r"(MEM_REGION_GVA));
-
+	flds(MEM_REGION_GVA);
 	GUEST_DONE();
 }
 
-/*
- * Accessors to get R/M, REG, and Mod bits described in the SDM vol 2,
- * figure 2-2 "Table Interpretation of ModR/M Byte (C8H)".
- */
-#define GET_RM(insn_byte) (insn_byte & 0x7)
-#define GET_REG(insn_byte) ((insn_byte & 0x38) >> 3)
-#define GET_MOD(insn_byte) ((insn_byte & 0xc) >> 6)
-
-/* Ensure we are dealing with a simple 2-byte flds instruction. */
-static bool is_flds(uint8_t *insn_bytes, uint8_t insn_size)
-{
-	return insn_size >= 2 &&
-	       insn_bytes[0] == 0xd9 &&
-	       GET_REG(insn_bytes[1]) == 0x0 &&
-	       GET_MOD(insn_bytes[1]) == 0x0 &&
-	       /* Ensure there is no SIB byte. */
-	       GET_RM(insn_bytes[1]) != 0x4 &&
-	       /* Ensure there is no displacement byte. */
-	       GET_RM(insn_bytes[1]) != 0x5;
-}
-
-static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct kvm_regs regs;
-	uint8_t *insn_bytes;
-	uint8_t insn_size;
-	uint64_t flags;
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
-		    "Unexpected suberror: %u",
-		    run->emulation_failure.suberror);
-
-	flags = run->emulation_failure.flags;
-	TEST_ASSERT(run->emulation_failure.ndata >= 3 &&
-		    flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES,
-		    "run->emulation_failure is missing instruction bytes");
-
-	insn_size = run->emulation_failure.insn_size;
-	insn_bytes = run->emulation_failure.insn_bytes;
-
-	TEST_ASSERT(insn_size <= 15 && insn_size > 0,
-		    "Unexpected instruction size: %u",
-		    insn_size);
-
-	TEST_ASSERT(is_flds(insn_bytes, insn_size),
-		    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
-
-	/*
-	 * If is_flds() succeeded then the instruction bytes contained an flds
-	 * instruction that is 2-bytes in length (ie: no prefix, no SIB, no
-	 * displacement).
-	 */
-	vcpu_regs_get(vcpu, &regs);
-	regs.rip += 2;
-	vcpu_regs_set(vcpu, &regs);
-}
-
 static void assert_ucall_done(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
@@ -133,7 +70,8 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	process_exit_on_emulation_error(vcpu);
+	assert_exit_for_flds_emulation_failure(vcpu);
+	skip_flds_instruction(vcpu);
 	vcpu_run(vcpu);
 	assert_ucall_done(vcpu);
 
-- 
2.38.0.413.g74048e4d9e-goog

