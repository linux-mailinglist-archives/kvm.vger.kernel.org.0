Return-Path: <kvm+bounces-17940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 538178CBD35
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 10:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D18A61F220CF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FB680039;
	Wed, 22 May 2024 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aBpliW2R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173947868B;
	Wed, 22 May 2024 08:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367816; cv=none; b=cE3BXl6hV/cVkAilI+3dIxUtrAloJ5bn7EN8nUpn8BqXbnir0cAHkNsfF8cmkuD3b+5y6zE0P6rqbTnNzXH34nuLn1o6R+i/R+kMF1pzJ97tYDfRhrkiup849bzdF/LQXlO6HDKVD7BMXz3+buOtRAv81AIHrQefbqoil/QYE8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367816; c=relaxed/simple;
	bh=yEeshlxO/0CfqQYE1FNW1skQXI/vD8pClNE0P6qCtH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M/uhg1jmyx0bSQFJKfU25caJkEU2DW5bw0t8GU5Jw1oGmKIyT7cZNYcGXkVdBf2SH1HBDFHGjNn1TWDUr/erTEpCmohnUKL6W1krEBEQCmKaOuewR7RTJ1JYtdx3DR0mdwAT0Z/+HOz1W478HwbdqhsX14XeEsjuvp0sK2TkpkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aBpliW2R; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44M8Sooa030448;
	Wed, 22 May 2024 08:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Z+0PgAr/eLLew9MiU3rUy2s/5OX4IfXRIb2c/9wgeIg=;
 b=aBpliW2RTzOiUyqEmfaCatkLa8GwnGQSAVO+XxJIP1ukznkk/BoIPLez6VPju6jAnr3J
 RnmCvqORgNKVGdfF44O+PxODm2zvy/0pDrq3nXqIubFcckL4vgl4hvk4WazGiD8oW3JI
 3fpV0N+9AddnT5CTkDRpS40VhZezfEJI50ZOBVlrSzPF83/qnTobe1xKcfZlaraTgsPz
 HVnncFk2opnI4+r1njPjFd5EQIUfc3qcxcEk+TeMCDzNadDj22WJZrrTnSC205vp+Gd9
 BB4oG++aBjir7liRqFrLhBK7EL8xASKBMUCmHVX0Qa1ZWryDRb1CuDwiUCHDogJzwTu2 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9d7gg22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:50:01 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44M8o0PI000625;
	Wed, 22 May 2024 08:50:01 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9d7gg22j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:50:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44M6P4cg023533;
	Wed, 22 May 2024 08:50:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77npb0v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:50:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44M8nsX432113390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 08:49:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4495B2004E;
	Wed, 22 May 2024 08:49:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1261220043;
	Wed, 22 May 2024 08:49:52 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 May 2024 08:49:51 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1 RESEND] arch/powerpc/kvm: Fix doorbell emulation by adding DPDES support
Date: Wed, 22 May 2024 14:19:45 +0530
Message-ID: <20240522084949.123148-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7twMTi4uoBrGCFf2IsEijlHqmFUwJa5t
X-Proofpoint-ORIG-GUID: qdE9fAFu7Aqy0159yFHb6JtGiyF5pLuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_03,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=577 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220063

Doorbell emulation is broken for KVM on PowerVM guests as support for
DPDES was not added in the initial patch series. Due to this, a KVM on
PowerVM guest cannot be booted with the XICS interrupt controller as
doorbells are to be setup in the initial probe path when using XICS
(pSeries_smp_probe()). Add DPDES support in the host KVM code to fix
doorbell emulation.

Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v1 -> v1 resend:
1. Add the stable tag

 Documentation/arch/powerpc/kvm-nested.rst     |  4 +++-
 arch/powerpc/include/asm/guest-state-buffer.h |  3 ++-
 arch/powerpc/include/asm/kvm_book3s.h         |  1 +
 arch/powerpc/kvm/book3s_hv.c                  | 14 +++++++++++++-
 arch/powerpc/kvm/book3s_hv_nestedv2.c         |  7 +++++++
 arch/powerpc/kvm/test-guest-state-buffer.c    |  2 +-
 6 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
index 630602a8aa00..5defd13cc6c1 100644
--- a/Documentation/arch/powerpc/kvm-nested.rst
+++ b/Documentation/arch/powerpc/kvm-nested.rst
@@ -546,7 +546,9 @@ table information.
 +--------+-------+----+--------+----------------------------------+
 | 0x1052 | 0x08  | RW |   T    | CTRL                             |
 +--------+-------+----+--------+----------------------------------+
