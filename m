Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1231E791354
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352564AbjIDIXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjIDIXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:23:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A911A5;
        Mon,  4 Sep 2023 01:23:25 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38486tLl003946;
        Mon, 4 Sep 2023 08:23:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lr1aJMwtYhv0OXZc066uW45PypTmq3DPT04Ccw5LmZc=;
 b=fyTvxn7I0RbYIILwcyXlx6Y0kVBaJIIzp/s8HRnlKEaHOi1da1kc9Ov0XKfqeBf45+vc
 ouDRuJOzWTUOTIY2BBPK7LGFBYusvyp0XcIqCBhQ7zzHU0hJlZhMOb8G1MUdBqx2B+y1
 wvMnA3X2nUl1djpa/fFsdPAnrEDyt8DkOOQsI0YdU9log+rTffctteZ1Skg45KSUzDAY
 ttwgp3LgkkaZCoKADZdehYnyBHFj1BTW8xTLkDTnP9yqj5j4/2gITyoxMeTNJkVVE4KB
 lValt+iPhKopFGVsqaZ9XxF6jubwENFvcalYmQ+2Im1+qUopJRlZQ4wDE6PceZafqg0s yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7bpdguj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:25 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38486vok004388;
        Mon, 4 Sep 2023 08:23:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7bpdgu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:24 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3847mvas026809;
        Mon, 4 Sep 2023 08:23:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svgcn10jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3848NKAS11535040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 08:23:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C1520043;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D82D2004E;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 5/8] s390x: lib: sie: don't reenter SIE on pgm int
Date:   Mon,  4 Sep 2023 10:22:23 +0200
Message-ID: <20230904082318.1465055-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904082318.1465055-1-nrb@linux.ibm.com>
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RDniRVobjgK4fUqlc2QJM0FL3bM1uzBb
X-Proofpoint-ORIG-GUID: 1D0XYmW4iIlxfeyia9sHOidS9n8oEjJS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_05,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=69 clxscore=1015
 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=69 mlxscore=69
 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=-33 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, when a PGM int occurs while in SIE, we will just reenter
SIE after the interrupt handler was called.

This is because sie() has a loop which checks icptcode and re-enters SIE
if it is zero.

However, this behaviour is quite undesirable for SIE tests, since it
doesn't give the host the chance to assert on the PGM int. Instead, we
will just re-enter SIE, on nullifing conditions even causing the
exception again.

In sie(), check whether a pgm int code is set in lowcore. If it has,
exit the loop so the test can react to the interrupt. Add a new function
read_pgm_int_code() to obtain the interrupt code.

Note that this introduces a slight oddity with sie and pgm int in
certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
we will now never enter SIE until the pgm_int_code is cleared by e.g.
clear_pgm_int().

Also add missing include of facility.h to mem.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/interrupt.h | 14 ++++++++++++++
 lib/s390x/asm/mem.h       |  1 +
 lib/s390x/sie.c           |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d01f8a89641a..7f73d473b346 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -97,4 +97,18 @@ static inline void low_prot_disable(void)
 	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
 }
 
+/**
+ * read_pgm_int_code - Get the program interruption code of the last pgm int
+ * on the current CPU.
+ *
+ * This is similar to clear_pgm_int(), except that it doesn't clear the
+ * interruption information from lowcore.
+ *
+ * Returns 0 when none occurred.
+ */
+static inline uint16_t read_pgm_int_code(void)
+{
+	return lowcore.pgm_int_code;
+}
+
 #endif
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
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 7f4474555ff7..a97096948460 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
+#include <asm/interrupt.h>
 #include <libcflat.h>
 #include <alloc_page.h>
 
@@ -79,7 +80,8 @@ void sie(struct vm *vm)
 	/* also handle all interruptions in home space while in SIE */
 	irq_set_dat_mode(true, AS_HOME);
 
-	while (vm->sblk->icptcode == 0) {
+	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
+	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
 	}
-- 
2.41.0

