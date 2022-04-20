Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15712508771
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378335AbiDTL5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbiDTL5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410AC419A1
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:43 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KBXogv011298;
        Wed, 20 Apr 2022 11:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f8wJ++C7xcDma/IPpZBTzFb9xlvcjHsoB3p+fCafGoc=;
 b=ogeQtcn/OiYfViEehYuZwfH7mCie6R11/NnjWGgwkRQ9t2NRRRlwP+b6+FxDR0SlDaLZ
 odOTGtadttx+Z1154xFMbry8g6Y9pKopj1OpPY1IByaBu2TMniR7bfUnzorw6x60Uecm
 IZZlZ9X07rxNfBbcG+a/FgiaWCrDFjnGG8H0U0jHiwjADsq7ib9DbX3DXTN+0AO5VdC9
 SFzNcq6d6XQxNACGcziCHIbo67ETy/wxSDNo7a5vbqEo2NsieuUW6N5rrdktZdR387Pk
 gc0/oNmkcKJhf+y2+HLlL3LLpJzGK5qlGtbaA3G/qWfuBUZgRFpRzZ75428q49/R0sA0 QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7kb8ffd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBsaqf011312;
        Wed, 20 Apr 2022 11:54:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7kb8feu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBs1YT021711;
        Wed, 20 Apr 2022 11:54:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u3cke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBsfRA11862768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:54:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45660AE053;
        Wed, 20 Apr 2022 11:54:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F88CAE051;
        Wed, 20 Apr 2022 11:54:29 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:29 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 01/13] Update linux headers
Date:   Wed, 20 Apr 2022 13:57:33 +0200
Message-Id: <20220420115745.13696-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mfqwATzSkqUxAGCCz19980xWO3XmrkkJ
X-Proofpoint-GUID: cqTSsjICig6SrRWEeKPuY57ZQVFCNqAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a placeholder that pulls in 5.18-rc3 + unmerged kernel changes
required by this item.  A proper header sync can be done once the
associated kernel code merges.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 .../linux/input-event-codes.h                 |   4 +-
 .../standard-headers/linux/virtio_config.h    |   6 +
 .../standard-headers/linux/virtio_crypto.h    |  82 +++-
 linux-headers/asm-arm64/kvm.h                 |  16 +
 linux-headers/asm-generic/mman-common.h       |   2 +
 linux-headers/asm-mips/mman.h                 |   2 +
 linux-headers/asm-s390/kvm.h                  |   9 +
 linux-headers/linux/kvm.h                     |  20 +-
 linux-headers/linux/psci.h                    |   4 +
 linux-headers/linux/userfaultfd.h             |   8 +-
 linux-headers/linux/vfio.h                    | 406 +++++++++---------
 linux-headers/linux/vhost.h                   |   7 +
 12 files changed, 347 insertions(+), 219 deletions(-)

diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index b5e86b40ab..e36c01003a 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -278,7 +278,8 @@
 #define KEY_PAUSECD		201
 #define KEY_PROG3		202
 #define KEY_PROG4		203
-#define KEY_DASHBOARD		204	/* AL Dashboard */
+#define KEY_ALL_APPLICATIONS	204	/* AC Desktop Show All Applications */
+#define KEY_DASHBOARD		KEY_ALL_APPLICATIONS
 #define KEY_SUSPEND		205
 #define KEY_CLOSE		206	/* AC Close */
 #define KEY_PLAY		207
@@ -612,6 +613,7 @@
 #define KEY_ASSISTANT		0x247	/* AL Context-aware desktop assistant */
 #define KEY_KBD_LAYOUT_NEXT	0x248	/* AC Next Keyboard Layout Select */
 #define KEY_EMOJI_PICKER	0x249	/* Show/hide emoji picker (HUTRR101) */
+#define KEY_DICTATE		0x24a	/* Start or Stop Voice Dictation Session (HUTRR99) */
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index 22e3a85f67..7acd8d4abc 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -80,6 +80,12 @@
 /* This feature indicates support for the packed virtqueue layout. */
 #define VIRTIO_F_RING_PACKED		34
 
