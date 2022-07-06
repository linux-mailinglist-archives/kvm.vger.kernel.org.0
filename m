Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778B4567ECA
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiGFGle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGFGl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795FD1A81B;
        Tue,  5 Jul 2022 23:41:26 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2665aKsj009070;
        Wed, 6 Jul 2022 06:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8lyqnH+JwllXGgXSVTjsoNzaGHgZXmKhOFlpFSwYUDA=;
 b=kIFoyfhWzZvw3YuTCdb9NeC5NGsV4gmfreh1guNpnpzP1zCfzBGqFBJvdl3OECGC8HAb
 DlazfAgMEgQ2U5ImHKGg5+bwtjAt8sc59MHxWoCZOawo24324nYKNwi22wr/RcqQKMzh
 V+hzm0KOxl2FUjPRvXdzQXXPK3RuoUhMcnw5rxmblAWfiwwCVMoX88/FRhBI/t/q2mqV
 yuSKTv7BUt+nMcD43cJ+xLQJp5NHoducC6JFgst6UmE9rpStoUZwbch3X+j1RvrIewbP
 rxpK3P3+N2TT6v1EYKL/Es4ZUE+JJfkOQEX5n+0uwxuJD5ngut9ZF1U0mc127kHhNbfR VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h537fjqkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:25 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2665cPf5014635;
        Wed, 6 Jul 2022 06:41:25 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h537fjqjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666M5UF025562;
        Wed, 6 Jul 2022 06:41:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsgjbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fJuX23593238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3FB94C044;
        Wed,  6 Jul 2022 06:41:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D066B4C040;
        Wed,  6 Jul 2022 06:41:18 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 8/8] s390x: uv-host: Fix init storage origin and length check
Date:   Wed,  6 Jul 2022 06:40:24 +0000
Message-Id: <20220706064024.16573-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UIaZZch0i4waty1NTFG11AoIOfFRL72F
X-Proofpoint-ORIG-GUID: xVQCgK-GwgkDG2udHwsCcrbrR2v8pmPh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The origin and length are masked with the HPAGE_MASK and PAGE_MASK
respectively so adding a few bytes doesn't matter at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 1ed8ded1..b1412a20 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -516,17 +516,22 @@ static void test_init(void)
 	       "storage invalid length");
 	uvcb_init.stor_len += 8;
 
-	uvcb_init.stor_origin =  get_max_ram_size() + 8;
+	/* Storage origin is 1MB aligned, the length is 4KB aligned */
+	uvcb_init.stor_origin = get_max_ram_size();
 	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x104,
+	report(rc == 1 && (uvcb_init.header.rc == 0x104 || uvcb_init.header.rc == 0x105),
 	       "storage origin invalid");
 	uvcb_init.stor_origin = mem;
 
-	uvcb_init.stor_origin = get_max_ram_size() - 8;
-	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x105,
-	       "storage + length invalid");
-	uvcb_init.stor_origin = mem;
+	if (uvcb_init.stor_len >= HPAGE_SIZE) {
+		uvcb_init.stor_origin = get_max_ram_size() - HPAGE_SIZE;
+		rc = uv_call(0, (uint64_t)&uvcb_init);
+		report(rc == 1 && uvcb_init.header.rc == 0x105,
+		       "storage + length invalid");
+		uvcb_init.stor_origin = mem;
+	} else {
+		report_skip("storage + length invalid, stor_len < HPAGE_SIZE");
+	}
 
 	uvcb_init.stor_origin = 1UL << 30;
 	rc = uv_call(0, (uint64_t)&uvcb_init);
-- 
2.34.1

