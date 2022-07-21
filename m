Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4969757CCD9
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiGUOHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiGUOHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4164330A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:17 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDVpn2013300
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xtUj/fSdZJN6kXYHprBjGIoGQzDX+i/mGlqM70Lm2AY=;
 b=di6Po1lfju6COJ5Ojrh7odtvhsUVM9TwS12GTeKVS6nOzWYdPJm23QFmZZGbRzhcFXsP
 1dwPyzishQF3h1OZoCSUyKtd0ZrW04SJUBFb76owOaEzagazF9Ur4HB2xjRkeMrD0nOZ
 VCroCNaCYoKZ5RLON+y5XFwJeZhi1DS6Plfjp07P5CbGBSNq1PoO8b9qkL/0b+/hvl/A
 tiLyPP7vcnvihtxExMjRzU7e6fff8weBYT+H3W1+/cd1yF58zYwxYkNMe2nM00q8D1Nm
 VR2VK4Xm2YTf1VwpLEu7w+Y9OyXk/envHM13Cfjp7yedZ5xIhGX4gyj+HMS+0WfrN/fz Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7ry946a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE5roa005511
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7ry93y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE5TBa022417;
        Thu, 21 Jul 2022 14:07:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nbw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE74J024248830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79C5F4C040;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B33E4C052;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/12] s390x/intercept: Test invalid prefix argument to SET PREFIX
Date:   Thu, 21 Jul 2022 16:06:56 +0200
Message-Id: <20220721140701.146135-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ix4dLBfn-JpDu5GpKgwqMEvA3Kj1CnyX
X-Proofpoint-ORIG-GUID: BBlFyIjwrT_3jNEzUca_KYv9wtHX505-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=655
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

According to the architecture, SET PREFIX must try to access the new
prefix area and recognize an addressing exception if the area is not
accessible.
Test that the exception occurs when we try to set a prefix higher
than the available memory.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Message-Id: <20220627152412.2243255-1-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/intercept.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 86e57e11..54bed5a4 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -74,6 +74,22 @@ static void test_spx(void)
 	expect_pgm_int();
 	asm volatile(" spx 0(%0) " : : "r"(-8L));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+
+	new_prefix = get_ram_size() & 0x7fffe000;
+	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
+		expect_pgm_int();
+		asm volatile("spx	%0 " : : "Q"(new_prefix));
+		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+
+		/*
+		 * Cannot test inaccessibility of the second page the same way.
+		 * If we try to use the last page as first half of the prefix
+		 * area and our ram size is a multiple of 8k, after SPX aligns
+		 * the address to 8k we have a completely accessible area.
+		 */
+	} else {
+		report_skip("inaccessible prefix area");
+	}
 }
 
 /* Test the STORE CPU ADDRESS instruction */
-- 
2.36.1

