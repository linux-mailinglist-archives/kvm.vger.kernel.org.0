Return-Path: <kvm+bounces-34547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22406A00EC2
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8E3F3A3464
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225D31BEF75;
	Fri,  3 Jan 2025 20:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2psI60Qh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2301BBBF1;
	Fri,  3 Jan 2025 20:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934529; cv=fail; b=jTFb/ZZyd86Ek6zIE2Qf1OLX1F+bgRGsvD6JE3mTO+fObF2VkzAeOh/z3uCrzeiR8TAnqxXBNVaNYm/vusjg2BVq4hVWaCG0B+KjERZtVMQmY4EO7klz5L3/+o9yw5khgxuRUpKm7S3OQHCGKzyLbczoyafDY7+tf1QV/kz8OXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934529; c=relaxed/simple;
	bh=3WVBlN6W2cc3jq7KTXYDW0VvO1JMun4z1wdx2ZFHe3o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGaHjqu1yhjNLPPTrOIyhfm86GmRrrsirlCGWNsHQAOxcTHRFJZzt6/0DT67bs5LHQA/YXt+EBgFPH7ARPvvAioVgV3hhehi8TKQYK/rFolg3lJOMzQPQVEOzMb5jRCVhyLEvwyAlBmEFBSHDvdBBYF9u1fAxQJ+r/NFuobv3dM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2psI60Qh; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gb0Ng/1YNOMgLcEJ3jU26msG1KpZEdWPFuiOkhBWnZI/5uZQJtuemGG+a84VdiLeTJJp3ohNsSCCeA0bxZw1HjczFwwGP0p4j83aty2K77WITB6yuhrRa61yUZyabcuQ2DISNSWQt7sEuDQQhpEYJxleMNyX+vFqj2OseVDPiDMnXSOkZNziFHNgCJUgHLsWl6WbAuOaHPAL2DGx3tE1+ZUCJxlXVx1vZN63A5diiQWM+DVpqR43/Z2y4VXCzMdfmgQHb71nwK8l2fhWlnIspwDw6KG8P20gZKU2Lp1PpTdDV4HuDURSaHKc9gpmV1wLL8wVvxz5XbWDOPaDEUBKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJp5bO021neq9pm8lBDqNpqpM5PPNhfaH5qCwyw4Prg=;
 b=ilKQTVPZ0I5Y8tm7nyu47BW4MUpF24egOFQBH00AcxFZQMc1CrloHxDpDyJZIXxHoEuYIcsiQwXjPRVUiIj1Xfr2w1nZ8X3VfsOhf8zheelp1NmLj6agePymbTxweOYdvFa9pRN+pkHc60Nxb2LKs0YlrxV2MtdWteihfV2SmUqoqyqHRJUZnl5PvduXIfSocu5Eg31XjjJWNFJ4kLW8ObFOqv5QF/lzt9nUdJLgqpXg9uM1UFit/0TIci29j42pFXP8sKtvVYCNknPLnSV7vHZqjUMakNfSKjgd14QYDyXSoiH4C0U2JsbOTapXroDlXD0cjURVdNxJO64HG8yPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJp5bO021neq9pm8lBDqNpqpM5PPNhfaH5qCwyw4Prg=;
 b=2psI60QhWbwERj2BI1OdthH1RRavcLNKYh5D94d+OnUBfMfOx6F1YEd2KKZVeZ/53Ms3LzOX9bE01hZkRRMHH1UY9RU/UoTZD5ji5NEsgOYvacskrt6MTJgfoYNtS8K60+FGMf9auH/ZVPz78sMNMQnagD3EF4SAsMO2YQkFnfc=
