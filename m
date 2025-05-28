Return-Path: <kvm+bounces-47861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE02AC6579
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E7773A86F1
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF062750FB;
	Wed, 28 May 2025 09:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jI6NMTXa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231212750ED;
	Wed, 28 May 2025 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423700; cv=none; b=AiaSuuUOyEuzRrIRfgcKsZ+5vsculXon/BPCsIPYSZGeGJYgaPNPnzut59n/xwH2hRkG5zf98CIafJK+7Y0+1dxwI68fgX8+bkT/eHHaQbRx8IowaBoMujdG7sAJyQnovJxxbSovdl7O82gEbTUvmxeJCjyGJMq4X8GmxpXhBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423700; c=relaxed/simple;
	bh=Uomc4IpoLoW1FTWjVKwfNUz2/qNymFeJ2lQpSZEcklc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbbnQ4seEoETNAoSJaAzjeHxSiWCGMVFwCOIRfdE+rg69GeV6ddnngTIbw+S114OKl1HQOO5no6pV0XMmv5b0sMrS8f9flUxQlhfCNgDi1QkWh9a/XBSaN9u2aIu5N0KTISw996ii2moOO8zfS4k0n016s9OVNvjhFv3BUDioys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jI6NMTXa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S2CAJS017195;
	Wed, 28 May 2025 09:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=D6QeAt5OvXJRsvmA8
	scbiN3dfQsetPcARGUkZIvtbOU=; b=jI6NMTXak2YUsS8Vta329r+WVz9eVQ1tt
	/McCVxoXN2FJe5JYFVq0MCoHlygfZs6Mj8D3VaCsQ+MTpU9kf92YHVez0NYi5bIf
	o87fQAL7034oyP1vvzCw6pZIcp4LOFDeSHr1D+9CFmIUPCdsjMY3NOVKoM5qRo2d
	ycgmp9ZIqs+qCD9DS736nORYdoLzpYgzZ3Bu4QRBfnESp5BsVcxt3LQ7+iFQL7i3
	n5W7AgEEj62jRyznG9lsAylDIR/FIN5OPIB7EH9G4F56q1MnabwyaT6wBCDHuL9r
	lkJQ/VnDI1avhnwBfOgLzKAdDTgn1HVK1A1N+rfifbCYSozdwkxAA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wgsgkvbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6CVTu021333;
	Wed, 28 May 2025 09:14:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46utnmpky7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9EoY845810084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:14:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1322120040;
	Wed, 28 May 2025 09:14:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C910420043;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/2] s390x: diag10: Check page clear
Date: Wed, 28 May 2025 09:13:50 +0000
Message-ID: <20250528091412.19483-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250528091412.19483-1-frankja@linux.ibm.com>
References: <20250528091412.19483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2p5-rgYA2GPCDPnFs6WWmpfFjD9Og0Ad
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA3OCBTYWx0ZWRfX/xtlbBLXcs5C EBeMLq/JD166c28G3Q2M+RT3sRF0pR7mhnZwJx6Thw4TDxyE7i5H0UAXDxq2fduRItPoHkka2iu uz6pMoZpNlZvTrMHAps89TLvPooZTq4SnhCWpS+3urXjGTIKO4F2ZqcApSbxqfOr9eeusKppZRH
 MhvyvtLNRxjbY3noBEuOFwQBSQ6vCzqgkSC6zSMS88SyhBYe2avpKG2B5dae4smoVmdNvxHx1Yr QZAGGR7cg9kqCXL+k1q7MRD557cMn6be/pFO7lpXHcW2Iomv8wVpl+7j9JdA1UQIqBO69WhEU4H mj+PB1QKGwH3j/bPLeh5UZO6F0xs3sX3G34G12I+uE29j4Lxta7IahL4RWwKZSjtqcXaCijm6zg
 il+EwHsl0031U6P+Ec94aFhfhyz1rLB5WstrKxX6aBRad9HDt+RRehrTspM0S/Czvyim5+WR
X-Authority-Analysis: v=2.4 cv=bZRrUPPB c=1 sm=1 tr=0 ts=6836d40e cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=hFFYQovYn3O7A-klem4A:9
X-Proofpoint-GUID: 2p5-rgYA2GPCDPnFs6WWmpfFjD9Og0Ad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_04,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=956 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280078

We should get a new page after we discarded the page.
So let's check for that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/diag10.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/s390x/diag10.c b/s390x/diag10.c
index 00725f58..b68481ad 100644
--- a/s390x/diag10.c
+++ b/s390x/diag10.c
@@ -94,6 +94,16 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_content(void)
+{
+	report_prefix_push("content");
+	memset((void *)page0, 0x42, PAGE_SIZE);
+	memset((void *)page1, 0, PAGE_SIZE);
+	diag10(page0, page0);
+	report(!memcmp((void *)page0, (void *)page1, PAGE_SIZE), "Page cleared");
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("diag10");
@@ -110,6 +120,7 @@ int main(void)
 	test_prefix();
 	test_params();
 	test_priv();
+	test_content();
 
 out:
 	report_prefix_pop();
-- 
2.48.1


