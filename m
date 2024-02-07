Return-Path: <kvm+bounces-8207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A958484C472
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 06:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D17CB24590
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA9A1CD2E;
	Wed,  7 Feb 2024 05:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mTiFNkKV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1311CD13;
	Wed,  7 Feb 2024 05:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707284751; cv=none; b=bdMuCeT1f65qKRSzO79tNKBWK/pNyV98c0WilKsqdXqG5SzmNHvIODp++v8bzVfCaAPRbSiXfRjfyu04M9isSRAe5gt2h+SlivN6eg1YbYKKvxqC0vTvCKjHNqflUMEpnH+8CbFZFNN8nhsU0l6M+G/KkqDgJtxzuTTIl4FiO50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707284751; c=relaxed/simple;
	bh=ZG5O/oDpuPyqi/II+mnqqiRy90UtJUFQDlRfxvNX4yc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y/6XmIkQlAdR7T8vymwBrZ/SD2tnrz6cDmiXXPIPQuPddd6kvilRCgNuC+EwpMU5TeV7zrWZ/kCByB1vg8TmaaqpZrxb8Igwuo08oSITTvpHEkVSm1fKKlV8bciT7VeUwF85PA1mLdiEGJS29Aj8eI0dYSPutO4rJQJpAt+jOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mTiFNkKV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4174WIxH029726;
	Wed, 7 Feb 2024 05:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=2q9wYdLiAFypv56eU29otYgs1NbtQUDBWRKXs+vMQ+o=;
 b=mTiFNkKVjAWnHQO6sqs+diV+DCZQMY8CkUHq0CezFM6QM+VyaActbTTrpYbMEtugk59c
 ZohMqnK5LcSat7AaDSHKnqLfdxOnFu6YjdYtgoIxD/o2TUPPZzKRsH4bGtWYgV2FQQsH
 A/JopcIW0wBA3QH2Qwdn3bg/+VN/b77q6ULhXRSUgTFDKqiLQ4BmeYpLcceyf/D/JJKh
 1aYdQbi255y6RnfKll7U2mAS5Kmx3p8MuWMqFahGAFHDXSNCqenCndgBkQoklbKeTHaU
 trNwypr+7aGD2aTV5aFDqdwmKILf0IhCfxMAKayHGt9eoFJW3BL31GRkuHirETYyHnIU 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w42x0sd3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:45:37 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4175069Y010592;
	Wed, 7 Feb 2024 05:45:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w42x0sd3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:45:36 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4173O3WP020375;
	Wed, 7 Feb 2024 05:45:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w1ytt44c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:45:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4175jXSv7668468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Feb 2024 05:45:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DADDB2004B;
	Wed,  7 Feb 2024 05:45:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9E0620043;
	Wed,  7 Feb 2024 05:45:29 +0000 (GMT)
Received: from li-a83676cc-350e-11b2-a85c-e11f86bb8d73.ibm.com.com (unknown [9.43.65.120])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 Feb 2024 05:45:29 +0000 (GMT)
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
Subject: [PATCH v4] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to empty 'arch_compat'
Date: Wed,  7 Feb 2024 11:15:26 +0530
Message-ID: <20240207054526.3720087-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D_8x-I_1CFHt3jP_reTtRMUSv5nBlPCW
X-Proofpoint-GUID: FxCSAno3ahqLPxriIWNGCJ8eN7-XyolC
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
 definitions=2024-02-06_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=825 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070041

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

The relevant part of the code might need a rework if PowerVM implements
a support for `arch_compat == 0` in nestedv2 API.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Reviewed-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---

Changes v3 -> v4:
    - Moved part of a code comment around implementation of `arch_compat
      == 0` in PowerVM to the patch description based on an off mailing
      list discussion

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
 arch/powerpc/kvm/book3s_hv_nestedv2.c | 20 ++++++++++++++++++--
 2 files changed, 42 insertions(+), 4 deletions(-)

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
index 5378eb40b162..8e6f5355f08b 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -138,6 +138,7 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 	vector128 v;
 	int rc, i;
 	u16 iden;
+	u32 arch_compat = 0;
 
 	vcpu = gsm->data;
 
@@ -347,8 +348,23 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
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


