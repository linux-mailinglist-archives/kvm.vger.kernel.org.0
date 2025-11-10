Return-Path: <kvm+bounces-62535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CA2C1C484B6
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:23:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 96B2A4EFB64
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA02829BD9B;
	Mon, 10 Nov 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VMiEGF+/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681229ACF6;
	Mon, 10 Nov 2025 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795068; cv=none; b=Qspnf+qarokTVL9JFJ6u9JvGmvwoki8ckO+q+eIFbsExafnzdgSbPsRmTgvodmp4nxW8bfnjZdU+7UfAP8+RHVfucxcLso6Ubtzz43CXpQrq5AV9pMR0bKdX/m5UoVj/7CrfVTAEofT6Z8PFwt6dmr/dDw2vDqoEJji/UrLVTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795068; c=relaxed/simple;
	bh=lTiXtOwu/0sRLDjSeazPUvJIIfUoMqpqkw1VGNYtnpo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MHPR9lNqIW5xvm45bpMctvirTv05Ue6SkaluIX1QtHNtOZrdvLlSptvzgtoaagFG+9FBxxPoQ0yNav80AH1+iFICNLjNgOsuWnVV1ugW1J65m3YbR08yqv2agxoiW4FyLyWOrKoagX8pkQC/uHF6O7A3/TqmFB4JBrGbBDFaDsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VMiEGF+/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAF4B1u012181;
	Mon, 10 Nov 2025 17:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FQjsCF
	XUVzuf9/SKwlHKa5KlVQVdaEI+Uxx8hQY3L0U=; b=VMiEGF+/0gEKRly91qzhE1
	yU2NgywqyB6UfrueRnxngGtuAAi87o9gXbsyzcWgbf5I7EZxBdq8HRo+Lo9EVBOt
	WzwNpeUjkcECcQhJ1FlSBguKpM6bnrS1IpnO+QGyOWL543TTocs/koS5amyEvOOC
	PFoxz+w/qwsfc+wjrlffXMga4cDqhk+NFISahvudeFSG/mdwW6iBDU2CJFqlrJM8
	ldat8yXyWGaxddWrzOVfCJjc0+VRSxzi1d3YykQe3H6bnfTep5kG03SeZ3rMDxmZ
	iTH3YWW+p6+pwUCTaQdBdeALIJ/n7/N6bo/ZIkSIqnT4szcY7hKnChu82qZ8N9pw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjq9xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGcR04011562;
	Mon, 10 Nov 2025 17:17:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw16emx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHZbf30736760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4B6020040;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 204B320043;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:35 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:45 +0100
Subject: [PATCH RFC v2 05/11] KVM: s390: Add ssca_block and ssca_entry
 structs for vsie_ie
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-5-9e53a3618c8c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2661;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=lTiXtOwu/0sRLDjSeazPUvJIIfUoMqpqkw1VGNYtnpo=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctpZiXySOkufnvj+pO5glO2ZKW28DKEcplOkmJfzv
 +rgV5jRUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwETYXjAyPD/7WKrxR2Kk9N4M
 3lcNJdlrOZy6ftQzBv7t6LPXPlUgxMjw4fDpOJXc7ndKQTW1/ZKxr3dVrX185++16QevfnJ6pna
 ZCQA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CMVK0qFFtXRfSZoBGQ7R_SBAoK1mm4Yg
X-Proofpoint-ORIG-GUID: CMVK0qFFtXRfSZoBGQ7R_SBAoK1mm4Yg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX39JNRUPymq2M
 wpxTwUw1OP+CSeJpHTx3kJIVtmyBDUPN01IYOwU3W+tHyBdXUemkGhnkXe9an75Vm6kRGyqZbGn
 hZvwHxGtBaC1RH/o9t2Vm7MNE3Ntb9KcWASwfOhs399FoOKXNzx05+cGyMVH6omi8kKJE1qSRAI
 hZ5Aw6I7Q7r1/83ylN/BrnMsfYccKFeq7pDhQfYzVqOrlc7a/8WyxuTK3NF+USweGeXI4V5Dbkd
 ua6pQtiZzYOmzhICQDelyOHLfDlC8P3Jqlftwu78eOj3Hm6cczkUMGl3Z1IpkpW0BY3IBCiF+Cb
 XeGxryui4SVquUPjly0iLzW4u7Zrl1qsZzQrL2fXotWd/6b41/EFvlStHBpRNizKEn4srhHuW4v
 XpEzlHsZe0quSrYjbgihZzBm27qcvQ==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=69121e34 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=KXQrNVq8KaMVEL7Tj7gA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099

Add the required guest-1 structures for the vsie_sigpif to the SIE
control block and vsie_page for use in later patches.

The shadow SCA features the address of the original SCA as well as an
entry for each original SIGP entry. The entries contain the addresses of
the shadow state description and original SIGP entry.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host_types.h         | 21 ++++++++++++++++++++-
 tools/testing/selftests/kvm/include/s390/sie.h |  2 +-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..ce52608449735d6ca629008c554e7df09f97e67b 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -45,6 +45,13 @@ struct bsca_entry {
 	__u64	reserved2[2];
 };
 
+struct ssca_entry {
+	__u64	reserved1;
+	__u64	ssda;
+	__u64	ossea;
+	__u64	reserved2;
+};
+
 union ipte_control {
 	unsigned long val;
 	struct {
@@ -86,6 +93,18 @@ struct esca_block {
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
 };
 
+/*
+ * The shadow sca / ssca needs to cover both bsca and esca depending on what the
+ * guest uses so we allocate space for 256 entries that are defined in the
+ * architecture.
+ * The header part of the struct must not cross page boundaries.
+ */
+struct ssca_block {
+	__u64	osca;
+	__u64	reserved08[7];
+	struct ssca_entry cpu[KVM_MAX_VCPUS];
+};
+
 /*
  * This struct is used to store some machine check info from lowcore
  * for machine checks that happen while the guest is running.
@@ -316,7 +335,7 @@ struct kvm_s390_sie_block {
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
2.51.1


