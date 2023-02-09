Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD286904B5
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBIKZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjBIKZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572C166EEB;
        Thu,  9 Feb 2023 02:25:14 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AGHCX003776;
        Thu, 9 Feb 2023 10:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Wvl0YReYdKFHwYjA6vKwz/5URDvSjDnJSqZrEXdZPPw=;
 b=UYdM84jlyUyNHUpPqnPSn7s1Frl3IrOF5sNJNqVM7MupwFIND9ckcG2XJVsSn1O0HxxQ
 EYiOfKtWh5jZ7I3oUMlTBk0R0jKYa7L3SI6527Pz5cuvuxCDsDyQEfixluvZa3MRaFzM
 DVQMiyf3KK16cqRcdaALdW30kmuRLwyK1WtCcQ7gGjoqvB2qEALa9ODI0OcfPEITxMq7
 FZlKrRQKy+iU34OLk4Jg3hayqPclCA+335rYYPI71WbsFUJb4zHDbeuF5naWV4e12dMe
 Xq8vrwO31Ep7s95oYzxd7MLIz9edo1OW8QQ+jS2ebvmNHZdq/x3AHo539V8hoGUZqgG4 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxxbr60h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:13 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319AIDcM013036;
        Thu, 9 Feb 2023 10:25:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxxbr5yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318LOu13001926;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06p0vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP7WN36962738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 781562006C;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54A3D2006E;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 15/18] Documentation: KVM: s390: Describe KVM_S390_MEMOP_F_CMPXCHG
Date:   Thu,  9 Feb 2023 11:22:57 +0100
Message-Id: <20230209102300.12254-16-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5kNCS9FKj1m3adn7sK0CAM0r-Xw48Eik
X-Proofpoint-ORIG-GUID: c1PZ0KgHvLFll5S5rCp4-JdGNtqs_Q_f
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 mlxlogscore=672 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Describe the semantics of the new KVM_S390_MEMOP_F_CMPXCHG flag for
absolute vm write memops which allows user space to perform (storage key
checked) cmpxchg operations on guest memory.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-14-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-14-scgl@linux.ibm.com>
[frankja@de.ibm.com: Removed a line from an earlier version]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8cd7fd05d53b..a4c9dbccc7c2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3728,7 +3728,7 @@ The fields in each entry are defined as follows:
 :Parameters: struct kvm_s390_mem_op (in)
 :Returns: = 0 on success,
           < 0 on generic error (e.g. -EFAULT or -ENOMEM),
-          > 0 if an exception occurred while walking the page tables
+          16 bit program exception code if the access causes such an exception
 
 Read or write data from/to the VM's memory.
 The KVM_CAP_S390_MEM_OP_EXTENSION capability specifies what functionality is
@@ -3746,6 +3746,8 @@ Parameters are specified via the following structure::
 		struct {
 			__u8 ar;	/* the access register number */
 			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if flag unset */
 		};
 		__u32 sida_offset; /* offset into the sida */
 		__u8 reserved[32]; /* ignored */
@@ -3773,6 +3775,7 @@ Possible operations are:
   * ``KVM_S390_MEMOP_ABSOLUTE_WRITE``
   * ``KVM_S390_MEMOP_SIDA_READ``
   * ``KVM_S390_MEMOP_SIDA_WRITE``
+  * ``KVM_S390_MEMOP_ABSOLUTE_CMPXCHG``
 
 Logical read/write:
 ^^^^^^^^^^^^^^^^^^^
@@ -3821,7 +3824,7 @@ the checks required for storage key protection as one operation (as opposed to
 user space getting the storage keys, performing the checks, and accessing
 memory thereafter, which could lead to a delay between check and access).
 Absolute accesses are permitted for the VM ioctl if KVM_CAP_S390_MEM_OP_EXTENSION
-is > 0.
+has the KVM_S390_MEMOP_EXTENSION_CAP_BASE bit set.
 Currently absolute accesses are not permitted for VCPU ioctls.
 Absolute accesses are permitted for non-protected guests only.
 
@@ -3829,7 +3832,26 @@ Supported flags:
   * ``KVM_S390_MEMOP_F_CHECK_ONLY``
   * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
 
-The semantics of the flags are as for logical accesses.
+The semantics of the flags common with logical accesses are as for logical
+accesses.
+
+Absolute cmpxchg:
+^^^^^^^^^^^^^^^^^
+
+Perform cmpxchg on absolute guest memory. Intended for use with the
+KVM_S390_MEMOP_F_SKEY_PROTECTION flag.
+Instead of doing an unconditional write, the access occurs only if the target
+location contains the value pointed to by "old_addr".
+This is performed as an atomic cmpxchg with the length specified by the "size"
+parameter. "size" must be a power of two up to and including 16.
+If the exchange did not take place because the target value doesn't match the
+old value, the value "old_addr" points to is replaced by the target value.
+User space can tell if an exchange took place by checking if this replacement
+occurred. The cmpxchg op is permitted for the VM ioctl if
+KVM_CAP_S390_MEM_OP_EXTENSION has flag KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG set.
+
+Supported flags:
+  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
 
 SIDA read/write:
 ^^^^^^^^^^^^^^^^
-- 
2.39.1

