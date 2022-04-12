Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE264FDC99
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiDLKc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381002AbiDLK0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:26:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B8654BD4;
        Tue, 12 Apr 2022 02:29:48 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C9KK1f040695;
        Tue, 12 Apr 2022 09:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RRiF1S4VKa7y5QRTcptJv2iHvDjaZP8HC0i/ubRQYnM=;
 b=LB8YdZruXZO4KEO8puGGbgBOtrl0tCZfgY2F4jcS2R6ByYh8jL/ClAWZUM/HmTyQ/J/6
 20K0B/km+bbLoenurP5duhvFtTP2dtpEp0KdelRV1maYnuJqqGXI1fD1q2mcsRD2tWkW
 nj2CY3G3R88/ta8dRhAx/dyKtrEI/mCT3fkpYP6EeSwyW3U4ClDJ+Hxqy+1wLzMoEbaY
 MzKfu6HcY/I5NRiDrOmYcVKyOGnDuZQw88H1zB+vzXHlfmAG+OA7O1fG2AzQUHiF4TMB
 PpP4o/vOIPitMPS6llF+vyJuVsHHpUpiQy9kLNbkG0XsDTwkHJQR1Rm0H9vLP0GZLUaQ pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd6q2r4px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:47 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23C9RG5x021063;
        Tue, 12 Apr 2022 09:29:47 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd6q2r4ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:47 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23C9BpJc012542;
        Tue, 12 Apr 2022 09:29:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8kp0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:29:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23C9Tgek38928868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 09:29:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55B52AE045;
        Tue, 12 Apr 2022 09:29:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12D75AE051;
        Tue, 12 Apr 2022 09:29:42 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 09:29:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/3] s390x: tprot: use system include for mmu.h
Date:   Tue, 12 Apr 2022 11:29:41 +0200
Message-Id: <20220412092941.20742-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220412092941.20742-1-nrb@linux.ibm.com>
References: <20220412092941.20742-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vl7K9n0ybesrEpdIseGZiuNlSvPFwyI1
X-Proofpoint-GUID: CZyolrFGM-GQG4Pl1PKGU7dwMPAiv8Xi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-12_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=741
 impostorscore=0 mlxscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu.h should come from the system includes

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/tprot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/tprot.c b/s390x/tprot.c
index 460a0db7ffcf..760e7ecdf914 100644
--- a/s390x/tprot.c
+++ b/s390x/tprot.c
@@ -12,7 +12,7 @@
 #include <bitops.h>
 #include <asm/pgtable.h>
 #include <asm/interrupt.h>
-#include "mmu.h"
+#include <mmu.h>
 #include <vmalloc.h>
 #include <sclp.h>
 
-- 
2.31.1

