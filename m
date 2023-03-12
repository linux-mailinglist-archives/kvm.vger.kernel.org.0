Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4496B64B3
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCLKBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCLKAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72837F16
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615199; x=1710151199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IaTtnij9zhMFg8555efmquE92rdL4o0p2CbyH4BBvjs=;
  b=jzXfSwCTvs48dPWw7MhCVyM908oe7QSX82QVHWiNJ/xLTa6/D6Cy8q6c
   vg9SHwf9Uu6dG9T6MTr0YAPquspG98HgPzKSzur211XesoXlMaAo0CJVV
   baEA+hAIAvfmSsuuUDkuISKKCy0H1UKQYWZMFeTjpoahw43tpKuj6ujUj
   Bd2O4tWqyzXRn4uBppBGG5SeusMrvJWttoMw/1GXRie6zdFV4LdM3+LJj
   7hJdUc4SeLN5QHIA04nqTPB4x4/QPCqhIRG7XVsPfI9WqRc+qEuRaZSfH
   dgH5ukrdJv9z7WJ+n46CbP1urxVi/G0Ep1cEGZZdzk4zkwFqnUmf1OA9s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344762"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344762"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627560"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627560"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:32 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-7 11/12] pkvm: x86: Add pgtable override helper functions for map/unmap/free leaf
Date:   Mon, 13 Mar 2023 02:04:14 +0800
Message-Id: <20230312180415.1778669-12-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add override helper function in pgtable map/unmap/destroy APIs:
- map_leaf_override():  override the final page entry map function
                        for pkvm_pgtable_map()
- unmap_leaf_override(): override the final page entry unmap function
                        for pkvm_pgtable_unmap()
- free_leaf_override(): override the final page entry free function
                        for pkvm_pgtable_destroy()

The pkvm_pgtable_map() calls map_leaf_override() when doing page leaf
mapping, if the override helper function exist.

The pkvm_pgtable_unmap() calls unmap_leaf_override() when doing page
leaf unmapping, if the override helper function exist.

Meanwhile for pkvm_pgtable_destroy(), it calls free_leaf_override() when
doing page leaf free, if the override helper function exist.

This will be used to handle shadow EPT invalidation, destroy and EPT
violation in the following patches, as for these operations, shadow EPT
has its own page leaf operations, the default one shall be override.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c         |  11 +-
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c |   6 +-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c         |   5 +-
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c     | 137 +++++++++++++++---------
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h     |  47 +++++++-
 5 files changed, 144 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index f7d3510cf0e2..9e5aeb8b239e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -144,13 +144,14 @@ struct pkvm_pgtable_ops ept_ops = {
 int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot)
 {
-	return pkvm_pgtable_map(&host_ept, vaddr_start, phys_start, size, pgsz_mask, prot);
+	return pkvm_pgtable_map(&host_ept, vaddr_start, phys_start, size,
+				pgsz_mask, prot, NULL);
 }
 
 int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
 			unsigned long size)
 {
-	return pkvm_pgtable_unmap_safe(&host_ept, vaddr_start, phys_start, size);
+	return pkvm_pgtable_unmap_safe(&host_ept, vaddr_start, phys_start, size, NULL);
 }
 
 void host_ept_lock(void)
@@ -327,7 +328,7 @@ void pkvm_invalidate_shadow_ept(struct shadow_ept_desc *desc)
 	if (!is_valid_eptp(desc->shadow_eptp))
 		goto out;
 
-	pkvm_pgtable_unmap(sept, 0, size);
+	pkvm_pgtable_unmap(sept, 0, size, NULL);
 
 	flush_ept(desc->shadow_eptp);
 out:
