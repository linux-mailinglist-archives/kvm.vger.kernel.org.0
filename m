Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9829777749
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 13:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbjHJLiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjHJLiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 07:38:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8ED270B;
        Thu, 10 Aug 2023 04:38:02 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ABQ6CG012905;
        Thu, 10 Aug 2023 11:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xyV0tIsNmG/l5bMtb03pYkRrII7TGyEO6vcYFxrZmO4=;
 b=rEyRZZqH6zPitynDf9DUpOy/4e6vLh1KKGBMRnXOI3Bjmcj8ih9LCrEAUssvEL3v37dy
 nS9a1D2TfyubGh4cgBvXhxvCuHkRanYvPNSQ1Ee0Bnb66PPxs/d8T708KyfRsPj3A3Sj
 2Raak57RQA82x2KrLneE2xWnfxfMhTRd3usub/NN9oOIqsq8dWE+MKWh6RF1huXpqBJQ
 ZtEeJMXU9BOYCSe+jC+KCQXxOrqXNMNEekjbY18iTjhLDO9tyKVdkuoMyV2ZWLjc3e3V
 3Igwy5eujSIP3IKVROfSD2tAVcJiZWuc1fpptpjQEeOP/phpcXSTdiHbOk3c9wU1l+PQ VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scy0x0gxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:38:01 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ABSO0Y019271;
        Thu, 10 Aug 2023 11:38:00 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scy0x0gwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:38:00 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37AB5enY006653;
        Thu, 10 Aug 2023 11:32:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sa0rthfxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:32:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37ABWuLi45810318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 11:32:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF9D320040;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9034220043;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v3 2/3] KVM: s390: Add UV feature negotiation
Date:   Thu, 10 Aug 2023 13:32:54 +0200
Message-Id: <20230810113255.2163043-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810113255.2163043-1-seiden@linux.ibm.com>
References: <20230810113255.2163043-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uae9igSLiTyuU6-_d-Akjl6Lu525mlUt
X-Proofpoint-ORIG-GUID: KhCdSstVkceRZCD7HPKe00_RzfazRgVZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_10,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308100098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a uv_feature list for pv-guests to the KVM cpu-model.
The feature bits 'AP-interpretation for secure guests' and
'AP-interrupt for secure guests' are available.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/include/uapi/asm/kvm.h | 16 +++++++
 arch/s390/kvm/kvm-s390.c         | 74 ++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)

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
index 813cc3d59c90..80c1449fd358 100644
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
@@ -3216,6 +3287,7 @@ void kvm_arch_free_vm(struct kvm *kvm)
 	__kvm_arch_free_vm(kvm);
 }
 
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT 0
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
@@ -3296,6 +3368,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
 	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
+	kvm->arch.model.uv_feat_guest.feat = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
+
 	kvm_s390_crypto_init(kvm);
 
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
-- 
2.40.1

