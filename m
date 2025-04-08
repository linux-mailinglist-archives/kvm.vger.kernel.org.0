Return-Path: <kvm+bounces-42893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA2CA7F9D6
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379723BEDB6
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD022676E3;
	Tue,  8 Apr 2025 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OmCdEUXl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A26D2673A2
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 09:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104760; cv=fail; b=kZA7AJQUsLhUsm+55uheAik2HUfvIHU+45fANMaEvfksbX0vsfA2CxgE8Trnk61vYQEyqJ83Ximla5/t9gK4/qxW1xJx9vMarlrUMO6A/MqVSst4/g/1J5AbfZxme7Prbv1tW81hXMtr7tvbODuDZNUohX8xUy+vBKGSW7P+BzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104760; c=relaxed/simple;
	bh=+TEkBAB0ZXh26mmMRuKMO45W2ho5kmEYlqhPwxMg5Hw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lHcDPaUw2Z6StN5v727hGRNiCd20oF7O9V9iB/5pxPBQx0yc+DsH9wDrdf/vgVMkBw9OtkrXq1Jj7N6s4UiPfU2i/ElVgBlJn2VI69lEqcnZxn129VJB+wgjoYF+3NZflh28RCsFKQBhPoDMRanpNVnoMdnv1NrKfg73HZ2cHps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OmCdEUXl; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDz9W0dEdopkozQHTKDOEYfpYRcTE/LGtTOzlDpfzl8uMEjWL69KIlKni/JDY9+p/Gr+ABsrFDSTLJZYJNKxWYQaeVu7/3QM5ubZSFz+YcTlebnF3aHIMpZbfbTXui3x/mstnV17AC8iSijkVKiy3OVd23a5NTxSAi0AF9uqWlrBxl2KH4y0WCtDrxmkcSO+sIAJnoueuJKSKEF6wnWFwssQyVMXyXsYebh66hggpoJUDPgP5MAH352e9AANPqUbyf4R7vUz9dffSPRvtFev3Lz5oAhAl45z+2Et2kFM5OpP3ZT8PVELiXg4B8twRbUsDHC7Fny2fOl8j9BVLtpIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fd4Cuq6HVQjGD0O2ZvWVOXLcC8CrkhxFf7cO94sBlZk=;
 b=XsXIV3E7A/JTeKPHZ4d0h6foyc5QSLzKi987r9H1NYMSMrYsrnlW6l8sUspq7dOWOKk8oee6gp1aZaGLmCys8dROBdi4Vw1rSvraDvwO4ECBwlcekr358FvEigXf73ew62uL6d38ZZIBYdU0Bbalbq4pjA9E9Sk0qoUsO3dA7kAizQLpFeDcC437HOp+xhn6hhpgCewYUWu8l7fd7/3jFYNBeKt9zDEGMz6qiBZuCcDpgbTQEmDjkB6/4w5jX66OTDuShHKyi9AytM8hNW3BJXRRxDtbM0Gny9InreN4Pa/fmdwKZuvnwVu4y3dGpCp/osprcaBKprlpO9IpFs9vEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fd4Cuq6HVQjGD0O2ZvWVOXLcC8CrkhxFf7cO94sBlZk=;
 b=OmCdEUXlKdzq4tqDBJPBWZjw6Hr9L7PVubVcelO+hH+UnuZrST3r5XIZbrIk0OlfPExiM/i28E5KGf/yjI8YfzljvdBDKgQ+jg9N1pQXvWDgFP/oGxzq4ssJ5OMF7bIIEheLU0dtb7ao4xKKpaIh+jTGGHucaeuVV3gW9oUWf7w=
