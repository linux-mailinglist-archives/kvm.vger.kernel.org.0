Return-Path: <kvm+bounces-51662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFD2AFB0D0
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 12:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 909953BB2F8
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 10:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7DD293B55;
	Mon,  7 Jul 2025 10:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x4EkyGSt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF51F8755
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751883056; cv=fail; b=Y+9JnGIt/tNVk5gJoIh1zM3NxNy10daDmRRkBUCp9aE6wLYT5DwpwitWkvejRyJScLFC/vkyHcIPavJD6muqTcI12BD19DNwKZ8EOEwRoJjgHZo5qzO7HtoKLkZC/inC2QE357mfSVgFCRKse0ktzBpK80kk6CFxl9dxWJvUkT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751883056; c=relaxed/simple;
	bh=mT9TzEBCIDrEFhMwOuP4XZx1QndlHX2MUWJnONNX9z4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XsgrAaVNicsVqoT5d1VFsyUoE5QEmtEwRPe/Oyw5b5fd6mEkmtde6MW5YlwlbsfJsneSOMLONw7APaIkakrmDC+A4qixq52o9/NEOIA8g3TYFs/slgPKgMX/vHICjc6ZTU+V2WvgNr01KSBMz+FixRheLLNEC9FOqDGZlyjFw3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x4EkyGSt; arc=fail smtp.client-ip=40.107.95.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WowMs8f9aV4Gm10t1jzvKKw6/umq6rCEHCLUqNpSQgOnZfOuB3lluMB5c4VsEBLq/Rd3b2V+VwFHJH2VP54rfWR7K9EeaVgeheY+ypHoENpR67XLTQynQHNi5PVtgOjLk05kMG4MhL650LNkqTHWXVPeh8JPw9iIiens4shpkr1HEytn9d9bTgCQJ3qevTY9Y6uQ5SEdQ4ulENKAE9QtC4VCgRQ4jvD1u1eTbmBomFtgFxBjRbKUUe3VfAQ2RvD8C67t9Do3W5nZYd5/IMa/zdmJrvWv73BpMhB3yvrBTtxz7n+i2M9G2fgqg4jOkD1ikNHEIxqAHV+c4QunQS/gjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmXyIOWWTjeCQOLINct0I9MKvba7OHnSpDsVBJRHLTs=;
 b=hGTFZvXtWcCSS5mOiWsBcBOTvfMmLZ/dGVm31MdXPPIC6RTrugwKdlVnrFy8+wDoX39ur3SRYobC7kThCOijcf2E2Vdq5iSV79+tZuJ/PE3qeBCzb0g+/UF0jaOAL+Wf8FvDQeBR2Bs+gloPFQGu+KkB51e4SVDLF0kd6Ei13pWpo0LfU5Lr6WXDYwcaC9crumlrnwn711hxnxTyNHAVhVlSWnzk5nCRRgjl68NE4TZUZp0+bWtu0I4v+MSYJ2PaoTIiqHbYf14HfBjYI9osLQGE6apBCoQGe4R4ov4teNVH5NRdMD5FKVNiAzykiySBRaxifr1AKhv1oYhqOHl4VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmXyIOWWTjeCQOLINct0I9MKvba7OHnSpDsVBJRHLTs=;
 b=x4EkyGSt+yaD9lhm/wgJtBAC51a44JpntvTeEWZuOucxjQAe8hiCcpBm96E3BZEOTVgnlwr6W7fcCsnvpa4esGh0ApaBcYeGcPUGFnPTnwciX47Im+0EGN2xOhe32Jibq+yTlz1K0HF10uZRo5xBYvHQ15WyvleocW8lB8SvIYw=
Received: from BLAP220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::13)
 by SJ5PPFF62310189.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Mon, 7 Jul
 2025 10:10:51 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:32c:cafe::d3) by BLAP220CA0008.outlook.office365.com
 (2603:10b6:208:32c::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.26 via Frontend Transport; Mon,
 7 Jul 2025 10:10:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 7 Jul 2025 10:10:50 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 7 Jul
 2025 05:10:47 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v8 0/2] Enable Secure TSC for SEV-SNP
