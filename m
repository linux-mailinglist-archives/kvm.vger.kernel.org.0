Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2167A6D5F34
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbjDDLhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbjDDLhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C0430ED
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:37:01 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349v9Vu016331;
        Tue, 4 Apr 2023 11:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=cE6HLqwLSiWBQJdBjSZwLHdImuDnpP1zSM+T7zCcHIs=;
 b=V8ul6QPgQMvwVEZIY0rt95Swhq5nM47xAWvgr09ilGl7gzneKHGIzo2cEmdkZI3HXywP
 xxqxK9pvYoFQsVdQdOx9SGtWkSksWLPJX8l2KVw+4aGObICF3vJkbPNQoEFYuZBl4fWF
 nzNyyUUQpf98RtrEyRxlqUsFLRZWWE/2qdKUjMyHurSZiVYxXi/GzqCG2q7DS0s3ghbf
 zZZaLeCKT7re2KelG7efIqM7PhMDknbgmuc3jdUoDvzMmI7WXqpYgsABC9l4mRABCazl
 dkbTLEbIkDjkDN+3XJkTlnZNQ0597u/+btBpbN0bY8gpYKh6dO0o9EeI/Fwr8N5fxIa7 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhqd2aw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334AufXC003773;
        Tue, 4 Apr 2023 11:36:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhqd2avg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3344tA87024527;
        Tue, 4 Apr 2023 11:36:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfsvdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Bapps18022660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4492A2004B;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC49720043;
        Tue,  4 Apr 2023 11:36:50 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 12/14] s390x: spec_ex: Add test for misaligned load
Date:   Tue,  4 Apr 2023 13:36:37 +0200
Message-Id: <20230404113639.37544-13-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H5GZvTGh6juXuTDn_-AcMTTDgmSCJlR3
X-Proofpoint-GUID: FTKnzCYKH7pxbob09c3jUftydeVGZmSq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
specification exception occurs. Test that this exception occurs.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230301132638.3336040-1-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index e5f7b12..e3dd85d 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -201,7 +201,7 @@ static int odd_ex_target(void)
 	return 0;
 }
 
-static int bad_alignment(void)
+static int bad_alignment_lqp(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
 	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
@@ -214,6 +214,22 @@ static int bad_alignment(void)
 	return 0;
 }
 
+static int bad_alignment_lrl(void)
+{
+	uint64_t r;
+
+	asm volatile ( ".pushsection .rodata\n"
+		"	.balign	4\n"
+		"	. = . + 2\n"
+		"0:	.fill	4\n"
+		"	.popsection\n"
+
+		"	lrl	%0,0b\n"
+		: "=d" (r)
+	);
+	return 0;
+}
+
 static int not_even(void)
 {
 	uint64_t quad[2] __attribute__((aligned(16))) = {0};
@@ -243,7 +259,8 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
 	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
 	{ "odd_ex_target", &odd_ex_target, true, NULL },
-	{ "bad_alignment", &bad_alignment, true, NULL },
+	{ "bad_alignment_lqp", &bad_alignment_lqp, true, NULL },
+	{ "bad_alignment_lrl", &bad_alignment_lrl, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
 };
-- 
2.39.2

