Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E184E437
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfFUJkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:40:41 -0400
Received: from foss.arm.com ([217.140.110.172]:54416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFUJkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51752142F;
        Fri, 21 Jun 2019 02:40:40 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F176A3F246;
        Fri, 21 Jun 2019 02:40:38 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 56/59] arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
Date:   Fri, 21 Jun 2019 10:38:40 +0100
Message-Id: <20190621093843.220980-57-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On entering vEL2, we must honor the SCTLR_EL2.SPAN bit so that
PSTATE.PAN reflect the expected setting.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/emulate-nested.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c406fd688b9f..e37af2749b38 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -127,9 +127,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
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
 
@@ -137,6 +139,15 @@ static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
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

