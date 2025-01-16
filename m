Return-Path: <kvm+bounces-35643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6ADA1390D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55EBD16896E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC991DE4DE;
	Thu, 16 Jan 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nHtIwCVR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0821E86E;
	Thu, 16 Jan 2025 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027249; cv=none; b=BJY+NkvBNRUootixXNUdLWX88ZuW/wls2ZoEXehawGJ8bRqVk8Xw20yrWkFkEV+knVDjD41cBhVi8tOGpYzv1HSb8DJ1kVJYVlAE/s2UBKnWHlY41lflQarzHA8UihiFeT7XVD85Pb+4R0OJq1y1xVLHX8Z8Amn3YZ2ZEDOvexc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027249; c=relaxed/simple;
	bh=/i4KOyVoOVdI1gUvACjoH/HAdcX4SxONCFMtl86yrpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwNyOw8r1izb9QaHlDCmvSdqbzfJpV5km/6BftCsvz60TNLibUgjOb18gVj79+AjJ62Pbtpw31oC7bCcjy/agwJWP+wsrbNzxGIprZ4uPz+W67XM8vISzZOYwLrDhOAQdIn7qgHvcXtxSGYdkkKR5orl94S9Znyjb1d1Di7oG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nHtIwCVR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FNaS2M022738;
	Thu, 16 Jan 2025 11:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=D/JvrZBH2LABER2sO
	6goeManPyR9hrhI/qPoGWf3Cz4=; b=nHtIwCVRS2Zmesorej60zJpuotzk9mYGD
	jwhy0UyZtjndHWzpY2mScYmVr40L4GEW8wPA7k0O1ed+oaWcCcPqQiqoqROAY7Je
	JIPHnTXZxg+pZBzoYQdWfLvRK7ry6upBufbNBxjaieRKqt/42NcaKhlCVJp3RLGd
	bn26q/jivJWI3ZTz6IDXO7UIt2H1hIAv8BwDMPV27yIpkj/yglp9zeVw1G5k77c8
	rtTjUlX8NmpvLAKLFIO7DA2SGy0qKY28feQroBaz0hip/xgPkQjL50hKcGsgCZN0
	LJm57/XrfgB6x+hhtC2Ch3AyL10ddGUkh34weg4N66Dyxnp1ywZ+g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub2qr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBY1TD027192;
	Thu, 16 Jan 2025 11:34:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub2qqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9LFqk002666;
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bydpmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXush18481632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 658D120049;
	Thu, 16 Jan 2025 11:33:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25B5F2004B;
	Thu, 16 Jan 2025 11:33:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 01/15] KVM: Do not restrict the size of KVM-internal memory regions
Date: Thu, 16 Jan 2025 12:33:41 +0100
Message-ID: <20250116113355.32184-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 98Tfrf_C-9SmDFkMoPjvRw6NyArwdeV4
X-Proofpoint-ORIG-GUID: e1Txh32O3erOc0AhwefyVVCTAMyX3wpN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=777 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160086

From: Sean Christopherson <seanjc@google.com>

Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
the limit on the number of pages exists purely to play nice with dirty
bitmap operations, which use 32-bit values to index the bitmaps, and dirty
logging isn't supported for KVM-internal memslots.

Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.47.1


