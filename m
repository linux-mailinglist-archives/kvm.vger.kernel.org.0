Return-Path: <kvm+bounces-25415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 153B09652D7
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1AB28516F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83AB1BC06D;
	Thu, 29 Aug 2024 22:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="MmO5Yukh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418E31BAEDF;
	Thu, 29 Aug 2024 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970278; cv=none; b=qChgzu1EJa+nqI/ZfrJ2l5//iYInDE9WaXQtbX+DT+wnViZlU55biieVHibOadIZX28fratGd/y7wchJbcTIRGweHDKzP9ghaSlHzVnQqPRhIlMw9I7iCY2OSvKRqvMqLC2mku3GvvnQaNxA+uLQobU++j0m9x8aKVqsXM181cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970278; c=relaxed/simple;
	bh=TYMkcwa+JAFM9P6Pzs9NIRDeotK7ZsGLHcDNRCKjV9w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=IWfLXc2O+E5ZkWq7VlX2RwWpU0WYL/qyJuhqpihCqLKQBomT3RPcmBkwJUJ/pcrpKN+rN0Ll6EjAwXBimLT93cXBHOgyrNHUmKjSYZaGjY8X9lblubsGGBHrRQWe6w0go2BKD8SDsqspgTX5yLpI+XJn6+LalC0IaguKZXWCT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=MmO5Yukh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TIHdeO029683;
	Thu, 29 Aug 2024 22:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SkG5yOfFgH34bJKKNVoh6g50Xq92Yfh9L8cTwSX8ZQk=; b=MmO5Yukhbl/rxy03
	1x/2MFYRsMWWqxTmarMOkPCZZVRUpCWqec6si5lysDeRckbrZZdLPU2HTRjBoWgV
	x3D8pzRlb5gC3OCBTgBsdqC3Wg2eSMR30F4H2haQOwIAf+aibCqWdAkM9hO2RuEC
	l0bBgYucWJ5FoOq0r6DBlMEiDaM+F7NzDi2TAeHR7+Xt7zwLbhSS3/4KNM3eXj1F
	0+vOT0+t4SljElyJW13EPXDxb9uoITkgi51FkV4bhr/qtjxBW1XzZ60LkaQ5r5ku
	T39n5SSZLbqviIEbiHMDpyFQjh5xkimGMo5O0JMkGVkLKZq6CiS3wznuNzB8CzkO
	h/KDMw==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41ax4mggav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:12 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMOCxg014627
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:12 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:11 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Thu, 29 Aug 2024 15:24:10 -0700
Subject: [PATCH RFC v2 2/5] mm: guest_memfd: Allow folios to be accessible
 to host
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240829-guest-memfd-lib-v2-2-b9afc1ff3656@quicinc.com>
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
X-Proofpoint-GUID: B3EyAuBzlbGw5UEinjhgqyFXCdQXkbzb
X-Proofpoint-ORIG-GUID: B3EyAuBzlbGw5UEinjhgqyFXCdQXkbzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=884
 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

Memory given to a confidential VM sometimes needs to be accessible by
Linux. Before the VM starts, Linux needs to load some payload into
the guest memory. While the VM is running, the guest may make some of
the memory accessible to the host, e.g. to share virtqueue buffers. We
choose less-used terminology here to avoid confusion with other terms
(i.e. private). Memory is considered "accessible" when Linux (the host)
can read/write to that memory. It is considered "inaccessible" when
reads/writes aren't allowed by the hypervisor.

Careful tracking of when the memory is supposed to be "inaccessible" and
"accessible" is needed because hypervisors will fault Linux if we
incorrectly access memory which shouldn't be accessed. On arm64 systems,
this is a translation fault. On x86 systems, this could be a machine
check.

After discussion in [1], we are using 3 counters to track the state of a
folio: the general folio_ref_count, a "safe" ref count, and an
"accessible" counter.

Transition between accessible and inaccessible is allowed only when:
0. The folio is locked
1. The "accessible" counter is at 0.
2. The "safe" ref count equals the folio_ref_count.
3. The hypervisor allows it.

The accessible counter can be used by Linux to guarantee the page stays
accessible, without elevating the general refcount. When the accessible
counter decrements to 0, we attempt to make the page inaccessible. When
the accessible counters increments to 1, we attempt to make the page
accessible.

We expect the folio_ref_count to be nearly zero. The "nearly" amount is
determined by the "safe" ref count value. The safe ref count isn't a
signal whether the folio is accessible or not, it is only used to
compare against the folio_ref_count.

