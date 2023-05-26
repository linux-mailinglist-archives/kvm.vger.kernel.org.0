Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29DE7128E4
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbjEZOra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbjEZOr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5B51BF
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9380A61598
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E29C433EF;
        Fri, 26 May 2023 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685112414;
        bh=tV1GC4lt1AhQsaOyflUGckOCSD9Gpyp+4HrIfwAcgZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrKnuSQoOoA2fFttxHevJkJO8t3u9PyQb5LuKKJLcdS24P5RyD4dfr7AmncftDV34
         fxm7nNRhJm/j2kKm52PjB7agYffPQrcict2w0coOpBj4jVL65ylbo3EKhP6UL2N3Rf
         oT1/4oGyx2H5xBEBJ+ETMtHV0fAxdQfGK1G8GkkxGysmBQ6InUOMU0QQK6eN7jIyje
         Rkqxlqq1Fj01F7mzHcrwDenJ0kuQDwDE5t2bqfMnk9rxqfy16UpBNgVrn5Ri0vehJs
         7RgwsZdIIHXo5SOX42QQEgQP60kUhx+/oYTVUFxb758FYBdDe6o6VUx8olCChCPAaO
         S4AkCZHV7ak2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVv-000aHS-DR;
        Fri, 26 May 2023 15:33:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 16/17] arm64: Allow arm64_sw.hvhe on command line
Date:   Fri, 26 May 2023 15:33:47 +0100
Message-Id: <20230526143348.4072074-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
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

