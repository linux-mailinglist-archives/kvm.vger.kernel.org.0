Return-Path: <kvm+bounces-63910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0C2C75ADA
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:31:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9FC454EA4A8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D16374122;
	Thu, 20 Nov 2025 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mmxuYCUF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C35371A1E;
	Thu, 20 Nov 2025 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659008; cv=none; b=Es7FKD+Z7Ckgh2hsvAlckrhojBuXOjnRjKSu+d95EleSOOMm8Bd2E4ddcGvr8PxGPOST9WSnYBU5BPxNkUSyptp7B7FPlY7DthlT0oUtuDnLLlhOZlxM2cJ4YtkirEuUclWezncpZ7kk7eCNLfO/T7NPpUTfy3tvJiqrOGceq8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659008; c=relaxed/simple;
	bh=9w3KrEBUUoHASQroqDJK/+seXCXIx5t9hTDKXw0V/18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFLpFBP+Rb8uDE/UyFPXuR9An8QtMiuvRAczhC2KdCgQYLNIOdMAMkDUiNgWcdtpFHyNiCinx50kTULgVcd+qVKngT8rGWMgnDOOPUy9sQlj90q4kTdroUaHqV08hoXiHpgiP1fjrizgX6R+BANHr5bVqOwC629KVePp9iybOCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mmxuYCUF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKBLPkN027938;
	Thu, 20 Nov 2025 17:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=30t+ezeghrBcC+FAT
	idHtdc9l6Wv1PVVvnvIKELOl4I=; b=mmxuYCUFXH7/02RsBWbB148/DgeQS6kUc
	BOXIqLgvYA6LmEMZnSbGxIU018tUwcEkHyrcxZm1uF4YHvhFNuYblyow5Xf54y4E
	skrKhbhm9naOnSAogZh4nCkHYgZjki46OKZ7o0JEenfBSCOCa7X2HLP3qAXKHc9e
	NZK0pFZMBcYMUwyAD62sq8Kfds0TmNThDmUx5DD1QHhC8RP2jrK3AD30iYeTz85u
	2W/JjJXEhumUn1Dn0nMrLih+QrnwKIoqZxNz7xxdGv5cOnL9P432H+d+911aleWV
	kyBpYagZt2Epnw07tI7lGEqN4rS4HM565IQA7P+lj+lPSAZYPdOgw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka7n1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKEPso3022340;
	Thu, 20 Nov 2025 17:16:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un7mhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHGUOQ50004320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:16:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE43E2004B;
	Thu, 20 Nov 2025 17:16:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98E4820040;
	Thu, 20 Nov 2025 17:16:28 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:16:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 22/23] KVM: s390: Enable 1M pages for gmap
Date: Thu, 20 Nov 2025 18:15:43 +0100
Message-ID: <20251120171544.96841-23-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120171544.96841-1-imbrenda@linux.ibm.com>
References: <20251120171544.96841-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rBDDP7gbyOX0At1NtdmUjuFksWw2RFNV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXyVD9W50PbDis
 bsnWg9gZu6G2DCg79YT3+ldWrEXjh2TO9OV6OsPS87Blrsj3CM0L39Q3M08CNyP4WkpljiQc5dX
 slWLKQSSaUM9R6edV/qWTTUe226KG33LQ/53DtsyBLGSrRZ5TTkCTx2LHtfdQOIVcjadkeDLcq2
 ykAse1FPFP26/rHu8h5kZlrYMtSPNu+YOMeZkoYV5+6G6fKXtraEoyKGtgRhYOyPC4Ws2PVMUsE
 WAO3wivT6ymCKKXRTj4ObuCREH/cc4kGHAYk0JzlueplBeBHtuOTxNSCywEJl/vk3B11ARZVub4
 ApDxS7aCnADJg9P97ssEWOh9B2VJEPrqx+bu7C5Muky6qFHKWM/R2wozwEiPnJMCKFS9BMatZyQ
 FDEPS9/q+jznn7tuZ3/VCNMhgXPJzw==
X-Proofpoint-ORIG-GUID: rBDDP7gbyOX0At1NtdmUjuFksWw2RFNV
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691f4cfb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2DwSK8QdlStOok5YbGYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

While userspace is allowed to have pages of any size, the new gmap
would always use 4k pages to back the guest.

Enable 1M pages for gmap.

This allows 1M pages to be used to back a guest when userspace is using
1M pages for the corresponding addresses (e.g. THP or hugetlbfs).

Remove the limitation that disallowed having nested guests and
hugepages at the same time.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c     | 2 +-
 arch/s390/kvm/kvm-s390.c | 6 +-----
 arch/s390/kvm/pv.c       | 3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 502012c0dfad..ef4190f56ae9 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -591,7 +591,7 @@ static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
 
 static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
 {
-	return false;
+	return gmap->allow_hpage_1m;
 }
 
 int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c8662177c63c..b7dc1d601fb8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -849,6 +849,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
+			WRITE_ONCE(kvm->arch.gmap->allow_hpage_1m, 1);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -5837,11 +5838,6 @@ static int __init kvm_s390_init(void)
 		return -ENODEV;
 	}
 
-	if (nested && hpage) {
-		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 16; i++)
 		kvm_s390_fac_base[i] |=
 			stfle_fac_list[i] & nonhyp_mask(i);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index d8a5c7b91148..8ea5f8d7e714 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -621,6 +621,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
 	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
+	WRITE_ONCE(kvm->arch.gmap->allow_hpage_1m, 0);
+	gmap_split_huge_pages(kvm->arch.gmap);
+
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-- 
2.51.1


