Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5227038A9
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbjEOReD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244325AbjEORdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A4814370
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 336E962D4A
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954F7C433A0;
        Mon, 15 May 2023 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171886;
        bh=R8+Mi/2jgzSmDHYmSudh6OXuZipUlO+XqjSbA8Jh6/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMvhOnTSojI3PdMezu3s17MZfOjtuL30wEL7Mdj1MQk6GsIGYMBaRsVjMuqVpzGZR
         qTPLEUpD8M8fGvMfiUIX3r93Tu6Qd8gh9LAP+wV7XaTuv7BOtdCFB9sWaIzrJHI2cf
         SnwHOIWGkfmc1bQn+m9sTWnVwDdJbKoHhkYiGs2FzCGL14TgXZTn8C6mJgIxTLVaEY
         EI4cYMKEJfUkiEnU9jKDpVRN7nxuAL9CFIHm+hj0/fPjkmEhp70MXR+kAPbXT5N+08
         uoIV4b0dAemZaJqN+i5gcfkGUaVtOL36Swp845c3++8V7051sr4zYwOWWqQLsOrsOJ
         OO9I5OaFH/JRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2e-00FJAF-EL;
        Mon, 15 May 2023 18:31:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 05/59] arm64: Add missing DC ZVA/GVA/GZVA encodings
Date:   Mon, 15 May 2023 18:30:09 +0100
Message-Id: <20230515173103.1017669-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Add the missing DC *VA encodings.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 71305f7425db..28ccc379a172 100644
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

