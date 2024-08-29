Return-Path: <kvm+bounces-25417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6739652DE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3DC41C225D3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6B41BD4FF;
	Thu, 29 Aug 2024 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="BZ2cy6VK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE941BB69A;
	Thu, 29 Aug 2024 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970279; cv=none; b=Btddy2TpZK1EqEQDFLgNqDdfN4+koSnZArXLH0YIS2Pg4uZ5bm+J0KUEgvHAuaL/v8oLq70O84qh4JC+mtAuakqepMkobHLANr7ggG5Vrtk5onu1kP8MnTtmLOTf3lMB1EoBiYjHZxkyXeOj5U4g+rE77xTfpX1dHEuNuF9D71s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970279; c=relaxed/simple;
	bh=OVpsnsnklWI91mBnkJxqpUi4I2UexG3F/rRgCYr+w5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=NRj83/fPwoU9ChRTAikX7AFoq64inMjXj/AjQ372MYINVIbnRQ52NHn8FtBy4sRT1Up2sJUwY0RrExg3i4Y2VljilD0m3Z7xMLwZCVy6D6nikFyryAjvmjqdu/yjZ9yxE92wOS46WxTeFs+mGY+oMp4BlIOIWhJJc/oQOvffWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=BZ2cy6VK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TGK3xQ005704;
	Thu, 29 Aug 2024 22:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d2/WnP2frNBYCJvNS7Pj/sP9q/9Ds6gocJG9LQvySYc=; b=BZ2cy6VKH9zO+TRh
	H/H/KZy33RkTyj7jBOCHlrahsoxDZqyO/o5i0rW4eZgp8M79zIirPprIieb22E82
	jN4hLvSyM/7KB65al3/+SJ5AvHI/N+QaPS0iNGIX55OCqzklUcp1nHbAzuT3klLZ
	aCnS52AWRU+Nu/GkOAK/cRHZUoquW8e2VjdzFfHd9PCmVEyubW4vioNsu0lMcMcU
	5PXG4eMsBZ2RDFkh1vqcVLeVH8BVbS34OMLV2JloJhe4DrFZKzFuUkSJlVteKN+J
	p90xDl47PNvK4D341qw8OUNFsDIbnfoO+Uja/b+I61YeCiCunmw7iVpI8W8lWuVF
	Eccjdg==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419putxv3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:13 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMOCM2019594
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:12 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:12 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Thu, 29 Aug 2024 15:24:11 -0700
Subject: [PATCH RFC v2 3/5] kvm: Convert to use guest_memfd library
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240829-guest-memfd-lib-v2-3-b9afc1ff3656@quicinc.com>
References: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
In-Reply-To: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sean Christopherson
	<seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov
	<bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>,
        Mike Rapoport <rppt@kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>,
        Elliot Berman <quic_eberman@quicinc.com>
X-Mailer: b4 0.14.1
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: KkmqlMiCSiehdHohJ5aZU1fbV3yHin3l
X-Proofpoint-GUID: KkmqlMiCSiehdHohJ5aZU1fbV3yHin3l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

Use the recently created mm/guest_memfd implementation. No functional
change intended.

Note: I've only compile-tested this. Appreciate some help from SEV folks
to be able to test this.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 arch/x86/kvm/svm/sev.c |   3 +-
 virt/kvm/Kconfig       |   1 +
 virt/kvm/guest_memfd.c | 371 ++++++++++---------------------------------------
 virt/kvm/kvm_main.c    |   2 -
 virt/kvm/kvm_mm.h      |   6 -
 5 files changed, 77 insertions(+), 306 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b72..f3a6857270943 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2297,8 +2297,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 			kunmap_local(vaddr);
 		}
 
-		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
-				       sev_get_asid(kvm), true);
+		ret = guest_memfd_make_inaccessible(pfn_folio(pfn));
 		if (ret)
 			goto err;
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fd6a3010afa83..1e7a3dc488919 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -106,6 +106,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
 
 config KVM_PRIVATE_MEM
        select XARRAY_MULTI
+       select GUEST_MEMFD
        bool
 
 config KVM_GENERIC_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f079a61a56db..cbff71b6019db 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,9 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/backing-dev.h>
