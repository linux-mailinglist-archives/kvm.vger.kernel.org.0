Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A51433DD9
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhJSR40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:56:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233537AbhJSR4Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:56:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JFrCix017923;
        Tue, 19 Oct 2021 13:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=41DarxAFZoGQIImuCAU1xxEyyyzJdxPe1CgKHwMex3Q=;
 b=SOI4MtIY6Tl2LwrTQi1QnOwq8e0YZcneMLezsM5W5+BZjsZyMT0Qx4MooZgq6hrT1bNC
 kgsD4eoyFKLfqIIWLUzP92Typ61gUhNGAi8bJzEdI1cdUFkBat9arPY/T+t2oNQ3seOv
 vetcvtJTVSZ1jT/bH5LxpvQdvVjoCAfwe4GtKU2gIgKccwWa9Mf19Hp2td9U38+d6Hiu
 3igJV/jkchHBvbLE51+PmfpBwjpI4b1K578TDpkDRVbcwUyBfEpYy7j/sxOUlZx6sRVc
 cPi4QHvNsyjI31yVrjbHxJz8UXlkcJGZnRd40qbJnJS93W6YVx3Opk8UuqOulI5SzlMj pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt129avjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:11 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JFsZ3r028273;
        Tue, 19 Oct 2021 13:54:11 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt129avhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:10 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JHqCWD011331;
        Tue, 19 Oct 2021 17:54:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3bqpca2r8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:54:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JHs5VD50856230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 17:54:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD277AE055;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FFC1AE045;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
Date:   Tue, 19 Oct 2021 19:53:59 +0200
Message-Id: <20211019175401.3757927-2-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019175401.3757927-1-pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: go5gCHUurTSKe2BnaJ-B93nAQhV1O7j-
X-Proofpoint-ORIG-GUID: jQ17KO3mfyImJWavxwRYTD0NS8fYaNXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=952 suspectscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea behind kicked mask is that we should not re-kick a vcpu that
is already in the "kick" process, i.e. that was kicked and is
is about to be dispatched if certain conditions are met.

The problem with the current implementation is, that it assumes the
kicked vcpu is going to enter SIE shortly. But under certain
circumstances, the vcpu we just kicked will be deemed non-runnable and
will remain in wait state. This can happen, if the interrupt(s) this
vcpu got kicked to deal with got already cleared (because the interrupts
got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
would return false, and the vcpu would remain in kvm_vcpu_block(),
but this time with its kicked_mask bit set. So next time around we
wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
that we just kicked it.

Let us make sure the kicked_mask is cleared before we give up on
re-dispatching the vcpu.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
---
 arch/s390/kvm/kvm-s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..1c97493d21e1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
 	return kvm_s390_vcpu_has_irq(vcpu, 0);
 }
 
-- 
2.25.1

