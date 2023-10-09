Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FC57BEEE3
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379141AbjJIXKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379146AbjJIXKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:04 -0400
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B796DA
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:08 -0700 (PDT)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-1d6fdbe39c8so7445390fac.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892948; x=1697497748; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gqnG4RpBlXbew2IIW8/0Y16WbuRr1AUJcTSoXQ3GxWs=;
        b=sykqH8cOdKRdvXGw2phY/cQrflSnyPEu7t2RqmstyKxKsubhSyWtqL13lyjw1mMsFQ
         KfoMmCBsCJ3y1ApKZd3yOb38E0yQSInkfg+aOa8zIdwAln8GYt5lQl2ErUxs89BItgga
         xoCicS1XSH3lXFXPfM3roRMiCoaKM/durA5+i8o8YRSSOH00e6r7Q22jZJVv9koothNh
         Goi/8ralsD4rpaQBY1+Eh9izG+42RNK2A5MhnIwHWIIw3psc3xFVx/DC7TTG4bbmya4Q
         dO8+b4nrf0dgMQDqNwHhB+QKBUMuDi2JY2RMo+ZDjsVl/x5D42S1gvTX8LCEpYB+KJbW
         BDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892948; x=1697497748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqnG4RpBlXbew2IIW8/0Y16WbuRr1AUJcTSoXQ3GxWs=;
        b=FSuBmgCJVyhQUjPr4tjbqDuNOnVgbhG2XyH1MuDfYHaAc30RVHDKHs8VcKfxDHCjS6
         yrKbonsrE5vrXs8com11WMS0lBTbMRoQj+m4Hij/roznhuqyLx2X3SupMuzsKAXsLpsw
         KYSUASdxEKF3p48QHVrCuaw9knHw2/WxGMMUWgf4AHg4hWllqjLsJfrRJUWXIozbTO1l
         lL1AEVMEpQ9YNV/KISZozxgs2XaCLqG8JeOpbIxrGUsYsgc/2S/wolIpfxmDmsueyTvt
         GYNNlNO1DzBYG4NKHIqU+F9Pp0LVAxVif4sFMA5nK2sf6Z4xQeiRWrPxRkD7zbZLxB/X
         uEVQ==
X-Gm-Message-State: AOJu0YzpQOlXqXHKJs8og7cCTgxVpfOYPjV703iFywdJDfpM9rmhHqjr
        56Ck2pj61xCVCVGW95aN9rAuvQE9pPOi
X-Google-Smtp-Source: AGHT+IHZZh94mOKGfOCAtlgZAgd/+koLjHYW/Z6Xqzqw/ekKEsynPRD2lrKaZKtg4PoFRUM5ElzQFOQbafP8
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6870:7686:b0:1c8:f237:303a with SMTP
 id dx6-20020a056870768600b001c8f237303amr6171317oab.5.1696892948012; Mon, 09
 Oct 2023 16:09:08 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:50 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-5-rananta@google.com>
Subject: [PATCH v7 04/12] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3dbb7d276b0e..08af7824e9d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0, },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0, },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.42.0.609.gbb76f46606-goog

