Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981206BEA20
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCQNdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCQNdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:33:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6773947435;
        Fri, 17 Mar 2023 06:33:13 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HDPNxt017253;
        Fri, 17 Mar 2023 13:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g1uDzORVihRrg80JZcD9GYi6ha/b8gegNdsGFH8c+dw=;
 b=jpuJKrrb6JD3pNbBw18np6kkqif/LSGzc0hchXJwaPNPvixCGk1fKEW+zZ5Quiuw8Tmj
 fs1qnP+YOzZqLcyGRAHgVxAERDCMhST6ArKSMjS+9bPYR3NbGsfRVsSSRrKISlcuTv17
 3X/cRgsY7q3bkIvVds3UTn/UIsCcXM23opT2oYD4IsNnBo81ZzpEzEh80EEW1Z52/WwA
 C7dWGef8kZoHcFytn0sEz2ETBN7VGjWfRtftHqEjEvrPdT5eQpnv5Gsz0MbrKGE7FZrD
 0q6cn0YrsgatIXFPAAMS39/TyS1cvveLYr0g8XH7W0g/mcy1C/TxwXn0X5tkcjUw7tim lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcs2q86h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HDT5Ku030015;
        Fri, 17 Mar 2023 13:33:12 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcs2q86g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:12 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HCYGxE023983;
        Fri, 17 Mar 2023 13:33:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pbsmbhtvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HDX6eV30278218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 13:33:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8471420040;
        Fri, 17 Mar 2023 13:33:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C3D320043;
        Fri, 17 Mar 2023 13:33:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 13:33:06 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/3] s390x/spec_ex: Add test of EXECUTE with odd target address
Date:   Fri, 17 Mar 2023 14:32:53 +0100
Message-Id: <20230317133253.965010-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317133253.965010-1-nsg@linux.ibm.com>
References: <20230317133253.965010-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jYwWtLBGQs65KfG4wpScdJlrEjHlKex2
X-Proofpoint-GUID: bF6GB0fjH8jHlNnp2XTwdn3hHx8vFJMy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_08,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The EXECUTE instruction executes the instruction at the given target
address. This address must be halfword aligned, otherwise a
specification exception occurs.
Add a test for this.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index ab023347..b4b9095f 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
 	return 0;
 }
 
+static int odd_ex_target(void)
+{
+	uint64_t pre_target_addr;
+	int to = 0, from = 0x0dd;
+
+	asm volatile ( ".pushsection .text.ex_odd\n"
+		"	.balign	2\n"
+		"pre_odd_ex_target:\n"
+		"	. = . + 1\n"
+		"	lr	%[to],%[from]\n"
+		"	.popsection\n"
+
+		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
+		"	ex	0,1(%[pre_target_addr])\n"
+		: [pre_target_addr] "=&a" (pre_target_addr),
+		  [to] "+d" (to)
+		: [from] "d" (from)
+	);
+
+	assert((pre_target_addr + 1) & 1);
+	report(to != from, "did not perform ex with odd target");
+	return 0;
+}
+
 static int bad_alignment(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
@@ -218,6 +242,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
 	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
+	{ "odd_ex_target", &odd_ex_target, true, NULL },
 	{ "bad_alignment", &bad_alignment, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
-- 
2.39.1

