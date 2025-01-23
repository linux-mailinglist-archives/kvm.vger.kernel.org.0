Return-Path: <kvm+bounces-36345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D7EA1A3D5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B962816A1AF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C24520F07C;
	Thu, 23 Jan 2025 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="afDBaJm8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222F520F07A;
	Thu, 23 Jan 2025 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737634098; cv=none; b=YyK0s+u1frHV7zHHS/5/UScNxmIvMJMxSP+i0H9bPlJdoXHLoFYhmrmPZqCrxrKD6doq8v2wF2A/niLRh+aQDt5z6hLZfTRF0dYT9PYrn/O3TW6Yh5jys85ga7UbXV4Dsb6WyDpPAiRKM76TMJSWg0oS+N6GzLMyau8jw4wrDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737634098; c=relaxed/simple;
	bh=x12bX+u/EvJLWD+9FMcS+zdl69sVv26wLkEXAkmKNeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBnhfk0zn8lEvzVGHEgBHaY4v4BDUrrNkGLiv0LTgra6fgvAoGr+L4WTRW7PMT03kDBXWEtZsaaRNJkXeztj13M3fU3lnABPyRy/N+gj2JppMlgLXZ++FcmMhQJxVkLb0YJ/+GEkCdF0g0hxmYX9xILcKRxPDrRCl8AtkcJcivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=afDBaJm8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N5O55l026549;
	Thu, 23 Jan 2025 12:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lCVt9vOPwrc3Wkv51
	dfdWe+UXE06yn6de7E5TeZ1XDY=; b=afDBaJm8KBjRjMNAk1keI/X8vRsUPBV7g
	UVBKXEGsPb+vZVj61KwZERJddCB/pHp49VLNR52Xm8jLod62ykKvVaUnHrobv/rr
	BAyGsrh2rUVDE80QmggU8X5AV4G2F6hCw4KLOUhqEBgCiRpATMGZf7KpcRUZz3R7
	W1AmFXzKueNhILiw/iCL6A6Rs4RZ6muVahRXZcPZsLOrlazE3E9itGjv4u/Rer08
	UWa0CKnkgtR3phuUXLhilurQn36vry9OdCll+KdxszMnvGPYi6YjI9yZWTNyZGjX
	6BURIfVWbcv1NWpBTLzm79+peYse1BgX5GNJnlH5zEjhfyilZWYdw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bfk7sth9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NC66Ih023431;
	Thu, 23 Jan 2025 12:08:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bfk7sth5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50N9Zpik019287;
	Thu, 23 Jan 2025 12:08:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pmsnm04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NC846432047438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 12:08:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BF2920040;
	Thu, 23 Jan 2025 12:08:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B45882004B;
	Thu, 23 Jan 2025 12:08:00 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.34])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 23 Jan 2025 12:08:00 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Thu, 23 Jan 2025 17:37:59 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH v3 2/6] kvm powerpc/book3s-apiv2: Add support for Hostwide GSB elements
Date: Thu, 23 Jan 2025 17:37:44 +0530
Message-ID: <20250123120749.90505-3-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123120749.90505-1-vaibhav@linux.ibm.com>
References: <20250123120749.90505-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h5FhlaVxyL6iMawfYg3CSgxvMJs3A41Z
X-Proofpoint-ORIG-GUID: cj8BiGem9aEge0hVzlt3PUhzJiv37hQm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_05,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230091

Add support for adding and parsing Hostwide elements to the
Guest-state-buffer data structure used in apiv2. These elements are used to
share meta-information pertaining to entire L1-Lpar and this
meta-information is maintained by L0-PowerVM hypervisor. Example of this
include the amount of the page-table memory currently used by L0-PowerVM
for hosting the Shadow-Pagetable of all active L2-Guests. More of the are
documented in kernel-documentation at [1]. The Hostwide GSB elements are
currently only support with H_GUEST_SET_STATE hcall with a special flag
namely 'KVMPPC_GS_FLAGS_HOST_WIDE'.

