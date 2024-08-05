Return-Path: <kvm+bounces-23252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E01729481BC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7975C28F591
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297F2166F34;
	Mon,  5 Aug 2024 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SfVU1oaR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5198165EE4;
	Mon,  5 Aug 2024 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882941; cv=none; b=n82aMJMNhfEB06OENLXOmS5U/gX05amgAKblOVdJAFGTPx+aPzSEwwS0Grhll3O6HjGxTDjirvIyBipUWtRoiwGA4Oaa1TU9EaD7jecK/jY+9jPbg2TQeeKXsBU5og39YBfw6QITDE/6JTHCjQVtXm+10oAfnHQctDX5nhSuHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882941; c=relaxed/simple;
	bh=01BOLZwIXds2oOBMgTfWEZnFHQTLE09ROIsOvTtBlWw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=A98Hh5RniRIwwdEoqeT5dM8DVlqBKHlc2thaYu4Y8yWm5E/C9oO/+kCwR3JUJvROKb4VorPWHGYVmEgV8GQtR/SYnW5izrkKa9YYvILctqQJOq1ZR5WVtqJc+dp4vq61AydRTzAmn2sFt38SInvdd12KNGMnAZPm8U3qT++hyno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=SfVU1oaR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475BbnqL019900;
	Mon, 5 Aug 2024 18:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	11QWH8pHvBW8f1MWbaRj+DTkAzgqxQMHSVhEzac2GrE=; b=SfVU1oaRmqi2I1Hu
	Q2HdtSpmE6G788E+QGlxDtec7Xe+PXwS5UvNdhfyA6XHpoS6iudNCgF4UdHaNQfD
	k86+iUpBg3MURy1xgl8w0gfzrddXk7onBEG+yoq7iAt9ZooTZtxx1u4d5phfFV9V
	moVuWOEPolpLnPEELPY/D0tevl2p9MgG6m1lNEtO4JE9ZbwlOJcpgmAUznX8Kjlk
	6l4bDM+Sx+lIWJobOCdCSKbp40xV44E/X5LRaBNOXguzsUyHKoZDhICGcuRjPi4v
	AOeL6w9jYOzk3dkvFNMrmYVKIvG+mJqfYAA9sAxQgN8XUBFQc8De7K9QKnGXilQL
	bKjU4w==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40scs2vvgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 18:35:26 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 475IZEoH024674
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Aug 2024 18:35:14 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 5 Aug 2024 11:35:13 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Mon, 5 Aug 2024 11:34:47 -0700
Subject: [PATCH RFC 1/4] mm: Introduce guest_memfd
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240805-guest-memfd-lib-v1-1-e5a29a4ff5d7@quicinc.com>
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
X-Proofpoint-ORIG-GUID: ZGxuxUGqCP_Vrg127mms6-uSzdAQx_Ti
X-Proofpoint-GUID: ZGxuxUGqCP_Vrg127mms6-uSzdAQx_Ti
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-05_07,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 mlxlogscore=902 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408050133

In preparation for adding more features to KVM's guest_memfd, refactor
and introduce a library which abstracts some of the core-mm decisions
about managing folios associated with the file. The goal of the refactor
serves two purposes:

Provide an easier way to reason about memory in guest_memfd. With KVM
supporting multiple confidentiality models (TDX, SEV-SNP, pKVM, ARM
CCA), and coming support for allowing kernel and userspace to access
this memory, it seems necessary to create a stronger abstraction between
core-mm concerns and hypervisor concerns.

Provide a common implementation for other hypervisors (Gunyah) to use.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 include/linux/guest_memfd.h |  44 +++++++
 mm/Kconfig                  |   3 +
 mm/Makefile                 |   1 +
 mm/guest_memfd.c            | 285 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 333 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
new file mode 100644
index 000000000000..be56d9d53067
--- /dev/null
+++ b/include/linux/guest_memfd.h
@@ -0,0 +1,44 @@
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
+ * @prepare: called before a folio is mapped into the guest address space.
+ *           Optional.
+ * @release: Called when releasing the guest_memfd file. Required.
+ */
+struct guest_memfd_operations {
+	int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
+	void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
+	int (*prepare)(struct inode *inode, pgoff_t offset, struct folio *folio);
+	int (*release)(struct inode *inode);
+};
+
+/**
+ * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
+ *                             If trusted hyp will do it, can ommit this flag
+ * @GUEST_MEMFD_PREPARE: Call the ->prepare() op, if present.
+ */
+enum {
+	GUEST_MEMFD_GRAB_UPTODATE	= BIT(0),
+	GUEST_MEMFD_PREPARE		= BIT(1),
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
index b72e7d040f78..333f46525695 100644
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
index d2915f8c9dc0..e15a95ebeac5 100644
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
index 000000000000..580138b0f9d4
--- /dev/null
+++ b/mm/guest_memfd.c
@@ -0,0 +1,285 @@
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
+struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
+{
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
+	/*
+	 * Use the up-to-date flag to track whether or not the memory has been
+	 * zeroed before being handed off to the guest.  There is no backing
+	 * storage for the memory, so the folio will remain up-to-date until
+	 * it's removed.
+	 */
+	if ((flags & GUEST_MEMFD_GRAB_UPTODATE) &&
+	    !folio_test_uptodate(folio)) {
+		unsigned long nr_pages = folio_nr_pages(folio);
+		unsigned long i;
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+
+		folio_mark_uptodate(folio);
+	}
+
+	if (flags & GUEST_MEMFD_PREPARE && ops->prepare) {
+		r = ops->prepare(inode, index, folio);
+		if (r < 0)
+			goto out_err;
+	}
+
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
+		folio = guest_memfd_grab_folio(file, index,
+					       GUEST_MEMFD_GRAB_UPTODATE |
+						       GUEST_MEMFD_PREPARE);
+		if (!folio) {
+			r = -ENOMEM;
+			break;
+		}
+
+		index = folio_next_index(folio);
+
+		folio_unlock(folio);
+		folio_put(folio);
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
+static struct file_operations gmem_fops = {
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
+	if (flags)
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


