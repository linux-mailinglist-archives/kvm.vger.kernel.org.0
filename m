Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEBC605AF0
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJTJQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJTJQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:16:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28671BE90B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA2BB82691
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2802C433C1;
        Thu, 20 Oct 2022 09:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666257406;
        bh=3tbOfP787ivANekjOpi0D+lzmeYXSesKC2n+sLbSetQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmp9gTo1hdSKd8xa/Cb4CnZj4NfRTUvH93BSsSvZM+UeGmtVcuCX7T2lRtTTWwMMX
         O9OuS9WUHXGOv7LgGvPwf9F59FHLbsCGWM++xfNo00bS/JkWxp/jdpItRAt6TaTq06
         JNb0vvi6whYfO0vHJ20B8CAiwuZFy9t+3gf8OuCmlo4MqyuV8+8xwGT9tjvifIVmBp
         bRfyZeLObwa69MxkxXYb3MOBXBBjvq4M/u6+J7RtNQNSzP67KOV1ACD+Dxa/7my430
         aA8dlX6id4K0aeTON7QOQlhdQ3DmL8gHxbWcuSgbcyEvQBOX8VPpb42yhtORk1LJXt
         Pq/xvllZwECkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWb-000Buf-3W;
        Thu, 20 Oct 2022 10:07:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date:   Thu, 20 Oct 2022 10:07:20 +0100
Message-Id: <20221020090727.3669908-11-maz@kernel.org>
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

Obviously, in order to be able to use VHE whilst at EL2, we need
to set HCR_EL2.E2H. Do so when ARM64_KVM_HVHE is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..85df7ce0b051 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1558,6 +1558,8 @@ static void cpu_prepare_hyp_mode(int cpu)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE))
+		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
 
 	/*
-- 
2.34.1

