Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006976B77F8
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCMMtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCMMs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 08:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC77726C30
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 05:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68EBCB8108F
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 12:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251A1C4339B;
        Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678711734;
        bh=KNvXqpiDb3tNFNreCU+D88wtLPb14YK8f59V/6UqA+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRhLIeE/NwlG/xZ2EvJ4GKrQyB9mMI51rT2hWFh+q7HusPKzoBkySJ0SV0q+AcLjP
         5+1yoHtCjijEdAoElg5d1IssshCgJKzjs5PxemOiFKQghvnuVciCxFpjiGfK0ssm/t
         uuXy4jI0WY2xqwfsumQhoUAE5idLtxuo5cajZ2AhjlmvBPyIyhZNn468CWGgAzXJj3
         vS+K+gJNA7bn6ejLiGw74JwgG09nMl/5bc/xNnhI9R2EoECWDcOWe/y4X/y9y7BrY/
         Afwr8Ujd3/h76ivvCX/muutRnCZdUpV3LO7rmq+y3VxuBHf/Gl7Tn9ylXqG8rCoYij
         rCOA06yeheMRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbg-00HEdE-7A;
        Mon, 13 Mar 2023 12:48:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v2 03/19] arm64: Add CNTPOFF_EL2 register definition
Date:   Mon, 13 Mar 2023 12:48:21 +0000
Message-Id: <20230313124837.2264882-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the definition for CNTPOFF_EL2 in the description file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dd5a9c7e310f..7063f1aacc54 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1952,6 +1952,10 @@ Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
 
+Sysreg	CNTPOFF_EL2	3	4	14	0	6
+Field	63:0	PhysicalOffset
+EndSysreg
+
 Sysreg	CPACR_EL12	3	5	1	0	2
 Fields	CPACR_ELx
 EndSysreg
-- 
2.34.1

