Return-Path: <kvm+bounces-2083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D3E7F1400
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FE9C282210
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA171CFA0;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECLYfnYg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDA21C281;
	Mon, 20 Nov 2023 13:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E246FC433BA;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485853;
	bh=3s1ljDq33uH1qd1QwpvWXGoDd4Zc+Wqjt1c9Tusu5WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECLYfnYgFyKgZd0urReIZOBwa/mbEs7OHV/r8sWlKf8u+OxJwy27HwVhZ6xXQYZha
	 tDNOgWrHvioGOv1wwTv87nJzcocVaRXisuAWCRPth+MK7EeTsjqdPLLDB/H+eomlkV
	 iWsOvNzO3nBmL89Db3iRK4mGolY5o/Z5FZneZpxB/Q0HzoEiQhwiWxWGaVt+ect7DG
	 OAxLTqBAEtkP1oGaVR9gZ5SZ7dznvvK33ucr6XuRw0ywwyZJhI8cs21YwDi4zFM65E
	 fJ5UmEa1b+zW4TGtBXDJzr+tpMl1MbfiAhpggJEvWCBQbBIr8TMduXN/dZsQfTjLda
	 +eR+HhwodnYTg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543A-00EjnU-4B;
	Mon, 20 Nov 2023 13:10:52 +0000
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
Subject: [PATCH v11 12/43] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Date: Mon, 20 Nov 2023 13:09:56 +0000
Message-Id: <20231120131027.854038-13-maz@kernel.org>
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

Accessing CNTHCTL_EL2 is fraught with danger if running with
HCR_EL2.E2H=1: half of the bits are held in CNTKCTL_EL1, and
thus can be changed behind our back, while the rest lives
in the CNTHCTL_EL2 shadow copy that is memory-based.

Yes, this is a lot of fun!

Make sure that we merge the two on read access, while we can
write to CNTKCTL_EL1 in a more straightforward manner.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c    | 28 ++++++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d5c0f29c121f..f42f3ed3724c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -138,6 +138,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 		if (!is_hyp_ctxt(vcpu))
 			goto memory_read;
 
+		/*
+		 * CNTHCTL_EL2 requires some special treatment to
+		 * account for the bits that can be set via CNTKCTL_EL1.
+		 */
+		switch (reg) {
+		case CNTHCTL_EL2:
+			if (vcpu_el2_e2h_is_set(vcpu)) {
+				val = read_sysreg_el1(SYS_CNTKCTL);
+				val &= CNTKCTL_VALID_BITS;
+				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
+				return val;
+			}
+			break;
+		}
+
 		/*
 		 * If this register does not have an EL1 counterpart,
 		 * then read the stored EL2 version.
@@ -209,6 +224,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 			preempt_enable();
 		}
 
+		switch (reg) {
+		case CNTHCTL_EL2:
+			/*
+			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
+			 * Otherwise, some of the bits are backed by
+			 * CNTKCTL_EL1, while the rest is kept in memory.
+			 * Yes, this is fun stuff.
+			 */
+			if (vcpu_el2_e2h_is_set(vcpu))
+				write_sysreg_el1(val, SYS_CNTKCTL);
+			return;
+		}
+
 		/* No EL1 counterpart? We're done here.? */
 		if (reg == el1r)
 			return;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c819c5d16613..fd650a8789b9 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -147,6 +147,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt);
 void kvm_timer_cpu_up(void);
 void kvm_timer_cpu_down(void);
 
+/* CNTKCTL_EL1 valid bits as of DDI0487J.a */
+#define CNTKCTL_VALID_BITS	(BIT(17) | GENMASK_ULL(9, 0))
+
 static inline bool has_cntpoff(void)
 {
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
-- 
2.39.2


