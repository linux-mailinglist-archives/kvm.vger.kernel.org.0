Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39B360352A
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJRVql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJRVqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C07BB06F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-352e29ff8c2so153220447b3.21
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1on+u6Ft+PC3bubHwfG2GbJjTHKJX75lxVXEmZJ9dY=;
        b=eNkU5Xljty7BP0br6q/YE6EGbNPfcIvGDUy+O6k/29Eej3yUAbxFRrEF/XtDNnfb/L
         6ONwBoprwuX5N9JvqQ84oTZJj+3G/jlKHlgCMQ95nlwlsezwgWaVGbWEwjtkwTlI34LC
         CPCKPjy4ogFSA4d6b8cniAuWadVFXrs7H9uXaLEl4b7qJdAyH9m3B0UKeSMWnTOWhbMl
         1eBcqUoy3/4liHrJEMje+MIVUzRjiIK9T0q+ePMBdMPU96mKiIJbDpREIhmRqDQuTZN7
         FKm1h9rRb2d513w1yfPREo+WDTObo0Uc6K+VZxNN56yh4RO8+CVuC5EomAjrpxXq+YKu
         LGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1on+u6Ft+PC3bubHwfG2GbJjTHKJX75lxVXEmZJ9dY=;
        b=bCIVAkVNMYzfE4urkaZcfa36ydWkckNjfvlWcpWEhOI0KeJlNeYQ4BlcNdrTHQ5cmx
         UCvRfY/IVwK48w5bxWNdqOMDUXnPxhtUJ1d0IPcc723U7eoxoAnEZM9+mPyL+fbokVr/
         6eqXSnBoPY73iz61t/BZYqrCdnqQdt9gtTeXOA1xkOWgJKcD90YoV65c2m3cz2EjwbuN
         Pa/cOoDHa1D/vEJEGywsZXqX7h25vOMiii43RK/i7SYyvil56QD0PZVtschE8+u8kmgT
         SWMtD8DP0yyzHstTw3Xj/JV/q+VmDnYsmGY8U9Elhst1ijlx2eDj6SlykFBIaOXT0U9s
         O3pw==
X-Gm-Message-State: ACrzQf3/1AR5DqEwoIi93GCPtiq16oQsgVTzXDGLShTFt1Au+SVGE5z3
        P8ZP0RVBBo/toGDM15fS+7eR1e7f69RvnQ==
X-Google-Smtp-Source: AMsMyM7uSLlJLuZCvuYcSh3Mfz8UXXjXwMtuyrRVubC1F2QHdg2AWjemeZnCIweo/qjd+MPZ2sznDsW1cdczGA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6f57:0:b0:6be:ff1c:5b42 with SMTP id
 k84-20020a256f57000000b006beff1c5b42mr4403844ybc.192.1666129579025; Tue, 18
 Oct 2022 14:46:19 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:06 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-3-dmatlack@google.com>
Subject: [PATCH v2 2/8] KVM: selftests: Explicitly require instructions bytes
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

Explicitly require instruction bytes to be available in
run->emulation_failure by asserting that they are present. Note that the
test already requires the instruction bytes to be present because that's
the only way the test will advance the RIP past the flds and get to
GUEST_DONE().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 47 +++++++++----------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 6ed996988a5a..c5353ad0e06d 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -65,30 +65,29 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
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
+	insn_size = run->emulation_failure.insn_size;
+	insn_bytes = run->emulation_failure.insn_bytes;
+
+	TEST_ASSERT(insn_size <= 15 && insn_size > 0,
+		    "Unexpected instruction size: %u",
+		    insn_size);
+
+	TEST_ASSERT(is_flds(insn_bytes, insn_size),
+		    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
+
+	/*
+	 * If is_flds() succeeded then the instruction bytes contained an flds
+	 * instruction that is 2-bytes in length (ie: no prefix, no SIB, no
+	 * displacement).
+	 */
+	vcpu_regs_get(vcpu, &regs);
+	regs.rip += 2;
+	vcpu_regs_set(vcpu, &regs);
 }
 
 static void do_guest_assert(struct ucall *uc)
-- 
2.38.0.413.g74048e4d9e-goog

