Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FCB613CC4
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJaSA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJaSAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:00:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176AA6423
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fde8f2cdcso108927777b3.23
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nk9ehFCSXwebc8wyDFZzqt7A9AUz20ttEVed23o/Jss=;
        b=hJbpzc+iWNGRBwfvga/XtSVIX+x6JbJbW3hSlyp7HLIqGS5U9JlQtm1/5BJg2578uM
         fODokw84BQMmBzn/5e9V0ZlN/RQikv4tWb53v7r7z4nDQkUAOeMFpX5hEGuIOSB04HFA
         UeL9ow7RN+StR1j1IFdnxaPmOMQ0pKvaLbPu/AqucTcRANNww6vyPvknj6bb3zQv5hUZ
         6554gyA1RHCNfz9byuhkVOEconB2C/eTO/s6DEOmmGipzolhedu5Bx5IaB+Zh6YQwy2y
         wPCBqcUKDalsarZWxJpvOmLl/Pdr1/B58exM0VnJzI5Wr97td28vN+k+7Li/yW7S80xR
         WNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nk9ehFCSXwebc8wyDFZzqt7A9AUz20ttEVed23o/Jss=;
        b=t1AX2VMWtja1qMwsx6Ca8FngVUeIGkce8yQA6KdKyRXp66mNNeO267jI8P+jzS11ht
         j+tg/mRDtDywLz0sW0wwd/mhxGOXe02ehL9BZCEVyh/9WEfLFOIrt465ZNOWGwVZnnSX
         c0Pxk8iOZ1VAEa7I993WtcxxKp9CPChxSsaDL+C0k24qz+unpICx6YYcW8nEgHpuCFGW
         D/aBdkA2rW/QQQrpCaT/71RhXNG22F4PxZkWK/YGfeBJOwGBh8CjTtQ9kYkFqMilkWdQ
         SvrTXZCvCo4RgfOM4uthApY9ntivpZ9PJR04vBweFbkMHluimKYMMnJHuJbCj8QfxXCP
         xMIg==
X-Gm-Message-State: ACrzQf2Xl4eMBb4bumVngSqugOqHucP/3bVF8puVHrQLtAIkC4s+oF6V
        fXr/Vw4i7CtdFOfHNBL1AYtUBU4EGVahGw==
X-Google-Smtp-Source: AMsMyM5/JH2BDamwirs6YxnvBgOYebPFt83xvI90NhT0MSrgd0W9mWRd0QhDJndyGVOLa59/H5nM1AgHKq16Vw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:c986:0:b0:325:1b81:9f77 with SMTP id
 l128-20020a0dc986000000b003251b819f77mr13613230ywd.182.1667239253406; Mon, 31
 Oct 2022 11:00:53 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:37 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-3-dmatlack@google.com>
Subject: [PATCH v3 02/10] KVM: selftests: Explicitly require instructions bytes
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

