Return-Path: <kvm+bounces-41440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 774BEA67C6F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 028A2176010
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBF22135B8;
	Tue, 18 Mar 2025 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mzWyyQp7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3F121325F;
	Tue, 18 Mar 2025 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324389; cv=none; b=OALekVvhsJoBu9ZENljyIeseD8h91VyhqKVvH1cAAN+Pwp3yCFGwAD7WXOW7wWIq9cFUQcsRKkG5XxiYCSGyoHDoKxQ+2gKadllFQGZY8hYqhINXHGvQTCNNazVVA9n/7yJs4Xkoy3A599l+qiH/Qb4GkvyaqiBCLwbr08savZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324389; c=relaxed/simple;
	bh=n6b1QuAg3mwxkdMn9l/9UhneNjRCx0Q61T5fok9hYAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTygafsO1oWv/jzCHKFY7oK1FnaV+sGTq7dr2SoIRU3IEl0veB9squQ4UP4nl/Y6Je6A88meqqIpbh9s1QlNs3g+I32RC4XXNwfp5X4+oHRu/s0OcpUm9nQxIO9rKKoQuR6GfpujZl4KwBd2EpsWpotyb9qOAjLzJkOcVJr3TqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mzWyyQp7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52IGxP91032589;
	Tue, 18 Mar 2025 18:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FddQ5o
	UzNN8LdupxzjNPAiwNYnjiK3YssmP1EoBRKIc=; b=mzWyyQp7qsfXJy5pfBNQsz
	sLiPCe8N2iVRHl6XM1h4jX8+XEEleBQt9B4T1+hw9P+OfoXqwqN8tNsIXdEhBmZb
	xZay+wZJTxz7mZPSsEPg7SkAKILLQUvSWFno3g3hSA/7+qY1boKDHeMpQNX3SeYV
	9BScTBtvUTobAHvUl9ywSPqfTWS/hpPGtP0pP0stkDRLIQddE1PGXeH0it+PlrfT
	7VWz+me+GjaWfMsLxKMltDKR4v8UX++HcQpY8s3SZzsZOP9LomCiz0iHI1TCf6rC
	pv+hRNz2nrusp1vTZxYdRLfYRMPlX9p0Jh+Hr8aqlHi7PTge71noJXmIUt382T0w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45ety0nr3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IGumPr032337;
	Tue, 18 Mar 2025 18:59:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvtdrj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxeJU60490044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40D0220043;
	Tue, 18 Mar 2025 18:59:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B06F620040;
	Tue, 18 Mar 2025 18:59:39 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:39 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 4/5] KVM: s390: Re-init SSCA on switch to ESCA
Date: Tue, 18 Mar 2025 19:59:21 +0100
Message-ID: <20250318-vsieie-v1-4-6461fcef3412@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OJ-k8-Z-pEleUFOgMBqq9izQGnM1HawK
X-Proofpoint-ORIG-GUID: OJ-k8-Z-pEleUFOgMBqq9izQGnM1HawK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180137

When the original SCA of a VSIE is switched from BSCA to ESCA (adding
the 65th processor) the addresses in the shadow SCA need to change as
well. It is sufficient to check for this on VSIE entry as all CPUs are
kicked out of VSIE for the migration.
This patch adds the necessary code where the original state description
address of the SSCA entry is updated.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/vsie.c             | 24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 4ab196caa9e79e4c4d295d23fed65e1a142e6ab1..e44f43906844d3b629e9685637af3f66398a4a8d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -155,6 +155,7 @@ struct ssca_vsie {
 	struct ssca_block ssca;			/* 0x0000 */
 	__u8	reserved[0x2200 - 0x2040];	/* 0x2040 */
 	atomic_t ref_count;			/* 0x2200 */
+	__u8	is_esca;
 };
 
 /*
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 0327c4964d27e493932a2b90b62c5a27b0a95446..3ddebebf8e9e90be3d5e27b6dc91d91214c3ea34 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -71,6 +71,11 @@ struct vsie_page {
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
 
+static inline bool vsie_uses_esca(struct vsie_page *vsie_page)
+{
+	return (vsie_page->scb_s.ecb2 & ECB2_ESCA);
+}
+
 /* trigger a validity icpt for the given scb */
 static int set_validity_icpt(struct kvm_s390_sie_block *scb,
 			     __u16 reason_code)
@@ -605,7 +610,7 @@ static void init_ssca(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
 	unsigned int bit, cpu_slots;
 	struct ssca_entry *cpu;
 	void *ossea_hva;
-	int is_esca;
+	bool is_esca;
 	u64 *mcn;
 
 	/* set original SIE control block address */
@@ -613,11 +618,12 @@ static void init_ssca(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
 	WARN_ON_ONCE(ssca->ssca.osca & 0x000f);
 
 	/* use ECB of shadow scb to determine SCA type */
-	is_esca = (vsie_page->scb_s.ecb2 & ECB2_ESCA);
+	is_esca = vsie_uses_esca(vsie_page);
 	cpu_slots = is_esca ? KVM_S390_MAX_VCPUS : KVM_S390_BSCA_CPU_SLOTS;
 	mcn = is_esca ? ((struct esca_block *)sca_o_hva)->mcn :
 			&((struct bsca_block *)sca_o_hva)->mcn;
 
+	ssca->is_esca = is_esca;
 	/*
 	 * For every enabled sigp entry in the original sca we need to populate
 	 * the corresponding shadow sigp entry with the address of the shadow
@@ -643,10 +649,20 @@ static void update_entry_ssda_remove(struct vsie_page *vsie_page, struct ssca_vs
 }
 
 /* add running scb pointer to ssca */
-static void update_entry_ssda_add(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
+static void update_entry_ssda_add(struct kvm *kvm, struct vsie_page *vsie_page,
+				  struct ssca_vsie *ssca)
 {
 	struct ssca_entry *cpu = &ssca->ssca.cpu[vsie_page->scb_s.icpua & 0xff];
 	phys_addr_t scb_s_hpa = virt_to_phys(&vsie_page->scb_s);
+	bool is_esca = vsie_uses_esca(vsie_page);
+
+	/* update original sca entry addresses after bsca / esca switch */
+	if (!ssca->is_esca && is_esca) {
+		down_write(&kvm->arch.vsie.ssca_lock);
+		if (!ssca->is_esca && is_esca)
+			init_ssca(vsie_page, ssca);
+		up_write(&kvm->arch.vsie.ssca_lock);
+	}
 
 	WRITE_ONCE(cpu->ssda, scb_s_hpa);
 }
@@ -815,7 +831,7 @@ static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		return PTR_ERR(ssca);
 
 	/* update shadow control block sca references to shadow sca */
-	update_entry_ssda_add(vsie_page, ssca);
+	update_entry_ssda_add(vcpu->kvm, vsie_page, ssca);
 	sca_s_hpa = virt_to_phys(ssca);
 	if (sclp.has_64bscao) {
 		WARN_ON_ONCE(sca_s_hpa & 0x003f);

-- 
2.48.1

