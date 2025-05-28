Return-Path: <kvm+bounces-47894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD5CAC6DC1
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 954671887D74
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D4328D8E8;
	Wed, 28 May 2025 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HTu3e+pQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BCA1632C8;
	Wed, 28 May 2025 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449015; cv=none; b=rkv/p/uK8aN+BbGNq4BaJaLmZNThXtoi+HT7Kp1zbXr0Qma1+D82ciP34oYV5p6gGgVjXBClAIF9dDOqnkkKCaxKfM1aTcw3374rS2o9g2ZHDepEzNkHnMdB/tqHAwA3N+Tc1wcNP0qYJRgm790Euk5n7D/5EkTUYb2zRGZVUtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449015; c=relaxed/simple;
	bh=n4C+Q8YVTD4n31+MHi5xHCXBfKpPM+V5+e3fDehR9eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJGKWhAj2VLYgv8WwM2LWmbTiEvHmh389KKTD36Vhw8utrDQKAX5VEeRbpS96m6G7/LJr5Byqpr2VhGSVDQ+P3odqQXb0N05KzwwPYCJFG6/Pw+wgpLWdsL7nVKhBWFM+a41JaxhozXqdNnzImNVnyQ0pKdes6Xgw/RxfYje/Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HTu3e+pQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9KVf032128;
	Wed, 28 May 2025 16:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9I62/8BNmQsGgYGrn
	PM0WTP4yZzdrfP0bPsdeLfr5ks=; b=HTu3e+pQ3uAfD/yl9fl0sDLLpxpiBs2Td
	Z20b2qLkQg3a8nOXOIAtu3bLCE/5TuiswP2WHfwWJMdPd/Knv2ByCW/+mnlXy45O
	KnwrX0YsjXZ3CAYr6M2oboEra/YSam9jBiu9pbcOumfE6bZHnD5XTO4BZgZS6KiF
	3VaBYMDYlwdhzBdf5jd66kBEigb3gWf//Ebpieq6Axp8yYNQkIjwtbpkr3i/9H96
	z7YZ2wzCBlfIHJYUS+geyBWnBoTlxhq3rJ3Y/YlQlhzTyKWJezK3SqIrt+JNvpCX
	46Tobc8jz0S+1ReKm7+1GjZDbnzoJR4qowgUzdQJzA6B26nf+UDUw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40ggphc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SF1wcd026388;
	Wed, 28 May 2025 16:16:50 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxn07eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:49 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SGGkCW16843258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 16:16:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF3E120049;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CBFB20040;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 2/7] s390/uv: Always return 0 from s390_wiggle_split_folio() if successful
Date: Wed, 28 May 2025 18:16:31 +0200
Message-ID: <20250528161636.280717-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528161636.280717-1-imbrenda@linux.ibm.com>
References: <20250528161636.280717-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q3lyDWDZ5g_lygEfnxrrLJjreL1mSkKK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzOSBTYWx0ZWRfX1gGlEkcRxA6i io8YQHcqk0zv1NIczp/Lha37xtZR3jjlnTH0JKFkxxmCzSPqXZ/O3381yngDDciN96k4m2K7mIN xWPQOEl9Qa4hWx/b1CgJ2I7PD3UniEwNQpJkCbAuILpKdlix8Ix5wVg0CmP7rMAsJkmQy8Ag+rH
 3RZC9HLQaj4NTniqFQpd6LJNy59HHBu+oolmGdO3pxilLjLieqy4D3w8Z9/AxbX0LQADJIO8H5g x7vUU3CwkkZDW7XFMa7suUYONU/uJ9WiiZnAcx4K2225WcmmkREqgUTOd//2mP4Ajz9AqJfgHOb KgAo3St3ig3ZllURrnMShHYGg2wuGdDwDlaZDYvWOuAgAdCdwdLWFSNQVcYnYXVjsL6po0p9sEr
 W++w0GrOTbe6qUml50eNJF9RETf4gtad6vs9fSym7V7hhfjgZA3/TTqzBMmBznN7pfbEGaJY
X-Proofpoint-ORIG-GUID: q3lyDWDZ5g_lygEfnxrrLJjreL1mSkKK
X-Authority-Analysis: v=2.4 cv=UflRSLSN c=1 sm=1 tr=0 ts=683736f2 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=acadoT-tMDuuzB1kdcIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_08,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280139

From: David Hildenbrand <david@redhat.com>

Let's consistently return 0 if the operation was successful, and just
detect ourselves whether splitting is required -- folio_test_large() is
a cheap operation.

Update the documentation.

Should we simply always return -EAGAIN instead of 0, so we don't have
to handle it in the caller? Not sure, staring at the documentation, this
way looks a bit cleaner.

Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-3-david@redhat.com
Message-ID: <20250516123946.1648026-3-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 2cc3b599c7fe..f6ddb2b54032 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -324,34 +324,36 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
 }
 
 /**
- * s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split.
+ * s390_wiggle_split_folio() - try to drain extra references to a folio and
+ *			       split the folio if it is large.
  * @mm:    the mm containing the folio to work on
  * @folio: the folio
- * @split: whether to split a large folio
  *
  * Context: Must be called while holding an extra reference to the folio;
  *          the mm lock should not be held.
- * Return: 0 if the folio was split successfully;
- *         -EAGAIN if the folio was not split successfully but another attempt
- *                 can be made, or if @split was set to false;
- *         -EINVAL in case of other errors. See split_folio().
+ * Return: 0 if the operation was successful;
+ *	   -EAGAIN if splitting the large folio was not successful,
+ *		   but another attempt can be made;
+ *	   -EINVAL in case of other folio splitting errors. See split_folio().
  */
-static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
 	int rc;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
 	lru_add_drain_all();
-	if (split) {
+
+	if (folio_test_large(folio)) {
 		folio_lock(folio);
 		rc = split_folio(folio);
 		folio_unlock(folio);
 
 		if (rc != -EBUSY)
 			return rc;
+		return -EAGAIN;
 	}
-	return -EAGAIN;
+	return 0;
 }
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
@@ -394,7 +396,7 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
 	mmap_read_unlock(mm);
 
 	if (rc == -E2BIG || rc == -EBUSY) {
-		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+		rc = s390_wiggle_split_folio(mm, folio);
 		if (!rc)
 			rc = -EAGAIN;
 	}
-- 
2.49.0


