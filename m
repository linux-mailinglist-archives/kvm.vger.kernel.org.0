Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8325EFEDC
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiI2Ura (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiI2UrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:47:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F10315311A
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349f88710b2so24594557b3.20
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=YiFgZ5G7GtRwDSuIWSYMu3WaEUvY8gkRcfs0C8X2dC4=;
        b=Twv8NbxwW3VrmxSP2xmUcpaTwuIM94wXpUwFPjCKwEns4q4h0FpniwLtjiQErsZ6OB
         s1S/MkXYNb2w4VZWNmP3uWRxCkk1kGF4pOviep4fi+EHvw26in/8wcASGKr2FnTHU0wQ
         dCknia8quBBEr8qT/G6Q6/EYPCNsIGh1N3A/WsqSuYXzjfq9UWfc2/msvMyeB4cYc3ZJ
         0hV2wbp1+3il7/KhzOIH1sqmLZSk5q7bf6nKcLStPlyyjGmGYZvc8h5i7pEyhjJoQ5W7
         HyZ6tbeG8bFz1PfsmDhos1yA5Td/Ev0aNE2wbM8veD1ehZE19N8xF9RBikNLXLE0Re58
         Y9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=YiFgZ5G7GtRwDSuIWSYMu3WaEUvY8gkRcfs0C8X2dC4=;
        b=RZUfJtfgzKK292WmyOjz4OXsO5cEhKPZFqbWFgoCx2PDwZOQBKeNYVW+aTSWzHxmAm
         GSTojF3NJnp4Jbanza6DXbZip2qQijGg28v3K+p46S1Oh2Ec65l6oK3zfhOnV9i6T4Iy
         Zsx61Der05kFIPgYsHk7PT6TuErNFRmiP70c1u7L+5p45tGNs2C24xM8Zd25w3WVD8G6
         llgzfGSCVzGCkybzc00bkonkdYEgFlx6Vk+09eGXLFYKfFb9MCs5ypuP0MG0P1UYSh/P
         FYw6l1U5h4YOtJJykJ5U+kyM78xW6A6cUIdVVOvej2+gTt7xhhbg9yTAbitjbdcvrX15
         +XoA==
X-Gm-Message-State: ACrzQf0UaRd+NlTkUQdcg9s6j3Y69C0/QnZQbdln/OD1xXOsKUoFt6sw
        EP4FgxTrYYUbMzezpJDCQSPWvbEQu8IVmA==
X-Google-Smtp-Source: AMsMyM51bkM4dx91NWb7MIofyA5OoYmlv+BmNFz+YVumEZX3XFjN79rsnSxOrnf7oGuD947i50YJwP8h4fTVEg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:e91:0:b0:69a:ddb:9f9f with SMTP id
 z17-20020a5b0e91000000b0069a0ddb9f9fmr5655772ybr.295.1664484442482; Thu, 29
 Sep 2022 13:47:22 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:08 -0700
In-Reply-To: <20220929204708.2548375-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929204708.2548375-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929204708.2548375-5-dmatlack@google.com>
Subject: [PATCH 4/4] KVM: selftests: Explicitly require instructions bytes in emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
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

Explicitly require instruction bytes to be available in
run->emulation_failure by asserting that they are present. Note that
the test already requires the instruction bytes to be present because
that's the only way the test will advance the RIP past the flds and get
to GUEST_DONE().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../kvm/x86_64/emulator_error_test.c          | 50 ++++++++++---------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 4b06c9eefe7d..37ecd880a7c1 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -58,30 +58,32 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
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
+	TEST_ASSERT(run->emulation_failure.ndata >= 3,
+		    "Unexpected emulation_failure.ndata: %d",
+		    run->emulation_failure.ndata);
+
+	flags = run->emulation_failure.flags;
+	TEST_ASSERT(flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES,
+		    "Missing instruction bytes in emulation_failure.");
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
 
 static void process_ucall_done(struct kvm_vcpu *vcpu)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

