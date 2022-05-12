Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE45F524916
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352178AbiELJgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352047AbiELJfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6A22BD
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:39 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C98ZpQ001344
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V8NzF3GK4W3SmfiVsizIYHdUGMa3FwTwQTDEz3/a/aY=;
 b=PPQO5v0zTKLxqG8hdNL0Ze54BhK4UjDAIYOWbtDB2ugW87sYYOTDOZGBUjqOlrTJSJ+7
 xlCePAUNAOFxWslgL1gbQxWEYHNbU01CKitC8aqnZFHAITWPN4+8kDJTP9QbNgHE08IG
 z1dETe9zA0LE+px75XOPS0O/bo2AOdkFc4hBF5IAlTC4GWQWAu0Sz3hpqRHL0t+Rw4Oy
 JNsAzgK1H+S9UX7e09oWbmBFQAhVK9E2d5yIUitrFruYEJmyz5LAqUFIOCxdvV+HvVum
 SzCbFg/uaICCjeHK32GvtUowsaCKpu4rNEPsKVxCMXlzG4IiKihhn94f7NFLXyv2SMGu ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y7n0juk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:38 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9ZbiO009723
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y7n0jtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9Wisc001647;
        Thu, 12 May 2022 09:35:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8w8x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZXSa48562600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B0A811C05B;
        Thu, 12 May 2022 09:35:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F73E11C04C;
        Thu, 12 May 2022 09:35:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:33 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 13/28] s390x: iep: Cleanup includes
Date:   Thu, 12 May 2022 11:35:08 +0200
Message-Id: <20220512093523.36132-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uaSBDb5kD0q6j9xyn_CPnke77oKAk-a3
X-Proofpoint-GUID: 6BONleMFzap5_pqMRXairQCexyEVJoYa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
 mlxlogscore=753 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We don't use barriers so let's remove the include.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.36.1

