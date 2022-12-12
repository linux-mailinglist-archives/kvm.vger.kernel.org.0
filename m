Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E76649D6C
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiLLLTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiLLLSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:18:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAA4D70
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:17:42 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC9wFq9026544;
        Mon, 12 Dec 2022 11:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3ME6uKr+u4ee5nC5VbglimhUWecWIQHKwL1CMGIVBtY=;
 b=VeggvFNyDIlOkb5DesLoTPR8WhE6nG+VZDo76RiSyc/0uxABj2Ti+P/paT5eV8veKDZL
 LwjyJwrgcSj1/UxxUJRvVn7vAmRnnBSmtznxSdjqp5RsHWbdDGwnKGJWvu4vvkHpjmRt
 VFIno9aaxcozPvPaftnVltr5BGaw8gjXP4Dd00UOCLSwgNTQBZsryLaPiWmIGxoPG4bq
 5nla8EBns+4nDz7WBltArpX8ffLmpDGenvRQEjbdCE9qmbsswu9P3VhjfcRZrzN57EL2
 +7OEd9dclWIwjURjyDQYc9H/BA34yUubQI1qhSB7BEwIgdV2w97zS8j7qyHO2ee/kaUY cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md40kp887-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCA3nDj024978;
        Mon, 12 Dec 2022 11:17:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md40kp877-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2BCAfLEr015510;
        Mon, 12 Dec 2022 11:17:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3mchr61tuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCBHXci52167120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 11:17:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEC5920049;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 740072004B;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/4] powerpc: use migrate_once() in migration tests
Date:   Mon, 12 Dec 2022 12:17:29 +0100
Message-Id: <20221212111731.292942-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111731.292942-1-nrb@linux.ibm.com>
References: <20221212111731.292942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tn7ToAIbCGkNAif7qY8VzQw1JZUH03DL
X-Proofpoint-ORIG-GUID: q7SBE3Qj11LNatB31DJ_G57YP11QYtr2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxlogscore=845 impostorscore=0 suspectscore=0 spamscore=0
 mlxscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 powerpc/Makefile.common | 1 +
 powerpc/sprs.c          | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 12c280c15fff..8ce00340b6be 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -36,6 +36,7 @@ cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/migrate.o
 cflatobjs += lib/powerpc/io.o
 cflatobjs += lib/powerpc/hcall.o
 cflatobjs += lib/powerpc/setup.o
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index d3c8780e8376..5cc1cd16cfda 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -21,6 +21,7 @@
  */
 #include <libcflat.h>
 #include <util.h>
+#include <migrate.h>
 #include <alloc.h>
 #include <asm/handlers.h>
 #include <asm/hcall.h>
@@ -285,8 +286,7 @@ int main(int argc, char **argv)
 	get_sprs(before);
 
 	if (pause) {
-		puts("Now migrate the VM, then press a key to continue...\n");
-		(void) getchar();
+		migrate_once();
 	} else {
 		puts("Sleeping...\n");
 		handle_exception(0x900, &dec_except_handler, &decr);
-- 
2.36.1

