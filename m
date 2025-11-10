Return-Path: <kvm+bounces-62537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3012C48438
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 978141888B7A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF5729C347;
	Mon, 10 Nov 2025 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pz4OGG3S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D08229AB05;
	Mon, 10 Nov 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795070; cv=none; b=dEJEG2wbAilP7q7B8cC1QKtuqT37K+vQb15qVPQsf/YvZk2FQPxYaAwz9/oP9ncNgtXMBHG6OnTQRd4BvbgP+cmUYGcLZoZpQA275c5Fy6v3Gq/0g6VRXNCzYpZVS4RhbELY0cm24x85gZ9E3/Xqw46G4dRfDlrYAm5zH7h6mbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795070; c=relaxed/simple;
	bh=YhOAMZrWwpSuik8tnK4JbmvBbRKwKU42odZUPcncLe0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hqi8ELjgt9f1kOgFb0Y6Z4WRI+PdfeUj0DnzZ1ZhkFgUxLrjJjk3sIIbacNcVU/i4WL0Rr6Mwiu3h9s+mmjCo2qvrWD+AIk/z6Xcq+dl94h9TKrlZyRE4blR9ymylgddhEk9jhK4PZxmHJ1Pb0263uLSbZfmEPj6AgqO2De6jBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pz4OGG3S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA9j5WZ016918;
	Mon, 10 Nov 2025 17:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FGzBac
	L3gy2rnw0msC/5YahufB3D9ztjbRTAr72S3jw=; b=Pz4OGG3Sg/lPiTkTTrjDMP
	74tYhe/1K9y0oh9Bi5lrg/dEkqJSbeXKtJprItVAu5XrdVObOfz1dBe87Gjm8J30
	65UjN1vnXDPdIO/KHqbJ1HNJQHTF7WcSSeuDpphyAZn8k/jQVHWfSLp2w/EMoN6X
	necRaQCuvCrnqL9EZGQ/JOMcTSOr8cgMkHvtIF4vwNyu3ZAVgu7BAKr2q0vPcngY
	gyfN4jtt2N2+veDb/OcQ3IlOFC0JJlWWbJtzT+32iZu3zIg4V8WbHJj/ot0D+Rjz
	Em8fpPidTIxAp4WdoHM8wZeTfR0JrtBhdL0VTsEA+6aSe6UqCZXKF0hbUcuKPOhA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGcHIl011738;
	Mon, 10 Nov 2025 17:17:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw16en0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHaEc35717494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E45920040;
	Mon, 10 Nov 2025 17:17:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B65E020043;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:46 +0100
Subject: [PATCH RFC v2 06/11] KVM: s390: Add helper to pin multiple guest
 pages
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-6-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
In-Reply-To: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4173;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=YhOAMZrWwpSuik8tnK4JbmvBbRKwKU42odZUPcncLe0=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctoGQfNzhc/0zvlj8PMWa9+mf41FgpuVfq+x+KfTp
 5YleWRDRykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABOpd2FkaLpc1Nz39VBKY4Tn
 7rsnE/6Hz5l703uKs0POrusXJk1LOcnIsD3lyDK5z4zlbly7Dp7mfq8iYZfa17uj5LuCXGrD1UB
 bDgA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXwGyHpT+V+k2v
 21zm6pXmXfKuRoIvhPeUyO5NurySQieMhNr4B2ZUZ2S6Ytcra5ltsy7fgKeXF83aHuzjYJrD2PA
 MNBMStDyDafA35NuovZpT0u932RfbFsxRSurBxeZ/OOQosNkTyPF5VtfXBi+DnUX/wf0ZEB3zkG
 0QPocx5O+WeMTrW98O4W56oycbRH3obcVz04H2TCHGKYASYaxIrhOISwUY1KabwmR5EF2/PJ+g/
 C6HX91NPO7RBXZhKAqafcEw1qeYz5vi+WVliSE/1qU3tY+BdRCIeSiwFH8I0cFi2rztxMP4IV7E
 qXMEt/WylfWq5KMQv9CImemirMty/aviz3oRHtyvvk/S2IDwnD7MlBEsZXL/kn5UzkcFCz1RSlr
 l1QICuLMJD1c6Ar4wWHk8eyd2dadnA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e35 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=OACYVtGxoUifLQ29P6oA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: wxyk0h7_dagrqPwZxo9zHmwe3NMsIqX3