@@ -342,7 +343,7 @@ void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc)
 	pkvm_spin_lock(&vm->lock);
 
 	if (desc->shadow_eptp) {
-		pkvm_pgtable_destroy(sept);
+		pkvm_pgtable_destroy(sept, NULL);
 
 		flush_ept(desc->shadow_eptp);
 
@@ -459,7 +460,7 @@ pkvm_handle_shadow_ept_violation(struct shadow_vcpu_state *shadow_vcpu, u64 l2_g
 		unsigned long gpa = ALIGN_DOWN(l2_gpa, level_size);
 		unsigned long hpa = ALIGN_DOWN(host_gpa2hpa(phys), level_size);
 
-		if (!pkvm_pgtable_map(sept, gpa, hpa, level_size, 0, gprot))
+		if (!pkvm_pgtable_map(sept, gpa, hpa, level_size, 0, gprot, NULL))
 			ret = PKVM_HANDLED;
 	}
 out:
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index 092c8b6ea5fe..e3718a4a19f6 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -74,7 +74,7 @@ static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_i
 
 static int host_ept_create_idmap_locked(u64 addr, u64 size, int pgsz_mask, u64 prot)
 {
-	return pkvm_pgtable_map(pkvm_hyp->host_vm.ept, addr, addr, size, pgsz_mask, prot);
+	return pkvm_pgtable_map(pkvm_hyp->host_vm.ept, addr, addr, size, pgsz_mask, prot, NULL);
 }
 
 static int
@@ -374,7 +374,7 @@ static int guest_complete_share(const struct pkvm_mem_transition *tx)
 	u64 prot = tx->completer.prot;
 
 	prot = pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED);
-	return pkvm_pgtable_map(pgt, addr, phys, size, 0, prot);
+	return pkvm_pgtable_map(pgt, addr, phys, size, 0, prot, NULL);
 }
 
 static int __do_share(const struct pkvm_mem_transition *tx)
@@ -513,7 +513,7 @@ static int guest_complete_unshare(const struct pkvm_mem_transition *tx)
 	u64 phys = tx->completer.guest.phys;
 	u64 size = tx->size;
 
-	return pkvm_pgtable_unmap_safe(pgt, addr, phys, size);
+	return pkvm_pgtable_unmap_safe(pgt, addr, phys, size, NULL);
 }
 
 static int __do_unshare(struct pkvm_mem_transition *tx)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index f2fe8aa45b46..58fe69ed4acf 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -187,7 +187,8 @@ int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
 {
 	int ret;
 
-	ret = pkvm_pgtable_map(&hyp_mmu, vaddr_start, phys_start, size, pgsz_mask, prot);
+	ret = pkvm_pgtable_map(&hyp_mmu, vaddr_start, phys_start, size,
+			pgsz_mask, prot, NULL);
 
 	return ret;
 }
