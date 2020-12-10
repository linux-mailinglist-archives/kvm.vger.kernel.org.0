Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6898E2D61A7
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391234AbgLJQWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392244AbgLJQFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:05:50 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D331723E1D;
        Thu, 10 Dec 2020 16:04:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONi-0008Di-97; Thu, 10 Dec 2020 16:01:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 54/66] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
Date:   Thu, 10 Dec 2020 15:59:50 +0000
Message-Id: <20201210160002.1407373-55-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to be able to make S2 TLB invalidations more performant on NV,
let's use a scheme derived from the ARMv8.4 TTL extension.

If bits [56:55] in the descriptor are non-zero, they indicate a level
which can be used as an invalidation range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  4 ++
 arch/arm64/kvm/nested.c             | 98 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 13 ++--
 3 files changed, 110 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7c47ad655e2e..34499c496ae6 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -123,6 +123,8 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
+u8 get_guest_mapping_ttl(struct kvm_vcpu *vcpu, struct kvm_s2_mmu *mmu,
+			 u64 addr);
 unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
@@ -131,4 +133,6 @@ struct sys_reg_desc;
 void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r);
 
+#define KVM_NV_GUEST_MAP_SZ	GENMASK_ULL(56, 55)
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 05b711e730b6..eef8f9873814 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -16,6 +16,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -351,6 +352,29 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+static int read_host_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	u64 *va = phys_to_virt(pa);
+
+	*desc = *va;
+
+	return 0;
+}
+
+static int kvm_walk_shadow_s2(struct kvm_s2_mmu *mmu, phys_addr_t gipa,
+			      struct kvm_s2_trans *result)
+{
+	struct s2_walk_info wi = { };
+
+	wi.read_desc = read_host_s2_desc;
+	wi.baddr = mmu->pgd_phys;
+
+	vtcr_to_walk_info(mmu->kvm->arch.vtcr, &wi);
+
+	wi.be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
+
+	return walk_nested_s2_pgd(gipa, &wi, result);
+}
 
 unsigned int ttl_to_size(u8 ttl)
 {
@@ -408,6 +432,80 @@ unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
+/*
+ * Compute the equivalent of the TTL field by parsing the shadow PT.
+ * The granule size is extracted from VTCR_EL2.TG0 while the level is
+ * retrieved from first entry carrying the level as a tag.
+ */
+u8 get_guest_mapping_ttl(struct kvm_vcpu *vcpu, struct kvm_s2_mmu *mmu,
+			 u64 addr)
+{
+	u64 tmp, sz = 0, vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	struct kvm_s2_trans out;
+	u8 ttl, level;
+
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		ttl = (1 << 2);
+		break;
+	case VTCR_EL2_TG0_16K:
+		ttl = (2 << 2);
+		break;
+	case VTCR_EL2_TG0_64K:
+		ttl = (3 << 2);
+		break;
+	default:
+		BUG();
+	}
+
+	tmp = addr;
+
+again:
+	/* Iteratively compute the block sizes for a particular granule size */
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		if	(sz < SZ_4K)	sz = SZ_4K;
+		else if (sz < SZ_2M)	sz = SZ_2M;
+		else if (sz < SZ_1G)	sz = SZ_1G;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_16K:
+		if	(sz < SZ_16K)	sz = SZ_16K;
+		else if (sz < SZ_32M)	sz = SZ_32M;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_64K:
+		if	(sz < SZ_64K)	sz = SZ_64K;
+		else if (sz < SZ_512M)	sz = SZ_512M;
+		else			sz = 0;
+		break;
+	default:
+		BUG();
+	}
+
+	if (sz == 0)
+		return 0;
+
+	tmp &= ~(sz - 1);
+	out = (struct kvm_s2_trans) { };
+	kvm_walk_shadow_s2(mmu, tmp, &out);
+	level = FIELD_GET(KVM_NV_GUEST_MAP_SZ, out.upper_attr);
+	if (!level)
+		goto again;
+
+	ttl |= level;
+
+	/*
+	 * We now have found some level information in the shadow S2. Check
+	 * that the resulting range is actually including the original IPA.
+	 */
+	sz = ttl_to_size(ttl);
+	if (addr < (tmp + sz))
+		return ttl;
+
+	return 0;
+}
+
 /* Must be called with kvm->lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 61094f5e955e..bd0a3e861ca5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2584,10 +2584,13 @@ static unsigned long compute_tlb_inval_range(struct kvm_vcpu *vcpu,
 					     u64 val)
 {
 	unsigned long max_size;
-	u8 ttl = 0;
+	u8 ttl;
 
-	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL)) {
-		ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+
+	if (!(cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) && ttl)) {
+		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
+		ttl = get_guest_mapping_ttl(vcpu, mmu, addr);
 	}
 
 	max_size = ttl_to_size(ttl);
@@ -2628,6 +2631,8 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	u64 base_addr;
 	unsigned long max_size;
 
+	spin_lock(&vcpu->kvm->mmu_lock);
+
 	/*
 	 * We drop a number of things from the supplied value:
 	 *
@@ -2639,8 +2644,6 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 */
 	base_addr = (p->regval & GENMASK_ULL(35, 0)) << 12;
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, HCR_VM);
 	if (mmu) {
 		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
-- 
2.29.2

