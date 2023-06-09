Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D866372A085
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjFIQrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjFIQrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:47:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D8A3A8E
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54D0065A0E
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF813C433EF;
        Fri,  9 Jun 2023 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686329217;
        bh=tV1GC4lt1AhQsaOyflUGckOCSD9Gpyp+4HrIfwAcgZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jR8uIFj3L/nLd9+QfBAUKJ4tgTApV15VXmC592hXJM7FNPLrisQfwuWhxvnHdtbuQ
         dAcu919B4q0Zlik/KfXXxOy9VrjckP/33/ps1D58fqjEga7xf1vFKWDCBWuXwwZtsy
         OCrPWKMOKIsBY9QIBThEkvkiUwDjIZCrbSIS92D+0gC9p5JcbLrfUDyUD/5v5qAXcv
         QGuleGtTzJ7ytRP0VhogYFNQQJiWlUZWqvYLZF1tIg8X3BGEgg2Sswz3Wy4GlBFtVe
         6S5xDrdVAOzkxl/QNzAN7IhHaRM/L+Lo40xXllbL6OqgXA7Rvq7f83j1QQlqPLXY5O
         pjT6FUBoEoTDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esN-0048L7-TZ;
        Fri, 09 Jun 2023 17:22:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 16/17] arm64: Allow arm64_sw.hvhe on command line
Date:   Fri,  9 Jun 2023 17:21:59 +0100
Message-Id: <20230609162200.2024064-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
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

Add the arm64_sw.hvhe=1 option to force the use of the hVHE mode
in the hypervisor code only.

This enables the hVHE mode of operation when using KVM on VHE
hardware.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 8c93b6198bf5..c553d30089e5 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -138,11 +138,22 @@ static const struct ftr_set_desc smfr0 __initconst = {
 	},
 };
 
+static bool __init hvhe_filter(u64 val)
+{
+	u64 mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+
+	return (val == 1 &&
+		lower_32_bits(__boot_status) == BOOT_CPU_MODE_EL2 &&
+		cpuid_feature_extract_unsigned_field(mmfr1,
+						     ID_AA64MMFR1_EL1_VH_SHIFT));
+}
+
 static const struct ftr_set_desc sw_features __initconst = {
 	.name		= "arm64_sw",
 	.override	= &arm64_sw_feature_override,
 	.fields		= {
 		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
+		FIELD("hvhe", ARM64_SW_FEATURE_OVERRIDE_HVHE, hvhe_filter),
 		{}
 	},
 };
-- 
2.34.1

