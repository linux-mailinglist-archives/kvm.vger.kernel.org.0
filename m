Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359FA5A085C
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiHYFKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiHYFK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC349A9F6
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-337ed9110c2so283709657b3.15
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=TuEzIR2uESIWnuxyfH1eHFT+9Tcdti9EDHpVvf4j/1Y=;
        b=FgTwKGkxPoKxP1KMzZgdT1Mj/ysD6A7ddjhiMc4ZMC8VCRZaSS5hI5vKDifgV+39BI
         wXu770kX27/8AZ9i97GsTq8pOYZk4INErQ8tFX1OSefI1sY6/u/qFMkvHvptqoUSZ6+E
         k2lJs/C31pUqFQ3ZvzsZ+24EUYugRw3GnYcu5HQmVox/Cz0vKKdoQgbwpTNSHnPtCALC
         jdCUwq99FBtXx0NYhFVDDz6EMCMTiKpsq48XCFc+vTJZny1B0S5pcoEvPNNMMkhIMRQp
         eYSEwLumBBkZ8sCvuKlOV0dBHgv9LMAAqIA25/2QSniBAjRoye39JhD06UA5Gm7Ngsy3
         IKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=TuEzIR2uESIWnuxyfH1eHFT+9Tcdti9EDHpVvf4j/1Y=;
        b=GvHgEhlUpKshYuFowwIXOGxbdtw7ripLt6pTVrjIrjCU+IbqnywU62DbPOYb3t4swX
         vF3C0m/J0/0kkE1MVEV40rsJrWDWjPyHWAgCVF5UHMb1XKSR0P6jKpqpH2B+vEtWcHLh
         jeW6n7r/koqkEjzKjXSum5hglFqM/BKDuaV9nQlgDpIH05b+zaZhB/qmKfklnKHqK+i1
         K8gXInga40l1Nw3KTMPuLWt8RncoZ/CpPjH2PVdRjy7KT2zfWPBLIob11Vx1gCzDKWIG
         kyEEbDSRu4ghPD4xm161xi57bp8GUMlovrnGHe4MtqlfgK2JHPu1zued6XrQfLlmBc4J
         i5KQ==
X-Gm-Message-State: ACgBeo1FnPm6nc1u+v2jopYRogeOYptIlGKAnI2X2mDcWEPB4IucC5cX
        Q+XHrnds6wjqJd5rBetbCli7x8CfVcU=
X-Google-Smtp-Source: AA6agR7GgsXeBwiRPy64/fTalDKJtX3KknB3Yhd/leHLUxzCnhR5CpkXyRqKF28lF7ZEEPDZE2xp5aqGTPs=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1101:b0:695:ce92:a857 with SMTP id
 o1-20020a056902110100b00695ce92a857mr2078061ybu.337.1661404225060; Wed, 24
 Aug 2022 22:10:25 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:45 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 8/9] KVM: arm64: selftests: Add a test case for a linked watchpoint
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the debug-exceptions test doesn't have a test case for
a linked watchpoint. Add a test case for the linked watchpoint to
the test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 9fccfeebccd3..dc94c85bb383 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -21,6 +21,9 @@
 #define DBGWCR_WR	(0x2 << 3)
 #define DBGWCR_EL1	(0x1 << 1)
 #define DBGWCR_E	(0x1 << 0)
+#define DBGWCR_LBN_SHIFT	16
+#define DBGWCR_WT_SHIFT		20
+#define DBGWCR_WT_LINK		(0x1 << DBGWCR_WT_SHIFT)
 
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
@@ -169,6 +172,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_debug_bwp_exception();
 }
 
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
+			   uint64_t ctx)
+{
+	uint32_t wcr;
+	uint64_t ctx_bcr;
+
+	/* Setup a context-aware breakpoint */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked watchpoint (linked to the context-aware breakpoint) */
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E |
+	      DBGWCR_WT_LINK | ((uint32_t)ctx_bp << DBGWCR_LBN_SHIFT);
+	write_dbgwcr(addr_wp, wcr);
+	write_dbgwvr(addr_wp, addr);
+	isb();
+
+	enable_debug_bwp_exception();
+}
+
 void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
 		       uint64_t ctx)
 {
@@ -323,6 +348,16 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 
 	GUEST_SYNC(10);
 
+	/* Linked watchpoint */
+	reset_debug_state();
+	install_wp_ctx(wpn, ctx_bpn, PC(write_data), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
 	GUEST_DONE();
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

