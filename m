Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD494605AE3
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJTJQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJTJQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:16:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBDC1AAE7B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C47B826AB
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E24C433C1;
        Thu, 20 Oct 2022 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666257391;
        bh=2eNqWN4PbAgzkaOx6mNpZevPq0uMwSWGGxKeEeSAMyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3dS9ql0M8AGPz8g57P+rjNfF/9WYQmyolI4TQYa+m6GGzENYzt6eAoprJqWEjumX
         T9i/iwyoegWahWQwezcNs/wNgutLxy+U1JZhoElpzqVPT1dUS03dQTVkpLvl/zPHSL
         06m6zDRJhXTmWP1aR3+XDLPM3PP5cjKv4BGDr++Pl5xjADtzQHdYiXVcg9nMQs0bAv
         TY5DnzkHVoDhpse6crIaWsjxJatc2Tmz0gkhiLO+NELUtkMmqLN/uS8txuOTJqYXde
         UWO8wTNNkwRK6CyRu0LpGReyKLK0J6ncys8pZB8Fx+UJCZV5otroQLMdg9gSXUrGMJ
         1O9ad/acRILog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWc-000Buf-Ku;
        Thu, 20 Oct 2022 10:07:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 16/17] arm64: Allow arm64_sw.hvhe on command line
Date:   Thu, 20 Oct 2022 10:07:26 +0100
Message-Id: <20221020090727.3669908-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 4e8ef5e05db7..7f3d7835ceaa 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -137,11 +137,22 @@ static const struct ftr_set_desc smfr0 __initconst = {
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

