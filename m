Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289C6524918
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352115AbiELJgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352041AbiELJfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D8869CD9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:38 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C8t4SX011337
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TyqXc33YrXcA4m6DBtjWhIbzUE9MR+2F9y09WNSx87k=;
 b=R+6KBOY9mM+x5OnBIUVdujp5E2kgsOI/tREFO4qYWIiDzGWO/7bD2TFcLbAOka/iQI8M
 10f/GoX0qc1toZrWqmMB8D5Ji++Ln9CPTVV9YITJeZarSfzpHf4P7fGKdAo0/HD/2iBl
 qzG9jjDMNAhtI+74flBWelIjfUtKgPQTfxAmvrh32WIm1F7J5MXrqv3Pn2TKbd27WM5p
 1PUCCKvPw8jJGbT3LqHAP7tgWhGIrXgJYi2MQnLiUwd7/T1lUNP7hYyixbV71YuZpXCO
 04nkMgrZHMgwBh9aQ5eFKv4QfPdrVpdfOAO7cWvUOT1G8ndaPaO1XQtk7ig3qCpbI1lA ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y538wy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C8uZkD022723
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y538wx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XHuv027307;
        Thu, 12 May 2022 09:35:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3g0kn78ne2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZWch33816958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D42F411C04A;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895FF11C050;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 11/28] s390x: pv-diags: Cleanup includes
Date:   Thu, 12 May 2022 11:35:06 +0200
Message-Id: <20220512093523.36132-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qP-wij4jMyJclkL50hNM2wFGfaFz4B3n
X-Proofpoint-ORIG-GUID: qwdu38nkIUgpzTTevxAQTadN2U4t08nz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=862 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

This file has way too much includes. Time to remove some.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/pv-diags.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 6899b859..9ced68c7 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -8,23 +8,10 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
-#include <asm/asm-offsets.h>
-#include <asm-generic/barrier.h>
-#include <asm/interrupt.h>
-#include <asm/pgtable.h>
-#include <mmu.h>
-#include <asm/page.h>
-#include <asm/facility.h>
-#include <asm/mem.h>
-#include <asm/sigp.h>
-#include <smp.h>
-#include <alloc_page.h>
-#include <vmalloc.h>
-#include <sclp.h>
 #include <snippet.h>
 #include <sie.h>
-#include <uv.h>
-#include <asm/uv.h>
+#include <sclp.h>
+#include <asm/facility.h>
 
 static struct vm vm;
 
-- 
2.36.1

