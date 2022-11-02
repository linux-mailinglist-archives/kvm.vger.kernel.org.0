Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC675616D04
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiKBSrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiKBSrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A582F66B
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y6-20020a25b9c6000000b006c1c6161716so17028118ybj.8
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZlY20pisID3UMdvyEPOsDdyNuMTsJMxwMVwMHhsyEA=;
        b=KNbO5OFWGRx1Sf9wqORfzfux0wAUYpDYYqoWVzcDfEHuZCvzhZJhCo4vmrbBjVxkvY
         VNGAf8BNUlbiZjjclnqE4NI1QkXMeEyNylOdjhzfk1Uv0RDRVG+qHyTXD/oz8WWxwAz1
         6O3PWRsf3jF7iBm5p2IacbAm33P5mTBDMrWLnzrHA0ur2JxjfFj/bEV2mEUvVnk48lbX
         Sa+z/ag63DF2d3I1cPm+QHuNMZwTPvnnO0/mgRN66FEywFzB7q2xT1A0mdCVBKzw0Yv6
         8qh2XilcDj2Fs1/rgRZtnm2kb4iG74TuVY6rv50E7xTp2vZrhg2GYw9eRrxSG07aqNGY
         03LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZlY20pisID3UMdvyEPOsDdyNuMTsJMxwMVwMHhsyEA=;
        b=1ZUSqHxhi7meVpo5095B4Ng4Dp5XvpHSzOO4DRyAqRASm2h3cgkxhS5MusZbZC/xcS
         vzQEdcg3XYw4hSJA6Ldwm0VwV+73fXTXRywJrGjDSvjY7hIhbxXUObIDBcx4YPz2fxJw
         WBLVU/vU0E2OKfn2ExmchQzc71UnEse0t04fK5RMq+i3GgCM15XqxhJrRS0ygOs2Kxb3
         pb1ELMIlWqp8JgNnKxM2yoWChmh6Eq6MzzHeHyrngxF3csy7G2xoTbAq9qvv/FPurCtS
         pa43khIcCTsBdLLe0vhWTgLROhXsllkrp72zT+Q5Q4DdjFJl33e4LlynURdzvCAFBUXz
         ykyw==
X-Gm-Message-State: ACrzQf09aS5TTwrW1KNCl7zFdeiMdpHEzTOHghu3mh4jyJwvA1DSskLW
        RxWvut9moKeaw5KgO+z1a3LnZmWw7xXpFg==
X-Google-Smtp-Source: AMsMyM6QT10t0FAYm56F0kG0IqnbQ/spL61Nwk7MXdKMTo7EfSDMgIZDdtM1jM4PphXGFDEkYqwgxikHQ3hM/w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:25d7:0:b0:6cb:77ee:61a0 with SMTP id
 l206-20020a2525d7000000b006cb77ee61a0mr193123ybl.498.1667414823936; Wed, 02
 Nov 2022 11:47:03 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:48 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-5-dmatlack@google.com>
Subject: [PATCH v4 04/10] KVM: selftests: Move flds instruction emulation
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
 .../selftests/kvm/x86_64/flds_emulation.h     | 55 +++++++++++++++++++
 .../smaller_maxphyaddr_emulation_test.c       | 44 ++-------------
 2 files changed, 59 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h

diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
new file mode 100644
index 000000000000..e43a7df25f2c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -0,0 +1,55 @@
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
+static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	struct kvm_regs regs;
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
+
+	vcpu_regs_get(vcpu, &regs);
+	regs.rip += 2;
+	vcpu_regs_set(vcpu, &regs);
+}
+
+#endif /* !SELFTEST_KVM_FLDS_EMULATION_H */
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index f9fdf365dff7..9d0e555ea630 100644
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
@@ -97,7 +61,7 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	process_exit_on_emulation_error(vcpu);
+	handle_flds_emulation_failure_exit(vcpu);
 	vcpu_run(vcpu);
 	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 
-- 
2.38.1.273.g43a17bfeac-goog

