Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBB15ECC9D
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 21:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiI0TFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiI0TFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 15:05:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16FD11A16
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:05:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34577a9799dso98958497b3.6
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=vWaVJBo4cDO7rYr22e9DnZLsoZEhUZMeOEhEXFBhj/Y=;
        b=HFM2qwXEVbd7NoaB+zR62pjHXxdCzc4MlqikBDuhA339JxOXWxyLHH1Mtmux+z6jwT
         WmbsY1SEtXsKBKn2uk+wRK+UvhcNy9nTamjZhW9g2f6HDul73J4mbzPxJDQWcFzKWWl4
         BlpIDasjeOre2rL773asIjfhlOvuFqwDJ4/XmA5S/H0STLS79tseXIDOjZp+PS0pCotm
         rOQe5+iT+lWnp8KjgTV7Nx01Jj8KiaD3JQR8uUy+a9oGHRUJ3wkxIILoWKK3MNbRyNfr
         rZw6loqR+icE70MbnQy2naXD447lR2Dqlmy1FjOQuwd+XB5zevZBwr/vzn9DFzZ0H7ZX
         JFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=vWaVJBo4cDO7rYr22e9DnZLsoZEhUZMeOEhEXFBhj/Y=;
        b=a/UWi9Dvzi/GoNZVDLwlFm23qYeKJr/UTPDM2KOchS57Xg4y8NF2PI1YlTUaWtZPUq
         IwFeTCT5T+biZUkhKw6csqdqfQQpQ+tKxvdukwyFjMiGAI9Ngig2dQYzk5V9W0j3fMo8
         gRkE/8KPMnWHZol7ujXpeOcEyDMULPq7JG0Oqhpi2D4jn1Mzhnff9YX7rR8e3tWzxFaK
         SttXOVpMYqFDnAgHHH49y5rrLJe08XSvVKfJ28UQYEaDlrX0swdxlIg8uwk3yDwh88PE
         P3WNm8cl5Mm4/cNkoTA2ONzYvHSfQl3d5B8s+VEcdftIK/kw76Sn8YI9weSZ5VIdV7/d
         SrGA==
X-Gm-Message-State: ACrzQf3GFyhiwNrsk2A3D6kjO4NTvFyeDuA2tDtojY7pRvTU1DQW7j2c
        PFuYSiPV66kqEKLg8RV73AK28FircTfVkg==
X-Google-Smtp-Source: AMsMyM4LXFjKJUBe8/4mNWtehroQnCByCx8ORujg3zl1ECSin/fCse1l/KXf5aJV2RTDFQ3lrFLNR7tUF8/sFA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:d508:0:b0:352:43a6:7ddc with SMTP id
 x8-20020a0dd508000000b0035243a67ddcmr3191838ywd.55.1664305521152; Tue, 27 Sep
 2022 12:05:21 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:05:15 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220927190515.984143-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: selftests: Gracefully handle empty stack traces
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
since only 2 are skipped in the code, and move the call to backtrace()
down to where it is used.

Cc: Vipin Sharma <vipinsh@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
v2:
 - Move backtrace() down to where it is used [Vipin]
 - Change "stack trace empty" to "stack trace missing" [me]

v1: https://lore.kernel.org/kvm/20220922231724.3560211-1-dmatlack@google.com/

 tools/testing/selftests/kvm/lib/assert.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index 71ade6100fd3..7b92d1aaeda6 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -38,16 +38,23 @@ static void test_dump_stack(void)
 		 1];
 	char *c;
 
-	n = backtrace(stack, n);
 	c = &cmd[0];
 	c += sprintf(c, "%s", addr2line);
+
 	/*
-	 * Skip the first 3 frames: backtrace, test_dump_stack, and
-	 * test_assert. We hope that backtrace isn't inlined and the other two
-	 * we've declared noinline.
+	 * Skip the first 2 frames, which should be test_dump_stack() and
+	 * test_assert(); both of which are declared noinline. Bail if the
+	 * resulting stack trace would be empty. Otherwise, addr2line will block
+	 * waiting for addresses to be passed in via stdin.
 	 */
+	n = backtrace(stack, n);
+	if (n <= 2) {
+		fputs("  (stack trace missing)\n", stderr);
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

