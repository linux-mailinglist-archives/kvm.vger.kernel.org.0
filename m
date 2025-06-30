Return-Path: <kvm+bounces-51088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF69FAEDA2D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 12:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A65303A5E1E
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06400244662;
	Mon, 30 Jun 2025 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2R0m2UXa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B793D239E98
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751280289; cv=fail; b=iiGMCKR8egaam45ShOKMl2rRd5s9nXq/riNtEfW5TxGivsh2ajyRWzKAMuJqOQ2NUXaZLNOABH2Zh9tHHirULhJWULeXAFMcJRYefJ85e0hXaFcEC09Ga0eoPbAc0+fmY906PsEpGrZh6hD1HQNg+7i85f3Qo+napHWrwQ5EiAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751280289; c=relaxed/simple;
	bh=00K7uVi/yjJnZdXojdIrDi/qPqjwrIsvK0BbFUW/MAk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZBfmSa+p2AeCDEG3nmCWZZX5KB2DKS7G99o1Se5n5Nj1WQ/NF4a2GFYKDTgpJeQu9sCGDgrF0zF1LDHkQZyOYKrCcUnOK84D3/T3K2/VEpHFW4ZaFU4+jJNMGzw+HqX30pgh5yKsXOHN6nY5vZDlMxNd6rDKiH5twlGB9w6psss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2R0m2UXa; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymgadIF3SpmTKqqSy24+bCEtmZl4hppZIUAyFE0wW2GnLy+KwFJF1zXhcjomQt39dDS2et+A60stPBWgpetYS4geyzx19bpS4uhLUG0XIOOdMwvWn/qcRWI6ge3DTmeXUl6oggPB3obJIMBCn+5X4I0ofxqM4eTh1eZSZAkllxAnzBrFSuUFhFOiQuuppPTjOwxSVDditWtbIvT8aWs/l6+bVUzG+bVfg8MAI9qmNeNkO+qXs14B9Ur7k7Ww/5osbgvJ3O8i7QKbnVPb5ArcpjBaUMtLuqOkHjZRKpvCZc4e8I364ugF5XapLCQdfe5NzpwH66zSdUUK+Zv47KJxng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPa4BLdB7W57jOrPW4KsdPy9Fr/j8D4a6BLrT8ELiww=;
 b=WYaYeuRGjejOAsLvS8tqUhFnL0lRTD8VghD8lzKeo9C2FDgTYfVFcUWmgmDmDzaXeKjOeb5/+00s8IhGHFM0WuDbRPuLxD4gSVn3fYMh3klwc9qSbkCgmAf8WboH9VJr/KBq4UidWOVnA2mOAm/BiPEtPrkAS1FJF8MHv0jtZF2EIUlNDUf0Lrge3XDdNIHxtGCWbeKMoKL0y5HMvgMYP3zthBowh7SCjcm1ftmFGJGlfu+6kIoGE+1D1m4K83Jz15e3HpnfvRsTMHVsLCFRkjrttHgfVouzuSMTMNLi9Mvn5A/YKD2TwK73W+DyNmhmYUPlNWRvkXrgGkeDWKlXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPa4BLdB7W57jOrPW4KsdPy9Fr/j8D4a6BLrT8ELiww=;
 b=2R0m2UXap9+KzziaJpK+BHdixisW4DRNK2IWat2prn4BXJHK7c8z+b5tkefOs/h9Qf34SeORU49TO2DB8oXBedEExcb+N4S2jPVqYRsaimCZzs7kVpWhglR1t/m66tnJmcswKN5DMSDB0dHD5gfyXp+m3LrwelaUqEUfJDhkr0Q=
Received: from CH0PR03CA0069.namprd03.prod.outlook.com (2603:10b6:610:cc::14)
 by LV8PR12MB9449.namprd12.prod.outlook.com (2603:10b6:408:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Mon, 30 Jun
 2025 10:44:44 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::a9) by CH0PR03CA0069.outlook.office365.com
 (2603:10b6:610:cc::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.30 via Frontend Transport; Mon,
 30 Jun 2025 10:44:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 30 Jun 2025 10:44:43 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Jun
 2025 05:44:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v7 0/2] Enable Secure TSC for SEV-SNP
