Return-Path: <kvm+bounces-35852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 240AFA157D6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44C4816833A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05931AAA11;
	Fri, 17 Jan 2025 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ft1+d/Xi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CD01A83EB;
	Fri, 17 Jan 2025 19:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140990; cv=none; b=mMlqYlx1llQGNuRMR093JbAN+H2HWH+sRhKZDa7I8MWhqQe0MBxAI1gmn2yfuMz/UPmrc1V7ZfyrGsosqMHwwOxiJYxjn1IOGW2osFfHNK7H0n4VAIeR2UpZkioj+F8uqdYMaRRgk8ANMIP4tqSYJrQUCJmPwlCEzcc6imQwhcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140990; c=relaxed/simple;
	bh=yi4WO9ESh/EWpTiw3ToYboFPe3xptoVENUs/EKj1qTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUMO5Rv3sz07UusYwXJzEvTTtiHiXgI4ArT/w5E3x36PGbFxBQgIuOCiW70rGpqBilQtiHepYjXGxc3Juc6bnUuWLrpDkmnSIcP/2i7Q74AWKUmjw1W57Vxq4Z6rQoUhbATgBABpak1wxFX7qRBeua7XIXOaVXXRFyA7/NQuUOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ft1+d/Xi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HHckr6002026;
	Fri, 17 Jan 2025 19:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QhgquwsfYJASkAeh/
	HEvE3Lq171siDCM9PiELW2IPHM=; b=Ft1+d/XijwC+ezyovqStRLut+66ahgMUf
	pY4buwsLpBj62bkjUMujoI50vQffu3bxu7jGplD/kIk1qzIXMMnwxAy7UER0An97
	o1hZqcUkfAzTXwZ4uc5V4SV61SXh736Bl7dqKPEE0A1wJJb/C8vwzzag9r/Tb7xZ
	ZE5OpalL5MkUbL6N74eOjzQ2d+4bZDrqv/2qFEfnPc02ZHiclba179U63E27zGAQ
	rj1gigyJIov6SH0CjZcwwUKiop9+z20kCZW6vATTE90XNhL/Y0Fx2yjxYEgWeKDp
	kdFLMRrxG5LnlkjgACiO1YQIwwfc0bXzrid9/KW8x2WeIF3qon/9A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3k0e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ3j3W010809;
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3k0dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIh11f007519;
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynmbng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9dcn55116116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48A4220040;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 135752004D;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 01/15] KVM: Do not restrict the size of KVM-internal memory regions
Date: Fri, 17 Jan 2025 20:09:24 +0100
Message-ID: <20250117190938.93793-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4RQYGynxrSKbrim08kf9HwSZcj-_kM4Q
X-Proofpoint-GUID: 8RsWg-W2Ml2RM_JRIscrIVs5D1HJGbmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=818
 priorityscore=1501 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170149

From: Sean Christopherson <seanjc@google.com>

Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
the limit on the number of pages exists purely to play nice with dirty
bitmap operations, which use 32-bit values to index the bitmaps, and dirty
logging isn't supported for KVM-internal memslots.

Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a8a84bf450f9..ee3f040a4891 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1966,7 +1966,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
-	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+
+	/*
+	 * The size of userspace-defined memory regions is restricted in order
+	 * to play nice with dirty bitmap operations, which are indexed with an
+	 * "unsigned int".  KVM's internal memory regions don't support dirty
+	 * logging, and so are exempt.
+	 */
+	if (id < KVM_USER_MEM_SLOTS &&
+	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
-- 
2.48.1


