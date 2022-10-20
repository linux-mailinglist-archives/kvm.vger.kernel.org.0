Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705706056EB
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJTFnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJTFnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:43:14 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922D5192B97
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3606e54636aso190359997b3.16
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJ7DW6FMrS3/XjKR3IUADDixPsWjRSTHpU4QIywCQT0=;
        b=kGndETIJMFAPsM6o9M6DaJUd1eiJ2R4UMKlgOyP1fNzxbCIVhSLbX7CnVkqS0nZlgD
         qkckUwjazjcZLM/YkMuwJNmj1ry2kxAjdem3B0xhMr2Dp4mF/14rIR7QQKqF48mU8mB8
         DcVOolzBRorJXy4aurbFEdEk/2+PPc1mT16TphLnIg/nGPjf1VTt5E1w2sdOQK4gJFWK
         SWfUUVygx2JxiN+W1eCfC/6ejAbDk16p/xlU+QRxcN9+DW5mPw4pCt5m2rJjzODbwnTl
         IPW0r6GYVCllZBAnh/B7sQDg2fWC80wwFFwvtnm6wbVWdEwS7OpZC3IggwH4D5drvjZp
         wY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJ7DW6FMrS3/XjKR3IUADDixPsWjRSTHpU4QIywCQT0=;
        b=tKl6XpcPSGU0nEFJ23ea/9HNa1KAbXluiAIx4zo+YYif8CxpnOykx/xPYKIfW2cwSJ
         rY8P7tCMpdTfxKXT1Y+WUszs0PhV4I58GsFO9vitKJisCqPcXSjWfJe9JG75V2e57mRl
         bQr9zDkt+3pBGggpHylv1+nJvXz0CyKrMlvnecni3ea+aTPlLN9OXXxiTh1ScZ6jJm6v
         AELZAoU9wvlLHfnzeLdE1yShNZVejqgAM510Tm/d32ecOfCVvXb59ctYabV5U0LSbtVz
         AZKSUWNFO9B66J9EylkzzYkujt8go8O1CtWG+gwykNTyxhiOWLNCynSBFgeuuxKtLqQL
         uZMw==
X-Gm-Message-State: ACrzQf1pdxCrvIgfrvOxKZjj+trrKrVthqszNzdAUquV7B78zM6In8Lf
        UqDSGkkWSy+cP8vLPvKprqC6awIS7cY=
X-Google-Smtp-Source: AMsMyM5cafI3oKmmNqdU3WwdsV2NsJ9CGbFSB+7QFWMTaiHhqL6V6IVmTaXwI0KJcvCCmksQc05HdIvzMqg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:7cc7:0:b0:6ca:3ba9:a1b8 with SMTP id
 x190-20020a257cc7000000b006ca3ba9a1b8mr438557ybc.206.1666244591287; Wed, 19
 Oct 2022 22:43:11 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:57 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-5-reijiw@google.com>
Subject: [PATCH v2 4/9] KVM: arm64: selftests: Add helpers to enable debug exceptions
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Add helpers to enable breakpoint and watchpoint exceptions.
No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 608a6c8db9a2..0c237022f4d3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -130,10 +130,20 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
+static void enable_monitor_debug_exceptions(void)
+{
+	uint32_t mdscr;
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+}
+
 static void install_wp(uint8_t wpn, uint64_t addr)
 {
 	uint32_t wcr;
-	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
 	write_dbgwcr(wpn, wcr);
@@ -141,28 +151,19 @@ static void install_wp(uint8_t wpn, uint64_t addr)
 
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_monitor_debug_exceptions();
 }
 
 static void install_hw_bp(uint8_t bpn, uint64_t addr)
 {
 	uint32_t bcr;
-	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
 	write_dbgbcr(bpn, bcr);
 	write_dbgbvr(bpn, addr);
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_monitor_debug_exceptions();
 }
 
 static void install_ss(void)
-- 
2.38.0.413.g74048e4d9e-goog

