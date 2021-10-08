Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E67242724E
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242698AbhJHUdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232005AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRNJJ028884;
        Fri, 8 Oct 2021 16:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q7Hc0tUEef6F8wb96Wz846QVmW+nQ2Hmp579MBFksJA=;
 b=mGp48cStrdeswOozNBI1UUkiasaN3xGs+PWf4k/o6zoxCMTSnmpyO/YX3m9R1I8CqC76
 27H3jtqoC7wz0s58QkHrhDs8Rq4FfQILOcAjLjOl1d1yRef8XNwxc0iVxCpO3byaC+Ga
 ARjAvCb03cMW6v+SpJsZ+2+0aXRh3vddUF9zY6HK0FRCdny+lfi57fbEBgdnU6jEOTk4
 lVI1UkqgHzipgArV3Ug5O2wi6UW3ZLl582v3xCgCTxGnuFDmZM0uVAuw0IL0cUU5tm3W
 3PmF7bzdsm20A/VSEFUlymVjl5cZR3yK0jff9twWZOrpUQooHdT+wWimZgrLJKpUCxvd WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjtm3k970-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:31 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KRfID030210;
        Fri, 8 Oct 2021 16:31:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjtm3k96b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMW2B014258;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2b5j12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVO0c53477742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7B6C52051;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9C27E5205F;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 41647E0394; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 4/6] KVM: s390: Restart IRQ should also block SIGP
Date:   Fri,  8 Oct 2021 22:31:10 +0200
Message-Id: <20211008203112.1979843-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fBFOXhhgqk8VlMg__9gfjvLWrvgiTQ0J
X-Proofpoint-GUID: bnc22Vxx4brb2tRMyaLe9WRbmfBQml6p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When userspace handles a SIGP Restart, it first looks at the
destination CPU state to determine its next course of action:

  if (cpu is online)
     inject restart IRQ
  else
     set cpu online
     load restart PSW

Since we already have logic for dealing with an in-flight
STOP IRQ when a new SIGP comes in, let's include the RESTART
IRQ in the same logic, so we don't race with that work.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 7 +++++++
 arch/s390/kvm/kvm-s390.h  | 1 +
 arch/s390/kvm/sigp.c      | 5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 10722455fd02..77c5d73ff0e2 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2108,6 +2108,13 @@ int s390int_to_s390irq(struct kvm_s390_interrupt *s390int,
 	return 0;
 }
 
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+
+	return test_bit(IRQ_PEND_RESTART, &li->pending_irqs);
+}
+
 int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 52bc8fbaa60a..57c5e9369d65 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -417,6 +417,7 @@ int psw_extint_disabled(struct kvm_vcpu *vcpu);
 void kvm_s390_destroy_adapters(struct kvm *kvm);
 int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
 extern struct kvm_device_ops kvm_flic_ops;
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
 int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 0c08927ca7c9..c64e37f4347d 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -412,10 +412,11 @@ static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
 	 * Any other SIGP order could race with an existing SIGP order
 	 * on the destination CPU, and thus encounter a busy condition
 	 * on the CPU processing the SIGP order. Reject the order at
-	 * this point, rather than racing with the STOP IRQ injection.
+	 * this point, rather than racing with any IRQ injection.
 	 */
 	spin_lock(&dst_vcpu->arch.local_int.lock);
-	if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
+	if (kvm_s390_is_stop_irq_pending(dst_vcpu) ||
+	    kvm_s390_is_restart_irq_pending(dst_vcpu)) {
 		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
 		rc = 1;
 	}
-- 
2.25.1

