Return-Path: <kvm+bounces-36980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E679A23D01
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B47816AD1F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FA31F1526;
	Fri, 31 Jan 2025 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rfdskuep"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96BB1F03CC;
	Fri, 31 Jan 2025 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322726; cv=none; b=hw2Ww7vXB+pjGEoTO47bZF+NiHqZzns01KGiMMRPq+RcSFhRanltLm1/k7Zz10Vhztx9U1DNbHX9VmKwoQNT8DpdDYNRZ0GYM3hdXeGCEgg6UzF1vxrCzSkhS7yoDZn3Xa+HM6+/QQBdjObgcttkpo1t+WNeDhb1auLGM3ubp+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322726; c=relaxed/simple;
	bh=sn5UeQISEithJTirHTkMvhKa85HHGezjc55xwI2IPZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwih6QPcgX6nVj5X0/wJufn2N+0UDIX1a6knu6Eauvcm6oAws+ATnZ8MJsWrdZmV0Q+oPGdCgclJqCUG6hfpbdL9KWbZywX1U5aFoSvTCu3i13PkxIJSlbbWQAaWm+stgmr0a+ROlAhuFKmLgtiEJINeUlP20ysiaIl89N4hjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rfdskuep; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V5O9Zi013392;
	Fri, 31 Jan 2025 11:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=H1yfjz2fs9PndP25P
	Pb+5fz4hGxOrNx4Ivl4X3cHtik=; b=rfdskueppWDchRdK+70HJ62wOP5p8NAYi
	fufbaxEpDqw+a51aujB1I2/cayr2lJy9ctFo7/GBxVx25vPkXHwEAtO2+O8zYLL2
	H/uvTbEoWY4+kNmOTLsStMDTxUgLUL08phPbNEdZwN/WufwG2GOPzu/XmMjOKWz7
	ie9xpIevRrjZLmVT23RMbrsHRt7x2iiLeqLW99KAMUliN7NHjq4WeXJQANKxZXAD
	ZOO4kztCEEc70WZV1ZxpD71scz+44oZ5UJdrSNcNph3nC2LFrpGKvclzGEb0bTYr
	pcpMJF5uIuxfm1z45v/tpIPV+SPvNZKAcc6PKaCfhrxd9jrkbRrWw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44grb79b4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8KL3Z010210;
	Fri, 31 Jan 2025 11:25:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfa0k93r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPF9g53870956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3214F20132;
	Fri, 31 Jan 2025 11:25:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32F8B20134;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 02/20] KVM: s390: vsie: stop using page->index
Date: Fri, 31 Jan 2025 12:24:52 +0100
Message-ID: <20250131112510.48531-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: H9uLk1c0xhvxtANVCTGbaXNh8nmJi61x
X-Proofpoint-ORIG-GUID: H9uLk1c0xhvxtANVCTGbaXNh8nmJi61x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2501310083

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
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


