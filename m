Return-Path: <kvm+bounces-36908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08349A22ACD
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C08181887FC4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971551B87C2;
	Thu, 30 Jan 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PLcpUpBx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B131B87E0;
	Thu, 30 Jan 2025 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230692; cv=none; b=YrjaUuyqWtdA8zocS05IAwN9bUDxDhUAOFhF7JHKs5gBzaggv+VqKCDAWq2fe6OKU1qktUpTveKWMCEjVS63SuxcBnyunAo+m5eCXRq5zGbOiEFD2R17LWX8vUkuob0QhGXvbI8FIPjWN6huAUosLi4nDZTm3q0DJ/IVphvSyK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230692; c=relaxed/simple;
	bh=bXMeCQwxXJJhWnlLKeCRhoDD9cdwFGwltizbHxyQnbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsXqXb9MWh0IJ7aLpoKo5PXhmAU3POjMM9uE3UP+NYHr+ANlAHJF+SenH4M8tBWL4C0opfJ/REdwihFMze+3ZAWwzZbsrUHHDyyDXaoM7iT4088d43Z8TZbfqD+SByrDx/laTYWsumfKWmide4oR2jOKgrjQoh4P8qNtetI1tWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PLcpUpBx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U20fXP019614;
	Thu, 30 Jan 2025 09:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iZcFWV0rWt5Yt0Xtq
	zWBidwiaSBSf8d6Q6babA4TcQc=; b=PLcpUpBx3tOLpKzjgZqHu56j20SI6V6tU
	6TaCBauh8M2Ek0c1Y8nwlTJXADoN2zsdU9EWcbMo6lRl5eSpD/0PKGTZwm9XXB4M
	xuOkLiPy9ELBqXi8SufmxC65K7ZttIOdX8v8NWgqs9iGnOhbXi9PvQj45yUGhiC5
	w4aqZxiv/wK9waTNCsqe+k7BOKzJGMsWNdENiTZGafAHJwsGYjLuIDMBRxDzEZ8j
	R1I/OzA2xhksO4K/J6tp9KfW2sHyVcVpAOIAxPzoorVyLvM669KSFtKCww110FpG
	J8COOYbVSWfwfso42JqjKAjLPtkt/GoqNPxlpeGGxy7viRsbyeVbg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g08ysnnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U7Bj9b003957;
	Thu, 30 Jan 2025 09:51:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44da9snpgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pMej33555010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDC612013D;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB8A82013E;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 18/20] KVM: s390: move PGSTE softbits
Date: Thu, 30 Jan 2025 10:51:11 +0100
Message-ID: <20250130095113.166876-19-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QGtRwWryMnZGjabAiTXlkFOOMKhdl216
X-Proofpoint-ORIG-GUID: QGtRwWryMnZGjabAiTXlkFOOMKhdl216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 mlxlogscore=440 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300069

Move the softbits in the PGSTEs to the other usable area.

This leaves the 16-bit block of usable bits free, which will be used in the
next patch for something else.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-15-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-15-imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index a3b51056a177..a96bde2e5f18 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -420,9 +420,9 @@ void setup_protection_map(void);
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


