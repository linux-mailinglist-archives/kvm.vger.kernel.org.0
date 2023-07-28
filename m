Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC66D7667A0
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbjG1IrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjG1IrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4933AAE
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4761C6206A
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E79C433C7;
        Fri, 28 Jul 2023 08:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690534022;
        bh=KxYYCtwMZkOE4N0UX03BRxRfRysYCULm6mCdQ/HBCjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+978mGu7wAar2duAtfuMvsV0LdDx7Ut0Y4Fu5Y75gY+GkolwRhKDBt9mMq9Gt5ny
         iAdd4S4aJmeAJVsTkEpehljmUfZLaoPYj2+/YeCaUeV7ZQC97p4swNqjm4BnIxOdhr
         IWEpFTYy/+1MD4IP84LKAWdnN2+TFXV9YavmsvJK9+WQ4VTTgdaexFH2RtTmxqzJx/
         +/jOSJuY4zyqcXrSBrLAK1dXkDSzQsCANfIdJYcgGSXQqHdVodRYXzhE96jeZIgYQS
         4SUBbPbMyJF55GFBlAeOfiCJIluzi8vb54xrUkUr7OSZI1soF6krZUO1mYL+NGofTC
         jL9g9AAe46q2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrJ-0000EO-Ss;
        Fri, 28 Jul 2023 09:30:01 +0100
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
Subject: [PATCH v2 11/26] KVM: arm64: Add missing HCR_EL2 trap bits
Date:   Fri, 28 Jul 2023 09:29:37 +0100
Message-Id: <20230728082952.959212-12-maz@kernel.org>
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

We're still missing a handfull of HCR_EL2 trap bits. Add them.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 58e5eb27da68..028049b147df 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -18,10 +18,19 @@
 #define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA_SHIFT	56
 #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
+#define HCR_TTLBOS	(UL(1) << 55)
+#define HCR_TTLBIS	(UL(1) << 54)
+#define HCR_ENSCXT	(UL(1) << 53)
+#define HCR_TOCU	(UL(1) << 52)
 #define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_TICAB	(UL(1) << 50)
 #define HCR_TID4	(UL(1) << 49)
 #define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV2		(UL(1) << 45)
+#define HCR_AT		(UL(1) << 44)
+#define HCR_NV1		(UL(1) << 43)
+#define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
-- 
2.34.1

