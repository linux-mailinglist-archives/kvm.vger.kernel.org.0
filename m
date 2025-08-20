Return-Path: <kvm+bounces-55136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0878BB2DFFD
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A1D018885B1
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40ADA31E10A;
	Wed, 20 Aug 2025 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kgG3pRl+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC75E3093BF;
	Wed, 20 Aug 2025 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701475; cv=fail; b=OjYhG84cxfQAdnjXVDdso28HskDNVh/CULdW6HqbkhmnGy127RnezyV1mbSKRhBMGwwVNRcGU6f2yFjE+LWUBCkd9sfJasItzzNMqej+7iRc6hKtI0gPY2n0R7t3xt+3AJQ0Q3/oPDTRs7KKAdYl4HJyLRQGDs/DIm5BixMwcx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701475; c=relaxed/simple;
	bh=nlB7z6XuEeLqSjER5ITani4U+xnF3OUahTMd90rl2X0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VC/BKsQ5oH31uZX2iPw7Ax/KFpF0k7ES79O5kaZZzYHuow61eY/5c/8t8g/CUNNmO/tRBGF2R1FZTcZGb5eLqk9nqGdyXbkXq+FLXf5Qlk8d+7QFjUi7xDbJB6Wi4+HQbBPgCMSyvN0RriAJiOJV3mh+SyAPzWeU2xkp0VCLYAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kgG3pRl+; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxYpu7Imn/mIojtz2X6ftIK2gjVH45H/DAwAQYeSMuhXuhHvhMd6psM1gQDmQaCI1lMK5VowDkyscmMl70ME9WE6p3qCLBDL5Ujf/PJkPfF4DG0kdPo8q9JCCFAXaZVjqeKrnWIgfXONrn1ehKsmqK9Amjk/Zeuz6DuVVbx/abDi+Jvf2LWStnj/qo66rgUd7uOWw/BAyYJ183nUm0E4DWWA2FGBp9CudAD0tV1V3mVbrl1YBc80dNYdNfMi6iG8Teux2z4EeIXYmJxHQfbDSsbw0Q7r60u3XY6mYIE1afu0GXTcgxJwbQod2cnnWvpe1ZVhvhn4GwM9rmVGvA70dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOs2qqXTLB0/+0V4g7p3p8lHJFZktGpTPiZNbSRQXgw=;
 b=mcOos4gql6nxtrxvE0U/DlD9ror6mMbtCtADNjFlc10JUONP1LWMBz48ON4aMMY+xwPFGUaxvW0vy9/ERVYuwT28DAnKw4YBPUEvpLFPNf+0h1E3C7iLX962rvmh8jugr1bIgm4l7uyKdxmteM+B3o0sy9+wLCddQAFCQYnOMFxmKqO6BQVT6HqhnMF3ZBXOyEtZFkTXfal1cV19lZWWVvBLlpDooehidKOnF42OV6kVR2nf1cAkNX8DiszpG7VINcWszhcb7kxKeLZFMtK7cdLv9M2YQGkaOcnuNesC8gTQPBCnIfbsYAG74yCeQCCxG8Y9uGLV+tpcVi1Kjxbk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOs2qqXTLB0/+0V4g7p3p8lHJFZktGpTPiZNbSRQXgw=;
 b=kgG3pRl+pQgCi20DiAknHo+nAP8g4NFvstVWaE0dp6Lv5YpmRtf/KmO7YqfMNHkvbYrLWahqBfKJxIkfc1DmDIxqrj+tz3J99sodt0XOCAUnAhz26dHTmyAHeaw/KQ1rJkMmg9plooRkfn9gEwK+3WxSecS6Vn3Ck3Ko2Oo5eM0=
Received: from MW4PR04CA0143.namprd04.prod.outlook.com (2603:10b6:303:84::28)
 by BN3PR12MB9569.namprd12.prod.outlook.com (2603:10b6:408:2ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 14:51:10 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:303:84:cafe::d0) by MW4PR04CA0143.outlook.office365.com
 (2603:10b6:303:84::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 14:51:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:51:09 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 09:51:07 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v8 0/2] Add SEV-SNP CipherTextHiding feature support
