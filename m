Return-Path: <kvm+bounces-35865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9891EA157F0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF1263A8CA7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEC81DE2CD;
	Fri, 17 Jan 2025 19:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BzmUpq+q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC231A7AF7;
	Fri, 17 Jan 2025 19:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140999; cv=none; b=OkQok6zHrP5V5MzRasv9Pqdds9b9rYd593nPXrvCUkYJEqOjxFAKV5SD4fMnXMi/Un4RrvsKowpT1mlyWac9kh709Yr0XNLN07Yn51JKRPH0+dA39Kw/JNGZ1GzRjy6TOmulDVuVpEQECbDzUNbWzmSJC8zXcmqoiC9nO8I+kKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140999; c=relaxed/simple;
	bh=woYQiszYOEYzhE2zn8ZV7gDgT7Cug1E08+uMltS4i6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIVv6OkjRLC+izByiKvD3+b31yDTspxX5o5ZMSEsxcNFseZk1f11xSuSyPq47TrPY8HIPCFabOI+B8uYN+DdzLgPNUhoEHQk3REwvrX9sT+lvvsIzvDNP/OaaHKsNigGCUmmUEDw5iLQ3ZOwOUk9Egcx/Wvef/KLDGULZ5L1jFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BzmUpq+q; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HCwPpR018796;
	Fri, 17 Jan 2025 19:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K0jZAX8ord7Zsu5Ub
	TEuvr6nX6fcYujyBrtAuuCUlfg=; b=BzmUpq+qKIGW3xKQ6mGFAtUXTdDH0D0RS
	7KBwZelKBidSXwDKU8lDEvpDu68s12CV8xiKUNIR7h0AO53Y7KazoqW2lI/o0uBS
	+mwvfMY/a2kRDkEjn8i73ttBjeUmWCN/dUnf9MUVdKrBH40sxFSX1AxqhkaIgSuP
	O1u5VOKFwQlSDQOTP7wzVUuhfFgsf4lWMug4vkLzwHNLMFxsNzUslpfCr23sQr3m
	2PWeD3ULHkCTo3hSMQMZrV3V4761qGpk4LWN+5L8pj4sVQPDCC/YcX94LpfzBWbh
	1J1+IyjROXwwjyprlNkyFV9DhpAcX1mvtUwLr5G/ktAPGdq9Q4DnA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ0i0Y014353;
	Fri, 17 Jan 2025 19:09:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIlQGL017400;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkma8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9gD519202424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEB8920040;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 714392004B;
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
Subject: [PATCH v3 14/15] KVM: s390: move PGSTE softbits
Date: Fri, 17 Jan 2025 20:09:37 +0100
Message-ID: <20250117190938.93793-15-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RoEs-FQNT9qPl6jFSFuago9nTHxdnBnB
X-Proofpoint-GUID: CbHywruGWtkZayqgHf0Z56UmRefZP_Gk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=442
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

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


