Return-Path: <kvm+bounces-18884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9132F8FCA9A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 287EE2835D4
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70154194150;
	Wed,  5 Jun 2024 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BQegtVzk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00015193094;
	Wed,  5 Jun 2024 11:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717587600; cv=none; b=S17KcEucUETnvBAHZI7pn71kkkTYajQRyS21G5rsudIuWZswD91Nl67ksvCghF1drZ+crGX0zfQ3eu5Lm7ioaT6/nsp/9DOYAKkR1AH6JIyBa+FtmEu2uLt3WaHB5wC35fqNarHP1Ihq9k7WdUmSVt2tTXKsJ/ItjN8KLPRPd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717587600; c=relaxed/simple;
	bh=7hXEkwUcH9eXx0Amb8Q07zLPkOj2W3cnD32AxiPRzaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDhEHwVOYv/K5gerX6MeyhsO5/EIHMV9rf98NhZkRYJ9xTkAGmEB0TLz/e8B835mzaTKrMI8gqT3zsvAOsj2eSil3tYi/5jQSZqxauoq5CKdACaOhrzmCLXhDvWkqLspa553OXt6EptblQXbwHO5ovRKpTMOoMUk6dM33XLsPM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BQegtVzk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455BN9iV009559;
	Wed, 5 Jun 2024 11:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=ob5E6h37KGV5gjZ3th932APLfZNBlC0K7WbUVstTGWs=;
 b=BQegtVzkZwHPj89sNNkUpJOnaiZLIUpzBjgsuiQFpfahybtcoeYTvK6RwDngp4ZHcte3
 21INUlM0EYR7Mp8xnyYnPhV2pJ0yZDY0ptQozNikwjQNFtoTeN7Mkx0I9mX3M5bKBygJ
 efH0n5ZthBAPnEZRNsP/ZCNhi2JEGfrKYEX0bojncE5l3b3BP7BvGPcc377qBHWXT3Rl
 vsM5KidXwfgOtyBw02G9or5yEFrHDiyLczM6I+J5SayCVj/qKq/YhayyZJIDCeBFHcck
 2WAssSlN2QBLAZyQmjoxvvsoalXsfO+uK3EAFun+DLJlPnw3HKAlyOFm2W+xEs12We2s DA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjq2xg16w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:40 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455Bdd8Y001543;
	Wed, 5 Jun 2024 11:39:39 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjq2xg16s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:39 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4557wX2w026588;
	Wed, 5 Jun 2024 11:39:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp33c2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 11:39:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455BdX6l52822370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 11:39:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57B222004B;
	Wed,  5 Jun 2024 11:39:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4348320040;
	Wed,  5 Jun 2024 11:39:31 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 11:39:31 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] arch/powerpc/kvm: Add DPDES support in helper library for Guest state buffer
Date: Wed,  5 Jun 2024 17:09:09 +0530
Message-ID: <20240605113913.83715-2-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605113913.83715-1-gautam@linux.ibm.com>
References: <20240605113913.83715-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0b47RC6CzKsfAysGcWYZHPXXdDDRiMs8
X-Proofpoint-GUID: W234iOudpybCN3OwMEEMR4kA7nH3_-V6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=879 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050088

Add support for using DPDES in the library for using guest state
buffers. DPDES support is needed for enabling usage of doorbells in a 
L2 KVM on PAPR guest.

Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffers")
Cc: stable@vger.kernel.org # v6.7
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
 arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
 arch/powerpc/include/asm/kvm_book3s.h         | 1 +
 arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
 arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
 5 files changed, 14 insertions(+), 3 deletions(-)

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
index 4720b8dc8837..2571ccc618c9 100644
--- a/arch/powerpc/kvm/test-guest-state-buffer.c
+++ b/arch/powerpc/kvm/test-guest-state-buffer.c
@@ -151,7 +151,7 @@ static void test_gs_bitmap(struct kunit *test)
 		i++;
 	}
 
-	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSID_CTRL; iden++) {
+	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSE_DW_REGS_END; iden++) {
 		kvmppc_gsbm_set(&gsbm, iden);
 		kvmppc_gsbm_set(&gsbm1, iden);
 		KUNIT_EXPECT_TRUE(test, kvmppc_gsbm_test(&gsbm, iden));
-- 
2.45.1


