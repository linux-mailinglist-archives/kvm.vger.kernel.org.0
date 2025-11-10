Return-Path: <kvm+bounces-62531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCDFC48429
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 51F63349B58
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D973D29992B;
	Mon, 10 Nov 2025 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rvWsz16d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB131482F2;
	Mon, 10 Nov 2025 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795065; cv=none; b=JBP8xf3Ymkag9FWEWtN3mrKNrc2+C5YbXsDZ3gCEAXy2oVEv2qFarYmdDEibnJuXdoG5F0CW6yqwFwLZiiRUunxobuXwlT8vgFUSec0bNUUloKUwz3Sy1HmJd4eMtnape6iyRcEH9v8x0q56ojRAsCVaOVXFcPmuEIvNZW1jlH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795065; c=relaxed/simple;
	bh=3O0mgGG3nK6FmO/IDgC797+GYK3t1CmlH6j6ieMUkcw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N7EtCZsByaB3P5aGSm0VAk/Q14SqFTDYnHgi36DiHVRUBtU1X9mB2hJEc17L3tq3tt9gQtgFw346OhPqCM6qHp9y/Nrcq93zc1KCWRLZMlxgtcozT1ARcVq0hEqVvGOg3PcIeDp7eHy/+BWWdnAGIc33UWWMH4gkZofcBYVB6PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rvWsz16d; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADeCOW028678;
	Mon, 10 Nov 2025 17:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8B7gqv
	EzpasY4lDApuRB12BgONWonH7n4DglC5uwdzc=; b=rvWsz16dlWEFdLJUArzJLn
	mfDJf3BwhAwgXmcsd14GMNgNWr52UEtbRiOaJTOUEz6q3nBrU3Q7YW9qXx/u4G/i
	BUWXd6Mt/SXFRxnTOsxUf8Rle4ME+2rM+K9NFQrPlM/MigXwpuq0OOTydtWWbumX
	ryqyfnPYDmUgYGqAnkfx+25Q/TMHWYmRhga0FF3UHRTaTzhah3k5/AxU7oADves3
	eP3RVgAZGER4ikJg3pVKbx5Nwlyy6lketVY9yadjZ+Cd03ytw1vuA9j3T7YPeMNU
	z5DDIw+eu6O8vH1vZ7GFBWgDRZwKubs4iN8iRZRo6viPv6efQ1adtPvmROV2n3YQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wgwrbca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGcARt008193;
	Mon, 10 Nov 2025 17:17:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6mpqxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHX1U40370678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE7D520040;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 490C620043;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:42 +0100
Subject: [PATCH RFC v2 02/11] KVM: s390: Remove double 64bscao feature
 check
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-2-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
In-Reply-To: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=911;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=3O0mgGG3nK6FmO/IDgC797+GYK3t1CmlH6j6ieMUkcw=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCclqyX1ilkt47RDxvV3vf+uOK25etpjIL1utrzntk4
 K0nUcvTUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwETeezD8T3+r8tY050sp65ui
 vy5sCy/cvfKQ/dK+ThumYPcHOQe6JzH8L758lVmQz1PU2Y+59v6/v6W/jy26r3l7z7xnezVyGr7
 18gMA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 68QfFLtcMDcBQnKbocwejvpgfs45-4S5
X-Proofpoint-ORIG-GUID: 68QfFLtcMDcBQnKbocwejvpgfs45-4S5
X-Authority-Analysis: v=2.4 cv=VMPQXtPX c=1 sm=1 tr=0 ts=69121e32 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=TDcXjUL1frRt-f2QLQkA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX0jbcMhi5E0z8
 o4zo06I7EGR5xYsDbviQ7QlL2CDGf+bIplx0oF2dil8OvbHAn064GTNLA7b6724JmVfkmooL//7
 iiDD7mVG0AS/3xXgxa2D7O8gYwTXm6YGPYvWxizeJqq1mAyDYLfqqZD2O0pe8AKyuyoBWR0v7HV
 7V6HvzGj1wjuFsofn/QMFBh0/qI4m+H4BDTue/FWe+HpumlJQ8Ww21kVkuPddRcw8Ep5qnczA+/
 0i0a1bYAuPzh9RmsozLhuZW612fO9Ns5q0U+kUdWnHd14eBfbkvTAKlXwG6nyYFFcVsVZiOQaWV
 VppXnYceK1a8t+v3s5TeA0VnMWmLRITnKR1NUjDEcXvlRHUknLJar0d7iNm65Arm1oteVrzT4m/
 prBHyBLsuDre5y/C6+o6EdxFmSYaMw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 clxscore=1011 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

sclp.has_64bscao is already verified in the guard clause a few lines
above this. So we cannot reach this code if it is not true.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 769820e3a2431c16c7ec85dbf313f61f7ba1a3cc..984baa5f5ded1e05e389abc485c63c0bf35eee4c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -455,8 +455,7 @@ static void __init kvm_s390_cpu_feat_init(void)
 	    !test_facility(3) || !nested)
 		return;
 	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIEF2);
-	if (sclp.has_64bscao)
-		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);
+	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);
 	if (sclp.has_siif)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIIF);
 	if (sclp.has_gpere)

-- 
2.51.1


