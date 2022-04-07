Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584BA4F7A1B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbiDGIqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243259AbiDGIqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DE918424C;
        Thu,  7 Apr 2022 01:44:42 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376hbdN015847;
        Thu, 7 Apr 2022 08:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pU1351TxxgaKcsdGEtePqvQruDptxNcj9mnpNTf7+Rg=;
 b=hQEO7HgP5B02Fb7UwbwPy5xLLqSrJuFSuO1BDiiQFV+EyQyJzm3I3NiQnWEpxMYIRdSD
 9eAMbmha4wkLEdoIewKJkc/F5dBUYlnGjRH4C8rnQac5VrT2TyduTTbf2LzGTTbenMHi
 wXn1MVYkzHllaFySOcqgOLQhB1LU/6Uob3RYaR528slypeAAeLw0xT6y7vbRRFCyXJvC
 V1VJYj1FcW50NiCBNfGjFzx26o/gY0IqToPsmbP4HSMKHHElnz6YuZOENW2aemLoBYWe
 D9fapqz+UFc3dnNyHsmGDq/xB9ilIlOZxA+LjsN4qicvy2JLQisx/I4aPXc59F8g8KQj Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f96b2kd84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:42 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378htIY027885;
        Thu, 7 Apr 2022 08:44:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f96b2kd7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378XLtN016680;
        Thu, 7 Apr 2022 08:44:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e491e3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378WJOu32702772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:32:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEF2AAE053;
        Thu,  7 Apr 2022 08:44:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3F76AE045;
        Thu,  7 Apr 2022 08:44:35 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 8/9] s390x: iep: Cleanup includes
Date:   Thu,  7 Apr 2022 08:44:20 +0000
Message-Id: <20220407084421.2811-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: izw3sKayYalU9TEKWlDQIzEExYBUoawr
X-Proofpoint-ORIG-GUID: sRxKkosgcxov37dIoyQuTuM-B2X3vNgm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxlogscore=851 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't use barriers so let's remove the include.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/iep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/s390x/iep.c b/s390x/iep.c
index 8d5e044b..4b3e09a7 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -9,11 +9,10 @@
  */
 #include <libcflat.h>
 #include <vmalloc.h>
+#include <mmu.h>
 #include <asm/facility.h>
 #include <asm/interrupt.h>
-#include <mmu.h>
 #include <asm/pgtable.h>
-#include <asm-generic/barrier.h>
 
 static void test_iep(void)
 {
-- 
2.32.0

