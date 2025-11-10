Return-Path: <kvm+bounces-62534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 56374C48435
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CDA91349955
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E9829B777;
	Mon, 10 Nov 2025 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XxSjYLOw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7402868A6;
	Mon, 10 Nov 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795066; cv=none; b=nZAfR7kKTUABgh4Y6lLI23P0mh7Yq5553FJ/ZiCARzU/zNP3CzNDTjIqRYCnhrTsiCx8jgJlp3R4WvKewWY6BVkTfOl73Yhl2AGoFPGnCU/MurAh1ff6OrJrqCnjfRoItGIDq8kzh2kwWk6pXFwHYwslyBKVI1bIBiYmxsEdyx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795066; c=relaxed/simple;
	bh=pArCCiOGRme2PhzFNJ3N35Vay7mDfjGXP9ctAUIv14A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VJY/rA2ZT/bjM8xaOt/lmmexv03PUdtdjl94jMTo4lJ2ua36mUSgNwBBRfg992fmDrCcUiXR0KgkzrSfIJmlLh561IXN13p3imPkSzoygHfhsxiukLPUzlD7Npicv1zDUYiYT21lBxIjOdG/A0ZcvvEGkLJrDbFXu9vPK2lQ0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XxSjYLOw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAE2RgS031322;
	Mon, 10 Nov 2025 17:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eFrF5w
	NFIsAe0meh7eqapdCQ9KtN/0EWW5xYH396HbE=; b=XxSjYLOwyvLKIi1s7zks7v
	XtuZWy6vOBy54q4zVttpwtOmw+Jfo2/xS+DzBVpd9zYG0bqgPK7E1kdbfaiw0nkN
	PbNXjHQSVFvs8HJLC31hLtDuU0TcpmCfTlBxaNfBLPXyIxHmUdv01auI1pIBBZWo
	H/7ai5bhkKbijyb3Z9m5LNHJ5hvhtt/FRKrmbWmIWnyasYdTebDqd9OUK+H7v+7k
	TJjf5eL3y7AK8DkIVUOU7YHr0Dg9aZ80inJ4S90WxsZ45HnvmFYAq/kPy4xklkY+
	L+/jZdEec/vp+xzZqkdHClJ3Aquo1QRL+XDj2cEAZ1j3YW6BRNoOnnjKkXw4cYRg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGWB3b014773;
	Mon, 10 Nov 2025 17:17:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpjxpnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHXhI43909552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37D6B20040;
	Mon, 10 Nov 2025 17:17:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8EC72004B;
	Mon, 10 Nov 2025 17:17:32 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:32 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:41 +0100
Subject: [PATCH RFC v2 01/11] KVM: s390: Add SCAO read and write helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-1-9e53a3618c8c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2430;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=pArCCiOGRme2PhzFNJ3N35Vay7mDfjGXP9ctAUIv14A=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCcloz5ll68d3UVP2x7F2K1ZEN56Utzs/gEI1b/sIh6
 qX2qcDTHaUsDGJcDLJiiizV4tZ5VX2tS+cctLwGM4eVCWQIAxenAExk5yxGhvPMj7dkCC1bPePo
 awO39a8Y1QynbjHcuarjaVTx08t7L/kxMkzYZHRZLNt2ntnq6qzgHZ9a41T8HNguTvB6vGvZ5K5
 OXS4A
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXwav6Oo0Lqv9E
 +lAGIpsncf3UEL2xiZ0ZPusnWiQ+vq3DWkc0zVwazIgUxNhDP6122aW/smZbwcYUD0CpqHaORGR
 U3dF09+wbnjeFyYrwciVrvwtOWtn5+RyOoUf4SpqmlhSvVT/yzTXrgHHGJ9zZ1mGxKjmqHtDm9W
 EAkF6OdYJwbmY81mylOa7qAlNZxTtAb9jitwbvGO+5cLUSSyl81997x14OsGSeHk6UxS+Gt5KSs
 zQ9Pl75A3ghZg622i+T79QE+6qTycl08UtycX5kbmdfTJ31oeDhiCj23JKWnKtx4pJL2FiiOe5G
 jvEHcDUyrx129wd7cFh15lnSC1JXPBGSdcEt7sMapFm3hgLyHEYqXhHRE200AOE/ar0oUm558jo
 QK+2K9Tr++nS0j5BqDmA3pQ8KkJqyA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e32 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Nr3O2JU5-Eb54A3yC_IA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: SQtvtWhQ8fjv7X5PgG0m-EG7SrMDghxt
X-Proofpoint-GUID: SQtvtWhQ8fjv7X5PgG0m-EG7SrMDghxt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

Introduce some small helper functions to get and set the system control
area origin address from the SIE control block.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 347268f89f2f186bea623a3adff7376cabc305b2..ced2ca4ce5b584403d900ed11cb064919feda8e9 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -123,6 +123,23 @@ static int prefix_is_mapped(struct vsie_page *vsie_page)
 	return !(atomic_read(&vsie_page->scb_s.prog20) & PROG_REQUEST);
 }
 
+static gpa_t read_scao(struct kvm *kvm, struct kvm_s390_sie_block *scb)
+{
+	gpa_t sca;
+
+	sca = READ_ONCE(scb->scaol) & ~0xfUL;
+	if (test_kvm_cpu_feat(kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
+		sca |= (u64)READ_ONCE(scb->scaoh) << 32;
+
+	return sca;
+}
+
+static void write_scao(struct kvm_s390_sie_block *scb, hpa_t hpa)
+{
+	scb->scaoh = (u32)((u64)hpa >> 32);
+	scb->scaol = (u32)(u64)hpa;
+}
+
 /* copy the updated intervention request bits into the shadow scb */
 static void update_intervention_requests(struct vsie_page *vsie_page)
 {
@@ -714,12 +731,11 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	hpa_t hpa;
 
-	hpa = (u64) scb_s->scaoh << 32 | scb_s->scaol;
+	hpa = read_scao(vcpu->kvm, scb_s);
 	if (hpa) {
 		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
 		vsie_page->sca_gpa = 0;
-		scb_s->scaol = 0;
-		scb_s->scaoh = 0;
+		write_scao(scb_s, 0);
 	}
 
 	hpa = scb_s->itdba;
@@ -773,9 +789,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	gpa_t gpa;
 	int rc = 0;
 
-	gpa = READ_ONCE(scb_o->scaol) & ~0xfUL;
-	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
-		gpa |= (u64) READ_ONCE(scb_o->scaoh) << 32;
+	gpa = read_scao(vcpu->kvm, scb_o);
 	if (gpa) {
 		if (gpa < 2 * PAGE_SIZE)
 			rc = set_validity_icpt(scb_s, 0x0038U);
@@ -792,8 +806,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if (rc)
 			goto unpin;
 		vsie_page->sca_gpa = gpa;
-		scb_s->scaoh = (u32)((u64)hpa >> 32);
-		scb_s->scaol = (u32)(u64)hpa;
+		write_scao(scb_s, hpa);
 	}
 
 	gpa = READ_ONCE(scb_o->itdba) & ~0xffUL;

-- 
2.51.1


