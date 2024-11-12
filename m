Return-Path: <kvm+bounces-31640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A198A9C5D31
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65F7A2830E2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E98C206E93;
	Tue, 12 Nov 2024 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XvXlIW8E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDE206976;
	Tue, 12 Nov 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428783; cv=none; b=dtU2Rx1Qr5jwzqT224uqjcf0RMVb1iI7D4JdFDO3gmUYuP0ZssR9nmV2emo7z3TI/k3xLuCYEtotLOyI7lpqClGZ435tNUEmgm86DVnJcln+X4ex9XNS+tY7pgcXz6iFQcE3dYp44tvKwyGRtYwH/zSMtdVRrpcu5oVKMEKB0LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428783; c=relaxed/simple;
	bh=EiLQAt2rtTYJHXRReZPh2IqRwScFoag4kUCxqP/Y2NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk8gCrJHa3c912bliSNC7ioP8yMsMI8cuJ0BVox5fUt35RO6MvYvj53PZbXIupKeupUTCsFnZXTSP3WDL4eqqVJ32PZwWGle1yVKKZnrQJ9Z0iuCPIOjTkRKcjQ299EgppaCuV8ADgdUsrHr4awkvIZfvb7hP5T6jov/koFcyNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XvXlIW8E; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEex8K008433;
	Tue, 12 Nov 2024 16:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=70b54xW0/5OeIog3X
	JWesNRpFKG6uyvx5Xm9kPCAl5g=; b=XvXlIW8ExKoUbutJoW87tkd7x5sO47mFU
	AIBI239XQ4XSK+3dRXR/L+R8TlRmu2nSSF8hmK4IIYrH6tUlggTOtQMeMcDhcAcv
	k/Y+5LQv8Kck20o3LMHJDHq1AbrAarKaUC3jQYFM1ZV/SKTMYw6a9lFcidlVQj1g
	XtyieVMoULk7JrLObmwg8O8zTnNNqMNOEzNORbodRWX1cAPC2b7/SgAUW/+1bkSa
	0tFsETiARi2sL/09XLpdNP2MSIRglNlM94VNH9XjE4G1x/juxIVXL9v1chByLcE6
	fKAMPGZQnFPjrkyDxTogOXxYwPHUrR8PAZKuwZlarEHrISvrXdr/A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9020g23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC57eZb010526;
	Tue, 12 Nov 2024 16:26:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tj2s4kqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQCrl63242576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94AD020040;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DE992004B;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [GIT PULL 12/14] KVM: s390: add msa11 to cpu model
Date: Tue, 12 Nov 2024 17:23:26 +0100
Message-ID: <20241112162536.144980-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mTLoJHXvYY4PcEXKTvkgZLl2t98AdbQV
X-Proofpoint-GUID: mTLoJHXvYY4PcEXKTvkgZLl2t98AdbQV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=855 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Hendrik Brueckner <brueckner@linux.ibm.com>

Message-security-assist 11 introduces pckmo subfunctions to encrypt
hmac keys.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107152319.77816-3-brueckner@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107152319.77816-3-brueckner@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 13 +++++++++++--
 arch/s390/kvm/vsie.c             |  3 ++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e77afbed58e..851cfe5042f3 100644
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
index 74f385b5efbd..20b1317ef95d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3796,6 +3796,13 @@ static bool kvm_has_pckmo_ecc(struct kvm *kvm)
 
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
@@ -3808,7 +3815,7 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->crycbd = vcpu->kvm->arch.crypto.crycbd;
 	vcpu->arch.sie_block->ecb3 &= ~(ECB3_AES | ECB3_DEA);
 	vcpu->arch.sie_block->eca &= ~ECA_APIE;
-	vcpu->arch.sie_block->ecd &= ~ECD_ECC;
+	vcpu->arch.sie_block->ecd &= ~(ECD_ECC | ECD_HMAC);
 
 	if (vcpu->kvm->arch.crypto.apie)
 		vcpu->arch.sie_block->eca |= ECA_APIE;
@@ -3816,9 +3823,11 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
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
index 89cafea4c41f..9ce0902f309b 100644
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
2.47.0


