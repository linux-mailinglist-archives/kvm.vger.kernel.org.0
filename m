Return-Path: <kvm+bounces-66491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E8540CD6BD9
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 104B03027EAA
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4C833DED3;
	Mon, 22 Dec 2025 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R+eAUF6Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB4F33C1AD;
	Mon, 22 Dec 2025 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422258; cv=none; b=A8A4h8WeTarQ0MuR7ZgieTzuwbHMp8fGAbC6531g4Ga6oXS5DhfSZPoBM+qUyMQS1p92GS+hm5xUE0WQ+m0bkZQ+nlNXPEJGcnpWAAjZYPElRSRthfe3suv8KdcAqgQgtQvVPEpD3j46d6RnSKEqpUEXNqSttoRwB0w+bvrVlKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422258; c=relaxed/simple;
	bh=MwRlEXS+9TTKAVxXRbRJfm30lcddhdF+DFAQ7aLn7eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVrmmwOBOgzAUcgiSrn0ItFfH/iZBUr6KjM/tpUcZH6no41wbeqsotVpKSqGVVLc0uFpl8VHlGV7IGYm0XvhogBv7lMCkJwczJeK9nvSZsl6eG5/8PWWkbogCbGljRRxOWWKFDIWnvBpECikifg3rwogLzCc4bKCjb9uSGNhZPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R+eAUF6Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDwHVx007191;
	Mon, 22 Dec 2025 16:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9VBHMGApuDPu1H5nW
	xC2gjbA/GYRZEiMfQwZendHh0k=; b=R+eAUF6YW3Y6JUHRVMHX8YAHwPsZl24lJ
	vtXuRBneMOMmh3r7n5zfJtoxwQYEeMjD87PMuMp07nmNZJlkRcz6bHtncPQXJNgn
	atOJbFlDQWie8EccCdjJQ0ywWEJdKeFB4ceuUEVucXQSnlC1nx+GomnIG3iiB/uQ
	nnqg2KYNj/TvH+ZXNOL5HsSgJGc6I17fCwwOL5cP14dmvDBHxToO8Ul+zDEK98O3
	2EQpxInlk0nLkFf1Xk/HY8QiWlK25K/IpByrZYlBwnRreJm6ak1wC40pS5uV0Ib4
	3cDSJhK/jGQPI61bLo2V4qvi/yBZQuHTVeLjms+Q5vOENEi82Q1jA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kfq16wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGKfpp005012;
	Mon, 22 Dec 2025 16:50:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq58y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGolOt12189982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6220220043;
	Mon, 22 Dec 2025 16:50:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47DA220040;
	Mon, 22 Dec 2025 16:50:46 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 09/28] KVM: s390: vsie: Pass gmap explicitly as parameter
Date: Mon, 22 Dec 2025 17:50:14 +0100
Message-ID: <20251222165033.162329-10-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=carfb3DM c=1 sm=1 tr=0 ts=694976ec cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=HXG1Eys9fZm8ipb54dgA:9
X-Proofpoint-ORIG-GUID: 4za2X7nckNiqDGDSlfTESqBca21_Fsll
X-Proofpoint-GUID: 4za2X7nckNiqDGDSlfTESqBca21_Fsll
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX/V7/oVnyZER2
 arMPM0aylySxVz+Rxl5E5+BIdUYMHC+rzOzG4GhpxMGD0k/v2SNEnyi8ZJgPQEnNl9MXRv8H1Vk
 zm0A+PEI+RRA1tp+66criV6E7tghbcIIHXGDf+/YVsnoQyxD7FfAQ8uLlXppO/y51sy0tFNb3f8
 oM9r0g2egSVbKBUKGwZxCk4d39cvyaNs7AmOq3hZSdOxR5fttDjpGLtqMzsNhxYQSIEfLNjxOJb
 JP5RjNXhoRRdTNjnYsuA0HTBT0XsBraMM9khCdAURqSmGb4qOA3oOHlKaMo/E95L4Y/rQM03crH
 hR0OZvxXsg5tfv5F1Kpzok0CRhAXOHUkBva6uglSVnxdfbJL/oNnAH0CxFT/9o1R32Po9MlV2p7
 cUCOI5IdcB18KpXmLQtpz2mx9YFWgsG5pZhxk4Y76tZnjE/wC8EobjQQJaOeXL50F1UOWzi5HZK
 z2XoRtu27JfO6CjgdsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

