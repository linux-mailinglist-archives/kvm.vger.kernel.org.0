Return-Path: <kvm+bounces-1227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B54D7E5C1E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12D5FB210E6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403B4321BB;
	Wed,  8 Nov 2023 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="prgYej4t"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0AD30359
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:12:37 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39961BC3;
	Wed,  8 Nov 2023 09:12:36 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8G0XXp009876;
	Wed, 8 Nov 2023 17:12:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sb1jNJWcf0Des609yZa4DqHxbtt1v4z3KOzytpH2Uz0=;
 b=prgYej4twDcO3WWowB6p9F0CFpXX4WRTL3QjoNMC6/OHCP2aPwd48Qx79WsIdDPfjtCY
 tgQGRSSOpy04gPLKYt8LqihhS0KoU9vLcsYIrDBfNrXvIe5nSW5uECnSH/n052w0Ft3G
 r4hBQjZ/zpMySsHnIDj1W4wISIXRaDLCGtMXhnI0JVb2ykihroYtzDJyfxXnMKF6lACy
 4pNivLxhq92njiFfXK72GoW9sM6A4dfsxj1MkSCLFZWWjJeMsEut40Cv9SOgYZlrJCb7
 Nu78sjAS40QfljKGT08+nz1SLNdaG+zGLice89k/r8Hj6IvOAE6speaigkOs+qBgL1Uj wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dfk2vpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:35 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8H9F0k032043;
	Wed, 8 Nov 2023 17:12:35 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dfk2vpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:35 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GNBX7014309;
	Wed, 8 Nov 2023 17:12:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21xa13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8HCVkU24511102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 17:12:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87CBF20043;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C0C92004B;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        kvm@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: s390: vsie: Fix STFLE interpretive execution identification
Date: Wed,  8 Nov 2023 18:12:26 +0100
Message-Id: <20231108171229.3404476-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231108171229.3404476-1-nsg@linux.ibm.com>
References: <20231108171229.3404476-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MXXzvTPP4V2uH69Ao2XZX2xy8oF102eZ
X-Proofpoint-GUID: r91Tib7Gwe_f691GO5TFSPnbSmh93gx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_05,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311080141

STFLE can be interpretively executed.
This occurs when the facility list designation is unequal to zero.
Perform the check before applying the address mask instead of after.

Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 61499293c2ac..d989772fe211 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -988,9 +988,10 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
 static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	__u32 fac = READ_ONCE(vsie_page->scb_o->fac) & 0x7ffffff8U;
+	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
 
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
+		fac = fac & 0x7ffffff8U;
 		retry_vsie_icpt(vsie_page);
 		if (read_guest_real(vcpu, fac, &vsie_page->fac,
 				    sizeof(vsie_page->fac)))
-- 
2.39.2