@@ -196,7 +197,7 @@ int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long size)
 {
 	int ret;
 
-	ret = pkvm_pgtable_unmap(&hyp_mmu, vaddr_start, size);
+	ret = pkvm_pgtable_unmap(&hyp_mmu, vaddr_start, size, NULL);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
index 5854a30dbf8b..b36d7ed7d8f6 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -19,17 +19,6 @@ struct pgt_walk_data {
 	struct pkvm_pgtable_walker *walker;
 };
 
-struct pkvm_pgtable_map_data {
-	unsigned long phys;
-	u64 annotation;
-	u64 prot;
-	int pgsz_mask;
-};
-
-struct pkvm_pgtable_unmap_data {
-	unsigned long phys;
-};
-
 struct pkvm_pgtable_lookup_data {
 	unsigned long vaddr;
 	unsigned long phys;
@@ -107,21 +96,16 @@ static void pgtable_split(struct pkvm_pgtable_ops *pgt_ops,
 	}
 }
 
-static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
-				unsigned long vaddr_end, int level, void *ptep,
-				struct pgt_flush_data *flush_data,
-				struct pkvm_pgtable_map_data *data)
+static int pgtable_map_leaf(struct pkvm_pgtable *pgt,
+			    unsigned long vaddr,
+			    int level, void *ptep,
+			    struct pgt_flush_data *flush_data,
+			    struct pkvm_pgtable_map_data *data)
 {
 	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
 	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
 	u64 old = *(u64 *)ptep, new;
 
-	if (!leaf_mapping_allowed(pgt_ops, vaddr, vaddr_end,
-				 data->phys, data->pgsz_mask, level)) {
-		/* The 4K page shall be able to map, otherwise return err */
-		return (level == PG_LEVEL_4K ? -EINVAL : -E2BIG);
-	}
-
 	if (pkvm_phys_is_valid(data->phys)) {
 		new = data->phys | data->prot;
 		if (level != PG_LEVEL_4K)
@@ -153,6 +137,23 @@ static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	return 0;
 }
 
+static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
+				unsigned long vaddr_end, int level, void *ptep,
+				struct pgt_flush_data *flush_data,
+				struct pkvm_pgtable_map_data *data)
+{
+	if (!leaf_mapping_allowed(pgt->pgt_ops, vaddr, vaddr_end,
+				 data->phys, data->pgsz_mask, level)) {
+		/* The 4K page shall be able to map, otherwise return err */
+		return (level == PG_LEVEL_4K ? -EINVAL : -E2BIG);
+	}
+
+	if (data->map_leaf_override)
+		return data->map_leaf_override(pgt, vaddr, level, ptep, flush_data, data);
+	else
+		return pgtable_map_leaf(pgt, vaddr, level, ptep, flush_data, data);
+}
+
 static int pgtable_map_walk_leaf(struct pkvm_pgtable *pgt,
 				 unsigned long vaddr, unsigned long vaddr_end,
 				 int level, void *ptep, unsigned long flags,
@@ -250,6 +251,33 @@ static inline void *get_page_from_freelist(struct list_head *head)
 	return (void *)node;
 }
 
+static int pgtable_unmap_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
+			      int level, void *ptep, struct pgt_flush_data *flush_data,
+			      void *const arg)
+{
+	struct pkvm_pgtable_unmap_data *data = arg;
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	unsigned long size = page_level_size(level);
+
+	if (data->phys != INVALID_ADDR) {
+		unsigned long phys = pgt_ops->pgt_entry_to_phys(ptep);
+
+		PKVM_ASSERT(phys == data->phys);
+	}
+
+	pgt_ops->pgt_set_entry(ptep, 0);
+	flush_data->flushtlb |= true;
+	mm_ops->put_page(ptep);
+
+	if (data->phys != INVALID_ADDR) {
+		data->phys = ALIGN_DOWN(data->phys, size);
+		data->phys += size;
+	}
+
+	return 0;
+}
+
 static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 			    unsigned long vaddr_end, int level, void *ptep,
 			    unsigned long flags, struct pgt_flush_data *flush_data,
