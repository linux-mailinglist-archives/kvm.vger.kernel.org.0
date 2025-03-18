Return-Path: <kvm+bounces-41442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF38A67C73
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A1B119C3115
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6915B2139B1;
	Tue, 18 Mar 2025 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XFny48o+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A4C213245;
	Tue, 18 Mar 2025 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324392; cv=none; b=oMCBFQRHtICIibCr4h2AzHdU5fFedJMAxYgYW0kbZ60huSnD4MBHfFJ6karkS5wWxvT5zl2lNigFC72HSJPXgftGFT2HWPlIJ/Fi2S7wqrTcbFKyhu7rqDR2/6LhWYgfRbMEgXPQz5sfBZJ00BDgkG/2YHIf1rTBpxdz4lugCtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324392; c=relaxed/simple;
	bh=fwn7ZYhIxRWNbHY0yqGmLnwtTu3iBcBmO4V6Ifz02CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xtn6chh1KzQuzSAgKfRQwSasPdxX4eDEXKLIy0WJ14etXDgjFB3a8UYuJrTFJdpApHKNg3w1BkWDO3Ed+Y4TE3rWA9y3yfSfdAo6wjYGugZ0KR5gpr/7H+vCQ/pHsPSBmP/4LA2VTlPgVTX21Ha8Ckf7mH2d4i+X7a83P8sUbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XFny48o+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ICSZPq031147;
	Tue, 18 Mar 2025 18:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RdAJjg
	U4NPs944RuG+ubIU4drVVBWMGM4s7CTPTKixU=; b=XFny48o+KnEeKybTpxP2IH
	BBpYpdA13KiyFU2V1uOfg7h+fKWpg6yLcoXJnhxjPZ1iPfpOPoNa+T5OugNkYWN7
	86PbgBWicibw6ginDbDgVH63qtuei8tdTZSNH3IEPc8lfFGfGiLHqAUZBtu/yOZy
	kun5mfW+oSOnAJRzzjXjv50U2nu3kkzP2bO3bGUdNpbcG9W7RXOs3kTQzUwnefb1
	+brr3DrzlaUf4mvB5KrSJ3FpgzUevFxy9VPwIOZEle7LQjPiiRqJYbMVRreQ4q3S
	bCvMPXj3HyQrV/Mg1RrrMDccTfsB0g1raTVcblz2ypV+wN1EmykhMx0f2/R75g0w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45f8v7j5yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IHlfSv012351;
	Tue, 18 Mar 2025 18:59:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dmvnwj07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxdSG53281028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F116620043;
	Tue, 18 Mar 2025 18:59:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66BBF20040;
	Tue, 18 Mar 2025 18:59:38 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:38 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 2/5] KVM: s390: Add ssca_block and ssca_entry structs for vsie_ie
Date: Tue, 18 Mar 2025 19:59:19 +0100
Message-ID: <20250318-vsieie-v1-2-6461fcef3412@linux.ibm.com>
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
X-Proofpoint-GUID: yaf_oM8UM75cgGM3gbSBhbdSMqERXjd9
X-Proofpoint-ORIG-GUID: yaf_oM8UM75cgGM3gbSBhbdSMqERXjd9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180137

Add the required guest-1 structures for the vsie_sigpif to the SIE
control block and vsie_page for use in later patches.

The shadow SCA features the address of the original SCA as well as an
entry for each original SIGP entry. The entries contain the addresses of
the shadow state description and original SIGP entry.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h               | 20 +++++++++++++++++++-
 tools/testing/selftests/kvm/include/s390/sie.h |  2 +-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 149912c3b1ffd0f8ed978b8c06a70efc892b7e01..0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -87,6 +87,13 @@ struct bsca_entry {
 	__u64	reserved2[2];
 };
 
+struct ssca_entry {
+	__u8	reserved0[8];
+	__u64	ssda;
+	__u64	ossea;
+	__u8	reserved18[8];
+};
+
 union ipte_control {
 	unsigned long val;
 	struct {
@@ -128,6 +135,17 @@ struct esca_block {
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
 };
 
+/*
+ * The shadow sca / ssca needs to cover both bsca and esca depending on what the
+ * guest uses so we use KVM_S390_ESCA_CPU_SLOTS.
+ * The header part of the struct must not cross page boundaries.
+ */
+struct ssca_block {
+	__u64	osca;
+	__u64	reserved08[7];
+	struct ssca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
+};
+
 /*
  * This struct is used to store some machine check info from lowcore
  * for machine checks that happen while the guest is running.
@@ -358,7 +376,7 @@ struct kvm_s390_sie_block {
 	__u32	fac;			/* 0x01a0 */
 	__u8	reserved1a4[20];	/* 0x01a4 */
 	__u64	cbrlo;			/* 0x01b8 */
-	__u8	reserved1c0[8];		/* 0x01c0 */
+	__u64	osda;			/* 0x01c0 */
 #define ECD_HOSTREGMGMT	0x20000000
 #define ECD_MEF		0x08000000
 #define ECD_ETOKENF	0x02000000
diff --git a/tools/testing/selftests/kvm/include/s390/sie.h b/tools/testing/selftests/kvm/include/s390/sie.h
index 160acd4a1db92d6129c0f084db82c8c147d5c23e..4ff1c1a354af51d322042c03d59a8cf56685abd3 100644
--- a/tools/testing/selftests/kvm/include/s390/sie.h
+++ b/tools/testing/selftests/kvm/include/s390/sie.h
@@ -223,7 +223,7 @@ struct kvm_s390_sie_block {
 	__u32	fac;			/* 0x01a0 */
 	__u8	reserved1a4[20];	/* 0x01a4 */
 	__u64	cbrlo;			/* 0x01b8 */
-	__u8	reserved1c0[8];		/* 0x01c0 */
+	__u64	osda;			/* 0x01c0 */
 #define ECD_HOSTREGMGMT	0x20000000
 #define ECD_MEF		0x08000000
 #define ECD_ETOKENF	0x02000000

-- 
2.48.1

