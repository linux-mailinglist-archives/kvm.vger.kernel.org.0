Return-Path: <kvm+bounces-30170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4569B7A30
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 352B41F235C5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C60319C54F;
	Thu, 31 Oct 2024 12:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qqJjygng"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9007E1BC20;
	Thu, 31 Oct 2024 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730376204; cv=none; b=d2xqgD4ZKL0yA9W/NE51u9qNGSvL26eqKt4WULYHElyJ12W/t1JjTwQ6vFo6MKAxBz2NDHpWQbfy35QNU5/Wg3xiUpOJXzmVVs6HS19irJOjhoSgr5Q/OhlQMpqRg/cwN88gl1EwLK7pWVgAyl06uBUDrQdbNamgm6Lzgzj+v9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730376204; c=relaxed/simple;
	bh=Qg4mJxs4fXCmXS7KB5laOTg+7yxkd7M8r4nAAkZ9adQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KfM96zXXUrJF/f1vlUD0A3Q9pLyLAzcIQOU8PV5WSBc8vHGlJVfipmG+l61EPehHqdhvfPBWl0b6mpJoC4Qitjhrw5VJKfMSpjQn9XMqfjcT0CYymYdJ4zrT9WPcyUHJWoBn7K3aqI4gYfZgqPqZBfN0V88W9UO7V2foHS9xg9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qqJjygng; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V6vL49013181;
	Thu, 31 Oct 2024 12:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=9APeEwQXPLuuVKK42xBYkPKUFePEi9WFCzuJSO91+
	GE=; b=qqJjygngaYB5kwBLfuqTHlQH2fza25uBLy7IB6m9ylAPeEqz0yOhQaZq2
	7uwmZC6QGWzFT1tKjtfO5FkcvRUJGtQ8RaQij8zpSdj7/UbltIBWGVrKwYgIMm0C
	Npjg9W6nyFaxazNelj5q37KZR3sbafLkFMnKAELpLCFRHdvAOrXF1mVeAi2XG3U2
	s3FaGsr6Zz1qoM7/X0ZbzvaLrO16SCVCCTyzaEqZXxW0K3BEqgNDXMvIyWTztiu8
	aqJPYRPsyLvMbYIshgr1F4Sbxtf4y+V8Ey0wyyDshM5oqp26DEKwbhWGxmxM0otW
	yUpFhl1JM8WvFR6qyAdHtV6HrFpqg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42m52c97rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 12:03:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VBI8p4015899;
	Thu, 31 Oct 2024 12:03:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hdf1mbxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 12:03:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VC3H0t40698144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 12:03:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F66320043;
	Thu, 31 Oct 2024 12:03:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83FAC2004B;
	Thu, 31 Oct 2024 12:03:16 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.69.120])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 31 Oct 2024 12:03:16 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] s390/kvm: mask extra bits from program interrupt code
Date: Thu, 31 Oct 2024 13:03:16 +0100
Message-ID: <20241031120316.25462-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qj_0wnjad3No7P3g8mDomxTi9CIg2yz4
X-Proofpoint-ORIG-GUID: Qj_0wnjad3No7P3g8mDomxTi9CIg2yz4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=587 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410310091

The program interrupt code has some extra bits that are sometimes set
by hardware for various reasons; those bits should be ignored when the
program interrupt number is needed for interrupt handling.

Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8b3afda99397..f2d1351f6992 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4737,7 +4737,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	if (kvm_s390_cur_gmap_fault_is_write())
 		flags = FAULT_FLAG_WRITE;
 
-	switch (current->thread.gmap_int_code) {
+	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
 		vcpu->stat.exit_null++;
 		break;
-- 
2.47.0


