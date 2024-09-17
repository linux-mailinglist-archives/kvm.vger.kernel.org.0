Return-Path: <kvm+bounces-27053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E16997B232
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 17:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC50928423C
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 15:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876F61922D7;
	Tue, 17 Sep 2024 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fEcnB77u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBEE191499;
	Tue, 17 Sep 2024 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726587379; cv=none; b=tyUF4i/YEsjZcp0oZh0dHxRSgrH1nM7Vf52+Fw+YKWNMzgrrAfdjumquQNM6IVH/uU9HHw8AnQ2uyuiKODfPj0J8a3mn0nrPqKl2vpsF/yl/lrH/NUmoK5tnB11/ux674I7o1SdCD4k6Ut54PVyHr0zCpZ4hrIvIDxa+2MEJtUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726587379; c=relaxed/simple;
	bh=rxW//vZuGAtRNEViNAKLqp7B9+PIct2Ye3bIRW3KtBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE6yIKwmgXt+SuMP+0yv7g85qBIFbPrdJsXTaeuqefuapmEDn1vo2F6k10vaOmQz5u3bMqMBtjaqlibVthG74KLTg91SlIrcFBi/B6rtW0HGdCrWkPnY2bIChfERYrCQEdgdXHFiuFwKHf16/Oip2MBa3EfGocpT5VxKHSUEIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fEcnB77u; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48H91Zfh007556;
	Tue, 17 Sep 2024 15:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=yImlsXhEsP3lG
	TJl5ARInyjsvaodNKhdiL6Cf81Ht/c=; b=fEcnB77u6ZkJAIfvyyYGi9uJJdEGS
	vAJ3VNr/RK9V+wjOom1Jxd09j96nJLCvEWCAyxiG5xP4dGxQUptZBhw8wbGhR7N9
	BoS1pBO9F9gl9W4MBTFGDpqgjwjlJ1SiTNoeazC/L6ITeTOI/5/BH6KTf6grRnTf
	eco3eeCOMzX4jjmYarV2a9AF0SMK0T+sr0BJXQYbrYk4s5XBFTgUbknXehN1AsyQ
	ly/ciDXTouy9tK+56FcKgJVYQCO37L7js2lLSb/unEMmxZMmRK1qRboF6rFbXemc
	BwZP1GCFRLTfxZvZQKpPbz2Um3xrXqJ92mtzHbHngUwKXAiKdc5gXW4lA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vdh3bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:17 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48HFaGco032225;
	Tue, 17 Sep 2024 15:36:16 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vdh3bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HDAKrA030631;
	Tue, 17 Sep 2024 15:36:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41npan5w4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:36:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HFaBFQ45941104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 15:36:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C96CC20043;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4D132004F;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Sep 2024 15:36:11 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: edat: move LC_SIZE to arch_def.h
Date: Tue, 17 Sep 2024 17:35:35 +0200
Message-ID: <20240917153611.138883-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240917153611.138883-1-nrb@linux.ibm.com>
References: <20240917153611.138883-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fyXveThNwlMc2HKrpeElCmLswRy7aMjq
X-Proofpoint-GUID: EWmUKRDafvar109Xd1wz2N8ljNeyldpC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_07,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409170110

struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
tests as well, therefore move it to arch_def.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 1 +
 s390x/edat.c             | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a33878de5..5574a45156a9 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -119,6 +119,7 @@ enum address_space {
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
 
+#define LC_SIZE	(2 * PAGE_SIZE)
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397017c..e664b09d9633 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -17,7 +17,6 @@
 
 #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
 
-#define LC_SIZE	(2 * PAGE_SIZE)
 #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
 
 static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
-- 
2.46.0


