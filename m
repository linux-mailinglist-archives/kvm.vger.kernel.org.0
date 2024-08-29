Return-Path: <kvm+bounces-25416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE86A9652DC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23291B22894
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B281BCA1E;
	Thu, 29 Aug 2024 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eah9mlFU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23C1BAEEE;
	Thu, 29 Aug 2024 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970279; cv=none; b=TkBvzJ35UljYA51JKQkgTqi4k0CK8P1m9iCganCUOBHOdG434IlyP/7FZ1Y33SPl0Fwa8lRwgt9RRUR1yu66FNKAjW9vXMuSrj+v7WAxHNQKleuUhH/NS4iYmYBBM8APH0Qptiiz9zaZB6g7GwQKtpKejcvaPbYA2N5lBPawm28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970279; c=relaxed/simple;
	bh=vNp4WCXRq96/jsbTyQi8C13HB80VQ5tpk67BkQVTMlQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=C0zPe599LFI6qBXEEZD6PtM5gkj3wg8jzel+2dag9jzeSErzW/FcYDxJ3Y5h/MxoCSBTxObY/K4tlG9Gv4JDmcUR3tLYX7FQSYM4h81RYbR4Y/kOYIyMmNGH2l9s6S/gveJh1bXmulIYnXIvdf3Gmc0R0RmydtvZ4kS65vIbt40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eah9mlFU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47THWFOG026564;
	Thu, 29 Aug 2024 22:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OikWV/zxhCjbqlu1U3SrGEvR6lLB0Wn4slbdklJYTbQ=; b=eah9mlFUiP8U2VPm
	C2fRIGHbALCXiJ2dg5iiSTWWGrrJG4hcOVmBlzZQgz9WSEhILxnJNru1yrxSn/N+
	xGK7RThKNRyd17la0q+19UxJSgOgSUyq5gNFlqQknwFlNRs9AvBVj8NmN4av+7Qp
	iuZzrb6HZ5WDmEhtpI2G5/R8Y4SNFfloKCL9byLSHyI7Zz7lTJOfcYn9jjg/3lXk
	FWJ4eDnf5LeiXzF1rLop15EAggNmJNqP68Tlg83dpshOqp83pqH1PQqx/UBtaI5o
	im5wW4b9CGjV6n8QVowjQtqOq5GaczfOntucqC085rm0NnZRr6azGqK4ixGlZA/X
	NM6uuA==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419puvesp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:14 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMOD6e014638
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:13 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:13 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Date: Thu, 29 Aug 2024 15:24:13 -0700
Subject: [PATCH RFC v2 5/5] mm: guest_memfd: Add option to remove
 inaccessible memory from direct map
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240829-guest-memfd-lib-v2-5-b9afc1ff3656@quicinc.com>
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
X-Proofpoint-ORIG-GUID: VKocc11VXrfwDcfhSZyfG1SnIgFpRfUU
X-Proofpoint-GUID: VKocc11VXrfwDcfhSZyfG1SnIgFpRfUU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=721 priorityscore=1501 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

When memory is made inaccessible to the host, Linux may still
speculatively access the folio if a load_unaligned_zeropad is performed
at the end of the prior page. To ensure Linux itself catches such errors
without hypervisor crashing Linux, unmap the guest-inaccessible pages
from the direct map.

This feature is made optional because arm64 pKVM can provide a special,
detectable fault which can be fixed up directly.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 include/linux/guest_memfd.h |  1 +
 mm/guest_memfd.c            | 79 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 66e5d3ab42613..de53bce15db99 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -33,6 +33,7 @@ enum guest_memfd_grab_flags {
 
 enum guest_memfd_create_flags {
 	GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE = (1UL << 0),
+	GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP = (1UL << 1),
 };
 
 struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags);
diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
index 194b2c3ea1525..d4232739d4c5b 100644
--- a/mm/guest_memfd.c
+++ b/mm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/falloc.h>
 #include <linux/guest_memfd.h>
 #include <linux/pagemap.h>
+#include <linux/set_memory.h>
 #include <linux/wait.h>
 
 #include "internal.h"
@@ -26,6 +27,45 @@ struct guest_memfd_private {
 	atomic_t safe;
 };
 
