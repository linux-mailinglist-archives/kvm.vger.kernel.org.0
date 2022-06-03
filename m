Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8C53CC6E
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245598AbiFCPks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbiFCPkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:40:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82604ECE4;
        Fri,  3 Jun 2022 08:40:44 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253Ed1Cx023366;
        Fri, 3 Jun 2022 15:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QzAt6t7Fh/IbXaBdELcKYq188hmN8ezgaD9Yb+vsWIw=;
 b=bDbkp4yx4XsQYMg5HH4CmvJ86bR23sKJfRDPREvFCiSO74xACA+6LhOg4QkAiQjyaKsB
 t0xGGgyfn4oLHH9Kn8Kz2PgDx96bRjBywIYJfMkYqLfKE6g7OH2HmeEGAhgfT7LA9H6s
 MSFuwR6PsnWGSvSUvyV+tA/66cHRuYuboRR05uVeNBZTXq8mNmAhte2vRIhDwO8mden3
 1ueHX/FhnixcR42CuPwhf0wske99olTxdjmOq1w8gJRc9npFpFjv8jEbtgrY5QicOdnr
 slBcgCOi9GsgachqgAdHImJ4cM65d+/YAuajQ+ddi+fnBl8X+MhLZUsbhTIslU4mrJW9 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgu755ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:44 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253Fdcjb008609;
        Fri, 3 Jun 2022 15:40:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgu7559r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253Fa7M4028920;
        Fri, 3 Jun 2022 15:40:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae8kur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253Fec4u21496256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:40:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822E3A4051;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F62FA4055;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, pmorel@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] s390x: skey.c: rework the interrupt handler
Date:   Fri,  3 Jun 2022 17:40:36 +0200
Message-Id: <20220603154037.103733-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603154037.103733-1-imbrenda@linux.ibm.com>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EW-3u6FPwoCokoJW7ldru07klGA3JZgE
X-Proofpoint-GUID: x7VlcIxqXL8g6qivCsdTnVN7TLFShMVs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=893 suspectscore=0 spamscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030068
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
 s390x/skey.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 32bf1070..d01c6f79 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -15,6 +15,7 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 
+static struct lowcore *lc;
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -250,19 +251,6 @@ static void set_prefix_key_1(uint32_t *prefix_ptr)
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
 
@@ -318,7 +306,13 @@ static void test_set_prefix(void)
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-	register_pgm_cleanup_func(dat_fixup_pgm_int);
+	/*
+	 * Page 0 will be remapped, making the lowcore inaccessible, which
+	 * breaks the normal handler and breaks skipping the faulting
+	 * instruction. Disable dynamic address translation for the
+	 * interrupt handler to make things work.
+	 */
+	lc->pgm_new_psw.mask &= ~PSW_MASK_DAT;
 
 	report_prefix_push("remapped page, fetch protection");
 	set_prefix(old_prefix);
@@ -356,7 +350,7 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 
 	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
-	register_pgm_cleanup_func(NULL);
+	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
 	report_prefix_pop();
 	set_storage_key(pagebuf, 0x00, 0);
 	report_prefix_pop();
-- 
2.36.1

