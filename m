Return-Path: <kvm+bounces-82-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04CB7DBD6C
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8357428168A
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0219199BB;
	Mon, 30 Oct 2023 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hsmvXosg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFD618E04
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:08 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D43DD;
	Mon, 30 Oct 2023 09:04:06 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFsje9027130;
	Mon, 30 Oct 2023 16:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dttwXisVRQW6VzItWqEiNWuRVXRaQhE+f7ItKyxseDU=;
 b=hsmvXosgaffIl01boZb3QS+bIsRQWv9wJ71zdUY5NlMzDhLdQD2m3vV7c81gE+GJHVn8
 NOfDQ+vXGXiko+tepysrjvkZhPTmtDfbUC9bHvhWDSSje1icslVGc4/VZzMh7wgD6WnQ
 AWOUGBwOvbYNY0N4rmdEo9Xq9VN7X7Mq/58wPVBhLvd/T6VWkEmHmRSnfAKK/b2Pr9x6
 2fgVE1/CKycSAxl8qrK2Z6LOM9PBh6bIdjfPqQA2hfVu6Pey0HuPXESMZOmEaKdiDtXZ
 2F0tNUHs+1D9z56WYeUUkRqXfU4Ui6bA2IPhd6yQvtBfeTGoKZTdX/+eVcPhEykpR4Qu jA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fht0cr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFsxnd027846;
	Mon, 30 Oct 2023 16:03:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fht0cps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:57 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UEVgYL007674;
	Mon, 30 Oct 2023 16:03:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmna5gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3rBg24642146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB07C2004B;
	Mon, 30 Oct 2023 16:03:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0E3C20043;
	Mon, 30 Oct 2023 16:03:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:52 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v3 05/10] s390x: topology: Make some report messages unique
Date: Mon, 30 Oct 2023 17:03:44 +0100
Message-Id: <20231030160349.458764-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9Aqcgq_6NE88gcQ8Es__UfAk7ReIeKfK
X-Proofpoint-ORIG-GUID: wEsXic5iP6qGy89CdqpgSMe8zN_L4v10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

When we test something, i.e. do a report() we want unique messages,
otherwise, from the test output, it will appear as if the same test was
run multiple times, possible with different PASS/FAIL values.

Convert some reports that don't actually test anything topology specific
into asserts.
Refine the report message for others.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index c8ad4bcb..03bc3d3b 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -114,7 +114,7 @@ static void check_polarization_change(void)
 	report_prefix_push("Polarization change");
 
 	/* We expect a clean state through reset */
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	/*
 	 * Set vertical polarization to verify that RESET sets
@@ -123,7 +123,7 @@ static void check_polarization_change(void)
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 0, "Set vertical polarization.");
 
-	report(diag308_load_reset(1), "load normal reset done");
+	assert(diag308_load_reset(1));
 
 	cc = ptf(PTF_CHECK, &rc);
 	report(cc == 0, "Reset should clear topology report");
@@ -137,25 +137,25 @@ static void check_polarization_change(void)
 	report(cc == 0, "Change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should report");
+	report(cc == 1, "Should report change after horizontal -> vertical");
 
 	cc = ptf(PTF_REQ_VERTICAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to vertical");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after vertical -> vertical");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 0, "Change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 1, "Should Report");
+	report(cc == 1, "Should report change after vertical -> horizontal");
 
 	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
 	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED, "Double change to horizontal");
 
 	cc = ptf(PTF_CHECK, &rc);
-	report(cc == 0, "Should not report");
+	report(cc == 0, "Should not report change after horizontal -> horizontal");
 
 	report_prefix_pop();
 }
-- 
2.41.0


