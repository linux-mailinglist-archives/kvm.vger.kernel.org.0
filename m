Return-Path: <kvm+bounces-36978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41260A23CFC
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85BD47A4EAE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0E31F0E3D;
	Fri, 31 Jan 2025 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a2pxYbRG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59041C1F27;
	Fri, 31 Jan 2025 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322724; cv=none; b=hx9BWPYH7jM+yY20fAJ+IpYNleDhBIGYezT08nhd6c1DJPJt4IAnsI15ltXBi7xmp3ycZOxn6ad4hH6xCNBdAGbEo3Kgr3DippD+BehjyN98SMG9JAKn19hCuieY+FWyJ3z3+bk+oJaT8n4uxFHChSAhK/5x0NERTK8/SOL7E4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322724; c=relaxed/simple;
	bh=S83xgFUVvgKdoh3LqqvysctSMbV/M/iSX6IN4+tm5mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6Mq756cXymAGlY+OAowMzNizAIvCj6TIikwpk93mSUBnrTxZePQKW3hHqUv2Unw61mspB0LZQNTgBsgf0eZROysDMGc6qgihXtj/SwayMAN8u5SwHqsjysZiovhMMLjJzg6uXbeAPkyxMF6mJTwRH2N8cOoof1t8cfOpGtXC4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a2pxYbRG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2O9o9016320;
	Fri, 31 Jan 2025 11:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tSRncQR9h9/rXuuTa
	U6VYKFDz8PlEhaXkV50bKfseHc=; b=a2pxYbRGzw84Qy+/xqnqHjHsVW90KyGKK
	lktJq/wY5yN9NP3PplM9adt//DTWSgv4n5hTQ3OU5H1VtQSi5biaDSpaxQhKpJiF
	oxm9GRBBTmCg4RlY5C2u64SwD0mhBzyl+qVLuYOi6IAsD9/AD4ohW8lrDyGeejfV
	xVzZO7XG6VZDxNKFPOF4ftl/Ygx1ESPPKxf5/+R8JQjlxUimWsbMXsjFJlN96GCD
	+JGl/+8p8EuiJ5n0X0wcREHJzdSz5VNCenOeOkmSpfGwgSpCXdub8FHPhC3tLlyk
	CJT6dXqXHi7O58/h04o08Iz8Q0ofiTPYPRGlUTsRskY9aLVloDX7Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gmk9246x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V88exK013872;
	Fri, 31 Jan 2025 11:25:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gf93b9ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:18 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPFVK56361278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1538D2012D;
	Fri, 31 Jan 2025 11:25:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED42E20136;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 04/20] KVM: s390: vsie: stop using "struct page" for vsie page
Date: Fri, 31 Jan 2025 12:24:54 +0100
Message-ID: <20250131112510.48531-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: Cj1jMfRDZ1_6DoKCsFxks8J9VBEGhkyq
X-Proofpoint-ORIG-GUID: Cj1jMfRDZ1_6DoKCsFxks8J9VBEGhkyq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 adultscore=0 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=988
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

From: David Hildenbrand <david@redhat.com>

Now that we no longer use page->index and the page refcount explicitly,
let's avoid messing with "struct page" completely.

Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-5-david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


