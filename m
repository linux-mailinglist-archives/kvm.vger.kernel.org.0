Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7036703A25
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244639AbjEORtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbjEORtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF76D14E52
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC3F62F0E
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77203C433D2;
        Mon, 15 May 2023 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172818;
        bh=HzXSsUwByW2jAR2hO6nb9l7RS/h2EPWpRifFw83LriQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtbYv0YCiu90BRfaTqc0HWRAsF7HP5omooE1sYKhjY/XJAuteor9FUcliAJI4S7OA
         wL561TyhMVo5QTZ9MoMSxQ6LKUM0wc+lxWJrc9y8oa18cACP0J1bXVhcfr3XWnSPFb
         rWoyLa94bMy0wwq7hG7CQ61j499QGPAUbTylcSIZAHA4fRAXoHaqpyafpW9rObN1oc
         5SJgaLrRIf7uHnRzbiv+AFlAD0E65Ugqy7+w/KDNMRez8t+X8ObCLYKmSGV+kWXbRl
         AdKuj1XGTsdI/js1RMjYZVVFBzncE+kksPLVjOzLQuwFthaiZBZIhL+eIgt2lmXeW2
         sCo1KrI/NuV2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc32-00FJAF-5f;
        Mon, 15 May 2023 18:31:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 42/59] KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt delivery
Date:   Mon, 15 May 2023 18:30:46 +0100
Message-Id: <20230515173103.1017669-43-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Normal, non-nesting KVM deals with maintenance interrupt in a very
simple way: we don't even try to handle it and just turn it off
as soon as we exit, long before the kernel can handle it.

However, with NV, we rely on the actual handling of the interrupt
to leave it active and pass it down to the L1 guest hypervisor
(we effectively treat it as an assigned interrupt, just like the
timer).

This doesn't work with something like the Apple M2, which doesn't
have an active state that allows the interrupt to be masked.

Instead, just disable the vgic after having taken the interrupt and
injected a virtual interrupt. This is enough for the guest to make
forward progress, but will limit its ability to handle further
interrupts until it next exits (IAR will always report "spurious").

Oh well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 755e4819603a..919275b94625 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -225,4 +225,7 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 				    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
 	}
+
+	if (unlikely(kvm_vgic_global_state.no_hw_deactivation))
+		sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EN, 0);
 }
-- 
2.34.1

