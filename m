Return-Path: <kvm+bounces-25211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7AD9619C9
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44511286CC9
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9667D1D417F;
	Tue, 27 Aug 2024 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MB80L7Ed"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F071D415E;
	Tue, 27 Aug 2024 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796057; cv=fail; b=BfVLwAqfj7on9t8+8oEp6TcVVnfjOv3z7zCm6WXNXmkURdXzIa0nHhB0al60R7wbf8n/ACVUilkXaFZA+d3YJ0K5FM5OnOVWWothMtiATPh7gGaZXnx2jX/XnsuRk81IooiqTKx6NNUwO+9UlWlZRuGP4S+i8+Oj5aAmT5BzfMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796057; c=relaxed/simple;
	bh=ZTX3oSMjQHclgW1ECuY/8ny7CTgGaYIo87hB77/6vLg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egNYIQmBXUk4vUhIY8d2JGtih44i9ox9WWX193YGeaIZQflbIpuE3TY6NRfDsl+wMwuGTh7sFoEctQ1yf1co0TD2sdpH4nGeGnkj67XXE2vgdGlzFZUlA6NdS6qJR8slp2I7kRk7hDDPtB+b3iHUxPXwDywRxHw3zFfhIKaweyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MB80L7Ed; arc=fail smtp.client-ip=40.107.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZFnn0rzMKjNv8NdGUNkjReO3++89y3CkLSWuCrC+EeD/Y/hEyvPd7wKENwsN5BZ7lyixkyNUStirwwOVY+GyblLfBtTyxTgdNhP4IgSeg8KWDVVuPjhV3+6/gIRj8AqOxHSJ4N44AGVseSYUWq7tn8/GXNQv5BLzZQGy/S4+nhe09xBttuo2r9BBTf+WQ+GjBdgCVlPQ5RpW59c0aM1TNDhNpRbWNhniENlmS5kLB7glDkOJ9u2TGjDkgcGwMwvdPhyRdrqIbovrxZ/84LE/evfI3cxPbMVAGUdSD+m67ChxxLvOk/xhdo5qEPMeOy1Ilxabrjcm8fJ5x8gPHiEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZzxZOc/YcNZP8xNG6kaZkkicWt/v/inW/GthKLWOEw=;
 b=hkUbWl4nNks2l6a2/uClk6We6qb1RLxNYnAxvAq6srKU4c2i7pZNAPusn9wUO2WLBkUcIh2tzq/Q8TH/qs4VWmdajMhMzaEWDUI4JrbnPjDA9J3oD1kIOM+04TBg9yZMMlOQHRps9Dc44N3LPT76lX6/ZN9YUozs4r62pyBGwiR+gcpQHpi4Le6r01jEPWyuiUVVCpGEq/jI3B6Fpc8IzGYr/DloASQUmAjk+tIdaLx59LpjfqfigFhSxyYWlceBtMVtk92/K1X+7skytgiK9hSn663fQkCflsq4rhlqijt8WBqOzfTuDCSzdPXrgkiJr5GMv3UCg8RE2s/HqM6xtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZzxZOc/YcNZP8xNG6kaZkkicWt/v/inW/GthKLWOEw=;
 b=MB80L7EdI8wbLUj1ohd3F4VA0y8zXVJQlGnTIwmp66NYZ5WqPnIfOtN9m0d45X9Q84fhIEIXHDanOquQ23guZI4arzHsx3/l5NPS+xxsAbJAvgTpzOuFv6/1Uy9Lupr2iEPLpVdz/UNrtih5IwikbgVprqHYwtw/c6XiWlJ/adw=
Received: from BN9PR03CA0568.namprd03.prod.outlook.com (2603:10b6:408:138::33)
 by IA1PR12MB7736.namprd12.prod.outlook.com (2603:10b6:208:420::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Tue, 27 Aug
 2024 22:00:44 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:138:cafe::82) by BN9PR03CA0568.outlook.office365.com
 (2603:10b6:408:138::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:44 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:42 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 7/7] KVM: SVM: Support initialization of an SVSM
