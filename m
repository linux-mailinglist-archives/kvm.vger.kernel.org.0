Return-Path: <kvm+bounces-37105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA7AA25487
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A266C3A4338
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC972066CB;
	Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ctipK6gk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B8A1FBCB9
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571806; cv=none; b=gPEn3sZBkfm54FPNGDSOYTFgpEpIsJfXSwwJuk65S42P3nT7PPSSzbGtlXut+rCG1MjGV+XgWf/Vl4h/pbu247llm89MonjAofDRphGSm0t7/J1u2zABv9YM5MuhUOwFfY+7p+t1d53YWaCYwIppNEtvJVvCAW4TcGGgLGIj81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571806; c=relaxed/simple;
	bh=UmmOtYnzoF8C0aZ+rRGIlDsrLjunYFJVD933xdA182E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5XkNHJfyqxYmcfFchkFPIS/Lucas4B4OV73wJ7gH9Y0HSeCG/OeHFYBGULTslqIjASs1jBETZHpSoMmJFfNXdKLpfpl2t8JA4WLaSHZ8O619y71SvZCV+sFq5E9HFvGCwXtXwFut9UVjJrMQo610GwkRNE5UHfHv6VVQDOC7B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ctipK6gk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512KvPYm001517;
	Mon, 3 Feb 2025 08:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NiHKEOX31EOziF5kX
	DU/F1o/6D+KCLVyKKGfDazAuMw=; b=ctipK6gk13GEfjNG9lquIxiOHrbkcbylo
	CtTy/C16kBN62CJl9t/48RBGEWBBGjNoxmBzsf4T2Muj1dZt2H1peMMNAEcDe1pO
	0VNFS3eyxKmgdZwMH3C2Gvpt6Gv9HqspzhXwbJU58A5C5X0/XXfCxrevzfSRe0gA
	Op/yWdBxkZ9AhVUi0FntZdK0zt/enug3L86anRYfVk34fhPfXwQagVj/iukUJQSK
	QpAz3vyNaOPI3w4t7Y2vNAXWbHvCTUCeEILTOvHaOsgjqtBmsHb87HOlF4A1HELz
	Nv4CICaL9Vq3LVMXTwKmSanFt853NJiyvu7IXEtN1On2kl2PbYM/A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jayyba03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137xAAJ024506;
	Mon, 3 Feb 2025 08:36:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxmwe3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aP8231130264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 485B820040;
	Mon,  3 Feb 2025 08:36:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9DFF20043;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 02/18] s390x: edat: test 2G large page spanning end of memory
Date: Mon,  3 Feb 2025 09:35:10 +0100
Message-ID: <20250203083606.22864-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AopRkxTo31UmMTsmhC0bgr9pPDPIRCJq
X-Proofpoint-ORIG-GUID: AopRkxTo31UmMTsmhC0bgr9pPDPIRCJq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Create a region 3 table with fc=1 (i.e. a 2G large page) mapping across the
end of memory.

Check that the part of the large page before the end of memory is accessible,
and the part that is after the end of memory is not.

Also fix a typo in the existing edat2 test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20241001113640.55210-1-imbrenda@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/edat.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397..1f582efc 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -196,6 +196,8 @@ static void test_edat1(void)
 
 static void test_edat2(void)
 {
+	uint64_t mem_end, i;
+
 	report_prefix_push("edat2");
 	p[0] = 42;
 
@@ -206,7 +208,21 @@ static void test_edat2(void)
 	/* Prefixing should not work with huge pages, just like large pages */
 	report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
 		!memcmp(prefix_buf, VIRT(0), LC_SIZE),
-		"pmd, large, prefixing");
+		"pud, large, prefixing");
+
+	mem_end = get_ram_size();
+	if (mem_end >= BIT_ULL(REGION3_SHIFT)) {
+		report_skip("pud spanning end of memory");
+	} else {
+		for (i = 0; i < mem_end; i += PAGE_SIZE)
+			READ_ONCE(*(uint64_t *)VIRT(i));
+		for (i = mem_end; i < BIT_ULL(REGION3_SHIFT); i += PAGE_SIZE) {
+			expect_pgm_int();
+			READ_ONCE(*(uint64_t *)VIRT(i));
+			assert(clear_pgm_int() == PGM_INT_CODE_ADDRESSING);
+		}
+		report_pass("pud spanning end of memory");
+	}
 
 	report_prefix_pop();
 }
-- 
2.47.1


