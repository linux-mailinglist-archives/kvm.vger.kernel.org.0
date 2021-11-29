Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5654621AA
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhK2ULO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:11:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50374 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238888AbhK2UJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:09:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9629BCE1409
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C12C53FCF;
        Mon, 29 Nov 2021 20:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216352;
        bh=iTAjg+2Hz6NY3nku7Tg2LsgdREFDIXDRK8hNw6p9WrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jv2CpZdt/f6zWR+0mCulX33+j5p6SuWMGFU6zIPsrAwq2Oz0RoumGD+XxViNAFdga
         qU+/KcLchDn5KyTHDMteqm1c7HEESaEXl8eJXITVcFfp7e1mtRnMsWi8Fiux/FOJC1
         fPn0zq54Iy32zWOl68tT/PnBpJwCRyY+YghPdppuQ0PB/3gCPDoCxiWrBOb8GkejEz
         WClNbKS+xz+nuOzY148carnVY4Frvhu1vAgGP9PTYKVTigFX2yQ2ODxxV3bDlVJ/mw
         l+kfqEB551n4d7NbdRav7Tt3PNmohevyquJoYGFiDYupKrf/0RhcCoz40OKwMo528b
         Vd11y6ei3sGqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqv-008gvR-ML; Mon, 29 Nov 2021 20:02:17 +0000
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
Subject: [PATCH v5 26/69] KVM: arm64: nv: Handle PSCI call via smc from the guest
Date:   Mon, 29 Nov 2021 20:01:07 +0000
Message-Id: <20211129200150.351436-27-maz@kernel.org>
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

From: Jintack Lim <jintack.lim@linaro.org>

VMs used to execute hvc #0 for the psci call if EL3 is not implemented.
However, when we come to provide the virtual EL2 mode to the VM, the
host OS inside the VM calls kvm_call_hyp() which is also hvc #0. So,
it's hard to differentiate between them from the host hypervisor's point
of view.

So, let the VM execute smc instruction for the psci call. On ARMv8.3,
even if EL3 is not implemented, a smc instruction executed at non-secure
EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than being treated as
UNDEFINED. So, the host hypervisor can handle this psci call without any
confusion.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 95ae624d6aa8..72b981004b1d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -62,6 +62,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	int ret;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
@@ -69,10 +71,28 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 *
 	 * We need to advance the PC after the trap, as it would
 	 * otherwise return to the same address...
+	 *
+	 * If imm is non-zero, it's not defined, so just skip it.
+	 */
+	if (kvm_vcpu_hvc_get_imm(vcpu)) {
+		vcpu_set_reg(vcpu, 0, ~0UL);
+		kvm_incr_pc(vcpu);
+		return 1;
+	}
+
+	/*
+	 * If imm is zero, it's a psci call.
+	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
+	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
+	 * being treated as UNDEFINED.
 	 */
-	vcpu_set_reg(vcpu, 0, ~0UL);
+	ret = kvm_hvc_call_handler(vcpu);
+	if (ret < 0)
+		vcpu_set_reg(vcpu, 0, ~0UL);
+
 	kvm_incr_pc(vcpu);
-	return 1;
+
+	return ret;
 }
 
 /*
-- 
2.30.2