Date: Tue, 27 Aug 2024 16:59:31 -0500
Message-ID: <8d5d8aae56f3623ee3fe247aafa764b2c0b181c9.1724795971.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|IA1PR12MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 504c4f25-d64d-4e61-89d0-08dcc6e3b359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kq0qijys2GP5nc5/WHZM5VTSujYHYicW2C4av7ejAIjwVENO4Eu7U3z/nIoP?=
 =?us-ascii?Q?X1fcPZa15bKDfKikWbkuPjl/WRCDZ5fR7htb+cy49l+c34mT89otSTX4oqPY?=
 =?us-ascii?Q?JFpFSs1j3JM9zzewCmU8dWZWEgwaFDXBbDd6j3ErCxiBHtK/RM1Rc9fR3eTv?=
 =?us-ascii?Q?wfVOxdKT9Vw3V+v9xgobxoRmpbk8Xf+RAPPfA7jsLaxrxARYFPjYU3SsSJOO?=
 =?us-ascii?Q?FvlhYnxvH2nhijBEq8HKxwf7DAoo5n9ATKnyz/uKMXNAtQhbMpJmwi/zjLNW?=
 =?us-ascii?Q?i9yTLgTJq6n2t9aUNV6Fm8LSFDuMaIsohlHEHTDbyspfh/AYqq/KVBB6pGog?=
 =?us-ascii?Q?nMg7lrld+QpYukoPDpoloJncF3LsRcfMLkR1yCO79dqv/zWFGNduIjgvqhMt?=
 =?us-ascii?Q?7UeoZm14RsKC0tvqRYk70iHOA19c0q4f6m5vz3ZuZoGzOvrq5iE3u+2m8qpA?=
 =?us-ascii?Q?w+ciH1aW09hb08n4aChtt6JQrwa5r/5IJQesifq/ISp41BPmonvJRt+O9Xkb?=
 =?us-ascii?Q?tyXwHjwebdJdFm2a+PgRW5fe/awR4XD9O06BilIe7ynwMp5rpWgOpqrfq00W?=
 =?us-ascii?Q?OcZc70cxnyDyFBtbW/wFNl7EtHGxdzBGD+mOQI5GsWCdxJB0TuvjZD44miXI?=
 =?us-ascii?Q?VssRFEdN8P+9SAgUE6eYCtzk12cgnaDC5OUwZ6X9PqcslB0CvkJ2qTOSklqW?=
 =?us-ascii?Q?IrJKMmYlEJHyIFgcHANvQA7NNJ4DZyebRQKSHCIL3F5QeFyuwm1pEVC/LjSW?=
 =?us-ascii?Q?GjhQy+4pFmKJp0igHAOD4c4WuaMH3ORJdGcBtpBsqEJEZ25GaRN+u5GL3ILL?=
 =?us-ascii?Q?ZJRKmeGJHAOuNydEUnw1M6jnsfHwr/z+jFK8nbR1oZrxiq2ksoymeS83AZ0t?=
 =?us-ascii?Q?Y4KJ7R4sp1uRjnV5m4TIG/GmmtsVVBrwIk5kst8umGBQd+sWlAYJ0JcR/o0R?=
 =?us-ascii?Q?Y+28a4uNqiltRCTn3NGK5hVBuxCjtU9hLTUdw+QRVv7Z/MRj56umYvfdVovk?=
 =?us-ascii?Q?pNoIDhcb5y8HQovvtlXir6ibmt4CBXIrV/6Db1w849FzuCARrncCPj4k4XYA?=
 =?us-ascii?Q?/4u6GDxgmfwB4bsP9xfzO1fxW/6YM584KWtzU4R5AVYVHAb2Mq9VrTmDJS6b?=
 =?us-ascii?Q?VmAM4K0G0i8iGV1F1EBMnJl0W4uE3d5EoKYuy1nx0TLYeR2Kd/JNIEpHusfB?=
 =?us-ascii?Q?C1R+nhC3S34oABsqWo4mTBs0gXDtlneVb/noQwOdPErQxouX86/YP2ULZX/k?=
 =?us-ascii?Q?NOMHWFM006IfSEs+yQgIyHvV66kF+jKVtV3tDU6dFdE1DgLXl5X1XHbfjgZI?=
 =?us-ascii?Q?qoQPoKv1toOQlwGFIHWOsuWPjCmMckD1deFvT/Vd7ey1W0NVq0ZJQFCka+T/?=
 =?us-ascii?Q?JAn3PuUe3iIPCOS8DzxqGEolE7EFt3x/KQI5CdMZ74LxvgG5aaHx+pyelKtd?=
 =?us-ascii?Q?jSYWRKq3eMI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:44.7852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 504c4f25-d64d-4e61-89d0-08dcc6e3b359
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7736

