Return-Path: <kvm+bounces-8038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C670484A1FC
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 19:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36C6D1F22CD0
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D719C481B1;
	Mon,  5 Feb 2024 18:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aK9AHZlL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E1A45974;
	Mon,  5 Feb 2024 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707157141; cv=none; b=peh+cBX0hqc3G53C+JgRhZhElxXV0Ix5RYNNc7g/osQw6VmaT6ZlOsDKH2DX0Vg9pwwdaDvrYbpKs8WkOTgwfPFiDytZT/ru55WyWK06np+hiYGehlSlNj97/QMPizOaFS1CB0A0s3NOEddoHl2i0vpFUTWHqHxoBmTfk6MSoJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707157141; c=relaxed/simple;
	bh=hBYrC30RdNRdKCfKA9EFp1rJ5kkeCllFZfWAQ3T5zvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dxMMUo1ooqCO9JbGLy2lODQV9POfF3QmuVLCXA/jLQ8/UvOH3ysfeGyrxU4Va2hzf1f/jNJG9wc92jIv3U/vKvty8w2UOz2TAQobCtTe9DSdlSjboOdy4yjETs/bFXlnkDQSU4ZXxYsY5R2v6l0ORHFHtbl/24xWNXrV+8xrVBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aK9AHZlL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415IITo4006991;
	Mon, 5 Feb 2024 18:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=7FZq3UKocrSdIKqb/HIHHIxnBLE3eJesaiVq6qENOmQ=;
 b=aK9AHZlL3h7U9VYkkszgSpiR6I8EO3Gge0GeM77H5VE0xLd2IEqo6+2l67HeKFodGiMJ
 oFWfZ943782f+zc9xvzITQyTunw+P5XZZ2ak+U7ME6K7eTNL8Sz6vXGZ6ONWh2id7Yag
 ZF8Zp4IuuNkcBUGsIaKsD11vXppcKM7t3iN9pj2a0jPplD5TemFOz3jR15BnMb34Ht0C
 N14D/WQ32ecMdQZc2ASdGWoeqaqKAO6W7diWMGc3l60UjsFimaLZLCxmccbaJJIe94O5
 YU0HSTmWjru68A6N4XAiWuqERAgKxzQIAA0CKtvvzbcMJwvAg2bLRNCy7jaSWrmbiMuD Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w34u50075-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:18:46 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415IIZwB007304;
	Mon, 5 Feb 2024 18:18:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w34u5006u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:18:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415GekxN014865;
	Mon, 5 Feb 2024 18:18:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tnj4vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:18:45 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415IIgo140239522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 18:18:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 557B220040;
	Mon,  5 Feb 2024 18:18:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 436BE20043;
	Mon,  5 Feb 2024 18:18:39 +0000 (GMT)
Received: from li-a83676cc-350e-11b2-a85c-e11f86bb8d73.ibm.com.com (unknown [9.43.55.162])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Feb 2024 18:18:39 +0000 (GMT)
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Amit Machhiwal <amachhiw@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to empty 'arch_compat'
Date: Mon,  5 Feb 2024 23:48:33 +0530
Message-ID: <20240205181833.212955-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CYr3oYuRF9ndfHDrfIlv9Y5hzJStxe98
X-Proofpoint-ORIG-GUID: 6VBeCFRo2XRuVcwoMmETR36z-NQiZAa7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_12,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=894 priorityscore=1501
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050138

Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
below error as L1 qemu sends PVR value 'arch_compat' == 0 via
ppc_set_compat ioctl. This triggers a condition failure in
kvmppc_set_arch_compat() resulting in an EINVAL.

qemu-system-ppc64: Unable to set CPU compatibility mode in KVM: Invalid
argument

Also, a value of 0 for arch_compat generally refers the default
compatibility of the host. But, arch_compat, being a Guest Wide Element
in nested API v2, cannot be set to 0 in GSB as PowerVM (L0) expects a
non-zero value. A value of 0 triggers a kernel trap during a reboot and
consequently causes it to fail:

[   22.106360] reboot: Restarting system
KVM: unknown exit, hardware reason ffffffffffffffea
NIP 0000000000000100   LR 000000000000fe44 CTR 0000000000000000 XER 0000000020040092 CPU#0
MSR 0000000000001000 HID0 0000000000000000  HF 6c000000 iidx 3 didx 3
TB 00000000 00000000 DECR 0
GPR00 0000000000000000 0000000000000000 c000000002a8c300 000000007fe00000
GPR04 0000000000000000 0000000000000000 0000000000001002 8000000002803033
GPR08 000000000a000000 0000000000000000 0000000000000004 000000002fff0000
GPR12 0000000000000000 c000000002e10000 0000000105639200 0000000000000004
GPR16 0000000000000000 000000010563a090 0000000000000000 0000000000000000
GPR20 0000000105639e20 00000001056399c8 00007fffe54abab0 0000000105639288
GPR24 0000000000000000 0000000000000001 0000000000000001 0000000000000000
GPR28 0000000000000000 0000000000000000 c000000002b30840 0000000000000000
CR 00000000  [ -  -  -  -  -  -  -  -  ]     RES 000@ffffffffffffffff
 SRR0 0000000000000000  SRR1 0000000000000000    PVR 0000000000800200 VRSAVE 0000000000000000
