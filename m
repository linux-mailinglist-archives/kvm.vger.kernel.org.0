Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9160CB24
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiJYLoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiJYLn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014BA17535C
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:54 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8UIc011576
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=clu6OQ6JaBz3eP1HGsNYBZoV6x1K04GF0jA3ljFhupE=;
 b=Sl2W1nt2KH0WxHbYdK2u8Pwh1nLwL73cIIg/z/WrD615aZ/ZiAx7B/DCP1q2POzlOo4D
 X+RbdjOWa12F8NEvV3U0Ujn3yI8Jb+YJrlaPwpTAwLsgs0TPLpPD72pj6K8t8HLxUVEY
 rpho6s8mQTdPB6noGZaQknikIggZCi4Ii+KTU63xtOf20Au/pzIiBXwKcz4xj6qLRBc7
 5LjWorrgUr5OhcC2zZ/RzC4FCdinG9LA8eyYOvTNBnliHvm9wEfGM+fMh69uYdCM4MTz
 nixcahDtq4IP+N6MclAN9uXK0KZ1Y8p3rnt8HQY9hlZiJ0de/2i7RF+Ls5D9WHKgY6Ob DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee02tdn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:53 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB94NN013911
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:53 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee02tdmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBc7cI013897;
        Tue, 25 Oct 2022 11:43:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3kc8594ddm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBcZS348365836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:38:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F5FCAE045;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DC56AE055;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 11/22] s390x: uv-host: Add a set secure config parameters test function
Date:   Tue, 25 Oct 2022 13:43:34 +0200
Message-Id: <20221025114345.28003-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CqLNPoBvnRPeNLeCPiKeZcsCA40QAArG
X-Proofpoint-ORIG-GUID: iJwP1RVNEEqiHkWCXudhvEL2akRBnU5Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
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

Time for more tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Message-Id: <20221017093925.2038-6-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.37.3

