Return-Path: <kvm+bounces-25414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CC09652D6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C731D1C2305F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4111BBBCA;
	Thu, 29 Aug 2024 22:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RFheopaU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51581BAEC8;
	Thu, 29 Aug 2024 22:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970277; cv=none; b=fYIDIgZmlrHP/I6M8PCCi8rRlSlAQ3ZebhRj8l20lf1RtFObPkbdoq9wuUtu5Tr5JsRd+EiF913s+k1KgnrYP7BGKKNi/JZk8trWZkP9Bg9mIb+jJ88yEYld4fqlNcN8XxPMPEhgwUl3nACjzJBaVLiJ9d5q9EdHHSVabZUrYLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970277; c=relaxed/simple;
	bh=KG2HDrlYw+N0DHV6w1tjAiaqTpiT5E6XMVEmQFXY93w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=aRTUA2R9QNEjXa30Hz6RKvQmG6iOJHGlPD78a9pZQDCMaACHoljpAnyNPsA8rBF4dC/Km6RhzXXlnjZrcyhifsx2qlApoTuB5TRXLd16yoy6/uESy89JCdQpHzIBJV7EBqZWnLpsbNTjON2HiO9YSm+bm3OhFWWH2DYI67T8RvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RFheopaU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TI0TBq002700;
	Thu, 29 Aug 2024 22:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FfcPaM3y1FPh43G+0wXG9L9JbGBg6+bMzmMVEQvR3PE=; b=RFheopaUjoo7cfkK
	utq3XtjAAmfjSaspNzfuPgjlwV/DtByeaMO/RPlJlLR2dSJTdQfdg0r0/U+ReO+a
	6zLfyveoP1INuJyDrof1UkQ305tlfJF6UR5uhVG8by8BjfNgVlV0rXtc4NJBCtXO
	yzDfZiShw+wxM1+MS9Bwu1vx1ULQ/eF7uCPUbnvkZwBqBRTHy4/Hc65Jf4Vi303W
	FOM66K8SiisEY7S1O+UorEGmuD/WqjsdHJ9nmGNvinVMYgvUHIvD1n43mHhgdDkQ
	+cUid4PRKcuRvGQfrVbMJOb05ylX8gUwXtySwaOmUbwX9mcgJxk+gLJ85/bseHwt
	Hp/T3w==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419putxv3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:12 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMOBkZ001848
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:11 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:11 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Thu, 29 Aug 2024 15:24:09 -0700
Subject: [PATCH RFC v2 1/5] mm: Introduce guest_memfd
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240829-guest-memfd-lib-v2-1-b9afc1ff3656@quicinc.com>
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
X-Proofpoint-ORIG-GUID: sKUH7ABBLbjRHp9Mvo4MD33HGWJw5PK5
X-Proofpoint-GUID: sKUH7ABBLbjRHp9Mvo4MD33HGWJw5PK5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

In preparation for adding more features to KVM's guest_memfd, refactor
and introduce a library which abstracts some of the core-mm decisions
about managing folios associated with the file. The goal of the refactor
serves two purposes:

Provide an easier way to reason about memory in guest_memfd. With KVM
supporting multiple confidentiality models (TDX, SEV-SNP, pKVM, ARM
CCA), and coming support for allowing kernel and userspace to access
this memory, it seems necessary to create a stronger abstraction between
core-mm concerns and hypervisor concerns.

Provide a common implementation for the various hypervisors (SEV-SNP,
Gunyah, pKVM) to use.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 include/linux/guest_memfd.h |  38 +++++
 mm/Kconfig                  |   3 +
 mm/Makefile                 |   1 +
 mm/guest_memfd.c            | 332 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 374 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
new file mode 100644
index 0000000000000..8785b7d599051
--- /dev/null
+++ b/include/linux/guest_memfd.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _LINUX_GUEST_MEMFD_H
+#define _LINUX_GUEST_MEMFD_H
+
+#include <linux/fs.h>
+
+/**
+ * struct guest_memfd_operations - ops provided by owner to manage folios
+ * @invalidate_begin: called when folios should be unmapped from guest.
+ *                    May fail if folios couldn't be unmapped from guest.
+ *                    Required.
+ * @invalidate_end: called after invalidate_begin returns success. Optional.
+ * @prepare_inaccessible: called when a folio transitions to inaccessible state
+ *                        Optional.
+ * @release: Called when releasing the guest_memfd file. Required.
+ */
+struct guest_memfd_operations {
+	int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
+	void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
+	int (*prepare_inaccessible)(struct inode *inode, struct folio *folio);
+	int (*release)(struct inode *inode);
+};
+
+enum guest_memfd_create_flags {
+	GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE = (1UL << 0),
+};
+
+struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags);
+struct file *guest_memfd_alloc(const char *name,
+			       const struct guest_memfd_operations *ops,
+			       loff_t size, unsigned long flags);
+bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops);
+
+#endif
diff --git a/mm/Kconfig b/mm/Kconfig
index b72e7d040f789..333f465256957 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1168,6 +1168,9 @@ config SECRETMEM
 	  memory areas visible only in the context of the owning process and
 	  not mapped to other processes and other kernel page tables.
 
