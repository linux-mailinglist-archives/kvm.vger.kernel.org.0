Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6755CD28
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiF0PYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiF0PYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:24:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E218371;
        Mon, 27 Jun 2022 08:24:20 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RFERGI004251;
        Mon, 27 Jun 2022 15:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=EQjW0gU0Q/3PbhYeyUAfp156cLyZ43HMqk/twIUrBDs=;
 b=nsWiAPlmsJ2NSCrq4IlsPfWntLv4NwbuNm8DpSeNuf1c4mTtB/3Y69n7Ty/aXu5QzTGG
 +GKxrkHS4dPcE2o5CeSY7tEUBe9rTXN+y5flD8zLcxCNBdN7zFQsSPvkaC7sha5bIiPz
 MgoP6PcIXsGdKAyHFwRmc+jQqpVlda+cKfKY3iWrqT8G00IhcHRN2rIHBhxDNjxdt7o2
 I/M6ZM4Wt2Yys7SC8+RUiZ9Hu040+KhP/ywpPInTIn0oUPuv7061mDXEPAzkh1L3mB0q
 n5Ap/7aiKrEG3h2BfPS3VoZyGbdqWCncfCF+iSaCDBkL7/jSr2Th7uOs0i7XGT0ZxWGh uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyf0v8aeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 15:24:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RFI8eo022124;
        Mon, 27 Jun 2022 15:24:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyf0v8acv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 15:24:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RF5heG011361;
        Mon, 27 Jun 2022 15:24:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3gwt08tdcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 15:24:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RFOD6s19071356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 15:24:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A041952051;
        Mon, 27 Jun 2022 15:24:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5E09B5204F;
        Mon, 27 Jun 2022 15:24:13 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2] s390x/intercept: Test invalid prefix argument to SET PREFIX
Date:   Mon, 27 Jun 2022 17:24:11 +0200
Message-Id: <20220627152412.2243255-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FsbYJtmqrYtNca-0p2ElCOoszOmvvDI9
X-Proofpoint-GUID: jwfiNOfR9dw3DRX8U9KgxNSWZFIpDH03
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxlogscore=936 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the architecture, SET PREFIX must try to access the new
prefix area and recognize an addressing exception if the area is not
accessible.
Test that the exception occurs when we try to set a prefix higher
than the available memory.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---

v1 -> v2
 * report skip if we're running with too much memory (thanks Claudio)


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

base-commit: 110c69492b53f0070e1bbce986fb635e72a423b4
-- 
2.36.1

