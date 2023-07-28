Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5071A766726
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbjG1Ib2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjG1Ia4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7198C3AA2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 102D662018
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C722BC43395;
        Fri, 28 Jul 2023 08:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690533000;
        bh=r+g/VcnlqQCVOIqSl1HA4CWQfHzoONGsqLE5TosmZy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j939pBFK3ckt759NmZoUDxWxsDHXHQES8XUHQbTGeAoACO+E1ChhMM9lhbk9TUG8F
         +tDBAhFYfXYCACeg+xZ80IKrDWpXVDh1A/7Gh7dN6c3LobG9AeFcDKMWW6osvKDvb0
         Rclm/M7uPeziNk0FitJ3cFMgQuTnQCTgXJPJwLb2rOOGc0XR2S3RlKi7KM6yJ5ND2a
         BtLpuj8KgwIlJLb4iC2XiZ4rHUuIdr4Gpqgfk6BKOuG1u+Nhr7J/sO3kW4javuspQ0
         nk1iObWQQ9hupm8+j4P84VUOn9OlkXE7OnGVH4Jcz/Cp01F2ggcjRHidogb/HW8t4r
         Qq5+s00/uSLqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrG-0000EO-OG;
        Fri, 28 Jul 2023 09:29:58 +0100
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
Subject: [PATCH v2 01/26] arm64: Add missing VA CMO encodings
Date:   Fri, 28 Jul 2023 09:29:27 +0100
Message-Id: <20230728082952.959212-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the missing VA-based CMOs encodings.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b481935e9314..85447e68951a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -124,6 +124,32 @@
 #define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
 #define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
 
+#define SYS_IC_IALLUIS			sys_insn(1, 0, 7, 1, 0)
+#define SYS_IC_IALLU			sys_insn(1, 0, 7, 5, 0)
+#define SYS_IC_IVAU			sys_insn(1, 3, 7, 5, 1)
+
+#define SYS_DC_IVAC			sys_insn(1, 0, 7, 6, 1)
+#define SYS_DC_IGVAC			sys_insn(1, 0, 7, 6, 3)
+#define SYS_DC_IGDVAC			sys_insn(1, 0, 7, 6, 5)
+
+#define SYS_DC_CVAC			sys_insn(1, 3, 7, 10, 1)
+#define SYS_DC_CGVAC			sys_insn(1, 3, 7, 10, 3)
+#define SYS_DC_CGDVAC			sys_insn(1, 3, 7, 10, 5)
+
+#define SYS_DC_CVAU			sys_insn(1, 3, 7, 11, 1)
+
+#define SYS_DC_CVAP			sys_insn(1, 3, 7, 12, 1)
+#define SYS_DC_CGVAP			sys_insn(1, 3, 7, 12, 3)
+#define SYS_DC_CGDVAP			sys_insn(1, 3, 7, 12, 5)
+
+#define SYS_DC_CVADP			sys_insn(1, 3, 7, 13, 1)
+#define SYS_DC_CGVADP			sys_insn(1, 3, 7, 13, 3)
+#define SYS_DC_CGDVADP			sys_insn(1, 3, 7, 13, 5)
+
+#define SYS_DC_CIVAC			sys_insn(1, 3, 7, 14, 1)
+#define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
+#define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
-- 
2.34.1

