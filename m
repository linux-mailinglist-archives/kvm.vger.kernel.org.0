Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4A0774772
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjHHTPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbjHHTO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B1637CAE
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCB06250A
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217DDC433CB;
        Tue,  8 Aug 2023 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495238;
        bh=Ph1+tRKzVKdyf4Punoam7MFsr5SrhDeK9ZgeYBacndg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAe6KXnLYaho2UF6GYVDLX4LBVLrq9azzUF1KUqSVvgm4SapsJe+3GYeodabunIOO
         3XSIOctgrfdFf1ryk1rFTnzKJz/kV7CNzouZP1LjHUMaKL5E0gKTNrJz84iswQxz5g
         v3R1MrSbJbr5FJD7oHue+QYS6wvIesXjOIv2NdpvmAjw1BVr//tRsR7tuqObSgV1h3
         +zEkBve3cwi86ccAzaQAvUJiLS7LNc5l8zqt934t9G5PnUGne+YYsylXapJnbP8Yjt
         YBBkwuv7Y3hJzf7OtpkkdOBn5OSjcpD8zAyjlJ3TcNGOhFQFIfOMKak9tWO45s8OUh
         z+31D9PPkRAMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBE-0037Ph-16;
        Tue, 08 Aug 2023 12:47:16 +0100
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
Subject: [PATCH v3 04/27] arm64: Add TLBI operation encodings
Date:   Tue,  8 Aug 2023 12:46:48 +0100
Message-Id: <20230808114711.2013842-5-maz@kernel.org>
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

Add all the TLBI encodings that are usable from Non-Secure.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 128 ++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 5084add86897..72e18480ce62 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -514,6 +514,134 @@
 
 #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
 
