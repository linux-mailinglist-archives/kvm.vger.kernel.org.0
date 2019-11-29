Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3549910D6E6
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 15:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfK2OVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 09:21:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbfK2OVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 09:21:46 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATEI1uX126354
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:21:45 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wjxaye06s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:21:45 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 29 Nov 2019 14:21:41 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 14:21:37 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xATELaSP55705770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 14:21:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC228A4054;
        Fri, 29 Nov 2019 14:21:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30148A405C;
        Fri, 29 Nov 2019 14:21:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.188.128])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Nov 2019 14:21:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        mihajlov@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: Add new reset vcpu API
Date:   Fri, 29 Nov 2019 09:21:22 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19112914-4275-0000-0000-000003880E51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112914-4276-0000-0000-0000389BA3B9
Message-Id: <20191129142122.21528-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_04:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 impostorscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The architecture states that we need to reset local IRQs for all CPU
resets. Because the old reset interface did not support the normal CPU
reset we never did that.

Now that we have a new interface, let's properly clear out local IRQs
and let this commit be a reminder.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++++++++-
 include/uapi/linux/kvm.h |  7 +++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..2f74ff46b176 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_CMMA_MIGRATION:
 	case KVM_CAP_S390_AIS:
 	case KVM_CAP_S390_AIS_MIGRATION:
+	case KVM_CAP_S390_VCPU_RESETS:
 		r = 1;
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
@@ -3293,6 +3294,25 @@ static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu, unsigned long type)
+{
+	int rc = -EINVAL;
+
+	switch (type) {
+	case KVM_S390_VCPU_RESET_NORMAL:
+		rc = 0;
+		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_s390_clear_local_irqs(vcpu);
+		break;
+	case KVM_S390_VCPU_RESET_INITIAL:
+		/* fallthrough */
+	case KVM_S390_VCPU_RESET_CLEAR:
+		rc = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		break;
+	}
+	return rc;
+}
+
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
@@ -4364,7 +4384,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_S390_INITIAL_RESET:
-		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		arg = KVM_S390_VCPU_RESET_INITIAL;
+		/* fallthrough */
+	case KVM_S390_VCPU_RESET:
+		r = kvm_arch_vcpu_ioctl_reset(vcpu, arg);
 		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..6da16b1f2c86 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_S390_VCPU_RESETS 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,6 +1462,12 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+#define KVM_S390_VCPU_RESET_NORMAL	0
+#define KVM_S390_VCPU_RESET_INITIAL	1
+#define KVM_S390_VCPU_RESET_CLEAR	2
+
+#define KVM_S390_VCPU_RESET    _IO(KVMIO,   0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

