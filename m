Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB48C5E7029
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIVXRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiIVXRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:17:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A270C1138F3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:17:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so92426987b3.10
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=NmB/TOwNV+d0K4El1trruw0xsCpYMkUho912ppeIISE=;
        b=Qj/lGnxzxurhcDAfhOjT8R9yrj/nsYHzxo0S9XBA0MPBUeUsFR8vqpDcemexSMuN9g
         36S3mW7BRWBVIpXeiqou9RuDiy3YVweY7Jj7JKv/UnqLZYJrQJlhFFvy8LgGV7TiWhXj
         pwwK0sxQKPWrn0VjrW6YbXVAp29QwXdh5lHd1o3fCf5ygAdLqN3tb9B5MWh04MvivFBf
         qXqsIY4VQAPSGMMKvbXBBceCwGjQaPWTJP6MZFPvzDHFAcghJ4a2luXT5s/EIxPwR3aM
         IPlFUg0XiaHYM5raKYAg4hTd9A+hjQvF51ZUbo9aRnG8MkI2rUYzUoE0Enxc8ic/lh+X
         Bshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=NmB/TOwNV+d0K4El1trruw0xsCpYMkUho912ppeIISE=;
        b=Pi4ZQH/EMhK21hGvsj6xUeOMECwArL06HvBkPGqkvVT6OGvD8x8x5Y3nnTfh0eZZOK
         5Ozaz5WKzLwj+wdCINto9oU+s0XU2s3auEmVqTVHoisUp9WYL3BtdrmP8ap9CsxMPL9u
         VHMWO3pVcGZCiQ/ZVmfHOu22BHHx9YpWQWMv7zLyuJS87cYe+SlYG+Y/Zv2uhY2XSc+N
         A+OeNv5vcy/DzhTuzVbOT3paqebGQ77gWmNJavUxQtyiNiztOR/c99F7UPEVKx1yGhaS
         NTUdPzcwVyqzL+e7Ff2QVLhlv5ldXuk4wMto/wNJDz5KI8Chnv9eYzg1Yo35klr0V/mw
         Op5w==
X-Gm-Message-State: ACrzQf20GUdN5XxiiBcCmwlm9Z6LwMQ3jN+KbpXq/ug3kFLOdyfDSB6F
        jsgaJ9MVp/LTwCPI+DFrk+1OSOxqnrngQw==
X-Google-Smtp-Source: AMsMyM630t02WafVyQOoDSC+NZ1gDS1FZ4ZaoCXV41B7Mu0JSsu/Q0xl73IzgQrmkuC0UQDsD9BLjrqVumzOvQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2d5a:0:b0:6b4:eb2c:372 with SMTP id
 s26-20020a252d5a000000b006b4eb2c0372mr6757823ybe.538.1663888652967; Thu, 22
 Sep 2022 16:17:32 -0700 (PDT)
Date:   Thu, 22 Sep 2022 16:17:23 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220922231724.3560211-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Gracefully handle empty stack traces
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Bail out of test_dump_stack() if the stack trace is empty rather than
invoking addr2line with zero addresses. The problem with the latter is
that addr2line will block waiting for addresses to be passed in via
stdin, e.g. if running a selftest from an interactive terminal.

Opportunistically fix up the comment that mentions skipping 3 frames
since only 2 are skipped in the code.

Cc: Vipin Sharma <vipinsh@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/assert.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index 71ade6100fd3..c1ce54a41eca 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -42,12 +42,18 @@ static void test_dump_stack(void)
 	c = &cmd[0];
 	c += sprintf(c, "%s", addr2line);
 	/*
-	 * Skip the first 3 frames: backtrace, test_dump_stack, and
-	 * test_assert. We hope that backtrace isn't inlined and the other two
-	 * we've declared noinline.
+	 * Skip the first 2 frames, which should be test_dump_stack() and
+	 * test_assert(); both of which are declared noinline.  Bail if the
+	 * resulting stack trace would be empty. Otherwise, addr2line will block
+	 * waiting for addresses to be passed in via stdin.
 	 */
+	if (n <= 2) {
+		fputs("  (stack trace empty)\n", stderr);
+		return;
+	}
 	for (i = 2; i < n; i++)
 		c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
+
 	c += sprintf(c, "%s", pipeline);
 #pragma GCC diagnostic push
 #pragma GCC diagnostic ignored "-Wunused-result"

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
prerequisite-patch-id: 1a148d98d96d73a520ed070260608ddf1bdd0f08
-- 
2.37.3.998.g577e59143f-goog