Date: Mon, 30 Jun 2025 16:14:24 +0530
Message-ID: <20250630104426.13812-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|LV8PR12MB9449:EE_
X-MS-Office365-Filtering-Correlation-Id: adf6f086-256f-4c7b-be9a-08ddb7c31fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xFv0li2cAQoBWpCTA68qI6fcheL0G0GgY9HuqYYY1etR1p6pJSEELhXRyDac?=
 =?us-ascii?Q?HyNneCV55HCN61q6quv1ofZnd5KbBJGmCId2l08GOsoxF36sRQocqgtbJIXN?=
 =?us-ascii?Q?McEzV2DFsFrtFfuFKbsTQHjAANyoKOUn49lEJDLLtj8Yc2Z++L0WGMxM6xDx?=
 =?us-ascii?Q?CdWJ3GqmT0rmz5QsX04gTck2+Qbkoto82LtI1XIR8KwUuLlluRRYuLnj4yPd?=
 =?us-ascii?Q?I2pj6VEX6lXjNGn24vxVRVZZg0+Hdn3gj5YCqVLLXlNHJNSjXtmZUTROzomZ?=
 =?us-ascii?Q?iTFdZAnsxFkmfJAQkTMtr77Ie4aENknO5zAwWoUvZboJdm6QQ3C8LTqpfapZ?=
 =?us-ascii?Q?wgEr7+DezQLwc8UyxDAEvexoK4Pd0z0OK9TddDd5m2E0nxklTG+76F8k7hrG?=
 =?us-ascii?Q?T8LnCyjcAkpNGgE/1iNQzAG06qpmcwr413umhRv8xJbOOwf1SKC0819MkpX5?=
 =?us-ascii?Q?SsCU+NaPY26XyXBnbpIdG0Eaw/TFqHN6hpEw/egdkJm2nVayndZ5x3gqJdLW?=
 =?us-ascii?Q?gtyyRlRJntDHZkolcQd6P9IDCGLyu+s9xneTpJcOSSSgFg6OWOQUTbo48iKO?=
 =?us-ascii?Q?yncMYx+OEDfgF8oPdUp7fCqX+509Tu7GFSBjIfTfdZJ0I4YZ+FCeF2b769VI?=
 =?us-ascii?Q?yPvc3Ur+I00pExNnynAqbXrxROT5tOlUf0e3OdQB668nkGdtg6UHgL1QAu9S?=
 =?us-ascii?Q?hYp9T1yTUx0wiGemtYWBBPJF4gEoQ/pHSMhEgA+HbT6Ik0bma7CVMl/IOBxR?=
 =?us-ascii?Q?CIXvNBrSlTEyWDqAepggOqAWInnnk+sFwVUP+MlnOZcefVLI622KEuhNX6nL?=
 =?us-ascii?Q?DKgoLUiPkWBVZdQQJJLSIxpTrjTlxBwLuy6qj5KuN9JOdlOHN9maYzEmVxJO?=
 =?us-ascii?Q?TuDPvjiiVsWnEPrUM6dskX1+lanTecbdNo8u2m2fGwDxHhYBBnkUUvKdzr+0?=
 =?us-ascii?Q?+DFKTDPXxBuQAxCIPxpILs0WIImQSj/fbhwQyCbv1FfxxWz09PnRVJky7IYt?=
 =?us-ascii?Q?ucAXJxSPf/hptytW4FEtcw7D/7pCq5SgG8ZgWfK+WMROdfaCSnTL5fVYje+g?=
 =?us-ascii?Q?atHcE9jkf+SvS5YWXpu41Cv5VXH4c/HBMtqcTziGuXI9WziDmC49zeJz4mdk?=
 =?us-ascii?Q?+z19Oou4HxrSg6jMGR4cmrQBTDDPu/VU/HAuE3s/ZIEdEcOZ+gSilwfBHpFv?=
 =?us-ascii?Q?dSBJSI+hW8Uph/oHD26JyUXB7Ubo6VRcgAqmcxA7/BU+/PF9gYyCyIaStg5Z?=
 =?us-ascii?Q?H9GDmFr6h1uYqxB7wFts/UjYZpK8vgaFtTTo6nW5RSx/8DQqIY1gbqBHljAi?=
 =?us-ascii?Q?/NGC79yif32xtPArGmeeThq5pNp4wXOAZf9MNT1k64eQJbcKYm7Bz42uZBsE?=
 =?us-ascii?Q?8Gx1j8DtbeeWNJH1/ugvMslYkBhCLzD/3jMOjUfBXPrIn+fEPLYV1exTown/?=
 =?us-ascii?Q?sPNRXeeEfdTbaSoJrMpHHZgMTBTwHYNJReUZhH4P7ZgxBfBgAxZcmy8ou/AA?=
 =?us-ascii?Q?fAgL+8OSA0g3hKATkwFyIsQbuAhjU3f/SqkX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 10:44:43.4890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adf6f086-256f-4c7b-be9a-08ddb7c31fbc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9449

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

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
v7:
* Rebased on top of kvm-x86/next that has MSR interception rework
* As snp_secure_tsc_enabled() is used only in sev.c, move it there (Sean) 
* Add checks to prevent user-triggerable WARN_ON_ONCE (Sean)
* Squash GUEST_TSC_FREQ MSR addition patch
* Dropped RB/TB as patch 3/4 got changed

v6:
* Rebased on top of kvm/master
* Collected Reviewed-by/Tested-by
* s/svm->vcpu/vcpu/ in snp_launch_update_vmsa() as vcpu pointer is already available (Tom)
* Simplify assignment of guest_protected_tsc (Tom)

Nikunj A Dadhania (2):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Enable Secure TSC for SNP guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 34 +++++++++++++++++++++++++++---
 4 files changed, 35 insertions(+), 4 deletions(-)


base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
-- 
2.43.0