The patch introduces new defs for the 5 new Hostwide GSB elements including
their GSIDs as well as introduces a new class of GSB elements namely
'KVMPPC_GS_CLASS_HOSTWIDE' to indicate to GSB construction/parsing
infrastructure in 'kvm/guest-state-buffer.c'. Also
gs_msg_ops_vcpu_get_size(), kvmppc_gsid_type() and
kvmppc_gse_{flatten,unflatten}_iden() are updated to appropriately indicate
the needed size for these Hostwide GSB elements as well as how to
flatten/unflatten their GSIDs so that they can be marked as available in
GSB bitmap.

[1] Documention/arch/powerpc/kvm-nested.rst

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog

v2->v3:
None

v1->v2:
None
---
 arch/powerpc/include/asm/guest-state-buffer.h | 35 ++++++++++++++---
 arch/powerpc/include/asm/hvcall.h             | 13 ++++---
 arch/powerpc/kvm/book3s_hv_nestedv2.c         |  6 +++
 arch/powerpc/kvm/guest-state-buffer.c         | 39 +++++++++++++++++++
 4 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/powerpc/include/asm/guest-state-buffer.h
index d107abe1468f..acd61eb36d59 100644
--- a/arch/powerpc/include/asm/guest-state-buffer.h
+++ b/arch/powerpc/include/asm/guest-state-buffer.h
@@ -28,6 +28,21 @@
  /* Process Table Info */
 #define KVMPPC_GSID_PROCESS_TABLE		0x0006
 
+/* Guest Management Heap Size */
+#define KVMPPC_GSID_L0_GUEST_HEAP		0x0800
+
+/* Guest Management Heap Max Size */
+#define KVMPPC_GSID_L0_GUEST_HEAP_MAX		0x0801
+
+/* Guest Pagetable Size */
+#define KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE	0x0802
+
+/* Guest Pagetable Max Size */
+#define KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX	0x0803
+
+/* Guest Pagetable Reclaim in bytes */
+#define KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM	0x0804
+
 /* H_GUEST_RUN_VCPU input buffer Info */
 #define KVMPPC_GSID_RUN_INPUT			0x0C00
 /* H_GUEST_RUN_VCPU output buffer Info */
@@ -106,6 +121,11 @@
 #define KVMPPC_GSE_GUESTWIDE_COUNT \
 	(KVMPPC_GSE_GUESTWIDE_END - KVMPPC_GSE_GUESTWIDE_START + 1)
 
+#define KVMPPC_GSE_HOSTWIDE_START KVMPPC_GSID_L0_GUEST_HEAP
+#define KVMPPC_GSE_HOSTWIDE_END KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM
+#define KVMPPC_GSE_HOSTWIDE_COUNT \
+	(KVMPPC_GSE_HOSTWIDE_END - KVMPPC_GSE_HOSTWIDE_START + 1)
+
 #define KVMPPC_GSE_META_START KVMPPC_GSID_RUN_INPUT
 #define KVMPPC_GSE_META_END KVMPPC_GSID_VPA
 #define KVMPPC_GSE_META_COUNT (KVMPPC_GSE_META_END - KVMPPC_GSE_META_START + 1)
@@ -130,7 +150,8 @@
 	(KVMPPC_GSE_INTR_REGS_END - KVMPPC_GSE_INTR_REGS_START + 1)
 
 #define KVMPPC_GSE_IDEN_COUNT                                 \
