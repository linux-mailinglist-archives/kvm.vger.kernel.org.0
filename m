Return-Path: <kvm+bounces-46798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C97CFAB9C5E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAD6718989E1
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AF92417E0;
	Fri, 16 May 2025 12:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aQbwLBBd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C48239E69;
	Fri, 16 May 2025 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399252; cv=none; b=sfEBUmD5vrUIIOpLrW9724oO5LZUK6/MiqCWDrcHSyhQOJAD1/1EpCJ1Onx/ajPAeTKnzzhWqdAA5+GAx2cjXNHHjS3o/p+2OuWuK4TDJv59Vh+7YEWdu52DPDVRyLm5ne5IOoA/OoI58exjHp1/XMmkqx9+GwIRF7qqc6i3qM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399252; c=relaxed/simple;
	bh=En/Vw9wTnrV0iiGoqqr5ARsm07NVhMnseucljR4/vtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EhrOnfwRqrtQbcEkR9vitsSGFaFAPAYh2Bz3+kZCUVA45nkFY/7qiZGHfFN8ssvjj3lBmxfYmEeRpq148Eo6MFBfapv5SOz3IDo4IltoFhoYb+iQt2DAIEy0VkU4GC8gu7JET/3q8FfEqCCg1RzjYWHcUxdPiohJJYFKfCUC9Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aQbwLBBd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G5unPW012663;
	Fri, 16 May 2025 12:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=gjvxHPL1janfCdvLnHMKKrb2pt2ZDhhBF4Dw2m5P8
	08=; b=aQbwLBBdvoLAyQApqMLM5JpkZUAjMxnRbYFqFVX4sWinkw/LvZkSGc1Q4
	QK6YyQr132zU/eNgp1owWpQN20bL3a+MMSPBAfddTpu+Zi21qX0icwIMWheQ3wPP
	vfMCEVzAPGoJw+qOoLQ/L1R03soUa+xT/42GD8f+oqk2KRcDe8224M2PQTbWd/yd
	J8r+Uj6L2Bg23bLJi+U3j9mdM5WezY9xdTFVElmbXWVjiH21FoCDDX6hsYkxqMWi
	lMrRsqJ2IvpTGZRu7KNl52yIu7sYnK61Pl7DwYKtPTppYrkBwKoZz4bFfqb/MWzT
	7pMnRahrGckA9Xhvg+sOJa0+QU5rA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46nnw943sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 12:40:36 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54GCFiIg024904;
	Fri, 16 May 2025 12:40:35 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46nnw943st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 12:40:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54GA5Iwk024273;
	Fri, 16 May 2025 12:40:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfsfgjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 12:40:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54GCeTgU46203192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 12:40:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F25A20166;
	Fri, 16 May 2025 12:12:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10B312015F;
	Fri, 16 May 2025 12:12:30 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.39.30.87])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 May 2025 12:12:29 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S HV: Add H_VIRT mapping for tracing exits
Date: Fri, 16 May 2025 17:42:24 +0530
Message-ID: <20250516121225.276466-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDEyMSBTYWx0ZWRfX6Fsbe83ZOFiw s5CTWwsRlm27GUpEoBM0SEvM9NqO+gOHMvAkeDwYpHmh/I+c906Mh6aRdxiiDxYBLhu9xgN3sIy Aovr1iRe9HekIfP53wyQkk/YR4c2NPPKpoU24yLmiyvq2WPeioyJJHBLCWmqW20kGpbhNoIVGb2
 OIfu0SAiN/dkMq1/cpAXpAUhn28F7rkjNSDbXVUmXf+CrKkaH6RhSM8pQNH2QjR80ltii/O2+DH OkRDOs+uaK26gpH2CAhTyV9GyJiCQN7mycTAfLvUxkoS5zj9qOUBfopiLyQlykb352+W3z57Hxd pABWmNMTuaaH9hH2tWPIzXQpS9GBROakkMQqUWmWSOBVVgZMVHSg3MTYkjoVIDyPDaU5rFFyiug
 IlTJfTMgdDTVQEXHHwVk+4dQ3OU527lWpvHMHaN8lExjLuUoJTUzW0CcxZ8/QshXuvxWP6CN
X-Authority-Analysis: v=2.4 cv=b8Ky4sGx c=1 sm=1 tr=0 ts=68273244 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=q7Y8yhldYiaEvS2G40IA:9
X-Proofpoint-GUID: OivNb5j-I5ywfp3i_xhTq_WXGpHLiA0M
X-Proofpoint-ORIG-GUID: 7wjkZDfhubc31Ctd_5x_AnMhT8BqEQDA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 spamscore=0 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505160121

The macro kvm_trace_symbol_exit is used for providing the mappings
for the trap vectors and their names. Add mapping for H_VIRT so that
trap reason is displayed as string instead of a vector number when using
the kvm_guest_exit tracepoint.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/trace_book3s.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/trace_book3s.h b/arch/powerpc/kvm/trace_book3s.h
index 372a82fa2de3..9260ddbd557f 100644
--- a/arch/powerpc/kvm/trace_book3s.h
+++ b/arch/powerpc/kvm/trace_book3s.h
@@ -25,6 +25,7 @@
 	{0xe00, "H_DATA_STORAGE"}, \
 	{0xe20, "H_INST_STORAGE"}, \
 	{0xe40, "H_EMUL_ASSIST"}, \
+	{0xea0, "H_VIRT"}, \
 	{0xf00, "PERFMON"}, \
 	{0xf20, "ALTIVEC"}, \
 	{0xf40, "VSX"}
-- 
2.49.0


