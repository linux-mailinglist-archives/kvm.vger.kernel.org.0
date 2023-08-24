Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DD0786F58
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbjHXMqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbjHXMqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F47E59;
        Thu, 24 Aug 2023 05:46:17 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgDjo009443;
        Thu, 24 Aug 2023 12:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1j/9IIjASMvVoaISjGOWRwyKNggPstN1mY7oIyn2sPo=;
 b=i3zWrfB6FbEWoZ/Dm/MOvtcFQqZvZmftKV8S0aLQMlE6e7H/W+xzHMapLmzG8uUlvLGI
 CR8BrRGRMt8KiFgmRrOrDfTiZUqDUSeZuPv+gH9ozSEdTDlMJHavFyBtwqoiqKS9jwM2
 Nsd4rhVwoH8hnLTp8+gYqxj27Mmr5AX/TdrFGxaqChaRRbv0U1sGOrU/9/rrSiuOYz4s
 CQ0bQdMkPjpDNTpZF5yVVZngqByQuSFdn9ErA0UY+wyQ3wsERgZEu42auU+LJearkTZ9
 Q+rOiNR8Gwf5ypCNEeaJ1heDBZvInxPr7nVlHbRSFDvP2tvCB5IPvGxjD3iQCB12fz0W /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ehre6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:16 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OChJm2013649;
        Thu, 24 Aug 2023 12:46:16 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ehre35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:16 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OA6j2m004050;
        Thu, 24 Aug 2023 12:46:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn21rpxka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkBD653936462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FA932004D;
        Thu, 24 Aug 2023 12:46:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958C320043;
        Thu, 24 Aug 2023 12:46:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 04/22] KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
Date:   Thu, 24 Aug 2023 14:43:13 +0200
Message-ID: <20230824124522.75408-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BVYv5UqV9dXYjh7gmWScGDmGA4m5WaWy
X-Proofpoint-GUID: 2luS1_eLpX8jhMxZKxf7-C-sjGVsB0Tt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=900
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

Single-stepping a userspace-emulated instruction that generates an
interrupt causes GDB to land on the instruction following it instead of
the respective interrupt handler.

The reason is that after arranging a KVM_EXIT_S390_SIEIC exit,
kvm_handle_sie_intercept() calls kvm_s390_handle_per_ifetch_icpt(),
which sets KVM_GUESTDBG_EXIT_PENDING. This bit, however, is not
processed immediately, but rather persists until the next ioctl(),
causing a spurious single-step exit.

Fix by clearing this bit in ioctl().

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20230725143857.228626-5-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0c6333b108ba..e6511608280c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5383,6 +5383,7 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	int rc;
 
 	switch (ioctl) {
 	case KVM_S390_IRQ: {
@@ -5390,7 +5391,8 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 
 		if (copy_from_user(&s390irq, argp, sizeof(s390irq)))
 			return -EFAULT;
-		return kvm_s390_inject_vcpu(vcpu, &s390irq);
+		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
+		break;
 	}
 	case KVM_S390_INTERRUPT: {
 		struct kvm_s390_interrupt s390int;
@@ -5400,10 +5402,25 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			return -EFAULT;
 		if (s390int_to_s390irq(&s390int, &s390irq))
 			return -EINVAL;
-		return kvm_s390_inject_vcpu(vcpu, &s390irq);
+		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
+		break;
 	}
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
 	}
-	return -ENOIOCTLCMD;
+
+	/*
+	 * To simplify single stepping of userspace-emulated instructions,
+	 * KVM_EXIT_S390_SIEIC exit sets KVM_GUESTDBG_EXIT_PENDING (see
+	 * should_handle_per_ifetch()). However, if userspace emulation injects
+	 * an interrupt, it needs to be cleared, so that KVM_EXIT_DEBUG happens
+	 * after (and not before) the interrupt delivery.
+	 */
+	if (!rc)
+		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
+
+	return rc;
 }
 
 static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
-- 
2.41.0