X-Proofpoint-GUID: wxyk0h7_dagrqPwZxo9zHmwe3NMsIqX3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

In the main patch of this set we need to pin and unpin multiple
consecutive guest-2 pages in guest-1. As these might not be consecutive
in guest-1 it is necessary to iterate over all pages and store guest and
host addresses for later use.

As the new methods to use the existing {,un}pin_guest_page() methods
these are moved up unchanged in the file to prevent to have to resort to
forward declarations later on.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 91 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 65 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3d602bbd1f70b7bd8ddc2c54d43027dc37a6e032..e86fef0fa3919668902c766813991572c2311b09 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -67,6 +67,11 @@ struct vsie_page {
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
 
+struct kvm_address_pair {
+	gpa_t gpa;
+	hpa_t hpa;
+};
+
 /**
  * gmap_shadow_valid() - check if a shadow guest address space matches the
  *                       given properties and is still valid
@@ -159,6 +164,66 @@ static void write_scao(struct kvm_s390_sie_block *scb, hpa_t hpa)
 	scb->scaol = (u32)(u64)hpa;
 }
 
+/*
+ * Pin the guest page given by gpa and set hpa to the pinned host address.
+ * Will always be pinned writable.
+ *
+ * Returns: - 0 on success
+ *          - -EINVAL if the gpa is not valid guest storage
+ */
+static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
+{
+	struct page *page;
+
+	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+	if (!page)
+		return -EINVAL;
+	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
+	return 0;
+}
+
+/* Unpins a page previously pinned via pin_guest_page, marking it as dirty. */
+static void unpin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t hpa)
+{
+	kvm_release_page_dirty(pfn_to_page(hpa >> PAGE_SHIFT));
+	/* mark the page always as dirty for migration */
+	mark_page_dirty(kvm, gpa_to_gfn(gpa));
+}
+
+/* unpin multiple guest pages pinned with pin_guest_pages() */
+static void unpin_guest_pages(struct kvm *kvm, struct kvm_address_pair *addr, unsigned int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		unpin_guest_page(kvm, addr[i].gpa, addr[i].hpa);
+		addr[i].gpa = 0;
+		addr[i].hpa = 0;
+	}
+}
+
+/* pin nr_pages consecutive guest pages */
+static int pin_guest_pages(struct kvm *kvm, gpa_t gpa, unsigned int nr_pages,
+			   struct kvm_address_pair *addr)
+{
+	hpa_t hpa;
+	int i, rc;
+
+	/* the guest pages may not be mapped continuously, so pin each page */
+	for (i = 0; i < nr_pages; i++) {
+		rc = pin_guest_page(kvm, gpa + PAGE_SIZE * i, &hpa);
+		if (rc)
+			goto err;
+		addr[i].gpa = gpa + PAGE_SIZE * i;
+		addr[i].hpa = hpa;
+	}
+	return i;
+
+err:
+	unpin_guest_pages(kvm, addr, i);
+	return -EFAULT;
+}
+
 /* copy the updated intervention request bits into the shadow scb */
 static void update_intervention_requests(struct vsie_page *vsie_page)
 {
@@ -718,32 +783,6 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
-/*
- * Pin the guest page given by gpa and set hpa to the pinned host address.
- * Will always be pinned writable.
- *
- * Returns: - 0 on success
- *          - -EINVAL if the gpa is not valid guest storage
- */
-static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
-{
-	struct page *page;
-
-	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
-	if (!page)
-		return -EINVAL;
-	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
-	return 0;
-}
-
-/* Unpins a page previously pinned via pin_guest_page, marking it as dirty. */
-static void unpin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t hpa)
-{
-	kvm_release_page_dirty(pfn_to_page(hpa >> PAGE_SHIFT));
-	/* mark the page always as dirty for migration */
-	mark_page_dirty(kvm, gpa_to_gfn(gpa));
-}
-
 /* unpin all blocks previously pinned by pin_blocks(), marking them dirty */
 static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {

-- 
2.51.1


