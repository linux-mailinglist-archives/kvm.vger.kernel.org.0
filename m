Return-Path: <kvm+bounces-3157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D160180126C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8631C20CE6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595334F5F5;
	Fri,  1 Dec 2023 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n7f7Tn1m"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84247F9;
	Fri,  1 Dec 2023 10:17:10 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1HvSXM015657;
	Fri, 1 Dec 2023 18:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lfaGoSXvKE+GcZp9Tsg0uRDhD6slPSCvGZW8A+NNAIA=;
 b=n7f7Tn1mrSI7JXNVJe2OkRVtjPwqyOLn2I6qgBwO2jItRxKkvKA6wFu8eww3PddrhTFS
 WsD8SmcvcZABYoyb9QIj6c0gdRGASgOC0YdlXhEO2Kkt7Ch4mMeo0/AekzN4qnU0gqj/
 ig3uaVxH+HH4c+Pf8KGybyczbLDtJXwD1X4awfaJqzjmrLZ2VVuDWJ6Y87IXR9rJmL5l
 z/H7ERuraIOoxDov4wQZlooJrUo7ljcyDVedtMNTvmsWpYMMbnErPYd3yjkBOWY8bnW9
 gs4UrgvkGslgzyDDp2t47jo4rEjzCYQPZ0tGw3tZ1bkaTrfG1KmmoWisV9ZKXwPMs+pA hg== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqmb8rh45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 18:17:09 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1GVdRQ000708;
	Fri, 1 Dec 2023 18:17:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uku8tq5dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 18:17:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1IH5aM19006034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 18:17:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B2EF2004B;
	Fri,  1 Dec 2023 18:17:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A28020043;
	Fri,  1 Dec 2023 18:17:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  1 Dec 2023 18:17:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 2A18FE01D3; Fri,  1 Dec 2023 19:17:05 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: fix cc for successful PQAP
Date: Fri,  1 Dec 2023 19:16:57 +0100
Message-Id: <20231201181657.1614645-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UmUeKNMSx_S45Y6R-I2cZedo_50epEKY
X-Proofpoint-ORIG-GUID: UmUeKNMSx_S45Y6R-I2cZedo_50epEKY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_16,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=964
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010120

The various errors that are possible when processing a PQAP
instruction (the absence of a driver hook, an error FROM that
hook), all correctly set the PSW condition code to 3. But if
that processing works successfully, CC0 needs to be set to
convey that everything was fine.

Fix the check so that the guest can examine the condition code
to determine whether GPR1 has meaningful data.

Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 621a17fd1a1b..f875a404a0a0 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -676,8 +676,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.crypto.pqap_hook) {
 		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
 		ret = pqap_hook(vcpu);
-		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
-			kvm_s390_set_psw_cc(vcpu, 3);
+		if (!ret) {
+			if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
+				kvm_s390_set_psw_cc(vcpu, 3);
+			else
+				kvm_s390_set_psw_cc(vcpu, 0);
+		}
 		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
 		return ret;
 	}
-- 
2.40.1


