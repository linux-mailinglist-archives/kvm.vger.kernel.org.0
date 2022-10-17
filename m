Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650BA600B11
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiJQJkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiJQJkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6785B237D4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:01 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9VhN9027427
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZIGFLIQ8cCCRCPuQmsTkJqlThiHyJjhkqcUMNV1aqa0=;
 b=KVA6ErtB90gO9CYTVQl6IDIVYHR1YXVV9bquqhSRPahf/HjasUal/EPqlLKZxggeCYyO
 opydd0LhZQvBSJKcKPOIIooH1krje9Vg/ZdLAPbgpnIstecsGBTQD2dnyk2TuLXsVRsZ
 qhYXazEBzYA6r/BasKrRr0SwqHkWjjBcL1/IyXR7+0ULAdxtunc4zOavO+KqTY0x3YTF
 3+FZE7Jre41ihtWb2HMSYFwSmQSshY2ndyxy5Fy59aj+wbejaaLTPewnFThA7u0HfKOQ
 9E+qK3Pa3COMB1fLlRCuxVGId6AAUrOT8L4AypumyyzKl8wFgGSvqJIY8leuYlFEEtS3 zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H7tgjm028712
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9adYQ032115;
        Mon, 17 Oct 2022 09:39:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9a2jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9dtN357278770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 071F2A405B;
        Mon, 17 Oct 2022 09:39:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ED09A4054;
        Mon, 17 Oct 2022 09:39:54 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/8] s390x: uv-host: Test uv immediate parameter
Date:   Mon, 17 Oct 2022 09:39:20 +0000
Message-Id: <20221017093925.2038-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NdZmhwLRWHP16kGoGIWBRFWZjVvfSUNz
X-Proofpoint-GUID: Vg_8BjthLw1sLpPVZYN6a3jO2_n_Zy-U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=841 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get a specification PGM exception if we set a
non-zero i3 when doing a UV call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 24dcd6dc..e401fa5d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -90,6 +90,28 @@ static struct cmd_list cmds[] = {
 	{ NULL, 0, 0 },
 };
 
+static void test_i3(void)
+{
+	struct uv_cb_header uvcb = {
+		.cmd = UVC_CMD_INIT_UV,
+		.len = sizeof(struct uv_cb_init),
+	};
+	unsigned long r1 = 0;
+	int cc;
+
+	report_prefix_push("i3");
+	expect_pgm_int();
+	asm volatile(
+		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],4,2\n"
+		"		ipm	%[cc]\n"
+		"		srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: [r1] "a" (r1), [r2] "a" (&uvcb)
+		: "memory", "cc");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
 static void test_priv(void)
 {
 	struct uv_cb_header uvcb = {};
@@ -585,6 +607,7 @@ int main(void)
 		goto done;
 	}
 
+	test_i3();
 	test_priv();
 	test_invalid();
 	test_uv_uninitialized();
-- 
2.34.1

