Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB1739876
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjFVHwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjFVHwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825CC199C;
        Thu, 22 Jun 2023 00:52:08 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7lNt5005418;
        Thu, 22 Jun 2023 07:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WeHt63U/8QSdB8iwiYKHyuuPgRF8rqcp1q52CXC9Dtc=;
 b=jZsBJ15+458YBWLO/OCbT0bBspCIWH7QmdrCnQB5TxUva9eXcNB4ce/FF2jv3UamoajO
 PIgMZsfb8fByM1MZ5Fo4FdF79JscMLWseh+a+k0chRv2AIjNfrnr5eRMjT1vs0Vy8cqx
 AGD6uG699gB8w2TD0DJAw9A0dDwplwD8ZwnYOFPP7OuvohL11WSz695ik1YEac70fuCT
 z9VjUiFaruETPqXATCH2a6imCTz1uvK7fxsicK2wpIJHuZ4o64YxaIJ/b6xRbRnbhYRC
 qaciygWkzVb1w6hxxmMh+x1YliLZ/ygyhhchg7Uxdi6+R1u7GDKenRuUwFW7jcEpJnDE WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj7j825w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:07 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7mTmC008188;
        Thu, 22 Jun 2023 07:52:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj7j825j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M5uWkP011191;
        Thu, 22 Jun 2023 07:52:05 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r94f52gtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q19h57803094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AADD92004B;
        Thu, 22 Jun 2023 07:52:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7DB920040;
        Thu, 22 Jun 2023 07:52:00 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:52:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 2/8] s390x: uv-host: Check for sufficient amount of memory
Date:   Thu, 22 Jun 2023 07:50:48 +0000
Message-Id: <20230622075054.3190-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _FOOanDIxq6FPw3wvfROSGMi8eBxrwNI
X-Proofpoint-GUID: 1aJM7Hd4RnTL_tFxGJhvx24mq5i7fiDN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV init storage needs to be above 2G so we need a little over 2G
of memory when running the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 9dfaebd7..ee8e44d1 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,6 +15,7 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
+#include <snippet.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/sigp.h>
@@ -720,6 +721,13 @@ int main(void)
 	test_invalid();
 	test_uv_uninitialized();
 	test_query();
+
+	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
+		report_skip("Not enough memory. This test needs about %ld MB of memory",
+			    SNIPPET_PV_MIN_MEM_SIZE / SZ_1M);
+		goto done;
+	}
+
 	test_init();
 
 	setup_vmem();
-- 
2.34.1

