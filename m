Return-Path: <kvm+bounces-62186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD47C3C0D9
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 16:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF5253ACE58
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 15:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD7B2737F3;
	Thu,  6 Nov 2025 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pgAu75m5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D291EEA5D;
	Thu,  6 Nov 2025 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762442755; cv=none; b=F1+MLUw4EOM4dTGFeqRb9MWrtNG6pMQN6PfLNKim5dDOnZpt3AZLtmk5BzLoXYx5osi9IgOP+EOPDlUa4g/P4snvIoB+sIm9oTHWrLf/ugsMREUIBiUXjvAg57QtZMJmb8H9h3IkatLDAbPXCslqAAAcSRu/VTS9z3uoA9KjkiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762442755; c=relaxed/simple;
	bh=6iOjcSAxs3NxY9p5Z8vOb47o67EQ2so0Ix8yDCMTguI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qh2KfO0U3exbJJSI5K0H9CC7hoHC6Rt/dC9BKHKhgOGDg7D62nwoDtzjXUxiyRqAhvh10j3oBWLL6QkCBnneLXXBcU2eb2Qz4dL1mXHa7Dz5GEKGBpdjXypDkVy9wUO7tsOYH0JKT1bc0KneJbl8anYNm8AW/jqb5S/4L2VVUqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pgAu75m5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FF8iF009215;
	Thu, 6 Nov 2025 15:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=mtsa329fUtQbDlBUnISqk9oEEDR1m5/u3hkXhk6pG
	Zs=; b=pgAu75m5IL45mlIeS1eY+G9JVK/VDS9W4kK01MCGGiR1lxnnqQf0fnbSm
	kZW8tAKFpxzZkgu9XSnCUoyzK1Sj69wkwfDQuMqmnX5PQ9lk3FDF7DizDzqOWD6O
	v9D3m/3CoAjd+6Xlxn3E3gS/iCHCncsQg9MwuvN71v1hpg1+wtFmnqq+bRNcfuia
	daQBjZA0GAayQmZhQ5RhyvOZKbbaNVARwfmT5zb1p/ccUs2KRrXDk/z72U5K19by
	xOM0CAo+GrxR6r1H7gh0rN2a+frmCExz9qz0UCoRU5rLcEy3cNRLtImjp6aSipm4
	yPT2jgJIJcV/8RhWHlBp9yFVswSog==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59q97y9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 15:25:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CdwoS012875;
	Thu, 6 Nov 2025 15:25:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y825udp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 15:25:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6FPkh454657462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 15:25:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82B5020043;
	Thu,  6 Nov 2025 15:25:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BBB820040;
	Thu,  6 Nov 2025 15:25:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 15:25:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mhartmay@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, ggala@linux.ibm.com, david@redhat.com
Subject: [PATCH v1 1/1] KVM: s390: Fix gmap_helper_zap_one_page() again
Date: Thu,  6 Nov 2025 16:25:45 +0100
Message-ID: <20251106152545.338188-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=StmdKfO0 c=1 sm=1 tr=0 ts=690cbdff cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=hc2NwQUhtlEWUF91VgoA:9
X-Proofpoint-ORIG-GUID: PPbXzuvdWZmfUfVvDHg_xbUhVffvJ9Qq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAxOCBTYWx0ZWRfX/ouv/e8mabm4
 +nrjP7XCRoqBndZr4vqYW21w/zxq9maqd+c8/AXH1LbDl54gZ8jhgXUH2VPEg2hqbQmzob9V1Ji
 /kLqiIPRuzBh0b01VOEZ+mtgXPANFMdxLcuvZDYXT2DH9NfweC1xlHBqW433cNsIKlhrTbe4rnG
 ohneebLB2xTKSVRu3NOqE52NV0X3/+tmAahiPkcYBvj2ltQZDLzTLoXLOE8a8w5xl+MnJuQFOiD
 G9RLxg6UHtMEpehMYLbvdg9WenE33k637fQ1FlFpmKYLxi+at1amleYts1CxJeTj957wpymFrt3
 Zl+oJx3tz4EbfqlkGgnGi1aa1tXgbUMUTFQjTxXz01bfVRa7WzKoFhEdfSxTceYn7a1DOcST0C+
 TsMhe3UHHHmJJyxqXm+RZxEklzV1GQ==
X-Proofpoint-GUID: PPbXzuvdWZmfUfVvDHg_xbUhVffvJ9Qq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010018

A few checks were missing in gmap_helper_zap_one_page(), which can lead
to memory corruption in the guest under specific circumstances.

Add the missing checks.

Fixes: 5deafa27d9ae ("KVM: s390: Fix to clear PTE when discarding a swapped page")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/gmap_helpers.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index d4c3c36855e2..38a2d82cd88a 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -47,6 +47,7 @@ static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
 void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 {
 	struct vm_area_struct *vma;
+	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
 	pte_t *ptep;
@@ -65,9 +66,13 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 	if (pte_swap(*ptep)) {
 		preempt_disable();
 		pgste = pgste_get_lock(ptep);
+		pgstev = pgste_val(pgste);
 
-		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
-		pte_clear(mm, vmaddr, ptep);
+		if ((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED ||
+		    (pgstev & _PGSTE_GPS_ZERO)) {
+			ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+			pte_clear(mm, vmaddr, ptep);
+		}
 
 		pgste_set_unlock(ptep, pgste);
 		preempt_enable();
-- 
2.51.1


