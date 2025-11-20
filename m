Return-Path: <kvm+bounces-63893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B4178C75A23
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F2DE73607F2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6BF3A1CF7;
	Thu, 20 Nov 2025 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rOGjBQIE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FC436E56F;
	Thu, 20 Nov 2025 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658962; cv=none; b=W9R56+QLzcT9AL/uTSKZMFRrOZPvdeHIWpsabF4qhdqakpD6S5TW7Ppb2iOTQ0/j7vpkh8LNEZbgJZP/RDpBdMTJ72GVQzfH6fleipo1ijoENghxJ8zi+aYrvO+SvJH8RLETMZRyAP+8nMTTAwdAjmIFK6pR9iXvou82weOqkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658962; c=relaxed/simple;
	bh=u0nU9kATVWzKc/kzO+zCDytNR0N2lU6/4sQllCyXLLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8WIi//phkIe7liDeQ4LmS6yCgUeJ3w/6Q94iTyz5kLRCttii+dTjntpLunomS9tLUXU0zhbh0D4FvH7rxQJqvSqMxyvv6TKcVqctk4LT35suZ/CXRgShuAlTm5lF+/2Giu0prykbv2rqGPpMR/eOT9vRA+dWpUE9FH97z16q1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rOGjBQIE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKBshML021451;
	Thu, 20 Nov 2025 17:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9Glwi7ThStNExADDO
	9eERh5uOsvr/UmeHWdV3D6Ue6k=; b=rOGjBQIE0qDc2jeIFhzHjNxwRc8em5ViX
	+WDtlGsrGBM/6PeTQV2tZrt9snu0UBWMxhXyKV0Zvbxf3RU0DiKGDqFzRTqT6bdd
	aqJUfzJhIATBhKVK94getVym81ri+8CzjQpc7qcbHtJ1n6HedzPO1lAD6Y2X/KF3
	HLLkkg7lWpKNUP9HkZxO3q0qAYBJEoUkha4CorBXBm1IvN+Nt2xJXWhnWkcPNPGl
	UJKQRx+VyuMFv6rUKuxhh6pyhsMv/RN2J09hwW6SQc79vfHf4oIFmo8z8X7QutPU
	tXDM0TYnllOiCyvYbY29HgwLAHRnODt8ZaADwwmixnR0ubwwj9x3g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjwfr9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKGcYbO030851;
	Thu, 20 Nov 2025 17:15:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af47y7qnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHFqI546268842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:15:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FEA32004D;
	Thu, 20 Nov 2025 17:15:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9B8220040;
	Thu, 20 Nov 2025 17:15:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:15:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 03/23] s390: Move sske_frame() to a header
Date: Thu, 20 Nov 2025 18:15:24 +0100
Message-ID: <20251120171544.96841-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120171544.96841-1-imbrenda@linux.ibm.com>
References: <20251120171544.96841-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691f4ccd cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=-u9FmCOoZJUNk1x3bJoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXzlPQO/shgidR
 sts1BE71Rur0zRVYs/yRVuAvut2NNCdbNBZwWoVGkhJEmMdmYDbR8wQM2OAG9eJHx3hvfa3MB8m
 Y32siroLpKkqmvE25Pxwr1cbrlL+o4szMW3mJNtsBckz/UTHVtxdw3VSXwJ87WaudSwla8yrMy5
 1fOw+NV/MNNAeKNC74tc4wmviRCyw+EtFr4DNfiNn7q9mhu0Q09NGWh6i4dqBqGnmEKqoTNBguD
 mXtOETFhU8Ou5siNizMRQP3bhl2Z14SyXhi4rAn+udWvMjhsBwEYBssQBwhzR6Cm5I/UxEmlO8D
 LAB1fiP3l+mcRqUlnQv9N3rVAlQirgFbXtIsihrYOyylWKBRYCxq8mlpPRSIcmxXFth2YtTX6ac
 cilBYFSbgSJccb+zte9M/FXnNCY7+g==
X-Proofpoint-GUID: HQM6LjQUB-vsTWCpkRawPf_3co87Cy0G
X-Proofpoint-ORIG-GUID: HQM6LjQUB-vsTWCpkRawPf_3co87Cy0G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Move the sske_frame() function to asm/pgtable.h, so it can be used in
other modules too.

Opportunistically convert the .insn opcode specification to the
appropriate mnemonic.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 arch/s390/mm/pageattr.c         | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 528ce3611e53..3ddc62fcf6dd 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1148,6 +1148,13 @@ static inline pte_t pte_mkhuge(pte_t pte)
 }
 #endif
 
+static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
+{
+	asm volatile("sske %[skey],%[addr],1"
+		     : [addr] "+a" (addr) : [skey] "d" (skey));
+	return addr;
+}
+
 #define IPTE_GLOBAL	0
 #define	IPTE_LOCAL	1
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 348e759840e7..ceeb04136cec 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -16,13 +16,6 @@
 #include <asm/asm.h>
 #include <asm/set_memory.h>
 
-static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
-{
-	asm volatile(".insn rrf,0xb22b0000,%[skey],%[addr],1,0"
-		     : [addr] "+a" (addr) : [skey] "d" (skey));
-	return addr;
-}
-
 void __storage_key_init_range(unsigned long start, unsigned long end)
 {
 	unsigned long boundary, size;
-- 
2.51.1


