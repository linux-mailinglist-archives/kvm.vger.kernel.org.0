Return-Path: <kvm+bounces-5821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39733826FD8
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC53728307C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD654597C;
	Mon,  8 Jan 2024 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iBXA75HU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257BE4595B;
	Mon,  8 Jan 2024 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408CHLB6015324;
	Mon, 8 Jan 2024 13:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fRcpG3K5aBySJZn0hYQ5lUtmriysL7b79gX2wLnVQWU=;
 b=iBXA75HUuYeW3rG+UY9FGQj9s4Pzm9KWCnnYx/38MrN68EFkvsqsfJImWzLpv6eNRDYn
 KoorAmg+GJe24tZha7clzr+K3BoPfPAzo5HE2WJZXeLlepXTJBuNLYWPvwCV/ZcrTsxu
 iF/58uEUHbJ1orWzrCZvY8dnpbhh1sQrFqYJ3s+xUmMcrxPC5IOk2XxIKUvneNXs+4y0
 Fj704sr9ru+t+DfrKQwUn6ISse3I5IHCvgzlNJQVwBz5mQb4JOMk/zEvPSz8BVbfZAht
 FcnFMTwk0OP1SMEeCkEmaPkPZCrUGxQhVP90lJRK4uduQXVbAmotpfespd8imp/Twjv3 sA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf7u8ru8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408DGmSw028523;
	Mon, 8 Jan 2024 13:29:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf7u8ru86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408DOoD3004427;
	Mon, 8 Jan 2024 13:29:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfjpkfxxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:49 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DTknx19399396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:29:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5966220043;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 339EA2004D;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/5] lib: s390x: sigp: Dirty CC before sigp execution
Date: Mon,  8 Jan 2024 13:29:18 +0000
Message-Id: <20240108132921.255769-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240108132921.255769-1-frankja@linux.ibm.com>
References: <20240108132921.255769-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uC5Kto5jL1S7fRW1C2lILYnPlze9g5dy
X-Proofpoint-ORIG-GUID: 0d7CO8QpE93fCXvAYaMCHV1NfXxUTa2t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=614 bulkscore=0
 mlxscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401080115

Dirtying the CC allows us to find missing CC changes when sigp is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/sigp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 61d2c625..d73be1ef 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -49,13 +49,17 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
 		       uint32_t *status)
 {
 	register unsigned long reg1 asm ("1") = parm;
+	uint64_t spm_cc = SIGP_CC_NOT_OPERATIONAL << SPM_CC_SHIFT;
 	int cc;
 
 	asm volatile(
+		"	spm	%[spm_cc]\n"
 		"	sigp	%1,%2,0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
+		: "=d" (cc), "+d" (reg1)
+		: "d" (addr), "a" (order), [spm_cc] "d" (spm_cc)
+		: "cc");
 	if (status)
 		*status = reg1;
 	return cc;
-- 
2.40.1


