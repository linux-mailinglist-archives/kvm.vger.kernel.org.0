Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F031BF51B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 12:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgD3KPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 06:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgD3KPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 06:15:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D262137B;
        Thu, 30 Apr 2020 10:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588241719;
        bh=BlvNdHFKkh0FnrdTCIIcpCw2RMDmby99vpfCd+vpBjc=;
        h=From:To:Cc:Subject:Date:From;
        b=dXaxMw20l9rua7LXw8qu3PrlkeDyQR6+Q0MXVuU6tPr5oZAivlfCBo9QLgKuiiHB8
         JebLGJqxr/Q0ZbUVj4xkr7/vCqB6BB9I301G1VOvI0qD5p9NFKciDiCphKYtIVp4XQ
         CZcrGS51uUsCB7rnEekSbqEPIAjWSkrV1HwMGQgQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jU6Dt-007zYv-8R; Thu, 30 Apr 2020 11:15:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
Date:   Thu, 30 Apr 2020 11:15:13 +0100
Message-Id: <20200430101513.318541-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the unlikely event that a 32bit vcpu traps into the hypervisor
on an instruction that is located right at the end of the 32bit
range, the emulation of that instruction is going to increment
PC past the 32bit range. This isn't great, as userspace can then
observe this value and get a bit confused.

Conversly, userspace can do things like (in the context of a 64bit
guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
that PC hasn't been truncated. More confusion.

Fix both by:
- truncating PC increments for 32bit guests
- sanitize PC every time a core reg is changed by userspace, and
  that PSTATE indicates a 32bit mode.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c     | 4 ++++
 virt/kvm/arm/hyp/aarch32.c | 8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 23ebe51410f0..2a159af82429 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	}
 
 	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+
+	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
+		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
+
 out:
 	return err;
 }
diff --git a/virt/kvm/arm/hyp/aarch32.c b/virt/kvm/arm/hyp/aarch32.c
index d31f267961e7..25c0e47d57cb 100644
--- a/virt/kvm/arm/hyp/aarch32.c
+++ b/virt/kvm/arm/hyp/aarch32.c
@@ -125,12 +125,16 @@ static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  */
 void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
+	u32 pc = *vcpu_pc(vcpu);
 	bool is_thumb;
 
 	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
 	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
+		pc += 2;
 	else
-		*vcpu_pc(vcpu) += 4;
+		pc += 4;
+
+	*vcpu_pc(vcpu) = pc;
+
 	kvm_adjust_itstate(vcpu);
 }
-- 
2.26.2