Allow for setting VMPL permission as part of the launch sequence and
ssing an SNP init flag, limit measuring of the guest vCPUs, to just the
BSP.

Indicate full multi-VMPL support to the guest through the GHCB feature
bitmap.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  10 +++
 arch/x86/kvm/svm/sev.c          | 123 ++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h          |   1 +
 include/uapi/linux/kvm.h        |   3 +
 4 files changed, 107 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf57a824f722..c60557bb4253 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -465,6 +465,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SEV_SNP_INIT_FLAGS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -703,6 +704,8 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
 
+	KVM_SEV_SNP_LAUNCH_UPDATE_VMPLS,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -856,6 +859,13 @@ struct kvm_sev_snp_launch_update {
 	__u64 pad2[4];
 };
 
+struct kvm_sev_snp_launch_update_vmpls {
+	struct kvm_sev_snp_launch_update lu;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
 #define KVM_SEV_SNP_ID_BLOCK_SIZE	96
 #define KVM_SEV_SNP_ID_AUTH_SIZE	4096
 #define KVM_SEV_SNP_FINISH_DATA_SIZE	32
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3aa9489786ee..25d5fe0dab5a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -41,7 +41,10 @@
 
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP			| \
 				 GHCB_HV_FT_SNP_AP_CREATION	| \
-				 GHCB_HV_FT_APIC_ID_LIST)
+				 GHCB_HV_FT_APIC_ID_LIST	| \
+				 GHCB_HV_FT_SNP_MULTI_VMPL)
+
+#define SNP_SUPPORTED_INIT_FLAGS	KVM_SEV_SNP_SVSM
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -329,6 +332,12 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
+static bool verify_init_flags(struct kvm_sev_init *data, unsigned long vm_type)
+{
+	return (vm_type != KVM_X86_SNP_VM) ? !data->flags
+					   : !(data->flags & ~SNP_SUPPORTED_INIT_FLAGS);
+}
+
 /*
  * This sets up bounce buffers/firmware pages to handle SNP Guest Request
  * messages (e.g. attestation requests). See "SNP Guest Request" in the GHCB
@@ -414,7 +423,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	if (data->flags)
+	if (!verify_init_flags(data, vm_type))
 		return -EINVAL;
 
 	if (data->vmsa_features & ~valid_vmsa_features)
@@ -430,6 +439,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->es_active = es_active;
 	sev->vmsa_features[SVM_SEV_VMPL0] = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
+	sev->snp_init_flags = data->flags;
 
 	/*
 	 * Currently KVM supports the full range of mandatory features defined
@@ -468,6 +478,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->snp_init_flags = 0;
 	sev->vmsa_features[SVM_SEV_VMPL0] = 0;
 	sev->es_active = false;
 	sev->active = false;
@@ -2152,7 +2163,9 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	case KVM_X86_SEV_VMSA_FEATURES:
 		*val = sev_supported_vmsa_features;
 		return 0;
-
+	case KVM_X86_SEV_SNP_INIT_FLAGS:
+		*val = SNP_SUPPORTED_INIT_FLAGS;
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -2260,6 +2273,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 struct sev_gmem_populate_args {
 	__u8 type;
+	__u8 vmpl1_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl3_perms;
 	int sev_fd;
 	int fw_error;
 };
@@ -2309,6 +2325,9 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
 		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
 		fw_args.page_type = sev_populate_args->type;
+		fw_args.vmpl1_perms = sev_populate_args->vmpl1_perms;
+		fw_args.vmpl2_perms = sev_populate_args->vmpl2_perms;
+		fw_args.vmpl3_perms = sev_populate_args->vmpl3_perms;
 
 		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
 				      &fw_args, &sev_populate_args->fw_error);
@@ -2355,34 +2374,27 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	return ret;
 }
 
-static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp,
+			       struct kvm_sev_snp_launch_update_vmpls *params)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_gmem_populate_args sev_populate_args = {0};
-	struct kvm_sev_snp_launch_update params;
 	struct kvm_memory_slot *memslot;
 	long npages, count;
 	void __user *src;
 	int ret = 0;
 
-	if (!sev_snp_guest(kvm) || !sev->snp_context)
-		return -EINVAL;
-
-	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
-		return -EFAULT;
-
 	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+		 params->lu.gfn_start, params->lu.len, params->lu.type, params->lu.flags);
 
-	if (!PAGE_ALIGNED(params.len) || params.flags ||
-	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
-	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
-	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
-	     params.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
-	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
+	if (!PAGE_ALIGNED(params->lu.len) || params->lu.flags ||
+	    (params->lu.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params->lu.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params->lu.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params->lu.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params->lu.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
 		return -EINVAL;
 
-	npages = params.len / PAGE_SIZE;
+	npages = params->lu.len / PAGE_SIZE;
 
 	/*
 	 * For each GFN that's being prepared as part of the initial guest
@@ -2405,17 +2417,20 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	 */
 	mutex_lock(&kvm->slots_lock);
 
