Return-Path: <kvm+bounces-25205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D41F09619AF
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75598B2187B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C746D1D45F0;
	Tue, 27 Aug 2024 22:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rMX19p7U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A8E1D415E;
	Tue, 27 Aug 2024 21:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796000; cv=fail; b=aYZmI3LZ9B9Up4Rosb4ZuqfHdmTL13INd6S8oOUyxPetCR54WmH0Ej5GnPTpxXhAVsQdoAxZN0KrR6kiLd5HY/1AvRBHJufSm8bCAlfxVU7MRJLPdnKzy3BtJwutNO7F0dRgtPQcgu+w+UNU/T0zNMoHJKhpLJFyNdPObS2bCHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796000; c=relaxed/simple;
	bh=nJkF8hAEgd6t5ZyJm2tyzLnU96C4UwhPFU/jCBoNm3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nldvC4qPiwZmWk2DtX0JtldeCLte/7nZy4aYIoLWN9l9UamUXoC/2qvPo5//zXaLCJuYJdVLLWIrwVxoV5JFMIv6j2G2UaiaPrnzpcLghLerEgA7y1Qvw4MyCAJZj+ofLFmyJIdSASUHqje8tOoJLTyIYiqMYW/GH0rmVhQPleU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rMX19p7U; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vrgB9qDnlnJ1NB0gQHxmZ7Q3DX6dJNwi+OTqGVQ2dc0xA4twPUuxQHaKm/NYXlt0nxTgzjPYWj24l98bolvuOdWFSEeG2NYyNmBZFfL3mpPgRBENH1jEEmYup5dsnuvShmbSbtPhXG6sG7/xCZ8xUuLDqIDxhlsu+0DZA80STDOrSQGEoAxyUi4g4jEmJaXf+XU6Fob5YXLNyw87WyMn9rHE9QFxx7rzg9GkrxauR1Ku8FB6xD3bzV4B31HzKw/KuY7I/Uk0GH6Ci4T7+ZDJ+48W+bm6JdXhAoLcCE2nToadxrJxGoWaEKsCTK4L1ODP7kLXwa/4GLR3QaQqBSnpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bL7v8C8CiMIGs7H9bEPlpTemtKI1+fKz8wqjUvilL9E=;
 b=ato+rl8+R5BetIwj9r7Aoq3JCL2GBUxJHuZoaEY/Mb3CtnQyWCs52JGUTX11I/rWuZetbin32YLxewzft50+SQdnfhMTxpYWv5ClU6xr3wFKZyymzkDuwkRPGbc5mfovmD7ai0sHPBPp0oIlYDRenoLoj6zVaFTxZvTvSGgSIsoRm2TE+smk8s+lp+DY7VEB9ARN7TvOInSpMS159nPysCzEdoGgRgKMa65LXxxS007cPKOAsMnmMyIFiqQ4gBwfCVec2c2ql+/wAqBKg9Hny9fqu2xR9jqu9bIlh//SfsWIpvFY5zZr40lCiXTLLbC83yLOKZKCNJgrd0Tsyh/QMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL7v8C8CiMIGs7H9bEPlpTemtKI1+fKz8wqjUvilL9E=;
 b=rMX19p7UHEjTPCSSvZgjy/yYnkHFZtH3DwF4/Clg1QKIS+rlPaJ0igz0Xr1BqjPaHWSYsrS7Myqnoz4bmil0De8aeLJoCPoWXJzsFj8Ku5POJ3DFBqx+qf91lCfXPD4vC6MSCFhNdIH7NkSsJ8ymZhB3YIhhwF4Fk6Kt0waRjRI=
Received: from BN0PR03CA0038.namprd03.prod.outlook.com (2603:10b6:408:e7::13)
 by DS0PR12MB7770.namprd12.prod.outlook.com (2603:10b6:8:138::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 21:59:55 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:408:e7:cafe::d3) by BN0PR03CA0038.outlook.office365.com
 (2603:10b6:408:e7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20 via Frontend
 Transport; Tue, 27 Aug 2024 21:59:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 21:59:54 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 16:59:52 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 1/7] KVM: SVM: Implement GET_AP_APIC_IDS NAE event
