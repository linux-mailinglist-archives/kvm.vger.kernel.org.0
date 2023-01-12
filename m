Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E86667F0C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjALT1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjALT01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EE85F99
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:19:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C35C86216A
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C6AC43392;
        Thu, 12 Jan 2023 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551180;
        bh=a4UTVb8UOXSxNKd8O8XlH8cthygH6vXj5ampEKLLkJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pj4/vgrFyzD7WKKkIyp4XuR51ehrbkXwgYF2ywiLNSVrdqdHnneEgOKYkFn0gEPOd
         OcQie9M29p39XPuB4xMmtLWyBB3b+1J6nkhs1/qcRMtCuORYJwqArUo/pdAt+BZCKY
         XNzKGnkngf8j17LiLVpNFQdRwIrKbPMRE4K1/xm045Jr/fVJjr0MEkCXK0NT76WbAG
         ftvHsLAi2FNfEunPSBd8Qc7odojhJKhzhZIztGIZ/7mzNg+YjPEr6h9xgU6SPdzThq
         efFCxzG1+Tb9/8gjnMf5DpXt5K4C3q2xZhdyM+Cm3qX16EkQAlWc9GltAGr6kCK7VO
         lb3khdMLl6JLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG36w-001IWu-2E;
        Thu, 12 Jan 2023 19:19:38 +0000
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
Subject: [PATCH v7 04/68] KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
Date:   Thu, 12 Jan 2023 19:18:23 +0000
Message-Id: <20230112191927.1814989-5-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

We were not allowing userspace to set a more privileged mode for the VCPU
than EL1, but we should allow this when nested virtualization is enabled
for the VCPU.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5626ddb540ce..63643c98e6c3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -24,6 +24,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
@@ -253,6 +254,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;
+		case PSR_MODE_EL2h:
+		case PSR_MODE_EL2t:
+			if (!vcpu_has_nv(vcpu))
+				return -EINVAL;
+			fallthrough;
 		case PSR_MODE_EL0t:
 		case PSR_MODE_EL1t:
 		case PSR_MODE_EL1h:
-- 
2.34.1

