Return-Path: <kvm+bounces-34817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D9EA0641D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91C791889634
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA66200BBE;
	Wed,  8 Jan 2025 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lEx60sC6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E2202C39;
	Wed,  8 Jan 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360107; cv=none; b=W1ugcuCZ4cpYY2LS/7o702LxRmwhKSDXtHdh7sVu4oVXyrc5pgjdadkQ+PGgpIP8CnDCPLgW9A3cYx+c90aJQAi35zcjZx5s6Be2t/KefRJhzQWSXgZwIQ4vXSfcB2RDMx6u1ckv4HEuRGrl2eyj/FLiTkDqczhMiknOMJsB2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360107; c=relaxed/simple;
	bh=L1q9B0V8NwEUqqiT8cSM8ANaxwhLoHvZWakfvu1bIDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toAXu4JBZfVaQgLrI/JWIT+EZ9Fgi/UIO9+jzs6i9WRbjyo5ZBiVHx7ijOZBcm26ZIKGcKTsLOpFrLXT+RSqiZtbMkSUvNlhWLVjkFewuLrse6my5fph1Jo1cgRPbLCLZXbHwhT5VEFJ7ZC61idHb/ypBXJKXU1kJMxQ1y0ggtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lEx60sC6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508C3axD028788;
	Wed, 8 Jan 2025 18:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=c9pfbuV57+SAPM9eE
	ums8OEEJ5tSK7Wikg9htrzfqE8=; b=lEx60sC6xQg50JHSbU4Wx9Z/xHbtk1in9
	QZVd8tHaSTgkVM8eBjksZhgINrDYTK3JlHx7B7BBdUG9cunbYQKFsxgVr205PzEb
	PUJk5QY7JRNXf6/RZJnAeRe7srVKXjireS9qH7rAMFa4EKthIKoJIWtiw+sff+GW
	IOoqBCNYYnfO58FoGYZbHVKqB/sNikp+wwfjY6SbCmePwzR/JOaDUBlWUJRpvBLd
	BbvSSaEsrN6q9RE/SPApuZEPLdg0xyjMHhyKgHtUtQ3m/JBk/SeYvOPBIw0KFtgb
	eE4DHYTVf83o/rs/oXl0xJp/CegST2Sc2O4DyAsLpaei1Dmf3MdcA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441e3b4d3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508G88r7004143;
	Wed, 8 Jan 2025 18:14:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfat99n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEsML38338890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A26E2004B;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6526E20043;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 11/13] KVM: s390: remove useless page->index usage
Date: Wed,  8 Jan 2025 19:14:49 +0100
Message-ID: <20250108181451.74383-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5MPP1lcwP0ewUrHRKDceHoCYZJ9EzS-e
X-Proofpoint-GUID: 5MPP1lcwP0ewUrHRKDceHoCYZJ9EzS-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

The page->index field for VSIE dat tables is only used for segment
tables.

Stop setting the field for all region tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 815bcb996ec4..3276437725b8 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1507,9 +1507,6 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = r2t & _REGION_ENTRY_ORIGIN;
-	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
 	s_r2t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
@@ -1590,9 +1587,6 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	page->index = r3t & _REGION_ENTRY_ORIGIN;
-	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
 	s_r3t = page_to_phys(page);
 	/* Install shadow region second table */
 	spin_lock(&sg->guest_table_lock);
@@ -1673,9 +1667,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
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
2.47.1