SPRG0 0000000000000000 SPRG1 0000000000000000  SPRG2 0000000000000000  SPRG3 0000000000000000
SPRG4 0000000000000000 SPRG5 0000000000000000  SPRG6 0000000000000000  SPRG7 0000000000000000
HSRR0 0000000000000000 HSRR1 0000000000000000
 CFAR 0000000000000000
 LPCR 0000000000020400
 PTCR 0000000000000000   DAR 0000000000000000  DSISR 0000000000000000

 kernel:trap=0xffffffea | pc=0x100 | msr=0x1000

This patch updates kvmppc_set_arch_compat() to use the host PVR value if
'compat_pvr' == 0 indicating that qemu doesn't want to enforce any
specific PVR compat mode.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Reviewed-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---

Changes v2 -> v3:
    - Vaibhav: Use a 'break' instead of switch-case fallthrough
    - v2: https://lore.kernel.org/all/20240205132607.2776637-1-amachhiw@linux.ibm.com/

Changes v1 -> v2:
    - Added descriptive error log in the patch description when
      `arch_compat == 0` passed in GSB
    - Added a helper function for PCR to capabilities mapping
    - Added relevant comments around the changes being made
    - v1: https://lore.kernel.org/lkml/20240118095653.2588129-1-amachhiw@linux.ibm.com/

 arch/powerpc/kvm/book3s_hv.c          | 26 ++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv_nestedv2.c | 23 +++++++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 52427fc2a33f..0b921704da45 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -391,6 +391,24 @@ static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
 /* Dummy value used in computing PCR value below */
 #define PCR_ARCH_31    (PCR_ARCH_300 << 1)
 
+static inline unsigned long map_pcr_to_cap(unsigned long pcr)
+{
+	unsigned long cap = 0;
+
+	switch (pcr) {
+	case PCR_ARCH_300:
+		cap = H_GUEST_CAP_POWER9;
+		break;
+	case PCR_ARCH_31:
+		cap = H_GUEST_CAP_POWER10;
+		break;
+	default:
+		break;
+	}
+
+	return cap;
+}
+
 static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 {
 	unsigned long host_pcr_bit = 0, guest_pcr_bit = 0, cap = 0;
@@ -424,11 +442,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 			break;
 		case PVR_ARCH_300:
 			guest_pcr_bit = PCR_ARCH_300;
-			cap = H_GUEST_CAP_POWER9;
 			break;
 		case PVR_ARCH_31:
 			guest_pcr_bit = PCR_ARCH_31;
-			cap = H_GUEST_CAP_POWER10;
 			break;
 		default:
 			return -EINVAL;
@@ -440,6 +456,12 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 		return -EINVAL;
 
 	if (kvmhv_on_pseries() && kvmhv_is_nestedv2()) {
+		/*
+		 * 'arch_compat == 0' would mean the guest should default to
+		 * L1's compatibility. In this case, the guest would pick
+		 * host's PCR and evaluate the corresponding capabilities.
+		 */
+		cap = map_pcr_to_cap(guest_pcr_bit);
 		if (!(cap & nested_capabilities))
 			return -EINVAL;
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index 5378eb40b162..6042bdc70230 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -138,6 +138,7 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 	vector128 v;
 	int rc, i;
 	u16 iden;
+	u32 arch_compat = 0;
 
 	vcpu = gsm->data;
 
@@ -347,8 +348,26 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 			break;
 		}
 		case KVMPPC_GSID_LOGICAL_PVR:
-			rc = kvmppc_gse_put_u32(gsb, iden,
-						vcpu->arch.vcore->arch_compat);
+			/*
+			 * Though 'arch_compat == 0' would mean the default
+			 * compatibility, arch_compat, being a Guest Wide
+			 * Element, cannot be filled with a value of 0 in GSB
+			 * as this would result into a kernel trap.
+			 * Hence, when `arch_compat == 0`, arch_compat should
+			 * default to L1's PVR.
+			 *
+			 * Rework this when PowerVM supports a value of 0
+			 * for arch_compat for KVM API v2.
+			 */
+			if (!vcpu->arch.vcore->arch_compat) {
+				if (cpu_has_feature(CPU_FTR_ARCH_31))
+					arch_compat = PVR_ARCH_31;
+				else if (cpu_has_feature(CPU_FTR_ARCH_300))
+					arch_compat = PVR_ARCH_300;
+			} else {
+				arch_compat = vcpu->arch.vcore->arch_compat;
+			}
+			rc = kvmppc_gse_put_u32(gsb, iden, arch_compat);
 			break;
 		}
 

base-commit: 6764c317b6bb91bd806ef79adf6d9c0e428b191e
-- 
2.43.0


