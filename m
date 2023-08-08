Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65F5774599
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 20:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjHHSnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 14:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjHHSn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 14:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052CC387CE
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 110EE62503
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EAFC433C8;
        Tue,  8 Aug 2023 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495287;
        bh=6d4Kspg7nIaOGmD/4cchuF/PX4zqa/gLnUY8Tbj4CBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9gzvEy5h0wHMZ8SZpNRT1eyRILkMft/UQN8MGsDoxBBNYLTkCc4RUiZc64Tjr3ws
         u8CEy9NFl5EhjiaTAWriCYWjIrbuxlo8Lh0cIX08VWhGH7HsorYx2+zGv5CdE2N58e
         dqpSoDTQ394CpIl+kTHty5kcXYzXsuLtPLSLh9q/4G2lDktyRsmCqXd+ZVfxEWs748
         sLnoKDSxME0d0FKZvXHaifriEyR9wNUNykkTCha+HfDDmmjimeN1P1cxDVlU7/fLYe
         eL/v89cTsIEYKm8s9jLVqhUg1IcDA10ImbAkaZoxSqqbNcP1Jb+GNYNmtuyMEiLSKy
         1MbosYmPmXukA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBI-0037Ph-7e;
        Tue, 08 Aug 2023 12:47:20 +0100
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
Subject: [PATCH v3 16/27] KVM: arm64: nv: Expose FEAT_EVT to nested guests
Date:   Tue,  8 Aug 2023 12:47:00 +0100
Message-Id: <20230808114711.2013842-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we properly implement FEAT_EVT (as we correctly forward
traps), expose it to guests.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 315354d27978..7f80f385d9e8 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~(NV_FTR(MMFR2, EVT)	|
-			 NV_FTR(MMFR2, BBM)	|
+		val &= ~(NV_FTR(MMFR2, BBM)	|
 			 NV_FTR(MMFR2, TTL)	|
 			 GENMASK_ULL(47, 44)	|
 			 NV_FTR(MMFR2, ST)	|
-- 
2.34.1

