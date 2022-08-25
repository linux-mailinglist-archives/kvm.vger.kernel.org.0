Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E960C5A0853
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiHYFKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiHYFKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ACE9A6B5
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33dbfb6d2a3so5415497b3.11
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=8oX+5M8AEKJji1mM4AdRdiIeL9hn/q6yl0Bz7273pVA=;
        b=LeLhe13n76eUMhCg8SWeTVrWKNtcglEFQyn+mfy6n1dzAkWuQysdlKISXEtK+nMY8e
         KFHp3ByAxQkIys2eIl+f4hu/uA+oD6EZJNE/nEotAQeMIFarEHGOqga1SN984jZVdz/5
         N4Aza75aQ6ogp2RnHch+Zsn6Jalu1DrSU4kripuc0ELF5fnewHCu0Gn3vChBs1tgDaYd
         ADLEDy9zjAvrnk0uMK/T8HwpKQEAjAsqwE75J8fM/9mscrSuleHrzT67O3Y+FrHMSlaM
         uIsU6jEl8gn0OGNrQY/Fyk8idl1C4Cd9nBvGbyaOjjPwxpFmo+kDKFVMJMHLPRiAikRk
         k7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=8oX+5M8AEKJji1mM4AdRdiIeL9hn/q6yl0Bz7273pVA=;
        b=Ltkllk4s8EzcMtInLMdCpl5m3YGGbqcoKwODSEryO8dgsRBkGUXIZD/X5FTa0VEgRe
         eeOahuN0I0ZD8ogA5muFsaKngUdPG0iJ0UJm58gm8UamQjcSe6TtctqSTb7r2g9HqiEH
         65ZFLOYcDxenTsBehBz58OyC0H5FM+LMkQt3u8k9UE7mGWL2UpPNDokp/7hna+nErqcq
         XL0NXFDqoFTa8cXpTbO+TECq167XE+kzYa9ziMFVAF5P1bwXgHel8dD7B8UeQZsCGhQ3
         Djl4ReRvu66350uMvBlTCftIycUDQKHhzOqbNgOuABnZVohMd4Xh/9XYKWqHVmoHk8uU
         IqzQ==
X-Gm-Message-State: ACgBeo0+6jfeN8MsbNQYQLh/NRkWDV/ibL0ZGHJwSpMTnYT/NdQ/EIYU
        w/tE8Nx/Ed07F3NnXSGUvYlqyPJYEg0=
X-Google-Smtp-Source: AA6agR52jNE2uqaO7jEYMgZLpa+TwESVpjsc/w6zjrZheJdPE8MUiS+G/MUXsFxHt1MmvGcr0ODLhNAfaxQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:2cb:0:b0:688:ecfc:5865 with SMTP id
 h11-20020a5b02cb000000b00688ecfc5865mr2015078ybp.642.1661404216176; Wed, 24
 Aug 2022 22:10:16 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:41 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-5-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug exceptions
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

Add helpers to enable breakpoint and watchpoint exceptions.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 183ee16acb7d..713c7240b680 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -128,10 +128,20 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
+static void enable_debug_bwp_exception(void)
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
@@ -139,28 +149,19 @@ static void install_wp(uint8_t wpn, uint64_t addr)
 
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_debug_bwp_exception();
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
+	enable_debug_bwp_exception();
 }
 
 static void install_ss(void)
-- 
2.37.1.595.g718a3a8f04-goog

