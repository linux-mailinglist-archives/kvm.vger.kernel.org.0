Return-Path: <kvm+bounces-9857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 513958674C3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B89541F2C81A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56259604DE;
	Mon, 26 Feb 2024 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lqz3LSMa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08687604AC;
	Mon, 26 Feb 2024 12:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708950298; cv=none; b=BPkkeqmr6Usjb8p7eeufrlTpravtuDqvS9PgSokedac6MNBHoqRuVAqd5zFM6Zh9zFmUSnzsPlGc9M11fCV9vyq/U3f61SvRhDwVvo8mUsyr9I3A+bemD3I6LDQN+eg9nbMQAE3pu2R8Qsr/WtQ9dGP/mZSQrygLUAmLBJTl+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708950298; c=relaxed/simple;
	bh=G134br+7cQPlC0mne7n5f1kl9NJaiZGtZ7MySetIKn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph+PAZLLO2Hl1FbQRkiwicaTlPOnVX9ai04NsDsMlgrZP5WJB8CspnLho0RNX4tDZTMJHSDoJKixzCL0y0xB8w5fmV2a003GzQJMoTZ1UTLLfkylH2M28j4iI+YmN8++LmUXlred6MBJ0NTRx2RJURkg+vc4Ip1AXby4HeOMTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lqz3LSMa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QAjVjn000332;
	Mon, 26 Feb 2024 12:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=kvNKxyBwV5fPEikynXGvQi/BhzabOFSP5k479+v5g6M=;
 b=lqz3LSMaPZEfvDH5N+OH7ZujZVm1UR+FrTC2SZeOGqAT/4hbaGpDEU/Wxi/6wULDaXUu
 PKjrD7Me7BkExtjPZS7yWEx8At6Y1a8AePSyKUFBQi5dknjJ//3nFZGf4MVhaUbY8z+K
 vxa4/gIhf+a4YjnPxcXeqwnFTC23Al7WoyHIkKhmNr0qC47xu8wVzw0J2gcq+S46rwIT
 AMzc7Qh1cY451H4sWwCsDi6E4fT4cs197cZm3ASt/1LomPD4bpEN6qOn0dmlPqCJezV/
 22+QyyAi0Cu30Syg8LzxASolXioWC3dCVrZ/D8l7/lstcBDNfW61XBMRWgg7oboTF5tE Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgpbkwtch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:24:55 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41QC0OE7010174;
	Mon, 26 Feb 2024 12:24:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgpbkwsst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:24:53 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41QAi0aT008787;
	Mon, 26 Feb 2024 12:22:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wftst985x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41QCMAUB4850362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 12:22:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DACF72004F;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3511E2004B;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.77.191])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Feb 2024 12:22:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, farman@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [GIT PULL 2/3] KVM: s390: only deliver the set service event bits
Date: Mon, 26 Feb 2024 13:13:07 +0100
Message-ID: <20240226122059.58099-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240226122059.58099-1-frankja@linux.ibm.com>
References: <20240226122059.58099-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ca3jHRKEHVKaPxrVSiFGJyfQvmLDutrU
X-Proofpoint-ORIG-GUID: 1EFHYtXUwNdytRXsGALmf18zVLcWOMiE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_09,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=722 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260094

From: Eric Farman <farman@linux.ibm.com>

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
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240205214300.1018522-1-farman@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20240205214300.1018522-1-farman@linux.ibm.com>
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
2.43.2


