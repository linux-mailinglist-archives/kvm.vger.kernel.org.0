Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AFD4EEC38
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiDALS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345431AbiDALS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2614186F83
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:40 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319noig006652
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lWcgMYQHu3kxXQ8mFwqZdEXsvqpQpk1pNBgJRl32bBc=;
 b=p1+0FMVHEhTvkECeXbUb07ZXqSCwdl68P63pkMs4AT7LC/0btrUlfefh5gg8xDrQaJVp
 PeN33vyrGUsHBIcTYvsPFoRmYZMIh4bSvZFkhwRO/wSbh50/UbQkGbOvKN01XHBLajqB
 lOAQhPm9n/LhdhDdnJphpkTaa2XBwoEoSxicYOnqc+2L/k5o4SKPAAeY6vJZ9cMndWN8
 fJ5Co7WYwZLzI1N51CNp10IOdKI8bCchb83GRt2YJSWzDRVA9j2Sr7OYnDywWjWncEzs
 y1fz1CzR7id2dnmeIBZk+0GvK7Yk8HuRQo9GTPxIyo5K0RxdT8gXtu+YVACh1CTFCKsb pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y3y1rqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:40 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231ANHqi021930
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y3y1rpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7ss8012931;
        Fri, 1 Apr 2022 11:16:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9mv0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGYo845613330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 060AD4C07A;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D984C062;
        Fri,  1 Apr 2022 11:16:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:33 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 19/27] s390x: smp: add tests for CONDITIONAL EMERGENCY
Date:   Fri,  1 Apr 2022 13:16:12 +0200
Message-Id: <20220401111620.366435-20-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ji98iM3-KP2HLiaczVv33_a_H3AM7xji
X-Proofpoint-ORIG-GUID: k-0qF81PQRXFDSrrzOQLZlJ38HD_SASC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

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
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index c204d0b9..1dffbd7b 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -16,6 +16,7 @@
 #include <asm/sigp.h>
 
 #include <smp.h>
+#include <uv.h>
 #include <alloc_page.h>
 
 static int testflag = 0;
@@ -362,6 +363,47 @@ static void test_emcall(void)
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
@@ -485,6 +527,7 @@ int main(void)
 	test_set_prefix();
 	test_ecall();
 	test_emcall();
+	test_cond_emcall();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.34.1