+/* TLBI instructions */
+#define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
+#define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
+#define OP_TLBI_ASIDE1OS		sys_insn(1, 0, 8, 1, 2)
+#define OP_TLBI_VAAE1OS			sys_insn(1, 0, 8, 1, 3)
+#define OP_TLBI_VALE1OS			sys_insn(1, 0, 8, 1, 5)
+#define OP_TLBI_VAALE1OS		sys_insn(1, 0, 8, 1, 7)
+#define OP_TLBI_RVAE1IS			sys_insn(1, 0, 8, 2, 1)
+#define OP_TLBI_RVAAE1IS		sys_insn(1, 0, 8, 2, 3)
+#define OP_TLBI_RVALE1IS		sys_insn(1, 0, 8, 2, 5)
+#define OP_TLBI_RVAALE1IS		sys_insn(1, 0, 8, 2, 7)
+#define OP_TLBI_VMALLE1IS		sys_insn(1, 0, 8, 3, 0)
+#define OP_TLBI_VAE1IS			sys_insn(1, 0, 8, 3, 1)
+#define OP_TLBI_ASIDE1IS		sys_insn(1, 0, 8, 3, 2)
+#define OP_TLBI_VAAE1IS			sys_insn(1, 0, 8, 3, 3)
+#define OP_TLBI_VALE1IS			sys_insn(1, 0, 8, 3, 5)
+#define OP_TLBI_VAALE1IS		sys_insn(1, 0, 8, 3, 7)
+#define OP_TLBI_RVAE1OS			sys_insn(1, 0, 8, 5, 1)
+#define OP_TLBI_RVAAE1OS		sys_insn(1, 0, 8, 5, 3)
+#define OP_TLBI_RVALE1OS		sys_insn(1, 0, 8, 5, 5)
+#define OP_TLBI_RVAALE1OS		sys_insn(1, 0, 8, 5, 7)
+#define OP_TLBI_RVAE1			sys_insn(1, 0, 8, 6, 1)
+#define OP_TLBI_RVAAE1			sys_insn(1, 0, 8, 6, 3)
+#define OP_TLBI_RVALE1			sys_insn(1, 0, 8, 6, 5)
+#define OP_TLBI_RVAALE1			sys_insn(1, 0, 8, 6, 7)
+#define OP_TLBI_VMALLE1			sys_insn(1, 0, 8, 7, 0)
+#define OP_TLBI_VAE1			sys_insn(1, 0, 8, 7, 1)
+#define OP_TLBI_ASIDE1			sys_insn(1, 0, 8, 7, 2)
+#define OP_TLBI_VAAE1			sys_insn(1, 0, 8, 7, 3)
+#define OP_TLBI_VALE1			sys_insn(1, 0, 8, 7, 5)
+#define OP_TLBI_VAALE1			sys_insn(1, 0, 8, 7, 7)
+#define OP_TLBI_VMALLE1OSNXS		sys_insn(1, 0, 9, 1, 0)
+#define OP_TLBI_VAE1OSNXS		sys_insn(1, 0, 9, 1, 1)
+#define OP_TLBI_ASIDE1OSNXS		sys_insn(1, 0, 9, 1, 2)
+#define OP_TLBI_VAAE1OSNXS		sys_insn(1, 0, 9, 1, 3)
+#define OP_TLBI_VALE1OSNXS		sys_insn(1, 0, 9, 1, 5)
+#define OP_TLBI_VAALE1OSNXS		sys_insn(1, 0, 9, 1, 7)
+#define OP_TLBI_RVAE1ISNXS		sys_insn(1, 0, 9, 2, 1)
+#define OP_TLBI_RVAAE1ISNXS		sys_insn(1, 0, 9, 2, 3)
+#define OP_TLBI_RVALE1ISNXS		sys_insn(1, 0, 9, 2, 5)
+#define OP_TLBI_RVAALE1ISNXS		sys_insn(1, 0, 9, 2, 7)
+#define OP_TLBI_VMALLE1ISNXS		sys_insn(1, 0, 9, 3, 0)
+#define OP_TLBI_VAE1ISNXS		sys_insn(1, 0, 9, 3, 1)
+#define OP_TLBI_ASIDE1ISNXS		sys_insn(1, 0, 9, 3, 2)
+#define OP_TLBI_VAAE1ISNXS		sys_insn(1, 0, 9, 3, 3)
+#define OP_TLBI_VALE1ISNXS		sys_insn(1, 0, 9, 3, 5)
+#define OP_TLBI_VAALE1ISNXS		sys_insn(1, 0, 9, 3, 7)
+#define OP_TLBI_RVAE1OSNXS		sys_insn(1, 0, 9, 5, 1)
+#define OP_TLBI_RVAAE1OSNXS		sys_insn(1, 0, 9, 5, 3)
+#define OP_TLBI_RVALE1OSNXS		sys_insn(1, 0, 9, 5, 5)
+#define OP_TLBI_RVAALE1OSNXS		sys_insn(1, 0, 9, 5, 7)
+#define OP_TLBI_RVAE1NXS		sys_insn(1, 0, 9, 6, 1)
+#define OP_TLBI_RVAAE1NXS		sys_insn(1, 0, 9, 6, 3)
+#define OP_TLBI_RVALE1NXS		sys_insn(1, 0, 9, 6, 5)
+#define OP_TLBI_RVAALE1NXS		sys_insn(1, 0, 9, 6, 7)
+#define OP_TLBI_VMALLE1NXS		sys_insn(1, 0, 9, 7, 0)
+#define OP_TLBI_VAE1NXS			sys_insn(1, 0, 9, 7, 1)
+#define OP_TLBI_ASIDE1NXS		sys_insn(1, 0, 9, 7, 2)
+#define OP_TLBI_VAAE1NXS		sys_insn(1, 0, 9, 7, 3)
+#define OP_TLBI_VALE1NXS		sys_insn(1, 0, 9, 7, 5)
+#define OP_TLBI_VAALE1NXS		sys_insn(1, 0, 9, 7, 7)
+#define OP_TLBI_IPAS2E1IS		sys_insn(1, 4, 8, 0, 1)
+#define OP_TLBI_RIPAS2E1IS		sys_insn(1, 4, 8, 0, 2)
+#define OP_TLBI_IPAS2LE1IS		sys_insn(1, 4, 8, 0, 5)
+#define OP_TLBI_RIPAS2LE1IS		sys_insn(1, 4, 8, 0, 6)
+#define OP_TLBI_ALLE2OS			sys_insn(1, 4, 8, 1, 0)
+#define OP_TLBI_VAE2OS			sys_insn(1, 4, 8, 1, 1)
+#define OP_TLBI_ALLE1OS			sys_insn(1, 4, 8, 1, 4)
+#define OP_TLBI_VALE2OS			sys_insn(1, 4, 8, 1, 5)
+#define OP_TLBI_VMALLS12E1OS		sys_insn(1, 4, 8, 1, 6)
+#define OP_TLBI_RVAE2IS			sys_insn(1, 4, 8, 2, 1)
+#define OP_TLBI_RVALE2IS		sys_insn(1, 4, 8, 2, 5)
+#define OP_TLBI_ALLE2IS			sys_insn(1, 4, 8, 3, 0)
+#define OP_TLBI_VAE2IS			sys_insn(1, 4, 8, 3, 1)
+#define OP_TLBI_ALLE1IS			sys_insn(1, 4, 8, 3, 4)
+#define OP_TLBI_VALE2IS			sys_insn(1, 4, 8, 3, 5)
+#define OP_TLBI_VMALLS12E1IS		sys_insn(1, 4, 8, 3, 6)
+#define OP_TLBI_IPAS2E1OS		sys_insn(1, 4, 8, 4, 0)
+#define OP_TLBI_IPAS2E1			sys_insn(1, 4, 8, 4, 1)
+#define OP_TLBI_RIPAS2E1		sys_insn(1, 4, 8, 4, 2)
+#define OP_TLBI_RIPAS2E1OS		sys_insn(1, 4, 8, 4, 3)
+#define OP_TLBI_IPAS2LE1OS		sys_insn(1, 4, 8, 4, 4)
+#define OP_TLBI_IPAS2LE1		sys_insn(1, 4, 8, 4, 5)
+#define OP_TLBI_RIPAS2LE1		sys_insn(1, 4, 8, 4, 6)
+#define OP_TLBI_RIPAS2LE1OS		sys_insn(1, 4, 8, 4, 7)
+#define OP_TLBI_RVAE2OS			sys_insn(1, 4, 8, 5, 1)
+#define OP_TLBI_RVALE2OS		sys_insn(1, 4, 8, 5, 5)
+#define OP_TLBI_RVAE2			sys_insn(1, 4, 8, 6, 1)
+#define OP_TLBI_RVALE2			sys_insn(1, 4, 8, 6, 5)
+#define OP_TLBI_ALLE2			sys_insn(1, 4, 8, 7, 0)
+#define OP_TLBI_VAE2			sys_insn(1, 4, 8, 7, 1)
+#define OP_TLBI_ALLE1			sys_insn(1, 4, 8, 7, 4)
+#define OP_TLBI_VALE2			sys_insn(1, 4, 8, 7, 5)
+#define OP_TLBI_VMALLS12E1		sys_insn(1, 4, 8, 7, 6)
+#define OP_TLBI_IPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 1)
+#define OP_TLBI_RIPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 2)
+#define OP_TLBI_IPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 5)
+#define OP_TLBI_RIPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 6)
+#define OP_TLBI_ALLE2OSNXS		sys_insn(1, 4, 9, 1, 0)
+#define OP_TLBI_VAE2OSNXS		sys_insn(1, 4, 9, 1, 1)
+#define OP_TLBI_ALLE1OSNXS		sys_insn(1, 4, 9, 1, 4)
+#define OP_TLBI_VALE2OSNXS		sys_insn(1, 4, 9, 1, 5)
+#define OP_TLBI_VMALLS12E1OSNXS		sys_insn(1, 4, 9, 1, 6)
+#define OP_TLBI_RVAE2ISNXS		sys_insn(1, 4, 9, 2, 1)
+#define OP_TLBI_RVALE2ISNXS		sys_insn(1, 4, 9, 2, 5)
+#define OP_TLBI_ALLE2ISNXS		sys_insn(1, 4, 9, 3, 0)
+#define OP_TLBI_VAE2ISNXS		sys_insn(1, 4, 9, 3, 1)
+#define OP_TLBI_ALLE1ISNXS		sys_insn(1, 4, 9, 3, 4)
+#define OP_TLBI_VALE2ISNXS		sys_insn(1, 4, 9, 3, 5)
+#define OP_TLBI_VMALLS12E1ISNXS		sys_insn(1, 4, 9, 3, 6)
+#define OP_TLBI_IPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 0)
+#define OP_TLBI_IPAS2E1NXS		sys_insn(1, 4, 9, 4, 1)
+#define OP_TLBI_RIPAS2E1NXS		sys_insn(1, 4, 9, 4, 2)
+#define OP_TLBI_RIPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 3)
+#define OP_TLBI_IPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 4)
+#define OP_TLBI_IPAS2LE1NXS		sys_insn(1, 4, 9, 4, 5)
+#define OP_TLBI_RIPAS2LE1NXS		sys_insn(1, 4, 9, 4, 6)
+#define OP_TLBI_RIPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 7)
+#define OP_TLBI_RVAE2OSNXS		sys_insn(1, 4, 9, 5, 1)
+#define OP_TLBI_RVALE2OSNXS		sys_insn(1, 4, 9, 5, 5)
+#define OP_TLBI_RVAE2NXS		sys_insn(1, 4, 9, 6, 1)
+#define OP_TLBI_RVALE2NXS		sys_insn(1, 4, 9, 6, 5)
+#define OP_TLBI_ALLE2NXS		sys_insn(1, 4, 9, 7, 0)
+#define OP_TLBI_VAE2NXS			sys_insn(1, 4, 9, 7, 1)
+#define OP_TLBI_ALLE1NXS		sys_insn(1, 4, 9, 7, 4)
+#define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
+#define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
-- 
2.34.1

