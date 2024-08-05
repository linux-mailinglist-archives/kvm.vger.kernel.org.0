Return-Path: <kvm+bounces-23253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EEB9481BE
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC8828F549
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD78D165EF1;
	Mon,  5 Aug 2024 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ilp7NFpM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096A815FCFB;
	Mon,  5 Aug 2024 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882942; cv=none; b=iyxqc21/fLEDyKAarYu3uqxPyR5x4MRYPs8IX3CDTFa4dyRuPdjFQZB+lIOPs4KHcc9noYMzPgAjlCeRXRZwBhndx2Wr9sknYP4FhC5RP5EQsVFgRxSuKmF76x/jY3hoFFsFlu/OxYyYz/9S1WdfdxOssysj1ny571BrCuMgDCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882942; c=relaxed/simple;
	bh=KDfEQXalqiSf5/IeM/csiSOK+UBLbEzbozYvh/q4gwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=NRrUynrYBNid34W0TTKjZrgSPjWhcM1I7p0Y7LIcY2bMTJKxffPhexA1wQl/3lLFL/Q9wpy25KPCj8dokZJ+eLjVjRiHlZPiYwnV5yiwYPPEov281H8ubWL/a0ve+gNA0J7n4qXip2cqwvUMFKgUaLB8TNQI1tTsauphU/3utP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ilp7NFpM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Ba1wb019108;
	Mon, 5 Aug 2024 18:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t1pn8IKt3beAj61svnkSxeGlbod/pIj3zCqhxkMpp1w=; b=ilp7NFpM6DFeBDl8
	W2bBX1hMzxVSdWfGchUjniGKkx5rbEA43dGS6ywxd2ONUPCRZpNMGRa+FHVK7AdK
	0z0YnZ0dmjdVjJrbVeeUj0zInLNzMpNvTjqnRKnyj5yteJ4A0XXLRiii8ntFpC9n
	ayW/9+d5w8HN12VLKzjnbx0EH+ATlOkD8R/Dulbom+eIV71Vryq0BKfZh/BAlWXA
	HqT6/Grd8PRWUoZjUgozB09K254LwLAojCpuPkVM7IKvyoxZNtfVWVPc0vQccmck
	/7glP+rY1jC4i76BTW8vCMnFOLjRn3WwRtld+qmUh7B+uBIloCbP50wEYuJnN8tC
	EvgJ9w==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40scs2vvgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 18:35:26 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 475IZEiA024686
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Aug 2024 18:35:14 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 5 Aug 2024 11:35:14 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Mon, 5 Aug 2024 11:34:49 -0700
Subject: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
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
X-Proofpoint-ORIG-GUID: Km60UcZQKmFHYOSjr87yEZONp7TaX5Yo
X-Proofpoint-GUID: Km60UcZQKmFHYOSjr87yEZONp7TaX5Yo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-05_07,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 mlxlogscore=885 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408050133

This patch was reworked from Patrick's patch:
https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/

While guest_memfd is not available to be mapped by userspace, it is
still accessible through the kernel's direct map. This means that in
scenarios where guest-private memory is not hardware protected, it can
be speculatively read and its contents potentially leaked through
hardware side-channels. Removing guest-private memory from the direct
map, thus mitigates a large class of speculative execution issues
[1, Table 1].

Direct map removal do not reuse the `.prepare` machinery, since
`prepare` can be called multiple time, and it is the responsibility of
the preparation routine to not "prepare" the same folio twice [2]. Thus,
instead explicitly check if `filemap_grab_folio` allocated a new folio,
and remove the returned folio from the direct map only if this was the
case.

The patch uses release_folio instead of free_folio to reinsert pages
back into the direct map as by the time free_folio is called,
folio->mapping can already be NULL. This means that a call to
folio_inode inside free_folio might deference a NULL pointer, leaving no
way to access the inode which stores the flags that allow determining
whether the page was removed from the direct map in the first place.

[1]: https://download.vusec.net/papers/quarantine_raid23.pdf

Cc: Patrick Roy <roypat@amazon.co.uk>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 include/linux/guest_memfd.h |  8 ++++++
 mm/guest_memfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index be56d9d53067..f9e4a27aed67 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -25,6 +25,14 @@ struct guest_memfd_operations {
 	int (*release)(struct inode *inode);
 };
 
+/**
+ * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
+ *                                  remove them from the kernel's direct map.
+ */
+enum {
+	GUEST_MEMFD_FLAG_NO_DIRECT_MAP		= BIT(0),
+};
+
 /**
  * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
  *                             If trusted hyp will do it, can ommit this flag
diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
index 580138b0f9d4..e9d8cab72b28 100644
--- a/mm/guest_memfd.c
+++ b/mm/guest_memfd.c
@@ -7,9 +7,55 @@
 #include <linux/falloc.h>
 #include <linux/guest_memfd.h>
 #include <linux/pagemap.h>
+#include <linux/set_memory.h>
+
+static inline int guest_memfd_folio_private(struct folio *folio)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long i;
+	int r;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = folio_page(folio, i);
+
+		r = set_direct_map_invalid_noflush(page);
+		if (r < 0)
+			goto out_remap;
+	}
+
+	folio_set_private(folio);
+	return 0;
+out_remap:
+	for (; i > 0; i--) {
+		struct page *page = folio_page(folio, i - 1);
+
+		BUG_ON(set_direct_map_default_noflush(page));
+	}
+	return r;
+}
+
+static inline void guest_memfd_folio_clear_private(struct folio *folio)
+{
+	unsigned long start = (unsigned long)folio_address(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	unsigned long i;
+
+	if (!folio_test_private(folio))
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct page *page = folio_page(folio, i);
+
+		BUG_ON(set_direct_map_default_noflush(page));
+	}
+	flush_tlb_kernel_range(start, start + folio_size(folio));
+
+	folio_clear_private(folio);
+}
 
 struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
 {
+	unsigned long gmem_flags = (unsigned long)file->private_data;
 	struct inode *inode = file_inode(file);
 	struct guest_memfd_operations *ops = inode->i_private;
 	struct folio *folio;
@@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
 			goto out_err;
 	}
 
+	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
+		r = guest_memfd_folio_private(folio);
+		if (r)
+			goto out_err;
+	}
+
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
 	 * unevictable and there is no storage to write back to.
@@ -213,14 +265,25 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
 	if (ops->invalidate_end)
 		ops->invalidate_end(inode, offset, nr);
 
+	guest_memfd_folio_clear_private(folio);
+
 	return true;
 }
 
+static void gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
+{
+	/* not yet supported */
+	BUG_ON(offset || len != folio_size(folio));
+
+	BUG_ON(!gmem_release_folio(folio, 0));
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
@@ -241,7 +304,7 @@ struct file *guest_memfd_alloc(const char *name,
 	if (!guest_memfd_check_ops(ops))
 		return ERR_PTR(-EINVAL);
 
-	if (flags)
+	if (flags & ~GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
 		return ERR_PTR(-EINVAL);
 
 	/*

-- 
2.34.1


