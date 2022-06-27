Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7055C80F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiF0MoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 08:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiF0MoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 08:44:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FC3D118;
        Mon, 27 Jun 2022 05:44:05 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RBjcq8017827;
        Mon, 27 Jun 2022 12:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AaYn+r+7i+BYnxtyG3yJWwXLlt3Fia5+dyVzey0V21A=;
 b=Xtw+/rtBW2kez2DQpdthPwTe58oVX1l5NSilKRvL/kWsft8xyV2izjFwZWNMTTAjs+Rv
 rObl/9A3K7QWsm4lpX+XmYjLm9GxQEEHE/Xuqswm0BaknhXBOp5V13XkCmK/uR/DpGpK
 63gDcx5gHgxtUG+9chsniqKNS/Y70w+NxrM1tsAyTOm3E6yF3ZXG8fPPj8gk0q0HPbDK
 9Sz92Er6XIMqqzjObGd01hSmTcP7wWKhKABo7kSVtW+ZWhASUo7dKrspkNWgH1MvAHbh
 4ugboGVH0OZBX3Uxt8zUhRkbW98IrPGFlOxQNm+L8SpLPlsfNnvAimYA+gvL7WghVj7i CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyby7hkqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:44:05 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RCgZhX005527;
        Mon, 27 Jun 2022 12:44:04 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyby7hkpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:44:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RCZutc018320;
        Mon, 27 Jun 2022 12:44:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt092880-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 12:44:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RCh26k23069046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 12:43:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8486A405B;
        Mon, 27 Jun 2022 12:43:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FEBEA4054;
        Mon, 27 Jun 2022 12:43:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 12:43:59 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] s390x/intercept: Test invalid prefix argument to SET PREFIX
Date:   Mon, 27 Jun 2022 14:43:56 +0200
Message-Id: <20220627124356.2033539-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dz9bCvhLz3R8ELVITQj1CSg1J_I_g5Dn
X-Proofpoint-ORIG-GUID: 6FxL4z_5aINJ4ljXoUV1IY5YFhJX9GkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=898 impostorscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270055
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
 s390x/intercept.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 86e57e11..0b90e588 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -74,6 +74,20 @@ static void test_spx(void)
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
+	}
 }
 
 /* Test the STORE CPU ADDRESS instruction */

base-commit: 110c69492b53f0070e1bbce986fb635e72a423b4
-- 
2.36.1