Date: Tue, 27 Aug 2024 16:59:25 -0500
Message-ID: <e60f352abde6bfa9c989d63213d4fb04c3721c11.1724795971.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1724795970.git.thomas.lendacky@amd.com>
References: <cover.1724795970.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|DS0PR12MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: a54dad7c-f689-4fd9-b13e-08dcc6e39599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?psl9SacNuEjwlFDNzDXZkz30hYuCLDfd9O8oz9Wsc8/2mBgwhy2vlUZU/rhb?=
 =?us-ascii?Q?U9btSYBxMgDyX9B4LfjObhMpnq6QEnbu2IBxnrlH7CnJhZ+NXb2Gqfnsr908?=
 =?us-ascii?Q?a5JlSif1oaITDvnLVMXHAVwpb3jW4hUbcAh2SL3wfMr3VBAxXLAbolrBE8Rr?=
 =?us-ascii?Q?09qyMf8D+0AGP1d3rKm582JRZ43W6R62hXafH/ML9d7TwBcXBwqhcb3+HoJs?=
 =?us-ascii?Q?dTEX1BBBdHXNyuFG2ZoSDZ0PM6qDs/6rlF4+FXL5YONP/DuCdhZ4fpisvtJg?=
 =?us-ascii?Q?AWcv80+b4qOPoggoi/cz8t7p1Ze1Cme3uAUrTkmVTnlewFs+S0Dx3LhAhvWY?=
 =?us-ascii?Q?2WGre6P0Zr0OHOz1KUSeut+4EpsK29r9cNpaGacIDev71/KR1nlSQ7yIkGOx?=
 =?us-ascii?Q?t0PgAxPvy2P/jqqCAeYNK3C/nEDbKNheYS7cE4MS+860f3ne6P6WW6l0owFA?=
 =?us-ascii?Q?IVYj6gaYIIHkr/zBW2LR5oNacXlk3z04qVPuz8hE+hVVw/3F7SFRAfitQEbS?=
 =?us-ascii?Q?oZ3OJfQBXvby55fW01b0vM8XTKdkTlUL84CaDGBVDJsSZLAPQT8r2YDeUMwZ?=
 =?us-ascii?Q?tsztmna2cE1yw64xEHn0WxZ1aZELK/wpjRTw7RBAyeMlNa0+MW8jeaHwNBey?=
 =?us-ascii?Q?cVvjt9pJVzpPVGRISH01e8GsoUn+EFBXFO/jHJgf8QYE+YjKwon7cQ6izet1?=
 =?us-ascii?Q?s5AFASsRYVF1oRJz3SU5pClJ+VP7mqGReKfoHLweBRWeejbPqHiLHsfXmCi5?=
 =?us-ascii?Q?qI/K42CGSjyNHvm7/8g3LZ4rkNaRbVcXx7wzgGb1fDDQ4aPbL3JXA710k0oG?=
 =?us-ascii?Q?VstmhZ+jTl1rGvULy+vnbPcgc49mPpLhVnJEhNYri0zlwUpvIN2o1omqJvlK?=
 =?us-ascii?Q?dQcRQCjIXlGQr8ozk6O2shR8An14i72ddo1VGew3j8cyUu0BpimZcloEfyMz?=
 =?us-ascii?Q?tKs2HzhF9tvqoCML7hlMmrqafTWQaNP/BYs0y432gZb69fzEtkzHPd6Zvuv0?=
 =?us-ascii?Q?P+VMlhTphEh0mTorBgZzgAvURhVSIJFXgxqE5LE2O/f5oqft4hBbgKKM43Vz?=
 =?us-ascii?Q?IqWo9UsLDy1mS0FiHJjUxwV/1DBhCEk9/1AqiSbwzpKaca7VMy35f7CCdYje?=
 =?us-ascii?Q?04mIQSLcAK2QauQTLxbKuWEo+TDfhjnCPV6N4fa9GpQ4ME82SNuwuMQz72GN?=
 =?us-ascii?Q?pw39jMaemkpfnLWvzvE4ozEzC4Qjz+p5FwR+UHFex4Q9tPZTjMioW9MG0Ii+?=
 =?us-ascii?Q?lc/9bUyy3Cagwbb/JE7A5dX/ARIHzS2OdI96fBj55SowypiNhs4E49KsoOBU?=
 =?us-ascii?Q?bM3m+fA2658iop0UcYy81loL7dpfP1IcsIOGdHHlkfCQKq3J1/VEgt5KFdWK?=
 =?us-ascii?Q?5uSqRR788Q5jZWzbTz118h55Jwsl+1wVC1ok6eIKJuyEP94297PiEELihNVx?=
 =?us-ascii?Q?8CIUmx4TbIw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 21:59:54.4208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a54dad7c-f689-4fd9-b13e-08dcc6e39599
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7770

