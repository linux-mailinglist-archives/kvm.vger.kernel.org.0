Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753EB524919
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352123AbiELJgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352051AbiELJfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D21A316
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9CLIA026334
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Q34mjb+B6KvNisQvKbGLZ41+ubKpv7kFDZukJ5Km2LA=;
 b=e1iPttiyOj79HahmZ6hQ2l3IopYx9W8tJjSEQDN+MemYVTNbBt2Pv7MlWbzUc++zWLNg
 8qQoP1/nfmSkRgZGuqmYUKlY5v8J7+Z1KyxET7pKdG3i6W5hBUwc8+3FQP55bHMi5Wfu
 GsmboIw03HBpT9fwmpyr+brha83FiyuxDAaY4/EBZaF6dxFpgHDSvvNcSxg/F8Wdu4Fk
 Z1a3Rs3ITFXN0cYrqf8cBb8gtMiXK/fTSTejxL7jpQ3gT2WtJtLhW/vYDYwEiLd2DT7u
 TR/rTzVgKERHz6no/u/7sLUpPC+D8/E3RuZjr3xu10tAuSSn1wIJkXu9UtviLL3RR/JP Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50e0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9E9Ll006966
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50dyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XZEj007509;
        Thu, 12 May 2022 09:35:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8n98m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZYlL21299540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C4911C052;
        Thu, 12 May 2022 09:35:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD66711C050;
        Thu, 12 May 2022 09:35:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:33 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 14/28] s390x: mvpg: Cleanup includes
Date:   Thu, 12 May 2022 11:35:09 +0200
Message-Id: <20220512093523.36132-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Lbz8ktEz1nObBG3EQ101JvIudMcrz6Ot
X-Proofpoint-ORIG-GUID: 9JpmQRhPV_KYsXMwGYosScLMMSDU5PcQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=664 mlxscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
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

Time to remove unneeded includes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.36.1

