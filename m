Return-Path: <kvm+bounces-36383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BED17A1A60D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA4361887756
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D782144AF;
	Thu, 23 Jan 2025 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KeZ7qAk8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C533E2139B1;
	Thu, 23 Jan 2025 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643610; cv=none; b=Pc7iO8BmGC+y9Q5wjf+qqK9NvHLIFjv9pWjY5AhClHB1JJExdMqbGHY8ge1qRmmOu3JRAxWC7S7m+pQucmuXwAogMqPXpX3W5fFjBoVeLkolU60bR6Z6x9MGdpT9p9ya93h0jRMVFrBtiIiQIcH6a7AO/Nc8AQGHfkINbqnIgFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643610; c=relaxed/simple;
	bh=woYQiszYOEYzhE2zn8ZV7gDgT7Cug1E08+uMltS4i6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrhUQqZzCbvZqXuW1dWTi74uzB7X6oZhG5d6rKisfEWBGJ2XseEzpQi6VVF235QHhjRBmMcKSz4JQTM619pRDSIgGFXbPNPob6awFvTjTLVfjqFFTLrfKzn4hUjebE+jX0GmVgh+/jadxZO+P/BlyrKd5VE7W0UG0c2fVUX9oNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KeZ7qAk8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N5O5eq026562;
	Thu, 23 Jan 2025 14:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K0jZAX8ord7Zsu5Ub
	TEuvr6nX6fcYujyBrtAuuCUlfg=; b=KeZ7qAk8uqMXx7xeU3ylXuOPuGAJGgfvn
	vOHcgtcuwcGfwx2AJPhXGtQJ7D5uMS3cG8qhfwQ3jGsVOdUeXOUWuD9mjLsPerKX
	tnBRt4ndMrl04aQy7grwPQBiyQV6YMH+Mk/4q3golBkuUYzsr6hNjmvFqZnR3q4G
	1dNm7JoSJbpXiIbfFJbbSpNTt/MNvA0JO4AEx/pBlDxkGr+R/iOjJJp5G0X6xGvS
	CSGA1B7ZSkDOEX5XHRbTlyYSisYKQEf/nUJ3o4ePbJoWwmrN+jYREEUW3Zu3p04T
	g4/el/E2IAQpeRfykHah8f73i6wA0WIldHEn0Q0PCVH7jZVcaYZFw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bfk7tkfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:37 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NESaxD025439;
	Thu, 23 Jan 2025 14:46:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bfk7tkfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NDk4Lq019287;
	Thu, 23 Jan 2025 14:46:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pmsp5g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkWak50463086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F2F20040;
	Thu, 23 Jan 2025 14:46:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3993F2004B;
	Thu, 23 Jan 2025 14:46:32 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:32 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 14/15] KVM: s390: move PGSTE softbits
Date: Thu, 23 Jan 2025 15:46:26 +0100
Message-ID: <20250123144627.312456-15-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: sPHw2WjdwUREpUp-tKfpfkPOeS9kD1uf
X-Proofpoint-ORIG-GUID: knLT2U1SsTXWvFQOvn8frLkXpcL39yIj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=439
 adultscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

Move the softbits in the PGSTEs to the other usable area.

This leaves the 16-bit block of usable bits free, which will be used in the
next patch for something else.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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
2.48.1


