Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF0774B5D
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbjHHUpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjHHUpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E60014597
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB00624E5
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B286C433C8;
        Tue,  8 Aug 2023 11:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495239;
        bh=5iKpslBQZfnKRLEGs+Ud+1WPRDTfwxOGNa25YZkpxEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjMDjWo/L3BeDKA14sIwqkZvUqv9QlBy6HuDzNp9Z8I82y4gaT3tLnvYe4AMJNEnR
         77G7+jQtjDmw2ziXdu+ffKlBhbGsI108BRakIvtxMzbNMDaEHSCRK/P6zBYtxGaLsk
         miVJthnpdeL63ZGDo9R6t9Ziw+NJn71WQDjFHsh3iTeUowLkB/YVfoxFzasjc40Nih
         ZoQ3m0Pt9PrE19TqxLexFeeF8YIaNhp3AR0vtOdD+PUiLRzB5MYCw/n6Weo+UA+S27
         CdEcavD5jYEeotaik3rePACzWA/Qk1Bz5GD6deAyzVuT2+4mpinHES8nXDOeWgdt2l
         56/xuQDSzzt6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBF-0037Ph-0t;
        Tue, 08 Aug 2023 12:47:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
Date:   Tue,  8 Aug 2023 12:46:51 +0100
Message-Id: <20230808114711.2013842-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HFGITR_EL2 traps a bunch of instructions for which we don't have
encodings yet. Add them.

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index bb5a0877a210..6d9d7ac4b31c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -735,6 +735,13 @@
 #define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
 #define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
 
+/* Misc instructions */
+#define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
+#define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
+#define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
+#define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
+#define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
-- 
2.34.1

