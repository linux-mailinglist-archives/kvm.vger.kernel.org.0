Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51BE600B16
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJQJkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJQJkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E5527B33
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9IcTh016700
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s7d7sGUhnwF+2T+jt/uLF7I3cSXcl6VLh/PLw43aufU=;
 b=Zfa1JJ0nPWVoFZ7/113bjhtu+r5lIwTo+7M7+p0i7PGe0a2lVMoVKqzw7tQLD7ASyHUI
 BejsDeNa2X3kCD3GXReuCb0+MK+4LiB/YMjvdDK7pHAZryXv95UF6WBX5sPaROZ0BEr7
 GIooqbNkdPA9Du9baOtiao8ejY3rTv6Iho9u3G1EEkbMxm7n0OGCaLgV6fy8GUlRJWbi
 smyJwBerUErbb3zYH/1enQkxuk6TciOApvyXJs/0b38JX846AsOfx4cRp6pxlkia7BIb
 +N0XNaNEq/IrSSpg15H3JqNS9arelCCHVb+/M/3PNxpyKYJq8IpY+PG4xZcQkfHu7aPf 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86hkb1nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H85S89022773
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86hkb1mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9b0ML012572;
        Mon, 17 Oct 2022 09:40:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3k7m4jjrck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9dxXv5767816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380B6A405B;
        Mon, 17 Oct 2022 09:39:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89A34A4054;
        Mon, 17 Oct 2022 09:39:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 8/8] s390x: uv-host: Fix init storage origin and length check
Date:   Mon, 17 Oct 2022 09:39:25 +0000
Message-Id: <20221017093925.2038-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2a42SMws321d26oZlc8FWsIRGWVovAAW
X-Proofpoint-ORIG-GUID: PtkT7tPeDN7aLaQVufn72ytEYDGJ2zz1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=979 impostorscore=0 bulkscore=0 malwarescore=0
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

The origin and length are masked with the HPAGE_MASK and PAGE_MASK
respectively so adding a few bytes doesn't matter at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a33389b9..191e8b3f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -524,17 +524,22 @@ static void test_init(void)
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

