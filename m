Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8798F496BB7
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 11:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiAVKjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 05:39:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40746 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiAVKjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 05:39:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ECA6B81B9C
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 10:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7CDC004E1;
        Sat, 22 Jan 2022 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642847985;
        bh=eICj53nhUD6oDafxEW9rj8YPqjwYnnth05JyfsVW8b4=;
        h=From:To:Cc:Subject:Date:From;
        b=J7H7rBMZIaPwOI0kc27QWeLOb9kuzS23lcn/0MIBZ8VASl4GO556v1lWs+DneAOdd
         sG5u2P3c6JHveJPA+kih8WFkQT0WriCeaq34Jcl26YyGOrRZmZ4fiqH3cmOmVVanpl
         CdvmNpEIwS2x2Tk5lHyzZ1N3Yb0jLjji8HGkjVHf3sYNIgilQwlwwHeZIWzgJjYuiV
         jO6z64pr4Q1/t9Q0pnm4tYfDXdroTCbMWXgTy8bTi/VSIdVxbrOzTghziAco5FraTD
         Zx2fQOBIKOt5UNLpzLQWddKMzZmnTFr25ZKPfvNCc9sg2QnuUxOU7kueKW1NykQUIf
         Is/mo2KbONf/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nBDo7-0024oU-Bi; Sat, 22 Jan 2022 10:39:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] KVM: arm64: vgic-v3: Restrict SEIS workaround to known broken systems
Date:   Sat, 22 Jan 2022 10:39:12 +0000
Message-Id: <20220122103912.795026-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Contrary to what df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3
locally generated SErrors") was asserting, there is at least one other
system out there (Cavium ThunderX2) implementing SEIS, and not in
an obviously broken way.

So instead of imposing the M1 workaround on an innocent bystander,
let's limit it to the two known broken Apple implementations.

Fixes: df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors")
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 +++
 arch/arm64/kvm/vgic/vgic-v3.c   | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 20db2f281cf2..4fb419f7b8b6 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -983,6 +983,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
 	/* IDbits */
 	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
+	/* SEIS */
+	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK)
+		val |= BIT(ICC_CTLR_EL1_SEIS_SHIFT);
 	/* A3V */
 	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 78cf674c1230..d34a795f730c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -609,6 +609,18 @@ static int __init early_gicv4_enable(char *buf)
 }
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
+static struct midr_range broken_seis[] = {
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+	{},
+};
+
+static bool vgic_v3_broken_seis(void)
+{
+	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
+		is_midr_in_range_list(read_cpuid_id(), broken_seis));
+}
+
 /**
  * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
  * @info:	pointer to the GIC description
@@ -676,9 +688,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 		group1_trap = true;
 	}
 
-	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) {
-		kvm_info("GICv3 with locally generated SEI\n");
+	if (vgic_v3_broken_seis()) {
+		kvm_info("GICv3 with broken locally generated SEI\n");
 
+		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_SEIS_MASK;
 		group0_trap = true;
 		group1_trap = true;
 		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
-- 
2.34.1

