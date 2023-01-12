Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D423F667F1B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbjALT1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbjALT1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:27:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD0B164B1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:21:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A69C3B82017
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C844C433D2;
        Thu, 12 Jan 2023 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551268;
        bh=aPuvJevfob0bbgbl1+3vnPH6lP+dsIOwT1X09yp3vX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Typ8UadynE+FpDV4KdUu/i6n9Yc2+LExLg6yTuzyIDFJ+ro/AuIALt3suyHxYMliZ
         P0aT6BvsiXZVqB84M8zRdaFZLSVdt9pSJfTasqpdLVdDgXkNR0uZioLgIeE2ss2Jts
         lmUFkRHWeKeQjaxvQz+vhPOtLuphDt6RuWrGCwZltgo4TVE3tth47vIsnRHsKMewx1
         tSr0SIjPPSzE644ToS8I1UbTYh08WjtudqkmcXGF1TxULlKL4b1+yS4TYjGBkai7tm
         jy/lzet/THRWVVR3dlmrpVcwFui1idNbgZstLjjUgTt0gNGJ5ujWQPWwFkYO3AcS+V
         UOcS9XD+NvgQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG373-001IWu-LL;
        Thu, 12 Jan 2023 19:19:45 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 25/68] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
Date:   Thu, 12 Jan 2023 19:18:44 +0000
Message-Id: <20230112191927.1814989-26-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Forward the EL1 virtual memory register traps to the virtual EL2 if they
are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
bit is set.

This is for recursive nested virtualization.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 934341a1df2e..988bd907f4f2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -347,6 +347,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p)) {
+		u64 bit = p->is_write ? HCR_TVM : HCR_TRVM;
+
+		if (forward_traps(vcpu, bit))
+			return false;
+	}
+
 	/* We don't expect TRVM on the host */
 	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
 
-- 
2.34.1

