Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C29C433DDE
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhJSR42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:56:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234801AbhJSR40 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:56:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JGHhhl001976;
        Tue, 19 Oct 2021 13:54:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q/3DR9hWr4hjriuIEVzl47dAQxxL9n6DlZStTH7FA+4=;
 b=iUxgnPD4rjPIB9JzIGZqZwLhdtJ7AEQvC52wkAH2q65SvP9faeqYsvqz1wDr5FHeUlDT
 usYQ4UR4l+m8uM1Hrrkx3bCqCMnYjKSyg9Oq/KaYtEAgzo+praRj1Zeaz0ZhtWPov1rE
 EVW6UVNjDWMC7jB0vWuRp/XEMyE11OPoMzOWug080mv8BiaRXUTTczdFajOC4FqpnxZk
 Wtwt36SC64rCS6BXqVBIvooAWLCZvo33ED5iJkbULmo9Q8hDfNE2NEyfrGTnGpmygYmd
 y1XkPUJwS19tMHUQQ1GaJ5gzQMDGLyX1ULlZwBWSsLMTQ0I7VnEosYJWPhaSoWdaei+I Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt1draavr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:12 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JGkmMJ011074;
        Tue, 19 Oct 2021 13:54:12 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt1draav7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:12 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JHrNHv006558;
        Tue, 19 Oct 2021 17:54:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3bqpcbjr8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:54:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JHs70P35520954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 17:54:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E685EAE053;
        Tue, 19 Oct 2021 17:54:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73446AE045;
        Tue, 19 Oct 2021 17:54:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 17:54:06 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
Date:   Tue, 19 Oct 2021 19:54:01 +0200
Message-Id: <20211019175401.3757927-4-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019175401.3757927-1-pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rZtmK9zhXz0uxj3kfkvTk0v391lt4HVG
X-Proofpoint-ORIG-GUID: TfSOrbrLVH_MZgr95rHj096R307ZfErf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=810 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea behind kicked mask is that we should not re-kick a vcpu
from __airqs_kick_single_vcpu() that is already in the middle of
being kicked by the same function.

If however the vcpu that was idle before when the idle_mask was
examined, is not idle any more after the kicked_mask is set, that
means that we don't need to kick, and that we need to clear the
bit we just set because we may be beyond the point where it would
get cleared in the wake-up process. Since the time window is short,
this is probably more a theoretical than a practical thing: the race
window is small.

To get things harmonized let us also move the clear from vcpu_pre_run()
to __unset_cpu_idle().

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
---
 arch/s390/kvm/interrupt.c | 7 ++++++-
 arch/s390/kvm/kvm-s390.c  | 2 --
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 2245f4b8d362..3c80a2237ef5 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -426,6 +426,7 @@ static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
 	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
@@ -3064,7 +3065,11 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 			/* lately kicked but not yet running */
 			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
-			kvm_s390_vcpu_wakeup(vcpu);
+			/* if meanwhile not idle: clear  and don't kick */
+			if (test_bit(vcpu_idx, kvm->arch.idle_mask))
+				kvm_s390_vcpu_wakeup(vcpu);
+			else
+				clear_bit(vcpu_idx, gi->kicked_mask);
 			return;
 		}
 	}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1c97493d21e1..6b779ef9f5fb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4067,8 +4067,6 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 		kvm_s390_patch_guest_per_regs(vcpu);
 	}
 
-	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
-
 	vcpu->arch.sie_block->icptcode = 0;
 	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x", cpuflags);
-- 
2.25.1

