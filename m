Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2CB7668D2
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjG1J1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbjG1J0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:26:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B1B3AB3;
        Fri, 28 Jul 2023 02:23:49 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9JTcb025111;
        Fri, 28 Jul 2023 09:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1uKUpvEURvezixS7cG8DR5K/Ud3EBEQGVwVAKCac4Hw=;
 b=gMprL/OpCbE2eo8SntT+Mr9bF5h1NZ/dqizsW+aPFHx/q35E+RMR1XCt/imJiDzegwJf
 xsxMyHu6/pwET3FqFrhmYWuJmdzvXBdrULd5yOo4ohYS2HXfGXHhiHOzYYVwnVHHS59b
 lBkKet5vIgzHXhob2XUKJHPi4V+gMPhucJRyugXLr8m7E7N52BpSI20QRXsnhdlxO9h7
 uC0StjOs6WRQActVF38ozESmWadeibAsgiWk2ssrWsmICE2vs4tAw3d/dLwC0N02A3BQ
 j7Pwu9QKChTxYBVxbpP8tf3Z/JUBw+RwRbF0Spocid03pnifhQ4xSwl6i4iPzyoX3vZS cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4axe825w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:48 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S9K1f6026042;
        Fri, 28 Jul 2023 09:23:48 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4axe825j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:47 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S96S1g001973;
        Fri, 28 Jul 2023 09:23:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0tenmt9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S9Nh8o20578816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 09:23:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF13120040;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8681020049;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH v2 2/3] KVM: s390: Add UV feature negotiation
Date:   Fri, 28 Jul 2023 11:23:40 +0200
Message-Id: <20230728092341.1131787-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728092341.1131787-1-seiden@linux.ibm.com>
References: <20230728092341.1131787-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gm2_Wqb0Tux_9Z3J_o8_xHPfiy0ITFtN
X-Proofpoint-GUID: bZdRkgJus2Y4WUZ016mTKcBp0-lCTk_p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a uv_feature list for pv-guests to the kvm cpu-model.
The feature bits 'AP-interpretation for secure guests' and
'AP-interrupt for secure guests' are available.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/include/uapi/asm/kvm.h | 25 +++++++++++++
 arch/s390/kvm/kvm-s390.c         | 60 ++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..7ae57ac352b2 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -817,6 +817,8 @@ struct kvm_s390_cpu_model {
 	__u64 *fac_list;
 	u64 cpuid;
 	unsigned short ibc;
+	/* subset of available uv features for pv-guests enabled by user space */
+	struct kvm_s390_vm_cpu_uv_feat uv_feat_guest;
 };
 
 typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index a73cf01a1606..b7f4bf5687c7 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -159,6 +159,31 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 reserved[1728];
 };
 
+#define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
+#define KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST	7
+
+#define KVM_S390_VM_CPU_UV_FEAT_NR_BITS	64
+struct kvm_s390_vm_cpu_uv_feat {
+	union {
+		struct {
+			__u64 res0 : 4;
+			__u64 ap : 1;		/* bit 4 */
+			__u64 ap_intr : 1;	/* bit 5 */
+			__u64 res6 : 58;
+		};
+		__u64 feat;
+	};
+};
+
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK  \
+	(((struct kvm_s390_vm_cpu_uv_feat){ \
+		  .ap = 1,                  \
+		  .ap_intr = 1,             \
+	  })                                \
+		 .feat)
+
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT ((struct kvm_s390_vm_cpu_uv_feat){})
+
 /* kvm attributes for crypto */
 #define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
 #define KVM_S390_VM_CRYPTO_ENABLE_DEA_KW	1
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 813cc3d59c90..46d3108ad11f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1531,6 +1531,29 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 	return 0;
 }
 
+static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat data = {};
+	unsigned long filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+
+	if (copy_from_user(&data, (void __user *)attr->addr, sizeof(data)))
+		return -EFAULT;
+	if (!bitmap_subset((unsigned long *)&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	if (kvm->created_vcpus) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+	kvm->arch.model.uv_feat_guest = data;
+	mutex_unlock(&kvm->lock);
+
+	VM_EVENT(kvm, 3, "SET: guest uv feat: 0x%16.16llx", data.feat);
+
+	return 0;
+}
+
 static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret = -ENXIO;
@@ -1545,6 +1568,9 @@ static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
 		ret = kvm_s390_set_processor_subfunc(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
+		ret = kvm_s390_set_uv_feat(kvm, attr);
+		break;
 	}
 	return ret;
 }
@@ -1777,6 +1803,30 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 	return 0;
 }
 
+static int kvm_s390_get_processor_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat *src = &kvm->arch.model.uv_feat_guest;
+
+	if (copy_to_user((void __user *)attr->addr, src, sizeof(*src)))
+		return -EFAULT;
+	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx", kvm->arch.model.uv_feat_guest.feat);
+
+	return 0;
+}
+
+static int kvm_s390_get_machine_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_uv_feat data = { .feat = uv_info.uv_feature_indications &
+							KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK };
+
+	BUILD_BUG_ON(sizeof(data) != sizeof(uv_info.uv_feature_indications));
+	if (copy_to_user((void __user *)attr->addr, &data, sizeof(struct kvm_s390_vm_cpu_uv_feat)))
+		return -EFAULT;
+	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx", data.feat);
+
+	return 0;
+}
+
 static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret = -ENXIO;
@@ -1800,6 +1850,12 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -1952,6 +2008,8 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 		case KVM_S390_VM_CPU_MACHINE_FEAT:
 		case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
 		case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
+		case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
+		case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
 			ret = 0;
 			break;
 		default:
@@ -3296,6 +3354,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
 	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
+	kvm->arch.model.uv_feat_guest = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
+
 	kvm_s390_crypto_init(kvm);
 
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
-- 
2.40.1

