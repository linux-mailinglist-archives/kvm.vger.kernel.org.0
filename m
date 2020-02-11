Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C91596CA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgBKRvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbgBKRvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:44 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EB020578;
        Tue, 11 Feb 2020 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443503;
        bh=0Meg/3iJbL3MBzT1+yZerX/G5rQIdjlezfw/2Tu1x/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDyF35cfeJLCZ1Exk84bNpVljETTKER1JLv+mpo8rnEe0BM1e2vTSn9itXPtIpwZN
         l7uwqcL1Otu37w3PjTpiIXwErNaRkKxuFPseraE3p+7JhWt5zGNR8U4JIuEYybhTDx
         ULHECoCu/uY1cM6HREUzmNHEFBQAGr/OIZJVS4KE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zg3-004O7k-Gv; Tue, 11 Feb 2020 17:50:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 58/94] arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
Date:   Tue, 11 Feb 2020 17:49:02 +0000
Message-Id: <20200211174938.27809-59-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On entering vEL2, we must honor the SCTLR_EL2.SPAN bit so that
PSTATE.PAN reflect the expected setting.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8380ed810062..97af080b9b52 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -131,9 +131,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 				enum exception_type type)
 {
+	u64 spsr = *vcpu_cpsr(vcpu);
+
 	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
 
-	vcpu_write_sys_reg(vcpu, *vcpu_cpsr(vcpu), SPSR_EL2);
+	vcpu_write_sys_reg(vcpu, spsr, SPSR_EL2);
 	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
 	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
 
@@ -141,6 +143,15 @@ static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 	/* On an exception, PSTATE.SP becomes 1 */
 	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
 	*vcpu_cpsr(vcpu) |= PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT;
+
+	/*
+	 * If SPAN is clear, set the PAN bit on exception entry
+	 * if SPAN is set, copy the PAN bit across
+	 */
+	if (!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_EL1_SPAN))
+		*vcpu_cpsr(vcpu) |= PSR_PAN_BIT;
+	else
+		*vcpu_cpsr(vcpu) |= (spsr & PSR_PAN_BIT);
 }
 
 /*
-- 
2.20.1