Received: from MW4PR03CA0029.namprd03.prod.outlook.com (2603:10b6:303:8f::34)
 by LV2PR12MB5799.namprd12.prod.outlook.com (2603:10b6:408:179::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Tue, 8 Apr
 2025 09:32:35 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:303:8f:cafe::34) by MW4PR03CA0029.outlook.office365.com
 (2603:10b6:303:8f::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.27 via Frontend Transport; Tue,
 8 Apr 2025 09:32:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 8 Apr 2025 09:32:35 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 04:32:31 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
Date: Tue, 8 Apr 2025 15:02:09 +0530
Message-ID: <20250408093213.57962-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|LV2PR12MB5799:EE_
X-MS-Office365-Filtering-Correlation-Id: 86af2151-6ec5-4491-e1b7-08dd76804b8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uDxkEIT/MfeAXbgnrtaYtDY1wxLPb0+46lyTb23INIwOaq9VpLubULOBKs/J?=
 =?us-ascii?Q?vQvt/zwKPZXe5yVJMo0hWCd18cael5SbMwYg3vrCYsEZDU6gYAs4/jIR1HSW?=
 =?us-ascii?Q?DWI259NRPiQdSi0OZl//qVTOWslnczeXgdTjc6E2KFF1j/v/pvhVYSD7Zwze?=
 =?us-ascii?Q?kEyLvzyPwe/LKXGB25vZQGir41Bl7RWQYlsPALWjw20GmUyEbg+pFhLEJ9j1?=
 =?us-ascii?Q?HFQrcPaHfwYadX+MxM3fdj0gvf1qzgd7mMteWKni8daqTO8TusegLV1j13f+?=
 =?us-ascii?Q?NLXV+TQp7IJomNbojInGySQ6e3wl8sjViiw81nGvs1LC2Xg/dtKZVoe+Rmvn?=
 =?us-ascii?Q?4Ty1wzt8L12H26JQj3vT19cKKkMT7ZtuA1Uj75c9ifc6QG7KRkNGEru15iIG?=
 =?us-ascii?Q?p1txl1ldhxI9GW3aPjhCGa3F8pz/oA9MtQlbUFJ5GCRN0knA12tqkJ5M5K+a?=
 =?us-ascii?Q?mY4hL1tVAYwECPwUUHi69yqWJaaiDiMby2WiTdGqbfMEoBzBK79bbon3vhMs?=
 =?us-ascii?Q?tQq93sBwYmZa0vmE3vgnxeDwBz62wSIrAlfs0vkAP0lrrUzedFi+Bs3UduKD?=
 =?us-ascii?Q?TH9Tty5xBDHDMvLG+j8/8K5v3/bG/y3zizn/6K+oJI99yCi0ACcljEaYPiAA?=
 =?us-ascii?Q?ItNnkGq3Ev1CNdHkkZSi2o9LvLNmb3IrtkmdBkBX2fqi+4xhNjSredZvVt/q?=
 =?us-ascii?Q?tUSQrUqvq/LQX0cV57kiYtJGlzh8xK3mnEymwys0dWoUmEHXQXqUIpeP0UKE?=
 =?us-ascii?Q?KgFtPD4zod8GodeqgLRwmTMhpQLvMgh+EBvLJwL2T67l2bCsejPOIG9Chp5F?=
 =?us-ascii?Q?T2TtziGaYoZiZNLMr8Si8SBEhCEU+mhMCFGbwuUmVTTnDEE2+wgjKxxO+tCk?=
 =?us-ascii?Q?UsKrIKzjHrH08LuAjulkUm4AU3ibmNFpv7kAqzQZAhfPJmLk/iHzUMO76bqW?=
 =?us-ascii?Q?XiFjXkrJjD81RAXXJ2GJeU2k3CGpc55SPsmVQ5v24ZicD9ncQct42wXkJRLU?=
 =?us-ascii?Q?APkkFDfRsFs9y8GDN4XYaepfLUswaL3ay6zb1fm8Ktv2FW4acvw0vZpfo6Ik?=
 =?us-ascii?Q?4ll9gRTEYAB0/uQiCU5IGv7HBkr7jceeQvhoyeC0lr1AlNV0nb3flcSd1SK7?=
 =?us-ascii?Q?EOg8PUOsqZLLaB2P2pq1EE4UzN08pMPCUSPpTfQZ2vYqGPeElRJ+pvoR9ei3?=
 =?us-ascii?Q?m8m7BUxnA+I0v94OPoeaEuat6ktABCVN+tNDhAaEugToh1I1pLRGziw/9VcZ?=
 =?us-ascii?Q?U1e+62bgDySsmc7cMl8jIa90SV7DLDfxJEuJ0L1T1yinrIA057MlLKLl3+X6?=
 =?us-ascii?Q?uh9h64pBiwObAOvW+N48GUgBt1oERAmNQsFmOWjcUF3hlsCC5Q91P/08Mqcj?=
 =?us-ascii?Q?oQcIvZePQDaUOlmsfJ28iNdxfbM+3CgySPJ8RtHIRUqbWMQJAwH82QOfaL/3?=
 =?us-ascii?Q?tpaKLL8RBF3x6XJ8I+1BK7zM4dXgGDLgq7AojXvpHFgbITRLlZt/u7Dg0upE?=
 =?us-ascii?Q?BRcXuIforUtkNjvIHORpblev64Yf+jEgnZ1138gOZ/DgYfhZXo9+ieuDWg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 09:32:35.0684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86af2151-6ec5-4491-e1b7-08dd76804b8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5799

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

This patch set is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on kvm/master

Testing Secure TSC
-----------------

Secure TSC guest patches are available as part of v6.14-rc1.

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU command line SEV-SNP with Secure TSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v6:
* Rebased on top of kvm/master
* Collected Reviewed-by/Tested-by
* s/svm->vcpu/vcpu/ in snp_launch_update_vmsa() as vcpu pointer is already available (Tom)
* Simplify assignment of guest_protected_tsc (Tom)


v5: https://lore.kernel.org/kvm/20250317052308.498244-1-nikunj@amd.com/
* Rebased on top of kvm/queue that includes protected TSC patches
  https://lore.kernel.org/kvm/20250314183422.2990277-1-pbonzini@redhat.com/
* Dropped patch 4/5 as it is not required after protected TSC patches
* Set guest_tsc_protected when Secure TSC is enabled (Paolo)
* Collect Reviewed-by from Tom
* Base the desired_tsc_freq on KVM's ABI (Sean)

Ketan Chaturvedi (1):
  KVM: SVM: Enable Secure TSC for SNP guests

Nikunj A Dadhania (3):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
  KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 18 +++++++++++++++++-
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
 include/linux/psp-sev.h            |  2 ++
 7 files changed, 34 insertions(+), 3 deletions(-)


base-commit: c77eee50caa289fee6cfde146471aa7b0f311471
-- 
2.43.0


