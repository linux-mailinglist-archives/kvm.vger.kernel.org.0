Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6D06C7DE8
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjCXMSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjCXMSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9D7173A
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:19 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBLLff026446
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vij4tZW0ajqr5fyCXjCdAa3a0o2RBWnAhEg6bT5223E=;
 b=nuvBa0u+5J9v/3GNdSEv57bRai05s5J5CdGZPpNtmUziScMtslgF+Zt2LkiFcrkMN9Ui
 qMW7V1QWatZAJnqwNbtowGXzQjDhJUq3dK3oEa5EEoAaZh/m91WmKUV8C5G9aae3Muvh
 r5F9cTlt7d7TCdOkIQgdmrg2W3a+TR643n3hBAY/hIaxaqmzA/fbxDKHtzR2rymOP5BV
 Q149LB1aXwT/2jaGLXALzDrByszXfle0mJQZSUwxl913D3qI+Q9pMka3R3lC8YV1zshJ
 pE5U+hscH61GKzymwXPXlcRzCdDPvvuySQ4UuJ2jrnzEmS58KoR0/0ALbfqleNBINcUG 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phawuh9ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBUbZl028250
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phawuh9n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLalfq010748;
        Fri, 24 Mar 2023 12:18:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pgxua8tf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCIDUm27787860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B1092004D;
        Fri, 24 Mar 2023 12:18:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 701282004B;
        Fri, 24 Mar 2023 12:18:12 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 6/9] s390x: uv-host: Fix create guest variable storage prefix check
Date:   Fri, 24 Mar 2023 12:17:21 +0000
Message-Id: <20230324121724.1627-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4BdPmmHxv4NXhLQy22nznnScah2WurMP
X-Proofpoint-GUID: IUKFFqxVDwMsmS2gnBYQ92BjTVtuX2Pc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want more than one cpu and the rc is 10B, not 10E.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 13e49ed3..f9a55acf 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -434,11 +434,15 @@ static void test_config_create(void)
 	       "base storage origin contains lowcore");
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
-	if (smp_query_num_cpus() == 1) {
+	/*
+	 * Let's not make it too easy and use a second cpu to set a
+	 * non-zero prefix.
+	 */
+	if (smp_query_num_cpus() > 1) {
 		sigp_retry(1, SIGP_SET_PREFIX,
 			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
-		report(uvcb_cgc.header.rc == 0x10e && rc == 1 &&
+		report(uvcb_cgc.header.rc == 0x10b && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
 		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
-- 
2.34.1

