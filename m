Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C13D786F7A
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbjHXMrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbjHXMqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651410FE;
        Thu, 24 Aug 2023 05:46:30 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgJbf009633;
        Thu, 24 Aug 2023 12:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=azgVBXl9krXnVuOW9t++ITp9lFWoMAEGkCMkyxlYl8Y=;
 b=sBqV38KGP4yi2AhnjCava++QDkeuX/2LaYw8InajB5RMG8ZmXthaIysAE3ivDw2VCPcm
 7CVU2lK2vi81zN3M/mQJhSdxMcbfrgYa3cFyBXGvSoU14KLPexLJ+YE694IDcwC4X542
 wivoYFrbASHIN8tkbThbyiQepcXOq/7QnFCcOux8UnPm4MXnASG39JFkH7KG8GmAFT5S
 /EruUu8BcWQLfrw5ngKxuzfYukdSFBXaw02t9euaFLI0jbqEONofr7oyQPYtpe1IE7ED
 NkAPhPdgghnYDiqCX8ympuhm8R2q74yvHClBGpZYB7ZeBhZVILFpMIA0JoEmP3soV+6N ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ehrf4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:30 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh9tD012930;
        Thu, 24 Aug 2023 12:46:29 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ehrf04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:29 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCTsxi016435;
        Thu, 24 Aug 2023 12:46:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn227xyu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkOrD45547946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F70A20043;
        Thu, 24 Aug 2023 12:46:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECBA52004B;
        Thu, 24 Aug 2023 12:46:23 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 21/22] KVM: s390: Add UV feature negotiation
Date:   Thu, 24 Aug 2023 14:43:30 +0200
Message-ID: <20230824124522.75408-22-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TV5ylZsg3JMpfadGnFtoGpJ4Xl0Mm8e5
X-Proofpoint-GUID: 02esM3y3GtXirbv3pKs6OHOVQQs_BsFk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
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

From: Steffen Eiden <seiden@linux.ibm.com>

Add a uv_feature list for pv-guests to the KVM cpu-model.
The feature bits 'AP-interpretation for secure guests' and
'AP-interrupt for secure guests' are available.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815151415.379760-4-seiden@linux.ibm.com
Message-Id: <20230815151415.379760-4-seiden@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/include/uapi/asm/kvm.h | 16 +++++++
 arch/s390/kvm/kvm-s390.c         | 73 ++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 91bfecb91321..427f9528a7b6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -817,6 +817,8 @@ struct kvm_s390_cpu_model {
 	__u64 *fac_list;
 	u64 cpuid;
 	unsigned short ibc;
+	/* subset of available UV-features for pv-guests enabled by user space */
+	struct kvm_s390_vm_cpu_uv_feat uv_feat_guest;
 };
 
 typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index a73cf01a1606..abe926d43cbe 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -159,6 +159,22 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 reserved[1728];
 };
 
+#define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
+#define KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST	7
+
+#define KVM_S390_VM_CPU_UV_FEAT_NR_BITS	64
+struct kvm_s390_vm_cpu_uv_feat {
+	union {
+		struct {
+			__u64 : 4;
+			__u64 ap : 1;		/* bit 4 */
+			__u64 ap_intr : 1;	/* bit 5 */
+			__u64 : 58;
+		};
+		__u64 feat;
+	};
+};
+
 /* kvm attributes for crypto */
 #define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
 #define KVM_S390_VM_CRYPTO_ENABLE_DEA_KW	1
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 813cc3d59c90..b3f17e014cab 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1531,6 +1531,39 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 	return 0;
 }
 
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK	\
+(						\
+	((struct kvm_s390_vm_cpu_uv_feat){	\
+		.ap = 1,			\
+		.ap_intr = 1,			\
+	})					\
+	.feat					\
+)
+
+static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat __user *ptr = (void __user *)attr->addr;
+	unsigned long data, filter;
+
+	filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+	if (get_user(data, &ptr->feat))
+		return -EFAULT;
+	if (!bitmap_subset(&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	if (kvm->created_vcpus) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+	kvm->arch.model.uv_feat_guest.feat = data;
+	mutex_unlock(&kvm->lock);
+
+	VM_EVENT(kvm, 3, "SET: guest UV-feat: 0x%16.16lx", data);
+
+	return 0;
+}
+
 static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret = -ENXIO;
@@ -1545,6 +1578,9 @@ static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
 		ret = kvm_s390_set_processor_subfunc(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
+		ret = kvm_s390_set_uv_feat(kvm, attr);
+		break;
 	}
 	return ret;
 }
@@ -1777,6 +1813,33 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 	return 0;
 }
 
+static int kvm_s390_get_processor_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
+	unsigned long feat = kvm->arch.model.uv_feat_guest.feat;
+
+	if (put_user(feat, &dst->feat))
+		return -EFAULT;
+	VM_EVENT(kvm, 3, "GET: guest UV-feat: 0x%16.16lx", feat);
+
+	return 0;
+}
+
+static int kvm_s390_get_machine_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
+	unsigned long feat;
+
+	BUILD_BUG_ON(sizeof(*dst) != sizeof(uv_info.uv_feature_indications));
+
+	feat = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+	if (put_user(feat, &dst->feat))
+		return -EFAULT;
+	VM_EVENT(kvm, 3, "GET: guest UV-feat: 0x%16.16lx", feat);
+
+	return 0;
+}
+
 static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret = -ENXIO;
@@ -1800,6 +1863,12 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
 		ret = kvm_s390_get_machine_subfunc(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
+		ret = kvm_s390_get_processor_uv_feat(kvm, attr);
+		break;
+	case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
+		ret = kvm_s390_get_machine_uv_feat(kvm, attr);
+		break;
 	}
 	return ret;
 }
@@ -1952,6 +2021,8 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 		case KVM_S390_VM_CPU_MACHINE_FEAT:
 		case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
 		case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
+		case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
+		case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
 			ret = 0;
 			break;
 		default:
@@ -3296,6 +3367,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
 	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
+	kvm->arch.model.uv_feat_guest.feat = 0;
+
 	kvm_s390_crypto_init(kvm);
 
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
-- 
2.41.0

