Return-Path: <kvm+bounces-12167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E4D8802A6
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C80671C21AE6
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2AD1798F;
	Tue, 19 Mar 2024 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VPPauEtw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56302208A1;
	Tue, 19 Mar 2024 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866685; cv=none; b=OEws/F/aurNmhNwqMXRBRALFT+31fDVHm50OehQcs+P2yZ/EFMPyjQVvK52BrH9iPIopPJquEcV3wskcYnC17otQ38bog3vWRHzLvLp3/4jFCXDB0lTXPHRaIi++JWCTPUr6HLC9ADOLRA8vLrq9h5dKd1njuZPwnMIZokyrAlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866685; c=relaxed/simple;
	bh=i7kPFXFJBnxsnKWbGIxgq669WYiKOTewKT1ClzlYNC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cb/zqERqf67DKGKSIAmrBxR7+4GL6mmt93WJO0l08ZpKlUUw1KaNoR5mMXgHN1IijrCJEYuXKfL0s30fjwgznhi3M8Ct76/MHCOWb1793426So9ENGATqMkq6kGLlUWTtL6KfRIYA0CeGbNHmzi69CmzTvcQ9sLv18HS7oVqz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VPPauEtw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42JGPh6g013870;
	Tue, 19 Mar 2024 16:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A2EMMp35xjopyzyXHi+YYmTRR2UohzKQHty1QJYLSSI=;
 b=VPPauEtwc+Y4yn+n4ZAkwdH5rNW5l2+FIqN5lW9dUsuAC9Dmis/6dPghmNZdkZEXi2eK
 UgSEseJIyp9fj3G1ABLTMOEH02YBMxfF+T5oPugrMQ3SxU44xQJW8ayh3svdyv+sHfwe
 TzdpYabE53GoyqkNmMmVfVXXdDeaJ+UydwvwISC7Z/mvOSdrZ7wxxQ+tcex8bY97Eodr
 P2bRuFD2a8oL1261No76cVYTmF9JFhfEe5HtSo7PCf0HT8oJkC3ZnEKWPQXIhggrdIKv
 HyzPtwKe04Z4bWrzM2yGEEvgaO71o3QBJglkivvL9MCI4VDRA7Y2CfIWX3F3FUS2+CD3 bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyb5ps3fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:41 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42JGieNo011728;
	Tue, 19 Mar 2024 16:44:40 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wyb5ps3fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:40 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42JGhKpX011615;
	Tue, 19 Mar 2024 16:44:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wwq8m0pa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42JGiXUF47710556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 16:44:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DF952005A;
	Tue, 19 Mar 2024 16:44:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F268220040;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH 2/2] KVM: s390: vsie: Use virt_to_phys for facility control block
Date: Tue, 19 Mar 2024 17:44:20 +0100
Message-Id: <20240319164420.4053380-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240319164420.4053380-1-nsg@linux.ibm.com>
References: <20240319164420.4053380-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GVvoP0BoWq9gnMm7sJAbK0SoBJpjk2Cq
X-Proofpoint-ORIG-GUID: jN2QESoqSejbF59F-UOdSC336KK_sQNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_05,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=923 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190126

In order for SIE to interpretively execute STFLE, it requires the real
or absolute address of a facility-list control block.
Before writing the location into the shadow SIE control block, convert
it from a virtual address.
We currently do not run into this bug because the lower 31 bits are the
same for virtual and physical addresses.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3af3bd20ac7b..da2819112e1d 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/bitmap.h>
 #include <linux/sched/signal.h>
+#include <linux/io.h>
 
 #include <asm/gmap.h>
 #include <asm/mmu_context.h>
@@ -1006,7 +1007,7 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if (read_guest_real(vcpu, fac, &vsie_page->fac,
 				    stfle_size() * sizeof(u64)))
 			return set_validity_icpt(scb_s, 0x1090U);
-		scb_s->fac = (__u32)(__u64) &vsie_page->fac;
+		scb_s->fac = (u32)virt_to_phys(&vsie_page->fac);
 	}
 	return 0;
 }
-- 
2.40.1


