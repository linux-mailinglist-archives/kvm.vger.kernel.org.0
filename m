Return-Path: <kvm+bounces-38292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE50A36EF5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91AC77A1B8C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8087D1F416B;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEhvtf+D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933D71EA7D5;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631724; cv=none; b=hQ6hz6xDStahLWMuvNyRYO4QNmRP4PxGUodwdTU+Nhjc6cgPKr00QTFfVthNgqeDrcTRSjDHE1COZmviIN2d6TItldUFBtS5wUJznQ8ORZ8ZsiEiSb0aiIHzPRnLJ8jrxekhn3xAI1pu5Riu+qbZP7RS6ORIB6oNtYEY6Vhu54A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631724; c=relaxed/simple;
	bh=NMYKJ0yMl3LarmDuWH+JZqyMOz1yxAJw5qnSKOyFiDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hzw6qSvJF670JDoLzaFuIANLQq6joD3iRgmVtVTn8BQgzsCYDJcuYv491dPdRJvLAhU67ISKMWS2TYUQvAc4iS6FC2ZK+5wyDJq9E61QKZ2v2Hnicn3Y1vQPg7tr4FUjp79CYSei3iy0jmbD6BO9eoSnOtqaM94LpnxB2Ls292w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEhvtf+D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74410C4CEF4;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631724;
	bh=NMYKJ0yMl3LarmDuWH+JZqyMOz1yxAJw5qnSKOyFiDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEhvtf+Dwp4sEMZQBs4Zxno6Cose3p/fhabVE2663xjUnHGsXJVdFU5/t4Nt2K4MU
	 NNHbEU+tqkpAE0MC7tjydH91/bryxA4JpnLNp6Y0PIV3Zv9KT1NaFxFw+SCTvaf6Fu
	 nXNg+NnEMiK9t+yleIkz3vnqHxo/OEjhD3l5VYyKuz/41jmxHwSRg8UBfqCQYtDV94
	 F95MEBfWUvV8oKnu6gz9461peOvLcj8CRL/gT/w/VzKnaCAeBhjkAAYceFzQxq6iwo
	 wFyUcmX4ufl9LSRCW+uLJRXnVcHmnH6lGtmB6jCVABcF3i49iA1mTqdjc2CGZfgxco
	 CRQ2RHa8feVmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJgA-004Nz6-Hw;
	Sat, 15 Feb 2025 15:02:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 12/14] KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
Date: Sat, 15 Feb 2025 15:01:32 +0000
Message-Id: <20250215150134.3765791-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we now have a way to map the guest's VNCR_EL2 on the host,
we can point the host's VNCR_EL2 to it and go full circle!

Note that we unconditionally assign the fixmap to VNCR_EL2,
irrespective of the guest's version being mapped or not. We want
to take a fault on first access, so the fixmap either contains
something guranteed to be either invalid or a guest mapping.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3453fb76cf0e3..6242ab037bfdf 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -48,6 +48,7 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 {
+	u64 guest_hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
 	u64 hcr = vcpu->arch.hcr_el2;
 
 	if (!vcpu_has_nv(vcpu))
@@ -70,9 +71,23 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
 	} else {
 		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);
+
+		if (guest_hcr & HCR_NV) {
+			u64 va = __fix_to_virt(vncr_fixmap(smp_processor_id()));
+
+			/* Inherit the low bits from the actual register */
+			va |= __vcpu_sys_reg(vcpu, VNCR_EL2) & GENMASK(PAGE_SHIFT - 1, 0);
+			write_sysreg_s(va, SYS_VNCR_EL2);
+
+			/* Force NV2 in case the guest is forgetful... */
+			guest_hcr |= HCR_NV2;
+		}
 	}
 
-	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
+	BUG_ON(host_data_test_flag(VCPU_IN_HYP_CONTEXT) &&
+	       host_data_test_flag(L1_VNCR_MAPPED));
+
+	return hcr | (guest_hcr & ~NV_HCR_GUEST_EXCLUDE);
 }
 
 static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
-- 
2.39.2


