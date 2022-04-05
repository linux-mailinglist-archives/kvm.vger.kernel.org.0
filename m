Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BDF4F2744
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiDEIE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiDEH7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5E91AD92;
        Tue,  5 Apr 2022 00:55:51 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23573XZZ029366;
        Tue, 5 Apr 2022 07:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SWvSeb1NmFrHEaxc3tjVMsya0wC/OeShXMDwR5Z6k0I=;
 b=jS7J5KdDm2ZjjCwwZ+Fp/zM3m/tQN2nUuJgolFCUCFTmtuSThkYEyxbEtzYh4AMMr0os
 jO0+w3FJXRtyPPOFStBYcHkjaLhdRlxxZryZ4rKjZAd1+N9BNkgmCQsByW91R89spF6R
 k4r2/qMaiC4KL+0iCyTq0jphrkIUZWMO1SsjUGKFhOHGZb6II6v48vPQckNFJXIHOLiF
 5k5semjm8uaG6gd1T5AvfH5bMeahMlTQhqrOU/nZnZdk9NEhMfgHpoXdqXlZjtarcxVf
 sAXv9XG3oBdlKqagbrsSbxtKc8ItkZN1zaz96Wthm4LEp3iFk2XpIZWKvdSEyLE563BR PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjx6dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357toP7002339;
        Tue, 5 Apr 2022 07:55:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjx6dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357hFNn017698;
        Tue, 5 Apr 2022 07:55:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e48w786-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357tqB739059784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD6D242041;
        Tue,  5 Apr 2022 07:55:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F22984203F;
        Tue,  5 Apr 2022 07:55:43 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 8/8] s390x: mvpg: Cleanup includes
Date:   Tue,  5 Apr 2022 07:52:25 +0000
Message-Id: <20220405075225.15903-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405075225.15903-1-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PAJ86fAlgNbHByUygM4SzUiKA1HFxrea
X-Proofpoint-ORIG-GUID: _-4t-qBmIncj83DhaYyeyVyn-rlnU9_A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxlogscore=670 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Time to remove unneeded includes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 62f0fc5a..04e5218f 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -9,15 +9,12 @@
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
-#include <asm-generic/barrier.h>
 #include <asm/interrupt.h>
 #include <asm/pgtable.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
-#include <asm/sigp.h>
-#include <smp.h>
 #include <alloc_page.h>
 #include <bitops.h>
 #include <hardware.h>
-- 
2.32.0

