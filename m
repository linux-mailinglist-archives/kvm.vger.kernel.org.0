Return-Path: <kvm+bounces-42944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6225EA80EFD
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 16:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A02A1898F5B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 14:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2FA2153D1;
	Tue,  8 Apr 2025 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="i9F0FJC6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAC318FC67
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744123978; cv=none; b=K96L7ucmR0f76u/8Ijbkt3CjVIvt9twwjCh+gdINt11DlMU7IvDDcQwkvO2yzwmgVQnAEoqPfYQm5VHeAD2cKpBi4jAPx0z8p9JFn+KOa2r8c4aIH8xGAQTddji73yIYkV8UtiaL+BbDiGef6Z1iXhV/UFJhFIOj3yVF/uKr5p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744123978; c=relaxed/simple;
	bh=ri5hLBz3BYZn9GUJ6LP2C/RqGNMIUGrvdfD6hIQ1eb4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=APl071jmHbTGUxu7xhVKOarQYxqswJdkZ1Infm1fxS5po5SAAFj13M6AMAqCvPIBbeutgmmfduSzJ0yT3L1+j3Cn0yEgwZA6QeG0Qx7UwNhVVlflD7bh210Yfe4bIr7VXCuTihtpywn8fzPgjsECq6CD7STl4ZaYofGOYDAG4zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=i9F0FJC6; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 538Eo6R1003022
	for <kvm@vger.kernel.org>; Tue, 8 Apr 2025 07:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=FutpzTugB1kF6jB19+
	yX5Fm9gNJ6+nU6Bmh7QDAMwNg=; b=i9F0FJC6LudtvcPSKgHZNKHg3L1zG5MI5h
	iDqPikZqs3RvE8/RnkV9XMHAyjNWdjyY1q5CD5YLR//sAs+MVuxf3a5Pk15TU63G
	/u8NSOm5FQGAbYtvtLTg9ipTPDS0RUANmniettsRjXQqyVQ6fhjhuaQ9ZJBQkGb3
	CstJYL3uHKvxmff9vGpTr5fNaNzIRHOObKm114BknEv9VOCzxtqGpsoIRmFUHcL3
	2Ll7XbNb3ZuwEy18oHKeOflSKXfqqFCnFpTTIJVLxEdBwTku/Nlp2WF4ZpQPuvK1
	f9PNTKTn1Az9gwi7xOtGh7RqvPTRJL/A4H3IgGfsR0XGO/DSA2Fg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45w5whg0rb-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 07:52:55 -0700 (PDT)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 8 Apr 2025 14:52:42 +0000
Received: by devbig286.ash8.facebook.com (Postfix, from userid 535388)
	id 4DCC8E11D434; Tue,  8 Apr 2025 07:52:28 -0700 (PDT)
From: Joshua Lilly <jgl@meta.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
        "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean
 Christopherson <seanjc@google.com>
CC: <Joshua@devbig286.ash8.facebook.com>, <Lilly@devbig286.ash8.facebook.com>,
        <jgl@meta.com>, <kvm@vger.kernel.org>,
        <linux-coco.lists.linux.dev@devbig286.ash8.facebook.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH] Add I/O port filtering for AMDs sev module.
Date: Tue, 8 Apr 2025 07:52:25 -0700
Message-ID: <20250408145225.502757-1-jgl@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: CuHgBhUCZH7QwOwnczZ3_fiTUs-w_2p5
X-Proofpoint-ORIG-GUID: CuHgBhUCZH7QwOwnczZ3_fiTUs-w_2p5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_06,2025-04-08_03,2024-11-22_01

This adds a port allow list to allow PCIE, ACPI, PCI, DMA,
RTC, etc and serial for easy debugging when debugging is enabled.
The port allow list (switch statement) is copied directly from
the tdx code.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Joshua Lilly <jgl@meta.com>
---
 arch/x86/coco/sev/core.c   |  3 +++
 arch/x86/coco/sev/shared.c | 41 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index b0c1a7a57497..b8d62394d355 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2638,6 +2638,9 @@ static int __init snp_init_platform_device(void)
 	if (platform_device_register(&sev_guest_device))
 		return -ENODEV;
=20
+	if (!sev_cfg.debug)
+		debug_enabled =3D false;
+
 	pr_info("SNP guest platform device initialized.\n");
 	return 0;
 }
diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 2e4122f8aa6b..e5409af64203 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -44,6 +44,7 @@ static u64 boot_svsm_caa_pa __ro_after_init;
 static struct svsm_ca *svsm_get_caa(void);
 static u64 svsm_get_caa_pa(void);
 static int svsm_perform_call_protocol(struct svsm_call *call);
+static bool debug_enabled =3D true;
=20
 /* I/O parameters for CPUID-related helpers */
 struct cpuid_leaf {
@@ -870,6 +871,40 @@ static enum es_result vc_insn_string_write(struct es=
_em_ctxt *ctxt,
 #define IOIO_SEG_ES    (0 << 10)
 #define IOIO_SEG_DS    (3 << 10)
=20
+static bool sev_allowed_port(int port)
+{
+	switch (port) {
+	/* MC146818 RTC */
+	case 0x70 ... 0x71:
+	/* i8237A DMA controller */
+	case 0x80 ... 0x8f:
+	/* PCI */
+	case 0xcd8 ... 0xcdf:
+	case 0xcf8 ... 0xcff:
+		return true;
+	/* PCIE hotplug device state for Q35 machine type */
+	case 0xcc4:
+	case 0xcc8:
+		return true;
+	/* ACPI ports list:
+	 * 0600-0603 : ACPI PM1a_EVT_BLK
+	 * 0604-0605 : ACPI PM1a_CNT_BLK
+	 * 0608-060b : ACPI PM_TMR
+	 * 0620-062f : ACPI GPE0_BLK
+	 */
+	case 0x600 ... 0x62f:
+		return true;
+	case 0x2e8 ... 0x2ef:
+	case 0x2f8 ... 0x2ff:
+	case 0x3e8 ... 0x3ef:
+	case 0x3f8 ... 0x3ff:
+		/* 16650 serial ports are not to be enabled in production, but help de=
bugging. */
+		return debug_enabled;
+	default:
+		return false;
+	}
+}
+
 static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exi=
tinfo)
 {
 	struct insn *insn =3D &ctxt->insn;
@@ -970,11 +1005,17 @@ static enum es_result vc_handle_ioio(struct ghcb *=
ghcb, struct es_em_ctxt *ctxt)
 	struct pt_regs *regs =3D ctxt->regs;
 	u64 exit_info_1, exit_info_2;
 	enum es_result ret;
+	u16 port;
=20
 	ret =3D vc_ioio_exitinfo(ctxt, &exit_info_1);
 	if (ret !=3D ES_OK)
 		return ret;
=20
+	/* port number is packed [31, 16] */
+	port =3D (exit_info_1 >> 16) & 0xffff;
+	if (!sev_allowed_port(port))
+		return ES_OK;
+
 	if (exit_info_1 & IOIO_TYPE_STR) {
=20
 		/* (REP) INS/OUTS */
--=20
2.47.1


