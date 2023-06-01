Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DC371EF69
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjFAQpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjFAQps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 12:45:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6C218D;
        Thu,  1 Jun 2023 09:45:47 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351GbkHb018279;
        Thu, 1 Jun 2023 16:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=He4IEzgtg1My38B9Uz4X6kAZ6THbCICFQA40ZWTMYHY=;
 b=eYqrN90OHumxx1pDQLdquu0IZGz6svHUIRj21lvZEbU10TPr7AQvW2tiaFJsnV7XQ4Ae
 duc8+EIP14tMecr4eqn0FILokaR/CsFmGXMOrXXzgT4t9DYAFtZfKDmbRK4rz+wpRARp
 gOlGbWLRg8N6mdnymrvEey1DCEVMvXR+wRgubpO/nvZzGzkE9uoZgXUFQMcVbRYrNIFu
 s95ivUO5gcwVEBYTCLJBlnCGg1+hqk/VqbgPJ2xSq4qJkLpVCBWGPAQcDxDzItvtNdu6
 jO1QxcC5awdDbS/50N5vRCCCZBoympv1NItohTRfn7SCYlmrEJFZLrwEZYWNxJ5X9pCl BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxxpc0xp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:46 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351GcejM027057;
        Thu, 1 Jun 2023 16:45:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxxpc0xnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3512OpqE030267;
        Thu, 1 Jun 2023 16:45:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5amsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351GjeNc26935992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 16:45:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8447C20040;
        Thu,  1 Jun 2023 16:45:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C3C20043;
        Thu,  1 Jun 2023 16:45:39 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.12.131])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 16:45:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 2/2] s390x: sclp: Implement extended-length-SCCB facility
Date:   Thu,  1 Jun 2023 18:45:37 +0200
Message-Id: <20230601164537.31769-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230601164537.31769-1-pmorel@linux.ibm.com>
References: <20230601164537.31769-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fzYZ6cOxKisjI2sZHmMf8LS-fE37MFsB
X-Proofpoint-GUID: 3GQw4X_o6FfDssN-tesFGXORccTcC29y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=971 impostorscore=0 spamscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the extended-length-SCCB facility is present use a big
buffer already at first try when calling sclp_read_scp_info()
to avoid the SCLP_RC_INSUFFICIENT_SCCB_LENGTH error.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index adf357b..e44d299 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -17,13 +17,14 @@
 #include "sclp.h"
 #include <alloc_phys.h>
 #include <alloc_page.h>
+#include <asm/facility.h>
 
 extern unsigned long stacktop;
 
 static uint64_t storage_increment_size;
 static uint64_t max_ram_size;
 static uint64_t ram_size;
-char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 static ReadInfo *read_info;
 struct sclp_facilities sclp_facilities;
 
@@ -114,6 +115,8 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
 void sclp_read_info(void)
 {
 	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
+	sclp_read_scp_info((void *)_read_info,
+		test_facility(140) ? sizeof(_read_info) : SCCB_SIZE);
 	read_info = (ReadInfo *)_read_info;
 }
 
-- 
2.31.1

