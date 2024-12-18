Return-Path: <kvm+bounces-34045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA209F67B0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 14:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8008E7A26FC
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 13:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F2C1B4247;
	Wed, 18 Dec 2024 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jtXj4m1w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E9A1ACEC1;
	Wed, 18 Dec 2024 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734529911; cv=none; b=mhuaoU5nE/1Ps1khYZA7ePMx4SNxBllIIM3FHpMaxDiJOO6GmVqKbbF6Hb4+pek1d7YNWBtLnVxzlWsig3WPIrSJdOyihiqahce++bOfZfwMrWW+9RtWmLt5eC7By2qqEbbtkOIfVXhgReQYXpJIxxi6xj5dPwJA5BvVXCytW3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734529911; c=relaxed/simple;
	bh=WFtA+iskOqkHw6sr45SPH9+eroydfCoXoL4ChIZHFDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw0Jv3WIatYVpMzxvRqP0uSLi+WACv429c17Eq/xN/8x4QsnhDB7vRAchOIR3CqC1N0Pbp0Pp5wIoSROcgIhJR21cpReZyz6/JE0eriyEdIcV6ss+zvEw5wSlYcYgz7pV3NnGKZhD54UuoVjK/ZEz/PZoGCai2p/bbwPKPXv0gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jtXj4m1w; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI3rD64029772;
	Wed, 18 Dec 2024 13:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=46trVngonGJucMOVI
	+KdjGuP/FF5MhznmTbg87i5hEk=; b=jtXj4m1wb79h0mFyVRFnfohCFjOi/9E/O
	L6hlUrc4YJHf6KiuPexWOcgG/JFV+rOMEM/ICP97cKX9rMUjESFJhLOpRnBsZqAY
	Pw/nt5hN/V59Il1P/oODxcWfkvdcTDyy2alTi8e+pLMQrDLUS+gChHorbONZ16u5
	QG8NAMr7N4e6hi1doveCBYaoYVajf8fpJ3zGz7Q+20rlmOE8Q+ENgNfnFtyRQKn5
	MLEd8YmG9XyeBubQS2o/wThFzcni5Mi96akd/1Chl5RLwUNA2g4LeGCUkITVPATx
	2UbZLiNUJ8VawnUfdT0/pte6D7q6mo9lsVfi4xjSjnJhFAU22DCEg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43kpvgtgd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BID3eIF024022;
	Wed, 18 Dec 2024 13:51:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43hnukg0hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BIDpdQX40632752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 13:51:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59EE020040;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25B372004D;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        thuth@redhat.com, david@redhat.com, schlameuss@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/3] lib: s390: add ptlb wrapper
Date: Wed, 18 Dec 2024 14:51:36 +0100
Message-ID: <20241218135138.51348-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241218135138.51348-1-imbrenda@linux.ibm.com>
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Kb8lAWG7FlHsEeqx_zui7ZpQB2Qm2o-
X-Proofpoint-ORIG-GUID: 5Kb8lAWG7FlHsEeqx_zui7ZpQB2Qm2o-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=701 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180106

Add wrapper function for the Purge TLB instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 7b556ad9..fcb30a1e 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -247,4 +247,9 @@ static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
 	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
 }
 
+static inline void ptlb(void)
+{
+	asm volatile("ptlb" : : : "memory");
+}
+
 #endif /* _ASMS390X_PGTABLE_H_ */
-- 
2.47.1