+/*
+ * Inorder feature indicates that all buffers are used by the device
+ * in the same order in which they have been made available.
+ */
+#define VIRTIO_F_IN_ORDER		35
+
 /*
  * This feature indicates that memory accesses by the driver and the
  * device are ordered in a way described by the platform.
diff --git a/include/standard-headers/linux/virtio_crypto.h b/include/standard-headers/linux/virtio_crypto.h
index 5ff0b4ee59..68066dafb6 100644
--- a/include/standard-headers/linux/virtio_crypto.h
+++ b/include/standard-headers/linux/virtio_crypto.h
@@ -37,6 +37,7 @@
 #define VIRTIO_CRYPTO_SERVICE_HASH   1
 #define VIRTIO_CRYPTO_SERVICE_MAC    2
 #define VIRTIO_CRYPTO_SERVICE_AEAD   3
+#define VIRTIO_CRYPTO_SERVICE_AKCIPHER 4
 
 #define VIRTIO_CRYPTO_OPCODE(service, op)   (((service) << 8) | (op))
 
@@ -57,6 +58,10 @@ struct virtio_crypto_ctrl_header {
 	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x02)
 #define VIRTIO_CRYPTO_AEAD_DESTROY_SESSION \
 	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x03)
+#define VIRTIO_CRYPTO_AKCIPHER_CREATE_SESSION \
+	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x04)
+#define VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION \
+	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x05)
 	uint32_t opcode;
 	uint32_t algo;
 	uint32_t flag;
@@ -180,6 +185,58 @@ struct virtio_crypto_aead_create_session_req {
 	uint8_t padding[32];
 };
 
+struct virtio_crypto_rsa_session_para {
+#define VIRTIO_CRYPTO_RSA_RAW_PADDING   0
+#define VIRTIO_CRYPTO_RSA_PKCS1_PADDING 1
+	uint32_t padding_algo;
+
+#define VIRTIO_CRYPTO_RSA_NO_HASH   0
+#define VIRTIO_CRYPTO_RSA_MD2       1
+#define VIRTIO_CRYPTO_RSA_MD3       2
+#define VIRTIO_CRYPTO_RSA_MD4       3
+#define VIRTIO_CRYPTO_RSA_MD5       4
+#define VIRTIO_CRYPTO_RSA_SHA1      5
+#define VIRTIO_CRYPTO_RSA_SHA256    6
+#define VIRTIO_CRYPTO_RSA_SHA384    7
+#define VIRTIO_CRYPTO_RSA_SHA512    8
+#define VIRTIO_CRYPTO_RSA_SHA224    9
+	uint32_t hash_algo;
+};
+
+struct virtio_crypto_ecdsa_session_para {
+#define VIRTIO_CRYPTO_CURVE_UNKNOWN   0
+#define VIRTIO_CRYPTO_CURVE_NIST_P192 1
+#define VIRTIO_CRYPTO_CURVE_NIST_P224 2
+#define VIRTIO_CRYPTO_CURVE_NIST_P256 3
+#define VIRTIO_CRYPTO_CURVE_NIST_P384 4
+#define VIRTIO_CRYPTO_CURVE_NIST_P521 5
+	uint32_t curve_id;
+	uint32_t padding;
+};
+
+struct virtio_crypto_akcipher_session_para {
+#define VIRTIO_CRYPTO_NO_AKCIPHER    0
+#define VIRTIO_CRYPTO_AKCIPHER_RSA   1
+#define VIRTIO_CRYPTO_AKCIPHER_DSA   2
+#define VIRTIO_CRYPTO_AKCIPHER_ECDSA 3
+	uint32_t algo;
+
+#define VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC  1
+#define VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE 2
+	uint32_t keytype;
+	uint32_t keylen;
+
+	union {
+		struct virtio_crypto_rsa_session_para rsa;
+		struct virtio_crypto_ecdsa_session_para ecdsa;
+	} u;
+};
+
+struct virtio_crypto_akcipher_create_session_req {
+	struct virtio_crypto_akcipher_session_para para;
+	uint8_t padding[36];
+};
+
 struct virtio_crypto_alg_chain_session_para {
 #define VIRTIO_CRYPTO_SYM_ALG_CHAIN_ORDER_HASH_THEN_CIPHER  1
 #define VIRTIO_CRYPTO_SYM_ALG_CHAIN_ORDER_CIPHER_THEN_HASH  2
@@ -247,6 +304,8 @@ struct virtio_crypto_op_ctrl_req {
 			mac_create_session;
 		struct virtio_crypto_aead_create_session_req
 			aead_create_session;
+		struct virtio_crypto_akcipher_create_session_req
+			akcipher_create_session;
 		struct virtio_crypto_destroy_session_req
 			destroy_session;
 		uint8_t padding[56];
@@ -266,6 +325,14 @@ struct virtio_crypto_op_header {
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x00)
 #define VIRTIO_CRYPTO_AEAD_DECRYPT \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x01)
+#define VIRTIO_CRYPTO_AKCIPHER_ENCRYPT \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x00)
+#define VIRTIO_CRYPTO_AKCIPHER_DECRYPT \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x01)
+#define VIRTIO_CRYPTO_AKCIPHER_SIGN \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x02)
+#define VIRTIO_CRYPTO_AKCIPHER_VERIFY \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x03)
 	uint32_t opcode;
 	/* algo should be service-specific algorithms */
 	uint32_t algo;
