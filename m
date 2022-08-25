Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0DD5A084E
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiHYFKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiHYFKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:13 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6B789CCE
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-334d894afd8so327297067b3.19
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=mbWwPoUmijWxZF1qqEuvmzXuoM73rXdJ5r3D+vU7B94=;
        b=r8VhFLOaJT2TiUfv5+8axKHdrA7rd9E3CpESCV4oQAWgvQswx5RdABZz3ahHrg7fzv
         ttpqQCCUQxkXo+K4PSCAiJwLlIaaNI9WnmqxpF8e1QHDG8fgfywLytaA1eDi6Kafx/8u
         +cqUU1Yg8lR/QkMl2G0o6DiG4wglSuwNEh07eEhQMwELJ4u8LQ4Ym/Szse8yiZp2eWL9
         18+wMWphGzs99MzWHLecuNFbW868I3BVRiBJ23r8/6RJxC2HLGBRSeD7dMi6+d08vtuW
         tLAg3yvOYQsfnzGwFL1sfHzqISWlVUCuJhgEfXtUq1zr2KOI9BDEInIwHt+eIFjCjBPO
         loTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=mbWwPoUmijWxZF1qqEuvmzXuoM73rXdJ5r3D+vU7B94=;
        b=P056TEs2qqat3zRfsW1j4p1iqLyA6WN2D+fmb5LvODPXnM3BCxiuwDNX/YoIDoDdqP
         YrGGMjD4nzcjgRja3YQSWuhk6udN9RtZXwJY7M+nr6Cj2YroFXnsEoqTotxpEG48M+b6
         J+ZZeew5SfXCg0SA7McG1+dvfd7WqS+wu7oNI6jzNtmK9dyw/I1ky8EPoSTJ4t0fToWn
         HaaCaG/DEgL3hWhVFQsGGvzoL2Gp2kFPBJbelH8DL+dEudWus8+MJTLOC/H2idwtVvx7
         r19jAivZwmwF4cZOcU9sqV8kd0mT6F3WjfA2q+3V9uGEHmwcox840ZQ8C1wUYr9BXQ1+
         C0bA==
X-Gm-Message-State: ACgBeo2IF+ikjJbFN/d2/3qbEol2dqh9fsfPi6ck45UvPBtxHpkvtsli
        8KACeWxGM8dsWw46WKe2W7tzp+DAkRQ=
X-Google-Smtp-Source: AA6agR6Y3Gi8FMQjP63JX1oEF6pk6Y3m+wYPfkv8vdoUapXy4ra3FJcrC1HheWBCS6yZioM75J0QQ0KL4KQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:2f4a:0:b0:695:8b9a:1788 with SMTP id
 v71-20020a252f4a000000b006958b9a1788mr1971181ybv.126.1661404211856; Wed, 24
 Aug 2022 22:10:11 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:39 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers
 in debug-exceptions
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

Introduce helpers in the debug-exceptions test to write to
dbg{b,w}{c,v}r registers. Those helpers will be useful for
test cases that will be added to the test in subsequent patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..51047e6b8db3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -28,6 +28,69 @@ static volatile uint64_t svc_addr;
 static volatile uint64_t ss_addr[4], ss_idx;
 #define  PC(v)  ((uint64_t)&(v))
 
+#define GEN_DEBUG_WRITE_REG(reg_name)			\
+static void write_##reg_name(int num, uint64_t val)	\
+{							\
+	switch (num) {					\
+	case 0:						\
+		write_sysreg(val, reg_name##0_el1);	\
+		break;					\
+	case 1:						\
+		write_sysreg(val, reg_name##1_el1);	\
+		break;					\
+	case 2:						\
+		write_sysreg(val, reg_name##2_el1);	\
+		break;					\
+	case 3:						\
+		write_sysreg(val, reg_name##3_el1);	\
+		break;					\
+	case 4:						\
+		write_sysreg(val, reg_name##4_el1);	\
+		break;					\
+	case 5:						\
+		write_sysreg(val, reg_name##5_el1);	\
+		break;					\
+	case 6:						\
+		write_sysreg(val, reg_name##6_el1);	\
+		break;					\
+	case 7:						\
+		write_sysreg(val, reg_name##7_el1);	\
+		break;					\
+	case 8:						\
+		write_sysreg(val, reg_name##8_el1);	\
+		break;					\
+	case 9:						\
+		write_sysreg(val, reg_name##9_el1);	\
+		break;					\
+	case 10:					\
+		write_sysreg(val, reg_name##10_el1);	\
+		break;					\
+	case 11:					\
+		write_sysreg(val, reg_name##11_el1);	\
+		break;					\
+	case 12:					\
+		write_sysreg(val, reg_name##12_el1);	\
+		break;					\
+	case 13:					\
+		write_sysreg(val, reg_name##13_el1);	\
+		break;					\
+	case 14:					\
+		write_sysreg(val, reg_name##14_el1);	\
+		break;					\
+	case 15:					\
+		write_sysreg(val, reg_name##15_el1);	\
+		break;					\
+	default:					\
+		GUEST_ASSERT(0);			\
+	}						\
+}
+
+/* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
+GEN_DEBUG_WRITE_REG(dbgbcr)
+GEN_DEBUG_WRITE_REG(dbgbvr)
+GEN_DEBUG_WRITE_REG(dbgwcr)
+GEN_DEBUG_WRITE_REG(dbgwvr)
+
 static void reset_debug_state(void)
 {
 	asm volatile("msr daifset, #8");
@@ -59,8 +122,9 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(wcr, dbgwcr0_el1);
-	write_sysreg(addr, dbgwvr0_el1);
+	write_dbgwcr(0, wcr);
+	write_dbgwvr(0, addr);
+
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -76,8 +140,8 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(bcr, dbgbcr0_el1);
-	write_sysreg(addr, dbgbvr0_el1);
+	write_dbgbcr(0, bcr);
+	write_dbgbvr(0, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
-- 
2.37.1.595.g718a3a8f04-goog

