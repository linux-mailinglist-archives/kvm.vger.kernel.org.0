Return-Path: <kvm+bounces-32516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E259D9583
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F4FB28668D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEC81CEE8F;
	Tue, 26 Nov 2024 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OTIfFaW5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE751BFE0C;
	Tue, 26 Nov 2024 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616726; cv=none; b=Ts5T5CLgWkEJL+buqBPmVU4lZC71zo3tSZ96/t3z04KX/Gax6aCGf0OFvRKpPOOXe+Kr3mgtJfJcoiIQRuo1VVmt5WurgBk+wqaUId4sXVQD45QxHBzQwlVuSANEwTRyE4sHvdqHPkrR8p0mpJ9bW4gMEN6YO71KRzN03Rejhoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616726; c=relaxed/simple;
	bh=FEpL1IOF8+ltMuh06dQGAsVOw0X3hxr6rWhTcxqXkug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQukzTeclQMHHfewNO+7KYBzaFQdRWUez9mOt9KS7tQCUf2Ey/mYZWDv57O9K6rBdGDJmAIEz9Z0s/ZDKnLPG9gnkkwUepR2odl59YZnG9RSskCtxd+V2MXXUjuKLTRYnZ0oT/HGeP0p8jZfAp4fp/R6v3pH70uKs9sPMGpYUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OTIfFaW5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQAP5ww026650;
	Tue, 26 Nov 2024 10:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0Auzg5QUc+i6/wRwO
	FadlhiRjLMjnW/UyNhRIKy2ddA=; b=OTIfFaW5d+cRc9In7DEJuRLDmGh3YE/uf
	VnlfvcEOWhCUzZ1twtPo7IUt5Tny0RG0iaOPS5IP/+Qyfdl8B+eGpTPdq/G2S3Qp
	OD+cauk+pzHt0C1bqkY1pr2wfzRInLFhB9+bNYnEtaBRXv+cSIb9stu1nNVildYH
	381AIRI7CsK12Yj3UaLnzBrx8CkJywX6KmPYsYu1/XNu3HcvRa67SSd56SVcfeEm
	bbtdCknjwFhBn9Gg6H7ITx3EFPo8N4OAr1zffJAGK4/6TEKBlx4CeUl+/WnvUYod
	RWIlFl0Y9T3vN1ZHVyGCEQxLkU/lkSU5Em6qNZqU6HxkQqzDPdD3Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4350rhjsup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ4mB3v026337;
	Tue, 26 Nov 2024 10:25:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 433v30v44u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQAPG8X17039676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 10:25:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0AF22007A;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CEA120072;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: s390: Increase size of union sca_utility to four bytes
Date: Tue, 26 Nov 2024 11:25:15 +0100
Message-ID: <20241126102515.3178914-4-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241126102515.3178914-1-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ORVJqAXtxQzjV-c0v6KcYgqQt0kr4q7F
X-Proofpoint-ORIG-GUID: ORVJqAXtxQzjV-c0v6KcYgqQt0kr4q7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411260079

kvm_s390_update_topology_change_report() modifies a single bit within
sca_utility using cmpxchg(). Given that the size of the sca_utility union
is two bytes this generates very inefficient code. Change the size to four
bytes, so better code can be generated.

Even though the size of sca_utility doesn't reflect architecture anymore
this seems to be the easiest and most pragmatic approach to avoid
inefficient code.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1cd8eaebd3c0..1cb1de232b9e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -95,10 +95,10 @@ union ipte_control {
 };
 
 union sca_utility {
-	__u16 val;
+	__u32 val;
 	struct {
-		__u16 mtcr : 1;
-		__u16 reserved : 15;
+		__u32 mtcr : 1;
+		__u32	   : 31;
 	};
 };
 
@@ -107,7 +107,7 @@ struct bsca_block {
 	__u64	reserved[5];
 	__u64	mcn;
 	union sca_utility utility;
-	__u8	reserved2[6];
+	__u8	reserved2[4];
 	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
 };
 
@@ -115,7 +115,7 @@ struct esca_block {
 	union ipte_control ipte_control;
 	__u64   reserved1[6];
 	union sca_utility utility;
-	__u8	reserved2[6];
+	__u8	reserved2[4];
 	__u64   mcn[4];
 	__u64   reserved3[20];
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
-- 
2.45.2


