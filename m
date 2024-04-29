Return-Path: <kvm+bounces-16180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 634718B5FDD
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94D1AB2346C
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD77386AE9;
	Mon, 29 Apr 2024 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a9QXqmc7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284283CBA;
	Mon, 29 Apr 2024 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410925; cv=none; b=DnyoUye5LJytN2vJp4j7/YvJNYF+D5m+1M1ybIw13kOjGPHrUGM6mscNUNtvnaO5ijTOJ5Cv2AKYGQlHjNKgVjSw4THHyb4bGZlIS8VKl2j3iMo8yRERhjumuwBh5za8snj1bi7i8NyHbUlu3tRNTeC1HBJRHJI03ufCuBNlE5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410925; c=relaxed/simple;
	bh=VP3HFtZH5mVhVC5OJXQaqpA4OP5AvOuBK0xAvVAVqIw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hypUSEJhXLSERzvOhlqbjeIhl/uyJS2BF7GojWFK0iPUjuax1bnjsEgzD1sP5imoNIJyOJ8zebcSNucVJ3ybZg4tQeASJEa9nt7FZYBpeyHRzXLSWWKmjuf1mqoz3WgJJzk0YWXqiilWQaEYPKscYhme1ZMQ3Y5xGQLkk01m/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a9QXqmc7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TGlwlO027112;
	Mon, 29 Apr 2024 17:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1ZEeUbJSgd/FznoOFx/46ZsQxvaZ7TORAHHAvhlCKk4=;
 b=a9QXqmc7pGFZBEUZIS0mtX72GgcNqJ5v1PVqmwlbgT9oro97jfPGLo1PqgQFdE8sX2Fj
 wu6Mj3wZRSDF590C8uBYrKNoZ6uiPvc3yA94LyDDu6e1DWd6eiNEn9SHwCkTrou20jSs
 uh5lGfZvZpUwzMhXoHK66aCavHqh3Wd7o5VcvIIf6nL1z5wVCQrEZZH0SybWUOGSCSK4
 TOXslGb0alxj2t3ILLcQsDGkKG4m2ki5oqwNXghhjYLV+OxW22UBaWec2rVNJlepnl4X
 DIBQG5kdvKFJ6xKxhehwtqMyo8/X4JTMfPJlyqBVafr9N8fCdQCF/60Hb3+Aiy5jSToy kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtfcnr2a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:15:21 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43THFKGS003219;
	Mon, 29 Apr 2024 17:15:20 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtfcnr2a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:15:20 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43TGVHHR015582;
	Mon, 29 Apr 2024 17:15:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xsed2r4cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 17:15:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43THFEY043909566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 17:15:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 557412004B;
	Mon, 29 Apr 2024 17:15:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2242A20043;
	Mon, 29 Apr 2024 17:15:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 29 Apr 2024 17:15:14 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH] s390/kvm/vsie: Use virt_to_phys for crypto control block
Date: Mon, 29 Apr 2024 19:15:12 +0200
Message-Id: <20240429171512.879215-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iImK1c6xl_QeZmmlj99npiOYPKHaZXVY
X-Proofpoint-ORIG-GUID: ISSFKbLpKxQrN-D_UdIdGf6oBfoTDydX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_14,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404290110

The address of the crypto control block in the (shadow) SIE block is
absolute/physical.
Convert from virtual to physical when shadowing the guest's control
block during VSIE.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b2c9f010f0fe..24defeada00c 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -361,7 +361,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	case -EACCES:
 		return set_validity_icpt(scb_s, 0x003CU);
 	}
-	scb_s->crycbd = ((__u32)(__u64) &vsie_page->crycb) | CRYCB_FORMAT2;
+	scb_s->crycbd = (u32)virt_to_phys(&vsie_page->crycb) | CRYCB_FORMAT2;
 	return 0;
 }
 

base-commit: b947cc5bf6d793101135265352e205aeb30b54f0
-- 
2.40.1


