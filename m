Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA4F74F18E
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjGKORB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjGKOQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1605A10EF
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:42 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEEUef003838;
        Tue, 11 Jul 2023 14:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lx3S5vy2A/5C5MW1IbsI8GeY7KL04Xg75pewCNpEaSI=;
 b=L3EvJP3l9nGyAZQhAe6pfq1j2N1ttvE9F7kghTL93e+KHhM8+0eqsXZyQUqF5Yp02k4d
 unCd3zGZdHdcvg/84W9JsflrhgSciGALCJUazJdVmXEUujU9BjR3ZMyK5wMPnvf26jGU
 TAWVO3OG+mrAKnSvznGg0UYvoogmKxGFx2JFtF7fG0VM+sSWyOD6wClWCw2FHUyXYTdk
 cK+9YasFfF9thaTUwFZ/Ilj8GrZeLaJs+WvZD9q+hacJBCkr1z11Gx5qqswsvVDks544
 A9Yvico8qEw1kZwJz/0tKMF78AlUVa4IuyOgcy3udnS+FuqyNxonm9qZD+9xjnunfPUX iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:31 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEEpER005433;
        Tue, 11 Jul 2023 14:16:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:27 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEEfCD018517;
        Tue, 11 Jul 2023 14:16:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqmu0r145-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGMJE59048212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594F820043;
        Tue, 11 Jul 2023 14:16:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE95B20040;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [PATCH 20/22] s390x: sclp: Implement extended-length-SCCB facility
Date:   Tue, 11 Jul 2023 16:15:53 +0200
Message-ID: <20230711141607.40742-21-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UnvTxWj4bA7yW1YxrfOhbI_WbiLX6Gte
X-Proofpoint-GUID: xg1_uOba22QNcJXhZ9Jd2amTZ-t8-GCy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=891 adultscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

When the extended-length-SCCB facility is present use a big
buffer already at first try when calling sclp_read_scp_info()
to avoid the SCLP_RC_INSUFFICIENT_SCCB_LENGTH error.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/20230601164537.31769-3-pmorel@linux.ibm.com
[ nrb: remove one call to sclp_read_scp_info() ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sclp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 15662aa..56d5c90 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -17,13 +17,14 @@
 #include "sclp.h"
 #include <alloc_phys.h>
 #include <alloc_page.h>
+#include <asm/facility.h>
 
 extern unsigned long stacktop;
 
 static uint64_t storage_increment_size;
 static uint64_t max_ram_size;
 static uint64_t ram_size;
-char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 static ReadInfo *read_info;
 struct sclp_facilities sclp_facilities;
 
@@ -113,7 +114,8 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
 
 void sclp_read_info(void)
 {
-	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
+	sclp_read_scp_info((void *)_read_info,
+		test_facility(140) ? sizeof(_read_info) : SCCB_SIZE);
 	read_info = (ReadInfo *)_read_info;
 }
 
-- 
2.41.0

