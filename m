Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA7509B25
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 10:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386939AbiDUIxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 04:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386932AbiDUIxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 04:53:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FEFDEDB;
        Thu, 21 Apr 2022 01:50:30 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L6jBmc002668;
        Thu, 21 Apr 2022 08:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pfMdYvFFCrhWk8ag/FKteO217Rz48d7za6nzd1UlVyY=;
 b=O8cK7UpOoEkBQr+798F4rzbabwoYZqPak9GG/tTmQgghlbBjz/MwtggEMud3a9uDw1Oa
 aXbbn1yXb8bweCZ/8UKhjXxrMJ1MNswcytaSgdqHwaXnHu0VFRattxAi7Ojfm1kAz78E
 BXCyFFlcWOWzD4w7ogy5uF0tmYIpNDfdHMCcTHgScVe1kMp+JPwaNEJpgYWnMUByHDR2
 jQFpbTzu7bL5Yv8NyyWdvyHuW1KrZg+CiXjCtB3q4tCBXasbCsHOkOZ30GoqhYZFQJAV
 NU5dXU6moG6dAyWwqOFaOLYGq9EQgAMGzdWXSNLeNC5AnYBkEjS4/XkhGvSRL9xrwjYQ rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhxh8xr5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:29 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8W3Vt029377;
        Thu, 21 Apr 2022 08:50:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhxh8xr4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L8RG3T015164;
        Thu, 21 Apr 2022 08:50:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne97j1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L8bXCL34406796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 08:37:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDF90A4053;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85C8EA4057;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: tprot: use lib include for mmu.h
Date:   Thu, 21 Apr 2022 10:50:20 +0200
Message-Id: <20220421085021.1651688-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220421085021.1651688-1-nrb@linux.ibm.com>
References: <20220421085021.1651688-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H3JgW0tNJsmqMfZ9vtMHRedf-YXFRZbr
X-Proofpoint-GUID: k-Dekv4a8lfDkeVZ7ueOJDthJCRe62Ib
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=894
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu.h should come from the library includes

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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

