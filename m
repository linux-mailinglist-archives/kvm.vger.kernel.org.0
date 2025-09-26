Return-Path: <kvm+bounces-58865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF13CBA36F2
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AEE1627B6D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DA62F83AC;
	Fri, 26 Sep 2025 11:03:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350A12F548F;
	Fri, 26 Sep 2025 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884606; cv=none; b=W93MCS+E5lpYeJQ9W2cID20E3UasWeXTia3LO7TJzZO9ykPXPuO/PK6DLj7oTK/pmBqmKtFA7irVVwzxP6njCZ8AJcaKOGuaz9qf5mTCOUnPeG6lsGVn88kH6qRtfz6vykBq0NOzmX65bEU9AMwEa9U9AYWJTi+T9r7qqANSRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884606; c=relaxed/simple;
	bh=fjXJt2CfVxkbAP1rjjFOz5JK+z2VdhcQ7Q/T1ABGp24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYt8HCp6XK3RTOQPXgAEFBMO3nR5YDL+AJYR46Miken8zgvbSwUoPdXihsyE0/NZT5KeGdtBPgVJ1FZDWzElWGMTVdWuqyeNDm/dNcEohZVNv/OgyezJ3vSMkFegbiTRbvBKYxzMNk6/bIAmDR6oU7h9MZyhwU2oQanAb5QAwNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 788B61691;
	Fri, 26 Sep 2025 04:03:16 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8DDD3F66E;
	Fri, 26 Sep 2025 04:03:20 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 4/5] arm64: rme: Allocate AUX RTT PGDs and VMIDs
