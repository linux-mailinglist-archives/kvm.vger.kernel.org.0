Return-Path: <kvm+bounces-36370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA170A1A5F6
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13651887696
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F13F212B34;
	Thu, 23 Jan 2025 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n5UAJOx0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0994338B;
	Thu, 23 Jan 2025 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643600; cv=none; b=c2CT/6eMxr0uRgA8tqK4srZht6ew1Q1LcPAIauwB2z5Lfvb924ZlIBSjNfal4csSfYsBlMlXg3lJZ0E8VxQCOIq0FKzPX1erUH6bguHaSgr9SeRkSiz+zBauhYC4jLCfGViYzD3A/xZRywWv9KlCe2kiVlrIbv0/VfC7JZpi2z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643600; c=relaxed/simple;
	bh=yi4WO9ESh/EWpTiw3ToYboFPe3xptoVENUs/EKj1qTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6jQQgf0je9jiZq21WmQqtcFn1daQMz3PvXUPD6/j0GlWxw/Gxkmdce9hIx2tYzyDyfMl1snQe7jtWADO90dqzKKrYyhWZt6NujW8bBXmpMwHZSB6Y/2TbUs8FErCK9dhpFqv/GpsA59viZa1eF986mXCL5vq/RN18kF3NXwO+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n5UAJOx0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NEKWtb016779;
	Thu, 23 Jan 2025 14:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QhgquwsfYJASkAeh/
	HEvE3Lq171siDCM9PiELW2IPHM=; b=n5UAJOx0sNCcSO9HbVvLTZZVChpuqmeDJ
	9xpu1Cy9Lbwnpjo4diwG1adIw6PPriC7SR4JQPhX8MQ5vjMZDMdsHdi4KLRdCvXT
	1Uwn5S7PEv1xwJQ2c28Tpn7mtTCTiwHoZFPg1+o1OnNA3fjxrtR2UnJeDByi082V
	JNQAT4VpkAUWvE/ezVnlVGnnbhf60n7zGZ0KneExVgdZKZW8r3fMp7foQ3k1KHMN
	gUEG5YBQFeEXSCeQcU6PUqxYDH5IXY05ANFFXyCWj75QFI7KaLuQyw2mwxN6i/IB
	0/MEyTX9k3TLP0pA24sjJp4xFDHs+iOoT6D+kxMz3nii3UqWJkYxA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEgILL019665;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NAc3eY022387;
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4kduxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkTCp15925542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAF8020040;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3BFD2004B;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 01/15] KVM: Do not restrict the size of KVM-internal memory regions
Date: Thu, 23 Jan 2025 15:46:13 +0100
Message-ID: <20250123144627.312456-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d0DUpDlSQK-Yag0sT1i63pKjiHSEoqua
X-Proofpoint-GUID: duSDZodNShe7GlVwgoBWfJbvvHHLH_my
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxlogscore=818 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

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


