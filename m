Return-Path: <kvm+bounces-36902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2418FA22AC0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BFF73A7FD0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D79C1BCA19;
	Thu, 30 Jan 2025 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O+nt+uIQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5570E1B6D08;
	Thu, 30 Jan 2025 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230689; cv=none; b=JIVbKhzRgYQL20J4Pb2Q55EAu+pKSLA/+vZxIgTn2kDaeRMuG5IJzMxUpcD6yFw+jpP8Yw9+FuLx0WoFELSm4CjvKaPm2P7cIsMhC0L3Mtko7ncMy36H5+Pd03d990pdsFz0gCv4uiQfjydi8DZnI/PHhhgDt3RqVJAvrsSH67o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230689; c=relaxed/simple;
	bh=zpPEJWMm+yAJPbyDxobWOMfNMdOPGjBC5H23ihz0YP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etE24MEDrxa9aGhoLmCY1Q7TM1MrO5SFYlwW/QqJuua8XTbg7SGyvnXjNOx8fyv82am3OgH9naGuc80jCJNoNQcjnw7tx4+rx4UJDBrNKrCJp1dT6qIKoRZIf0fbzOMeTKuQ7qia91qTL71gb7QxlTbFzmHsHsIfZ20YnFcNpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O+nt+uIQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U5NpWr012397;
	Thu, 30 Jan 2025 09:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=46AUPCpWShPazLqtn
	PPPPmEqpoWnuBQ2K+1kORfm9PI=; b=O+nt+uIQdTyDntjLGbTmaYKS+OOuRv9M6
	6jqeTqQgSAhBMd+uA4QRGPWcBv8aXCgiEzVQ+cWHcE9RA/7d8fWCStMlBJB5yXtN
	zojLTL47Ma6JEQ5FyHXNwwuI3cX8M/DExtajTOVOsZe3QoLLrtWPpBsYFZ2MG2Xj
	I74Da8dcdbtGId0JQ6KkwkMtMprqkT/DLUiXeSG59SNyILPuqyUwwdiYBusAExnU
	JgDsiieY6KXkZ9NJZir5xqVY9L6B5fe38JF2D39KkGp4sTo4Frfg3G3hi2j4E2r1
	qeI6GHZ3viNEws0t7WiV6eJ/RO5L280qmVjrQVcLO2VpXbFCXe2TA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g38814e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U7ZhMN012336;
	Thu, 30 Jan 2025 09:51:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44danydndj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pJ9v26083640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C59DD2013E;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A31B12013D;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 02/20] KVM: s390: vsie: stop using page->index
Date: Thu, 30 Jan 2025 10:50:55 +0100
Message-ID: <20250130095113.166876-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2fp7uJFLDa0Ajyg0xlHau_8q9zuX5IFk
X-Proofpoint-GUID: 2fp7uJFLDa0Ajyg0xlHau_8q9zuX5IFk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300073

From: David Hildenbrand <david@redhat.com>

Let's stop using page->index, and instead use a field inside "struct
vsie_page" to hold that value. We have plenty of space left in there.

This is one part of stopping using "struct page" when working with vsie
pages. We place the "page_to_virt(page)" strategically, so the next
cleanups requires less churn.

Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-3-david@redhat.com>
---
 arch/s390/kvm/vsie.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 513e608567cc..3874a1b49dd5 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -46,7 +46,13 @@ struct vsie_page {
 	gpa_t gvrd_gpa;				/* 0x0240 */
 	gpa_t riccbd_gpa;			/* 0x0248 */
 	gpa_t sdnx_gpa;				/* 0x0250 */
-	__u8 reserved[0x0700 - 0x0258];		/* 0x0258 */
+	/*
+	 * guest address of the original SCB. Remains set for free vsie
+	 * pages, so we can properly look them up in our addr_to_page
+	 * radix tree.
+	 */
+	gpa_t scb_gpa;				/* 0x0258 */
+	__u8 reserved[0x0700 - 0x0260];		/* 0x0260 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
@@ -1362,9 +1368,10 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
 	rcu_read_unlock();
 	if (page) {
+		vsie_page = page_to_virt(page);
 		if (page_ref_inc_return(page) == 2) {
-			if (page->index == addr)
-				return page_to_virt(page);
+			if (vsie_page->scb_gpa == addr)
+				return vsie_page;
 			/*
 			 * We raced with someone reusing + putting this vsie
 			 * page before we grabbed it.
@@ -1386,6 +1393,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 			mutex_unlock(&kvm->arch.vsie.mutex);
 			return ERR_PTR(-ENOMEM);
 		}
+		vsie_page = page_to_virt(page);
 		page_ref_inc(page);
 		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = page;
 		kvm->arch.vsie.page_count++;
@@ -1393,18 +1401,19 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 		/* reuse an existing entry that belongs to nobody */
 		while (true) {
 			page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
+			vsie_page = page_to_virt(page);
 			if (page_ref_inc_return(page) == 2)
 				break;
 			page_ref_dec(page);
 			kvm->arch.vsie.next++;
 			kvm->arch.vsie.next %= nr_vcpus;
 		}
-		if (page->index != ULONG_MAX)
+		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
-					  page->index >> 9);
+					  vsie_page->scb_gpa >> 9);
 	}
 	/* Mark it as invalid until it resides in the tree. */
-	page->index = ULONG_MAX;
+	vsie_page->scb_gpa = ULONG_MAX;
 
 	/* Double use of the same address or allocation failure. */
 	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
@@ -1412,10 +1421,9 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
 	}
-	page->index = addr;
+	vsie_page->scb_gpa = addr;
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
-	vsie_page = page_to_virt(page);
 	memset(&vsie_page->scb_s, 0, sizeof(struct kvm_s390_sie_block));
 	release_gmap_shadow(vsie_page);
 	vsie_page->fault_addr = 0;
@@ -1507,9 +1515,9 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 		vsie_page = page_to_virt(page);
 		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
-		if (page->index != ULONG_MAX)
+		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
-					  page->index >> 9);
+					  vsie_page->scb_gpa >> 9);
 		__free_page(page);
 	}
 	kvm->arch.vsie.page_count = 0;
-- 
2.48.1


