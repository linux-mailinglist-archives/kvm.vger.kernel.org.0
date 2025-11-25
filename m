Return-Path: <kvm+bounces-64470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE509C83C67
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 08:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F113A14A0
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEF72D7803;
	Tue, 25 Nov 2025 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C7srLLBb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979E02248B9;
	Tue, 25 Nov 2025 07:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764056803; cv=none; b=ULNb3m2jrotLKWNvgGbwok3biSfHL/4kzIPn2n9iCEWtLvhjFd8BUsz2WyTV4JhP0PTHPxR8LPuukarrGtEWLys77Za+KmGssj3rHxQFCDhufq5qLKOdSkaAMeG4FhoV9VezdMVT7bzChA1c8Evao5+G8osuXQuanOcbeQzNSeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764056803; c=relaxed/simple;
	bh=mlKXJUe4V1DrGVVM+Wmaq4bBJ2m/ukvgHSJAd2SGJnw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZEBQiayKw44bajMReCTLULX6NeUFP2Hx1uQXT1erQpWFDWl6JmG26ALkKx/cDS9g1KZkb6oPeue8baIhpCFJUOPHondMpmLCuosDmumGBif2odBJFY5XBKgat1wtZsssVUpAuujvEP2XUTPMdrWI4MRiL0ybCw4knq5tl/2hAvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C7srLLBb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOKlbhs016482;
	Tue, 25 Nov 2025 07:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kjl1az
	LRE9ur0C52N2dgIeYfMTg2D3R0g39O1muXgwA=; b=C7srLLBbOOPwBL6U29pZzr
	0gSOcsa5Ax3h+dTyPLLZuyZvFiyrzIg+edklM0Ifbq8lhykSTNATxHQ7yt3xmyv7
	nR4dayXYv+yp/+Iw9n216g277FRE20yzL9IymRx9ZHVJn/A0TiEsi1oLtrYE4V2D
	/4b/Zfu6k898I6hucCgCBbszhS5pnOP0+zFzTVGXpOVG5507ZzsIvVgEtW1PEf5U
	Nkyyj88iix173kaASZHDFLs2tLF316LD4F39Dfw9czlI8Rqg0ZbWZZuyJHClEa6v
	pSvgXS31wKJmEs8f1BfEfaOC7gzEwIy/W1R4JXELHiMbTdMBGVRv+uCclNfnyX3w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w9c1kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP6IAai013866;
	Tue, 25 Nov 2025 07:46:17 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akrgn2cym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:16 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AP7kFIG18547294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 07:46:15 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF15C58056;
	Tue, 25 Nov 2025 07:46:15 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BDE758052;
	Tue, 25 Nov 2025 07:46:09 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.150.29.34])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Nov 2025 07:46:08 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Tue, 25 Nov 2025 18:45:52 +1100
Subject: [PATCH 1/3] KVM: s390: Add signal_exits counter
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-s390-kvm-xfer-to-guest-work-v1-1-091281a34611@linux.ibm.com>
References: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
In-Reply-To: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
To: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX93/PiJrgs8IA
 AaudWQWICpxTav2KBwI7EYLtFJ7/PN0ReI60Ni+P2OKGorQvcNAfnVWhRBPLQ2PSQRUSBGyib0l
 Zx2hFxBB1iF6bf7mD+V5ibsNsySsRhzoG2lYWdyujOuINzXP9ImgkynhpVRDkdhREbHJ6ym2asg
 GZq0MH9OG9evRTQiC5rrmpAPSM+vIqqJXiSH2GRL2fASIJzxLjB5l009JmFAYQA1cEjR6iflOgZ
 ChVveIa4MpAnfLmm0Rwh/sfOdiUeEKFYPy6DFNwir+I4zXpH313GBLb9pAZ8keAN3W0MqPAesTd
 uAUlF/pQ/4/u/x3alNfqcH/oV3p1eW/Jv0X16yDaO85QplHs+T+DA+3h41zsgXkpY81gQuEzmWx
 IMHXIXV4z8kWqjyCc7iUsOKKxIgPGQ==
X-Proofpoint-ORIG-GUID: wF2B8_1XnB89yi7T06xI9BN2aSoZbrKe
X-Proofpoint-GUID: wF2B8_1XnB89yi7T06xI9BN2aSoZbrKe
X-Authority-Analysis: v=2.4 cv=TMJIilla c=1 sm=1 tr=0 ts=69255eca cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=G-lmFN37WTdQfOt6kDkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

Add a signal_exits counter for s390, as exists on arm64, loongarch, mips,
powerpc, riscv and x86.

This is used by kvm_handle_signal_exit(), which we will use when we
later enable CONFIG_VIRT_XFER_TO_GUEST_WORK.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c2ba3d4398c5371526ddfd53b43607c00abc35a1..1b08a250fb341f7bd2d19810392c1c6e21673b64 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -146,6 +146,7 @@ struct kvm_vcpu_stat {
 	u64 instruction_diagnose_500;
 	u64 instruction_diagnose_other;
 	u64 pfault_sync;
+	u64 signal_exits;
 };
 
 #define PGM_OPERATION			0x01
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16ba04062854a99ab7d48ac427b690006ea8e7eb..fa6b5150ca31e4d9f0bdafabc1fb1d90ef3f3d0d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -185,7 +185,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_308),
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_500),
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
-	STATS_DESC_COUNTER(VCPU, pfault_sync)
+	STATS_DESC_COUNTER(VCPU, pfault_sync),
+	STATS_DESC_COUNTER(VCPU, signal_exits)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -5364,6 +5365,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (signal_pending(current) && !rc) {
 		kvm_run->exit_reason = KVM_EXIT_INTR;
+		vcpu->stat.signal_exits++;
 		rc = -EINTR;
 	}
 

-- 
2.52.0


