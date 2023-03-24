Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2A6C8032
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjCXOrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjCXOrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA11D1E283
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6277562B4A
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C74C4339E;
        Fri, 24 Mar 2023 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669239;
        bh=VzmiC9FX+ZfNMXCHEN+Bh2kvmeKVWDoUDgNLI+FCBiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmzatZepj6CuLUwaLuIbpHOcDqR9PcbY8yD9IQHxIBGNqAgtXqfL2TwxGdblu2wu8
         HvQGI1NWmJsgUSV9SIa65pmVW82XBClnfGyYEhrGv1bbdryvA4X43BCExt+E4BbE5e
         tJGGsgvtXQTpdIc9PVe8xdRk1aHbqcXtvzbPjMwJoiAiNiPNz1+hSHP8KvFSx/Tfjv
         gIxW7mcPn7SyXaxVBOLAkFPe3KDgjC0/DVmgsOgw9g6vZnd3mQz9/0FC2gWRK861Y7
         kjOosundyGBH/J4TLgqmCwkl1ZE5R1G6buGEodH50hBaaK8qE0HmUBso5PaOKTct1X
         b5UDRjoCjjSoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihJ-002qBP-MW;
        Fri, 24 Mar 2023 14:47:17 +0000
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
Subject: [PATCH v3 03/18] arm64: Add HAS_ECV_CNTPOFF capability
Date:   Fri, 24 Mar 2023 14:46:49 +0000
Message-Id: <20230324144704.4193635-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the probing code for the FEAT_ECV variant that implements CNTPOFF_EL2.
Why it is optional is a mystery, but let's try and detect it.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2e3e55139777..c331c49a7d19 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2223,6 +2223,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (CNTPOFF)",
+		.capability = ARM64_HAS_ECV_CNTPOFF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.field_pos = ID_AA64MMFR0_EL1_ECV_SHIFT,
+		.field_width = 4,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = ID_AA64MMFR0_EL1_ECV_CNTPOFF,
+	},
 #ifdef CONFIG_ARM64_PAN
 	{
 		.desc = "Privileged Access Never",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 37b1340e9646..40ba95472594 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -23,6 +23,7 @@ HAS_DCPOP
 HAS_DIT
 HAS_E0PD
 HAS_ECV
+HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
-- 
2.34.1

