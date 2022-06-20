Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839F8551958
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbiFTMuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 08:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiFTMu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 08:50:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEF62C3;
        Mon, 20 Jun 2022 05:50:25 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KC6rld009175;
        Mon, 20 Jun 2022 12:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MM9qviSh6Q+gTGXsfRZhcNfyoQIg+w+Icyq9ToekYBs=;
 b=RWSVNfeECgAcjXiQRPeY/m8ukEBxbfye+apSFBm6EecQDjqELR83bfCYfwiuOFliBW4O
 uf2OaA0C0IAhEBvV/AzjeeRwKRbjzcG5cREFhMKI1txU4z3BC8UD0lP/EWottZZEwzef
 e1pISTz4dQbHbdZ6FVTOxxj05yoz/wXMEnsf7xFKLIyelEtWQB7+hENnnyqYEP2Ble9o
 LZHkA4b+5H5UVu71M+f0q/G0CpqEERTW+FK1YLTeub5SyY/SzWufa93kwJAobA08v6Br
 2xDjRheqL67XyVebJFvrNs+A3ZgpNCyIPqtG9eRo+I3poFD3HhMY5tX7pemtrMjkjB6g hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrb614cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KAtOj9021616;
        Mon, 20 Jun 2022 12:50:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrb614bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KCa6Lg011373;
        Mon, 20 Jun 2022 12:50:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3gs6b8tgxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KCoIEI20709820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 12:50:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A72BA4053;
        Mon, 20 Jun 2022 12:50:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBE16A4051;
        Mon, 20 Jun 2022 12:50:17 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 12:50:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 3/3] KVM: s390: resetting the Topology-Change-Report
Date:   Mon, 20 Jun 2022 14:54:37 +0200
Message-Id: <20220620125437.37122-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620125437.37122-1-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G0To1EClj_X2f3Tz__NoJxVOgcKawI5w
X-Proofpoint-GUID: 8vGgjoAXEPQz2RniSNz-eSAnxDkqJ4Bz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During a subsystem reset the Topology-Change-Report is cleared.
Let's give userland the possibility to clear the MTCR in the case
of a subsystem reset.

To migrate the MTCR, we give userland the possibility to
query the MTCR state.

We indicate KVM support for the CPU topology facility with a new
KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   | 31 +++++++++++
 arch/s390/include/uapi/asm/kvm.h | 10 ++++
 arch/s390/kvm/kvm-s390.c         | 96 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  1 +
 4 files changed, 138 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..326f8b7e7671 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7956,6 +7956,37 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+8.37 KVM_CAP_S390_CPU_TOPOLOGY
+------------------------------
+
+:Capability: KVM_CAP_S390_CPU_TOPOLOGY
+:Architectures: s390
+:Type: vm
+
+This capability indicates that KVM will provide the S390 CPU Topology
+facility which consist of the interpretation of the PTF instruction for
+the Function Code 2 along with interception and forwarding of both the
+PTF instruction with Function Codes 0 or 1 and the STSI(15,1,x)
+instruction to the userland hypervisor.
+
+The stfle facility 11, CPU Topology facility, should not be provided
+to the guest without this capability.
+
+When this capability is present, KVM provides a new attribute group
+on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
+This new attribute allows to get, set or clear the Modified Change
+Topology Report (MTCR) bit of the SCA through the kvm_device_attr
+structure.
+
+Getting the MTCR bit is realized by using a kvm_device_attr attr
+entry value of KVM_GET_DEVICE_ATTR and with kvm_device_attr addr
+entry pointing to the address of a struct kvm_cpu_topology.
+The value of the MTCR is return by the bit mtcr of the structure.
+
+When using KVM_SET_DEVICE_ATTR the MTCR is set by using the
+attr->attr value KVM_S390_VM_CPU_TOPO_MTCR_SET and cleared by
+using KVM_S390_VM_CPU_TOPO_MTCR_CLEAR.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 7a6b14874d65..df5e8279ffd0 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY	5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,15 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for cpu topology */
+#define KVM_S390_VM_CPU_TOPO_MTCR_CLEAR	0
+#define KVM_S390_VM_CPU_TOPO_MTCR_SET	1
+
+struct kvm_cpu_topology {
+	__u16 mtcr : 1;
+	__u16 reserved : 15;
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 95b96019ca8e..ae39041bb149 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = test_facility(11);
+		break;
 	default:
 		r = 0;
 	}
@@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		icpt_operexc_on_all_vcpus(kvm);
 		r = 0;
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = -EINVAL;
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus) {
+			r = -EBUSY;
+		} else if (test_facility(11)) {
+			set_kvm_facility(kvm->arch.model.fac_mask, 11);
+			set_kvm_facility(kvm->arch.model.fac_list, 11);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
+			 r ? "(not available)" : "(success)");
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -1710,6 +1727,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
 	ipte_unlock(kvm);
 }
 
+/**
+ * kvm_s390_sca_clear_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * Updates the Multiprocessor Topology-Change-Report to signal
+ * the guest with a topology change.
+ */
+static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
+
+	ipte_lock(kvm);
+	sca->utility &= ~SCA_UTILITY_MTCR;
+	ipte_unlock(kvm);
+}
+
+static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_CPU_TOPO_MTCR_SET:
+		kvm_s390_sca_set_mtcr(kvm);
+		break;
+	case KVM_S390_VM_CPU_TOPO_MTCR_CLEAR:
+		kvm_s390_sca_clear_mtcr(kvm);
+		break;
+	}
+	return 0;
+}
+
+/**
+ * kvm_s390_sca_get_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * reports to QEMU the Multiprocessor Topology-Change-Report.
+ */
+static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
+	int val;
+
+	ipte_lock(kvm);
+	val = sca->utility & SCA_UTILITY_MTCR;
+	ipte_unlock(kvm);
+
+	return val;
+}
+
+static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_cpu_topology topo = {};
+
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	topo.mtcr = kvm_s390_sca_get_mtcr(kvm) ? 1 : 0;
+	if (copy_to_user((void __user *)attr->addr, &topo, sizeof(topo)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -1730,6 +1817,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_set_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1755,6 +1845,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_get_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1828,6 +1921,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = test_kvm_facility(kvm, 11) ? 0 : -ENXIO;
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..33317d820032 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_S390_CPU_TOPOLOGY 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1

