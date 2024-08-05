Return-Path: <kvm+bounces-23251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 153569481B7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60628B22A43
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52647165F18;
	Mon,  5 Aug 2024 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nBmip99i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC06A15FA9E;
	Mon,  5 Aug 2024 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882930; cv=none; b=YOc7+uDjv1MHUPYd13q0iF7ztKyFNl+LZ0LjLMmu4w43efZ8ZQfsr6X+qnLnK3eCox8Mz6iHIZEjA5ZD59JwntB5oAmy0cXChw6o0xxq3Nx+1v+u6287hLdmJWtvBfAVrBDtX5tNMMsb35mfePFtRzhUYfbfAn9FEvpN6jdeUfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882930; c=relaxed/simple;
	bh=xS1NHiO6Ad1ehcR/3Bs9Qk0gDA5ntDYTwYFWCrruVmg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=cmY1PPHQ1Z9au9r345zJt1eTiTrIv1fmXMaLu73OsZUmEWAkDNU4Czco3V7JpOT/MXQjx25pyMFgcrTvR71Kr79XZmSvDHMykMKbAvNw43I56BZIsOJiqnpJqxHa1GVrb09o/csQoMJYSpMm4DHSgKLFo11a0DQVC7Ma+hxupHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nBmip99i; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475CS0ZK012626;
	Mon, 5 Aug 2024 18:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NNwc/yTMOhkA2KsrscwiCYYgyWrv8AnymFPd4NDgii4=; b=nBmip99ie+VKFEV6
	5BwX9G+Nq9+yRv8Zq/fE+4C2HG6UEfMkYzNf8NiHeaozuwzZ15UEDwhe8R6c339d
	inq4fkafeIcjMrRDzSxv0NmrGPnLxSeqp6Pz8ijsPgMyfr1l4P/NQ9Y2fmC5VEAx
	Bm7noiyPlryzZzAjgrRZmP3fnriwS/hqGxpupiitP45l3iM6PGcW53hoP4xkFwcM
	8o107oX6jhUfwhsClNX0o3UkIBko+h+UaAONRnJkmTuyhWkCq+InSX6m3xshCJ/N
	PpvfGvdZh5mvem95KOXCvWA6feBRKTv3j9T3fPBasnWPCN2wEboXSLscLE67t0Lz
	H85zUw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40sbj6n0k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 18:35:15 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 475IZEHn024680
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Aug 2024 18:35:14 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 5 Aug 2024 11:35:14 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Mon, 5 Aug 2024 11:34:48 -0700
Subject: [PATCH RFC 2/4] kvm: Convert to use mm/guest_memfd
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240805-guest-memfd-lib-v1-2-e5a29a4ff5d7@quicinc.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
In-Reply-To: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>
CC: <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, Elliot Berman <quic_eberman@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: MTWcnK-X0sCx-AQ_MiaF48nCefXYbKNb
X-Proofpoint-GUID: MTWcnK-X0sCx-AQ_MiaF48nCefXYbKNb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-05_07,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408050132

Use the recently created mm/guest_memfd implementation. No functional
change intended.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 virt/kvm/Kconfig       |   1 +
 virt/kvm/guest_memfd.c | 299 ++++++++-----------------------------------------
 virt/kvm/kvm_main.c    |   2 -
 virt/kvm/kvm_mm.h      |   6 -
 4 files changed, 49 insertions(+), 259 deletions(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b14e14cdbfb9..1147e004fcbd 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -106,6 +106,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
 
 config KVM_PRIVATE_MEM
        select XARRAY_MULTI
+       select GUEST_MEMFD
        bool
 
 config KVM_GENERIC_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c509c351261..2fe3ff9e5793 100644
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
 
@@ -13,9 +11,16 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
-static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+static inline struct kvm_gmem *inode_to_kvm_gmem(struct inode *inode)
 {
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+
+	return list_first_entry_or_null(gmem_list, struct kvm_gmem, entry);
+}
+
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+{
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	struct kvm_gmem *gmem;
 
@@ -45,57 +50,14 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		}
 	}
 
-#endif
 	return 0;
 }
