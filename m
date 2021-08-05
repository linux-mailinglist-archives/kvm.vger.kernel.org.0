Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41DB3E0F19
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhHEHZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:25:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238153AbhHEHZS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 03:25:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17574AKl190609;
        Thu, 5 Aug 2021 03:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dyfLrbUYF+bfLKmLM+04hqX0pe2+BPIZfw16sZMuW4U=;
 b=Odv8txROkw7TPkmiGzqPWJcm02CuK8nRdAMYZ6n6/MD0ej6xqrX5j1wA+/VVYdNrhc4n
 5H/6JcrquStwMNSQOvRfVS3iFRpJjCc0GT9mFNgKYZNR4dEkjZ8EwDadnJnoDRWtvWFh
 wMsmdOx8TOJzzmyhX40DuJ5DY3nwe64lu3vpYH8dA8DE3D1xPyWk0PBBNqkGk9j6V3uU
 sb8mgWC3jJRm4V9F5vf2uu5VrDunI7fDCHXII+8JqSpWk2+JRJf72bkn5v6qGfmsgPG3
 P3Y812iQ5IZiWRGIE7oUuOMmh+IA49E+aUDok3urz6bpQOUbdRjMXaL0+TowT8Zt0KwC 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8858vttm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 03:25:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17574BJx190676;
        Thu, 5 Aug 2021 03:25:01 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a8858vtsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 03:25:01 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17577ZqN029911;
        Thu, 5 Aug 2021 07:24:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3a4x58snma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:24:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1757OtI748038366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 07:24:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB7B1A4051;
        Thu,  5 Aug 2021 07:24:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99484A405D;
        Thu,  5 Aug 2021 07:24:53 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.102.2.73])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 07:24:53 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        bharata.rao@gmail.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [RFC PATCH v0 2/5] KVM: PPC: Add support for KVM_REQ_ESN_EXIT
Date:   Thu,  5 Aug 2021 12:54:36 +0530
Message-Id: <20210805072439.501481-3-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805072439.501481-1-bharata@linux.ibm.com>
References: <20210805072439.501481-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ao0apLeLEIhah8sEikhfIA4zOIOgPT53
X-Proofpoint-ORIG-GUID: gJYXdwxIfgtarxBhCZTJr-1bD0jviSo_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_02:2021-08-04,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108050041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new KVM exit request KVM_REQ_ESN_EXIT that will be used
to exit to userspace (QEMU) whenever subvention notification
needs to be sent to the guest.

The userspace (QEMU) issues the subvention notification by
injecting an interrupt into the guest.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 +
 arch/powerpc/kvm/book3s_hv.c        | 8 ++++++++
 include/uapi/linux/kvm.h            | 1 +
 3 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..204dc2d91388 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -52,6 +52,7 @@
 #define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
 #define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
 #define KVM_REQ_PENDING_TIMER	KVM_ARCH_REQ(2)
+#define KVM_REQ_ESN_EXIT	KVM_ARCH_REQ(3)
 
 #include <linux/mmu_notifier.h>
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 085fb8ecbf68..47ccd4a2df54 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2820,6 +2820,14 @@ static void kvmppc_core_vcpu_free_hv(struct kvm_vcpu *vcpu)
 
 static int kvmppc_core_check_requests_hv(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If subvention interrupt needs to be injected to the guest
+	 * exit to user space.
+	 */
+	if (kvm_check_request(KVM_REQ_ESN_EXIT, vcpu)) {
+		vcpu->run->exit_reason = KVM_EXIT_ESN;
+		return 0;
+	}
 	/* Indicate we want to get back into the guest */
 	return 1;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..47be532ed14b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -269,6 +269,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_ESN		  35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
-- 
2.31.1