-#include <linux/falloc.h>
+#include <linux/guest_memfd.h>
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
@@ -13,6 +11,13 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+static inline struct kvm_gmem *inode_to_kvm_gmem(struct inode *inode)
+{
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+
+	return list_first_entry_or_null(gmem_list, struct kvm_gmem, entry);
+}
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -25,12 +30,11 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
-static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
-				    pgoff_t index, struct folio *folio)
+static int kvm_gmem_prepare_inaccessible(struct inode *inode, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-	kvm_pfn_t pfn = folio_file_pfn(folio, index);
-	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
+	kvm_pfn_t pfn = folio_file_pfn(folio, 0);
+	gfn_t gfn = slot->base_gfn + folio_index(folio) - slot->gmem.pgoff;
 	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
 	if (rc) {
 		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
@@ -42,67 +46,7 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
-{
-	folio_mark_uptodate(folio);
-}
-
-/*
- * Process @folio, which contains @gfn, so that the guest can use it.
- * The folio must be locked and the gfn must be contained in @slot.
- * On successful return the guest sees a zero page so as to avoid
- * leaking host data and the up-to-date flag is set.
- */
-static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
-				  gfn_t gfn, struct folio *folio)
-{
-	unsigned long nr_pages, i;
-	pgoff_t index;
-	int r;
-
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
-
-	/*
-	 * Preparing huge folios should always be safe, since it should
-	 * be possible to split them later if needed.
-	 *
-	 * Right now the folio order is always going to be zero, but the
-	 * code is ready for huge folios.  The only assumption is that
-	 * the base pgoff of memslots is naturally aligned with the
-	 * requested page order, ensuring that huge folios can also use
-	 * huge page table entries for GPA->HPA mapping.
-	 *
-	 * The order will be passed when creating the guest_memfd, and
-	 * checked when creating memslots.
-	 */
-	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
-	index = gfn - slot->base_gfn + slot->gmem.pgoff;
-	index = ALIGN_DOWN(index, 1 << folio_order(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
-	if (!r)
-		kvm_gmem_mark_prepared(folio);
-
-	return r;
-}
-
-/*
- * Returns a locked folio on success.  The caller is responsible for
- * setting the up-to-date flag before the memory is mapped into the guest.
- * There is no backing storage for the memory, so the folio will remain
- * up-to-date until it's removed.
- *
- * Ignore accessed, referenced, and dirty flags.  The memory is
- * unevictable and there is no storage to write back to.
- */
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
-{
-	/* TODO: Support huge pages. */
-	return filemap_grab_folio(inode->i_mapping, index);
-}
-
-static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+static void __kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 				      pgoff_t end)
 {
 	bool flush = false, found_memslot = false;
@@ -137,118 +81,38 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
-				    pgoff_t end)
+static int kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t offset, unsigned long nr)
 {
-	struct kvm *kvm = gmem->kvm;
-
-	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
-		KVM_MMU_LOCK(kvm);
-		kvm_mmu_invalidate_end(kvm);
-		KVM_MMU_UNLOCK(kvm);
-	}
-}
-
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
-{
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm_gmem *gmem;
 
-	/*
-	 * Bindings must be stable across invalidation to ensure the start+end
-	 * are balanced.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
-
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
-
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
-
-	filemap_invalidate_unlock(inode->i_mapping);
+	list_for_each_entry(gmem, &inode->i_mapping->i_private_list, entry)
+		__kvm_gmem_invalidate_begin(gmem, offset, offset + nr);
 
 	return 0;
 }
 
-static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
+static void __kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
+				    pgoff_t end)
 {
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t start, index, end;
-	int r;
-
-	/* Dedicated guest is immutable by default. */
-	if (offset + len > i_size_read(inode))
-		return -EINVAL;
-
-	filemap_invalidate_lock_shared(mapping);
-
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
-
-	r = 0;
-	for (index = start; index < end; ) {
-		struct folio *folio;
-
-		if (signal_pending(current)) {
-			r = -EINTR;
-			break;
-		}
-
-		folio = kvm_gmem_get_folio(inode, index);
-		if (IS_ERR(folio)) {
-			r = PTR_ERR(folio);
-			break;
-		}
-
-		index = folio_next_index(folio);
-
-		folio_unlock(folio);
-		folio_put(folio);
-
-		/* 64-bit only, wrapping the index should be impossible. */
-		if (WARN_ON_ONCE(!index))
-			break;
+	struct kvm *kvm = gmem->kvm;
 
-		cond_resched();
+	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
+		KVM_MMU_LOCK(kvm);
+		kvm_mmu_invalidate_end(kvm);
+		KVM_MMU_UNLOCK(kvm);
 	}
-
-	filemap_invalidate_unlock_shared(mapping);
-
-	return r;
 }
 
