Return-Path: <kvm+bounces-36979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08557A23CFE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71697188B8ED
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EBD1F12F5;
	Fri, 31 Jan 2025 11:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AIllj9Ao"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821FB1EE005;
	Fri, 31 Jan 2025 11:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322725; cv=none; b=rzkmQD3iRMvMH/LNnKFgMN7lyCNI6z+fEJi3my2zURwXcAlrtnhbl5zz0C+PlXH3caThMHUWaYKMfOU+jABwR+dU3CqJoIMmC/3f/4zKnGINve+ceei1fmHyg9DTkCC4u7z9NLTM/r7G43XOmfDnQdMMx1Par8xwKcnHvF9HMtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322725; c=relaxed/simple;
	bh=cEoPayf2ZG8/NZi6117x1jQpcSZAYxr8xIrsHkxiHe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dl0iIyp0qmD200K9OyivBFYvvLENnVvirEQkTPmPqxsP2wtwGGzZLYP+ederCXA363cvLhgwcXOKCYB/KnRv++g5l7/HuN+Tpe293WOCgO/iLIJDhibsml8Judj/wtcyRoEPRRyVstoXtJaR5Sw71r1dgCTlm/h7clfaC9wZCC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AIllj9Ao; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V7XHxv010452;
	Fri, 31 Jan 2025 11:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gUkFPjtkO1VXtmSbC
	ORk16PWP3oJ6jrZZR0PIAOcQl0=; b=AIllj9AocdVoevbh+0YAFJM+2urFXiL/F
	CLtoxvSbsWjdfIriIEMFclwNZurkE+KB1z45KCe+RnQeRkdhYnmVDOk73dwdU79z
	QXszMLqQkcVcCZaw9u8FIqwo3QCCxvkCoCk3FoyXN1NAnph67t7n+fSHgb0GwqqH
	nqgR6MlsAKNTHaXt1O/Nzttt9PwjMU/db/zQLc6KePYM+kRBBo5JVtwFnlCWc2Mb
	upG8dpVcuXT9GgkZjpzokA1Lxplp8cQPAnkGWLqIAE4ra9guCPZziazjbErJ0Tt3
	3RqOvlRcXD03L25Qi6yCeMzmICiBzchjzIcvz/gUcZU6ALuCbuWbw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gt7n8v2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8RIJ0016065;
	Fri, 31 Jan 2025 11:25:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfaub8pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:18 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPF1M38338850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 153E820138;
	Fri, 31 Jan 2025 11:25:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9170320135;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:11 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 03/20] KVM: s390: vsie: stop messing with page refcount
Date: Fri, 31 Jan 2025 12:24:53 +0100
Message-ID: <20250131112510.48531-4-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: ot5_XRmuPvNH_3fWyzMFm3q1GjTUmT2T
X-Proofpoint-ORIG-GUID: ot5_XRmuPvNH_3fWyzMFm3q1GjTUmT2T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

From: David Hildenbrand <david@redhat.com>

Let's stop messing with the page refcount, and use a flag that is set /
cleared atomically to remember whether a vsie page is currently in use.

Note that we could use a page flag, or a lower bit of the scb_gpa. Let's
keep it simple for now, we have sufficient space.

While at it, stop passing "struct kvm *" to put_vsie_page(), it's
unused.

Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-4-david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 46 +++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3874a1b49dd5..424f80f5f6b2 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -23,6 +23,10 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 
+enum vsie_page_flags {
+	VSIE_PAGE_IN_USE = 0,
+};
+
 struct vsie_page {
 	struct kvm_s390_sie_block scb_s;	/* 0x0000 */
 	/*
@@ -52,7 +56,12 @@ struct vsie_page {
 	 * radix tree.
 	 */
 	gpa_t scb_gpa;				/* 0x0258 */
-	__u8 reserved[0x0700 - 0x0260];		/* 0x0260 */
+	/*
+	 * Flags: must be set/cleared atomically after the vsie page can be
+	 * looked up by other CPUs.
+	 */
+	unsigned long flags;			/* 0x0260 */
+	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
@@ -1351,6 +1360,20 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
+/* Try getting a given vsie page, returning "true" on success. */
+static inline bool try_get_vsie_page(struct vsie_page *vsie_page)
+{
+	if (test_bit(VSIE_PAGE_IN_USE, &vsie_page->flags))
+		return false;
+	return !test_and_set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
+}
+
+/* Put a vsie page acquired through get_vsie_page / try_get_vsie_page. */
+static void put_vsie_page(struct vsie_page *vsie_page)
+{
+	clear_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
+}
+
 /*
  * Get or create a vsie page for a scb address.
  *
@@ -1369,15 +1392,15 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	rcu_read_unlock();
 	if (page) {
 		vsie_page = page_to_virt(page);
-		if (page_ref_inc_return(page) == 2) {
+		if (try_get_vsie_page(vsie_page)) {
 			if (vsie_page->scb_gpa == addr)
 				return vsie_page;
 			/*
 			 * We raced with someone reusing + putting this vsie
 			 * page before we grabbed it.
 			 */
+			put_vsie_page(vsie_page);
 		}
-		page_ref_dec(page);
 	}
 
 	/*
@@ -1394,7 +1417,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 			return ERR_PTR(-ENOMEM);
 		}
 		vsie_page = page_to_virt(page);
-		page_ref_inc(page);
+		__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
 		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = page;
 		kvm->arch.vsie.page_count++;
 	} else {
@@ -1402,9 +1425,8 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 		while (true) {
 			page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
 			vsie_page = page_to_virt(page);
-			if (page_ref_inc_return(page) == 2)
+			if (try_get_vsie_page(vsie_page))
 				break;
-			page_ref_dec(page);
 			kvm->arch.vsie.next++;
 			kvm->arch.vsie.next %= nr_vcpus;
 		}
@@ -1417,7 +1439,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 
 	/* Double use of the same address or allocation failure. */
 	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
-		page_ref_dec(page);
+		put_vsie_page(vsie_page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
 	}
@@ -1431,14 +1453,6 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	return vsie_page;
 }
 
-/* put a vsie page acquired via get_vsie_page */
-static void put_vsie_page(struct kvm *kvm, struct vsie_page *vsie_page)
-{
-	struct page *page = pfn_to_page(__pa(vsie_page) >> PAGE_SHIFT);
-
-	page_ref_dec(page);
-}
-
 int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 {
 	struct vsie_page *vsie_page;
@@ -1489,7 +1503,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 out_unpin_scb:
 	unpin_scb(vcpu, vsie_page, scb_addr);
 out_put:
-	put_vsie_page(vcpu->kvm, vsie_page);
+	put_vsie_page(vsie_page);
 
 	return rc < 0 ? rc : 0;
 }
-- 
2.48.1


