Return-Path: <kvm+bounces-28918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E92EC99F305
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A50C5283416
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D6E20822B;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qf06BEyG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419AF1F76B1;
	Tue, 15 Oct 2024 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010615; cv=none; b=bfFbEOOLrJqUSssuW4fpcd52NOq7DoH2FwYCD5+21yrntCIP54drI/1kwL1OMITxlDEPP2Rr3FfZzwoK7W7Nf6fZoD0tMb9wEEbgnt/U9ODmHgryJUAVF59MR3A+8KHe/UTdNLqRz9Dfn3/6SDraFfUAKkMZDE2d4CMwYFyuObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010615; c=relaxed/simple;
	bh=k5lOefbufAjKCXSvAI0QZkBhEVgURXz8KGP/kcrvRLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+eL+iSaGJuxfo3D3AxC66UUldsnAcIP5bBcJoBugt6JQideTlsWsR4DTm4Mkw3QGHGViYQBEbQ7Q5bQenUMS+e6UXG1eI4SEZm41M23DGhf90C1pWpAbFHl/hj7Qhz72yjOdekQyHUUd1hoFT+3nxnPbyjMXI3PXooZOUx33PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Qf06BEyG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FGQXsx019561;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=A52Lr50fscREd2CRD
	tbP+ERY4Z2lSogVfSi5ya6LgN4=; b=Qf06BEyG/rxeVZZ5c71p5ufFVv+jddQvQ
	qTshQfQCBvK8rNBDE6Ax9zwYf2KqQWxT+oImIOCwJBev0G1lisSrc5SGEcnc3dZq
	WbrE1oEgOBTCfplfHoFJKP3yasJogmn520ZfUbizqr7ox3QN9X/fVa1qDdJ/ADMp
	bXfn4+k9inbfTjwQJP1SQjZRd5Rz6PZL45KBAilRsGbigTdyKk3lYeSjCS0gr52g
	18KXGhympcjT1kA1UKWWqbeagmfJf59UB6tr2YV1U0OFkvUnkri5c10cpU3AWZ8M
	aA7r3aWqWdBCsv3PhT/WT6lvxrXQAykbv3Tq66nUNYWQNDrO7TiVg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429uwjg2ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDoqOr027444;
	Tue, 15 Oct 2024 16:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txn027-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhSV450069776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59F5A20040;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 332EB2004B;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 08/11] s390: Remove gmap pointer from lowcore
Date: Tue, 15 Oct 2024 18:43:23 +0200
Message-ID: <20241015164326.124987-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015164326.124987-1-imbrenda@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 09bijSbFQjfpdl6JMIX0_p82HusvcrHk
X-Proofpoint-ORIG-GUID: 09bijSbFQjfpdl6JMIX0_p82HusvcrHk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=601 adultscore=0 clxscore=1015 mlxscore=0
 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

Remove the gmap pointer from lowcore, since it is not used anymore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/lowcore.h | 3 +--
 arch/s390/kernel/asm-offsets.c  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 48c64716d1f2..42a092fa1029 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -165,8 +165,7 @@ struct lowcore {
 	__u64	percpu_offset;			/* 0x03b8 */
 	__u8	pad_0x03c0[0x03c8-0x03c0];	/* 0x03c0 */
 	__u64	machine_flags;			/* 0x03c8 */
-	__u64	gmap;				/* 0x03d0 */
-	__u8	pad_0x03d8[0x0400-0x03d8];	/* 0x03d8 */
+	__u8	pad_0x03d0[0x0400-0x03d0];	/* 0x03d0 */
 
 	__u32	return_lpswe;			/* 0x0400 */
 	__u32	return_mcck_lpswe;		/* 0x0404 */
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 3a6ee5043761..1d7ed0faff8b 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -137,7 +137,6 @@ int main(void)
 	OFFSET(__LC_USER_ASCE, lowcore, user_asce);
 	OFFSET(__LC_LPP, lowcore, lpp);
 	OFFSET(__LC_CURRENT_PID, lowcore, current_pid);
-	OFFSET(__LC_GMAP, lowcore, gmap);
 	OFFSET(__LC_LAST_BREAK, lowcore, last_break);
 	/* software defined ABI-relevant lowcore locations 0xe00 - 0xe20 */
 	OFFSET(__LC_DUMP_REIPL, lowcore, ipib);
-- 
2.47.0


