Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8A49FA01
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348723AbiA1Muu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:50:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52776 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348714AbiA1Mut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:50:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2663561C50
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2FFC340E6;
        Fri, 28 Jan 2022 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374248;
        bh=YXTrt+jPSm3H5jzqHNqD4s3HXxglcr2tbEknzYDr2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsAl7GT9DvJrCqa+RSkOs6V94TVIZ6tDLXOPXEjPYU8Ei8Y5a3x+Jqt1rwA8Gw7hX
         gMqGuHxrawYlb8B5CFv0gQGsc+NuUzctQNQ+WUS8CEPkn9TrRF9HB6Mrs/wkNoIKCP
         AKcbRPciVTAlo+nZkuDvOURZQYs9J5nljVioSjN5HJ0i144hE+qJIqbxSBxjr+2aRR
         h5vMF7WNXSc7sp3uQwe9XtWSO2QjOP+qXiYvdyPO1sGpG5LAQZJ+xxMlAYIsR4S0RN
         /HS/zZlXReBQPVF92Jt46DuMvEWR6q7IajuXscHMjHRqc3uSdhLcm748yj6xEN/ByJ
         /OL+qUz4UvOMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQEN-003njR-Ja; Fri, 28 Jan 2022 12:19:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 42/64] KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
Date:   Fri, 28 Jan 2022 12:18:50 +0000
Message-Id: <20220128121912.509006-43-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
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
index 0e164cc8e913..5e8eafac27c6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -78,6 +78,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			if (!vcpu_el2_tge_is_set(vcpu))
 				hcr |= HCR_AT | HCR_TTLB;
 		}
+	} else if (vcpu_has_nv(vcpu)) {
+		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+		vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
+		hcr |= vhcr_el2;
 	}
 
 	___activate_traps(vcpu, hcr);
-- 
2.30.2

