Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B201058AC03
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbiHEN7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiHEN6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB26580E
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6790260DBA
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C832EC433B5;
        Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659707902;
        bh=WRtaYt1uNNVydnCSn92Qr10PYS+YrZ1SpC9w5AHVK8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHczkr9Xg7gk6/Jp2Z3Du7XTQ3lWoevqE6mNlIxB8xtZymFqae6e/dME0AzktJxll
         8D7zehkHx2vHwhIxYN+h0vyjgyfpH9FvFTmFWkkYl9HPlCyRV/HKxDpTtjN+Io0tc0
         Wg/tFxW0Rd5mOrGCA2tbv2+sDaxGgSqbJ2yCXmAJiggBgSA/gAPfL0rubkvy9b67Aw
         0iTXnxbWQtssW4ZyRm9zGNaBD6odQ2om502fX+s1HvruhIkhojhuX9tNfXszwrFE2J
         E3THTp8XIW33nZ79mjhZ2uTTfAOo8ntMJGqx4+A8ALxkaxpQYxrdP+I3GKCZA7DxHP
         IbhVO5bUvpb1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oJxqH-001AeL-4E;
        Fri, 05 Aug 2022 14:58:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: [PATCH 9/9] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest
Date:   Fri,  5 Aug 2022 14:58:13 +0100
Message-Id: <20220805135813.2102034-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the infrastructure is in place, bummp the PMU support up
to PMUv3p5.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b33a2953cbf6..fbbe6a7e3837 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1031,6 +1031,6 @@ u8 kvm_arm_pmu_get_host_pmuver(void)
 	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	tmp = cpuid_feature_cap_perfmon_field(tmp,
 					      ID_AA64DFR0_PMUVER_SHIFT,
-					      ID_AA64DFR0_PMUVER_8_4);
+					      ID_AA64DFR0_PMUVER_8_5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
 }
-- 
2.34.1

