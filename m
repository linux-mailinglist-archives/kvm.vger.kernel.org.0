Return-Path: <kvm+bounces-36909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBDDCA22AD5
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA5233A7E41
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A26F1D6DB8;
	Thu, 30 Jan 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lE9rvJYp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02011B87E8;
	Thu, 30 Jan 2025 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230692; cv=none; b=cRJNgBHEwPIHcyNPgNOVqJgm5OgpdFY+ab+mQdkWkqQECEkYDfmK8Tae0yD0arhXpKQLkMwtpz8emUwM0yBMWj71nxGyW/THIwnGZw5lxdVJjfiwdBHjAE8UQim9bw+lObxkDVFe3Yr+L9iCkpYCTdx44gixBrTnGw3D/DdlLh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230692; c=relaxed/simple;
	bh=sNR7bi+aOpjyYjZZAKqNLOUNvCFJ6/an2UCtLVENN8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEh/AQ5WQenrtGCWyQPlYiaRPJbXUjJE8OKHGv9GwOUMdnzglV+vp7PT7lV1Dmd5v/a0qJiAIsa/NH7jXIIw/QL3LUuGR0OrNofqqwhCbM2psg+HJ4xzxG0B4EsCO9rmLH293woisF2VZ5BqmerkewGy+vwCo+ElCnMAkFas6AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lE9rvJYp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U31t1U008430;
	Thu, 30 Jan 2025 09:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=aM4NsU6gCKP3MpDak
	cgbgRzV79DiZqF2lS03JnrvR3o=; b=lE9rvJYpc1lEITb08+Xosie1qZiM3NCdQ
	+yy7JN8lN25S6IJ5Xzi6qExYVyvJSIuAQiRcuk66vbVfhYYf+H+qtJ82SaJm/iDQ
	Js+uSzMeLzZSy4JLAWvXoei/98OJ4yXJvtAJD10Le2NpgrC4rkzlGmdAAZQ/UWYs
	PCfYb1aBkCnZ+m7Iw8pDnsG9z0DcDx5G2rRmYkQ0iUYLDztqaMT/g7qtw1UtWd3i
	3uq04eWHzx88nhmMy7Ikz7FRNiEtAdRjHyhue9iHIDX+39LQRSL3aLBuC1fZNwDj
	AfA9LtEAnCKbVPKZUpFWmM5lwiGarZI8g593SMtNk+OiXNPHEiTbA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fq5tv9e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U7ZhMP012336;
	Thu, 30 Jan 2025 09:51:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44danydnds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pM0820119932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24DCF20140;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0232F2013E;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 04/20] KVM: s390: vsie: stop using "struct page" for vsie page
Date: Thu, 30 Jan 2025 10:50:57 +0100
Message-ID: <20250130095113.166876-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 1eHveuYvBNb0NzJrU_NMO7373p2qWwud
X-Proofpoint-ORIG-GUID: 1eHveuYvBNb0NzJrU_NMO7373p2qWwud
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=994 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300073

From: David Hildenbrand <david@redhat.com>

Now that we no longer use page->index and the page refcount explicitly,
let's avoid messing with "struct page" completely.

Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-5-david@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/kvm/vsie.c             | 31 ++++++++++++-------------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 97c7c8127543..4581388411b7 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -931,12 +931,14 @@ struct sie_page2 {
 	u8 reserved928[0x1000 - 0x928];			/* 0x0928 */
 };
 
+struct vsie_page;
+
 struct kvm_s390_vsie {
 	struct mutex mutex;
 	struct radix_tree_root addr_to_page;
 	int page_count;
 	int next;
-	struct page *pages[KVM_MAX_VCPUS];
+	struct vsie_page *pages[KVM_MAX_VCPUS];
 };
 
 struct kvm_s390_gisa_iam {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 424f80f5f6b2..a0398ff85d00 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -599,7 +599,6 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 	struct kvm *kvm = gmap->private;
 	struct vsie_page *cur;
 	unsigned long prefix;
-	struct page *page;
 	int i;
 
 	if (!gmap_is_shadow(gmap))
@@ -609,10 +608,9 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 	 * therefore we can safely reference them all the time.
 	 */
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
-		page = READ_ONCE(kvm->arch.vsie.pages[i]);
-		if (!page)
+		cur = READ_ONCE(kvm->arch.vsie.pages[i]);
+		if (!cur)
 			continue;
-		cur = page_to_virt(page);
 		if (READ_ONCE(cur->gmap) != gmap)
 			continue;
 		prefix = cur->scb_s.prefix << GUEST_PREFIX_SHIFT;
@@ -1384,14 +1382,12 @@ static void put_vsie_page(struct vsie_page *vsie_page)
 static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 {
 	struct vsie_page *vsie_page;
-	struct page *page;
 	int nr_vcpus;
 
 	rcu_read_lock();
-	page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
+	vsie_page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
 	rcu_read_unlock();
-	if (page) {
-		vsie_page = page_to_virt(page);
+	if (vsie_page) {
 		if (try_get_vsie_page(vsie_page)) {
 			if (vsie_page->scb_gpa == addr)
 				return vsie_page;
@@ -1411,20 +1407,18 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	if (kvm->arch.vsie.page_count < nr_vcpus) {
-		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
-		if (!page) {
+		vsie_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
+		if (!vsie_page) {
 			mutex_unlock(&kvm->arch.vsie.mutex);
 			return ERR_PTR(-ENOMEM);
 		}
-		vsie_page = page_to_virt(page);
 		__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
-		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = page;
+		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page;
 		kvm->arch.vsie.page_count++;
 	} else {
 		/* reuse an existing entry that belongs to nobody */
 		while (true) {
-			page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
-			vsie_page = page_to_virt(page);
+			vsie_page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
 			if (try_get_vsie_page(vsie_page))
 				break;
 			kvm->arch.vsie.next++;
@@ -1438,7 +1432,8 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	vsie_page->scb_gpa = ULONG_MAX;
 
 	/* Double use of the same address or allocation failure. */
-	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
+	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
+			      vsie_page)) {
 		put_vsie_page(vsie_page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
@@ -1519,20 +1514,18 @@ void kvm_s390_vsie_init(struct kvm *kvm)
 void kvm_s390_vsie_destroy(struct kvm *kvm)
 {
 	struct vsie_page *vsie_page;
-	struct page *page;
 	int i;
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
-		page = kvm->arch.vsie.pages[i];
+		vsie_page = kvm->arch.vsie.pages[i];
 		kvm->arch.vsie.pages[i] = NULL;
-		vsie_page = page_to_virt(page);
 		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
 		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
 					  vsie_page->scb_gpa >> 9);
-		__free_page(page);
+		free_page((unsigned long)vsie_page);
 	}
 	kvm->arch.vsie.page_count = 0;
 	mutex_unlock(&kvm->arch.vsie.mutex);
-- 
2.48.1