@@ -271,21 +299,12 @@ static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	if (level == PG_LEVEL_4K || (pgt_ops->pgt_entry_huge(ptep) &&
 				     leaf_mapping_valid(pgt_ops, vaddr, vaddr_end,
 							1 << level, level))) {
-		if (data->phys != INVALID_ADDR) {
-			unsigned long phys = pgt_ops->pgt_entry_to_phys(ptep);
-
-			PKVM_ASSERT(phys == data->phys);
-		}
-
-		pgt_ops->pgt_set_entry(ptep, 0);
-		flush_data->flushtlb |= true;
-		mm_ops->put_page(ptep);
-
-		if (data->phys != INVALID_ADDR) {
-			data->phys = ALIGN_DOWN(data->phys, size);
-			data->phys += size;
-		}
-		return 0;
+		if (data->unmap_leaf_override)
+			return data->unmap_leaf_override(pgt, vaddr, level, ptep,
+					flush_data, data);
+		else
+			return pgtable_unmap_leaf(pgt, vaddr, level, ptep,
+					flush_data, data);
 	}
 
 	if (pgt_ops->pgt_entry_huge(ptep)) {
@@ -362,6 +381,18 @@ static int pgtable_lookup_cb(struct pkvm_pgtable *pgt,
 	return PGTABLE_WALK_DONE;
 }
 
+static int pgtable_free_leaf(struct pkvm_pgtable *pgt,
+			     struct pgt_flush_data *flush_data,
+			     void *ptep)
+{
+	if (pgt->pgt_ops->pgt_entry_present(ptep)) {
+		flush_data->flushtlb |= true;
+		pgt->mm_ops->put_page(ptep);
+	}
+
+	return 0;
+}
+
 static int pgtable_free_cb(struct pkvm_pgtable *pgt,
 			    unsigned long vaddr,
 			    unsigned long vaddr_end,
@@ -371,17 +402,18 @@ static int pgtable_free_cb(struct pkvm_pgtable *pgt,
 			    struct pgt_flush_data *flush_data,
 			    void *const arg)
 {
+	struct pkvm_pgtable_free_data *data = arg;
 	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
 	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
 	phys_addr_t phys;
 	void *virt;
 
 	if (pgt_ops->pgt_entry_is_leaf(ptep, level)) {
-		if (pgt_ops->pgt_entry_present(ptep)) {
-			flush_data->flushtlb |= true;
-			mm_ops->put_page(ptep);
-		}
-		return 0;
+		if (data->free_leaf_override)
+			return data->free_leaf_override(pgt, vaddr, level, ptep,
+							flush_data, data);
+		else
+			return pgtable_free_leaf(pgt, flush_data, ptep);
 	}
 
 	/* Free the child page */
@@ -526,7 +558,8 @@ int pkvm_pgtable_init(struct pkvm_pgtable *pgt,
 
 static int __pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		     unsigned long phys, unsigned long size,
-		     int pgsz_mask, u64 prot, u64 annotation)
+		     int pgsz_mask, u64 prot, pgtable_leaf_ov_fn_t map_leaf,
+		     u64 annotation)
 {
 	struct pkvm_pgtable_map_data data = {
 		.phys = phys,
@@ -534,6 +567,7 @@ static int __pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_star
 		.prot = prot,
 		.pgsz_mask = pgsz_mask ? pgt->allowed_pgsz & pgsz_mask :
 					 pgt->allowed_pgsz,
+		.map_leaf_override = map_leaf,
 	};
 	struct pkvm_pgtable_walker walker = {
 		.cb = pgtable_map_cb,
@@ -546,17 +580,18 @@ static int __pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_star
 
 int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		     unsigned long phys_start, unsigned long size,
-		     int pgsz_mask, u64 prot)
+		     int pgsz_mask, u64 prot, pgtable_leaf_ov_fn_t map_leaf)
 {
 	return __pkvm_pgtable_map(pgt, vaddr_start, ALIGN_DOWN(phys_start, PAGE_SIZE),
-				  size, pgsz_mask, prot, 0);
+				  size, pgsz_mask, prot, map_leaf, 0);
 }
 
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-		       unsigned long size)
+		       unsigned long size, pgtable_leaf_ov_fn_t unmap_leaf)
 {
 	struct pkvm_pgtable_unmap_data data = {
 		.phys = INVALID_ADDR,
+		.unmap_leaf_override = unmap_leaf,
 	};
 	struct pkvm_pgtable_walker walker = {
 		.cb = pgtable_unmap_cb,
@@ -568,10 +603,12 @@ int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 }
 
 int pkvm_pgtable_unmap_safe(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-			    unsigned long phys_start, unsigned long size)
+			    unsigned long phys_start, unsigned long size,
+			    pgtable_leaf_ov_fn_t unmap_leaf)
 {
 	struct pkvm_pgtable_unmap_data data = {
 		.phys = ALIGN_DOWN(phys_start, PAGE_SIZE),
+		.unmap_leaf_override = unmap_leaf,
 	};
 	struct pkvm_pgtable_walker walker = {
 		.cb = pgtable_unmap_cb,
@@ -612,13 +649,17 @@ void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		*plevel = data.level;
 }
 
-void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt)
+void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt, pgtable_leaf_ov_fn_t free_leaf)
 {
 	unsigned long size;
 	void *virt_root;
 	struct pkvm_pgtable_ops *pgt_ops;
+	struct pkvm_pgtable_free_data data = {
+		.free_leaf_override = free_leaf,
+	};
 	struct pkvm_pgtable_walker walker = {
 		.cb 	= pgtable_free_cb,
+		.arg 	= &data,
 		.flags 	= PKVM_PGTABLE_WALK_LEAF | PKVM_PGTABLE_WALK_TABLE_POST,
 	};
 
@@ -642,5 +683,5 @@ int pkvm_pgtable_annotate(struct pkvm_pgtable *pgt, unsigned long addr,
 		return -EINVAL;
 
 	return __pkvm_pgtable_map(pgt, addr, INVALID_ADDR, size,
-			1 << PG_LEVEL_4K, 0, annotation);
+			1 << PG_LEVEL_4K, 0, NULL, annotation);
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
index cb6645e96409..4ed63ea47976 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
@@ -52,6 +52,44 @@ typedef int (*pgtable_visit_fn_t)(struct pkvm_pgtable *pgt, unsigned long vaddr,
 				  unsigned long flags, struct pgt_flush_data *flush_data,
 				  void *const arg);
 
+typedef int (*pgtable_leaf_ov_fn_t)(struct pkvm_pgtable *pgt, unsigned long vaddr,
+				    int level, void *ptep, struct pgt_flush_data *flush_data,
+				    void *data);
+
+struct pkvm_pgtable_map_data {
+	unsigned long phys;
+	u64 annotation;
+	u64 prot;
+	int pgsz_mask;
+
+	/*
+	 * extra override helper ops:
+	 * - map_leaf_override():  override the final page entry map function
+	 *   		  	   for pkvm_pgtable_map()
+	 */
+	pgtable_leaf_ov_fn_t map_leaf_override;
+};
+
+struct pkvm_pgtable_unmap_data {
+	unsigned long phys;
+
+	/*
+	 * extra override helper ops:
+	 * - unmap_leaf_override(): override the final page entry map function
+	 *   for pkvm_pgtable_unmap()
+	 */
+	pgtable_leaf_ov_fn_t unmap_leaf_override;
+};
+
+struct pkvm_pgtable_free_data {
+	/*
+	 * extra override helper ops:
+	 * - free_leaf_override(): override the final page entry free function
+	 *   		  	   for pkvm_pgtable_destroy()
+	 */
+	pgtable_leaf_ov_fn_t free_leaf_override;
+};
+
 #define PGTABLE_WALK_DONE      1
 
 struct pkvm_pgtable_walker {
@@ -72,14 +110,15 @@ int pkvm_pgtable_init(struct pkvm_pgtable *pgt,
 		bool alloc_root);
 int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		unsigned long phys_start, unsigned long size,
-		int pgsz_mask, u64 entry_prot);
+		int pgsz_mask, u64 entry_prot, pgtable_leaf_ov_fn_t map_leaf);
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-		       unsigned long size);
+		       unsigned long size, pgtable_leaf_ov_fn_t unmap_leaf);
 int pkvm_pgtable_unmap_safe(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-			    unsigned long phys_start, unsigned long size);
+			    unsigned long phys_start, unsigned long size,
+			    pgtable_leaf_ov_fn_t unmap_leaf);
 void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		unsigned long *pphys, u64 *pprot, int *plevel);
-void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt);
+void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt, pgtable_leaf_ov_fn_t free_leaf);
 int pkvm_pgtable_annotate(struct pkvm_pgtable *pgt, unsigned long addr,
 			  unsigned long size, u64 annotation);
 #endif
-- 
2.25.1

