Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876127679BE
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbjG2Ai3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbjG2AiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A7835A9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583f048985bso29006787b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591027; x=1691195827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qOSidrRp2LZHBdun0W7JYB5cE5pjjFCNvb+AcO0kpgo=;
        b=IeguEOY0s9ia4LSqz0PgZnKqVW1fP0z9QG/oINDmIWG6CyC3ATWOXcPU8daBe6CfLx
         EbQ+o0l0XWCtodFbjFJ1lBYl8zQ9lI/HK1IBed/hhqLzu7yFojnkVmJ5Yc2zwNnTDATA
         PExKr3IXJDvazDfzsaLC2WMEfRgTgridif3o+lN8QltCrJCx75svpURWl+JX3rfL6VEC
         3I/IQlUXZ5bIz7Ak78S5iG2A5Q194P91ty6X2ufPMUJBcnfkbk60TGWdsf0zLtGZHLwv
         khBr1DTEcFb4P1GyQshYSHcICbfkfAmADqNs7y7pi05FdJndMa+XA5kZAm/Fjpmrk/DX
         KMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591027; x=1691195827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOSidrRp2LZHBdun0W7JYB5cE5pjjFCNvb+AcO0kpgo=;
        b=e4oaEemIZFENanAPMFEFNc0Ig564A6kokqlOiMGofz0iPs1CkQ82iEoeXe/e22EXjj
         XRd9wJeiQS7AEx5uDD+PmSHHqXi1g5TSW7ZYyr7TMWqhFdrrGlgOnCsi2P8tr62F52PQ
         MJ3sViOcDkpIUyIFwPZohqPdUSGdO6QJH7l15v2kqlISRmsV+oOJqFg1jOiiDUXfkZMw
         2ac/8xs7CESQL8FiwV1XPtP/cpBIDPW9o8lGzciTR0e/yGtLIDcg8j5jFd3PMmT0rVeR
         iQlTI/EvIYbP8wi4H75olEuTFqQK+VYe5a7bNKlwiJEVI6HLuQcCKATwGU/Rd8UHIlDk
         n9cw==
X-Gm-Message-State: ABy/qLY0EeKsjRLhYlOJp6odFTescP4XGwKGZjAzsMgbltcgvBJlNEQZ
        z9SA0wIl8lsKBotKlMCzGdW00YPWIB8=
X-Google-Smtp-Source: APBJJlFoZbKPiG4qr8ZwiXvM3nPYLxinTgJuk9sccrmvpGopOc0ujixNDWPL7G8kTRHnTG9EjYmYrn1AOZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac1a:0:b0:565:9bee:22e0 with SMTP id
 k26-20020a81ac1a000000b005659bee22e0mr24550ywh.0.1690591027421; Fri, 28 Jul
 2023 17:37:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:20 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-12-seanjc@google.com>
Subject: [PATCH v4 11/34] KVM: selftests: Convert debug-exceptions to printf
 style GUEST_ASSERT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert ARM's debug exceptions  test to use printf-based GUEST_ASSERT().
Opportunistically Use GUEST_ASSERT_EQ() in guest_code_ss() so that the
expected vs. actual values get printed out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 637be796086f..fdd5b05e1b0e 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
@@ -365,7 +367,7 @@ static void guest_wp_handler(struct ex_regs *regs)
 
 static void guest_ss_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT_1(ss_idx < 4, ss_idx);
+	__GUEST_ASSERT(ss_idx < 4, "Expected index < 4, got '%u'", ss_idx);
 	ss_addr[ss_idx++] = regs->pc;
 	regs->pstate |= SPSR_SS;
 }
@@ -410,8 +412,8 @@ static void guest_code_ss(int test_cnt)
 		/* Userspace disables Single Step when the end is nigh. */
 		asm volatile("iter_ss_end:\n");
 
-		GUEST_ASSERT(bvr == w_bvr);
-		GUEST_ASSERT(wvr == w_wvr);
+		GUEST_ASSERT_EQ(bvr, w_bvr);
+		GUEST_ASSERT_EQ(wvr, w_wvr);
 	}
 	GUEST_DONE();
 }
@@ -450,7 +452,7 @@ static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bp
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		goto done;
-- 
2.41.0.487.g6d72f3e995-goog

