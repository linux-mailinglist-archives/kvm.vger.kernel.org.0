Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFA60CB1F
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiJYLoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiJYLn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03D9175359
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:53 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8Ttt028286
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g1NvoQXOc5s/bQKikMOoFfTWAeIvTTKU4MS56HgdLv8=;
 b=CQqeI7RahfOpi2mClT8TYMLk/ACu9oXu+dC/ghptEfLmvrkGYfy/6pUV5h/SWk9cfKfv
 Q+fwlTn0I3cJpWQfl//rRaHUw+BwBMa5X1WXzaoyAAdNrUrKKhgBGCcdiYJujxTp16j3
 i1fa58LbfqWELg+smdEgHAGcXRwvy6bBiQnqjJOA4136CHPuuqb/HBdLY25UcxUdsw+1
 adNIRTDpYvicizQMB49IoP460eh/gT2Sm7WB3+JPAELJuNdVaYJJMNAfKLg9xcMJDivQ
 4yaxNdmx78WTG49HPEV9RD0XrSU6BdGQ0tu2EIxPFJ1qOF3D1sOA/H18kVq94JSBBgNW tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8a9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8bBC029832
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8a8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBcwtR024198;
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat579-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBiMUH32899478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:44:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822F4AE045;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51350AE051;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/22] s390x: uv-host: Add access checks for donated memory
Date:   Tue, 25 Oct 2022 13:43:30 +0200
Message-Id: <20221025114345.28003-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kqg-l9yeofi4m84Y2PpaQpL3eqvn5Yj3
X-Proofpoint-ORIG-GUID: s7op7Tqy-4ocdP3Od8cXhWoo_0VHCsiC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=909 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's check if the UV really protected all the memory we donated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by; Steffen Eiden <seiden@linux.ibm.com>
Message-Id: <20221017093925.2038-2-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a1a6d120..622c7f7e 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -43,6 +43,32 @@ static void cpu_loop(void)
 	for (;;) {}
 }
 
+/*
+ * Checks if a memory area is protected as secure memory.
+ * Will return true if all pages are protected, false otherwise.
+ */
+static bool access_check_3d(uint8_t *access_ptr, uint64_t len)
+{
+	assert(!(len & ~PAGE_MASK));
+	assert(!((uint64_t)access_ptr & ~PAGE_MASK));
+
+	while (len) {
+		expect_pgm_int();
+		READ_ONCE(*access_ptr);
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
+			return false;
+		expect_pgm_int();
+		WRITE_ONCE(*access_ptr, 42);
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
+			return false;
+
+		access_ptr += PAGE_SIZE;
+		len -= PAGE_SIZE;
+	}
+
+	return true;
+}
+
 static struct cmd_list cmds[] = {
 	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
 	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
@@ -194,6 +220,10 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = access_check_3d((uint8_t *)uvcb_csc.stor_origin,
+			     uvcb_qui.cpu_stor_len);
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -292,6 +322,13 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
 
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_base_stor_origin,
+			     uvcb_qui.conf_base_phys_stor_len);
+	report(rc, "Base storage protection");
+
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_var_stor_origin, vsize);
+	report(rc, "Variable storage protection");
+
 	uvcb_cgc.header.rc = 0;
 	uvcb_cgc.header.rrc = 0;
 	tmp = uvcb_cgc.guest_handle;
-- 
2.37.3

