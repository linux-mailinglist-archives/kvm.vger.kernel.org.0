Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54EC6056E7
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJTFmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJTFmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:42:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FE319C05E
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso18439892ybq.21
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELzAVn+3sNc+4loFg06+kDTn2r7oBUPNaJZquHZJGM8=;
        b=JHe9BhP8WxnUbibz6mt6YrXKaJ8YGE5HpO4NBAJasDjfzX6DH+FcWz/XA8i3DPgO+p
         IdhKCFDnzk5HbJ3oNT6RDfyg0Z9C0EeQ/XxJ9EKICgTXNawqyOk+vgb5hFo6UQCx8nVK
         ZKTsmXkj0jLCeWzC+WMWjrRGS8WDAy/749MHc14vQ5evsPc2NXLmx8VNJ0rbBnvb2/Xy
         5zI6/pvcBwkVjN6NACbeFpP/E8FMP+cwvZJ0Ovuy025NxlUFlKNnp01rl1mOEO7w90LG
         Gr+BX+BLdl8IPeROXbXAfLtkFLRqlwTO2L54IxyzvTlT6LqkZffO7mKaveT3ZeinuHqe
         vENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ELzAVn+3sNc+4loFg06+kDTn2r7oBUPNaJZquHZJGM8=;
        b=ZJxGSTOmQ4bEz3qgchgzGRecKLM6KbbFyWfzO782IREeifWO1xCqkWZ1O9MJ9NZTVg
         gZZW2lB/V4vm8TnEZQx2pEuyDyFKoIa61Rr4yeyozz3P567nWsR34wAabJCwYoOeI+KD
         na6jA7F2DvLiQ+8fQIxar4U/3RaQBXm5U+3ritkTSRIB9GLWjObJwtAsIyx55S6U+nUG
         F+vfL7ioJVRhata1h1t/Tg1lp4NTSTg6g8Bvdt3mJJ2dxZnsBARWL6vSkXQBugr7m4YL
         R+dCEAjo9GT2jtElKUp90kUJlgxAHhvT9G669J2k7jj8jZ29huMTlhIMiTnmr4uZ/WTq
         ITnQ==
X-Gm-Message-State: ACrzQf1jjNk1wPvuMdd77I0YGwikcsXU8siouUz8p5KJH6JFyR/2XlWa
        BFhiYpCt623Cu3r17EoKO/MrXMbu9LM=
X-Google-Smtp-Source: AMsMyM40Wdm+aeMOq5/+3bxZYEWlyCvjAW5HTHRrIls1sP9psLlqv/cFoMirmbh8Ju7nrRwXqbWzEiB5zBY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a0d:eb88:0:b0:367:284a:a4a with SMTP id
 u130-20020a0deb88000000b00367284a0a4amr5163460ywe.282.1666244564673; Wed, 19
 Oct 2022 22:42:44 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:55 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-3-reijiw@google.com>
Subject: [PATCH v2 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r
 helpers in debug-exceptions
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

Introduce helpers in the debug-exceptions test to write to
dbg{b,w}{c,v}r registers. Those helpers will be useful for
test cases that will be added to the test in subsequent patches.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 3808d3d75055..d9884907fe87 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -30,6 +30,69 @@ static volatile uint64_t svc_addr;
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
@@ -61,8 +124,9 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(wcr, dbgwcr0_el1);
-	write_sysreg(addr, dbgwvr0_el1);
+	write_dbgwcr(0, wcr);
+	write_dbgwvr(0, addr);
+
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -78,8 +142,8 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(bcr, dbgbcr0_el1);
-	write_sysreg(addr, dbgbvr0_el1);
+	write_dbgbcr(0, bcr);
+	write_dbgbvr(0, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
-- 
2.38.0.413.g74048e4d9e-goog

