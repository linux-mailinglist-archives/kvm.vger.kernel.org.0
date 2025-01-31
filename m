Return-Path: <kvm+bounces-36981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F777A23D07
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38DEC16B30C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C801F2370;
	Fri, 31 Jan 2025 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NubS4eNv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8BB1F1512;
	Fri, 31 Jan 2025 11:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322730; cv=none; b=qkAl9KxviXK+u0lNisKvWa8bqZ3bQHWyB8sPs7jHzDTh71OCTkbe458xnxl5OaoVm/D6wHsnwAdjpGQU2PLqUyJPNXaEs0c61Gazlrq0mOwC+6F5nsleY6zUHBPU55rPbIba717OxoVOWkokAFoLAozENGhsBY0pkV/isv8Or4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322730; c=relaxed/simple;
	bh=WHf/GfVwGbpSthBAMPEa+QdYHtEebQt2tiHgzN0wHQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LayzMEJJnreI1Yrv5bKFWBo4k7CXXMl0TiAbHbvFhBvcnLIrdo2pzd3MA2E5ILMs0fWaBTyAnJWKy82dXlCeajWkLqqqYO5BiLKYPjubturuKgLSeLzDpp3yhFGsPaI5L7D1Cebuqaw/+OCZdxbZTBOdScMYzQiTKq2z4WCDSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NubS4eNv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2ORQK030647;
	Fri, 31 Jan 2025 11:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qVJy8wNMqLFLjIiiw
	JPupQgpBcVbCX93K+STC4IxBKg=; b=NubS4eNv4bjUkEAqjs+3j6fcCHh6uufn/
	rCxEJ64Ily64BGx/s/6HWTpal80OeKPyNuTRn6S7PvHvCARCGOy3XJovVMfJySnF
	5DWpWHKFOf5A/+9XE3ZPuBnS8qB1ftL2ZWd+qujKWt2o+vzZK4ZFODnxwuT0ZWeL
	nJG4voIH7oSV9camluexcbejkQugxNeyyz7Z1+1ZaR8f2ttyqu0Anx6LqCsQbxvI
	laifHXURiKECsh7Ns4fg0IY52sYfugXC9vyD3QFsEKHGrJT2E17bBU+DIj5w06fi
	0xrwL91EIxJM8OXl5WsLQ4mjekjv+eD796m2Wsm1xm9fdQ3cH7pgw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5b8sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:26 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8BILm017237;
	Fri, 31 Jan 2025 11:25:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfayb9fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPMc238338856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E06C20131;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 551A820137;
	Fri, 31 Jan 2025 11:25:12 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:12 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 05/20] KVM: Do not restrict the size of KVM-internal memory regions
Date: Fri, 31 Jan 2025 12:24:55 +0100
Message-ID: <20250131112510.48531-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0ZTHR2F27a6Somzud1y-dpBQ09_7twEQ
X-Proofpoint-GUID: 0ZTHR2F27a6Somzud1y-dpBQ09_7twEQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=956 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310083

From: Sean Christopherson <seanjc@google.com>

Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
the limit on the number of pages exists purely to play nice with dirty
bitmap operations, which use 32-bit values to index the bitmaps, and dirty
logging isn't supported for KVM-internal memslots.

Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250123144627.312456-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-2-imbrenda@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index faf10671eed2..3f04cd5e3a8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1971,7 +1971,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
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