Date: Mon, 7 Jul 2025 15:40:27 +0530
Message-ID: <20250707101029.927906-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|SJ5PPFF62310189:EE_
X-MS-Office365-Filtering-Correlation-Id: aab08542-0cbf-4b8c-a563-08ddbd3e8d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0QuDgAwqcijcYUb0/jhHK4x544ihiQy0Xm2YFswEhglof3Q9V909EVv8CNNh?=
 =?us-ascii?Q?jI+b5T8jfIIlPOAOFzHKVQuPH6m9lwq5ave9iI6V0Pg2yfAshr0/iq71Oerg?=
 =?us-ascii?Q?Bmp7AJoKxDnnTQnChVvZ9gDUMwzmNtIHuHS0mwB5t054G2i4ioDOWqPVH/jK?=
 =?us-ascii?Q?fJsMLjeHiS0FzpbSHY7cT6aDLwm6TGRGXx7K96Jzo6+K/O0zpmS8vT9nCcmF?=
 =?us-ascii?Q?HIfxlip4lEuwKXEjwdNxrJkcE3kc+HCjbL+1p3QaSWAcxMPftd7Kh9/mqxMR?=
 =?us-ascii?Q?lD3++KsdAt0vXRs9cFS7XWJQMq++gB6ugalMVYFftLFG2g5bD2Q/6FXLr8SK?=
 =?us-ascii?Q?X/4D8t4xqCfk6kSyagh27hlBL3rZzJ/Ob0Pz6n9piKcE4qZe7FOgma2wYy+m?=
 =?us-ascii?Q?Fpp3Uftu9uQRkqa4XT/4FpIz4xPW1vVdAGYZd2yRriyWtu8XzaeYhepcRe94?=
 =?us-ascii?Q?DtD024UICErHAoTyUZv5uTbBEApqsULbRdyliLvO7cjXVUGR/2xkbII2TP8L?=
 =?us-ascii?Q?410a6BqddoTWejDVaVE+oKqD0rl+RryNXmaXUWkiCtsD7HZhJZTG6C3LaVgP?=
 =?us-ascii?Q?FIYm6E1mABTB8NkvbObPOtnLbEy/93Di3ju45CBHbpR1qKAv2jbL7iwTKP5g?=
 =?us-ascii?Q?A7lKUPXA0N9EbkpMPIoGzhMLMTnqi1yXmwhbgJZC45XNX5/NnpKtP8WJdcVf?=
 =?us-ascii?Q?/s7zAnRct31QMgv3lduMMxWCPmVZ46hvGRxQf3tgm0s7azNsWoaPEVtylqRn?=
 =?us-ascii?Q?KUL/GrCK1yxrwaJEQi/xFmCeyE/yHXhn/Z/uyGPeo4oZB3qLUw30ik6oD1vc?=
 =?us-ascii?Q?7CGW34UUjn/LfkavMN221J1k8DaB6oBEeGjiA+Cnwwryg0hWg2Nr6ljuMfRX?=
 =?us-ascii?Q?xTfQXQvsp6KLdT+eaITW0QNcMLLIxIkD4KXvIj/3qA95j4lJAKwcei7CCphE?=
 =?us-ascii?Q?leoUOKeH7f9o1CnwpzdXr9hDrzwwk8l8jR0h3V8CVoro//yXSnyzV5WVvVV7?=
 =?us-ascii?Q?G1u8adc7eAZz4OVT0W63bzkze1Oh/ZYl3jxTIywge1LzwdZg9XSwnsQ6kwVE?=
 =?us-ascii?Q?6QikKwNUPOxxJh35b/ZJPGMTb83J1WJUPgcjl6CiDtYI9GCstM6eelE+mHsV?=
 =?us-ascii?Q?3B5s09wsdGslqHRaDGsltHGVVme3vlp2tsHYeuHMYu2Nubx6TQoX+YbeRbbH?=
 =?us-ascii?Q?VQGqs54oVvSZvEysb32CaTCw4jLxFeJIZX4r6fWtWZKXnAUJk65HpeCjgCDO?=
 =?us-ascii?Q?ZA84ogc2oM19KzagRsCC4tEJd5FR4d+Xmdl+T4QVWVXWwDTCv7xKtAhJZwwp?=
 =?us-ascii?Q?GgAs3Ku1RnPHewrs2kJLvVfT/YBj9zczIyEWJSkuHRXtvY4HYXL0Z2Dzl02Y?=
 =?us-ascii?Q?gMw7ep/U7hnOCwOmA45XSqiDx4rjG9BX2sN51e1wMR27Fw6Tx9qW0GU88CpM?=
 =?us-ascii?Q?tI7FLE27wpT4rEweYM9PX39ixBHsjXUiXPl3pyayhs7BAQNliF7aqyQ+oequ?=
 =?us-ascii?Q?AnAFPdR7oPeCBC72ar/JljzgsjBCQIwX4zqQ2avnJZiFAiMQQM2RUeqF0w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 10:10:50.7812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab08542-0cbf-4b8c-a563-08ddbd3e8d08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF62310189

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

Patches are based on kvm-x86/next which includes MSR interception rework and a
fix adding missing desired_tsc_khz to struct sev_data_snp_launch_start

51a4273dcab3 ("KVM: SVM: Add missing member in SNP_LAUNCH_START command structure")

Testing Secure TSC
-----------------

Secure TSC guest patches are available as part of v6.14.

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
v8:
* Commit message improvements (Kai Huang)
* Remove 'desired_tsc_khz' from 'struct Kim_sev_snp_launch_start' (Kai Huang)

v7: https://lore.kernel.org/kvm/20250630104426.13812-1-nikunj@amd.com/

* Rebased on top of kvm-x86/next that has MSR interception rework
* As snp_secure_tsc_enabled() is used only in sev.c, move it there (Sean) 
* Add checks to prevent user-triggerable WARN_ON_ONCE (Sean)
* Squash GUEST_TSC_FREQ MSR addition patch
* Dropped RB/TB as patch 3/4 got changed

Nikunj A Dadhania (2):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Enable Secure TSC for SNP guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/kvm/svm/sev.c             | 34 +++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)


base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
-- 
2.43.0


