Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309287038A8
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244353AbjEOReC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbjEORdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE57AAC
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E893762D3E
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C48C433EF;
        Mon, 15 May 2023 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171886;
        bh=UU4FnB4+acVfWZc7PHZIWb3pt0RhJdTVSo9/IRPo9Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5dE1uaMF0ALVXOro2zFUNWpMqyI5RejXc93Vob3/iYWegowkSx2dJoeqOdmeH9wr
         0pK3EEwxgvGN1O9C7mp6y+98XUtUGeEYECAUOIRQIvt2qUmjpxE9c4+upQni8MicMo
         lgkTTbmFM/8exi/yp3TOnp/JzYB10D/JwYrbOmeSpeSw7haRCImq5FKwym/vlWJYJX
         qkNtSRXVI6CFqj6bE3JrIj8mSY43qIN3/p5k5MDIiCfkv3wyI4fU6/bjKIgmK7B/nA
         w8PxXnRojebY2Qln+DjFpZ81dpUR5z4zvlCYLP9EKR0CJtT8K/YaO/uOo/vurvN5Oh
         9TsiWgn69Is5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2e-00FJAF-75;
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
Subject: [PATCH v10 04/59] arm64: Add missing ERXMISCx_EL1 encodings
Date:   Mon, 15 May 2023 18:30:08 +0100
Message-Id: <20230515173103.1017669-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

We only describe ERXMISC{0,1}_EL1. Add ERXMISC{2,3}_EL1 for a good measure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 071cc8545fbe..71305f7425db 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -239,6 +239,8 @@
 #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
 #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
 #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
+#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
+#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)
 #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
 #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
 
-- 
2.34.1

