Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2AA704ECE
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjEPNIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbjEPNHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:07:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8E17DBB;
        Tue, 16 May 2023 06:07:14 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GCdAli014824;
        Tue, 16 May 2023 13:07:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KR/NnFuopYSJbgzv6ZKWBDiBwVbZ7qKo7KnxqoVABxo=;
 b=eXNF4cgDDxe1Xi6pkAKdHLFApAf3XtQ/UlLHxEPn3uuw8FMM73IVJO2Ii4yNJmpRbSri
 E0ZKBobg97C0WGkYlwbw0z/SF4rEsL7bcRhVPPQguLy387Nh6CrLKK04ioxw8M2hQOdB
 ZPt/MBi2EpsAjE75KU6DWAsSt/kqVw8EGXKZzmPVVb7Ixjk07wzFUBqS51jyvTqf1wQE
 pd4KF9X0kqmPzdZw5RJ3KVzLF5apkTePAUk/twHtX6JAlrrolYORIaPQtR7MWD1Iac6O
 vrFQ95DHl8j8VKetqX6GLNe7I3Nfrni5lvZrQkopeHI9YrEiJkAFw2MM7Jlpu5yLq8Rh WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm9s69d6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:07:12 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GCdOhA016452;
        Tue, 16 May 2023 13:06:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm9s69b7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:06:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G5sHM6025422;
        Tue, 16 May 2023 13:05:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdsn1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GD4vr621627586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 13:04:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 580ED20040;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 284F520043;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 4/6] s390x: fix compile of interrupt.c
Date:   Tue, 16 May 2023 15:04:54 +0200
Message-Id: <20230516130456.256205-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230516130456.256205-1-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ClhzT3AScs0N1zdJgUed4JkeSK919Q61
X-Proofpoint-ORIG-GUID: sSUpk_2UKQ2JBOyH6uv4kVPHcuNd12qP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_06,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=595 spamscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A future commit will include interrupt.h from sie.c.

Since interrupt.h includes mem.h, but sie.c does not include facility.h,
this will lead to the following compile error:

In file included from lib/s390x/interrupt.c:10:
/home/nrb/kvm-unit-tests/lib/asm/mem.h: In function ‘set_storage_key_mb’:
/home/nrb/kvm-unit-tests/lib/asm/mem.h:42:16: error: implicit declaration of function ‘test_facility’ [-Werror=implicit-function-declaration]
   42 |         assert(test_facility(8));
         |                ^~~~~~~~~~~~~

Add the missing include in interrupt.h

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/mem.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 64ef59b546a4..94d58c34f53f 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -8,6 +8,7 @@
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
 #include <asm/arch_def.h>
+#include <asm/facility.h>
 
 /* create pointer while avoiding compiler warnings */
 #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
-- 
2.39.1

