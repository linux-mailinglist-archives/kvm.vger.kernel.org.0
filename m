Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49128462393
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhK2Vro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhK2Vpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:45:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5945C08EB30
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1F84CE13DE
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC68C53FC7;
        Mon, 29 Nov 2021 20:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216347;
        bh=THxfTratzuqnEYOjcyY3aQOXMptJwOp65u+vqN5et1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9s2zOs6sQmgspPbLkSCbYEv4Bw+wREmA1o4IPHSDOSEbi318fK9wOhWBMsdCkMjz
         sWHM4mKPgn0kGGf9/aRL+ONrMvLL6rEshGFxNuarekB2oEg46XBNXomJrWDTH+tOzs
         p/TjjuMUKw2IQTJ/4gj3AU2yOw0Q3IWfl8Mtveg9IaJ2DBdGMluVfFTsh8D4oALUYv
         To9W1c4S9JFfelUokt+0AJdKdeckP0PdduG5FnA7X8OXKuhZWYnEQRK7tmhpPjs66c
         klfkbPDbebpMq0SoyfpSUY11bxzzRRKZe4589jRNolIXurrxwkuOwqGPRrg+4CYA53
         ZkJJsTXZEDTuQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmr4-008gvR-BT; Mon, 29 Nov 2021 20:02:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 47/69] KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
Date:   Mon, 29 Nov 2021 20:01:28 +0000
Message-Id: <20211129200150.351436-48-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When entering a L2 guest (nested virt enabled, but not in hypervisor
context), we need to honor the traps the L1 guest has asked enabled.

For now, just OR the guest's HCR_EL2 into the host's. We may have to do
some filtering in the future though.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 71a4914761d0..ef4488db6dc1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -79,6 +79,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			if (!vcpu_el2_tge_is_set(vcpu))
 				hcr |= HCR_AT | HCR_TTLB;
 		}
+	} else if (nested_virt_in_use(vcpu)) {
+		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+		vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
+		hcr |= vhcr_el2;
 	}
 
 	___activate_traps(vcpu, hcr);
-- 
2.30.2