-	(KVMPPC_GSE_GUESTWIDE_COUNT + KVMPPC_GSE_META_COUNT + \
+	(KVMPPC_GSE_HOSTWIDE_COUNT + \
+	 KVMPPC_GSE_GUESTWIDE_COUNT + KVMPPC_GSE_META_COUNT + \
 	 KVMPPC_GSE_DW_REGS_COUNT + KVMPPC_GSE_W_REGS_COUNT + \
 	 KVMPPC_GSE_VSRS_COUNT + KVMPPC_GSE_INTR_REGS_COUNT)
 
@@ -139,10 +160,11 @@
  */
 enum {
 	KVMPPC_GS_CLASS_GUESTWIDE = 0x01,
-	KVMPPC_GS_CLASS_META = 0x02,
-	KVMPPC_GS_CLASS_DWORD_REG = 0x04,
-	KVMPPC_GS_CLASS_WORD_REG = 0x08,
-	KVMPPC_GS_CLASS_VECTOR = 0x10,
+	KVMPPC_GS_CLASS_HOSTWIDE = 0x02,
+	KVMPPC_GS_CLASS_META = 0x04,
+	KVMPPC_GS_CLASS_DWORD_REG = 0x08,
+	KVMPPC_GS_CLASS_WORD_REG = 0x10,
+	KVMPPC_GS_CLASS_VECTOR = 0x18,
 	KVMPPC_GS_CLASS_INTR = 0x20,
 };
 
@@ -164,6 +186,7 @@ enum {
  */
 enum {
 	KVMPPC_GS_FLAGS_WIDE = 0x01,
+	KVMPPC_GS_FLAGS_HOST_WIDE = 0x02,
 };
 
 /**
@@ -287,7 +310,7 @@ struct kvmppc_gs_msg_ops {
  * struct kvmppc_gs_msg - a guest state message
  * @bitmap: the guest state ids that should be included
  * @ops: modify message behavior for reading and writing to buffers
- * @flags: guest wide or thread wide
+ * @flags: host wide, guest wide or thread wide
  * @data: location where buffer data will be written to or from.
  *
  * A guest state message is allows flexibility in sending in receiving data
diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 65d1f291393d..1c12713538a4 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -489,14 +489,15 @@
 #define H_RPTI_PAGE_ALL (-1UL)
 
 /* Flags for H_GUEST_{S,G}_STATE */
-#define H_GUEST_FLAGS_WIDE     (1UL<<(63-0))
+#define H_GUEST_FLAGS_WIDE     (1UL << (63 - 0))
+#define H_GUEST_FLAGS_HOST_WIDE	(1UL << (63 - 1))
 
 /* Flag values used for H_{S,G}SET_GUEST_CAPABILITIES */
-#define H_GUEST_CAP_COPY_MEM	(1UL<<(63-0))
-#define H_GUEST_CAP_POWER9	(1UL<<(63-1))
-#define H_GUEST_CAP_POWER10	(1UL<<(63-2))
-#define H_GUEST_CAP_POWER11	(1UL<<(63-3))
-#define H_GUEST_CAP_BITMAP2	(1UL<<(63-63))
+#define H_GUEST_CAP_COPY_MEM	(1UL << (63 - 0))
+#define H_GUEST_CAP_POWER9	(1UL << (63 - 1))
+#define H_GUEST_CAP_POWER10	(1UL << (63 - 2))
+#define H_GUEST_CAP_POWER11	(1UL << (63 - 3))
+#define H_GUEST_CAP_BITMAP2	(1UL << (63 - 63))
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index e5c7ce1fb761..87691cf86cae 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -123,6 +123,12 @@ static size_t gs_msg_ops_vcpu_get_size(struct kvmppc_gs_msg *gsm)
 		case KVMPPC_GSID_PROCESS_TABLE:
 		case KVMPPC_GSID_RUN_INPUT:
 		case KVMPPC_GSID_RUN_OUTPUT:
+		  /* Host wide counters */
+		case KVMPPC_GSID_L0_GUEST_HEAP:
+		case KVMPPC_GSID_L0_GUEST_HEAP_MAX:
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE:
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX:
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM:
 			break;
 		default:
 			size += kvmppc_gse_total_size(kvmppc_gsid_size(iden));
diff --git a/arch/powerpc/kvm/guest-state-buffer.c b/arch/powerpc/kvm/guest-state-buffer.c
index b80dbc58621f..871cf60ddeb6 100644
--- a/arch/powerpc/kvm/guest-state-buffer.c
+++ b/arch/powerpc/kvm/guest-state-buffer.c
@@ -92,6 +92,10 @@ static int kvmppc_gsid_class(u16 iden)
 	    (iden <= KVMPPC_GSE_GUESTWIDE_END))
 		return KVMPPC_GS_CLASS_GUESTWIDE;
 
+	if ((iden >= KVMPPC_GSE_HOSTWIDE_START) &&
+	    (iden <= KVMPPC_GSE_HOSTWIDE_END))
+		return KVMPPC_GS_CLASS_HOSTWIDE;
+
 	if ((iden >= KVMPPC_GSE_META_START) && (iden <= KVMPPC_GSE_META_END))
 		return KVMPPC_GS_CLASS_META;
 
@@ -118,6 +122,21 @@ static int kvmppc_gsid_type(u16 iden)
 	int type = -1;
 
 	switch (kvmppc_gsid_class(iden)) {
+	case KVMPPC_GS_CLASS_HOSTWIDE:
+		switch (iden) {
+		case KVMPPC_GSID_L0_GUEST_HEAP:
+			fallthrough;
+		case KVMPPC_GSID_L0_GUEST_HEAP_MAX:
+			fallthrough;
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE:
+			fallthrough;
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX:
+			fallthrough;
+		case KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM:
+			type = KVMPPC_GSE_BE64;
+			break;
+		}
+		break;
 	case KVMPPC_GS_CLASS_GUESTWIDE:
 		switch (iden) {
 		case KVMPPC_GSID_HOST_STATE_SIZE:
@@ -187,6 +206,9 @@ unsigned long kvmppc_gsid_flags(u16 iden)
 	case KVMPPC_GS_CLASS_GUESTWIDE:
 		flags = KVMPPC_GS_FLAGS_WIDE;
 		break;
+	case KVMPPC_GS_CLASS_HOSTWIDE:
+		flags = KVMPPC_GS_FLAGS_HOST_WIDE;
+		break;
 	case KVMPPC_GS_CLASS_META:
 	case KVMPPC_GS_CLASS_DWORD_REG:
 	case KVMPPC_GS_CLASS_WORD_REG:
@@ -310,6 +332,13 @@ static inline int kvmppc_gse_flatten_iden(u16 iden)
 
 	bit += KVMPPC_GSE_GUESTWIDE_COUNT;
 
+	if (class == KVMPPC_GS_CLASS_HOSTWIDE) {
+		bit += iden - KVMPPC_GSE_HOSTWIDE_START;
+		return bit;
+	}
+
+	bit += KVMPPC_GSE_HOSTWIDE_COUNT;
+
 	if (class == KVMPPC_GS_CLASS_META) {
 		bit += iden - KVMPPC_GSE_META_START;
 		return bit;
@@ -356,6 +385,12 @@ static inline u16 kvmppc_gse_unflatten_iden(int bit)
 	}
 	bit -= KVMPPC_GSE_GUESTWIDE_COUNT;
 
+	if (bit < KVMPPC_GSE_HOSTWIDE_COUNT) {
+		iden = KVMPPC_GSE_HOSTWIDE_START + bit;
+		return iden;
+	}
+	bit -= KVMPPC_GSE_HOSTWIDE_COUNT;
+
 	if (bit < KVMPPC_GSE_META_COUNT) {
 		iden = KVMPPC_GSE_META_START + bit;
 		return iden;
@@ -588,6 +623,8 @@ int kvmppc_gsb_send(struct kvmppc_gs_buff *gsb, unsigned long flags)
 
 	if (flags & KVMPPC_GS_FLAGS_WIDE)
 		hflags |= H_GUEST_FLAGS_WIDE;
+	if (flags & KVMPPC_GS_FLAGS_HOST_WIDE)
+		hflags |= H_GUEST_FLAGS_HOST_WIDE;
 
 	rc = plpar_guest_set_state(hflags, gsb->guest_id, gsb->vcpu_id,
 				   __pa(gsb->hdr), gsb->capacity, &i);
@@ -613,6 +650,8 @@ int kvmppc_gsb_recv(struct kvmppc_gs_buff *gsb, unsigned long flags)
 
 	if (flags & KVMPPC_GS_FLAGS_WIDE)
 		hflags |= H_GUEST_FLAGS_WIDE;
+	if (flags & KVMPPC_GS_FLAGS_HOST_WIDE)
+		hflags |= H_GUEST_FLAGS_HOST_WIDE;
 
 	rc = plpar_guest_get_state(hflags, gsb->guest_id, gsb->vcpu_id,
 				   __pa(gsb->hdr), gsb->capacity, &i);
-- 
2.48.1


