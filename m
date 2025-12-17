Return-Path: <kvm+bounces-66124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29143CC753F
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33542300F300
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C7234A76B;
	Wed, 17 Dec 2025 10:12:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F4C349B0B;
	Wed, 17 Dec 2025 10:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966372; cv=none; b=JhuLqJAuoL/Ec05EyQKEY9fEfxQCAgjezbx00amdL7C13LpG2HK3zwJYesHBO+LZwGZOoRxvgzlVClgwsfE/U+fJqW3YcLGUH6NCqRLbRYywpQLPNwPIrNcKuzsBDARdMRMqDHbBUA6OBMkDf4zRtdcpN+bUlOFtgbcIzmvCtaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966372; c=relaxed/simple;
	bh=mmdp97WfxOpz1ShWIGSZ0Bg8MbLMTGLoLz1/Y3la564=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNx/EbWmBAWOkrebJP9T0fyWC+IEibLIz6cjtuNUlSZ+568CfR/PlGEtC/b31ZudMV6LQObWGqj7SWJgkXztF5pU1M/4oCdxDhMwf4twxoMCFRCaRBkS4Xsujg/aecAINqjLnnw4SGA5OPp89Et5bBV3qxI6aWY8Ks3QzLO5abc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA8041517;
	Wed, 17 Dec 2025 02:12:42 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CB2B3F73B;
	Wed, 17 Dec 2025 02:12:44 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 13/46] KVM: arm64: vgic: Provide helper for number of list registers
Date: Wed, 17 Dec 2025 10:10:50 +0000
Message-ID: <20251217101125.91098-14-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the number of list registers available is stored in a global
(kvm_vgic_global_state.nr_lr). With Arm CCA the RMM is permitted to
reserve list registers for its own use and so the number of available
list registers can be fewer for a realm VM. Provide wrapper functions
to fetch the global in preparation for restricting nr_lr when dealing
with a realm VM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes in v12:
 * Upstream changes mean that vcpu isn't available everywhere we need
   it, so update helpers to take vcpu.
 * Note that the VGIC handling will be reworked for the RMM 2.0 spec.
New patch for v6
---
 arch/arm64/kvm/vgic/vgic-v2.c |  6 +++---
 arch/arm64/kvm/vgic/vgic-v3.c |  8 ++++----
 arch/arm64/kvm/vgic/vgic.c    |  6 +++---
 arch/arm64/kvm/vgic/vgic.h    | 18 ++++++++++++------
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 585491fbda80..990bf693f65d 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -34,11 +34,11 @@ void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu,
 
 	cpuif->vgic_hcr = GICH_HCR_EN;
 
-	if (irqs_pending_outside_lrs(als))
+	if (irqs_pending_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= GICH_HCR_NPIE;
-	if (irqs_active_outside_lrs(als))
+	if (irqs_active_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= GICH_HCR_LRENPIE;
-	if (irqs_outside_lrs(als))
+	if (irqs_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= GICH_HCR_UIE;
 
 	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP0_MASK) ?
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1d6dd1b545bd..c9ff4f90c975 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -31,11 +31,11 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 
 	cpuif->vgic_hcr = ICH_HCR_EL2_En;
 
-	if (irqs_pending_outside_lrs(als))
+	if (irqs_pending_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_NPIE;
-	if (irqs_active_outside_lrs(als))
+	if (irqs_active_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_LRENPIE;
-	if (irqs_outside_lrs(als))
+	if (irqs_outside_lrs(als, vcpu))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_UIE;
 
 	if (!als->nr_sgi)
@@ -60,7 +60,7 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	 * can change behind our back without any warning...
 	 */
 	if (!cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR) ||
-	    irqs_active_outside_lrs(als)		     ||
+	    irqs_active_outside_lrs(als, vcpu)		     ||
 	    atomic_read(&vcpu->kvm->arch.vgic.active_spis))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fd..2fdcef3d28d1 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -957,7 +957,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 
 	summarize_ap_list(vcpu, &als);
 
-	if (irqs_outside_lrs(&als))
+	if (irqs_outside_lrs(&als, vcpu))
 		vgic_sort_ap_list(vcpu);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
@@ -967,12 +967,12 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		if (count == kvm_vgic_global_state.nr_lr)
+		if (count == kvm_vcpu_vgic_nr_lr(vcpu))
 			break;
 	}
 
 	/* Nuke remaining LRs */
-	for (int i = count ; i < kvm_vgic_global_state.nr_lr; i++)
+	for (int i = count ; i < kvm_vcpu_vgic_nr_lr(vcpu); i++)
 		vgic_clear_lr(vcpu, i);
 
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc2..55a1142efc6f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -7,6 +7,7 @@
 
 #include <linux/irqchip/arm-gic-common.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_rmi.h>
 
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
@@ -242,14 +243,19 @@ struct ap_list_summary {
 	unsigned int	nr_sgi;		/* any SGI */
 };
 
-#define irqs_outside_lrs(s)						\
-	 (((s)->nr_pend + (s)->nr_act) > kvm_vgic_global_state.nr_lr)
+static inline int kvm_vcpu_vgic_nr_lr(struct kvm_vcpu *vcpu)
+{
+	return kvm_vgic_global_state.nr_lr;
+}
+
+#define irqs_outside_lrs(s, vcpu)					\
+	 (((s)->nr_pend + (s)->nr_act) > kvm_vcpu_vgic_nr_lr(vcpu))
 
-#define irqs_pending_outside_lrs(s)			\
-	((s)->nr_pend > kvm_vgic_global_state.nr_lr)
+#define irqs_pending_outside_lrs(s, vcpu)			\
+	((s)->nr_pend > kvm_vcpu_vgic_nr_lr(vcpu))
 
-#define irqs_active_outside_lrs(s)		\
-	((s)->nr_act &&	irqs_outside_lrs(s))
+#define irqs_active_outside_lrs(s, vcpu)		\
+	((s)->nr_act &&	irqs_outside_lrs(s, vcpu))
 
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr);
-- 
2.43.0