Date: Wed, 20 Aug 2025 14:50:57 +0000
Message-ID: <cover.1755700627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|BN3PR12MB9569:EE_
X-MS-Office365-Filtering-Correlation-Id: fefedb90-0110-4703-2e77-08dddff8ffec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qZNqNPoL33VRLkFnL4z8LIPMSKBhlKQPF5oUZ/LFWeeWVL7f6+IrIO/u8CST?=
 =?us-ascii?Q?29vvzDUL54R7rCsyZenQLr9ncbolsnYP4Vy2343jgbDhOWmGF/fLh4ry3Icu?=
 =?us-ascii?Q?zmCpAh7MQgsBcQYI44E7XfLPChzjL1RXd4sTlN9ks3GEvTzjkJjR93kLm2rz?=
 =?us-ascii?Q?oyandhCYZK3QXBm6EHEpSAlwDmHmyxjB1UfbxVQkWz1BkNfw92rhcbjiRHWY?=
 =?us-ascii?Q?wHaUBLhX3nAXHrEPXqYTKxSAG5uccwsJe1Mooq69OmDEVyaDLv7iBNsQbzrK?=
 =?us-ascii?Q?oQXbyAUAmJOdv/elS5A81LegvcT7f4g2i8JmHGWJgJlOTuMAFl6SxtIaeUzi?=
 =?us-ascii?Q?fsaq768OVDyw43ayDo0qZLAo2Kw9/0e3anKFw57MNwCz03ndBocWMlSjBN0u?=
 =?us-ascii?Q?fEYJdDaV3+431hDPeR0xhH7efCYRPjWbbIjsw2jjvcaaLZIRynSpQ/cA4PDy?=
 =?us-ascii?Q?wa1E3GFfC2AsgipqKjnI6V9i8RyYd4dLCkVZhZVKGphojMO44ZVVGrQSA9JG?=
 =?us-ascii?Q?G8bebc+OI9/R76TxILzVN+chmndOy+6fuavj8fWqGhpeojYnchAXBEzRNJrs?=
 =?us-ascii?Q?vktm68EMeYw61A8fqHFYqdlqUWzz5/GwbhvivS/cM7OCs+h3QnktsZR6hp6E?=
 =?us-ascii?Q?J7JkELE+KgoILh0e3Y+zTuzGimj9HSifyUhPBKgIq287XV6WUNZT9FY3hyYh?=
 =?us-ascii?Q?lwVch7EZFrsaMKiKEZ5omWDCHKOIyW068Pgfo2xJB2keKb6edq03BklrR6az?=
 =?us-ascii?Q?rNSjFqfpIZJv7pe90/JAER1QgEHEsW0ndMJNAPL2H7oE+6s7/6PXqDqBh4Qi?=
 =?us-ascii?Q?uCoUQ26/HyJ9gJEH1uNrvA63LLL54IDrb//6UQ0ICONWyGR05lu4R0qMjsHw?=
 =?us-ascii?Q?b/Swt/ROx1QqeB8Zrqt/+qN6dKHwRT6GeeSRzqUzw7sHaumUDoeux1R55TTY?=
 =?us-ascii?Q?e6vBvKSKYiUqj2LLMdWQPD/G6+sNkMoVC3lrvDGmcXbbEsNT2hEo7U1hi7wK?=
 =?us-ascii?Q?Ewh7kn8nmz5DXXcnzh0/wosm18Mj6uwNhGjV5hAFNSmZtWEmfXx+d3E9uX7Z?=
 =?us-ascii?Q?63lphSnmA1M52BTWiEH3sks2mfi12E8HExNplw+CnFMVrl0m/fZGcDZTCBCP?=
 =?us-ascii?Q?WaqtagAgi26FQokSoyyg1YENljlOv6sUTTkSA3rvk337ztUP32xr0bdtIaZg?=
 =?us-ascii?Q?NYYO7T8CEFzhcTVKxoqk0DcBLe4/npKjWonc1oJj9tQthB/UAZYVqqFCPXsW?=
 =?us-ascii?Q?YBHCAkibrWsGWfiN/XYkCRYm9lZ2T9cVvY3cSmPI0dg61dhcBhDPNexyg4mH?=
 =?us-ascii?Q?nJPg3jXN8RXD4uBcCz33pHhz05kSU2VlEvBfudxiRjngyUYnW3U3Q7NsS+o5?=
 =?us-ascii?Q?pGbotNrPk4iCfbw61sLffPRvq7RIYfMDsnJy+PcE1MzrpHugFchYwXx/BfYL?=
 =?us-ascii?Q?mH15AI8WhR2eHHAvwaIv1/ozNL0M9YaQZWAQJZap9Hh/rlAcXNMo0NdYM4M1?=
 =?us-ascii?Q?WuNqH5TbTOLtburKrSxE0pekoJUfuHHz5+mEAyaRmJ4hghdsJawQthrtK4S3?=
 =?us-ascii?Q?ZT650IeajIV+1GGhPRw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:51:09.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fefedb90-0110-4703-2e77-08dddff8ffec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9569

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add new module parameter to the KVM module to enable ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is '-1' then the complete SEV-ES/SEV-SNP
space is allocated to SEV-SNP guests.

