Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2A51D434
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 11:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390426AbiEFJYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 05:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389893AbiEFJYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 05:24:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887664BE8;
        Fri,  6 May 2022 02:20:38 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2469BvA0004753;
        Fri, 6 May 2022 09:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zgRFUssgjQGCem1D9ajuF6ScwcVLPWvHtW8B60B/npA=;
 b=PLtFdaTYeDuBI4IbMaG4cbebp9ZlYds0FCkXxD/mYqINXcZ9eFBQhL4WFUYC6Dx3rktf
 QCLdx5evWIUkcyRF3oxpP/WVobsijCL7B5MxuSxjHRUTLAkPgvWvX+M0wShoUlXJDEW8
 qp77YymJ5dNHdGxaMKhZNl3ljr3gF7V/eQqrLLT0LWdOrKcBuAv31CtgLhwArEYaX28d
 RQQl0ERfB6fnXnsbU5clRYoa7DGWe1d13ubtXQ7SaRRgVRJC95MSNnOmESc/gmO/9RF4
 j0eyEPe0W+B+ni9Heh6t/9SOtFrsl6E8J7Mn6cIMm2GTk1L6dagSfQ2HmTs9P0Sh6t8Z XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw0tx85du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:37 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2469Kb3Q030228;
        Fri, 6 May 2022 09:20:37 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw0tx85dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:37 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2469DCOG003016;
        Fri, 6 May 2022 09:20:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3fvm08gkw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2469KVHE45810170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 09:20:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C162111C050;
        Fri,  6 May 2022 09:20:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09FCE11C04A;
        Fri,  6 May 2022 09:20:31 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.79])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 09:20:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Date:   Fri,  6 May 2022 11:24:03 +0200
Message-Id: <20220506092403.47406-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506092403.47406-1-pmorel@linux.ibm.com>
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VtUrtVgR6yM3XUQHsCrjz3y0_-8teZO9
X-Proofpoint-GUID: ZGMZWuL-90XVg9WkE3HNaosDkAGucPlK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 clxscore=1015 bulkscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060049
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

To migrate the MTCR, let's give userland the possibility to
query the MTCR state.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |  5 ++
 arch/s390/kvm/kvm-s390.c         | 79 ++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 7a6b14874d65..abdcf4069343 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY	5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for cpu topology */
+#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
+#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c8bdce31464f..80a1244f0ead 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1731,6 +1731,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
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
+	sca->utility  &= ~SCA_UTILITY_MTCR;
+	ipte_unlock(kvm);
+}
+
+static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_CPU_TOPO_MTR_SET:
+		kvm_s390_sca_set_mtcr(kvm);
+		break;
+	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
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
+	val = !!(sca->utility & SCA_UTILITY_MTCR);
+	ipte_unlock(kvm);
+
+	return val;
+}
+
+static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int mtcr;
+
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	mtcr = kvm_s390_sca_get_mtcr(kvm);
+	if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -1751,6 +1821,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_set_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1776,6 +1849,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_get_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1849,6 +1925,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = test_kvm_facility(kvm, 11) ? 0 : -ENXIO;
+		break;
 	default:
 		ret = -ENXIO;
 		break;
-- 
2.27.0

