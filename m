Return-Path: <kvm+bounces-64606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BB9C882A3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1B07E35285A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4633164AD;
	Wed, 26 Nov 2025 05:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UBVnCOGf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06466315D49;
	Wed, 26 Nov 2025 05:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764135236; cv=none; b=Xo0aNYtPmPDexOe3G/YSkR/80n0j4CF3gz7UixuqDYv/VtoVrubdckQXIVe/scYzooVS4L7uOMqai6kqc2WbyWkFdrfosbfCmHWIKpa3NIwquo7Rm5Mq5k7wea73WhOCHYXbBCjRTMYq4mN5lgtJ8PvZvWZPNh6GJMmNPSmKlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764135236; c=relaxed/simple;
	bh=mlKXJUe4V1DrGVVM+Wmaq4bBJ2m/ukvgHSJAd2SGJnw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jmk2iFjI7Zj4DVZjfHFaD/hItOZBcgSQYUHx1ijP0BUw0CdWE408QDIPsYuNz1a2UI2NskKMsUNVKOFFimRRNPmbyTZzMCs+3xhUOltOidwnickKVWmKpGDUVFyBP0xr7YRD/7HGDyE4i7B4vo8vmK6l9yt69HauC28/Fz9ljTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UBVnCOGf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5APK7hnb021895;
	Wed, 26 Nov 2025 05:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kjl1az
	LRE9ur0C52N2dgIeYfMTg2D3R0g39O1muXgwA=; b=UBVnCOGfNq4Gkqb/HqVV6a
	iS51HYzOBhiE4szHkIUwW1cYdpfK5YnDmJaRdMYWzcg9DCDktyHXknccrf7kblWi
	Qa3F/fepZhhg5Y7H2niEerV2bpnmjAB06hZ2YpNkqSVKmNYJB42hEHswN9d3yHYP
	9nHK686nw4QT863O71A40saOG0UuJcSQVHTyPHG3LIXuD+CID51nPSsYYpysjBAE
	jR3FaNhNEFgOFbrZG8IQ2h73NxoJecA1o9MG40tID2XzjQMqb/7I/1pmusOTkrok
	8vG4IQM+ULWj6TsFTHUfcXZjjAsffFjz2T57VeXazPZCkIiXr+Da/GiP1E0jXYjA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kk14jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ52Ki6030755;
	Wed, 26 Nov 2025 05:33:45 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgsgdnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:45 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ5XhAh5177934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 05:33:44 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3BDE58056;
	Wed, 26 Nov 2025 05:33:43 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC4275805A;
	Wed, 26 Nov 2025 05:33:38 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 05:33:38 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Wed, 26 Nov 2025 16:33:10 +1100
Subject: [PATCH v2 1/3] KVM: s390: Add signal_exits counter
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-s390-kvm-xfer-to-guest-work-v2-1-1b8767879235@linux.ibm.com>
References: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
In-Reply-To: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
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
X-Proofpoint-GUID: IP-8lpP-JwmOvbWgHD6tG7cs5oCbQVw2
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=6926913a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=G-lmFN37WTdQfOt6kDkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IP-8lpP-JwmOvbWgHD6tG7cs5oCbQVw2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfXx84Hf/+hdPxI
 KHNs6trZLQuSr0VYw0oq5b34i7JpwbMNj2yVZuLITqQ4NPGdyCUNMg9gO0PcBQ5/Omg2SwAlzgk
 sF+DOqSigOuLjmqKAn3vpQdgQ7odCK6wLv9nIZlSkzv5dydIYa8VI+dIokpWwnuLX0ugZqkzECZ
 28nKdOIx1jq4mKHLRckZLSxLKcR2uXOve/99XN4EQaqd/UfKgsQJfR+OS3oG+3ottBF4RWcABhM
 7dYxfC7p8uLIBKKisP0q67t7e95gKGMdWl2SSqli8d8E2m3x22rViDS3nVu2bEE9o+R2+aiSAsb
 XAUTdtXEcG9EXEaAru+6vlHEg5D++0tGd/MKUMGiDTuchNRNYIfi6Mnxv3Kgy7yHYtYtNw4HsiD
 81BkW20MG912quzfDVl6nC52HnMI4g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

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