-| 0x1053-|       |    |        | Reserved                         |
+| 0x1053 | 0x08  | RW |   T    | DPDES                            |
++--------+-------+----+--------+----------------------------------+
+| 0x1054-|       |    |        | Reserved                         |
 | 0x1FFF |       |    |        |                                  |
 +--------+-------+----+--------+----------------------------------+
 | 0x2000 | 0x04  | RW |   T    | CR                               |
diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/powerpc/include/asm/guest-state-buffer.h
index 808149f31576..d107abe1468f 100644
--- a/arch/powerpc/include/asm/guest-state-buffer.h
+++ b/arch/powerpc/include/asm/guest-state-buffer.h
@@ -81,6 +81,7 @@
 #define KVMPPC_GSID_HASHKEYR			0x1050
 #define KVMPPC_GSID_HASHPKEYR			0x1051
 #define KVMPPC_GSID_CTRL			0x1052
+#define KVMPPC_GSID_DPDES			0x1053
 
 #define KVMPPC_GSID_CR				0x2000
 #define KVMPPC_GSID_PIDR			0x2001
@@ -110,7 +111,7 @@
 #define KVMPPC_GSE_META_COUNT (KVMPPC_GSE_META_END - KVMPPC_GSE_META_START + 1)
 
 #define KVMPPC_GSE_DW_REGS_START KVMPPC_GSID_GPR(0)
-#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_CTRL
+#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_DPDES
 #define KVMPPC_GSE_DW_REGS_COUNT \
 	(KVMPPC_GSE_DW_REGS_END - KVMPPC_GSE_DW_REGS_START + 1)
 
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 3e1e2a698c9e..10618622d7ef 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -594,6 +594,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 
 
 KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64, KVMPPC_GSID_VTB)
+KVMPPC_BOOK3S_VCORE_ACCESSOR(dpdes, 64, KVMPPC_GSID_DPDES)
 KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32, KVMPPC_GSID_LOGICAL_PVR)
 KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64, KVMPPC_GSID_LPCR)
 KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(tb_offset, 64, KVMPPC_GSID_TB_OFFSET)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 35cb014a0c51..cf285e5153ba 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	int trap;
 	long rc;
 
+	if (vcpu->arch.doorbell_request) {
+		vcpu->arch.doorbell_request = 0;
+		kvmppc_set_dpdes(vcpu, 1);
+	}
+
 	io = &vcpu->arch.nestedv2_io;
 
 	msr = mfmsr();
@@ -4278,9 +4283,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (kvmhv_on_pseries()) {
 		if (kvmhv_is_nestedv1())
 			trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
-		else
+		else {
 			trap = kvmhv_vcpu_entry_nestedv2(vcpu, time_limit, lpcr, tb);
 
+			/* Remember doorbell if it is pending  */
+			if (kvmppc_get_dpdes(vcpu)) {
+				vcpu->arch.doorbell_request = 1;
+				kvmppc_set_dpdes(vcpu, 0);
+			}
+		}
+
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !nested &&
 		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index 8e6f5355f08b..36863fff2a99 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -311,6 +311,10 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
 			rc = kvmppc_gse_put_u64(gsb, iden,
 						vcpu->arch.vcore->vtb);
 			break;
+		case KVMPPC_GSID_DPDES:
+			rc = kvmppc_gse_put_u64(gsb, iden,
+						vcpu->arch.vcore->dpdes);
+			break;
 		case KVMPPC_GSID_LPCR:
 			rc = kvmppc_gse_put_u64(gsb, iden,
 						vcpu->arch.vcore->lpcr);
@@ -543,6 +547,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc_gs_msg *gsm,
 		case KVMPPC_GSID_VTB:
 			vcpu->arch.vcore->vtb = kvmppc_gse_get_u64(gse);
 			break;
+		case KVMPPC_GSID_DPDES:
+			vcpu->arch.vcore->dpdes = kvmppc_gse_get_u64(gse);
+			break;
 		case KVMPPC_GSID_LPCR:
 			vcpu->arch.vcore->lpcr = kvmppc_gse_get_u64(gse);
 			break;
diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kvm/test-guest-state-buffer.c
index 4720b8dc8837..91ae660cfe21 100644
--- a/arch/powerpc/kvm/test-guest-state-buffer.c
+++ b/arch/powerpc/kvm/test-guest-state-buffer.c
@@ -151,7 +151,7 @@ static void test_gs_bitmap(struct kunit *test)
 		i++;
 	}
 
-	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSID_CTRL; iden++) {
+	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSID_DPDES; iden++) {
 		kvmppc_gsbm_set(&gsbm, iden);
 		kvmppc_gsbm_set(&gsbm1, iden);
 		KUNIT_EXPECT_TRUE(test, kvmppc_gsbm_test(&gsbm, iden));
-- 
2.45.0


