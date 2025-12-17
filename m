Return-Path: <kvm+bounces-66133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF02CC71DC
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62E3330AEC97
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85C134EEEB;
	Wed, 17 Dec 2025 10:13:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BBE34E768;
	Wed, 17 Dec 2025 10:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966415; cv=none; b=kHT0A42pvAPcGPnUru4B5EsCqtj4tO+jt8MwJf6RJ9BWRWhbJSNhDCa8oTVVSLslmEzfG3MDW2DSCWhagltT8Dk7H6wHOO2X3v6br5jFu96xEcgnQqorgiuhN1M38R+xFo9ttkYeakfhve/tIAXkfRdbLIPGbQyOW2y50n39M0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966415; c=relaxed/simple;
	bh=nIpKTWELtOnqA0N3t1I/B/zDz1c8WpFZIpVSBgNSgCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXCcNuxE2Lag3CjbEpkmyNo+yq/L03p41SVogqnHNOUkFMSpj7eDC3iCNEGLiXEcUBnWL3R0yHqtYTUCrCwcvhSzcDcdOet8q91hnG7VslelYoTxLR2/TEDCbqbjkK8f9+prO+NBQC51LEkgest/43g/DA0Sik/HjpBgcBQO730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 452D7168F;
	Wed, 17 Dec 2025 02:13:26 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CD993F73B;
	Wed, 17 Dec 2025 02:13:29 -0800 (PST)
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
Subject: [PATCH v12 22/46] arm64: RMI: Create the realm descriptor
Date: Wed, 17 Dec 2025 10:10:59 +0000
Message-ID: <20251217101125.91098-23-steven.price@arm.com>
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

Creating a realm involves first creating a realm descriptor (RD). This
involves passing the configuration information to the RMM. Do this as
part of realm_ensure_created() so that the realm is created when it is
first needed.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v12
---
 arch/arm64/kvm/rmi.c | 117 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index b51e68e56d56..18edc7eeb5fa 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -500,6 +500,106 @@ static void realm_unmap_shared_range(struct kvm *kvm,
 			     start, end);
 }
 
+/* Calculate the number of s2 root rtts needed */
+static int realm_num_root_rtts(struct realm *realm)
+{
+	unsigned int ipa_bits = realm->ia_bits;
+	unsigned int levels = 4 - get_start_level(realm);
+	unsigned int sl_ipa_bits = levels * (RMM_PAGE_SHIFT - 3) +
+				   RMM_PAGE_SHIFT;
+
+	if (sl_ipa_bits >= ipa_bits)
+		return 1;
+
+	return 1 << (ipa_bits - sl_ipa_bits);
+}
+
+static int realm_create_rd(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_params *params = realm->params;
+	void *rd = NULL;
+	phys_addr_t rd_phys, params_phys;
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	int i, r;
+	int rtt_num_start;
+
+	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	rtt_num_start = realm_num_root_rtts(realm);
+
+	if (WARN_ON(realm->rd || !realm->params))
+		return -EEXIST;
+
+	if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
+		return -EINVAL;
+
+	rd = (void *)__get_free_page(GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	rd_phys = virt_to_phys(rd);
+	if (rmi_granule_delegate(rd_phys)) {
+		r = -ENXIO;
+		goto free_rd;
+	}
+
+	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
+
+		if (rmi_granule_delegate(pgd_phys)) {
+			r = -ENXIO;
+			goto out_undelegate_tables;
+		}
+	}
+
+	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	params->rtt_level_start = get_start_level(realm);
+	params->rtt_num_start = rtt_num_start;
+	params->rtt_base = kvm->arch.mmu.pgd_phys;
+	params->vmid = realm->vmid;
+
+	params_phys = virt_to_phys(params);
+
+	if (rmi_realm_create(rd_phys, params_phys)) {
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
+		WARN_ON(rmi_realm_destroy(rd_phys));
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	realm->rd = rd;
+	WRITE_ONCE(realm->state, REALM_STATE_NEW);
+	/* The realm is up, free the parameters.  */
+	free_page((unsigned long)realm->params);
+	realm->params = NULL;
+
+	return 0;
+
+out_undelegate_tables:
+	while (i > 0) {
+		i -= RMM_PAGE_SIZE;
+
+		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
+
+		if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
+			/* Leak the pages if they cannot be returned */
+			kvm->arch.mmu.pgt = NULL;
+			break;
+		}
+	}
+	if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
+		/* Leak the page if it isn't returned */
+		return r;
+	}
+free_rd:
+	free_page((unsigned long)rd);
+	return r;
+}
+
 static int realm_unmap_private_page(struct realm *realm,
 				    unsigned long ipa,
 				    unsigned long *next_addr)
@@ -803,8 +903,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
 
 static int realm_ensure_created(struct kvm *kvm)
 {
-	/* Provided in later patch */
-	return -ENXIO;
+	int ret;
+
+	switch (kvm_realm_state(kvm)) {
+	case REALM_STATE_NONE:
+		break;
+	case REALM_STATE_NEW:
+		return 0;
+	case REALM_STATE_DEAD:
+		return -ENXIO;
+	default:
+		return -EBUSY;
+	}
+
+	ret = realm_create_rd(kvm);
+	return ret;
 }
 
 static int set_ripas_of_protected_regions(struct kvm *kvm)
-- 
2.43.0


