Return-Path: <kvm+bounces-8046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA4984A8C3
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ACE11C28990
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22C15A10C;
	Mon,  5 Feb 2024 21:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QBNcIh0q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35435A106;
	Mon,  5 Feb 2024 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707169619; cv=none; b=GFO5MibmohFTcWNI7o+X/ezHw7HzLvTVBG4hY3yUEx1tS6NskGP3EGKbsN+XezsM+bUFr+o7Jzm0UDbBuFXi0bTw88iKGbbO3EBCKIeCSTqX8qNtSLIP6pzN8lMCeVBbWIaD4tgKKkw7TK8Z41hVYNisL5nGVs9bgrnDTQaf21M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707169619; c=relaxed/simple;
	bh=ADdQeqHsq6c4cbNHVMMeUNxJsYyvOeLIh6RTYLgnQGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OQeULzkjDNOn5TPa+TtbYAX4WDN3RFucfG5upbBmAVuSAGgBSTtWekvLASxvy6BUzZ/03+o1afDzLKi7IYSHFQzwYEAwuMt38jbJLdyKIhA/lS6DeRjWMEWg9kASv1OLMixW61tZEE3hLokYbXEDOrGM/6UbxrO2nPruko55C9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QBNcIh0q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LRDlf015176;
	Mon, 5 Feb 2024 21:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=exwJpbKaDberRRtjsXNCtxC05LphlcH4pYtrKJjjGZo=;
 b=QBNcIh0qQjlPVtM8nhi5kFDdAD+MCW6hXfQRLzjF6dSQLSYN1yie0dhIyoX1+zuhbczC
 kbRO5q5xvZhfHosh4uUTau4HPm4jLbqjR2bf+0KyQ+5SZzbdzXV/gk6BkIcy+DFwgPKC
 y9uNjjRrGg9mSGBvW2zjH5906V0Ng+xSYF3ZXIQP/ezIZCrOMM1oe/FYQHgPusplzLlC
 5kU343kn8vUbgXk115qINp3arv6KMMSjKrgfTN5/PbwLQNsF0raFVN2MaZGeT/muRJ2i
 Vho8NXA2/7+NC0q2nPvlm8bXmhW76zPrFPYJCJHmAsI8TIj7n5Yd9OkePD+lP9jCqsWn 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w37kqrdw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 21:46:56 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415Lkukd006438;
	Mon, 5 Feb 2024 21:46:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w37kqrdn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 21:46:55 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415Jjq29014865;
	Mon, 5 Feb 2024 21:43:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tnk32t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 21:43:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415Lh2cV43188818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 21:43:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 612AA2004B;
	Mon,  5 Feb 2024 21:43:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5054920043;
	Mon,  5 Feb 2024 21:43:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Feb 2024 21:43:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 1CB6BE050E; Mon,  5 Feb 2024 22:43:02 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: only deliver the set service event bits
Date: Mon,  5 Feb 2024 22:43:00 +0100
Message-Id: <20240205214300.1018522-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l7YgtaTJbLjyUcohnal6N8ymwYdSn__K
X-Proofpoint-GUID: MWx81qCgV0LdOyGB5Vq_lDomgFh49Tqh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=790
 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050163

The SCLP driver code masks off the last two bits of the parameter [1]
to determine if a read is required, but doesn't care about the
contents of those bits. Meanwhile, the KVM code that delivers
event interrupts masks off those two bits but sends both to the
guest, even if only one was specified by userspace [2].

This works for the driver code, but it means any nuances of those
bits gets lost. Use the event pending mask as an actual mask, and
only send the bit(s) that were specified in the pending interrupt.

[1] Linux: sclp_interrupt_handler() (drivers/s390/char/sclp.c:658)
[2] QEMU: service_interrupt() (hw/s390x/sclp.c:360..363)

Fixes: 0890ddea1a90 ("KVM: s390: protvirt: Add SCLP interrupt handling")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index fc4007cc067a..20e080e9150b 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1031,7 +1031,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 	ext = fi->srv_signal;
-	/* only clear the event bit */
+	/* only clear the event bits */
 	fi->srv_signal.ext_params &= ~SCCB_EVENT_PENDING;
 	clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
 	spin_unlock(&fi->lock);
@@ -1041,7 +1041,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
-	return write_sclp(vcpu, SCCB_EVENT_PENDING);
+	return write_sclp(vcpu, ext.ext_params & SCCB_EVENT_PENDING);
 }
 
 static int __must_check __deliver_pfault_done(struct kvm_vcpu *vcpu)
-- 
2.40.1