@@ -390,6 +457,16 @@ struct virtio_crypto_aead_data_req {
 	uint8_t padding[32];
 };
 
+struct virtio_crypto_akcipher_para {
+	uint32_t src_data_len;
+	uint32_t dst_data_len;
+};
+
+struct virtio_crypto_akcipher_data_req {
+	struct virtio_crypto_akcipher_para para;
+	uint8_t padding[40];
+};
+
 /* The request of the data virtqueue's packet */
 struct virtio_crypto_op_data_req {
 	struct virtio_crypto_op_header header;
@@ -399,6 +476,7 @@ struct virtio_crypto_op_data_req {
 		struct virtio_crypto_hash_data_req hash_req;
 		struct virtio_crypto_mac_data_req mac_req;
 		struct virtio_crypto_aead_data_req aead_req;
+		struct virtio_crypto_akcipher_data_req akcipher_req;
 		uint8_t padding[48];
 	} u;
 };
@@ -408,6 +486,8 @@ struct virtio_crypto_op_data_req {
 #define VIRTIO_CRYPTO_BADMSG    2
 #define VIRTIO_CRYPTO_NOTSUPP   3
 #define VIRTIO_CRYPTO_INVSESS   4 /* Invalid session id */
+#define VIRTIO_CRYPTO_NOSPC     5 /* no free session ID */
+#define VIRTIO_CRYPTO_KEY_REJECTED 6 /* Signature verification failed */
 
 /* The accelerator hardware is ready */
 #define VIRTIO_CRYPTO_S_HW_READY  (1 << 0)
@@ -438,7 +518,7 @@ struct virtio_crypto_config {
 	uint32_t max_cipher_key_len;
 	/* Maximum length of authenticated key */
 	uint32_t max_auth_key_len;
-	uint32_t reserve;
+	uint32_t akcipher_algo;
 	/* Maximum size of each crypto request's content */
 	uint64_t max_size;
 };
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 3d2ce9912d..5c28a9737a 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -281,6 +281,11 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3	KVM_REG_ARM_FW_REG(3)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED	2
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
@@ -362,6 +367,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
 #define   KVM_ARM_VCPU_PMU_V3_FILTER	2
+#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
@@ -411,6 +417,16 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* arm64-specific kvm_run::system_event flags */
+/*
+ * Reset caused by a PSCI v1.1 SYSTEM_RESET2 call.
+ * Valid only when the system event has a type of KVM_SYSTEM_EVENT_RESET.
+ */
+#define KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2	(1ULL << 0)
+
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/linux-headers/asm-generic/mman-common.h b/linux-headers/asm-generic/mman-common.h
index 1567a3294c..6c1aa92a92 100644
--- a/linux-headers/asm-generic/mman-common.h
+++ b/linux-headers/asm-generic/mman-common.h
@@ -75,6 +75,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/linux-headers/asm-mips/mman.h b/linux-headers/asm-mips/mman.h
index 40b210c65a..1be428663c 100644
--- a/linux-headers/asm-mips/mman.h
+++ b/linux-headers/asm-mips/mman.h
@@ -101,6 +101,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index f053b8304a..b83747876f 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY	5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,14 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for cpu topology */
+#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
+#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
+
+struct kvm_s390_cpu_topology {
+	__u16 mtcr;
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index d232feaae9..f7191a8e34 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -562,9 +562,12 @@ struct kvm_s390_mem_op {
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
 	union {
-		__u8 ar;	/* the access register number */
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+		};
 		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* should be set to 0 */
+		__u8 reserved[32]; /* ignored */
 	};
 };
 /* types for kvm_s390_mem_op->op */
@@ -572,9 +575,12 @@ struct kvm_s390_mem_op {
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
 #define KVM_S390_MEMOP_SIDA_READ	2
 #define KVM_S390_MEMOP_SIDA_WRITE	3
+#define KVM_S390_MEMOP_ABSOLUTE_READ	4
+#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
 
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
@@ -1134,6 +1140,11 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_S390_MEM_OP_EXTENSION 211
+#define KVM_CAP_PMU_CAPABILITY 212
+#define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_S390_CPU_TOPOLOGY 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1624,9 +1635,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-/* Available with KVM_CAP_XSAVE2 */
-#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
-
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
@@ -1973,6 +1981,8 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_PMU_CAP_DISABLE                    (1 << 0)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
diff --git a/linux-headers/linux/psci.h b/linux-headers/linux/psci.h
index a6772d508b..213b2a0f70 100644
--- a/linux-headers/linux/psci.h
+++ b/linux-headers/linux/psci.h
@@ -82,6 +82,10 @@
 #define PSCI_0_2_TOS_UP_NO_MIGRATE		1
 #define PSCI_0_2_TOS_MP				2
 
+/* PSCI v1.1 reset type encoding for SYSTEM_RESET2 */
+#define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
+#define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
diff --git a/linux-headers/linux/userfaultfd.h b/linux-headers/linux/userfaultfd.h
index 8479af5f4c..769b8379e4 100644
--- a/linux-headers/linux/userfaultfd.h
+++ b/linux-headers/linux/userfaultfd.h
@@ -32,7 +32,8 @@
 			   UFFD_FEATURE_SIGBUS |		\
 			   UFFD_FEATURE_THREAD_ID |		\
 			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
-			   UFFD_FEATURE_MINOR_SHMEM)
+			   UFFD_FEATURE_MINOR_SHMEM |		\
+			   UFFD_FEATURE_EXACT_ADDRESS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -189,6 +190,10 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
 	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
+	 *
+	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
+	 * faults would be provided and the offset within the page would not be
+	 * masked.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -201,6 +206,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
 #define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
 #define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
+#define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index e680594f27..e9f7795c39 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -323,7 +323,7 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
-#define VFIO_REGION_TYPE_MIGRATION              (3)
+#define VFIO_REGION_TYPE_MIGRATION_DEPRECATED   (3)
 
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
@@ -405,225 +405,29 @@ struct vfio_region_gfx_edid {
 #define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
 
 /* sub-types for VFIO_REGION_TYPE_MIGRATION */
-#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
-
-/*
- * The structure vfio_device_migration_info is placed at the 0th offset of
- * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
- * migration information. Field accesses from this structure are only supported
- * at their native width and alignment. Otherwise, the result is undefined and
- * vendor drivers should return an error.
- *
- * device_state: (read/write)
- *      - The user application writes to this field to inform the vendor driver
- *        about the device state to be transitioned to.
- *      - The vendor driver should take the necessary actions to change the
- *        device state. After successful transition to a given state, the
- *        vendor driver should return success on write(device_state, state)
- *        system call. If the device state transition fails, the vendor driver
- *        should return an appropriate -errno for the fault condition.
- *      - On the user application side, if the device state transition fails,
- *	  that is, if write(device_state, state) returns an error, read
- *	  device_state again to determine the current state of the device from
- *	  the vendor driver.
- *      - The vendor driver should return previous state of the device unless
- *        the vendor driver has encountered an internal error, in which case
- *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
- *      - The user application must use the device reset ioctl to recover the
- *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
- *        indicated to be in a valid device state by reading device_state, the
- *        user application may attempt to transition the device to any valid
- *        state reachable from the current state or terminate itself.
- *
- *      device_state consists of 3 bits:
- *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
- *        it indicates the _STOP state. When the device state is changed to
- *        _STOP, driver should stop the device before write() returns.
- *      - If bit 1 is set, it indicates the _SAVING state, which means that the
- *        driver should start gathering device state information that will be
- *        provided to the VFIO user application to save the device's state.
- *      - If bit 2 is set, it indicates the _RESUMING state, which means that
- *        the driver should prepare to resume the device. Data provided through
- *        the migration region should be used to resume the device.
- *      Bits 3 - 31 are reserved for future use. To preserve them, the user
- *      application should perform a read-modify-write operation on this
- *      field when modifying the specified bits.
- *
- *  +------- _RESUMING
- *  |+------ _SAVING
- *  ||+----- _RUNNING
- *  |||
- *  000b => Device Stopped, not saving or resuming
- *  001b => Device running, which is the default state
- *  010b => Stop the device & save the device state, stop-and-copy state
- *  011b => Device running and save the device state, pre-copy state
- *  100b => Device stopped and the device state is resuming
- *  101b => Invalid state
- *  110b => Error state
- *  111b => Invalid state
- *
- * State transitions:
- *
- *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
- *                (100b)     (001b)     (011b)        (010b)       (000b)
- * 0. Running or default state
- *                             |
- *
- * 1. Normal Shutdown (optional)
- *                             |------------------------------------->|
- *
- * 2. Save the state or suspend
- *                             |------------------------->|---------->|
- *
- * 3. Save the state during live migration
- *                             |----------->|------------>|---------->|
- *
- * 4. Resuming
- *                  |<---------|
- *
- * 5. Resumed
- *                  |--------->|
- *
- * 0. Default state of VFIO device is _RUNNING when the user application starts.
- * 1. During normal shutdown of the user application, the user application may
- *    optionally change the VFIO device state from _RUNNING to _STOP. This
- *    transition is optional. The vendor driver must support this transition but
- *    must not require it.
- * 2. When the user application saves state or suspends the application, the
- *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
- *    On state transition from _RUNNING to stop-and-copy, driver must stop the
- *    device, save the device state and send it to the application through the
- *    migration region. The sequence to be followed for such transition is given
- *    below.
- * 3. In live migration of user application, the state transitions from _RUNNING
- *    to pre-copy, to stop-and-copy, and to _STOP.
- *    On state transition from _RUNNING to pre-copy, the driver should start
- *    gathering the device state while the application is still running and send
- *    the device state data to application through the migration region.
- *    On state transition from pre-copy to stop-and-copy, the driver must stop
- *    the device, save the device state and send it to the user application
- *    through the migration region.
- *    Vendor drivers must support the pre-copy state even for implementations
- *    where no data is provided to the user before the stop-and-copy state. The
- *    user must not be required to consume all migration data before the device
- *    transitions to a new state, including the stop-and-copy state.
- *    The sequence to be followed for above two transitions is given below.
- * 4. To start the resuming phase, the device state should be transitioned from
- *    the _RUNNING to the _RESUMING state.
- *    In the _RESUMING state, the driver should use the device state data
- *    received through the migration region to resume the device.
- * 5. After providing saved device data to the driver, the application should
- *    change the state from _RESUMING to _RUNNING.
- *
- * reserved:
- *      Reads on this field return zero and writes are ignored.
- *
- * pending_bytes: (read only)
- *      The number of pending bytes still to be migrated from the vendor driver.
- *
- * data_offset: (read only)
- *      The user application should read data_offset field from the migration
- *      region. The user application should read the device data from this
- *      offset within the migration region during the _SAVING state or write
- *      the device data during the _RESUMING state. See below for details of
- *      sequence to be followed.
- *
- * data_size: (read/write)
- *      The user application should read data_size to get the size in bytes of
- *      the data copied in the migration region during the _SAVING state and
- *      write the size in bytes of the data copied in the migration region
- *      during the _RESUMING state.
- *
- * The format of the migration region is as follows:
- *  ------------------------------------------------------------------
- * |vfio_device_migration_info|    data section                      |
- * |                          |     ///////////////////////////////  |
- * ------------------------------------------------------------------
- *   ^                              ^
- *  offset 0-trapped part        data_offset
- *
- * The structure vfio_device_migration_info is always followed by the data
- * section in the region, so data_offset will always be nonzero. The offset
- * from where the data is copied is decided by the kernel driver. The data
- * section can be trapped, mmapped, or partitioned, depending on how the kernel
- * driver defines the data section. The data section partition can be defined
- * as mapped by the sparse mmap capability. If mmapped, data_offset must be
- * page aligned, whereas initial section which contains the
- * vfio_device_migration_info structure, might not end at the offset, which is
- * page aligned. The user is not required to access through mmap regardless
- * of the capabilities of the region mmap.
- * The vendor driver should determine whether and how to partition the data
- * section. The vendor driver should return data_offset accordingly.
- *
- * The sequence to be followed while in pre-copy state and stop-and-copy state
- * is as follows:
- * a. Read pending_bytes, indicating the start of a new iteration to get device
- *    data. Repeated read on pending_bytes at this stage should have no side
- *    effects.
- *    If pending_bytes == 0, the user application should not iterate to get data
- *    for that device.
- *    If pending_bytes > 0, perform the following steps.
- * b. Read data_offset, indicating that the vendor driver should make data
- *    available through the data section. The vendor driver should return this
- *    read operation only after data is available from (region + data_offset)
- *    to (region + data_offset + data_size).
- * c. Read data_size, which is the amount of data in bytes available through
- *    the migration region.
- *    Read on data_offset and data_size should return the offset and size of
- *    the current buffer if the user application reads data_offset and
- *    data_size more than once here.
- * d. Read data_size bytes of data from (region + data_offset) from the
- *    migration region.
- * e. Process the data.
- * f. Read pending_bytes, which indicates that the data from the previous
- *    iteration has been read. If pending_bytes > 0, go to step b.
- *
- * The user application can transition from the _SAVING|_RUNNING
- * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
- * number of pending bytes. The user application should iterate in _SAVING
- * (stop-and-copy) until pending_bytes is 0.
- *
- * The sequence to be followed while _RESUMING device state is as follows:
- * While data for this device is available, repeat the following steps:
- * a. Read data_offset from where the user application should write data.
- * b. Write migration data starting at the migration region + data_offset for
- *    the length determined by data_size from the migration source.
- * c. Write data_size, which indicates to the vendor driver that data is
- *    written in the migration region. Vendor driver must return this write
- *    operations on consuming data. Vendor driver should apply the
- *    user-provided migration region data to the device resume state.
- *
- * If an error occurs during the above sequences, the vendor driver can return
- * an error code for next read() or write() operation, which will terminate the
- * loop. The user application should then take the next necessary action, for
- * example, failing migration or terminating the user application.
- *
- * For the user application, data is opaque. The user application should write
- * data in the same order as the data is received and the data should be of
- * same transaction size at the source.
- */
+#define VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED (1)
 
 struct vfio_device_migration_info {
 	__u32 device_state;         /* VFIO device state */
-#define VFIO_DEVICE_STATE_STOP      (0)
-#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
-#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
-#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
-#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
-				     VFIO_DEVICE_STATE_SAVING |  \
-				     VFIO_DEVICE_STATE_RESUMING)
+#define VFIO_DEVICE_STATE_V1_STOP      (0)
+#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
+#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
+#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING | \
+				     VFIO_DEVICE_STATE_V1_SAVING |  \
+				     VFIO_DEVICE_STATE_V1_RESUMING)
 
 #define VFIO_DEVICE_STATE_VALID(state) \
-	(state & VFIO_DEVICE_STATE_RESUMING ? \
-	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
+	(state & VFIO_DEVICE_STATE_V1_RESUMING ? \
+	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_V1_RESUMING : 1)
 
 #define VFIO_DEVICE_STATE_IS_ERROR(state) \
-	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
-					      VFIO_DEVICE_STATE_RESUMING))
+	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_V1_SAVING | \
+					      VFIO_DEVICE_STATE_V1_RESUMING))
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_V1_SAVING | \
+					     VFIO_DEVICE_STATE_V1_RESUMING)
 
 	__u32 reserved;
 	__u64 pending_bytes;
