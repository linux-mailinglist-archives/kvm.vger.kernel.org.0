Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C280613CC6
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJaSBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJaSA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:00:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3EE13D1E
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g66-20020a636b45000000b0043a256d3639so6453517pgc.12
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Sl8NAAmtS1iDuznP+uILgoMcDYJe1O4bErpznQAKrA=;
        b=HLFXV3VA8hOVzxdoYnhqyjLJNR/1pZyXecUZBP7ad66r/mtPSonBCxm144jNt7IS8v
         NWJHHxVcYwLp60LXRB5ED+KtdZmTgXykOzZFbSKQrhPK/YDULe2rw5ZVrMen2Za5+vH9
         21Et3DrUWVhIU3jpKAE7XjAFtdob5gRqXASPs8aK2oboWahWpXFjPtQHdbOAybpp/Fuy
         SGDMkbWg/GPtjLYgO/W0TRrvQD3zAWOAIOGy/ZXyBQB5qlhQTiAhQMXnR3dABcpN38Ga
         1YGDJHi/r3YPQb3Lb5iQugDkx3g5zhXYFNdoxVRHH6Dav6Fbzj2mdlas56i321sa0u/8
         Czcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Sl8NAAmtS1iDuznP+uILgoMcDYJe1O4bErpznQAKrA=;
        b=J8Moe0uLkCCZAJq4kWJ8prMi11VRvxGcPALECi1sqIf/oWS6Q+D36BnYowD8O04ra2
         xmDKvaXusBt7/VzGqo+RwMWE0hx1qjaZsJc9i+vj+NxN5N+mhxZWn0UCxE5SeyPTCKsN
         i3mFu3N+S9AI/zyF25blx5sRP4wLtTFabnX0dhKrciutN+vFVfW0FL3d3yJKQEjP2Mt+
         OPNYBwJZ2+1pEhPrO8WYunvMXxoJEYe74uoBbPBrzJ03VZ0tP9RTm88RitCZw39+jBCT
         tg007hMCltjFse7f2/j5diGc8GA0W1AVN9bATceF1c1T4DO4L5l/0yh/qkUtB8fW+xd8
         yhDw==
X-Gm-Message-State: ACrzQf3e/dMym/EsJkNii7IGQoT4RRxXEutTtM2jIhV7G3lb8VpLodgd
        M3qh1BOBA3GngR/9AjhNf7QK83G9PUzByA==
X-Google-Smtp-Source: AMsMyM72ZWvx6Xoj20XoMosuR1N2udg1bnz6hmIxa1C8iZSzdaTpjpYUns6mKVCceGQXikNMMdWhZrt1/TBsRw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP
 id fs17-20020a17090af29100b0020aeab5cf39mr1263pjb.1.1667239256717; Mon, 31
 Oct 2022 11:00:56 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:39 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-5-dmatlack@google.com>
Subject: [PATCH v3 04/10] KVM: selftests: Move flds instruction emulation
 failure handling to header
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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
 .../selftests/kvm/x86_64/flds_emulation.h     | 59 +++++++++++++++++++
 .../smaller_maxphyaddr_emulation_test.c       | 45 ++------------
 2 files changed, 64 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h

diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
new file mode 100644
index 000000000000..be0b4e0dd722
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_FLDS_EMULATION_H
+#define SELFTEST_KVM_FLDS_EMULATION_H
+
+#include "kvm_util.h"
+
+#define FLDS_MEM_EAX ".byte 0xd9, 0x00"
+
+/*
+ * flds is an instruction that the KVM instruction emulator is known not to
+ * support. This can be used in guest code along with a mechanism to force
+ * KVM to emulate the instruction (e.g. by providing an MMIO address) to
+ * exercise emulation failures.
+ */
+static inline void flds(uint64_t address)
+{
+	__asm__ __volatile__(FLDS_MEM_EAX :: "a"(address));
+}
+
+static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	uint8_t *insn_bytes;
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
+	TEST_ASSERT(run->emulation_failure.insn_size >= 2,
+		    "Expected a 2-byte opcode for 'flds', got %d bytes",
+		    run->emulation_failure.insn_size);
+
+	insn_bytes = run->emulation_failure.insn_bytes;
+	TEST_ASSERT(insn_bytes[0] == 0xd9 && insn_bytes[1] == 0,
+		    "Expected 'flds [eax]', opcode '0xd9 0x00', got opcode 0x%02x 0x%02x\n",
+		    insn_bytes[0], insn_bytes[1]);
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
index f9fdf365dff7..f438a98e8bb7 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -8,6 +8,8 @@
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 
+#include "flds_emulation.h"
+
 #include "test_util.h"
 #include "kvm_util.h"
 #include "vmx.h"
@@ -19,50 +21,12 @@
 #define MEM_REGION_SLOT	10
 #define MEM_REGION_SIZE PAGE_SIZE
 
-#define FLDS_MEM_EAX ".byte 0xd9, 0x00"
-
 static void guest_code(void)
 {
-	__asm__ __volatile__(FLDS_MEM_EAX :: "a"(MEM_REGION_GVA));
-
+	flds(MEM_REGION_GVA);
 	GUEST_DONE();
 }
 
-static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct kvm_regs regs;
-	uint8_t *insn_bytes;
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
-	TEST_ASSERT(run->emulation_failure.insn_size >= 2,
-		    "Expected a 2-byte opcode for 'flds', got %d bytes",
-		    run->emulation_failure.insn_size);
-
-	insn_bytes = run->emulation_failure.insn_bytes;
-	TEST_ASSERT(insn_bytes[0] == 0xd9 && insn_bytes[1] == 0,
-		    "Expected 'flds [eax]', opcode '0xd9 0x00', got opcode 0x%02x 0x%02x\n",
-		    insn_bytes[0], insn_bytes[1]);
-
-	vcpu_regs_get(vcpu, &regs);
-	regs.rip += 2;
-	vcpu_regs_set(vcpu, &regs);
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -97,7 +61,8 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	process_exit_on_emulation_error(vcpu);
+	assert_exit_for_flds_emulation_failure(vcpu);
+	skip_flds_instruction(vcpu);
 	vcpu_run(vcpu);
 	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 
-- 
2.38.1.273.g43a17bfeac-goog

