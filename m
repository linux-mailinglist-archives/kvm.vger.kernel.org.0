Return-Path: <kvm+bounces-35656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 962ADA1392E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC56C3A805C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70E91DF254;
	Thu, 16 Jan 2025 11:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SvWm0Zvt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1E01DF244;
	Thu, 16 Jan 2025 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027255; cv=none; b=XVSbRSTNY50dhgPSeF47jEPndkLZMZH7pfSIfz28/ab2LvJ+SUfm3nYmyrnPfU/LapH43+aTolAlhTiEgX3l/aJeufZf6OhN7lqW/0ry/P1cO0jUS/A8Qsvazbj3fHFvwUJI2K+LA5l3jMbE7kQQbP12NH97jAu0QtC0zucvBlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027255; c=relaxed/simple;
	bh=AWO+qTi6vzq7mgX7uRsev16cRbVC188XRohFeL4ghmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdyku5tRww/SmsaqMY0Ty2nRVanGzuHpFqfU3TPUlNY/G0nv7941VA5W8hFr3YNopoTbwVUDTVytgifeEri23AdFhbf/FMbiJYKUglWHx1FD1BJ/UrLV+/iYLWvCNa4QNfmecZVDkUHBU8bgmor3DDsmViOAPEmj3MCK81vrz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SvWm0Zvt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G85hRf020426;
	Thu, 16 Jan 2025 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9qsY2dMPH2uCF9tG4
	cLYb8v3R2pfYLtAQZ+UsJre1ag=; b=SvWm0Zvt2TlqUKGDyMy+X5deNN2f9FPwN
	3+sj58RP755qDxHVC9KgbfBFJNGPgUMGXQvagzRFEC1HjXkgE9Y0S6uKhcCmsXFH
	VIvhOCMqhrSAF2orgHUUSANZEAGJoFp1Scn0QDIbXHNa6/BIkCktP6kqVahlBpqk
	Y46rUWIwlczUM+Fx8zezTXPbxjJOlHXOAHSsx44eUREocOsyAJLZVy0DVlUUHxpG
	JkuSqgt5iGrvvr+OgT6TORUYTI1o0wMaUbJ5dkF2lGwaRx7ZjKUjOfU2D2ZJX8Mf
	G45iMXcAbB6fK0BoyIPyLu4dI95/iJuPD+vxZSoAW8sgofJNZ3HLA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446xa38y84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBOEbc007675;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446xa38y7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GBME6P016485;
	Thu, 16 Jan 2025 11:34:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1w7kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBY0fB56492524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 660922004B;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E58D2004D;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 14/15] KVM: s390: move PGSTE softbits
Date: Thu, 16 Jan 2025 12:33:54 +0100
Message-ID: <20250116113355.32184-15-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 0GelW5f9Cqi2tCAiXZqhtnzqEfRYZn5k
X-Proofpoint-ORIG-GUID: FLClASXuFRVRMrON5O_71jUsA8RhYhuH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=429 priorityscore=1501
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160086

Move the softbits in the PGSTEs to the other usable area.

This leaves the 16-bit block of usable bits free, which will be used in the
next patch for something else.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 48268095b0a3..151488bb9ed7 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -419,9 +419,9 @@ static inline int is_module_addr(void *addr)
 #define PGSTE_HC_BIT	0x0020000000000000UL
 #define PGSTE_GR_BIT	0x0004000000000000UL
 #define PGSTE_GC_BIT	0x0002000000000000UL
-#define PGSTE_UC_BIT	0x0000800000000000UL	/* user dirty (migration) */
-#define PGSTE_IN_BIT	0x0000400000000000UL	/* IPTE notify bit */
-#define PGSTE_VSIE_BIT	0x0000200000000000UL	/* ref'd in a shadow table */
+#define PGSTE_UC_BIT	0x0000000000008000UL	/* user dirty (migration) */
+#define PGSTE_IN_BIT	0x0000000000004000UL	/* IPTE notify bit */
+#define PGSTE_VSIE_BIT	0x0000000000002000UL	/* ref'd in a shadow table */
 
 /* Guest Page State used for virtualization */
 #define _PGSTE_GPS_ZERO			0x0000000080000000UL
-- 
2.47.1


