Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3EE569045
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiGFRFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiGFRFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49EA2A705
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696BB61E7B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC3C3411C;
        Wed,  6 Jul 2022 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127121;
        bh=R/yEgMh7z7fdGbMO2kbb8mcFadwBI9nk3leyMdDelqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQsuGml4GQTZh7nxo9xQMXq7Jv8QdaLqKs//hUvgy3fMd1BFNKaHnLwmQZMskqroO
         ijNPvAaYPGWjgrdgQU2bcHzIdIZalWxLTRr+/beo9/OY/7x9xXSYCDmXOo1tPGJtQt
         2Fr/h+3NX3AteS28s/XGaS2csfZeBDniE8WksYZGSbe1PNLXBBl3Mt2iIdfhg2l43F
         UCLkgJkahmD8m+15A8h5wJrartCfZl+pEhIct/WytBT/jWCgmOq5mpMhje08V+AJzR
         LTCDJBCbOPwUPHIQ31Ua096wAy4F1X9c6+x3kVMHxR2/XUWVm5Yznq+435FdbEgiyb
         GU4E/9R7EyaVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987O-005h9i-CS;
        Wed, 06 Jul 2022 17:43:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 17/19] KVM: arm64: Get rid of find_reg_by_id()
Date:   Wed,  6 Jul 2022 17:43:02 +0100
Message-Id: <20220706164304.1582687-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper doesn't have a user anymore, let's get rid of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 11 -----------
 arch/arm64/kvm/sys_regs.h |  5 -----
 2 files changed, 16 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b66be9df7a02..d3ac0cd1c2e2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2577,17 +2577,6 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num)
-{
-	if (!index_to_params(id, params))
-		return NULL;
-
-	return find_reg(params, table, num);
-}
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index b8b576a2af2b..49517f58deb5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -190,11 +190,6 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num);
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.34.1

