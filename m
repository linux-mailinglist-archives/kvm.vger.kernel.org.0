Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5AC524913
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352114AbiELJf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352033AbiELJfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B301B69B6B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:37 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9F2KI019795
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8GQGZKGi2PDG6U8D8O87WfWDQLL0dH1qvMo2T9sjxYY=;
 b=GKF0FxDMetHogxsrqKkE+IkVoOlTCTyOQv6YWx0niN2fHigkSyfgji4PVGFqq8nWQgS6
 OMZdHdBkwh0YY14Vh548qaZtChaAewNP0/svdIyXkPE94+HSVef7fj7y81BzjnX2P/2s
 tGiYqKsltuV7PtiCtpbJ8uq9YV/4uwfzcu9BDQgv9PcTMx2EexknoC0HAdOfsg7QKUZF
 rjPSRnuy3vGvRlpxh2s0Kxk6Qw5I7tw3yeaTflIX7ajOH7bVXsOEKzwDS8RZp/Iv71Gy
 PvITCkE9gnh7bzUCImyfJCeP04TjpVx73q0O+z318anWW53QvUh5KiAHLHosbFHmFk8U 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9VvjR032151
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XPBm008182;
        Thu, 12 May 2022 09:35:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8wa00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZVQE58327408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6597A11C04A;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15CA111C050;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/28] s390x: css: Skip if we're not run by qemu
Date:   Thu, 12 May 2022 11:35:02 +0200
Message-Id: <20220512093523.36132-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v0iWtfmDNCcCGyS9SQ3C0MeMs-8kso9Z
X-Proofpoint-GUID: ZHnsAdLw95Cw1UHfdKjsTvfVIv7Mk1hD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=844
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
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

There's no guarantee that we even find a device at the address we're
testing for if we're not running under QEMU.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/css.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/s390x/css.c b/s390x/css.c
index a333e55a..13a1509f 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -15,6 +15,7 @@
 #include <interrupt.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
+#include <hardware.h>
 
 #include <malloc_io.h>
 #include <css.h>
@@ -642,13 +643,21 @@ int main(int argc, char *argv[])
 	int i;
 
 	report_prefix_push("Channel Subsystem");
+
+	/* There's no guarantee where our devices are without qemu */
+	if (!host_is_qemu()) {
+		report_skip("Not running under QEMU");
+		goto done;
+	}
+
 	enable_io_isc(0x80 >> IO_SCH_ISC);
 	for (i = 0; tests[i].name; i++) {
 		report_prefix_push(tests[i].name);
 		tests[i].func();
 		report_prefix_pop();
 	}
-	report_prefix_pop();
 
+done:
+	report_prefix_pop();
 	return report_summary();
 }
-- 
2.36.1

