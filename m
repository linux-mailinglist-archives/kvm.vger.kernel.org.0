Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE77559CBF
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiFXOvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiFXOvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:51:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27958288E;
        Fri, 24 Jun 2022 07:45:40 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25ODfuG9019006;
        Fri, 24 Jun 2022 14:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h2GFRrWyDWBo9H3SNTqtSH3QnmCKmfFi85GTbx4kCF8=;
 b=MsweI4JTB4J46EWDJzYfO5VGMjlpONbGgcF31ct3vRl/CNoT+jhgJ4Ouswiguc7FYyAx
 0m78bOGKexejHUNokCpUH1Rlq59RUfqqZ1x1XaggRQ8i1vsj3Z0A7orJ1vOYFrGiIE62
 sBK3ohA2yPhiAgSrTmXkv94Z3L0CplA1bZKI7+jQBO3G7BF3h/4rtbUfMxHEI2tcu9qd
 Y85C9wjnadzCCPVluR7i8y3kyPowaz8U8B1XM1qAIh5hx13n3oZXeZ0FbAlXzzc3vAEm
 zhAZCnvx3k/pX0JAgEdqi1N2aRbIaZR3h/WZDg1WF6hgLHRHI99JPZ6bfFHu4v0K9+Dz Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gweck1xwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:25 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25ODgEJl019388;
        Fri, 24 Jun 2022 14:45:25 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gweck1xvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OEKTR4029757;
        Fri, 24 Jun 2022 14:45:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3gvuj7shmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OEiT8W16122334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 14:44:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FF1EA4053;
        Fri, 24 Jun 2022 14:45:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAEE3A4055;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: skey.c: rework the interrupt handler
Date:   Fri, 24 Jun 2022 16:45:17 +0200
Message-Id: <20220624144518.66573-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624144518.66573-1-imbrenda@linux.ibm.com>
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W8tMBRpvmWVJKrVxw7og69EyOr_1YbRv
X-Proofpoint-GUID: 39t9HZyAGM7JztakC21WiJI_LcaJCFMc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=736 clxscore=1015 lowpriorityscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206240056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The skey test currently uses a cleanup function to work around the
issues that arise when the lowcore is not mapped, since the interrupt
handler needs to access it.

Instead of a cleanup function, simply disable DAT for the interrupt
handler for the tests that remap page 0. This is needed in preparation
of and upcoming patch that will cause the interrupt handler to read
from lowcore before calling the cleanup function.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skey.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 445476a0..24123763 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -15,7 +15,6 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 
-
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_set_mb(void)
@@ -250,19 +249,6 @@ static void set_prefix_key_1(uint32_t *prefix_ptr)
 	);
 }
 
-/*
- * We remapped page 0, making the lowcore inaccessible, which breaks the normal
- * handler and breaks skipping the faulting instruction.
- * Just disable dynamic address translation to make things work.
- */
-static void dat_fixup_pgm_int(void)
-{
-	uint64_t psw_mask = extract_psw_mask();
-
-	psw_mask &= ~PSW_MASK_DAT;
-	load_psw_mask(psw_mask);
-}
-
 #define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
 static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
 
@@ -318,7 +304,13 @@ static void test_set_prefix(void)
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-	register_pgm_cleanup_func(dat_fixup_pgm_int);
+	/*
+	 * Page 0 will be remapped, making the lowcore inaccessible, which
+	 * breaks the normal handler and breaks skipping the faulting
+	 * instruction. Disable dynamic address translation for the
+	 * interrupt handler to make things work.
+	 */
+	lowcore.pgm_new_psw.mask &= ~PSW_MASK_DAT;
 
 	report_prefix_push("remapped page, fetch protection");
 	set_prefix(old_prefix);
@@ -356,7 +348,7 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 
 	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
-	register_pgm_cleanup_func(NULL);
+	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
 	report_prefix_pop();
 	set_storage_key(pagebuf, 0x00, 0);
 	report_prefix_pop();
-- 
2.36.1

