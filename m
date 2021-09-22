Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7951F414286
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhIVHVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13422 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233059AbhIVHUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:38 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M5BvGD032763;
        Wed, 22 Sep 2021 03:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jKlwvLkeEqkg20MGQd8BEJWzIJSd5y4CgNbUZguvQV8=;
 b=TJZo2cXCX59ajdA6oB9UZ88JsAs/ghf3hh4aLCu6WY+XCnYRC3iowrwI4cMn/uEdvVbs
 jHVSWZs61S0N/ezJtSJmWLC+nAEkvx6R9G47y2vjb0vZlnshedbXa5YhOXZ9VVfBdsbo
 ERSVI7cZWG7tyRBVDHQirLHo25Kjmr8PCnri1RXrDgIICZCw90si3xnL+G98ulm7htve
 wk/KdTobK/+JVX7rS9H9blMnIv7z8Mq/n2J+YEjSqXLcRfmXw5Y59lFce4QXN8f6N9nm
 Xj245M+Apaz8IDyhEQdoHX8KOU0Hyv4YkWcl0X8vNa5s8Qc6/RHRgQtOGpHb1HEmpjv5 Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7x4jad82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M5QOqE012637;
        Wed, 22 Sep 2021 03:19:07 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7x4jad7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:07 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M77gwx003960;
        Wed, 22 Sep 2021 07:19:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3b7q6jba3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7J1DR4129470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:19:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEEF4A405D;
        Wed, 22 Sep 2021 07:19:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C723A405F;
        Wed, 22 Sep 2021 07:19:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:19:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 9/9] s390x: skrf: Fix tprot assembly
Date:   Wed, 22 Sep 2021 07:18:11 +0000
Message-Id: <20210922071811.1913-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vDuguMbPS88cMB1dX6fcmHuXm3mdK5I0
X-Proofpoint-ORIG-GUID: 4Aih0g4Uvr9byV5cNtc1nZNIwEEnggXw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 phishscore=0 mlxlogscore=913 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's a base + displacement address so we need to address it via 0(%[addr]).

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/skrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/skrf.c b/s390x/skrf.c
index 8ca7588c..84fb762c 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -103,7 +103,7 @@ static void test_tprot(void)
 {
 	report_prefix_push("tprot");
 	expect_pgm_int();
-	asm volatile("tprot	%[addr],0xf0(0)\n"
+	asm volatile("tprot	0(%[addr]),0xf0(0)\n"
 		     : : [addr] "a" (pagebuf) : );
 	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
 	report_prefix_pop();
-- 
2.30.2

