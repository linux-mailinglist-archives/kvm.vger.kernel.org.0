Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159651140CF
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 13:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLEM2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 07:28:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbfLEM2i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 07:28:38 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5CMGeQ145681
        for <kvm@vger.kernel.org>; Thu, 5 Dec 2019 07:28:37 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq1pngnff-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 07:28:37 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Dec 2019 12:28:35 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 12:28:16 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5CRZ8K49938712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 12:27:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD835A405C;
        Thu,  5 Dec 2019 12:28:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12287A405B;
        Thu,  5 Dec 2019 12:28:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Dec 2019 12:28:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v4] KVM: s390: Add new reset vcpu API
Date:   Thu,  5 Dec 2019 07:28:10 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191205131930.1b78f78b.cohuck@redhat.com>
References: <20191205131930.1b78f78b.cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19120512-0012-0000-0000-00000371978F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120512-0013-0000-0000-000021AD5BD9
Message-Id: <20191205122810.10672-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=1 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The architecture states that we need to reset local IRQs for all CPU
resets. Because the old reset interface did not support the normal CPU
reset we never did that. Now that we have a new interface, let's
properly clear out local IRQs.

Also we add a ioctl for the clear reset to have all resets exposed to
userspace. Currently the clear reset falls back to the initial reset,
but we plan to have clear reset specific code in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 Documentation/virt/kvm/api.txt | 48 ++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 14 ++++++++++
 include/uapi/linux/kvm.h       |  5 ++++
 3 files changed, 67 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 4833904d32a5..296e51f9df70 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4126,6 +4126,47 @@ Valid values for 'action':
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+4.121 KVM_S390_NORMAL_RESET
+
+Capability: KVM_CAP_S390_VCPU_RESETS
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures that userspace
+can't access via the kvm_run structure. It is intended to be called
+when a normal reset is performed on the vcpu and clears local
+interrupts, the riccb and PSW bit 24.
+
+4.122 KVM_S390_INITIAL_RESET
+
+Capability: none
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures that userspace
+can't access via the kvm_run structure. It is intended to be called
+when an initial reset (which is a superset of the normal reset) is
+performed on the vcpu and additionally clears the psw, prefix, timing
+related registers, as well as setting the control registers to their
+initial value.
+
+4.123 KVM_S390_CLEAR_RESET
+
+Capability: KVM_CAP_S390_VCPU_RESETS
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures that userspace
+can't access via the kvm_run structure. It is intended to be called
+when an initial reset (which is a superset of the normal reset) is
+performed on the vcpu and additionally clears general, access,
+floating and vector registers.
 
 5. The kvm_run structure
 ------------------------
@@ -5322,3 +5363,10 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
 flush hypercalls by Hyper-V) so userspace should disable KVM identification
 in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
+
+8.22 KVM_CAP_S390_VCPU_RESETS
+
+Architectures: s390
+
+This capability indicates that the KVM_S390_NORMAL_RESET and
+KVM_S390_CLEAR_RESET ioctls are available.
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..7f3ede0b2715 100644
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
@@ -3287,6 +3288,13 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
+{
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_s390_clear_local_irqs(vcpu);
+	return 0;
+}
+
 static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_vcpu_initial_reset(vcpu);
@@ -4363,9 +4371,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
 		break;
 	}
+
+	case KVM_S390_CLEAR_RESET:
+		/* fallthrough */
 	case KVM_S390_INITIAL_RESET:
 		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
 		break;
+	case KVM_S390_NORMAL_RESET:
+		r = kvm_arch_vcpu_ioctl_normal_reset(vcpu);
+		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
 		struct kvm_one_reg reg;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..edbb2da43f02 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_S390_VCPU_RESETS 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,6 +1462,10 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

