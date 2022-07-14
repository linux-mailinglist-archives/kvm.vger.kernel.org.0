Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D9B5751E7
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbiGNPf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbiGNPfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD670481EB
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A75161F20
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9EEC34114;
        Thu, 14 Jul 2022 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812921;
        bh=uKTZ7q/gsQNMYQ24/tzAJ7rKkKRt7Y+oaSKj6tJVeR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrPs/FEmrW+sYs9pCj4v3DxZdgeh0I8Tsvr048Y43pDwIVadWBGn7fZxVv2WjLaNu
         T5uI8onoV0BhrfHGkS2Ue6999gcxx7u932j6Wwe4S29XjjyZW8SvK8NZPEIdnna9pz
         lsjXfcPPlRM4mfAYkV90V/XzjtN7ZPcbd+anUMXKIxdJu/HuVPawbAXHGiYZXLeA3B
         m6/rwDltjUyWE6T8yk2CMBqDUwPblc/iiY/2+ckdID/3ktzJ3AqwufDuR/WPNBNCJq
         XjEBrGFnmQrcM0dpEGK2bWEEtvauB2aFC4uKX/xP35Wsw4+P37+pAulfS8Vk5HFmQP
         Wr6JfflRY5odA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dk-007UVL-TY;
        Thu, 14 Jul 2022 16:20:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 18/20] KVM: arm64: Get rid of find_reg_by_id()
Date:   Thu, 14 Jul 2022 16:20:22 +0100
Message-Id: <20220714152024.1673368-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 379478eecfaa..7ab67a7fc0d8 100644
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