+#endif
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
-{
-	struct folio *folio;
-
-	/* TODO: Support huge pages. */
-	folio = filemap_grab_folio(inode->i_mapping, index);
-	if (IS_ERR(folio))
-		return folio;
-
-	/*
-	 * Use the up-to-date flag to track whether or not the memory has been
-	 * zeroed before being handed off to the guest.  There is no backing
-	 * storage for the memory, so the folio will remain up-to-date until
-	 * it's removed.
-	 *
-	 * TODO: Skip clearing pages when trusted firmware will do it when
-	 * assigning memory to the guest.
-	 */
-	if (!folio_test_uptodate(folio)) {
-		unsigned long nr_pages = folio_nr_pages(folio);
-		unsigned long i;
-
-		for (i = 0; i < nr_pages; i++)
-			clear_highpage(folio_page(folio, i));
-
-		folio_mark_uptodate(folio);
-	}
-
-	if (prepare) {
-		int r =	kvm_gmem_prepare_folio(inode, index, folio);
-		if (r < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			return ERR_PTR(r);
-		}
-	}
-
-	/*
-	 * Ignore accessed, referenced, and dirty flags.  The memory is
-	 * unevictable and there is no storage to write back to.
-	 */
-	return folio;
-}
-
-static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+static int kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
+	struct kvm_gmem *gmem = inode_to_kvm_gmem(inode);
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
@@ -126,11 +88,14 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
+
+	return 0;
 }
 
-static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
+static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
 {
+	struct kvm_gmem *gmem = inode_to_kvm_gmem(inode);
 	struct kvm *kvm = gmem->kvm;
 
 	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
@@ -140,106 +105,9 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	}
 }
 
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
-{
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
-	struct kvm_gmem *gmem;
-
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
-
-	return 0;
-}
-
-static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
+static int kvm_gmem_release(struct inode *inode)
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
-		folio = kvm_gmem_get_folio(inode, index, true);
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
-
-		cond_resched();
-	}
-
-	filemap_invalidate_unlock_shared(mapping);
-
-	return r;
-}
-
-static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
-			       loff_t len)
-{
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
-
-	if (!ret)
-		file_modified(file);
-	return ret;
-}
-
-static int kvm_gmem_release(struct inode *inode, struct file *file)
-{
-	struct kvm_gmem *gmem = file->private_data;
+	struct kvm_gmem *gmem = inode_to_kvm_gmem(inode);
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
@@ -265,8 +133,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(inode, 0, -1ul);
+	kvm_gmem_invalidate_end(inode, 0, -1ul);
 
 	list_del(&gmem->entry);
 
@@ -293,56 +161,6 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
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
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
 static void kvm_gmem_free_folio(struct folio *folio)
 {
@@ -354,34 +172,25 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
-static const struct address_space_operations kvm_gmem_aops = {
-	.dirty_folio = noop_dirty_folio,
-	.migrate_folio	= kvm_gmem_migrate_folio,
-	.error_remove_folio = kvm_gmem_error_folio,
+static const struct guest_memfd_operations kvm_gmem_ops = {
+	.invalidate_begin = kvm_gmem_invalidate_begin,
+	.invalidate_end = kvm_gmem_invalidate_end,
+#ifdef CONFIG_HAVE_KVM_GMEM_PREAPRE
+	.prepare = kvm_gmem_prepare_folio,
+#endif
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
 #endif
+	.release = kvm_gmem_release,
 };
 
-static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
-			    struct kstat *stat, u32 request_mask,
-			    unsigned int query_flags)
+static inline struct kvm_gmem *file_to_kvm_gmem(struct file *file)
 {
-	struct inode *inode = path->dentry->d_inode;
-
-	generic_fillattr(idmap, request_mask, inode, stat);
-	return 0;
-}
+	if (!is_guest_memfd(file, &kvm_gmem_ops))
+		return NULL;
 
-static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-			    struct iattr *attr)
-{
-	return -EINVAL;
+	return inode_to_kvm_gmem(file_inode(file));
 }
-static const struct inode_operations kvm_gmem_iops = {
-	.getattr	= kvm_gmem_getattr,
-	.setattr	= kvm_gmem_setattr,
-};
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
@@ -401,31 +210,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = guest_memfd_alloc(anon_name, &kvm_gmem_ops, size, 0);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
-
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
+	inode = file_inode(file);
 	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
 
 	fd_install(fd, file);
@@ -469,11 +263,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -530,7 +321,9 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	if (!file)
 		return;
 
-	gmem = file->private_data;
+	gmem = file_to_kvm_gmem(file);
+	if (!gmem)
+		return;
 
 	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
@@ -548,20 +341,24 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 	struct page *page;
-	int r;
+	int r, flags = GUEST_MEMFD_GRAB_UPTODATE;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
 		return -EFAULT;
 	}
 
-	gmem = file->private_data;
-	if (xa_load(&gmem->bindings, index) != slot) {
-		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
+	gmem = file_to_kvm_gmem(file);
+	if (WARN_ON_ONCE(!gmem))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot))
 		return -EIO;
-	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
+	if (prepare)
+		flags |= GUEST_MEMFD_PREPARE;
+
+	folio = guest_memfd_grab_folio(file, index, flags);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..cad798f4e135 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6516,8 +6516,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
-
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..6336a4fdcf50 100644
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