Pass the gmap explicitly as parameter, instead of just using
vsie_page->gmap.

This will be used in upcoming patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b526621d2a1b..1dd54ca3070a 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -652,7 +652,7 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
  *          - -EAGAIN if the caller can retry immediately
  *          - -ENOMEM if out of memory
  */
-static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	u64 prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
@@ -667,10 +667,9 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
+	rc = kvm_s390_shadow_fault(vcpu, sg, prefix, NULL);
 	if (!rc && (scb_s->ecb & ECB_TE))
-		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-					   prefix + PAGE_SIZE, NULL);
+		rc = kvm_s390_shadow_fault(vcpu, sg, prefix + PAGE_SIZE, NULL);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -951,7 +950,7 @@ static int inject_fault(struct kvm_vcpu *vcpu, __u16 code, __u64 vaddr,
  *          - > 0 if control has to be given to guest 2
  *          - < 0 if an error occurred
  */
-static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	int rc;
 
@@ -960,8 +959,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		return inject_fault(vcpu, PGM_PROTECTION,
 				    current->thread.gmap_teid.addr * PAGE_SIZE, 1);
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
+	rc = kvm_s390_shadow_fault(vcpu, sg, current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_teid.addr * PAGE_SIZE,
@@ -978,12 +976,10 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
  *
  * Will ignore any errors. The next SIE fault will do proper fault handling.
  */
-static void handle_last_fault(struct kvm_vcpu *vcpu,
-			      struct vsie_page *vsie_page)
+static void handle_last_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	if (vsie_page->fault_addr)
-		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr, NULL);
+		kvm_s390_shadow_fault(vcpu, sg, vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 
@@ -1065,7 +1061,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	}
 }
 
-static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
@@ -1083,8 +1079,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
 	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
-	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
-	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	rc_dest = kvm_s390_shadow_fault(vcpu, sg, dest, &pei_dest);
+	rc_src = kvm_s390_shadow_fault(vcpu, sg, src, &pei_src);
 	/*
 	 * Either everything went well, or something non-critical went wrong
 	 * e.g. because of a race. In either case, simply retry.
@@ -1144,7 +1140,7 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
  *          - > 0 if control has to be given to guest 2
  *          - < 0 if an error occurred
  */
-static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 	__releases(vcpu->kvm->srcu)
 	__acquires(vcpu->kvm->srcu)
 {
@@ -1153,7 +1149,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	int guest_bp_isolation;
 	int rc = 0;
 
-	handle_last_fault(vcpu, vsie_page);
+	handle_last_fault(vcpu, vsie_page, sg);
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -1191,7 +1187,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 			goto xfer_to_guest_mode_check;
 		}
 		guest_timing_enter_irqoff();
-		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
+		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, sg->asce);
 		guest_timing_exit_irqoff();
 		local_irq_enable();
 	}
@@ -1215,7 +1211,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (rc > 0)
 		rc = 0; /* we could still have an icpt */
 	else if (current->thread.gmap_int_code)
-		return handle_fault(vcpu, vsie_page);
+		return handle_fault(vcpu, vsie_page, sg);
 
 	switch (scb_s->icptcode) {
 	case ICPT_INST:
@@ -1233,7 +1229,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		break;
 	case ICPT_PARTEXEC:
 		if (scb_s->ipa == 0xb254)
-			rc = vsie_handle_mvpg(vcpu, vsie_page);
+			rc = vsie_handle_mvpg(vcpu, vsie_page, sg);
 		break;
 	}
 	return rc;
@@ -1330,15 +1326,17 @@ static void unregister_shadow_scb(struct kvm_vcpu *vcpu)
 static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	struct gmap *sg;
 	int rc = 0;
 
 	while (1) {
 		rc = acquire_gmap_shadow(vcpu, vsie_page);
+		sg = vsie_page->gmap;
 		if (!rc)
-			rc = map_prefix(vcpu, vsie_page);
+			rc = map_prefix(vcpu, vsie_page, sg);
 		if (!rc) {
 			update_intervention_requests(vsie_page);
-			rc = do_vsie_run(vcpu, vsie_page);
+			rc = do_vsie_run(vcpu, vsie_page, sg);
 		}
 		atomic_andnot(PROG_BLOCK_SIE, &scb_s->prog20);
 
-- 
2.52.0


