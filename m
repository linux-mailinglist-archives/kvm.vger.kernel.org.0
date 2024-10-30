Return-Path: <kvm+bounces-30057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11ADD9B68FF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC0E51F215D7
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A682141BF;
	Wed, 30 Oct 2024 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TbklLI9T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5023E1E47AE;
	Wed, 30 Oct 2024 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305155; cv=none; b=nOkzrvJF2HOx3LjyxtrbDGwY3wwHTr7kroKqfKhOmC2TtzB84IeAPu2blpwMQGDFbMtw6j0y7TI4qwkswz1CfjufWNFDCKFgFgnYqaWcbZs+9Gvy36Md3hroGL0RX96Zb3vw+3qaIlVe2ahMMmBWQMKsOhi0ZCirZZWoWk3OuNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305155; c=relaxed/simple;
	bh=Nckac5vAtB0LygOEXU3idMYwsLOU9AILN8PwmIR2DtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XF64Q+4nU+m6usuHmuOUbjPnLzlZ9CdV5kjLdj6I+ljJb9iYzq28Yqbra+10wK0HM/dph6vxGHkzCwkTIi5cRFmuIFyENfpHagaiBdgnNHnHuZl9T/TDfVz+ytvLziBBp4m1sb/ddqUiiQKfP/wI8YiSLQTf2glsCzo1ssXr2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TbklLI9T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw8kT013425;
	Wed, 30 Oct 2024 16:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=6C4D8xUZG8WRxij2h8xKKNS0r4KZPt7g2jSwTOeK9
	0s=; b=TbklLI9TA/3tEpLDIpXKXzIOAc4tWtACyPjyVPnHVWMvUwy5TKnFnCo+j
	v1fj+t8zNUq50b+e+ArFjxruNgYMBP9azM/tB/XKbR7z4Cz37M8dSs6IfxhwmDPW
	nvwpZFFZMU++Jn9rOGObjvy8aeaAhHXlqPXpcrUl/q97e7uS3GzOT85Cw7kDd+fo
	zAqttaPrQIFglJZuOafZiHeNJ4iK/Uyjdv2r5aVJ6Bmg35aAylEIotPRVKT+7ZEl
	eWpy+30s6jY7h7q6Gr2+pJ6TJeEqXvwg78cmCVh9uW9Rz2CVYkFc3SS8Y6E0iqOB
	3TCQKlbaimuS0LM9gPvoFm2Oo0QRQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65kj6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:19:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UFoMiK028211;
	Wed, 30 Oct 2024 16:19:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hb4y0wv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:19:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UGJ7eJ47776182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:19:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E9B12004B;
	Wed, 30 Oct 2024 16:19:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F44720040;
	Wed, 30 Oct 2024 16:19:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.78.172])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Oct 2024 16:19:06 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] s390/kvm: initialize uninitialized flags variable
Date: Wed, 30 Oct 2024 17:19:06 +0100
Message-ID: <20241030161906.85476-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n0DhsfomksrXfYjWaklAesb0ujJhztk6
X-Proofpoint-GUID: n0DhsfomksrXfYjWaklAesb0ujJhztk6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=748
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300127

The flags variable was being used uninitialized.
Initialize it to 0 as expected.

For some reason neither gcc nor clang reported a warning.

Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a5750c14bb4d..8b3afda99397 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4729,8 +4729,8 @@ static int vcpu_post_run_addressing_exception(struct kvm_vcpu *vcpu)
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
+	unsigned int flags = 0;
 	unsigned long gaddr;
-	unsigned int flags;
 	int rc = 0;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
-- 
2.47.0