-	memslot = gfn_to_memslot(kvm, params.gfn_start);
+	memslot = gfn_to_memslot(kvm, params->lu.gfn_start);
 	if (!kvm_slot_can_be_private(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	sev_populate_args.sev_fd = argp->sev_fd;
-	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+	sev_populate_args.type = params->lu.type;
+	sev_populate_args.vmpl1_perms = params->vmpl1_perms;
+	sev_populate_args.vmpl2_perms = params->vmpl2_perms;
+	sev_populate_args.vmpl3_perms = params->vmpl3_perms;
+	src = params->lu.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params->lu.uaddr);
 
-	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
+	count = kvm_gmem_populate(kvm, params->lu.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
 	if (count < 0) {
 		argp->error = sev_populate_args.fw_error;
@@ -2423,13 +2438,16 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			 __func__, count, argp->error);
 		ret = -EIO;
 	} else {
-		params.gfn_start += count;
-		params.len -= count * PAGE_SIZE;
-		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
-			params.uaddr += count * PAGE_SIZE;
+		params->lu.gfn_start += count;
+		params->lu.len -= count * PAGE_SIZE;
+		if (params->lu.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+			params->lu.uaddr += count * PAGE_SIZE;
 
 		ret = 0;
-		if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
+
+		/* Only copy the original LAUNCH_UPDATE area back */
+		if (copy_to_user(u64_to_user_ptr(argp->data), params,
+				 sizeof(struct kvm_sev_snp_launch_update)))
 			ret = -EFAULT;
 	}
 
@@ -2439,6 +2457,40 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmpls(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_update_vmpls params;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	return __snp_launch_update(kvm, argp, &params);
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_update_vmpls params;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	/* Copy only the kvm_sev_snp_launch_update portion */
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(struct kvm_sev_snp_launch_update)))
+		return -EFAULT;
+
+	params.vmpl1_perms = 0;
+	params.vmpl2_perms = 0;
+	params.vmpl3_perms = 0;
+
+	return __snp_launch_update(kvm, argp, &params);
+}
+
 static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2454,6 +2506,10 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		struct vcpu_svm *svm = to_svm(vcpu);
 		u64 pfn = __pa(vmpl_vmsa(svm, SVM_SEV_VMPL0)) >> PAGE_SHIFT;
 
+		/* If SVSM support is requested, only measure the boot vCPU */
+		if ((sev->snp_init_flags & KVM_SEV_SNP_SVSM) && vcpu->vcpu_id != 0)
+			continue;
+
 		ret = sev_es_sync_vmsa(svm);
 		if (ret)
 			return ret;
@@ -2482,6 +2538,10 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
 		 */
 		svm_enable_lbrv(vcpu);
+
+		/* If SVSM support is requested, no more vCPUs are measured. */
+		if (sev->snp_init_flags & KVM_SEV_SNP_SVSM)
+			break;
 	}
 
 	return 0;
@@ -2507,7 +2567,7 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flow. */
+	/* Measure vCPUs using LAUNCH_UPDATE before we finalize the launch flow. */
 	ret = snp_launch_update_vmsa(kvm, argp);
 	if (ret)
 		return ret;
@@ -2665,6 +2725,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE_VMPLS:
+		r = snp_launch_update_vmpls(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 029eb54a8472..97a1b1b4cb5f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -98,6 +98,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	unsigned int snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..49833912432a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1399,6 +1399,9 @@ struct kvm_enc_region {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
+/* Enable SVSM support */
+#define KVM_SEV_SNP_SVSM			(1 << 0)
+
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
-- 
2.43.2


