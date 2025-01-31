Return-Path: <kvm+bounces-36996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBDFA23D22
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A23723AA38C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F32E1C4A24;
	Fri, 31 Jan 2025 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o6RryhtL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42A1F3D57;
	Fri, 31 Jan 2025 11:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322749; cv=none; b=iekLFaonaNLENOSg35wa3HbV+lD7WffAHknVzP6rc/T0MoTOeNifIXsFgXObVAKid3nQO6cE8R9e/tl0Xw6Nvbk+Uh1jlLUmFGM7xXiXKjm6MYg/0LIZVRILwrVy9cp+wbmIR6rYCLuwOWvG5NZIxChwmuW9jvFM6GGOI1YX6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322749; c=relaxed/simple;
	bh=bXMeCQwxXJJhWnlLKeCRhoDD9cdwFGwltizbHxyQnbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE6pbkbl1ZpZbxSlQ0kp2hr499JnKzxwb3T+M3Y1sV6yxmIyc6NWMRI8+fyB9A+/bAfwQENZ8/QvjlWzJiirKx+Cl7zAJj5EwOLMavEjDhZX62v52FpJ6iFvBsig2ACuZxiKjRx3YXmx1cGtdsGwuXpX17URYa16XArz5Y6A9SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o6RryhtL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2Oc0V016640;
	Fri, 31 Jan 2025 11:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iZcFWV0rWt5Yt0Xtq
	zWBidwiaSBSf8d6Q6babA4TcQc=; b=o6RryhtL+yXz93FRknpuLV0GpVUVM1Bb4
	1QHKHNuLuOdeM6mR1ZW59vaTQqTSA254NPbHcz9ng6tP6Bgu4fwoo1zlzcv9BxXy
	qVMUp8tO2BF8U3Hm+Jt7iQg5nieCksVkZQ7thhsJZWNJRw6WZDZd0X2Vy/RvyNcv
	o2PVy12UOFu/GliVG7njnAzUBwcPKvO0WEbbnyYM9lqJk6uT1cJ/Jh3NHp6BRHTk
	0Td81ET3n/+CErrOf6e24McEmpwJyW6dsn2x7xtidSUF7/7byEsLYyu0j9pti580
	4DwhOZmTfpCpticdPk8RUEPfoocJuhj5pTZsRTsp3G/xFIakpbZJg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gmk92481-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8MVKk017145;
	Fri, 31 Jan 2025 11:25:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfaxb8mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPdbx29098506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:40 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44EA820134;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC3F920138;
	Fri, 31 Jan 2025 11:25:36 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:36 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 18/20] KVM: s390: move PGSTE softbits
Date: Fri, 31 Jan 2025 12:25:08 +0100
Message-ID: <20250131112510.48531-19-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QCw3AEhSQoLSt-MRq0HCfFUo3RFp7man
X-Proofpoint-ORIG-GUID: QCw3AEhSQoLSt-MRq0HCfFUo3RFp7man
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 adultscore=0 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=440
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

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


