Return-Path: <kvm+bounces-20382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F4B9146DE
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 11:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33D231F20FE2
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7C4135A7F;
	Mon, 24 Jun 2024 09:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q1Dalikb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A4F130A79;
	Mon, 24 Jun 2024 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719223169; cv=none; b=Ey9GT2P3fErjO72vBNmYjTNlV3JHUDUpjdjp5vPIDLyIUR7SS2F9xNJBMP/VWA42U5utSxvLmE3J66y6kWpDBZyqDVlHYUdTUxokGgEZV1VUCDfPMHZIup8JY09mTdvCQpwi5fQAHbuhFA0YHRo2Bzi0xILUUBMRjI3QKB/J9XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719223169; c=relaxed/simple;
	bh=zJcdGyUdZLuCNczx/nqzTFcVLN0OGiPutA1r790Kcfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QpESRBh1noX8gkozAq4oAZmD3ae6+tTiC7Po3itI1edzAVemwrBrX3XtGsU5h1Y4zvdBg6b0inwU9HbqPKc3D+iVPLbm27xAv/d/gIlgvTXqxbN60UfNgKOdXb4SdUiiJzRdCup9BPRMRTCy4W1kpkDYw6FNkgPDcft8bGEanVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q1Dalikb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45O8xPPw013702;
	Mon, 24 Jun 2024 09:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=2KZvX60DMd8P4EJ7ET6Mxr10IK
	A4yiUdj/8yc/yPeuw=; b=Q1DalikbKwRIX2ui9vAnJIliYwjKN+vF8L9IRQz4XV
	bCCGXzXE1PesPeCnXNUYTjrqHbB1hpwK7fxM+luQ584pncQ+M+0Bo7W/QMQhn/xp
	mjb9FIuxdoqSt12E83wfQX+ixaKumEWhwXbdgcEuJZ0gQK3dl4v0HjN38B0MtVeA
	KWYYMoWuDh23wEJawgQlerBGkktfNV7aoxS91/FsbWh960R8Ag8oLrPEISGI7J1f
	dz7sJ107uv2AL2RA6D6FoIH3AMNmNWdir9d4Hs9D+z50UWkYsa71EZohL/GVEMyO
	I31GF+8YQSHCpkJa9JxvjVS5qvSV24/ZkiDvKtfS9o6A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy5s50a2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 09:59:23 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45O9uJmh023233;
	Mon, 24 Jun 2024 09:59:23 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy5s50a2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 09:59:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45O9FGbB020058;
	Mon, 24 Jun 2024 09:59:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5m7ejj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 09:59:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45O9xGAX47251768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 09:59:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEF3620043;
	Mon, 24 Jun 2024 09:59:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 497BE20040;
	Mon, 24 Jun 2024 09:59:16 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.6.193])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Jun 2024 09:59:16 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH] s390/kvm: Reject memory region operations for ucontrol VMs
Date: Mon, 24 Jun 2024 11:59:02 +0200
Message-ID: <20240624095902.29375-1-schlameuss@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2xcoGmAbfJM62j_PztwpAAUazTjoDst-
X-Proofpoint-ORIG-GUID: 5H6cT5BBDe8iPSqQ5M6GVGr-JVHKY594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_09,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=598 clxscore=1011
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406240079

This change rejects the KVM_SET_USER_MEMORY_REGION and
KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
This is neccessary since ucontrol VMs have kvm->arch.gmap set to 0 and
would thus result in a null pointer dereference further in.
Memory management needs to be performed in userspace and using the
ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.

Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
and KVM_SET_USER_MEMORY_REGION2.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 arch/s390/kvm/kvm-s390.c       |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..eec8df1dde06 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1403,6 +1403,12 @@ Instead, an abort (data abort if the cause of the page-table update
 was a load or a store, instruction abort if it was an instruction
 fetch) is injected in the guest.
 
+S390:
+^^^^^
+
+Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
+Returns -EINVAL if called on a protected VM.
+
 4.36 KVM_SET_TSS_ADDR
 ---------------------
 
@@ -6273,6 +6279,12 @@ state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
 is '0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
 
+S390:
+^^^^^
+
+Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
+Returns -EINVAL if called on a protected VM.
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 82e9631cd9ef..854d0d1410be 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5748,6 +5748,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
+	if (kvm_is_ucontrol(kvm))
+		return -EINVAL;
+
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;

base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454
-- 
2.45.2


