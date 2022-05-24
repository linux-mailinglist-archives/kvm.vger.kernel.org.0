Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CECD53313C
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbiEXTFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240839AbiEXTEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:04:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90299ABF52
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:03:42 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIKmOJ032376;
        Tue, 24 May 2022 19:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0jqkOkkguEuybqg8uTwOU8iOs46hSGO791UHSq2HPTw=;
 b=nZk4tz8J0+NyLjtRQI8/P4EKvwMYxpDSawoLgCij6wmCqZsBFTAxZ5JDT3zqgxSfVmAy
 QL68BwXSSbeDOD0Bw94/hparD/azJa25Sc9uPkjETOjvol9+hIcgvCfg0mP8guszshCc
 ESKhQ3GY9HhEAKRLHZtSTexN89AzBeFE8dlvZWwVH2bZyqA302pPpAcEUgnqDqqxTDYf
 Bi1EB8/qTp6rys9IcdU/SBsxhB8//3sKHKBLiLRndmyNYy7wz7uLLtrAp3YwNKpN10y1
 o4xpIkz6gATfR0PbZC8J9kJ0jMcV+GzLy644C690PXCSHpJB7+Hz1k6wrXGvoH+GQLjr aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0qc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIwZtw013437;
        Tue, 24 May 2022 19:03:22 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0qbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:22 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OJ2ug1015882;
        Tue, 24 May 2022 19:03:21 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v80q4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:21 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ3KMZ21168510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:03:20 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8263A124053;
        Tue, 24 May 2022 19:03:20 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FF82124055;
        Tue, 24 May 2022 19:03:17 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:03:17 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 1/8] Update linux headers
Date:   Tue, 24 May 2022 15:02:58 -0400
Message-Id: <20220524190305.140717-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524190305.140717-1-mjrosato@linux.ibm.com>
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: evwRM03yOggto93A9CJUu8nVoFiI7s7K
X-Proofpoint-GUID: HO3yRDf9iwNKYOMTYakr2MBlrlUXMsjO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=1011 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205240094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a placeholder that pulls in unmerged kernel changes
required by this item.  A proper header sync can be done once the
associated kernel code merges.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 linux-headers/asm-s390/kvm.h    |  1 +
 linux-headers/linux/kvm.h       | 32 ++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h      |  4 ++--
 linux-headers/linux/vfio_zdev.h |  7 +++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index f053b8304a..d8259ff9a1 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -130,6 +130,7 @@ struct kvm_s390_vm_cpu_machine {
 #define KVM_S390_VM_CPU_FEAT_PFMFI	11
 #define KVM_S390_VM_CPU_FEAT_SIGPIF	12
 #define KVM_S390_VM_CPU_FEAT_KSS	13
+#define KVM_S390_VM_CPU_FEAT_ZPCI_INTERP 14
 struct kvm_s390_vm_cpu_feat {
 	__u64 feat[16];
 };
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 0d05d02ee4..3013371078 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1150,6 +1150,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_S390_ZPCI_OP 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2066,4 +2067,35 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_ZPCI_OP */
+#define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd0, struct kvm_s390_zpci_op)
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
+
+
 #endif /* __LINUX_KVM_H */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index e9f7795c39..ede44b5572 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -643,7 +643,7 @@ enum {
 };
 
 /**
- * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IORW(VFIO_TYPE, VFIO_BASE + 12,
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
  *
  * Return: 0 on success, -errno on failure:
@@ -770,7 +770,7 @@ struct vfio_device_ioeventfd {
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
 /**
- * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
+ * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
  *			       struct vfio_device_feature)
  *
  * Get, set, or probe feature data of the device.  The feature is selected
diff --git a/linux-headers/linux/vfio_zdev.h b/linux-headers/linux/vfio_zdev.h
index b4309397b6..77f2aff1f2 100644
--- a/linux-headers/linux/vfio_zdev.h
+++ b/linux-headers/linux/vfio_zdev.h
@@ -29,6 +29,9 @@ struct vfio_device_info_cap_zpci_base {
 	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
 	__u8 pft;		/* PCI Function Type */
 	__u8 gid;		/* PCI function group ID */
+	/* End of version 1 */
+	__u32 fh;		/* PCI function handle */
+	/* End of version 2 */
 };
 
 /**
@@ -47,6 +50,10 @@ struct vfio_device_info_cap_zpci_group {
 	__u16 noi;		/* Maximum number of MSIs */
 	__u16 maxstbl;		/* Maximum Store Block Length */
 	__u8 version;		/* Supported PCI Version */
+	/* End of version 1 */
+	__u8 reserved;
+	__u16 imaxstbl;		/* Maximum Interpreted Store Block Length */
+	/* End of version 2 */
 };
 
 /**
-- 
2.27.0

