Return-Path: <kvm+bounces-62538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DF1C48480
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1CE23B18AC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890F029ACF7;
	Mon, 10 Nov 2025 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I65lW9he"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B529BDA2;
	Mon, 10 Nov 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795070; cv=none; b=Upqi7MUJ1kZZGF5dzt/43JrbGfBUjYNSCTaPQlV/XBnpRcHkVqXvpzxB4LqXPxBMk8xbK0oklxI4P+2KUEMZ2G+m9EwpT7OG0tiyimG/+MdmlE5s3BXAHeSqv2bJCihrS2Si69UIJCNdZppF4jkFiCQmYnDDfp7AKO1I/Lukivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795070; c=relaxed/simple;
	bh=4Yp64kkWiYFA+6yB6OP+mItLtie+yPfTyjNs8QwjAOM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Loc3117SPma01fw2wpvozwuwU535olx2giIeq1vT6Mgr/TKJGyUOEpukPf52ZyIdR7gKYeV2yUzd/v4Yf7wRbo1JxQTu3xLSDYZbuexaMMMTJpsMV2xcOA9SwnuGRr3PtCWYp0KJXqdGL1PSzu3MDCPMpqzb1a0RyQbaRdZUTPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I65lW9he; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AACOYtW025879;
	Mon, 10 Nov 2025 17:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4o7YCl
	6VgT2HgOqR9YFyKlJsG2ZYFuyTqEPYvlwRyac=; b=I65lW9hekYw8/ZuoMsKFoh
	zfXzfZhCwX3cyvfMHNTVLdmqikLmROOyacvCISmoMu3WLI+786YTaDSoJhRblfdW
	ncb9e4GpTariVLGswgOOHN40qtGfHWnVTPJNaMjNfhyasoR/JUmqm/+ESD9s/Mdx
	B3iSatY/YK9lOaH+fQhSywd/ozuptzoyyRxI13cITxhrHu86uqqqFJtieetu+yWY
	o6ueC6E16FCPb52IcQ3xzSdrcm0D9ucZZDNLzzj7BBi2pUmMjvJ4vMR03Ws4DokT
	hpZdBlSC5myoHQXFuHUSw/4K6lwDizHXYYnc8/jyiyDq58Iu2MdF4T9zsM9+9jVA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGZX4Q011441;
	Mon, 10 Nov 2025 17:17:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw16en3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHbsX52429296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7AFB20040;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CADA2004B;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:48 +0100
Subject: [PATCH RFC v2 08/11] KVM: s390: Allow guest-3 cpu add and remove
 with vsie sigpif
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-8-9e53a3618c8c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2055;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=4Yp64kkWiYFA+6yB6OP+mItLtie+yPfTyjNs8QwjAOM=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctrTL7AffVp9OSdvbZnhlS/C9pPc6+13dDT9/bvod
 reU7fWSjlIWBjEuBlkxRZZqceu8qr7WpXMOWl6DmcPKBDKEgYtTACaS/Znhf+mi8DOTpO/Nyzjy
 VWdL+eN5d32Yf0+e9ixsj7aAYeTH+CKGX8zxG/63uM2//nMOqxOfX2Xc7o50xRk2S3wu+vzj3fT
 DhwMA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX5e+P4U1SdvuS
 XRAf8BZgCXdXwQv/mEJYlv7QR2fQxVHWuYGdTSDAH/WQSEob8uYWJ9JIDG37v3CdOt9q+jRUxIn
 RonPGloM1HMO7PDX50Ry23P+y5igPG4VSxWrHUkvDoWWOekjx2YT8fq/vGmftOpSINsfyHP7oCG
 k489URDtpmnh3+/0htqg74ZFlzBNw91H+RiUrQpermCkvHH372G9gsZpmBJQMyHTtABwaooyYMK
 u1KKoQ7+Zvz4D20UdnJ5Dm+YjHTs2DG3EitE5yIksbXmb54KWmnUAcKwdBzjXu+ytxLk+SBBYL6
 SUVhSyGjNV9R5N7NsJqk7cMjj7SbnCpx/QpgmCUh4sfBDUP1fmFF1B4RIPKT1zTWLXmYRZylj3j
 jODToJiCbuJkaH1rOERkfStFjzgBIw==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e36 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=CGJeJ0uGHn7zT2QCH0kA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: ND5vWa2lleqvWboXjSo4F3-ZE8ZdISKp
X-Proofpoint-GUID: ND5vWa2lleqvWboXjSo4F3-ZE8ZdISKp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

As we are shadowing the SCA we need to add and remove the pointers to
the shadowed control blocks and sca entries whenever the mcn changes.

It is not expected that the mcn changes frequently for a already running
guest-3 configuration. So we can simply re-init the ssca whenever the
mcn changes.
To detect the mcn change we store the expected mcn in the struct
vsie_sca when running the ssca init.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 72c794945be916cc107aba74e1609d3b4780d4b9..1e15220e1f1ecfd83b10aa0620ca84ff0ff3c1ac 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1926,12 +1926,27 @@ static int init_ssca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct
 	return PTR_ERR(vsie_page_n);
 }
 
+static bool sca_mcn_equals(struct vsie_sca *sca, u64 *mcn)
+{
+	bool is_esca = test_bit(VSIE_SCA_ESCA, &sca->flags);
+	int i;
+
+	if (!is_esca)
+		return ((struct bsca_block *)phys_to_virt(sca->ssca->osca))->mcn == *mcn;
+
+	for (i = 0; i < 4; i++)
+		if (((struct esca_block *)phys_to_virt(sca->ssca->osca))->mcn[i] != sca->mcn[i])
+			return false;
+	return true;
+}
+
 /*
  * Shadow the sca on vsie enter.
  */
 static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	bool do_init_ssca;
 	int rc;
 
 	vsie_page->sca = sca;
@@ -1947,8 +1962,9 @@ static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct
 	if (!use_vsie_sigpif_for(vcpu->kvm, vsie_page))
 		return false;
 
-	/* skip if the guest does not have an usable sca */
-	if (!sca->ssca->osca) {
+	do_init_ssca = !sca->ssca->osca;
+	do_init_ssca = do_init_ssca || !sca_mcn_equals(sca, sca->mcn);
+	if (do_init_ssca) {
 		rc = init_ssca(vcpu, vsie_page, sca);
 		if (rc)
 			return rc;

-- 
2.51.1


