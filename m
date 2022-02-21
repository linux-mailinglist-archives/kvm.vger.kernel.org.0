Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6BC4BE8CA
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357424AbiBUQdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:33:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiBUQdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:33:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFDC1DA71;
        Mon, 21 Feb 2022 08:32:46 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEgWhB031083;
        Mon, 21 Feb 2022 16:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=u+VB6Mub6TwBOoLS8CCFDBRNUbyBeLZbwCtNn1pU+Mg=;
 b=bjFvhOp2cgjeCXEg/PWWx8Tvh0m2lr9nqfMmT7m1yJ4Gmb1q5c2WgXb5S+KuH7vSW6K4
 zKKUkggCXP+7VqWlIj/ijvkKKW+ttkvgLeCMMVh1H22mjMAkKKIoAt+F52V+2g+WlJyY
 z+1lvEf3BfV9TgmwTm7IDjRzrl8GcKY2yb59LuDhM3I8Z5xyVsDx7DDdW7BJ+S85SqX2
 hOY1a4S6iO9S3/8zHyxHAjDFLUBTg1tInO2Lkd5Ki/aFT9SSEiUhXtEWbuAIxqRHt++1
 gRFTU1l1oTtEow8c9oocFbFeJzaevZNyXBVNlUsKg+jiuQzPV3tAUnuvM/dAUWZMOyoC 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eccr3amu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:32:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LGTQIx005184;
        Mon, 21 Feb 2022 16:32:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eccr3amtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:32:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LGQx38028029;
        Mon, 21 Feb 2022 16:32:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqthv783-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:32:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LGWdKh39977296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 16:32:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41A774C050;
        Mon, 21 Feb 2022 16:32:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D98A94C04E;
        Mon, 21 Feb 2022 16:32:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 16:32:38 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Add missing vm MEM_OP size check
Date:   Mon, 21 Feb 2022 17:32:37 +0100
Message-Id: <20220221163237.4122868-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-7-scgl@linux.ibm.com>
References: <20220211182215.2730017-7-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TiEEXWyel54FLwn5jpBY3HdCKHuzNZEb
X-Proofpoint-ORIG-GUID: zZMMGJt2KBcWEFpwsjdEU5TX6vVs_fa3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_08,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=882 impostorscore=0
 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.32.0