The final condition to transition between (in)accessible is whether the
->prepare_accessible or ->prepare_inaccessible guest_memfd_operation
passes. In arm64 pKVM/Gunyah terms, the fallible "prepare_accessible"
check is needed to ensure that the folio is unlocked by the guest and
thus accessible to the host.

When grabbing a folio, the client can either request for it to be
accessible or inaccessible. If the folio already exists, we attempt to
transition it to the state, if not already in that state. This will
allow KVM or userspace to access guest_memfd *before* it is made
inaccessible because KVM and userspace will use
GUEST_MEMFD_GRAB_ACCESSIBLE.

[1]: https://lore.kernel.org/all/a7c5bfc0-1648-4ae1-ba08-e706596e014b@redhat.com/

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 include/linux/guest_memfd.h |  10 ++
 mm/guest_memfd.c            | 238 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 236 insertions(+), 12 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 8785b7d599051..66e5d3ab42613 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -22,17 +22,27 @@ struct guest_memfd_operations {
 	int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
 	void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
 	int (*prepare_inaccessible)(struct inode *inode, struct folio *folio);
+	int (*prepare_accessible)(struct inode *inode, struct folio *folio);
 	int (*release)(struct inode *inode);
 };
 
+enum guest_memfd_grab_flags {
+	GUEST_MEMFD_GRAB_INACCESSIBLE	= (0UL << 0),
+	GUEST_MEMFD_GRAB_ACCESSIBLE	= (1UL << 0),
+};
+
 enum guest_memfd_create_flags {
 	GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE = (1UL << 0),
 };
 
 struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags);
+void guest_memfd_put_folio(struct folio *folio, unsigned int accessible_refs);
+void guest_memfd_unsafe_folio(struct folio *folio);
 struct file *guest_memfd_alloc(const char *name,
 			       const struct guest_memfd_operations *ops,
 			       loff_t size, unsigned long flags);
 bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops);
+int guest_memfd_make_accessible(struct folio *folio);
+int guest_memfd_make_inaccessible(struct folio *folio);
 
 #endif
diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
index c6cd01e6064a7..62cb576248a9d 100644
--- a/mm/guest_memfd.c
+++ b/mm/guest_memfd.c
@@ -4,9 +4,33 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/atomic.h>
 #include <linux/falloc.h>
 #include <linux/guest_memfd.h>
 #include <linux/pagemap.h>
