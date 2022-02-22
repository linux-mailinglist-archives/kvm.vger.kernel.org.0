Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A5A4BF516
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiBVJty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiBVJts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD149C332D;
        Tue, 22 Feb 2022 01:49:22 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M8Bpib005704;
        Tue, 22 Feb 2022 09:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=f7rmKABkdnlZwat/LaSoHVu1F8k35gCJmfPFI6VRIbE=;
 b=XR9FJVqpDk5vl79YiNlrhBEdbjpTyvUSwJRrjpJiI3o7Ql3/CcV5nZgmw5SCjujxPGxF
 HWKv9Uj5EJs3joB4xiG2ArEOSBP53ZqvMp4kBye/nNSFQvmWUXXcHBQfgta4fOcxIZDC
 h19PbnZ85Q/BVbABlHJo7njdE6Be+Iq29dJ8KfJXHWFouE/hBdATHwP/BD7p5+L7hTIH
 Nnt98P/kSLdwO/IsqYqYFY1EQjg0Oz8MQnrbzaXdVJeHkeJrXxMn1cT8Kn9Bt3ClYvgt
 NJ7PD4n0O6qgAHjq5DWKyhqJjvkEVsEFcf673i7OS1EsqUhfGHAAZkGux3k91W6/WHwF /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecv3ua0cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:22 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9U6o3026869;
        Tue, 22 Feb 2022 09:49:21 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecv3ua0c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9bUjJ015326;
        Tue, 22 Feb 2022 09:49:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear691ggx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nGUY53740014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0CE842045;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC1244204B;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 8CA4BE04DC; Tue, 22 Feb 2022 10:49:15 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 13/13] KVM: s390: Add missing vm MEM_OP size check
Date:   Tue, 22 Feb 2022 10:49:10 +0100
Message-Id: <20220222094910.18331-14-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZlgrVaRU37m1K3C-1RzcJNemcIcxldN-
X-Proofpoint-GUID: pGr_Mo4oYxaDE6LtJwgyS3ad3adQL0nR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=895 malwarescore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Check that size is not zero, preventing the following warning:

WARNING: CPU: 0 PID: 9692 at mm/vmalloc.c:3059 __vmalloc_node_range+0x528/0x648
Modules linked in:
CPU: 0 PID: 9692 Comm: memop Not tainted 5.17.0-rc3-e4+ #80
Hardware name: IBM 8561 T01 701 (LPAR)
Krnl PSW : 0704c00180000000 0000000082dc584c (__vmalloc_node_range+0x52c/0x648)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000083 ffffffffffffffff 0000000000000000 0000000000000001
           0000038000000000 000003ff80000000 0000000000000cc0 000000008ebb8000
           0000000087a8a700 000000004040aeb1 000003ffd9f7dec8 000000008ebb8000
           000000009d9b8000 000000000102a1b4 00000380035afb68 00000380035afaa8
Krnl Code: 0000000082dc583e: d028a7f4ff80        trtr    2036(41,%r10),3968(%r15)
           0000000082dc5844: af000000            mc      0,0
          #0000000082dc5848: af000000            mc      0,0
          >0000000082dc584c: a7d90000            lghi    %r13,0
           0000000082dc5850: b904002d            lgr     %r2,%r13
           0000000082dc5854: eb6ff1080004        lmg     %r6,%r15,264(%r15)
           0000000082dc585a: 07fe                bcr     15,%r14
           0000000082dc585c: 47000700            bc      0,1792
Call Trace:
 [<0000000082dc584c>] __vmalloc_node_range+0x52c/0x648
 [<0000000082dc5b62>] vmalloc+0x5a/0x68
 [<000003ff8067f4ca>] kvm_arch_vm_ioctl+0x2da/0x2a30 [kvm]
 [<000003ff806705bc>] kvm_vm_ioctl+0x4ec/0x978 [kvm]
 [<0000000082e562fe>] __s390x_sys_ioctl+0xbe/0x100
 [<000000008360a9bc>] __do_syscall+0x1d4/0x200
 [<0000000083618bd2>] system_call+0x82/0xb0
Last Breaking-Event-Address:
 [<0000000082dc5348>] __vmalloc_node_range+0x28/0x648

Other than the warning, there is no ill effect from the missing check,
the condition is detected by subsequent code and causes a return
with ENOMEM.

Fixes: ef11c9463ae0 (KVM: s390: Add vm IOCTL for key checked guest absolute memory access)
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220221163237.4122868-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c2c26c2aad64..e056ad86ccd2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2374,7 +2374,7 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 
 	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
 			  | KVM_S390_MEMOP_F_CHECK_ONLY;
-	if (mop->flags & ~supported_flags)
+	if (mop->flags & ~supported_flags || !mop->size)
 		return -EINVAL;
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
-- 
2.35.1

