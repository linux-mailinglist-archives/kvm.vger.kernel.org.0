Return-Path: <kvm+bounces-86-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D787DBD6F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 643F81C20ADF
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB2819BA0;
	Mon, 30 Oct 2023 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iwQo7vSC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4DD18C3D
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:08 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454CAC5;
	Mon, 30 Oct 2023 09:04:06 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFsajb027120;
	Mon, 30 Oct 2023 16:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=E+9VC00axoKNcG+/46kpAZAMqqi6XIuvh2+2SCG58rY=;
 b=iwQo7vSCdB5LNH9pcDFwc3Pkn8ko1en+iWZeQfCJan6xuk9GbtYnYCZvrAvSRWmVbqpt
 l57crtKfAQ+vxSvmRB9rlquPKee41HMioPJjmW/gYQm+qSlCrRQg0EhTpeIXVxFqSDqU
 bCVXw1yy0Y8sz6e81Y5suwNsxsWpEIvFE+jzzXSWuawcFzqjMzJKHr1/LRxwwWuQVFJD
 QQyq/s8+nbFE0CoOARJbP3cFRd8TGYeuh3UADXzdVMuObqpI35WMhF8I9GaZoIV6YLNJ
 +N4IPO8JWRFVn3gP+OPr/O4Vf//36TywWOyZOcpb77sbm5sRDYShcSZrEFuZm51cWrzh kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fhqgctd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:57 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFsvv1028141;
	Mon, 30 Oct 2023 16:03:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fhqgcsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDYTlH031388;
	Mon, 30 Oct 2023 16:03:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1fb1skwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3rIP24642148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3143620040;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 073DB2004D;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:52 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Colton Lewis <coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v3 06/10] s390x: topology: Refine stsi header test
Date: Mon, 30 Oct 2023 17:03:45 +0100
Message-Id: <20231030160349.458764-7-nsg@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 2ez_5syqyMdzBNriN1VIFOyu7vMYKXkE
X-Proofpoint-GUID: YRVjrMwpNqFJ2Vo_HgiedNpOrDrdYrBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

Add checks for length field.
Also minor refactor.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 03bc3d3b..6a5f100e 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -187,18 +187,23 @@ static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
 }
 
 /*
- * stsi_check_mag
+ * stsi_check_header
  * @info: Pointer to the stsi information
+ * @sel2: stsi selector 2 value
  *
  * MAG field should match the architecture defined containers
  * when MNEST as returned by SCLP matches MNEST of the SYSIB.
  */
-static void stsi_check_mag(struct sysinfo_15_1_x *info)
+static void stsi_check_header(struct sysinfo_15_1_x *info, int sel2)
 {
 	int i;
 
-	report_prefix_push("MAG");
+	report_prefix_push("Header");
 
+	/* Header is 16 bytes, each TLE 8 or 16, therefore alignment must be 8 at least */
+	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->length);
+	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length);
+	report(sel2 == info->mnest, "Valid mnest");
 	stsi_check_maxcpus(info);
 
 	/*
@@ -328,7 +333,6 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-		report(sel2 == info->mnest, "Valid mnest");
 	} else {
 		report(ret, "Invalid instruction");
 	}
@@ -367,7 +371,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
 		goto vertical;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 
 vertical:
@@ -380,7 +384,7 @@ vertical:
 		goto end;
 	}
 
-	stsi_check_mag(info);
+	stsi_check_header(info, sel2);
 	stsi_check_tle_coherency(info);
 	report_prefix_pop();
 
-- 
2.41.0


