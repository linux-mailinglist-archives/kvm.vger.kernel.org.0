Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2495C616D00
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiKBSrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKBSrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B0A2CE27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:01 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id k11-20020aa792cb000000b00558674e8e7fso9475840pfa.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ql4D3kiOZzzmaaxOdFm8FO+vhwnQsfC/UdEU/ar8O0w=;
        b=aNUkXBxNmbQdSOVWv/Iru8y2NflwpO3ygzFS+IJT5/Cf8/2z63W9e3jYx+G37tLmuR
         uPOhSWPTbC2R7qdSaC14LMM7IvbB7ygmTGx6qBlJi7RUGTqucbqwElkWrgUFczYdLxRL
         rSeeO+qJRkWJ9KMDIl/9lQky6rdAJVXS6BO6TCldqcHYGfZgQq6QdS8mvOrUsWBpUIkd
         Bf4X/NRvFKb3/JNPPWRfXs631Uh1uhJ6hHASPauf3Ufvq7ggVIXra2yCgt9GLT9JCZGR
         xIVL4tiQukJwdNXGN4YL4E00JVdzV6HNi0oZjwvaALhAndPrKKIVN+3mdEeo7n4YKlFj
         xneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ql4D3kiOZzzmaaxOdFm8FO+vhwnQsfC/UdEU/ar8O0w=;
        b=tBr3UL7CQDts91NcsF+tt8W7RIu5OOvXEMZCy06zZTfWnORCfektGQhnDsjdsOZs8J
         LnD3lVzXyl9EQlm6M7RSq3JooVdmNGekgxEloJKErzmZ/QWHZK8HsduStpxk4acXFgqm
         Q4zIU1ko6SdEVv24V7DiH+San11WK6QEMvN54zFLGrWonX+/a0codLT+9yI1/nRgc1rp
         0N8L7MdWNU4AmGiHfqdW2oi/GbyUEwuz3hHpMIjm70NiJJISmzXs0fU/FxwB1yu7hkF0
         0TpuDcbtXRyEN5YvJmKpplcrkhsHnhvFrI9NOmiMAs3DUsLfwvb+gaVVdyqJoMd9Hs/J
         5jgg==
X-Gm-Message-State: ACrzQf2NXp+EQROJ6sArFpd6+LMU9lzIqnuokcloWO/3UlcqltPCSqQh
        +jhA/yZOlLseoeI1vv0y96IyxoRek+7hWA==
X-Google-Smtp-Source: AMsMyM5q5qyLQVIN/MGOhr7mcX1yfMtLR66i3kecMb/7rU9e44+PG++MAUT2C4Z1Um9dIO4ffifVTmdnv8tL7g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:230d:b0:53d:c198:6ad7 with SMTP
 id h13-20020a056a00230d00b0053dc1986ad7mr26953339pfh.67.1667414820988; Wed,
 02 Nov 2022 11:47:00 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:46 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-3-dmatlack@google.com>
Subject: [PATCH v4 02/10] KVM: selftests: Explicitly require instructions bytes
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

Hard-code the flds instruction and assert the exact instruction bytes
are present in run->emulation_failure. The test already requires the
instruction bytes to be present because that's the only way the test
will advance the RIP past the flds and get to GUEST_DONE().

Note that KVM does not necessarily return exactly 2 bytes in
run->emulation_failure since it may not know the exact instruction
length in all cases. So just assert that
run->emulation_failure.insn_size is at least 2.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 68 ++++++-------------
 1 file changed, 20 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 6ed996988a5a..d92cd4139f6d 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -19,41 +19,20 @@
 #define MEM_REGION_SLOT	10
 #define MEM_REGION_SIZE PAGE_SIZE
 
+#define FLDS_MEM_EAX ".byte 0xd9, 0x00"
+
 static void guest_code(void)
 {
-	__asm__ __volatile__("flds (%[addr])"
-			     :: [addr]"r"(MEM_REGION_GVA));
+	__asm__ __volatile__(FLDS_MEM_EAX :: "a"(MEM_REGION_GVA));
 
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
 static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct kvm_regs regs;
 	uint8_t *insn_bytes;
-	uint8_t insn_size;
 	uint64_t flags;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
@@ -65,30 +44,23 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 		    "Unexpected suberror: %u",
 		    run->emulation_failure.suberror);
 
-	if (run->emulation_failure.ndata >= 1) {
-		flags = run->emulation_failure.flags;
-		if ((flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES) &&
-		    run->emulation_failure.ndata >= 3) {
-			insn_size = run->emulation_failure.insn_size;
-			insn_bytes = run->emulation_failure.insn_bytes;
-
-			TEST_ASSERT(insn_size <= 15 && insn_size > 0,
-				    "Unexpected instruction size: %u",
-				    insn_size);
-
-			TEST_ASSERT(is_flds(insn_bytes, insn_size),
-				    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
-
-			/*
-			 * If is_flds() succeeded then the instruction bytes
-			 * contained an flds instruction that is 2-bytes in
-			 * length (ie: no prefix, no SIB, no displacement).
-			 */
-			vcpu_regs_get(vcpu, &regs);
-			regs.rip += 2;
-			vcpu_regs_set(vcpu, &regs);
-		}
-	}
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
 }
 
 static void do_guest_assert(struct ucall *uc)
-- 
2.38.1.273.g43a17bfeac-goog

