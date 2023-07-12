Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9C6750B92
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjGLO7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjGLO7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485001BCA
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D4E61864
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E0C433CC;
        Wed, 12 Jul 2023 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689173930;
        bh=GjW92eLPQB/b++Gprz2H0IZOgXi3BU2wMKh/iuL1bTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oo0b2aaEHUtm/2W7nuR6CVR51RIdL/cv73VadWjpYeXliwSZ4x5tmdDfdxlVNhRrt
         vYP24d6Z+ecMWfOVB3TSq9Ehye4xRYXJcDWhq8dIH5k1ive/mau1AOynaFwnZ0dwkE
         r5xpQMx6n1KlY0AZVokciuYZ9GQuCHbQ5p0F1kD9N3LqsacSRY9IBqdmn/ZQ8Z+TW1
         f9FmrltEabcH1HbRuwIsZEu/K1ABh+KnW162E4umKDM0wqQQA5QIr1JHfj2U2+p0kN
         cYIxfRNrhDcmPEoWQpoV7bC6LeNYhRHQp0jGVUhfBg0j8HogwJ/VQRkQ3jGkAykk9t
         Wjmw3Qj4/DrwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIm-00CUNF-Td;
        Wed, 12 Jul 2023 15:58:48 +0100
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
Subject: [PATCH 05/27] arm64: Add AT operation encodings
Date:   Wed, 12 Jul 2023 15:57:48 +0100
Message-Id: <20230712145810.3864793-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the encodings for the AT operation that are usable from NS.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 72e18480ce62..76289339b43b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -514,6 +514,23 @@
 
 #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
 
+/* AT instructions */
+#define AT_Op0 1
+#define AT_CRn 7
+
+#define OP_AT_S1E1R	sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
+#define OP_AT_S1E1W	sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
+#define OP_AT_S1E0R	sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
+#define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
+#define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
+#define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
+#define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
+#define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
+#define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
+#define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
+#define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
+#define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
+
 /* TLBI instructions */
 #define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
 #define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
-- 
2.34.1

