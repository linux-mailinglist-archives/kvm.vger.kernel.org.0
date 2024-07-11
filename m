Return-Path: <kvm+bounces-21405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D881B92E5B5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 13:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08B2B1C225A0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 11:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D136716D4F1;
	Thu, 11 Jul 2024 11:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Uo8nZKiU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7B316D4EA;
	Thu, 11 Jul 2024 11:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696121; cv=none; b=KvvK46PNPZ9OqaXoueizUn0VbRggw0GEH8SpFkmZ9U6vSTBC813D2OHqvLfFsF+qhGx4kc10zDbM5Qj/c5dt7CTCTJ6jJSiMiNT/oROiVq0WsP+7Uxy5BwTGpAbWDNEsbrSNB21zMeoONFNb/u6SK3YdHgmnrqaF1XpTvOfBfeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696121; c=relaxed/simple;
	bh=IABTRFxquWcoENQEtDDW3l3TEiDDy6sa2JNxbsmZd/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzXHVoYoePrthB4TBunOhhXYx8kE4QsGnMXC3kdS+eTpkufOAD7TGhKdIbaIaA3Z1Px7AQgXjPmjHkPTtOem3MOwBs7w/wHcY+q9MZwP7a3n5QoJHDpi4dtm9/7Kj61ah0CqPyJnbE8tGVjcSsTE/1s0tKrYjOuvMy3x5wbGVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Uo8nZKiU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BARGpv023217;
	Thu, 11 Jul 2024 11:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=TXpiNzJHmycEc
	Bq86ON7M/jx2YamGeA/2VUwOpU/VgI=; b=Uo8nZKiUMVZR3+C3M/8OSA0lXCL0t
	DTqh3AEqEZhb1EjMfdqzJbApiqF9vpJ6Ex3rrugyvMbn1I/WS6mjl/cx6+Z+UtAN
	3yoOMsFgc1sbnNE52lwMXKIBl+63bRpK96B3IsnkgGQztG1A+6jaJgW1wt05SJ7x
	ZGftlEmxdlYfmGXKRgqAJDpsmHck3tHcwjQxL4CMy2hzkB4COO+afgME5J+a34ZH
	BvSm6HKyTPW+b90XROblmaysBUuuhliBaaVXZUZMPO2r7P8WJdu4V+L/Kmm9xeGC
	FuZtnIONe6ZHLIg6t5EhWe4yS9JRqNPrSmsreUGcl7IuiIGpt/ejrZW0Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40abwm8a20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:37 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46BB8bCS017463;
	Thu, 11 Jul 2024 11:08:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40abwm8a1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46B7vfGG013901;
	Thu, 11 Jul 2024 11:08:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 407gn10kbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46BB8UpI55706032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 11:08:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4F5C2004B;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE2052004D;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.boeblingen.de.ibm.com (unknown [9.152.224.253])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 2/3] KVM: s390: vsie: retry SIE instruction on host intercepts
Date: Thu, 11 Jul 2024 13:00:05 +0200
Message-ID: <20240711110654.40152-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711110654.40152-1-frankja@linux.ibm.com>
References: <20240711110654.40152-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6GYP1UT8Uib4f4Jdb0ujA7RIrcu5djoq
X-Proofpoint-ORIG-GUID: AVTjD2wkEPjIb4TH8tTC1pfM5CIsLMeE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_06,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=599
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110077

From: Eric Farman <farman@linux.ibm.com>

It's possible that SIE exits for work that the host needs to perform
rather than something that is intended for the guest.

A Linux guest will ignore this intercept code since there is nothing
for it to do, but a more robust solution would rewind the PSW back to
the SIE instruction. This will transparently resume the guest once
the host completes its work, without the guest needing to process
what is effectively a NOP and re-issue SIE itself.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20240301204342.3217540-1-farman@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240301204342.3217540-1-farman@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index c9ecae830634..54deafd0d698 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1304,10 +1304,24 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 		if (rc == -EAGAIN)
 			rc = 0;
-		if (rc || scb_s->icptcode || signal_pending(current) ||
-		    kvm_s390_vcpu_has_irq(vcpu, 0) ||
-		    kvm_s390_vcpu_sie_inhibited(vcpu))
+
+		/*
+		 * Exit the loop if the guest needs to process the intercept
+		 */
+		if (rc || scb_s->icptcode)
 			break;
+
+		/*
+		 * Exit the loop if the host needs to process an intercept,
+		 * but rewind the PSW to re-enter SIE once that's completed
+		 * instead of passing a "no action" intercept to the guest.
+		 */
+		if (signal_pending(current) ||
+		    kvm_s390_vcpu_has_irq(vcpu, 0) ||
+		    kvm_s390_vcpu_sie_inhibited(vcpu)) {
+			kvm_s390_rewind_psw(vcpu, 4);
+			break;
+		}
 		cond_resched();
 	}
 
@@ -1426,8 +1440,10 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
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
2.45.2


