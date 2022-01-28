Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A9F49F932
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348436AbiA1MUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348437AbiA1MUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61785B82569
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE26C340E0;
        Fri, 28 Jan 2022 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372404;
        bh=F0WDPTujzh01Sq2s/H4RolAuXeFIrVC3Zcaf5EdNwW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYKUh28AyglCuRrCGavmXM+QKo+pT+WTNFagUtlGrCNLh2Pidy8bYlXyjPc21H8tY
         vIdQO84Py1i+BYViLCGDvPHhWLIJUeeJycFa/CQfsS69Dl5mdajvR+7RJBhvS2OIFB
         o8oib1bsQQfVOsIbdzeNwNFqNcvK/y2HTVWnkH833lvLQU2T9LcaMzQYOVp9W1rgeU
         XVpz6Fa18LwEWogvnIDZMlNP5PrB/rmElloQ7qeJnnXqYnKU8FiN4CfrVTxR/iHFCt
         iHP0RHiK6Sd1EzU0egisOiSgnrQnmLs8E/K/vAV/fFAC9bcmHAd9SDD9ZXUUUi+fkk
         sOHdATHs1AHfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDx-003njR-Iu; Fri, 28 Jan 2022 12:19:29 +0000
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
Subject: [PATCH v6 15/64] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Date:   Fri, 28 Jan 2022 12:18:23 +0000
Message-Id: <20220128121912.509006-16-maz@kernel.org>
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

HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
we deal with a lot of the state. So when the guest flips this bit
(sysregs are live), do the put/load dance so that we have a consistent
state.

Yes, this is slow. Don't do it.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ace4a54caef9..102bc4906723 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -183,9 +183,24 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		goto memory_write;
 
 	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
+		bool need_put_load;
+
 		if (!is_hyp_ctxt(vcpu))
 			goto memory_write;
 
+		/*
+		 * HCR_EL2.E2H is nasty: it changes the way we interpret a
+		 * lot of the EL2 state, so treat is as a full state
+		 * transition.
+		 */
+		need_put_load = ((reg == HCR_EL2) &&
+				 vcpu_el2_e2h_is_set(vcpu) != !!(val & HCR_E2H));
+
+		if (need_put_load) {
+			preempt_disable();
+			kvm_arch_vcpu_put(vcpu);
+		}
+
 		/*
 		 * Always store a copy of the write to memory to avoid having
 		 * to reverse-translate virtual EL2 system registers for a
@@ -193,6 +208,11 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		if (need_put_load) {
+			kvm_arch_vcpu_load(vcpu, smp_processor_id());
+			preempt_enable();
+		}
+
 		switch (reg) {
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
-- 
2.30.2