+#include <linux/wait.h>
+
+#include "internal.h"
+
+static DECLARE_WAIT_QUEUE_HEAD(safe_wait);
+
+/**
+ * struct guest_memfd_private - private per-folio data
+ * @accessible: number of kernel users expecting folio to be accessible.
+ *              When zero, the folio converts to being inaccessible.
+ * @safe: number of "safe" references to the folio. Each reference is
+ *        aware that the folio can be made (in)accessible at any time.
+ */
+struct guest_memfd_private {
+	atomic_t accessible;
+	atomic_t safe;
+};
+
+static inline int base_safe_refs(struct folio *folio)
+{
+	/* 1 for filemap */
+	return 1 + folio_nr_pages(folio);
+}
 
 /**
  * guest_memfd_grab_folio() -- grabs a folio from the guest memfd
@@ -35,21 +59,56 @@
  */
 struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
 {
-	unsigned long gmem_flags = (unsigned long)file->private_data;
+	const bool accessible = flags & GUEST_MEMFD_GRAB_ACCESSIBLE;
 	struct inode *inode = file_inode(file);
 	struct guest_memfd_operations *ops = inode->i_private;
+	struct guest_memfd_private *private;
+	unsigned long gmem_flags;
 	struct folio *folio;
 	int r;
 
 	/* TODO: Support huge pages. */
-	folio = filemap_grab_folio(inode->i_mapping, index);
+	folio = __filemap_get_folio(inode->i_mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT | FGP_STABLE,
+			mapping_gfp_mask(inode->i_mapping));
 	if (IS_ERR(folio))
 		return folio;
 
-	if (folio_test_uptodate(folio))
+	if (folio_test_uptodate(folio)) {
+		private = folio_get_private(folio);
+		atomic_inc(&private->safe);
+		if (accessible)
+			r = guest_memfd_make_accessible(folio);
+		else
+			r = guest_memfd_make_inaccessible(folio);
+
+		if (r) {
+			atomic_dec(&private->safe);
+			goto out_err;
+		}
+
+		wake_up_all(&safe_wait);
 		return folio;
+	}
 
-	folio_wait_stable(folio);
+	private = kmalloc(sizeof(*private), GFP_KERNEL);
+	if (!private) {
+		r = -ENOMEM;
+		goto out_err;
+	}
+
+	folio_attach_private(folio, private);
+	/*
+	 * 1 for us
+	 * 1 for unmapping from userspace
+	 */
+	atomic_set(&private->accessible, accessible ? 2 : 0);
+	/*
+	 * +1 for us
+	 */
+	atomic_set(&private->safe, 1 + base_safe_refs(folio));
+
+	gmem_flags = (unsigned long)inode->i_mapping->i_private_data;
 
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
@@ -57,19 +116,26 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
 	 * storage for the memory, so the folio will remain up-to-date until
 	 * it's removed.
 	 */
-	if (gmem_flags & GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE) {
+	if (accessible || (gmem_flags & GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE)) {
 		unsigned long nr_pages = folio_nr_pages(folio);
 		unsigned long i;
 
 		for (i = 0; i < nr_pages; i++)
 			clear_highpage(folio_page(folio, i));
-
 	}
 
-	if (ops->prepare_inaccessible) {
-		r = ops->prepare_inaccessible(inode, folio);
-		if (r < 0)
-			goto out_err;
+	if (accessible) {
+		if (ops->prepare_accessible) {
+			r = ops->prepare_accessible(inode, folio);
+			if (r < 0)
+				goto out_free;
+		}
+	} else {
+		if (ops->prepare_inaccessible) {
+			r = ops->prepare_inaccessible(inode, folio);
+			if (r < 0)
+				goto out_free;
+		}
 	}
 
 	folio_mark_uptodate(folio);
@@ -78,6 +144,8 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
 	 * unevictable and there is no storage to write back to.
 	 */
 	return folio;
+out_free:
+	kfree(private);
 out_err:
 	folio_unlock(folio);
 	folio_put(folio);
@@ -85,6 +153,132 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
 }
 EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
 
+/**
+ * guest_memfd_put_folio() - Drop safe and accessible references to a folio
+ * @folio: the folio to drop references to
+ * @accessible_refs: number of accessible refs to drop, 0 if holding a
+ *                   reference to an inaccessible folio.
+ */
+void guest_memfd_put_folio(struct folio *folio, unsigned int accessible_refs)
+{
+	struct guest_memfd_private *private = folio_get_private(folio);
+
+	WARN_ON_ONCE(atomic_sub_return(accessible_refs, &private->accessible) < 0);
+	atomic_dec(&private->safe);
+	folio_put(folio);
+	wake_up_all(&safe_wait);
+}
+EXPORT_SYMBOL_GPL(guest_memfd_put_folio);
+
+/**
+ * guest_memfd_unsafe_folio() - Demotes the current folio reference to "unsafe"
+ * @folio: the folio to demote
+ *
+ * Decrements the number of safe references to this folio. The folio will not
+ * transition to inaccessible until the folio_ref_count is also decremented.
+ *
+ * This function does not release the folio reference count.
+ */
+void guest_memfd_unsafe_folio(struct folio *folio)
+{
+	struct guest_memfd_private *private = folio_get_private(folio);
+
+	atomic_dec(&private->safe);
+	wake_up_all(&safe_wait);
+}
+EXPORT_SYMBOL_GPL(guest_memfd_unsafe_folio);
+
+/**
+ * guest_memfd_make_accessible() - Attempt to make the folio accessible to host
+ * @folio: the folio to make accessible
+ *
+ * Makes the given folio accessible to the host. If the folio is currently
+ * inaccessible, attempts to convert it to accessible. Otherwise, returns with
+ * EBUSY.
+ *
+ * This function may sleep.
+ */
+int guest_memfd_make_accessible(struct folio *folio)
+{
+	struct guest_memfd_private *private = folio_get_private(folio);
+	struct inode *inode = folio_inode(folio);
+	struct guest_memfd_operations *ops = inode->i_private;
+	int r;
+
+	/*
+	 * If we already know the folio is accessible, then no need to do
+	 * anything else.
+	 */
+	if (atomic_inc_not_zero(&private->accessible))
+		return 0;
+
+	r = wait_event_timeout(safe_wait,
+			       folio_ref_count(folio) == atomic_read(&private->safe),
+			       msecs_to_jiffies(10));
+	if (!r)
+		return -EBUSY;
+
+	if (ops->prepare_accessible) {
+		r = ops->prepare_accessible(inode, folio);
+		if (r)
+			return r;
+	}
+
+	atomic_inc(&private->accessible);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(guest_memfd_make_accessible);
+
+/**
+ * guest_memfd_make_inaccessible() - Attempt to make the folio inaccessible
+ * @folio: the folio to make inaccessible
+ *
+ * Makes the given folio inaccessible to the host. IF the folio is currently
+ * accessible, attempt so convert it to inaccessible. Otherwise, returns with
+ * EBUSY.
+ *
+ * Conversion to inaccessible is allowed when ->accessible decrements to zero,
+ * the folio safe counter == folio reference counter, the folio is unmapped
+ * from host, and ->prepare_inaccessible returns it's ready to do so.
+ *
+ * This function may sleep.
+ */
+int guest_memfd_make_inaccessible(struct folio *folio)
+{
+	struct guest_memfd_private *private = folio_get_private(folio);
+	struct inode *inode = folio_inode(folio);
+	struct guest_memfd_operations *ops = inode->i_private;
+	int r;
+
+	r = atomic_dec_if_positive(&private->accessible);
+	if (r < 0)
+		return 0;
+	else if (r > 0)
+		return -EBUSY;
+
+	unmap_mapping_folio(folio);
+
+	r = wait_event_timeout(safe_wait,
+			       folio_ref_count(folio) == atomic_read(&private->safe),
+			       msecs_to_jiffies(10));
+	if (!r) {
+		r = -EBUSY;
+		goto err;
+	}
+
+	if (ops->prepare_inaccessible) {
+		r = ops->prepare_inaccessible(inode, folio);
+		if (r)
+			goto err;
+	}
+
+	return 0;
+err:
+	atomic_inc(&private->accessible);
+	return r;
+}
+EXPORT_SYMBOL_GPL(guest_memfd_make_inaccessible);
+
 static long gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -229,10 +423,12 @@ static int gmem_error_folio(struct address_space *mapping, struct folio *folio)
 
 static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
 {
+	struct guest_memfd_private *private = folio_get_private(folio);
 	struct inode *inode = folio_inode(folio);
 	struct guest_memfd_operations *ops = inode->i_private;
 	off_t offset = folio->index;
 	size_t nr = folio_nr_pages(folio);
+	unsigned long val, expected;
 	int ret;
 
 	ret = ops->invalidate_begin(inode, offset, nr);
@@ -241,14 +437,32 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
 	if (ops->invalidate_end)
 		ops->invalidate_end(inode, offset, nr);
 
+	expected = base_safe_refs(folio);
+	val = atomic_read(&private->safe);
+	WARN_ONCE(val != expected, "folio[%x] safe ref: %d != expected %d\n",
+		  folio_index(folio), val, expected);
+
+	folio_detach_private(folio);
+	kfree(private);
+
 	return true;
 }
 
+static void gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
+{
+	WARN_ON_ONCE(offset != 0);
+	WARN_ON_ONCE(len != folio_size(folio));
+
+	if (offset == 0 && len == folio_size(folio))
+		filemap_release_folio(folio, 0);
+}
+
 static const struct address_space_operations gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio = gmem_migrate_folio,
 	.error_remove_folio = gmem_error_folio,
 	.release_folio = gmem_release_folio,
+	.invalidate_folio = gmem_invalidate_folio,
 };
 
 static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *ops)
@@ -291,8 +505,7 @@ struct file *guest_memfd_alloc(const char *name,
 	 * instead of reusing a single inode.  Each guest_memfd instance needs
 	 * its own inode to track the size, flags, etc.
 	 */
-	file = anon_inode_create_getfile(name, &gmem_fops, (void *)flags,
-					 O_RDWR, NULL);
+	file = anon_inode_create_getfile(name, &gmem_fops, NULL, O_RDWR, NULL);
 	if (IS_ERR(file))
 		return file;
 
@@ -303,6 +516,7 @@ struct file *guest_memfd_alloc(const char *name,
 
 	inode->i_private = (void *)ops; /* discards const qualifier */
 	inode->i_mapping->a_ops = &gmem_aops;
+	inode->i_mapping->i_private_data = (void *)flags;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

-- 
2.34.1