-static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
-			       loff_t len)
+static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t offset, unsigned long nr)
 {
-	int ret;
-
-	if (!(mode & FALLOC_FL_KEEP_SIZE))
-		return -EOPNOTSUPP;
-
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
-	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
-		return -EINVAL;
-
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
-	else
-		ret = kvm_gmem_allocate(file_inode(file), offset, len);
+	struct kvm_gmem *gmem;
 
-	if (!ret)
-		file_modified(file);
-	return ret;
+	list_for_each_entry(gmem, &inode->i_mapping->i_private_list, entry)
+		__kvm_gmem_invalidate_end(gmem, offset, offset + nr);
 }
 
-static int kvm_gmem_release(struct inode *inode, struct file *file)
+static void __kvm_gmem_release(struct inode *inode, struct kvm_gmem *gmem)
 {
-	struct kvm_gmem *gmem = file->private_data;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
@@ -274,8 +138,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	__kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	__kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
 
@@ -287,6 +151,14 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	kfree(gmem);
 
 	kvm_put_kvm(kvm);
+}
+
+static int kvm_gmem_release(struct inode *inode)
+{
+	struct kvm_gmem *gmem;
+
+	list_for_each_entry(gmem, &inode->i_mapping->i_private_list, entry)
+		__kvm_gmem_release(inode, gmem);
 
 	return 0;
 }
