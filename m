Return-Path: <kvm+bounces-9858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5811B8674C8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE1751F2CA0D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E754F604D7;
	Mon, 26 Feb 2024 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FBy4S5n2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CF5FDB5;
	Mon, 26 Feb 2024 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708950316; cv=none; b=fQFeHMfgAvrX4kbXDw22FdKp8op02oRH9ETqKu2o61G5IyJn5CgWxcvGHfxxTRBRGuAIihYtXB3vv2WIXJzyM5rLKT4ORGdh2q5tPIfYbDpFIZSkVE96WtgSfSmVTGxQXHLOYEYJI6LDiMDVOeFmmlJtxTeYS360HCbMZIu2E1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708950316; c=relaxed/simple;
	bh=KVjlE6bft1KW9DYhwgFiOuTQfTc2SbGa1PnHQHemBBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/8EgjajA88Mq2lOZa4VLSYXjMnsGuc1WDEqbgBWZSc7j0ZAMO7gOd0BR4n9qpQJcWndQDNIFbVweMvRhlfXpphz/7Yux2Jh9s8BfzaOWCpBV5iN+h6kU9kM+l5hISZBpKWUMKYqGZTayvKAd00NBXi4hPNnw0husoUSIPOCX5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FBy4S5n2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QBviqt017715;
	Mon, 26 Feb 2024 12:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uDyZV07FmYvXG5qifeD+746o5SkW+wy29geRf4gWwyA=;
 b=FBy4S5n2ZCIoUPBUZJL8Kf+MC1Wj7d4TElqBPArG69PNOlx52/PGjHnlnPhtZVdUfAYo
 KaEyDMT8lXad/IeVcPrg1g4v+H/qLNTtIZnWjkUgJm1X4Hdi5G2eOgb/i9l6wkBZABzq
 0s4ny9KBjoDIRfzt3ry75ApO6NRYo/YIiSyF2W1BMK+EfxsTtBK43i1rawTFPfd2T6XX
 cs14Q+YER5TBm5NbQKX7PqN9gSNek81PYZ3hG51KqfuC5O8E8EYwfmk2KxEJ5y148jdI
 V5kRGPCrGgBnMdAcHblZJLCaPZisOjGrXtcLNlSzo6HKXKQXZMSJ/JYbg9rPZNMkmEMq nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgt7mrhyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:25:12 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41QCKUhZ013341;
	Mon, 26 Feb 2024 12:25:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgt7mrheb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:25:11 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41QAmiAG021762;
	Mon, 26 Feb 2024 12:22:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wfu5ys3p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:15 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41QCMAUY29884730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 12:22:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E3D92004E;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62C212004B;
	Mon, 26 Feb 2024 12:22:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.77.191])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Feb 2024 12:22:09 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, farman@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [GIT PULL 1/3] KVM: s390: fix virtual vs physical address confusion
Date: Mon, 26 Feb 2024 13:13:06 +0100
Message-ID: <20240226122059.58099-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240226122059.58099-1-frankja@linux.ibm.com>
References: <20240226122059.58099-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dUgDTmDwgAd834gAFcNN3hFk2ZgigMPA
X-Proofpoint-ORIG-GUID: YJ7-Ha8_cyvsKS7sH8qTJXmjDUuIKaMC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_09,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 spamscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260094

From: Alexander Gordeev <agordeev@linux.ibm.com>

Fix virtual vs physical address confusion. This does not fix a bug
since virtual and physical address spaces are currently the same.

Suggested-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ea63ac769889..6635a7acef34 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3153,7 +3153,7 @@ static int kvm_s390_apxa_installed(void)
  */
 static void kvm_s390_set_crycb_format(struct kvm *kvm)
 {
-	kvm->arch.crypto.crycbd = (__u32)(unsigned long) kvm->arch.crypto.crycb;
+	kvm->arch.crypto.crycbd = virt_to_phys(kvm->arch.crypto.crycb);
 
 	/* Clear the CRYCB format bits - i.e., set format 0 by default */
 	kvm->arch.crypto.crycbd &= ~(CRYCB_FORMAT_MASK);
-- 
2.43.2


