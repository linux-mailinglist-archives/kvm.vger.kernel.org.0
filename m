Return-Path: <kvm+bounces-2082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 652417F13FF
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96F9F1C21792
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F081C6B5;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGVMU/B3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14941BDD5;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A44C433B7;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485853;
	bh=hWt078evTbLyUNlhN2en4CwHS1/cNEuwQ9rrpk3KOzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGVMU/B3TL8NrxW5zgkbNlj1OEnw65Km7UIPf+2G0iHJcUV/1SFOzSdM4V0k1RsuS
	 iE66tqUVIuBi26qoUdCnTZND1fz/H3jGeRl99pHvLygfRf5mc1Octn92lXFkILLHql
	 D/4xyIeEBpumn2+q0i472GJ8cg28w7VVU/+mQPKnCdIAtXbrgiSMvbPCGlfQ4noCbp
	 LKCe4IbIfv8t7EkApTSMp7lDmmjQ1o9oHIEegiki02T3EbCOrlAU0P7puluF32KDCO
	 NznsbTCwO8K5Ey+P/qrHU9eJOKPrCZSARlfAFYTpq6lYRrZdFXh43ajkau+gG2Fs/8
	 fqKjjs3G0buQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5439-00EjnU-Rd;
	Mon, 20 Nov 2023 13:10:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: [PATCH v11 11/43] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Date: Mon, 20 Nov 2023 13:09:55 +0000
Message-Id: <20231120131027.854038-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
we deal with a lot of the state. So when the guest flips this bit
(sysregs are live), do the put/load dance so that we have a consistent
state.

Yes, this is slow. Don't do it.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 92bb91e520a8..d5c0f29c121f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -178,9 +178,25 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
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
+		need_put_load = (!cpus_have_final_cap(ARM64_HCR_NV1_RES0) &&
+				 (reg == HCR_EL2) &&
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
@@ -188,6 +204,11 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		if (need_put_load) {
+			kvm_arch_vcpu_load(vcpu, smp_processor_id());
+			preempt_enable();
+		}
+
 		/* No EL1 counterpart? We're done here.? */
 		if (reg == el1r)
 			return;
-- 
2.39.2


