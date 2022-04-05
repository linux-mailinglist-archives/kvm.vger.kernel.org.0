Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C5D4F26D2
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiDEIFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiDEH7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550EC41327;
        Tue,  5 Apr 2022 00:55:49 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2357FaFR005368;
        Tue, 5 Apr 2022 07:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OIxfJjmzKU/K3KX8Fblm5I+BDykJUsanlJgbfOTDr0E=;
 b=jRaDOiGxGNBoKul+X5+iXq3QNQZKvkvWZIyQElKE5H36PXYXkYLd1s7N74Xgk3+py3ig
 ofQ93sZEQ72C7sWpW+x/7hMkITxqsWMCKI0VnppWqBf2MHw+hhcCYWb4bkMSY0tPkKJF
 HBYO1UNrQ+Z7zIA+t2Ryhjtrp/Bd9XaXPic8QqaY0aMaQNDv3GayKCXTIgqJlzTrNYJF
 sSSo9GoWUomprXV8GK4LLh8fuVXRb4yFsNyk0YvVm1wQLy4mlcWXPxXH4RrhOCJAnT5X
 TL5tBjzoljzVUUOHLvt/m8nDGvQs6w9YScI4RJDjbSRX9xYz4banH5CQkQ5b1h5FOdHG HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7xfep6r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357RbZE011498;
        Tue, 5 Apr 2022 07:55:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7xfep6qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357hacn018132;
        Tue, 5 Apr 2022 07:55:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e48w784-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357tgD145613426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA45442045;
        Tue,  5 Apr 2022 07:55:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AF204203F;
        Tue,  5 Apr 2022 07:55:42 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 6/8] s390x: css: Cleanup includes
Date:   Tue,  5 Apr 2022 07:52:23 +0000
Message-Id: <20220405075225.15903-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405075225.15903-1-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jjfVU_sM5BifTQeucKYw3iOQU-gEGuDx
X-Proofpoint-GUID: sI7zC5R2ItUbMxqTl1J0AJQaz-733tKB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxlogscore=803 clxscore=1015 malwarescore=0
 bulkscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most includes were related to allocation but that's done in the io
allocation library so having them in the test doesn't make sense.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/css.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index 52d35f49..9cfcfad4 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -9,17 +9,14 @@
  */
 
 #include <libcflat.h>
-#include <alloc_phys.h>
-#include <asm/page.h>
-#include <string.h>
 #include <interrupt.h>
-#include <asm/arch_def.h>
-#include <alloc_page.h>
 #include <hardware.h>
 
+#include <asm/arch_def.h>
+#include <asm/page.h>
+
 #include <malloc_io.h>
 #include <css.h>
-#include <asm/barrier.h>
 
 #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
 static unsigned long cu_type = DEFAULT_CU_TYPE;
-- 
2.32.0

