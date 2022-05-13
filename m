Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DAB525F32
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379213AbiEMJv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379200AbiEMJvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963375716C;
        Fri, 13 May 2022 02:51:51 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D8l1UL017330;
        Fri, 13 May 2022 09:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Oi6VVb6LHV67qgW+GLrA+NNjrQLt95htfOR/g/RMC0A=;
 b=X4LbRtdnMR3YBU6lh5tYJU74e7pxMiVh1/acmvSIUzhJTibFXTu1LFDAUpJAyL4a8mZw
 qtAs0vXL4D6uJRFOcC1NFDc1dnZmOa8DnkNABvBWWjyYhSfOtC7OEh87NpJtzKh+Q8Rp
 +5c+p7s60L3rzaqxusagWud5Z8UZtMMBbHuFPJf8ctJEGiRfQsWUgfhMicqJU3l4uvBR
 gZToER6vXBR8M/Q7MALmioqF/TuZGCnzUrwC4xO/BkAeKMVyNrt/ac3oHEYkk8jRrtSV
 harrf9U9bB8vuWC9T0VrR3FdlMP3BX+jNQC1pvaXObwTJ4zWOaBpPJY97wz5HcwKNzjs qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1m4g93xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D9hZfr010406;
        Fri, 13 May 2022 09:51:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1m4g93x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9RvDW024501;
        Fri, 13 May 2022 09:51:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3fwg1hxhu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9pjdV49152388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:51:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F05E54C046;
        Fri, 13 May 2022 09:51:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27C044C044;
        Fri, 13 May 2022 09:51:44 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/6] s390x: uv-host: Add a set secure config parameters test function
Date:   Fri, 13 May 2022 09:50:16 +0000
Message-Id: <20220513095017.16301-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220513095017.16301-1-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yyt9zraNINHo9TnfF4x9tMtoUKIK_E5y
X-Proofpoint-ORIG-GUID: vmiBrgr68MNdcbS3d19W9Rixz4WR28OT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time for more tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 153a94e1..20d805b8 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -229,6 +229,52 @@ static void test_cpu_destroy(void)
 	report_prefix_pop();
 }
 
+static void test_set_se_header(void)
+{
+	struct uv_cb_ssc uvcb = {
+		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
+		.header.len = sizeof(uvcb),
+		.guest_handle = uvcb_cgc.guest_handle,
+		.sec_header_origin = 0,
+		.sec_header_len = 0x1000,
+	};
+	void *pages =  alloc_pages(1);
+	void *inv;
+	int rc;
+
+	report_prefix_push("sscp");
+
+	uvcb.header.len -= 8;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_LEN,
+	       "hdr invalid length");
+	uvcb.header.len += 8;
+
+	uvcb.guest_handle += 1;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_GHANDLE, "invalid handle");
+	uvcb.guest_handle -= 1;
+
+	inv = pages + PAGE_SIZE;
+	uvcb.sec_header_origin = (uint64_t)inv;
+	protect_page(inv, PAGE_ENTRY_I);
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == 0x103,
+	       "se hdr access exception");
+
+	/*
+	 * Shift the ptr so the first few DWORDs are accessible but
+	 * the following are on an invalid page.
+	 */
+	uvcb.sec_header_origin -= 0x20;
+	rc = uv_call(0, (uint64_t)&uvcb);
+	report(rc == 1 && uvcb.header.rc == 0x103,
+	       "se hdr access exception crossing");
+	unprotect_page(inv, PAGE_ENTRY_I);
+
+	report_prefix_pop();
+}
+
 static void test_cpu_create(void)
 {
 	int rc;
@@ -669,6 +715,7 @@ int main(void)
 
 	test_config_create();
 	test_cpu_create();
+	test_set_se_header();
 	test_cpu_destroy();
 	test_config_destroy();
 	test_clear();
-- 
2.34.1