@@ -1002,6 +806,186 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Indicates the device can support the migration API through
+ * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If this GET succeeds, the RUNNING and
+ * ERROR states are always supported. Support for additional states is
+ * indicated via the flags field; at least VFIO_MIGRATION_STOP_COPY must be
+ * set.
+ *
+ * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
+ * RESUMING are supported.
+ *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
+ * is supported in addition to the STOP_COPY states.
+ *
+ * Other combinations of flags have behavior to be defined in the future.
+ */
+struct vfio_device_feature_migration {
+	__aligned_u64 flags;
+#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
+#define VFIO_MIGRATION_P2P		(1 << 1)
+};
+#define VFIO_DEVICE_FEATURE_MIGRATION 1
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, execute a migration state change on the VFIO
+ * device. The new state is supplied in device_state, see enum
+ * vfio_device_mig_state for details
+ *
+ * The kernel migration driver must fully transition the device to the new state
+ * value before the operation returns to the user.
+ *
+ * The kernel migration driver must not generate asynchronous device state
+ * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
+ * ioctl as described above.
+ *
+ * If this function fails then current device_state may be the original
+ * operating state or some other state along the combination transition path.
+ * The user can then decide if it should execute a VFIO_DEVICE_RESET, attempt
+ * to return to the original state, or attempt to return to some other state
+ * such as RUNNING or STOP.
+ *
+ * If the new_state starts a new data transfer session then the FD associated
+ * with that session is returned in data_fd. The user is responsible to close
+ * this FD when it is finished. The user must consider the migration data stream
+ * carried over the FD to be opaque and must preserve the byte order of the
+ * stream. The user is not required to preserve buffer segmentation when writing
+ * the data stream during the RESUMING operation.
+ *
+ * Upon VFIO_DEVICE_FEATURE_GET, get the current migration state of the VFIO
+ * device, data_fd will be -1.
+ */
+struct vfio_device_feature_mig_state {
+	__u32 device_state; /* From enum vfio_device_mig_state */
+	__s32 data_fd;
+};
+#define VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE 2
+
+/*
+ * The device migration Finite State Machine is described by the enum
+ * vfio_device_mig_state. Some of the FSM arcs will create a migration data
+ * transfer session by returning a FD, in this case the migration data will
+ * flow over the FD using read() and write() as discussed below.
+ *
+ * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
+ *  RUNNING - The device is running normally
+ *  STOP - The device does not change the internal or external state
+ *  STOP_COPY - The device internal state can be read out
+ *  RESUMING - The device is stopped and is loading a new internal state
+ *  ERROR - The device has failed and must be reset
+ *
+ * And 1 optional state to support VFIO_MIGRATION_P2P:
+ *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
+ *
+ * The FSM takes actions on the arcs between FSM states. The driver implements
+ * the following behavior for the FSM arcs:
+ *
+ * RUNNING_P2P -> STOP
+ * STOP_COPY -> STOP
+ *   While in STOP the device must stop the operation of the device. The device
+ *   must not generate interrupts, DMA, or any other change to external state.
+ *   It must not change its internal state. When stopped the device and kernel
+ *   migration driver must accept and respond to interaction to support external
+ *   subsystems in the STOP state, for example PCI MSI-X and PCI config space.
+ *   Failure by the user to restrict device access while in STOP must not result
+ *   in error conditions outside the user context (ex. host system faults).
+ *
+ *   The STOP_COPY arc will terminate a data transfer session.
+ *
+ * RESUMING -> STOP
+ *   Leaving RESUMING terminates a data transfer session and indicates the
+ *   device should complete processing of the data delivered by write(). The
+ *   kernel migration driver should complete the incorporation of data written
+ *   to the data transfer FD into the device internal state and perform
+ *   final validity and consistency checking of the new device state. If the
+ *   user provided data is found to be incomplete, inconsistent, or otherwise
+ *   invalid, the migration driver must fail the SET_STATE ioctl and
+ *   optionally go to the ERROR state as described below.
+ *
+ *   While in STOP the device has the same behavior as other STOP states
+ *   described above.
+ *
+ *   To abort a RESUMING session the device must be reset.
+ *
+ * RUNNING_P2P -> RUNNING
+ *   While in RUNNING the device is fully operational, the device may generate
+ *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
+ *   and the device may advance its internal state.
+ *
+ * RUNNING -> RUNNING_P2P
+ * STOP -> RUNNING_P2P
+ *   While in RUNNING_P2P the device is partially running in the P2P quiescent
+ *   state defined below.
+ *
+ * STOP -> STOP_COPY
+ *   This arc begin the process of saving the device state and will return a
+ *   new data_fd.
+ *
+ *   While in the STOP_COPY state the device has the same behavior as STOP
+ *   with the addition that the data transfers session continues to stream the
+ *   migration state. End of stream on the FD indicates the entire device
+ *   state has been transferred.
+ *
+ *   The user should take steps to restrict access to vfio device regions while
+ *   the device is in STOP_COPY or risk corruption of the device migration data
+ *   stream.
+ *
+ * STOP -> RESUMING
+ *   Entering the RESUMING state starts a process of restoring the device state
+ *   and will return a new data_fd. The data stream fed into the data_fd should
+ *   be taken from the data transfer output of a single FD during saving from
+ *   a compatible device. The migration driver may alter/reset the internal
+ *   device state for this arc if required to prepare the device to receive the
+ *   migration data.
+ *
+ * any -> ERROR
+ *   ERROR cannot be specified as a device state, however any transition request
+ *   can be failed with an errno return and may then move the device_state into
+ *   ERROR. In this case the device was unable to execute the requested arc and
+ *   was also unable to restore the device to any valid device_state.
+ *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
+ *   device_state back to RUNNING.
+ *
+ * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
+ * state for the device for the purposes of managing multiple devices within a
+ * user context where peer-to-peer DMA between devices may be active. The
+ * RUNNING_P2P states must prevent the device from initiating
+ * any new P2P DMA transactions. If the device can identify P2P transactions
+ * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
+ * driver must complete any such outstanding operations prior to completing the
+ * FSM arc into a P2P state. For the purpose of specification the states
+ * behave as though the device was fully running if not supported. Like while in
+ * STOP or STOP_COPY the user must not touch the device, otherwise the state
+ * can be exited.
+ *
+ * The remaining possible transitions are interpreted as combinations of the
+ * above FSM arcs. As there are multiple paths through the FSM arcs the path
+ * should be selected based on the following rules:
+ *   - Select the shortest path.
+ * Refer to vfio_mig_get_next_state() for the result of the algorithm.
+ *
+ * The automatic transit through the FSM arcs that make up the combination
+ * transition is invisible to the user. When working with combination arcs the
+ * user may see any step along the path in the device_state if SET_STATE
+ * fails. When handling these types of errors users should anticipate future
+ * revisions of this protocol using new states and those states becoming
+ * visible in this case.
+ *
+ * The optional states cannot be used with SET_STATE if the device does not
+ * support them. The user can discover if these states are supported by using
+ * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
+ * avoid knowing about these optional states if the kernel driver supports them.
+ */
+enum vfio_device_mig_state {
+	VFIO_DEVICE_STATE_ERROR = 0,
+	VFIO_DEVICE_STATE_STOP = 1,
+	VFIO_DEVICE_STATE_RUNNING = 2,
+	VFIO_DEVICE_STATE_STOP_COPY = 3,
+	VFIO_DEVICE_STATE_RESUMING = 4,
+	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index c998860d7b..5d99e7c242 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -150,4 +150,11 @@
 /* Get the valid iova range */
 #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
 					     struct vhost_vdpa_iova_range)
+
+/* Get the config size */
+#define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
+
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
 #endif
-- 
2.27.0

