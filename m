Return-Path: <kvm+bounces-31131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1529C0A04
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C5BCB251DB
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD6A214428;
	Thu,  7 Nov 2024 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BYlN/YlM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BD2101A4;
	Thu,  7 Nov 2024 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993022; cv=none; b=ZmtnqaiH9NJtPLNrBRYhKWVEz/mQOz1T3ZBjybT41OsmST0QG7I4OgayX2GsoFF+05F5GSww/uQpvs8yBAwNrSC2V2G7/rung32x5fSXo4wsb5cu3bNNxGAU6YEzCgq5CAYbzV+yaCrlzmliBuOrq2IxECW/Z/Z5kWjeXndYG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993022; c=relaxed/simple;
	bh=XRWV1WfINcc2nhLFjtdfAtRY9pdCvoEvSxGcZpOL7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYyVXjl9DhG0GXTHdLLQO1BrFyx0EUh9cttdj9etJufAfJTeKgDKDTl5JYKTe4mkCS0lEAxl3MU3HgLwSW5sqgIZ0XrYqM2Sj1MJxU1FnhmwOoax1fZtbX8Euejg5PUTrzUnSGT9koQum84gsUePzTfWEvXRUa+ArP+CmbYIra8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BYlN/YlM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7FA1bg017938;
	Thu, 7 Nov 2024 15:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=q609OraqBOvlDyxd/
	0H+yFREJ4wh3UnuVVyvsl486DA=; b=BYlN/YlM3+0WPyhK0tsU1am47qLyJ5X1G
	3vCpxtJKw2jKKQU/filLEHZp3KI4DcL7U3y5cwf0GQo8ZGYtnnTzB1HfpJxFxcS4
	QbRXYvDW45XXy1Tppu30tzCLL5C1W6MuToL13qKCWnIe4E5DTSVoKrFPL6W+akJ7
	yxQkQUfd0Fed6F6W3vz0+KfYLFTNy1tbx0eiqjh3WipCTvVAc96h6FjW9t+RvmeW
	OTbaRz103J2O3s1x0NlfB0tdYx/nCMFj+D515RE8kArCeipofwAur8Tw66N0tVRJ
	9/a7ZrV6Yc4EiJLGT24Uhu1jAL+VIzs/0S6+B7HvNcTWVEyVYy0FA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ryxx02dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7Dm5rm012288;
	Thu, 7 Nov 2024 15:23:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p1410bnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 15:23:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7FNXmJ45089254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 15:23:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CA1220040;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3ED4B20049;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
Received: from vela.boeblingen.de.ibm.com (unknown [9.155.210.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 15:23:33 +0000 (GMT)
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH 2/4] KVM: s390: add msa11 to cpu model
Date: Thu,  7 Nov 2024 16:23:17 +0100
Message-ID: <20241107152319.77816-3-brueckner@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107152319.77816-1-brueckner@linux.ibm.com>
References: <20241107152319.77816-1-brueckner@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ixe8DRdiB9XbtysGGv61-bxYJhBOAQRk
X-Proofpoint-GUID: ixe8DRdiB9XbtysGGv61-bxYJhBOAQRk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=848 lowpriorityscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411070117

Message-security-assist 11 introduces pckmo subfunctions to encrypt
hmac keys.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 13 +++++++++++--
 arch/s390/kvm/vsie.c             |  3 ++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 51201b4ac93a..1cd8eaebd3c0 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -356,6 +356,7 @@ struct kvm_s390_sie_block {
 #define ECD_MEF		0x08000000
 #define ECD_ETOKENF	0x02000000
 #define ECD_ECC		0x00200000
+#define ECD_HMAC	0x00004000
 	__u32	ecd;			/* 0x01c8 */
 	__u8	reserved1cc[18];	/* 0x01cc */
 	__u64	pp;			/* 0x01de */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f9cc1c92a79d..6efa812ca592 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3791,6 +3791,13 @@ static bool kvm_has_pckmo_ecc(struct kvm *kvm)
 
 }
 
+static bool kvm_has_pckmo_hmac(struct kvm *kvm)
+{
+	/* At least one HMAC subfunction must be present */
+	return kvm_has_pckmo_subfunc(kvm, 118) ||
+	       kvm_has_pckmo_subfunc(kvm, 122);
+}
+
 static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -3803,7 +3810,7 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->crycbd = vcpu->kvm->arch.crypto.crycbd;
 	vcpu->arch.sie_block->ecb3 &= ~(ECB3_AES | ECB3_DEA);
 	vcpu->arch.sie_block->eca &= ~ECA_APIE;
-	vcpu->arch.sie_block->ecd &= ~ECD_ECC;
+	vcpu->arch.sie_block->ecd &= ~(ECD_ECC | ECD_HMAC);
 
 	if (vcpu->kvm->arch.crypto.apie)
 		vcpu->arch.sie_block->eca |= ECA_APIE;
@@ -3811,9 +3818,11 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 	/* Set up protected key support */
 	if (vcpu->kvm->arch.crypto.aes_kw) {
 		vcpu->arch.sie_block->ecb3 |= ECB3_AES;
-		/* ecc is also wrapped with AES key */
+		/* ecc/hmac is also wrapped with AES key */
 		if (kvm_has_pckmo_ecc(vcpu->kvm))
 			vcpu->arch.sie_block->ecd |= ECD_ECC;
+		if (kvm_has_pckmo_hmac(vcpu->kvm))
+			vcpu->arch.sie_block->ecd |= ECD_HMAC;
 	}
 
 	if (vcpu->kvm->arch.crypto.dea_kw)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index d3cdde1b18e5..b30f58f0bf95 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -335,7 +335,8 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* we may only allow it if enabled for guest 2 */
 	ecb3_flags = scb_o->ecb3 & vcpu->arch.sie_block->ecb3 &
 		     (ECB3_AES | ECB3_DEA);
-	ecd_flags = scb_o->ecd & vcpu->arch.sie_block->ecd & ECD_ECC;
+	ecd_flags = scb_o->ecd & vcpu->arch.sie_block->ecd &
+		     (ECD_ECC | ECD_HMAC);
 	if (!ecb3_flags && !ecd_flags)
 		goto end;
 
-- 
2.43.5


