Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAE6427245
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbhJHUd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230303AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRTTQ020044;
        Fri, 8 Oct 2021 16:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KGFP6+v7naDoDb1g0cPnnmWUW3Km1AW6dvdrAVHe56c=;
 b=P0zbgNsTutFIcCtfUOw6xDS5o5PdwvF7m2/RyrOF0AC0BL++MK4q3RZUUj/LdvImagyw
 Cw4pa56H7UoCY1J2C2w1aIOdSr7G/uw/Pe2gwObZUK9n39As0kUCvO4y40fV6B2UNMwi
 LJT8WGAWuGCuGZD8Wm83yu6JrKe9jJkWZsynL3l0OMp/Ivre+6zoQPwOWQ8ZmA5kn765
 MWjpMJxzY64HuAKDhxc1OgRzWkF9yHKedXrGt+/LqhMEcaA45r13yjainFP2+DXzxXFL
 Z+FZoLlBkYF9Irzv7IhcLx8V1h4eBrntgkNDzZcgud7XAa++UxZmC2cjpkkbp5yI0b56 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjueat6xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KTxS2000869;
        Fri, 8 Oct 2021 16:31:30 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjueat6wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMASa004204;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2as9kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVOHS43975080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF8DDA4065;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6FB6A404D;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 3CA8CE0352; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
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
Subject: [RFC PATCH v1 2/6] KVM: s390: Reject SIGP when destination CPU is busy
Date:   Fri,  8 Oct 2021 22:31:08 +0200
Message-Id: <20211008203112.1979843-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T7fXkddOm6M0QCrRWUeGnxRd9FGb8eI6
X-Proofpoint-ORIG-GUID: -L31TlYNSmr5BqvQt62PYkLqyEakRXld
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With KVM_CAP_USER_SIGP enabled, most orders are handled by userspace.
However, some orders (such as STOP or STOP AND STORE STATUS) end up
injecting work back into the kernel. Userspace itself should (and QEMU
does) look for this conflict, and reject additional (non-reset) orders
until this work completes.

But there's no need to delay that. If the kernel knows about the STOP
IRQ that is in process, the newly-requested SIGP order can be rejected
with a BUSY condition right up front.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/sigp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index cf4de80bd541..6ca01bbc72cf 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -394,6 +394,45 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
 	return 1;
 }
 
+static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
+					u16 cpu_addr)
+{
+	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
+	int rc = 0;
+
+	/*
+	 * SIGP orders directed at invalid vcpus are not blocking,
+	 * and should not return busy here. The code that handles
+	 * the actual SIGP order will generate the "not operational"
+	 * response for such a vcpu.
+	 */
+	if (!dst_vcpu)
+		return 0;
+
+	/*
+	 * SIGP orders that process a flavor of reset would not be
+	 * blocked through another SIGP on the destination CPU.
+	 */
+	if (order_code == SIGP_CPU_RESET ||
+	    order_code == SIGP_INITIAL_CPU_RESET)
+		return 0;
+
+	/*
+	 * Any other SIGP order could race with an existing SIGP order
+	 * on the destination CPU, and thus encounter a busy condition
+	 * on the CPU processing the SIGP order. Reject the order at
+	 * this point, rather than racing with the STOP IRQ injection.
+	 */
+	spin_lock(&dst_vcpu->arch.local_int.lock);
+	if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
+		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
+		rc = 1;
+	}
+	spin_unlock(&dst_vcpu->arch.local_int.lock);
+
+	return rc;
+}
+
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 {
 	int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
@@ -408,6 +447,10 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
 	order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
+
+	if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
+		return 0;
+
 	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
 		return -EOPNOTSUPP;
 
-- 
2.25.1

