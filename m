Return-Path: <kvm+bounces-36377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFDCA1A601
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1599D169839
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780BA2135B3;
	Thu, 23 Jan 2025 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H5vE5tgj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C0821322F;
	Thu, 23 Jan 2025 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643606; cv=none; b=H6iZh/rpBoROMPmV1Ak2II+4W3SKUeaX+/CtzeKQOpVXdn2zFDW3YMrKcg55Yr1+Ww74cBwVNrHqDf3rTq6/xWhQ7l2vEd+krqlYID1nhiGCqBWpMOPhi6lu6e5xl29hOYXyWzq+OTS8jSBhEFIx2iohJv8bl8Jxz/1XhXy5GTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643606; c=relaxed/simple;
	bh=R/qcMzfFLkLUhT66ulB4tjFyvrg8rhE/lOI+1MyUmlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfC49tPvoMXK3RgaubFFmvU/I8dhBOC/kcpU93nod4wLUoXtpVEi/OccnqqnZezybJMw3a43TuyKfhqtgcjtdN7sepbOC6DMBrglbXpcJrr6LxDKthAlcn6T8s8VuH9f/Ln/AGgYIbZDwaH5YkhvRSvJkLDh7ASpiV1nV/ATxbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H5vE5tgj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NDClSv016775;
	Thu, 23 Jan 2025 14:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HzqWAorIM7S7HuUam
	CjXHJNjqiVP+T7Z4kPPyvjlXT8=; b=H5vE5tgjHB+HkNCx0g/hCOX4tx1eGyndP
	Y4bYbYDYI43TJV1AxqmoNaJqtODbawiWbZeYcTYlnh753nQ3RqjA7gJbhqcujTf/
	kl191Og9YlcghRr2bMN6pZA6DTdtMKC5h2upTaxLYW26bKUHFDhZlRMX+BuCoQZw
	bRKEIwyNpoUnDZI4BHuF+VF9054zhvk3d+/hdBuEvOhyvJZ+kU4JXu9eeRi9NjuT
	+aBYnn3wQE/31pbMIGL4ZmvvQdDTGme0WBibjPy2YqRXmJgL08RWvLWHYPoFSQTP
	koXpMrDVoF+LjvnGyGYyaYR5x56EujxqEhxU541gOehvPoWEvKMzw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:37 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NENHGd001810;
	Thu, 23 Jan 2025 14:46:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NAnZx9029538;
	Thu, 23 Jan 2025 14:46:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448qmnnysp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkWlQ45416900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3329E20040;
	Thu, 23 Jan 2025 14:46:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1DE62004D;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:31 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 13/15] KVM: s390: remove useless page->index usage
Date: Thu, 23 Jan 2025 15:46:25 +0100
Message-ID: <20250123144627.312456-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PZaXMawLx1BesV8_bU9XA_T3zqvH6Qzz
X-Proofpoint-GUID: 5SPQh3lBdUWNaFJVtba7mnuOXryjbHU9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

The page->index field for VSIE dat tables is only used for segment
tables.

Stop setting the field for all region tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 918ea14515a1..38f044321704 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1520,9 +1520,6 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = r2t & _REGION_ENTRY_ORIGIN;
-	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
 	s_r2t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
@@ -1603,9 +1600,6 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = r3t & _REGION_ENTRY_ORIGIN;
-	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
 	s_r3t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
@@ -1686,9 +1680,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = sgt & _REGION_ENTRY_ORIGIN;
-	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
 	s_sgt = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
-- 
2.48.1