Based on linux-next.

Depends on the CCP driver patch-series for SEV-SNP ciphertext hiding 
feature support:
https://lore.kernel.org/lkml/e1740fa2-f26c-4c3b-b139-b31dd654bea6@amd.com/T/#m1100d65b99cbb022c8a2d04ec88082d3ba68a219

v8:
- Change module parameter to enable ciphertext hiding to use '-1' 
instead of the string "max" to assign complete SEV-ES/SEV-SNP ASID
space to SEV-SNP guests, this simplifies the implementation and moves
most error checking to the module loader itself.

v7:
- Fix comments.
- Move the check for module parameter ciphertext_hiding_asids inside
check_and_enable_sev_snp_ciphertext_hiding(), this keeps all the logic
related to the parameter in a single function.

v6:
- Fix module parameter ciphertext_hiding_asids=0 case.
- Coalesce multiple cases of handling invalid module parameter
ciphertext_hiding_asids into a single branch/label.
- Fix commit logs.
- Fix Documentation.

v5:
- Add pre-patch to cache SEV platform status and use this cached
information to set api_major/api_minor/build.
- Since the SEV platform status and SNP platform status differ, 
remove the state field from sev_device structure and instead track
SEV platform state from cached SEV platform status.
- If SNP is enabled then cached SNP platform status is used for 
api_major/api_minor/build.
- Fix using sev_do_cmd() instead of __sev_do_cmd_locked().
- Fix commit logs.
- Fix kernel-parameters documentation. 
- Modify KVM module parameter to enable CipherTextHiding to support
"max" option to allow complete SEV-ES+ ASID space to be allocated
to SEV-SNP guests.
- Do not enable ciphertext hiding if module parameter to specify
maximum SNP ASID is invalid.

v4:
- Fix buffer allocation for SNP_FEATURE_INFO command to correctly
handle page boundary check requirements.
- Return correct length for SNP_FEATURE_INFO command from
sev_cmd_buffer_len().
- Switch to using SNP platform status instead of SEV platform status if
SNP is enabled and cache SNP platform status and feature information.
Modify sev_get_api_version() accordingly.
- Fix commit logs.
- Expand the comments on why both the feature info and the platform
status fields have to be checked for CipherTextHiding feature 
detection and enablement.
- Add new preperation patch for CipherTextHiding feature which
introduces new {min,max}_{sev_es,snp}_asid variables along with
existing {min,max}_sev_asid variable to simplify partitioning of the
SEV and SEV-ES+ ASID space.
- Switch to single KVM module parameter to enable CipherTextHiding
feature and the maximum SNP ASID usable for SNP guests when 
CipherTextHiding feature is enabled.

v3:
- rebase to linux-next.
- rebase on top of support to move SEV-SNP initialization to
KVM module from CCP driver.
- Split CipherTextHiding support between CCP driver and KVM module
with KVM module calling into CCP driver to initialize SNP with
CipherTextHiding enabled and MAX ASID usable for SNP guest if
KVM is enabling CipherTextHiding feature.
- Move module parameters to enable CipherTextHiding feature and
MAX ASID usable for SNP guests from CCP driver to KVM module
which allows KVM to be responsible for enabling CipherTextHiding
feature if end-user requests it.

v2:
- Fix and add more description to commit logs.
- Rename sev_cache_snp_platform_status_and_discover_features() to 
snp_get_platform_data().
- Add check in snp_get_platform_data to guard against being called
after SNP_INIT_EX.
- Fix comments for new structure field definitions being added.
- Fix naming for new structure being added.
- Add new vm-type parameter to sev_asid_new().
- Fix identation.
- Rename CCP module parameters psp_cth_enabled to cipher_text_hiding and 
psp_max_snp_asid to max_snp_asid.
- Rename max_snp_asid to snp_max_snp_asid. 

Ashish Kalra (2):
  KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
  KVM: SEV: Add SEV-SNP CipherTextHiding support

 .../admin-guide/kernel-parameters.txt         | 18 +++++
 arch/x86/kvm/svm/sev.c                        | 80 ++++++++++++++++---
 2 files changed, 88 insertions(+), 10 deletions(-)

-- 
2.34.1