@@ -302,94 +174,11 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
-static struct file_operations kvm_gmem_fops = {
-	.open		= generic_file_open,
-	.release	= kvm_gmem_release,
-	.fallocate	= kvm_gmem_fallocate,
-};
-
-void kvm_gmem_init(struct module *module)
-{
-	kvm_gmem_fops.owner = module;
-}
-
-static int kvm_gmem_migrate_folio(struct address_space *mapping,
-				  struct folio *dst, struct folio *src,
-				  enum migrate_mode mode)
-{
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
-{
-	struct list_head *gmem_list = &mapping->i_private_list;
-	struct kvm_gmem *gmem;
-	pgoff_t start, end;
-
-	filemap_invalidate_lock_shared(mapping);
-
-	start = folio->index;
-	end = start + folio_nr_pages(folio);
-
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
-
-	/*
-	 * Do not truncate the range, what action is taken in response to the
-	 * error is userspace's decision (assuming the architecture supports
-	 * gracefully handling memory errors).  If/when the guest attempts to
-	 * access a poisoned page, kvm_gmem_get_pfn() will return -EHWPOISON,
-	 * at which point KVM can either terminate the VM or propagate the
-	 * error to userspace.
-	 */
-
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
-
-	filemap_invalidate_unlock_shared(mapping);
-
-	return MF_DELAYED;
-}
-
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
-static void kvm_gmem_free_folio(struct folio *folio)
-{
-	struct page *page = folio_page(folio, 0);
-	kvm_pfn_t pfn = page_to_pfn(page);
-	int order = folio_order(folio);
-
-	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
-}
-#endif
-
-static const struct address_space_operations kvm_gmem_aops = {
-	.dirty_folio = noop_dirty_folio,
-	.migrate_folio	= kvm_gmem_migrate_folio,
-	.error_remove_folio = kvm_gmem_error_folio,
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
-	.free_folio = kvm_gmem_free_folio,
-#endif
-};
-
-static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
-			    struct kstat *stat, u32 request_mask,
-			    unsigned int query_flags)
-{
-	struct inode *inode = path->dentry->d_inode;
-
-	generic_fillattr(idmap, request_mask, inode, stat);
-	return 0;
-}
-
-static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-			    struct iattr *attr)
-{
-	return -EINVAL;
-}
-static const struct inode_operations kvm_gmem_iops = {
-	.getattr	= kvm_gmem_getattr,
-	.setattr	= kvm_gmem_setattr,
+static const struct guest_memfd_operations kvm_gmem_ops = {
+	.invalidate_begin = kvm_gmem_invalidate_begin,
+	.invalidate_end = kvm_gmem_invalidate_end,
+	.prepare_inaccessible = kvm_gmem_prepare_inaccessible,
+	.release = kvm_gmem_release,
 };
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
@@ -410,28 +199,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = guest_memfd_alloc(anon_name, &kvm_gmem_ops, size,
+				 GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
 	inode = file->f_inode;
 	WARN_ON(file->f_mapping != inode->i_mapping);
 
-	inode->i_private = (void *)(unsigned long)flags;
-	inode->i_op = &kvm_gmem_iops;
-	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mode |= S_IFREG;
-	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_inaccessible(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
@@ -462,6 +239,14 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
+static inline struct kvm_gmem *file_to_kvm_gmem(struct file *file)
+{
+	if (!is_guest_memfd(file, &kvm_gmem_ops))
+		return NULL;
+
+	return inode_to_kvm_gmem(file_inode(file));
+}
+
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset)
 {
@@ -478,11 +263,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EBADF;
 
-	if (file->f_op != &kvm_gmem_fops)
-		goto err;
-
-	gmem = file->private_data;
-	if (gmem->kvm != kvm)
+	gmem = file_to_kvm_gmem(file);
+	if (!gmem || gmem->kvm != kvm)
 		goto err;
 
 	inode = file_inode(file);
@@ -539,7 +321,9 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	if (!file)
 		return;
 
-	gmem = file->private_data;
+	gmem = file_to_kvm_gmem(file);
+	if (WARN_ON_ONCE(!gmem))
+		return;
 
 	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
@@ -553,7 +337,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 /* Returns a locked folio on success.  */
 static struct folio *
 __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
+		   gfn_t gfn, kvm_pfn_t *pfn, bool accessible,
 		   int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
@@ -565,19 +349,27 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return ERR_PTR(-EFAULT);
 	}
 
-	gmem = file->private_data;
+	gmem = file_to_kvm_gmem(file);
+	if (WARN_ON_ONCE(!gmem))
+		return ERR_PTR(-EFAULT);
+
 	if (xa_load(&gmem->bindings, index) != slot) {
 		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
 		return ERR_PTR(-EIO);
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	if (accessible)
+		grab_flags = GUEST_MEMFD_GRAB_ACCESSIBLE;
+	else
+		grab_flags = GUEST_MEMFD_GRAB_INACCESSIBLE;
+
+	folio = guest_memfd_grab_folio(file, index, grab_flags);
 	if (IS_ERR(folio))
 		return folio;
 
 	if (folio_test_hwpoison(folio)) {
 		folio_unlock(folio);
-		folio_put(folio);
+		guest_memfd_put_folio(folio, accessible ? 1 : 0);
 		return ERR_PTR(-EHWPOISON);
 	}
 
@@ -585,7 +377,6 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -594,24 +385,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, false, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
-
 	folio_unlock(folio);
 	if (r < 0)
-		folio_put(folio);
+		guest_memfd_put_folio(folio, 0);
+	else
+		guest_memfd_unsafe_folio(folio);
 
 out:
 	fput(file);
@@ -648,7 +437,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	for (i = 0; i < npages; i += (1 << max_order)) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -656,19 +444,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, true, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret = -EEXIST;
-			break;
-		}
-
 		folio_unlock(folio);
 		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
 			(npages - i) < (1 << max_order));
@@ -684,11 +465,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
-		if (!ret)
-			kvm_gmem_mark_prepared(folio);
 
 put_folio_and_exit:
-		folio_put(folio);
+		guest_memfd_put_folio(folio, 1);
 		if (ret)
 			break;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb2b78e92910f..f94a36ca17fe2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6514,8 +6514,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
-
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01f..6336a4fdcf505 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -36,17 +36,11 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
-void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
-{
-
-}
-
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)

-- 
2.34.1


