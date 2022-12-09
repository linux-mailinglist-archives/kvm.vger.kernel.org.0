Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1927D6482E8
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLINsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLINsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:48:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565BD663F2
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:48:19 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9B7EHJ023380;
        Fri, 9 Dec 2022 13:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3ME6uKr+u4ee5nC5VbglimhUWecWIQHKwL1CMGIVBtY=;
 b=noYgGQpgK+/DqqL0KsqjDhzi6be8xrO2oi3fewj3NUqoyCrWtaoNgzDrHW6Mds5Xtyix
 MB8ENuG3ukw0u6feucDJXbcBelH23rQ1KXC3rH0t8C6fqbZIrYYNmSkYlFiHqxLbrwTR
 ftqz4e0F8AE/zxprYWWq3Lfom9YT8Nn5U9YzPYfUa/RIqFy5ci4UoIFy5WNgfNo5QFB6
 ScWoe8HK6v9OjlHk4hzKkk4bxF54N+PjWsLeVGqjxpP1lYBDYUSu4nDh7nuz/5IFfvHM
 hq6fZIeHOU6x1S5kPjxWDbNxJs20ZUWlbet7LVnEb+j5+xuQn0Y0MqYyyHQAanR2/eTP YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxfdk110-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9DHDsP013579;
        Fri, 9 Dec 2022 13:48:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxfdk109-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B98spGa012179;
        Fri, 9 Dec 2022 13:48:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3m9pv9v97f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 13:48:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9DmA2239322020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 13:48:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 973C620040;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5330E20043;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 13:48:10 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] powerpc: use migrate_once() in migration tests
Date:   Fri,  9 Dec 2022 14:48:07 +0100
Message-Id: <20221209134809.34532-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221209134809.34532-1-nrb@linux.ibm.com>
References: <20221209134809.34532-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 26jeH7qUCY8Dp81DSPSZz3rXfs00MatP
X-Proofpoint-ORIG-GUID: VS1c-OWdoeE6FeRx79iQbzwxd2sL0FnR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_07,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 suspectscore=0
 mlxlogscore=846 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090108
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

