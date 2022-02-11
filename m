Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D004B2CC0
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352663AbiBKSWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiBKSW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D44213A;
        Fri, 11 Feb 2022 10:22:28 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BG8cbw003365;
        Fri, 11 Feb 2022 18:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qxBZfgf8hN2GgRjJ/RSGAwsocPIU9mek478pfm148K8=;
 b=tEdUQx9fIPnZBdSEQqd7oU/tYCNEtbG2r5jRP125//fiXqNp/kzmzVSW1m6Gh/Fy5mXv
 CLIxFrkU4YCMFBN66sGJasXDATmUG1XQI4crIW60+J/el6bBM4h1YYmfyq6UEBV/VssZ
 dbS5u4nVe1ah4MB3tVYSkL8FaVTkkP/RE5auFaQ2fgR1gimwDhkyhQ+LjKLeoOT1/6Xg
 C+L4QlSIJ9wa8of2gTLKR+1vaV78jPWJG71oIggEXumyHfG+F2dlxUwsCct+qGDP9IMr
 b6R8PjmWBGpV/k2bha/eVUmRLdMG/8+urtn+3gBVYmIrrwRMooZUYz/BI/JdrQ12cqox 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5ph49fdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:27 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BIBmhq009751;
        Fri, 11 Feb 2022 18:22:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5ph49fd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BID40E032607;
        Fri, 11 Feb 2022 18:22:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gvac2wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIML0Z43975140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:22:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77AE652051;
        Fri, 11 Feb 2022 18:22:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0EBAB5204F;
        Fri, 11 Feb 2022 18:22:21 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 09/10] KVM: s390: Update api documentation for memop ioctl
Date:   Fri, 11 Feb 2022 19:22:14 +0100
Message-Id: <20220211182215.2730017-10-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DGFcinGbsnvE1FrNkHCpWwObnbuCF2iy
X-Proofpoint-GUID: DTY_AMexXPyGorioyxLLVlo6A-07hpA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=825 bulkscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document all currently existing operations, flags and explain under
which circumstances they are available. Document the recently
introduced absolute operations and the storage key protection flag,
as well as the existing SIDA operations.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 112 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h       |   2 +-
 2 files changed, 91 insertions(+), 23 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..48f23bb80d7f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3683,15 +3683,17 @@ The fields in each entry are defined as follows:
 4.89 KVM_S390_MEM_OP
 --------------------
 
-:Capability: KVM_CAP_S390_MEM_OP
+:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_PROTECTED, KVM_CAP_S390_MEM_OP_EXTENSION
 :Architectures: s390
-:Type: vcpu ioctl
+:Type: vm ioctl, vcpu ioctl
 :Parameters: struct kvm_s390_mem_op (in)
 :Returns: = 0 on success,
           < 0 on generic error (e.g. -EFAULT or -ENOMEM),
           > 0 if an exception occurred while walking the page tables
 
-Read or write data from/to the logical (virtual) memory of a VCPU.
+Read or write data from/to the VM's memory.
+The KVM_CAP_S390_MEM_OP_EXTENSION capability specifies what functionality is
+supported.
 
 Parameters are specified via the following structure::
 
@@ -3701,33 +3703,99 @@ Parameters are specified via the following structure::
 	__u32 size;		/* amount of bytes */
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
-	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	union {
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+		};
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* ignored */
+	};
   };
 
-The type of operation is specified in the "op" field. It is either
-KVM_S390_MEMOP_LOGICAL_READ for reading from logical memory space or
-KVM_S390_MEMOP_LOGICAL_WRITE for writing to logical memory space. The
-KVM_S390_MEMOP_F_CHECK_ONLY flag can be set in the "flags" field to check
-whether the corresponding memory access would create an access exception
-(without touching the data in the memory at the destination). In case an
-access exception occurred while walking the MMU tables of the guest, the
-ioctl returns a positive error number to indicate the type of exception.
-This exception is also raised directly at the corresponding VCPU if the
-flag KVM_S390_MEMOP_F_INJECT_EXCEPTION is set in the "flags" field.
-
 The start address of the memory region has to be specified in the "gaddr"
 field, and the length of the region in the "size" field (which must not
 be 0). The maximum value for "size" can be obtained by checking the
 KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
 userspace application where the read data should be written to for
-KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written is
-stored for a KVM_S390_MEMOP_LOGICAL_WRITE. When KVM_S390_MEMOP_F_CHECK_ONLY
-is specified, "buf" is unused and can be NULL. "ar" designates the access
-register number to be used; the valid range is 0..15.
+a read access, or where the data that should be written is stored for
+a write access.  The "reserved" field is meant for future extensions.
+Reserved and unused values are ignored. Future extension that add members must
+introduce new flags.
+
+The type of operation is specified in the "op" field. Flags modifying
+their behavior can be set in the "flags" field. Undefined flag bits must
+be set to 0.
+
+Possible operations are:
+  * ``KVM_S390_MEMOP_LOGICAL_READ``
+  * ``KVM_S390_MEMOP_LOGICAL_WRITE``
+  * ``KVM_S390_MEMOP_ABSOLUTE_READ``
+  * ``KVM_S390_MEMOP_ABSOLUTE_WRITE``
+  * ``KVM_S390_MEMOP_SIDA_READ``
+  * ``KVM_S390_MEMOP_SIDA_WRITE``
+
+Logical read/write:
+^^^^^^^^^^^^^^^^^^^
+
+Access logical memory, i.e. translate the given guest address to an absolute
+address given the state of the VCPU and use the absolute address as target of
+the access. "ar" designates the access register number to be used; the valid
+range is 0..15.
+Logical accesses are permitted for the VCPU ioctl only.
+Logical accesses are permitted for non-protected guests only.
+
+Supported flags:
+  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
+  * ``KVM_S390_MEMOP_F_INJECT_EXCEPTION``
+  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
+
+The KVM_S390_MEMOP_F_CHECK_ONLY flag can be set to check whether the
+corresponding memory access would cause an access exception; however,
+no actual access to the data in memory at the destination is performed.
+In this case, "buf" is unused and can be NULL.
+
+In case an access exception occurred during the access (or would occur
+in case of KVM_S390_MEMOP_F_CHECK_ONLY), the ioctl returns a positive
+error number indicating the type of exception. This exception is also
+raised directly at the corresponding VCPU if the flag
+KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
+
+If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
+protection is also in effect and may cause exceptions if accesses are
+prohibited given the access key passed in "key".
+KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
+is > 0.
+
+Absolute read/write:
+^^^^^^^^^^^^^^^^^^^^
+
+Access absolute memory. This operation is intended to be used with the
+KVM_S390_MEMOP_F_SKEY_PROTECTION flag, to allow accessing memory and performing
+the checks required for storage key protection as one operation (as opposed to
+user space getting the storage keys, performing the checks, and accessing
+memory thereafter, which could lead to a delay between check and access).
+Absolute accesses are permitted for the VM ioctl if KVM_CAP_S390_MEM_OP_EXTENSION
+is > 0.
+Currently absolute accesses are not permitted for VCPU ioctls.
+Absolute accesses are permitted for non-protected guests only.
+
+Supported flags:
+  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
+  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
+
+The semantics of the flags are as for logical accesses.
+
+SIDA read/write:
+^^^^^^^^^^^^^^^^
+
+Access the secure instruction data area which contains memory operands necessary
+for instruction emulation for protected guests.
+SIDA accesses are available if the KVM_CAP_S390_PROTECTED capability is available.
+SIDA accesses are permitted for the VCPU ioctl only.
+SIDA accesses are permitted for protected guests only.
 
-The "reserved" field is meant for future extensions. It is not used by
-KVM with the currently defined set of flags.
+No flags are supported.
 
 4.90 KVM_S390_GET_SKEYS
 -----------------------
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 08756eeea065..dbc550bbd9fa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -567,7 +567,7 @@ struct kvm_s390_mem_op {
 			__u8 key;	/* access key, ignored if flag unset */
 		};
 		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* should be set to 0 */
+		__u8 reserved[32]; /* ignored */
 	};
 };
 /* types for kvm_s390_mem_op->op */
-- 
2.32.0

