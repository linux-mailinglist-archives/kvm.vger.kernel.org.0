Return-Path: <kvm+bounces-36899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F2EA22ABC
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FBE43A7DE8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061221BBBFD;
	Thu, 30 Jan 2025 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dxqkhp/K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6E01B6D02;
	Thu, 30 Jan 2025 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230689; cv=none; b=BhdwyfsbMtVW+UiAorely6oN7ylqm0W4Gh7+Sl+G0DpegiSE428xOvttUZ8YfQLHbp8Ram1+8XbTeie7WcJHRa58loCYXAjWPR45Vrp0aiPdwSZt2Wek6Xn5ICCt/RZfewvpYxbcosA6K8/aXw4+CiA0pGFp2GYQyBuxdUJge2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230689; c=relaxed/simple;
	bh=9qbIHAKCOPtJuDEvT+CzNqOkPIfcP1/JF8ktIvAg+d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwmolFWDxkJ4ZyhNjJ5yQ8Shu75qissDvDPRqyTpFz1ral/JfAXXIaiNaloNeehz7Xy7psHx5mJWKYVmpBwswheiAx6PmZKzMql7c5sADBb7Rlax2/rcWvO8HEyQEzghBJVIfKs1Yn0eotwMrxBAT19WxVxkfiDe+hrHcJFvQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dxqkhp/K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U20hFK019630;
	Thu, 30 Jan 2025 09:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5PR5fvX2gP1VrSwye
	kMLTunymmMMmfvcF+DgwWXxLcA=; b=Dxqkhp/KJ74O4Zb+xr0aMgZrWHBaQiAsd
	k3wj/HZ14loOvFAvB64dX9OS+S0e/QJy/grh81Tq3w/wGAr0SyWocpV336px+OKL
	wfG1xPMZi1WmjbeuMApEUuKpDl9PAIV9Uj0MMAzyShZvWmdP5wT1oOv3zFDLfufV
	sSnJE2fJTePETyNb79mwufc4c7v6/HBrX1O5QdfRky4ODbcOMjfjZ7roHs2URfHY
	0HnLWCUrnLE8XXomm2zPgHEbGCUf6Az/Jhp1L8e7uqowgcb0q3jWPI8UHtE3O1rE
	KRCptNclnExyDOQOMhxAzh/iXO7Z5pb/PV/td93t3IM+0g1ZpXwVQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g08ysnna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U9Ompq018922;
	Thu, 30 Jan 2025 09:51:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dd01n51g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pJ5f26083638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93D3A20147;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B39D20146;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 01/20] KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
Date: Thu, 30 Jan 2025 10:50:54 +0100
Message-ID: <20250130095113.166876-2-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 3o9Yav3IEyFubFhJGYUN0HdyXYxZuikG
X-Proofpoint-ORIG-GUID: 3o9Yav3IEyFubFhJGYUN0HdyXYxZuikG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300069

From: David Hildenbrand <david@redhat.com>

We try to reuse the same vsie page when re-executing the vsie with a
given SCB address. The result is that we use the same shadow SCB --
residing in the vsie page -- and can avoid flushing the TLB when
re-running the vsie on a CPU.

So, when we allocate a fresh vsie page, or when we reuse a vsie page for
a different SCB address -- reusing the shadow SCB in different context --
we set ihcpu=0xffff to trigger the flush.

However, after we looked up the SCB address in the radix tree, but before
we grabbed the vsie page by raising the refcount to 2, someone could reuse
the vsie page for a different SCB address, adjusting page->index and the
radix tree. In that case, we would be reusing the vsie page with a
wrong page->index.

Another corner case is that we might set the SCB address for a vsie
page, but fail the insertion into the radix tree. Whoever would reuse
that page would remove the corresponding radix tree entry -- which might
now be a valid entry pointing at another page, resulting in the wrong
vsie page getting removed from the radix tree.

Let's handle such races better, by validating that the SCB address of a
vsie page didn't change after we grabbed it (not reuse for a different
SCB; the alternative would be performing another tree lookup), and by
setting the SCB address to invalid until the insertion in the tree
succeeded (SCB addresses are aligned to 512, so ULONG_MAX is invalid).

These scenarios are rare, the effects a bit unclear, and these issues were
only found by code inspection. Let's CC stable to be safe.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-2-david@redhat.com>
---
 arch/s390/kvm/vsie.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index a687695d8f68..513e608567cc 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1362,8 +1362,14 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
 	rcu_read_unlock();
 	if (page) {
-		if (page_ref_inc_return(page) == 2)
-			return page_to_virt(page);
+		if (page_ref_inc_return(page) == 2) {
+			if (page->index == addr)
+				return page_to_virt(page);
+			/*
+			 * We raced with someone reusing + putting this vsie
+			 * page before we grabbed it.
+			 */
+		}
 		page_ref_dec(page);
 	}
 
@@ -1393,15 +1399,20 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 			kvm->arch.vsie.next++;
 			kvm->arch.vsie.next %= nr_vcpus;
 		}
-		radix_tree_delete(&kvm->arch.vsie.addr_to_page, page->index >> 9);
+		if (page->index != ULONG_MAX)
+			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
+					  page->index >> 9);
 	}
-	page->index = addr;
-	/* double use of the same address */
+	/* Mark it as invalid until it resides in the tree. */
+	page->index = ULONG_MAX;
+
+	/* Double use of the same address or allocation failure. */
 	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
 		page_ref_dec(page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
 	}
+	page->index = addr;
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
 	vsie_page = page_to_virt(page);
@@ -1496,7 +1507,9 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 		vsie_page = page_to_virt(page);
 		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
-		radix_tree_delete(&kvm->arch.vsie.addr_to_page, page->index >> 9);
+		if (page->index != ULONG_MAX)
+			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
+					  page->index >> 9);
 		__free_page(page);
 	}
 	kvm->arch.vsie.page_count = 0;
-- 
2.48.1