+config GUEST_MEMFD
+	tristate
+
 config ANON_VMA_NAME
 	bool "Anonymous VMA name support"
 	depends on PROC_FS && ADVISE_SYSCALLS && MMU
diff --git a/mm/Makefile b/mm/Makefile
index d2915f8c9dc01..e15a95ebeac5d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -122,6 +122,7 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_SECRETMEM) += secretmem.o
+obj-$(CONFIG_GUEST_MEMFD) += guest_memfd.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
new file mode 100644
index 0000000000000..c6cd01e6064a7
--- /dev/null
+++ b/mm/guest_memfd.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/falloc.h>
+#include <linux/guest_memfd.h>
+#include <linux/pagemap.h>
+
+/**
+ * guest_memfd_grab_folio() -- grabs a folio from the guest memfd
+ * @file: guest memfd file to grab from
+ *        Caller must ensure file is a guest_memfd file
+ * @index: the page index in the file
+ * @flags: bitwise OR of guest_memfd_grab_flags
+ *
+ * If a folio is returned, the folio was successfully initialized or converted
+ * to (in)accessible based on the GUEST_MEMFD_* flags. The folio is guaranteed
+ * to be (in)accessible until the folio lock is relinquished. After folio
+ * lock relinquished, ->prepare_inaccessible and ->prepare_accessible ops are
+ * responsible for preventing transitioning between the states as
+ * required.
+ *
+ * This function may return error even if the folio exists, in the event
+ * the folio couldn't be made (in)accessible as requested in the flags.
+ *
+ * This function may sleep.
+ *
+ * The caller must call either guest_memfd_put_folio() or
+ * guest_memfd_unsafe_folio().
+ *
+ * Returns:
+ * A pointer to the grabbed folio on success, otherwise an error code.
+ */
+struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
+{
+	unsigned long gmem_flags = (unsigned long)file->private_data;
+	struct inode *inode = file_inode(file);
+	struct guest_memfd_operations *ops = inode->i_private;
+	struct folio *folio;
+	int r;
+
+	/* TODO: Support huge pages. */
+	folio = filemap_grab_folio(inode->i_mapping, index);
+	if (IS_ERR(folio))
+		return folio;
+
+	if (folio_test_uptodate(folio))
+		return folio;
+
+	folio_wait_stable(folio);
+
+	/*
+	 * Use the up-to-date flag to track whether or not the memory has been
+	 * zeroed before being handed off to the guest.  There is no backing
+	 * storage for the memory, so the folio will remain up-to-date until
+	 * it's removed.
+	 */
+	if (gmem_flags & GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE) {
+		unsigned long nr_pages = folio_nr_pages(folio);
+		unsigned long i;
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+
+	}
+
+	if (ops->prepare_inaccessible) {
+		r = ops->prepare_inaccessible(inode, folio);
+		if (r < 0)
+			goto out_err;
+	}
+
+	folio_mark_uptodate(folio);
+	/*
+	 * Ignore accessed, referenced, and dirty flags.  The memory is
+	 * unevictable and there is no storage to write back to.
+	 */
+	return folio;
+out_err:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ERR_PTR(r);
+}
+EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
+
+static long gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	const struct guest_memfd_operations *ops = inode->i_private;
+	pgoff_t start = offset >> PAGE_SHIFT;
+	unsigned long nr = len >> PAGE_SHIFT;
+	long ret;
+
+	/*
+	 * Bindings must be stable across invalidation to ensure the start+end
+	 * are balanced.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+
+	ret = ops->invalidate_begin(inode, start, nr);
+	if (ret)
+		goto out;
+
+	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+
+	if (ops->invalidate_end)
+		ops->invalidate_end(inode, start, nr);
+
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return 0;
+}
+
+static long gmem_allocate(struct file *file, loff_t offset, loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t start, index, end;
+	int r;
+
+	/* Dedicated guest is immutable by default. */
+	if (offset + len > i_size_read(inode))
+		return -EINVAL;
+
+	filemap_invalidate_lock_shared(mapping);
+
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
+
+	r = 0;
+	for (index = start; index < end;) {
+		struct folio *folio;
+
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		folio = guest_memfd_grab_folio(file, index, 0);
+		if (!folio) {
+			r = -ENOMEM;
+			break;
+		}
+
+		index = folio_next_index(folio);
+
+		folio_unlock(folio);
+		guest_memfd_put_folio(folio, 0);
+
+		/* 64-bit only, wrapping the index should be impossible. */
+		if (WARN_ON_ONCE(!index))
+			break;
+
+		cond_resched();
+	}
+
+	filemap_invalidate_unlock_shared(mapping);
+
+	return r;
+}
+
+static long gmem_fallocate(struct file *file, int mode, loff_t offset,
+			   loff_t len)
+{
+	int ret;
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
+	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+		return -EINVAL;
+
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		ret = gmem_punch_hole(file, offset, len);
+	else
+		ret = gmem_allocate(file, offset, len);
+
+	if (!ret)
+		file_modified(file);
+	return ret;
+}
+
+static int gmem_release(struct inode *inode, struct file *file)
+{
+	struct guest_memfd_operations *ops = inode->i_private;
+
+	return ops->release(inode);
+}
+
+static const struct file_operations gmem_fops = {
+	.open = generic_file_open,
+	.llseek = generic_file_llseek,
+	.release = gmem_release,
+	.fallocate = gmem_fallocate,
+	.owner = THIS_MODULE,
+};
+
+static int gmem_migrate_folio(struct address_space *mapping, struct folio *dst,
+			      struct folio *src, enum migrate_mode mode)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+
+static int gmem_error_folio(struct address_space *mapping, struct folio *folio)
+{
+	struct inode *inode = mapping->host;
+	struct guest_memfd_operations *ops = inode->i_private;
+	off_t offset = folio->index;
+	size_t nr = folio_nr_pages(folio);
+	int ret;
+
+	filemap_invalidate_lock_shared(mapping);
+
+	ret = ops->invalidate_begin(inode, offset, nr);
+	if (!ret && ops->invalidate_end)
+		ops->invalidate_end(inode, offset, nr);
+
+	filemap_invalidate_unlock_shared(mapping);
+
+	return ret;
+}
+
+static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
+{
+	struct inode *inode = folio_inode(folio);
+	struct guest_memfd_operations *ops = inode->i_private;
+	off_t offset = folio->index;
+	size_t nr = folio_nr_pages(folio);
+	int ret;
+
+	ret = ops->invalidate_begin(inode, offset, nr);
+	if (ret)
+		return false;
+	if (ops->invalidate_end)
+		ops->invalidate_end(inode, offset, nr);
+
+	return true;
+}
+
+static const struct address_space_operations gmem_aops = {
+	.dirty_folio = noop_dirty_folio,
+	.migrate_folio = gmem_migrate_folio,
+	.error_remove_folio = gmem_error_folio,
+	.release_folio = gmem_release_folio,
+};
+
+static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *ops)
+{
+	return ops->invalidate_begin && ops->release;
+}
+
+static inline unsigned long guest_memfd_valid_flags(void)
+{
+	return GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE;
+}
+
+/**
+ * guest_memfd_alloc() - Create a guest_memfd file
+ * @name: the name of the new file
+ * @ops: operations table for the guest_memfd file
+ * @size: the size of the file
+ * @flags: flags controlling behavior of the file
+ *
+ * Creates a new guest_memfd file.
+ */
+struct file *guest_memfd_alloc(const char *name,
+			       const struct guest_memfd_operations *ops,
+			       loff_t size, unsigned long flags)
+{
+	struct inode *inode;
+	struct file *file;
+
+	if (size <= 0 || !PAGE_ALIGNED(size))
+		return ERR_PTR(-EINVAL);
+
+	if (!guest_memfd_check_ops(ops))
+		return ERR_PTR(-EINVAL);
+
+	if (flags & ~guest_memfd_valid_flags())
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Use the so called "secure" variant, which creates a unique inode
+	 * instead of reusing a single inode.  Each guest_memfd instance needs
+	 * its own inode to track the size, flags, etc.
+	 */
+	file = anon_inode_create_getfile(name, &gmem_fops, (void *)flags,
+					 O_RDWR, NULL);
+	if (IS_ERR(file))
+		return file;
+
+	file->f_flags |= O_LARGEFILE;
+
+	inode = file_inode(file);
+	WARN_ON(file->f_mapping != inode->i_mapping);
+
+	inode->i_private = (void *)ops; /* discards const qualifier */
+	inode->i_mapping->a_ops = &gmem_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = size;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_inaccessible(inode->i_mapping);
+	/* Unmovable mappings are supposed to be marked unevictable as well. */
+	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	return file;
+}
+EXPORT_SYMBOL_GPL(guest_memfd_alloc);
+
+/**
+ * is_guest_memfd() - Returns true if the struct file is a guest_memfd
+ * @file: the file to check
+ * @ops: the expected operations table
+ */
+bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops)
+{
+	if (file->f_op != &gmem_fops)
+		return false;
+
+	struct inode *inode = file_inode(file);
+	struct guest_memfd_operations *gops = inode->i_private;
+
+	return ops == gops;
+}
+EXPORT_SYMBOL_GPL(is_guest_memfd);

-- 
2.34.1


