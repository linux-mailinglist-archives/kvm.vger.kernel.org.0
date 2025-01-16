Return-Path: <kvm+bounces-35654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A28A13927
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E4F168A4E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228CE1DEFF8;
	Thu, 16 Jan 2025 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n8pm7GPI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDAE1DE8A6;
	Thu, 16 Jan 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027253; cv=none; b=tkR0DKxiBEgZn6RkJGLoZumcsQwY1gBoAIAuHfaa4XeU6LePrsR8jz2sTnYA1bs7ocbtgt343a8RHV9wkq4HC64jm+AYckCseyG/MbJ4azHsSZOEo/rYpm2GcSPpF6L3PpCOyx7aYffnij2MCK9nA+a+cf5IH79RAIJogxlicE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027253; c=relaxed/simple;
	bh=xRGGDbBn4BnGleQpk6xWTGyCmLMpafCOd3dz6oiJeBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF8FNm+VZgTxUHb0lVDhuk8RAQGlovTkSd6mLqWRSmtLkY0e23aUsKZn/V9t26vRL3MuZmTLNlpcdS5A8XqDAaqsY4Td3TpMXc48bZXi7GHXHigTF2M1il6QWHs5jPuINenHWoNeRSKXagQl1XKF2Ku8+pjrya6PrI0TLWgfE0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n8pm7GPI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G85s60020990;
	Thu, 16 Jan 2025 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f02CC/uC2/BG4cTZx
	e9f5Lp6etGIZU53zCwZJlZH//o=; b=n8pm7GPIVfhzwcJrbCxLb/bhW4loDjdp5
	tDmjCSFS4dKV+LCiIas2ZeSTHEMmielpobNlwPCFmpjHoUUyX+S1wffLEkELQZ+s
	qq9lZ9R/hQek6rMXPuCFkl9ld+uzhOc7Vldc6OLLq7U4tKdm2ouyvoEDgi6ajb9Q
	2c5L6kG+udJKg/iMm+UkpD0sRwWVVe8VKolX3vcQdUvC0W6KVmaj1H6JRsjUKH8j
	FSyYBPmdTgwluzYm9/LZAwvd2UXytXeB+2V0hfdNldxsZTYRSjhFPMQHEZ0CSE1Y
	JF/LqJ/0A6Q5clLtCO5ZL7TUMfP/RncHMT1HgFUEEYdnpQobd9cIw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446xa38y86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBXgoP029680;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446xa38y82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GA8rq5017359;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkdgc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBY0E356164764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16F3D20049;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD1432004B;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 13/15] KVM: s390: remove useless page->index usage
Date: Thu, 16 Jan 2025 12:33:53 +0100
Message-ID: <20250116113355.32184-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AECEgYD7s1KLqPoUJhtbzaQqlbjImkvk
X-Proofpoint-ORIG-GUID: C2IJaJq2sdjcMmtraHBtypY6P2J5SCmX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160086

The page->index field for VSIE dat tables is only used for segment
tables.

Stop setting the field for all region tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9d4a62628e51..80674bbf0f7b 100644
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


