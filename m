Return-Path: <kvm+bounces-28368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2948E997F31
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85C4AB25295
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4268F1CEAAF;
	Thu, 10 Oct 2024 07:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q86I1zmd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F8C1CDFC7;
	Thu, 10 Oct 2024 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544357; cv=none; b=i1pzDlLcf0QmCzsIqCt2TXj0GpHrXacrXvt5cnvDkC210isTeS8sMoazVwiTzsO8JEgJ5F+6BFu7zHJep/GyXnhgLr5BuXMXD2uXnxv9w3MZMEyV63SHtBkIzsjivVmzbyesDReLsXt8Ym31swIH7siRVbK3OF3b9t//6B33X1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544357; c=relaxed/simple;
	bh=60AIUvEIO5ShnTtq9IwCjZTgsZLM713StqdUbqvB79M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYqzKoK3TUxhoxQSLsnemljKfYkIm8KB93LQ6CEbwU9zGLAUW1CjYHYt+TnxXWBl1JSz8i6wS94iLzocHIpDZ1egFBwGAGzmda3fgWB63EBg8kz8Y62aRKO59o5Psnjv09/AbvUoDHx5QQcturhfMNl+j1s/tOeOA2ZiAOeJhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q86I1zmd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A73bSj015830;
	Thu, 10 Oct 2024 07:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=A7ZMEdNmTgiN7
	NsGdNH6Pv8P47YEkBKClc7VeU53JJg=; b=q86I1zmdyBtoNRtEt+2QRFDnjFqJj
	U8uBAVVKSh+OuCY4HRZq9tQvb5MXEG7kOB4zQOUrYUM0Nzdc1mb8hUUGO4vKBEdG
	EaKaVe221xVFdcerXlTqwnuT5l0EVQICJeTx6yYdskk3Kj+5MimI+ZhCGXc3APlR
	fC/AQdlAKoEyxxSuaZTf+/xqWLz2GtDKsrFGDuTo7V6oHDTfcm+sf0g+KHjq8RzG
	9Ey8K7ulRWUakc+6ZnUqd2Kd5uEn4Dj7rjXwh5DADMcTMFNzkcwVEFZcWHW2qe6X
	I3I+L1qGgH3j9K3iy9S8MdcSULZ3iidT222/7WJ0Op3+AQLEFC6fo39kw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mg1dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A7CY2G001884;
	Thu, 10 Oct 2024 07:12:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 426a6mg1dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A6D0hs030153;
	Thu, 10 Oct 2024 07:12:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423gsmxbxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 07:12:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A7CTjb47186362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 07:12:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4667820040;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 216532005A;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 07:12:29 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/2] s390x: edat: move LC_SIZE to arch_def.h
Date: Thu, 10 Oct 2024 09:11:51 +0200
Message-ID: <20241010071228.565038-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010071228.565038-1-nrb@linux.ibm.com>
References: <20241010071228.565038-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7_eBEHXqQ_b5Uk4JkT35k0G5wWWkYqHK
X-Proofpoint-GUID: Uf6j3Twq95pJ7ttt3Rg4d1JdNHHCjs_E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_04,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410100045

struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
tests as well, therefore move it to arch_def.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 1 +
 s390x/edat.c             | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a33878de5..5574a45156a9 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -119,6 +119,7 @@ enum address_space {
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
 
+#define LC_SIZE	(2 * PAGE_SIZE)
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397017c..e664b09d9633 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -17,7 +17,6 @@
 
 #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
 
-#define LC_SIZE	(2 * PAGE_SIZE)
 #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
 
 static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
-- 
2.46.2


