Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0E774B63
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbjHHUqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjHHUp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05E91424C
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C1CE624FB
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA68EC433CA;
        Tue,  8 Aug 2023 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495237;
        bh=k70vbGyqtpFHqhcl5LnkNzDTDcL16PBph+LK/kmFZ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWlemGLL9nKR9YW4eyEYFjneYgBex87iSIMrSL6aBXcwZ//GVkkqmiwezRn3VLqw+
         9HA3pa6Or8/zHx6AGFNuoDPjoLeWKNFoV8h4+96xLRgPixrQXasjYHwmRt4bIB30vi
         OPAKD6XmzzhynLwFnuS31nD0E6fAqySygG7Ya49tWcdF6rnP24sfYyFGpYuJM9DHlM
         Qk8MIwZvdl1LYR0NQoG7dy9KodialIclvsTgtiO0UUhqVf+taeBjtHP9qUXg0T8RSy
         d9SczPUVrLVwNAfCCdnJ25Rm2hf5SCZEFBBXjfO+DlyOH+0pvYKYUrAoTkx30ksMq3
         1vAxNviv7kYSQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBD-0037Ph-MY;
        Tue, 08 Aug 2023 12:47:15 +0100
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
Subject: [PATCH v3 03/27] arm64: Add missing DC ZVA/GVA/GZVA encodings
Date:   Tue,  8 Aug 2023 12:46:47 +0100
Message-Id: <20230808114711.2013842-4-maz@kernel.org>
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

Add the missing DC *VA encodings.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ed2739897859..5084add86897 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -150,6 +150,11 @@
 #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
 #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
 
+/* Data cache zero operations */
+#define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
+#define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
+#define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
-- 
2.34.1

