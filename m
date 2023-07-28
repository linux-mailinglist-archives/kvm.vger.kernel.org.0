Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB676672E
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbjG1Ibj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbjG1IbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBA63C00
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A8662056
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5C8C433C7;
        Fri, 28 Jul 2023 08:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690533003;
        bh=NW9ugZQp6jdrc8K97jsONmyhCFN9uJpDBq39l2TMQpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWTY2zJnI0HY1LS42DtVW84NsTlkTNXZU3lhSdC3q3CG5+MFWuwqemjqbIecs/GAV
         EHcQ02QM33yaKnv1dO8lS+0uezS/Kl6r3Uza85/8h+iqBHXqIsZCQ9FAcgF3qapx9A
         j/6y050Huv/uhU7qRpbdcfZ+mzX+0SRQ8HS268DoepM77jT9vbrHMslyUnoJBAZ9zn
         wFOo+R+Htir0IZIKh4DUQNZBh8jTkaUREZFuVxEOC52cZOlz2VfLdt4+4ecSfydNks
         F+OFWeye8Jy3vYXUOQFvzej2s3xPvDpWvBK6pSH3V9djzNtqil4elMql9gWtDK9ogO
         v+Qu/uhFaI2Ew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrJ-0000EO-9S;
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
Subject: [PATCH v2 09/26] arm64: Add feature detection for fine grained traps
Date:   Fri, 28 Jul 2023 09:29:35 +0100
Message-Id: <20230728082952.959212-10-maz@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

In order to allow us to have shared code for managing fine grained traps
for KVM guests add it as a detected feature rather than relying on it
being a dependency of other features.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[maz: converted to ARM64_CPUID_FIELDS()]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@kernel.org
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f9d456fe132d..668e2872a086 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
 	},
+	{
+		.desc = "Fine Grained Traps",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index c80ed4f3cbce..c3f06fdef609 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -26,6 +26,7 @@ HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_EVT
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
 HAS_GENERIC_AUTH_ARCH_QARMA5
-- 
2.34.1

