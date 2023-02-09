Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D925691007
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 19:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBISLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 13:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBISLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 13:11:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB468ACF
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 10:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 648D1B82274
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 18:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19077C433D2;
        Thu,  9 Feb 2023 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675966251;
        bh=ycJQTa90vNc+zMPsmHdkSUMnSh/e/B8/iWuzQP1sK/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olK/T/x8piJxWVB/RdLQlesw68G3DMsLyeWdavMzB1xp1eejOVqh+Sblx0PKtnlZD
         jmgf+0H1Z/4pc7XMFrlYwEWnioO8wAGacnKFxqD04W7dmx9CT5znlLnHpVJwuHmAiS
         RC35OvTkK2Jyq6HbdyTDXjwtMS+3LSnRATbpkleekJBJlHHauLnD2N20JvGAlkm0XM
         DXpymplMTUXYVn7ovgIOUHMs+5fp03PWyymloDE9qWXTcRX3/yHB12Evte9M7vF8XQ
         BVtpoYb4bmdhjje0YSQUCvqAv5DjyZitaDmUIuiDJh/DlD5/Ykn8SZl45srpimHOBQ
         7EH1aP/aJgUjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pQBC4-0093r7-8S;
        Thu, 09 Feb 2023 17:58:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 10/18] KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
Date:   Thu,  9 Feb 2023 17:58:12 +0000
Message-Id: <20230209175820.1939006-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

As we expect all PSCI calls from the L1 hypervisor to be performed
using SMC when nested virtualization is enabled, it is clear that
all HVC instruction from the VM (including from the virtual EL2)
are supposed to handled in the virtual EL2.

Forward these to EL2 as required.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: add handling of HCR_EL2.HCD]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e778eefcf214..2d8c09cf3e49 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -16,6 +16,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/debug-monitors.h>
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
@@ -41,6 +42,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
+	if (vcpu_has_nv(vcpu)) {
+		if (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_HCD)
+			kvm_inject_undefined(vcpu);
+		else
+			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+		return 1;
+	}
+
 	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
-- 
2.34.1

