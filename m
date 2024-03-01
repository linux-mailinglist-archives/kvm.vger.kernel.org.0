Return-Path: <kvm+bounces-10693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D963D86EA88
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 21:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666991F22E7E
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519A83D555;
	Fri,  1 Mar 2024 20:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aBXXhKeZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6243D56E;
	Fri,  1 Mar 2024 20:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709325835; cv=none; b=becFf1PZO0gPwnY5cYEsJOGynC+hb0uX78cy/+7xm+zgPxbduVWrhPdvCPhc5CWESmL294/0fkzQHcDefWMY/B2BvchUym1iTT/ADQ0f4DPwyxPZNJRMKrYLfpLbLc/eXWPcJ2aFWlqPPWkftKEen22nc5y6UWtdeem4AjtAYMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709325835; c=relaxed/simple;
	bh=51Uf3kFC58rOpYfAttq8+yZjSU49IWuNMuMSRyOitBw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=obe9CbXxpXD2VjdP3YQNXz+a9O1bH3of3gIAuZvWEtptcRYKUgeJQ0w0JPHDZVwS5T7MJ7MUxBIxHwQJanMw+kkQJpztneZWqta1KCzmLcu+is7LxC/jMsDo8ITZdkhx1sEb7EiUzaHQ3WL33yw+pf/lCBXP1SVRN47X0wwmJYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aBXXhKeZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 421KgGrZ007039;
	Fri, 1 Mar 2024 20:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ydGBT0xPZvsFLbMhQUeawZ2Y0iiJGDIWTZi7AtGhAEo=;
 b=aBXXhKeZrsos35SSt9538sxBZB2uoAyeYL8Yd5KHbJYwd+cgvM6TrAK1l4G0WuLAT6pq
 4bt7Cq0mqcBGP8IIJaip2k1ir1HGKJ9dFjuZsaYMnbGHu4HSISUaQUTftYlRqcEC377j
 vquigP28cVEWlmBIrYFhGLq+Yho5lrsNslyOX8wdRG3My2WxaBm/mXBhNyG8MOQx3N1J
 YKbsA5thm46cAHwQU0m6XXHRxeByBUUb9Od281GEmq3W9auq301wX8DDbTckG9tTo9RT
 Brj2EYgTmrK3W91SPrAzdcFiZGxcmOOPUapqywYP4MTLfF+OI/S9KS0dz6VWdoHTzaDs wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wkp9mg0v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Mar 2024 20:43:52 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 421KgYwQ008461;
	Fri, 1 Mar 2024 20:43:52 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wkp9mg0ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Mar 2024 20:43:51 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 421IkkqE008852;
	Fri, 1 Mar 2024 20:43:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wftsu77u8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Mar 2024 20:43:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 421Khjb83080870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Mar 2024 20:43:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10C262004E;
	Fri,  1 Mar 2024 20:43:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0C2F2004B;
	Fri,  1 Mar 2024 20:43:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  1 Mar 2024 20:43:44 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 1EC51E01F3; Fri,  1 Mar 2024 21:43:44 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: vsie: retry SIE instruction on host intercepts
Date: Fri,  1 Mar 2024 21:43:42 +0100
Message-Id: <20240301204342.3217540-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T2rW6v16c8WURl6mAtP36kTM9_ZxtEte
X-Proofpoint-ORIG-GUID: ESQEe1PhCChPZN1yuDW4R-wBLwYgv6uu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_21,2024-03-01_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=900 priorityscore=1501 clxscore=1015 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403010172

It's possible that SIE exits for work that the host needs to perform
rather than something that is intended for the guest.

A Linux guest will ignore this intercept code since there is nothing
for it to do, but a more robust solution would rewind the PSW back to
the SIE instruction. This will transparently resume the guest once
the host completes its work, without the guest needing to process
what is effectively a NOP and re-issue SIE itself.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 8f0f944f81c2..63aae70a6790 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1306,10 +1306,24 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 		if (rc == -EAGAIN)
 			rc = 0;
-		if (rc || scb_s->icptcode || signal_pending(current) ||
+
+		/*
+		 * Exit the loop if the guest needs to process the intercept
+		 */
+		if (rc || scb_s->icptcode)
+			break;
+
+		/*
+		 * Exit the loop if the host needs to process an intercept,
+		 * but rewind the PSW to re-enter SIE once that's completed
+		 * instead of passing a "no action" intercept to the guest.
+		 */
+		if (signal_pending(current) ||
 		    kvm_s390_vcpu_has_irq(vcpu, 0) ||
-		    kvm_s390_vcpu_sie_inhibited(vcpu))
+		    kvm_s390_vcpu_sie_inhibited(vcpu)) {
+			kvm_s390_rewind_psw(vcpu, 4);
 			break;
+		}
 		cond_resched();
 	}
 
@@ -1428,8 +1442,10 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	if (signal_pending(current) || kvm_s390_vcpu_has_irq(vcpu, 0) ||
-	    kvm_s390_vcpu_sie_inhibited(vcpu))
+	    kvm_s390_vcpu_sie_inhibited(vcpu)) {
+		kvm_s390_rewind_psw(vcpu, 4);
 		return 0;
+	}
 
 	vsie_page = get_vsie_page(vcpu->kvm, scb_addr);
 	if (IS_ERR(vsie_page))
-- 
2.40.1


