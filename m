Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5A78C3DB
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjH2MKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjH2MJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7617A3;
        Tue, 29 Aug 2023 05:09:34 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBgaEO021533;
        Tue, 29 Aug 2023 12:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kN0bo2Q/5OU/SZ7yFbjzShYLy77yKOLZbfagdp7xa0Y=;
 b=N1Lm0WM018mxWa6W79PH/jJSyWc+J9o0sL07abF9JNbB6divoaA6cJhtsd90C5PAZqY0
 H7TsxDo89sjQcQEQWyX+LHiIY9zEGRmqbgVEmBwaGpUI3T4JAxffTLuV4thiw6l44BWA
 Mk1GG1W6RHA03KDrSbWqCrUxwXHY2FdMpXWPegeonmYTQ05k3HSBu8dpvUdTVFBxRenY
 c/TvHu2jsMcYXvxV7objZfWtO7kN6CGiAQJTE1dD/9HIlPz0qtgXADzM7oU1EJfIQw8W
 8WYR2zbZJUudP4sNyPw5Qlkdl/QbZbZ5oYANmfLykZFPoqlK3cb5IZ1N4i1UCG/LfpDG 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssg1frqpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:33 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC5rLd029927;
        Tue, 29 Aug 2023 12:09:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssg1frqgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:32 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBkD90020520;
        Tue, 29 Aug 2023 12:09:25 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqv3ybcpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9MpO20579002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3411520040;
        Tue, 29 Aug 2023 12:09:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 698992004D;
        Tue, 29 Aug 2023 12:09:21 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 04/10] KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
Date:   Tue, 29 Aug 2023 14:03:59 +0200
Message-ID: <20230829120843.66637-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i-hEF_SF3MYfc1r0ExDNR1Al7IBBDO_9
X-Proofpoint-GUID: sDFGDypMlsEsO3iuNGzzu4__rjqyx9M0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=901 lowpriorityscore=0 spamscore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308290105
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
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

