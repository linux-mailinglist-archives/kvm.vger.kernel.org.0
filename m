Return-Path: <kvm+bounces-66506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D65E5CD6D28
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E50730CECEF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C2B34A3D0;
	Mon, 22 Dec 2025 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FGUfMaQw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3C3491F3;
	Mon, 22 Dec 2025 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422281; cv=none; b=VqEv53Xdi9dAFE+V4TU7usHObpo/P7oECjrmWNmxmArSy2iTAX1HbNNzDscQwkVkUZtRqcsvog41k8WI0QM1pG7xfvumlqLFz+NruIV4zjh8E+4KLnVTqclA46/M4AXJxGWSL9cFU1NVFyY5qowyaMpVkS51UA3P5xTEJY7zTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422281; c=relaxed/simple;
	bh=mA/FSA+uMJsFbEP0CQxI3MfRaZY3f8VFSRZWLARf0No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFiSwVJkLOrFUHO3JlZa1R2SKqcAvrR1HiC+qLBEt1EY2KR+60u6Ro7k5J4EH3c/Y7xEyU19ayI4hW7dZaYcZiEkguCaL8+9CReOGRP3q9z6hGdZe++9l8nDdB4cefm5LwwV5v5FP8bfXS0YxJxBleM1z+qN7j5Fvq8tZrUyITE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FGUfMaQw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM7bGlj029926;
	Mon, 22 Dec 2025 16:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+20bgMpLDfPW1Ozr7
	f7qrf3uxA2kaHdzcHQeh221P9I=; b=FGUfMaQw9U2752RfdH79NyP+yLaKFfuEj
	a1JptFDeWgBDynEB/y6QHPAk+R5s7AlH5MVk8RiYliDR2AeECsn7/OxOXyzlaha7
	3tkV2d2uwCv8+sYv1PtWQ+u2BLLUNmlp1JIDUUdQyr8K5pf3dxWdvTrOLfwB0Ksn
	+A5mGTTiih5B8HMO7DfcXkU1EfTCYrKHyI5d8K5ohWZMfC1itvCsedtecCPHXHT9
	sQDLokMORTLF40xg0ibm49J3D8WwpHKnVBcf9xvHWBGPosi44/BsH+RNXRWeJtTU
	3Z4IImLf0tj/ntoRI5IcivpahDE5C+qPVhZDXlBEUed03XrGJUptQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kfq16yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMFeVxA030236;
	Mon, 22 Dec 2025 16:51:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b66gxq981-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGpBnH17498398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E57B20040;
	Mon, 22 Dec 2025 16:51:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EE5E2004B;
	Mon, 22 Dec 2025 16:51:10 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:10 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 27/28] KVM: s390: Enable 1M pages for gmap
Date: Mon, 22 Dec 2025 17:50:32 +0100
Message-ID: <20251222165033.162329-28-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=carfb3DM c=1 sm=1 tr=0 ts=69497704 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2DwSK8QdlStOok5YbGYA:9
X-Proofpoint-ORIG-GUID: 29k4ER3uXhNexO0YwCGJAFoHqa0l1Rgd
X-Proofpoint-GUID: 29k4ER3uXhNexO0YwCGJAFoHqa0l1Rgd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXzt9y4qRVIGr6
 AvoLU8Vn5M+/WaLbqcyg7M4p+jswStCJOY2U2q3o1zrLFahGmjyBtlhIrlL0/49S0XRaAWr1Zoy
 dTT10T2Y7OwpAikxUxR0JIo932As1WhoI6Qj8Kc48+/zqEkyWKb6+iIsMpDF/Cm3dGZLBoIZC76
 UeOLtQtIlxfZiTveTzjZDiDPBzehYExPDVcVwI9YIUexa+o6ii/qeyCl7trJyDBo8h0vXOprDQO
 LQqXCO6p5IG5b9rS+zHn45ag8EPmqkXQYbujQBVsCxjRXt13MGCe+BGT41DhQzSRJ8fq4NG2ia7
 s2mMJfqisY6O38A40eHusHlN904SHwWDLkrpa1F0qtyWOeTdO33KyK/lG7RMf8jUoDISBXS8WCW
 E8puZfrDpDfug99cXbvaXNfZPAeK6v/ukgMPzLVl0vnPrVnsL9zsMqvFhFM59ncIk5sOWhbDl4S
 vX7OQqiolamYNeMJvEQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

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
index 0abed178dde0..19392f3b398b 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -617,7 +617,7 @@ static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
 
 static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
 {
-	return false;
+	return test_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &gmap->flags);
 }
 
 int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a714037cef31..47f2794af2fb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -851,6 +851,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
+			set_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -5739,11 +5740,6 @@ static int __init kvm_s390_init(void)
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
index b6809ee0bfa5..456c96a1c44a 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -721,6 +721,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
 	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
+	clear_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
+	gmap_split_huge_pages(kvm->arch.gmap);
+
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-- 
2.52.0


