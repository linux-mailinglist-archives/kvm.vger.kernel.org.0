Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56380600B12
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiJQJkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiJQJkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47BB25EBD
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:03 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9VNfJ031502
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1m3ANcQKhpTluC+250DRIOjxVo9sB1ZcH8qoE9XXdQs=;
 b=UvwWs3DQQd+eNLPkPw0D7mJejQYTogJecHy0jsDl/vldx+q94+Up+Wtew3vxDpzxW6my
 L76CNQXPmu/phszu+W3IVvOfUdBy4fXpz8eYG552VHglJra4mwS0AGWjQHpa6y6X8Bc1
 8AKgvJ6dz1tqQLSQJm9lkYjKL3+/sdCJP4wpi/uH3ovVyAbFZlArHCtNLjMLgkLNlMYG
 xe2KdUe6mx7hG5jeekB1xQuJ3yvnrSaDhJZVxXetSKk1wyBfBVBM/VXwKNBJqgPhFzZZ
 NnkoJRhrem3tK49vpTD/qDzz98U8EUhCqbeg4LlmtbWzlYRzXi7Y7iXcQoAK8njSTkow bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86hkb1ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:02 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H9dHNR002846
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:01 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86hkb1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9bCuh012593;
        Mon, 17 Oct 2022 09:39:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3k7m4jjrcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9duFt6750736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A59E4A405B;
        Mon, 17 Oct 2022 09:39:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A1BA4054;
        Mon, 17 Oct 2022 09:39:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/8] s390x: uv-host: Add a set secure config parameters test function
Date:   Mon, 17 Oct 2022 09:39:22 +0000
Message-Id: <20221017093925.2038-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3EWNd7LohRiNGDHxAM93-v8GXnzU8R4r
X-Proofpoint-ORIG-GUID: OhNCc5qoNFewTqvOgxO4WzPnGMgSstYH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time for more tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 305b490f..05502d9a 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -256,6 +256,53 @@ static void test_cpu_destroy(void)
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
+	free_pages(pages);
+	report_prefix_pop();
+}
+
 static void test_cpu_create(void)
 {
 	int rc;
@@ -669,6 +716,7 @@ int main(void)
 
 	test_config_create();
 	test_cpu_create();
+	test_set_se_header();
 	test_cpu_destroy();
 	test_config_destroy();
 	test_clear();
-- 
2.34.1

