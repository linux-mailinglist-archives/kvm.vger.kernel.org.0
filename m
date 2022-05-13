Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D27525F87
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379188AbiEMJvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379160AbiEMJvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A0859089;
        Fri, 13 May 2022 02:51:47 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D80jxU024781;
        Fri, 13 May 2022 09:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mGXMzkGA2hf+OzGbroVOqmibZfDBb8CEpJL7TG8b4CY=;
 b=GzMHmm+CgVmbeG2td2JEder9qkQ6TxEZiBTyf6x4qUYf9vFyIY8+pw8yFKO3agOv9Nnm
 MxIwQELZdJ+FXPGu7YPsOnoGFoEg8yptjW55VDDz0wiogyHK5eWHQ9a1/+wtjVM3Khd9
 BgwDznFtc3TMKcBFZSuVZXZqjYT05RGyngPukIHFIqwvlalp774QjwpRIbA3Z2EhSxST
 FeGZuG+wHwTYvl3UOTEctM2LbnzG2Yub+juttvzCjVSj2Q+ydAJYlYfV8s6tgipNIzpU
 yqumFxp1gjGPys5xfMgoxBX7O8DDtT2PCJwh1tpidt/nYrnuHAdn6be8xZjYx6up9v0t 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ket1xv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:47 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D9jB1t009699;
        Fri, 13 May 2022 09:51:46 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ket1xup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9SShc021575;
        Fri, 13 May 2022 09:51:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8pj48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9pfIY33489286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:51:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 086E34C04E;
        Fri, 13 May 2022 09:51:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33F134C046;
        Fri, 13 May 2022 09:51:40 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/6] s390x: uv-host: Add access checks for donated memory
Date:   Fri, 13 May 2022 09:50:12 +0000
Message-Id: <20220513095017.16301-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220513095017.16301-1-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SKWGjkzi_brYQO2KDfMGk2DVN3IiDnZs
X-Proofpoint-GUID: 9zYEpzz3WrLp4dnUiLNPFbiBiTRSksJX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the UV really protected all the memory we donated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a1a6d120..0f0b18a1 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -142,7 +142,8 @@ static void test_cpu_destroy(void)
 static void test_cpu_create(void)
 {
 	int rc;
-	unsigned long tmp;
+	unsigned long tmp, i;
+	uint8_t *access_ptr;
 
 	report_prefix_push("csc");
 	uvcb_csc.header.len = sizeof(uvcb_csc);
@@ -194,6 +195,18 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = 1;
+	for (i = 0; i < uvcb_qui.cpu_stor_len / PAGE_SIZE; i++) {
+		expect_pgm_int();
+		access_ptr = (void *)uvcb_csc.stor_origin + PAGE_SIZE * i;
+		*access_ptr = 42;
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS) {
+			rc = 0;
+			break;
+		}
+	}
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -205,8 +218,9 @@ static void test_cpu_create(void)
 static void test_config_create(void)
 {
 	int rc;
-	unsigned long vsize, tmp;
+	unsigned long vsize, tmp, i;
 	static struct uv_cb_cgc uvcb;
+	uint8_t *access_ptr;
 
 	uvcb_cgc.header.cmd = UVC_CMD_CREATE_SEC_CONF;
 	uvcb_cgc.header.len = sizeof(uvcb_cgc);
@@ -292,6 +306,30 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
 
+	rc = 1;
+	for (i = 0; i < vsize / PAGE_SIZE; i++) {
+		expect_pgm_int();
+		access_ptr = (void *)uvcb_cgc.conf_var_stor_origin + PAGE_SIZE * i;
+		*access_ptr = 42;
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS) {
+			rc = 0;
+			break;
+		}
+	}
+	report(rc, "Base storage protection");
+
+	rc = 1;
+	for (i = 0; i < uvcb_qui.conf_base_phys_stor_len / PAGE_SIZE; i++) {
+		expect_pgm_int();
+		access_ptr = (void *)uvcb_cgc.conf_base_stor_origin + PAGE_SIZE * i;
+		*access_ptr = 42;
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS) {
+			rc = 0;
+			break;
+		}
+	}
+	report(rc, "Variable storage protection");
+
 	uvcb_cgc.header.rc = 0;
 	uvcb_cgc.header.rrc = 0;
 	tmp = uvcb_cgc.guest_handle;
-- 
2.34.1

