Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8554E2433
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346285AbiCUKUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346261AbiCUKUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215822C13A;
        Mon, 21 Mar 2022 03:19:14 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L7Lq1P024285;
        Mon, 21 Mar 2022 10:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JeuytjubPG8GOorb5edg4H1plZpbBkzegdyzimyumJI=;
 b=FlaSgoHqjWXv4VxNqldwQG+OfxGrAPmakgon7UF6vy9SWFcrzVgHHS19MPRCLeqAKaYq
 LQqLxj9DHFNpOiBNSllDxVNxL2AKacV3mIgf3lG1FVxDYGRiqvHG8cNvsdjNZJjcjuRg
 eTs4aYjHINFp5mATFSXRS2pK69gtq+H68HF/ES61HK+ohfOb8I7q+DJKU0TuHD/Y44ik
 6fs45ArdOEaxBy2hqLk55vyxnmhuinx9RIEZohWfuwWve5npi68rhcrktJgWAD5xKx/8
 uBAs3VfndOf/bf+CVBlsvtadCub2VIsFw04SS0PgzhYZ1rOfl3uUmWkD5XqX7YQaZnNM zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmwkbjx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22L9fn7o003054;
        Mon, 21 Mar 2022 10:19:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmwkbjwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LAC6ZE009778;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t933qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ7kb41681226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805D911C052;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ADAF11C04C;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 7/9] s390x: smp: add tests for CONDITIONAL EMERGENCY
Date:   Mon, 21 Mar 2022 11:19:02 +0100
Message-Id: <20220321101904.387640-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qUldapKGt0t9kaL1BH3ixllFoM85U-7Y
X-Proofpoint-GUID: _-zVEXncMOEhrSKKmewrBTSKacZW6ICn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test for the conditional emergency signal.

We cover the following cases:
- invalid CPU address. Should lead to the order being rejected.
- the order is accepted and an emergency signal is delivered. We make sure
  this is the case by disabling the CPU's PSW for IO interruptions.

Note we intentionally don't cover the case where the signal isn't
delivered. As per the PoP, implementations are allowed to make the signal
an unconditional one when the condition determination is precluded.

This test is unsupported under PV.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 3bd7e7c8f5ed..9c4e27106aef 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -16,6 +16,7 @@
 #include <asm/sigp.h>
 
 #include <smp.h>
+#include <uv.h>
 #include <gs.h>
 #include <alloc_page.h>
 
@@ -604,6 +605,47 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
 
+static void test_cond_emcall(void)
+{
+	uint32_t status = 0;
+	struct psw psw;
+	int cc;
+	psw.mask = extract_psw_mask() & ~PSW_MASK_IO;
+	psw.addr = (unsigned long)emcall;
+
+	report_prefix_push("conditional emergency call");
+
+	if (uv_os_is_guest()) {
+		report_skip("unsupported under PV");
+		goto out;
+	}
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_COND_EMERGENCY_SIGNAL, 0, NULL);
+	report(cc == 3, "CC = 3");
+
+	report_prefix_pop();
+
+	report_prefix_push("success");
+	set_flag(0);
+
+	smp_cpu_start(1, psw);
+	wait_for_flag();
+	set_flag(0);
+	cc = smp_sigp(1, SIGP_COND_EMERGENCY_SIGNAL, 0, &status);
+	report(!cc, "CC = 0");
+
+	wait_for_flag();
+	smp_cpu_stop(1);
+
+	report_prefix_pop();
+
+out:
+	report_prefix_pop();
+
+}
+
 static void test_sense_running(void)
 {
 	report_prefix_push("sense_running");
@@ -731,6 +773,7 @@ int main(void)
 	test_set_prefix();
 	test_ecall();
 	test_emcall();
+	test_cond_emcall();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.31.1