+static inline int folio_set_direct_map_invalid_noflush(struct folio *folio)
+{
+	unsigned long i, nr = folio_nr_pages(folio);
+	int r;
+
+	for (i = 0; i < nr; i++) {
+		struct page *page = folio_page(folio, i);
+
+		r = set_direct_map_invalid_noflush(page);
+		if (r)
+			goto out_remap;
+	}
+	/**
+	 * Currently no need to flush as hypervisor will also be flushing
+	 * tlb when giving the folio to guest.
+	 */
+
+	return 0;
+out_remap:
+	for (; i > 0; i--) {
+		struct page *page = folio_page(folio, i - 1);
+
+		BUG_ON(set_direct_map_default_noflush(page));
+	}
+
+	return r;
+}
+
+static inline void folio_set_direct_map_default_noflush(struct folio *folio)
+{
+	unsigned long i, nr = folio_nr_pages(folio);
+
+	for (i = 0; i < nr; i++) {
+		struct page *page = folio_page(folio, i);
+
+		BUG_ON(set_direct_map_default_noflush(page));
+	}
+}
+
 static inline int base_safe_refs(struct folio *folio)
 {
 	/* 1 for filemap */
@@ -131,6 +171,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
 				goto out_free;
 		}
 	} else {
+		if (gmem_flags & GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP) {
+			r = folio_set_direct_map_invalid_noflush(folio);
+			if (r < 0)
+				goto out_free;
+		}
+
 		if (ops->prepare_inaccessible) {
 			r = ops->prepare_inaccessible(inode, folio);
 			if (r < 0)
@@ -203,6 +249,7 @@ int guest_memfd_make_accessible(struct folio *folio)
 	struct guest_memfd_private *private = folio_get_private(folio);
 	struct inode *inode = folio_inode(folio);
 	struct guest_memfd_operations *ops = inode->i_private;
+	unsigned long gmem_flags;
 	int r;
 
 	/*
@@ -218,6 +265,10 @@ int guest_memfd_make_accessible(struct folio *folio)
 	if (!r)
 		return -EBUSY;
 
+	gmem_flags = (unsigned long)inode->i_mapping->i_private_data;
+	if (gmem_flags & GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP)
+		folio_set_direct_map_default_noflush(folio);
+
 	if (ops->prepare_accessible) {
 		r = ops->prepare_accessible(inode, folio);
 		if (r)
@@ -248,6 +299,7 @@ int guest_memfd_make_inaccessible(struct folio *folio)
 	struct guest_memfd_private *private = folio_get_private(folio);
 	struct inode *inode = folio_inode(folio);
 	struct guest_memfd_operations *ops = inode->i_private;
+	unsigned long gmem_flags;
 	int r;
 
 	r = atomic_dec_if_positive(&private->accessible);
@@ -266,6 +318,13 @@ int guest_memfd_make_inaccessible(struct folio *folio)
 		goto err;
 	}
 
+	gmem_flags = (unsigned long)inode->i_mapping->i_private_data;
+	if (gmem_flags & GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP) {
+		r = folio_set_direct_map_invalid_noflush(folio);
+		if (r)
+			goto err;
+	}
+
 	if (ops->prepare_inaccessible) {
 		r = ops->prepare_inaccessible(inode, folio);
 		if (r)
@@ -454,6 +513,7 @@ static int gmem_error_folio(struct address_space *mapping, struct folio *folio)
 	struct guest_memfd_operations *ops = inode->i_private;
 	off_t offset = folio->index;
 	size_t nr = folio_nr_pages(folio);
+	unsigned long gmem_flags;
 	int ret;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -464,6 +524,10 @@ static int gmem_error_folio(struct address_space *mapping, struct folio *folio)
 
 	filemap_invalidate_unlock_shared(mapping);
 
+	gmem_flags = (unsigned long)inode->i_mapping->i_private_data;
+	if (gmem_flags & GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP)
+		folio_set_direct_map_default_noflush(folio);
+
 	return ret;
 }
 
@@ -474,7 +538,7 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
 	struct guest_memfd_operations *ops = inode->i_private;
 	off_t offset = folio->index;
 	size_t nr = folio_nr_pages(folio);
-	unsigned long val, expected;
+	unsigned long val, expected, gmem_flags;
 	int ret;
 
 	ret = ops->invalidate_begin(inode, offset, nr);
@@ -483,6 +547,10 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
 	if (ops->invalidate_end)
 		ops->invalidate_end(inode, offset, nr);
 
+	gmem_flags = (unsigned long)inode->i_mapping->i_private_data;
+	if (gmem_flags & GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP)
+		folio_set_direct_map_default_noflush(folio);
+
 	expected = base_safe_refs(folio);
 	val = atomic_read(&private->safe);
 	WARN_ONCE(val != expected, "folio[%x] safe ref: %d != expected %d\n",
@@ -518,7 +586,14 @@ static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *op
 
 static inline unsigned long guest_memfd_valid_flags(void)
 {
-	return GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE;
+	unsigned long flags = GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE;
+
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
+	if (can_set_direct_map())
+		flags |= GUEST_MEMFD_FLAG_REMOVE_DIRECT_MAP;
+#endif
+
+	return flags;
 }
 
 /**

-- 
2.34.1