Received: from CH0PR13CA0036.namprd13.prod.outlook.com (2603:10b6:610:b2::11)
 by MN6PR12MB8516.namprd12.prod.outlook.com (2603:10b6:208:46f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Fri, 3 Jan
 2025 20:01:57 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::ae) by CH0PR13CA0036.outlook.office365.com
 (2603:10b6:610:b2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.6 via Frontend Transport; Fri, 3
 Jan 2025 20:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:01:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:01:56 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Fri, 3 Jan 2025 20:01:47 +0000
Message-ID: <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|MN6PR12MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: b33d7066-6869-44eb-bf7e-08dd2c317a55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eIn1hxulqCYQGbasD1CXokWxWftffDD3x2Na0bo+xOO4gvVpi59h90102+FL?=
 =?us-ascii?Q?BAK6cXRfzLlfjSd3MZJaGFnVmPOeWs64T8HCCH10LdKktLLad1U6aaB5l2S1?=
 =?us-ascii?Q?r4qyulCiDI3SFtgIt23ykKRsVaNDtsuE54lydVsatSwL5OiAmXs1Xiru4nPz?=
 =?us-ascii?Q?ZLokOY6mXgL/qOKUTKhA6z7QbjNM5vSKepySBx+hwSpabqpqeGHP26+WbXqd?=
 =?us-ascii?Q?nB4uAO9xM7FkabFp2v0Z//ROUSQhJQ4Dg2utHwKO9gwjyEF3vz14Nnb1QC86?=
 =?us-ascii?Q?hrNcuUL1gpgC+SlFaa0DT2HOARRIwWlHL/u3HLHfGKDPB+sIEr/YoNHFbMa2?=
 =?us-ascii?Q?RzT1Lr9Y+VMVeoko+wggr/9VN4aLOYUIVNMiXuvVEOKy/UIPe+H6dfCnTPTI?=
 =?us-ascii?Q?QdTfzHMlUpFEt6Je6Rf7eHWOSgJ05mCXNSF2kdwsL3B35Ix64+4ZIhZf8/m3?=
 =?us-ascii?Q?Q2KyvVHvyuGhSd+cCTyqmHRM67jDPBeUXjnYAiPzZS5D24ikgECaYLuw99NL?=
 =?us-ascii?Q?XTTFFYdhfAjhWzSFGdIjFdhMTUjUtBm0jqCB+8mCcuSut4/uIrPacXGHtHuf?=
 =?us-ascii?Q?ANbDGmNpo/xlPq3pHKJ41S1tIr4gkcWQ7vttx+uPFO3UA65zpf9DonpgQ0JB?=
 =?us-ascii?Q?a1FkQSZED2az3GNIgaopp/78msuuVS+LUySwkKQ5aQ/syhGrx3g1nngCjcM2?=
 =?us-ascii?Q?m1QKNhCQcftW3JItTgPcWwxZjm9bSbViHkbf+MuMSKizDJSjS+3KNzCToaUC?=
 =?us-ascii?Q?ddcf11Unw/USPwCFoucSnmUfKRipa0Ua1OjF2PthlbRXi5ll3MI9zHegyNZ6?=
 =?us-ascii?Q?u4vUzsb4XsKaJoyF4DqGrARrYWWJ1OqFL2eCPo37tBuHvkM0j/sWf9/SOBHA?=
 =?us-ascii?Q?t6E5dSvcpnjENPgPL3O+gocmptr1oHZ7l0csc8ix0Ndz2oqTnoxok08ha77y?=
 =?us-ascii?Q?MHMYcjO2s2l/+XlZo7/0R9kNmmDmSMl/e/PAXui7VUlrFmHPA4pOjIjeDHox?=
 =?us-ascii?Q?rRVPovi9wNoWAS1OsNxAUpLwb5JxwYW9+g83Zis9JxUbVQPZAs20Bq7Krlew?=
 =?us-ascii?Q?SP4NejFnkp8quPLmG8Crj/M+DELv6vAOg51qfm2W7fwxSG0zmoJ4ltKiTf+h?=
 =?us-ascii?Q?T4ntzD4XRNe9FWdyV/MSp6aeklzCSCDwF6WyBSbHHkt+KJZLKOQfu3i1rWDp?=
 =?us-ascii?Q?88IyIRvtUQQe2J5y26uWFIfKrSDRnaA4kvs/ZkBRAoBpdsGpwbyIrkRMEowY?=
 =?us-ascii?Q?ytUVtuOc8oD12B+4ngCGPnQoCe7E0x1o2B7keCbGuGvF6h0ilgx4hbVfxpL0?=
 =?us-ascii?Q?ONKiGla2J78UMSeVQszFgFQBdmz/JCr2EALFq7ZuneqUB1hA3STtxNvBW67o?=
 =?us-ascii?Q?itWwHJNjqdq4eY4dvFCS1Rh1BYG1VbXBTujVg+M37igjWLcyXN2y4uWSeUES?=
 =?us-ascii?Q?cx6tgTWXSb9IetFynDdhM6LsYodez2nkccEQTbuevNa680FtFA+KPqvz2Xds?=
 =?us-ascii?Q?OEFqn1mW3mDkEc617Gj1hfxnJMpcZRkZG1t0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:01:57.3155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b33d7066-6869-44eb-bf7e-08dd2c317a55
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8516

From: Ashish Kalra <ashish.kalra@amd.com>

Remove platform initialization of SEV/SNP from PSP driver probe time and
move it to KVM module load time so that KVM can do SEV/SNP platform
initialization explicitly if it actually wants to use SEV/SNP
functionality.

With this patch, KVM will explicitly call into the PSP driver at load time
to initialize SEV/SNP by default but this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time if required. Additionally SEV/SNP platform shutdown is invoked during
KVM module unload time.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..0dc8294582c6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_no_asid;
 
-	init_args.probe = false;
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
@@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/*
+	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
+	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
+	 * VMs in case SNP is enabled system-wide.
+	 */
+	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	/* Do SEV and SNP Shutdown */
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.34.1


