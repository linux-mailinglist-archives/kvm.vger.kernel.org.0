Return-Path: <kvm+bounces-35860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBC6A157E6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C62F51889971
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD111D5AC8;
	Fri, 17 Jan 2025 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QM/pICGe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B8A1AAA29;
	Fri, 17 Jan 2025 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140993; cv=none; b=B7TlTz07y9YvB1F/NUwQ/FeEtJPLZahrivSHmOV0dTZMbIsKFMBZzqlgJOxzBKIL5qFzlm8Kdq+ehKmb4GkRh90sCwhkZBYJmIS6dosz8QtqhXnmFz3c6/kuFIaRMh4GPZHChAmxLJ5bpCZpEiJ72+KjajW5t8v09hHQsBTuDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140993; c=relaxed/simple;
	bh=SGEAyUfArbnf+vR+FU0dozPIm67Z2H+VrXRfOARLtY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgsRB+cumZMrNWUESfN4TqoqjT67mH1NOVU7PmboPQttE0jPJr7sBt+ZHlQeV968gsx1XG1Dbs2tALw5hugxCM3s/r8xDL0ErT78tlt7A4fpMDWTWfgw/eZhs5gLSa5UTLhHNlx5yE+cxm2qJuc1AU/wY1JVzFjyzGgOGyDYMyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QM/pICGe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE6OZG021263;
	Fri, 17 Jan 2025 19:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GqvnegljpNofolcUG
	nLpduNbqLnzZo+PeDG4IanG9iY=; b=QM/pICGeAX34QnCXQySJUG9EsrjMsla5d
	Qesl9ZxMMeibQR4inKm/7SzKns/J/Wb8IYTvEm2Hl8b/8j2QiCxqoXkfgMRuUV5j
	0jY0pAbIpJLw27cXfx9hwlzkTtne/h4NYS6ei4Z1oQTfAnutCVZuph6a/wuCxHZ6
	0BC5xjH4xWLxm7azRCStLSA1GaqJMef6vXnP5Fy/lbocEdObyEPeZ7AGh4ETP98b
	+zOB5yiTMA04jwSKQ7yABp8u+EZEt6bVZeZLqhBTButBG1HzThDB5VdEmuQQKJwf
	w3tidk8QnLOMvgpHIEpCs/7cPV8csvs7zVOhh+wAJkNN49zjVXQbw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp59fkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ8YBC000464;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp59fke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HI09jO002738;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bymg11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9gTt19202422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6ADDB20040;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 372B620043;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 13/15] KVM: s390: remove useless page->index usage
Date: Fri, 17 Jan 2025 20:09:36 +0100
Message-ID: <20250117190938.93793-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zxwUTstJCHrBY0aPACCTUe2tt4YZm0Er
X-Proofpoint-ORIG-GUID: kNsU9iPu1WGXtC1HTDupxf--K22CqIhI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170149

The page->index field for VSIE dat tables is only used for segment
tables.

Stop setting the field for all region tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


