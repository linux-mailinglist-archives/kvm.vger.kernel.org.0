Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6A64F7A0F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbiDGIqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243244AbiDGIqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6763F182AFF;
        Thu,  7 Apr 2022 01:44:37 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2378Lm0w013990;
        Thu, 7 Apr 2022 08:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RJjnPFfuV2fON+WWfvKJsXPMgc+pwm3pxAFmn+iNekc=;
 b=o5+4PbCkWPF2AoD7G0VC4zTav8kSWLm/R0BmSbXz386/YRaJqK+SJu2kPWI/1BuFtVsF
 Sb//afbv4SH13ATQw8F0Rrt6SH+7VgGm98/rpYDzUNlOii9RaCVYP+XlTot71bFpjcOK
 ct8h9TyLqSf20YLcYE1MBShFVtkixo0b31u+jFdIgLaGMY/X/25c7cR82043ZILpj8h1
 ynZUtp/VCl0VCrnlYAJ04GwPISorbylW2u3U9WmZp2Ek8vXEDNXOH/ZOHxy5yTWWcQ/d
 mBiXBuG7fBgMOmzhrM0x7dbpt9QOIpr5DeWe/lkmF+FjgTHc8hE07Fpy8OvHHaov6viy pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9vcggdmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:36 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378OFpw022529;
        Thu, 7 Apr 2022 08:44:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9vcggdm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378XKOt016676;
        Thu, 7 Apr 2022 08:44:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e491e3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378iV5o50004238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:44:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F06CAE053;
        Thu,  7 Apr 2022 08:44:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63C13AE045;
        Thu,  7 Apr 2022 08:44:30 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/9] s390x: css: Skip if we're not run by qemu
Date:   Thu,  7 Apr 2022 08:44:14 +0000
Message-Id: <20220407084421.2811-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xyzSJtufpNLrJuZ085t5U45Q2sjwe1en
X-Proofpoint-GUID: 8XpkcOHnpnCBSqOS7Wbbqxr2IIKpj4KF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=827 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no guarantee that we even find a device at the address we're
testing for if we're not running under QEMU.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.32.0