Date: Fri, 26 Sep 2025 12:02:53 +0100
Message-ID: <20250926110254.55449-5-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250926110254.55449-1-steven.price@arm.com>
References: <20250926110254.55449-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If using multiple planes then the auxiliary trees also need PGDs
allocating for them. Each plane also needs its own VMID.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |   4 +-
 arch/arm64/kvm/rme.c             | 133 +++++++++++++++++++++++++++----
 2 files changed, 122 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 934b30a8e607..a9dc24a53c65 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -53,6 +53,7 @@ enum realm_state {
  * @params: Parameters for the RMI_REALM_CREATE command
  * @num_aux: The number of auxiliary pages required by the RMM
  * @vmid: VMID to be used by the RMM for the realm
+ * @aux_pgd: The PGDs for the auxiliary planes
  * @ia_bits: Number of valid Input Address bits in the IPA
  * @num_aux_planes: Number of auxiliary planes
  * @rtt_tree_pp: True if each plane has its own RTT tree
@@ -64,7 +65,8 @@ struct realm {
 	struct realm_params *params;
 
 	unsigned long num_aux;
-	unsigned int vmid;
+	unsigned int vmid[4];
+	void *aux_pgd[3];
 	unsigned int ia_bits;
 	unsigned int num_aux_planes;
 	bool rtt_tree_pp;
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index fa39a8393d53..6cb938957510 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -782,10 +782,17 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_level_start = get_start_level(realm);
 	params->rtt_num_start = rtt_num_start;
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
-	params->vmid = realm->vmid;
+	params->vmid = realm->vmid[0];
+	for (int plane = 0; plane < realm->num_aux_planes; plane++)
+		params->aux_vmid[plane] = realm->vmid[plane + 1];
 	params->num_bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
 	params->num_wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
 
+	if (realm->rtt_tree_pp) {
+		for (int plane = 0; plane < realm->num_aux_planes; plane++)
+			params->aux_rtt_base[plane] = virt_to_phys(realm->aux_pgd[plane]);
+	}
+
 	if (kvm->arch.arm_pmu) {
 		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
 		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
@@ -1483,25 +1490,117 @@ static int rme_vmid_init(void)
 	return 0;
 }
 
-static int rme_vmid_reserve(void)
+static int rme_vmids_reserve(unsigned int *vmids, int count)
 {
-	int ret;
+	int ret = 0;
+	int vmid;
+	int i;
 	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
 
 	spin_lock(&rme_vmid_lock);
-	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
+	for (i = 0; i < count; i++) {
+		vmid = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
+		if (vmid < 0) {
+			while (i > 0) {
+				i--;
+				bitmap_release_region(rme_vmid_bitmap,
+						      vmids[i], 0);
+			}
+			ret = -EBUSY;
+			break;
+		}
+		vmids[i] = vmid;
+	}
 	spin_unlock(&rme_vmid_lock);
 
 	return ret;
 }
 
-static void rme_vmid_release(unsigned int vmid)
+static void rme_vmids_release(unsigned int *vmids, int count)
 {
+	int i;
+
 	spin_lock(&rme_vmid_lock);
-	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
+	for (i = 0; i < count; i++)
+		bitmap_release_region(rme_vmid_bitmap, vmids[i], 0);
 	spin_unlock(&rme_vmid_lock);
 }
 
+static void rme_free_aux_pgds(struct kvm *kvm)
+{
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	struct realm *realm = &kvm->arch.realm;
+	int plane, i;
+
+	for (plane = 0; plane < realm->num_aux_planes; plane++) {
+		phys_addr_t pgd_phys;
+		int ret = 0;
+
+		if (!realm->aux_pgd[plane])
+			continue;
+
+		pgd_phys = virt_to_phys(realm->aux_pgd[plane]);
+
+		for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
+			phys_addr_t table_phys = pgd_phys + i;
+
+			if (WARN_ON(rmi_granule_undelegate(table_phys))) {
+				ret = -ENXIO;
+				break;
+			}
+		}
+		if (ret == 0)
+			free_pages_exact(realm->aux_pgd[plane], pgd_size);
+	}
+}
+
+static int rme_alloc_aux_pgds(struct kvm *kvm)
+{
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t pgd_phys;
+	void *aux_pages;
+	int plane, i;
+	int ret;
+
+	for (plane = 0; plane < realm->num_aux_planes; plane++) {
+		aux_pages = alloc_pages_exact(pgd_size,
+					      GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!aux_pages) {
+			ret = -ENOMEM;
+			goto err_alloc;
+		}
+		realm->aux_pgd[plane] = aux_pages;
+
+		pgd_phys = virt_to_phys(realm->aux_pgd[plane]);
+
+		for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
+			if (rmi_granule_delegate(pgd_phys + i)) {
+				ret = -ENXIO;
+				goto err_delegate;
+			}
+		}
+	}
+	return 0;
+
+err_delegate:
+	while (i > 0) {
+		i -= RMM_PAGE_SIZE;
+
+		if (WARN_ON(rmi_granule_undelegate(pgd_phys + i))) {
+			/* Leak the pages */
+			goto err_undelegate_failed;
+		}
+	}
+
+	free_pages_exact(realm->aux_pgd[plane], pgd_size);
+err_undelegate_failed:
+	realm->aux_pgd[plane] = NULL;
+err_alloc:
+	rme_free_aux_pgds(kvm);
+	return ret;
+}
+
 static int kvm_create_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -1510,16 +1609,17 @@ static int kvm_create_realm(struct kvm *kvm)
 	if (kvm_realm_is_created(kvm))
 		return -EEXIST;
 
-	ret = rme_vmid_reserve();
-	if (ret < 0)
+	ret = rme_vmids_reserve(realm->vmid, realm->num_aux_planes + 1);
+	if (ret)
 		return ret;
-	realm->vmid = ret;
+
+	ret = rme_alloc_aux_pgds(kvm);
+	if (ret)
+		goto error_release_vmids;
 
 	ret = realm_create_rd(kvm);
-	if (ret) {
-		rme_vmid_release(realm->vmid);
-		return ret;
-	}
+	if (ret)
+		goto error_release_vmids;
 
 	WRITE_ONCE(realm->state, REALM_STATE_NEW);
 
@@ -1528,6 +1628,10 @@ static int kvm_create_realm(struct kvm *kvm)
 	realm->params = NULL;
 
 	return 0;
+
+error_release_vmids:
+	rme_vmids_release(realm->vmid, realm->num_aux_planes + 1);
+	return ret;
 }
 
 static int config_realm_hash_algo(struct realm *realm,
@@ -1649,7 +1753,8 @@ void kvm_destroy_realm(struct kvm *kvm)
 		realm->rd = NULL;
 	}
 
-	rme_vmid_release(realm->vmid);
+	rme_free_aux_pgds(kvm);
+	rme_vmids_release(realm->vmid, realm->num_aux_planes + 1);
 
 	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
 		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
-- 
2.43.0