Implement the GET_APIC_IDS NAE event to gather and return the list of
APIC IDs for all vCPUs in the guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/uapi/asm/svm.h   |  1 +
 arch/x86/kvm/svm/sev.c            | 84 ++++++++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 98726c2b04f8..d63c861ef91f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -136,6 +136,7 @@ enum psc_op {
 
 #define GHCB_HV_FT_SNP			BIT_ULL(0)
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
+#define GHCB_HV_FT_APIC_ID_LIST		BIT_ULL(4)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
 
 /*
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 1814b413fd57..f8fa3c4c0322 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -115,6 +115,7 @@
 #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
+#define SVM_VMGEXIT_GET_APIC_IDS		0x80000017
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 532df12b43c5..199bdc7c7db1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -39,7 +39,9 @@
 #define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP			| \
+				 GHCB_HV_FT_SNP_AP_CREATION	| \
+				 GHCB_HV_FT_APIC_ID_LIST)
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -3390,6 +3392,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			if (!kvm_ghcb_rax_is_valid(svm))
 				goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GET_APIC_IDS:
+		if (!kvm_ghcb_rax_is_valid(svm))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -4124,6 +4130,77 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return 1; /* resume guest */
 }
 
+struct sev_apic_id_desc {
+	u32	num_entries;
+	u32	apic_ids[];
+};
+
+static void sev_get_apic_ids(struct vcpu_svm *svm)
+{
+	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu, *loop_vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int id_desc_size;
+	struct sev_apic_id_desc *desc;
+	kvm_pfn_t pfn;
+	gpa_t gpa;
+	u64 pages;
+	unsigned long i;
+	int n;
+
+	pages = vcpu->arch.regs[VCPU_REGS_RAX];
+
+	/* Each APIC ID is 32-bits in size, so make sure there is room */
+	n = atomic_read(&kvm->online_vcpus);
+	/*TODO: is this possible? */
+	if (n < 0)
+		return;
+
+	id_desc_size = sizeof(*desc);
+	id_desc_size += n * sizeof(desc->apic_ids[0]);
+	if (id_desc_size > (pages * PAGE_SIZE)) {
+		vcpu->arch.regs[VCPU_REGS_RAX] = PFN_UP(id_desc_size);
+		return;
+	}
+
+	gpa = svm->vmcb->control.exit_info_1;
+
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, 5);
+
+	if (!page_address_valid(vcpu, gpa))
+		return;
+
+	pfn = gfn_to_pfn(kvm, gpa_to_gfn(gpa));
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	if (!pages)
+		return;
+
+	/* Allocate a buffer to hold the APIC IDs */
+	desc = kvzalloc(id_desc_size, GFP_KERNEL_ACCOUNT);
+	if (!desc)
+		return;
+
+	desc->num_entries = n;
+	kvm_for_each_vcpu(i, loop_vcpu, kvm) {
+		/*TODO: is this possible? */
+		if (i > n)
+			break;
+
+		desc->apic_ids[i] = loop_vcpu->vcpu_id;
+	}
+
+	if (!kvm_write_guest(kvm, gpa, desc, id_desc_size)) {
+		/* IDs were successfully written */
+		ghcb_set_sw_exit_info_1(ghcb, 0);
+		ghcb_set_sw_exit_info_2(ghcb, 0);
+	}
+
+	kvfree(desc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4404,6 +4481,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		break;
+	case SVM_VMGEXIT_GET_APIC_IDS:
+		sev_get_apic_ids(svm);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.43.2


