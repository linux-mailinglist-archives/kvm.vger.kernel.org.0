Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82714EC6EC
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347148AbiC3OqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 10:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbiC3Opq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 10:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DFE689AA;
        Wed, 30 Mar 2022 07:43:55 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UDEKMF031025;
        Wed, 30 Mar 2022 14:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pWkFbHhsyw85rtG9dxCk+nuMcKBHlc9TDRduvFh+Hvc=;
 b=F8ZmmZFIBz5Mvb4jTPPI7ud2EV18LXxQdkqOk7x0duKOQCGKZyCWesgwfxBxD0c3R2ra
 UzbU+6hMckHD+9LoBKqq7bzCYTa1Hpw+fxRcCdpb+Np7edECQF5pVjMm3EfwPOiH2q0g
 gaGiP5BEYkkgB7NjL6ovQA5RvlIY/iNTmcdzGZgMkWpHXm9YWEDDzv0U3iwG/og5n5lQ
 cBauOkfirr4MDsp4Z3xJ0hrxTogcjju0OvcXCsRWLaqSzEAYZ6JVLvh8KKAm6Nj+ajkz
 mS1FM/LxrC7mDm1VrErqcQ32Jc5X2vSbhdBhIPakxEBoVQebHmB1HzM9hWh7IXu6NSCw Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4qwtj2ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UDSDiL031147;
        Wed, 30 Mar 2022 14:43:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4qwtj2te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:53 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UEdGI3012644;
        Wed, 30 Mar 2022 14:43:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3f1tf8ygbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UEhmX038928718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 14:43:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C03EA4C046;
        Wed, 30 Mar 2022 14:43:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33DBD4C040;
        Wed, 30 Mar 2022 14:43:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 14:43:48 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] s390x: remove spurious includes
Date:   Wed, 30 Mar 2022 16:43:36 +0200
Message-Id: <20220330144339.261419-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330144339.261419-1-imbrenda@linux.ibm.com>
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GPtwGM-T93lbqOggt494jGRVdKKGP4Zd
X-Proofpoint-ORIG-GUID: TkvlWLrnaEWsxc1EKRRXxW8uKzKURHxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=807 clxscore=1015 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused includes of vm.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/mvpg-sie.c    | 1 -
 s390x/pv-diags.c    | 1 -
 s390x/spec_ex-sie.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 8ae9a52a..46a2edb6 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -16,7 +16,6 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sclp.h>
 #include <sie.h>
 #include <snippet.h>
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 110547ad..6899b859 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -19,7 +19,6 @@
 #include <asm/sigp.h>
 #include <smp.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <vmalloc.h>
 #include <sclp.h>
 #include <snippet.h>
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5dea4115..d8e25e75 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -11,7 +11,6 @@
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sie.h>
 #include <snippet.h>
 
-- 
2.34.1

