Return-Path: <kvm+bounces-55628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0000B3457A
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A564B482EED
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4C82FE575;
	Mon, 25 Aug 2025 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Mfs8PI9E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B7D2FD7A0;
	Mon, 25 Aug 2025 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135123; cv=none; b=ICxMhYJUGIJ+s+H+7ESsnt7kp/8evPze3/T/xAh33fQ4VXaif4Di5xww5ueL91rl+DNro8BkyyZ2w4d98nnAURv2iILDzZ2Jw2EHhK3mSALQQ9hXEKdNnRmaKrRL3/5trYNh/zQNpxewwNYCVmcfolkRE6AeUU/hANnkRxiRrMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135123; c=relaxed/simple;
	bh=9jue979FcYfxOki+KK2bWILOLINI7UkesT2kcaszFMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcDS7TY0uOAV5so68r5FRKVPzPJ5nY8Nd6Ktslhv7zimJ9Ib4ZD/eh3uZUE8Hzrkg+Zt+8R3/eZOamqJ1IfqHk4s/6AQWnl+ZqEhZ6kGMGvx5QHCtlVXZBQgSdlV3OksTOfRmQVujqKPXuNB49rRUl+yrw2QLF4ok8R+2RJ70Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Mfs8PI9E; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBPvdq006945;
	Mon, 25 Aug 2025 15:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Yo1FPoaVzx2q+Fti4
	CXZWKIPzgzsSpuXAaNRBu5K/5A=; b=Mfs8PI9E+x6FWpXrF57+BOiIrxx137p5G
	RTlGy1tt+qXVQHdcBgyWPVxSIMTSpGzuft62UpkNFyd6YYpeLc8mQQAq7FZEn4UL
	GCwFFcQm/1pEKUnAlFvUrD5+OiSA6Qz8JAfUOGmNPePFKkrvFmucd2G2SlQjVIgL
	VXpShNm78XeoJ1/N8oU9wEbb6OaCp0fKxPI/YVbA0cYqRUlrPJlHkf7ifvRPEtXE
	0LBQ6whQyjX7VJ9kAZJB5pzI7HQb5+MmXK2BKf1Qbtj5UesAD/bqqLKRpkogtXDM
	k9YDEjQHhf8bbiBWd9b8kdLmGwDXDrtlImb1TEe3i+JeMJvDRpmuQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557srj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PEf8en002512;
	Mon, 25 Aug 2025 15:18:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qt6m68w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PFIX9G34538030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:18:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A32E020049;
	Mon, 25 Aug 2025 15:18:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AABE20040;
	Mon, 25 Aug 2025 15:18:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.17.238])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 15:18:32 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v3 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Date: Mon, 25 Aug 2025 17:18:31 +0200
Message-ID: <20250825151831.78221-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250825151831.78221-1-imbrenda@linux.ibm.com>
References: <20250825151831.78221-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Dwi4QutgdwYqIGE9ccIXygT9ZEFCAov0
X-Proofpoint-ORIG-GUID: Dwi4QutgdwYqIGE9ccIXygT9ZEFCAov0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX+Bxj+qb3lFAd
 WsyvUC24TVM5XApsgEKtcEfk8qvOr0RjOtBOxux9AZUEZ0YuCQ+C+UTvZf1HOBTIeENu8eHMPWG
 AQiRLKW8Q5KrcaYiPnunut6/Rakftzm6xhqwP9N7izARacCNBBFUGen6fKYOeDLiNMQuCopp3It
 r8HHHn9Sub/hX25X40x6BE7dXFEWReoL/EQjwXrUW0UqoJQMK/uoYkzRIzaawGfxg+tvFsyAd3Q
 sWKnu1+L1gongosv1cAxrhHY2xq0stnxljfP5/23tneBxwgKAggai+tEWzwlLeD6ch8/90QtZV4
 y1QVk2H0yuzM7njklAvESXGf0FHk5IGk/nxNNECbN6X3EOJ2ZUQYJEuMyNaFAC6eYEKDwAltDrR
 Q6U8VcjO
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68ac7ece cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=hH8_rHouDUwXcPhP104A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
instead.

This still works because they happen to have the same integer value,
but it's a mistake, thus the fix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d5ad10791c25..4280b25b6b04 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4863,12 +4863,12 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
  * @vcpu: the vCPU whose gmap is to be fixed up
  * @gfn: the guest frame number used for memslots (including fake memslots)
  * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @flags: FOLL_* flags
+ * @foll: FOLL_* flags
  *
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4882,13 +4882,13 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return vcpu_post_run_addressing_exception(vcpu);
 
-	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
 	if (vcpu->arch.gmap->pfault_enabled)
-		flags |= FOLL_NOWAIT;
+		foll |= FOLL_NOWAIT;
 	vmaddr = __gfn_to_hva_memslot(slot, gfn);
 
 try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 
 	/* Access outside memory, inject addressing exception */
 	if (is_noslot_pfn(pfn))
@@ -4904,7 +4904,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
-		flags &= ~FOLL_NOWAIT;
+		foll &= ~FOLL_NOWAIT;
 		goto try_again;
 	}
 	/* Any other error */
@@ -4924,7 +4924,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	return rc;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
 {
 	unsigned long gaddr_tmp;
 	gfn_t gfn;
@@ -4949,18 +4949,18 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 		}
 		gfn = gpa_to_gfn(gaddr_tmp);
 	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
-	unsigned int flags = 0;
+	unsigned int foll = 0;
 	unsigned long gaddr;
 	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 
 	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
@@ -5002,7 +5002,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -5012,7 +5012,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.51.0


