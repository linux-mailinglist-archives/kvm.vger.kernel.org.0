Return-Path: <kvm+bounces-59868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 131B0BD1AB8
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4DD3B4EF8DD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06EAF2E2EF8;
	Mon, 13 Oct 2025 06:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3yCCb/3O"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4882E0902
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336750; cv=fail; b=hcj36UVeozxxCvNrbGqygRvHaJo5e7X7toeuB1E/QCHwpFMp3f9R30QZaPjuWLKswHa9nTBRlTjZ0UesDahgpvyG2vjjYIVNdo4AT74hMuxPpchICO2+b04nTPBlAwkFfxF0HOCD8jpRTA9uT8IxbGN2wDMvMvL7pQRQPtEz4jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336750; c=relaxed/simple;
	bh=yu8wa2HE6zN9IIhELxS3HiOLlSlcgoxKiU9JwUhpmCU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZezPyeCNNgfRzNLoG7pVBzNg0a9rmuhEQEe/S2/zQa0OLH9C4hKshb+nWngV6M5x6Y7VhcPtYbMc/JbgY2i/KPyASSdpXd6yIlOHGMGHfqzxd9w+ez7QxFx4dbWme+qOX3y1t/Mwwpg04IcJSLIk6HsUYxEclHMyxT0WKalRkD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3yCCb/3O; arc=fail smtp.client-ip=40.93.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kNOEg+Kh/uZFio6MzonTcGAZapL/Ygy2sP8CmJa5JZ63MohhsMDrNajln5cG5xYAjzo6Sa2fzAGDNiM2PBk885w/soBenf9C0bn1T8BuO9sbR6t64T9LiNQ02cUuVdp6r7gOol8XTNCg0+25bpian8BXfQ8MK8WxhRpumbxt/IMIlEBfYFTiScfwsNEYxT8V1JI9GA0ilZ375y9E3bR8W5PthugGmnlecSdt6NFHhfR+3+wF6MxpdUQFrmHO8YmpYbKEvhMlqPpzBgQ4yk6FyHBxJGnyClbQMkai0eICmT5d170j9iJljuMwAFKvayShMh5mMxUlQf5IrMMpkOQ63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cq/KkrMuV5t8WtOSLuyi51WPeFwdgKKEcS43xkuTZn4=;
 b=HIC6xPX6mvOsOMXmqU+Cus+FvDphzMFpapdmhL9pbJ0QJC8MJJsJSSzjPiG6D1LxfM8Y9JWRAh4gg5jiW+gsdVd8epVyF2J7JUaHynWwOIKOD85VIyI9HXssRMS0C5Xk37MZ3QcOUWWkPq0EYFtX2cifFyuPogTh019u0DTDxOpLAohOBliQQTLgTb9Nonya/v+rPkXWB2J8TuZolqceAphjeFHVccdAEq0tLMWF/kC1MhsxPnVjXfsTqVY6DqJXnxWi/sexfuhme0RYVEI8ac2B+MFKuEVcy76K8ymp2dTcsKvI8fFsrEtWSeEu9InVxQqRmN7LZxL+3veERahPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cq/KkrMuV5t8WtOSLuyi51WPeFwdgKKEcS43xkuTZn4=;
 b=3yCCb/3O5ebgdHPjKeLt1B2QQKuPiMz8RCqEZ4EZErIxvsVCM0tZeioZJbsre+DB5xauT50kgxhjCw1UjXO6GrtCS78xxjsQqM+QYuVMcoJucL5nTaYsyz7k32XofbLjf4ixx+Nn3JnujpGX6yvw0NCDdxFcvesjWWVjjBUF2QE=
Received: from DS7P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::17) by
 IA1PR12MB8466.namprd12.prod.outlook.com (2603:10b6:208:44b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 06:25:44 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:8:223:cafe::bf) by DS7P220CA0028.outlook.office365.com
 (2603:10b6:8:223::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:25:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:25:44 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:41 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 0/7] KVM: SVM: Add Page Modification Logging (PML) support
Date: Mon, 13 Oct 2025 06:25:08 +0000
Message-ID: <20251013062515.3712430-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|IA1PR12MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: e781b64b-1afc-48bd-103a-08de0a21572f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/pdVMALh8t0/aJvx/zHTzpd6mXlYg1WJMdcUtls7ulgsxIjKzbCnxLgR0ZkT?=
 =?us-ascii?Q?d4SvT4A9Qgln6qixbK2el3+HvyWHGBYDOVC2afw1Ypnfbm9rBochwlQLin1l?=
 =?us-ascii?Q?u4cTBzsb9zjxRH04WvTkAx8aXilD+HRJNxXUH5aRuhbxl9uTEXhOsV4KtU3S?=
 =?us-ascii?Q?014OK+jlmHezb5ZB7P0tXPNCvkLdeumJFtGY2wKZSQTVktkbzh9hREQpWqCT?=
 =?us-ascii?Q?1+hziQItMcvGZr43Ef4K+3lIhlDo/KQ3lS3I277kxy42NdnxSQRKzcWarQh9?=
 =?us-ascii?Q?HSKOF5sUlZujOBBi3FaQR0kXBzXqed1+U7YidpfYhp82WVmo0Y0CDWYxePCQ?=
 =?us-ascii?Q?JDLETHb8gloB/yGqF1NPMzJiiXcoXwTXTbkub4IlyI9xu0DFmxEmSorrYyZw?=
 =?us-ascii?Q?OTZOBCnrC7+L7LKAOPo6lR+ylrIUABT6W08jF7hTgWSXZ19NrjVlhVE/NF3+?=
 =?us-ascii?Q?A/WGx9/eeNL07Y8RoWtW0hEwnPDV47gTP1/fSCcdEH+gUxpW4Xo9pPlE+sXk?=
 =?us-ascii?Q?c+sA5H3a8ymt1ZYRx0+AVXZcXtKWZBd7otBAmYZVR6xzLHRMdRxE5YOhOF5L?=
 =?us-ascii?Q?AaYQ2UwKbM+UAGZdshhEjEcM+eS0wja5gX1CBWf5LeGnD/uFPFSDnLWtCa89?=
 =?us-ascii?Q?rw3koq5S9ebAb6Sy/nwkoxFZNaUiF+XZAeHL/9hpW7S8UTWldivMeHgw9JR/?=
 =?us-ascii?Q?2nCyTMooacQS26Y8RmBsCYoXwTigbzX7+FH9BqzFDW8aWdEhdXjO/1kwaKKw?=
 =?us-ascii?Q?4t/6K2N559z5x1hVKUGtt2/fMIkIQtyVQyWKQKoB3gu6z0rTV60SByvmTBQV?=
 =?us-ascii?Q?xM/iHly/Y7lC3vU+KFJAPWHoF190Fzio+bGdrxzPPYWMbsTvTk8BXd+NHbSg?=
 =?us-ascii?Q?O39kWOQBgK2QhsVAvIk8ThCHHA/dSnci0vgh10pEUnRCvuEr+MX9XSiFf09n?=
 =?us-ascii?Q?+scgmQUEXBajMUCy0JiYct2InZGQ+SeekXXwgBzrlYcwYzUICVTSOcAoGkBP?=
 =?us-ascii?Q?PEbGSXQzaJgAOKleq84xjWzujKZnbg8TZ6XdT3O1iH47aTwGL0CpMsXQ4Enh?=
 =?us-ascii?Q?l73dABUA+MijDeAYGxiWxPD9OFG5nRpYE/ZYjNxoKLU+sbhuPNhuqNQwkJq7?=
 =?us-ascii?Q?9zxASRw37xcXI9JdYz09ojXqUjcXgIVWwsdKc2WJZO684LD7LrJKQcI/iCSm?=
 =?us-ascii?Q?m9QYj6mRtyKgqnJpp8o0UwZX0htNQQ/qJXecmPjzFT1bU3xtrVUVebDmdjjG?=
 =?us-ascii?Q?mEwI4u2KbGypksjtoUijuIbfvnEq8Ru+9I8Y6RI6pKgUAAnqgOEfMNVt5KLe?=
 =?us-ascii?Q?kKkN//E4hxPrMZqKlWqlGqduJvdxGE1ccXGVRAJRtvaR22mM51WfsXQlWYBH?=
 =?us-ascii?Q?GioNEJFDYVpc9KNlTXTn4m9CdftbXt9AOhHLkAWoGmCg5tLNYb3oAYGXbfMf?=
 =?us-ascii?Q?f+o+lUkwb3LlsvDm9znGKGwfq5U8C5OdD5tLuy+f0vDBGlHf4sq0jLMQYr+m?=
 =?us-ascii?Q?NPqlSQ2mt7GEwQpRWlvSEMqnXB06tt1Y7Kg/ALSwnA0WPE9QI30jdrl1jkqE?=
 =?us-ascii?Q?avTtxsxlqfxp0b5pc7anZ16wxlvTWnFXAeR45Z4B?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:25:44.5256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e781b64b-1afc-48bd-103a-08de0a21572f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8466

This series implements Page Modification Logging (PML) for guests, bringing
hardware-assisted dirty logging support. PML is designed to track guest
modified memory pages. PML enables the hypervisor to identify which pages in a
guest's memory have been modified since the last checkpoint or during live
migration.

The PML feature uses two new VMCB fields (PML_ADDR and PML_INDEX) and
generates a VMEXIT when the 4KB log buffer becomes full.

The feature is enabled by default when hardware support is detected and
can be disabled via the 'pml' module parameter.

Changelog:
v4:
* Add couple of patches to enable_pml and nested CPU dirty logging to
  common code (Kai Huang)
* Rebased to latest kvm/next

v3:
* Update comments with nested details (Kai Huang)
* Added nested.update_vmcb01_cpu_dirty_logging to update L1 PML (Kai Huang)
* Added patch to use BIT_ULL() instead of BIT() for 64-bit nested_ctl

v2: https://lore.kernel.org/kvm/20250915085938.639049-1-nikunj@amd.com/
* Rebased on latest kvm/next
* Added patch to move pml_pg field from struct vcpu_vmx to struct kvm_vcpu_arch
  to share the PML page. (Kai Huang)
* Dropped the SNP safe allocation optimization patch, will submit it separately.
* Update commit message adding explicit mention that AMD PML follows VMX behavior
  (Kai Huang)
* Updated SNP erratum comment to include PML buffer alongside VMCB, VMSA, and
  AVIC pages. (Kai Huang)

RFC: https://lore.kernel.org/kvm/20250825152009.3512-1-nikunj@amd.com/

Kai Huang (1):
  KVM: x86: Move nested CPU dirty logging logic to common code

Nikunj A Dadhania (6):
  KVM: x86: Carve out PML flush routine
  KVM: x86: Move PML page to common vcpu arch structure
  KVM: x86: Move enable_pml variable to common x86 code
  x86/cpufeatures: Add Page modification logging
  KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
  KVM: SVM: Add Page modification logging support

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  6 ++-
 arch/x86/include/asm/svm.h         | 12 +++--
 arch/x86/include/uapi/asm/svm.h    |  2 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/kvm_cache_regs.h      |  7 +++
 arch/x86/kvm/svm/nested.c          |  9 +++-
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/kvm/svm/svm.c             | 84 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |  2 +
 arch/x86/kvm/vmx/main.c            |  4 +-
 arch/x86/kvm/vmx/nested.c          |  5 --
 arch/x86/kvm/vmx/vmx.c             | 72 ++++++-------------------
 arch/x86/kvm/vmx/vmx.h             | 10 +---
 arch/x86/kvm/vmx/x86_ops.h         |  2 +-
 arch/x86/kvm/x86.c                 | 56 +++++++++++++++++++-
 arch/x86/kvm/x86.h                 |  8 +++
 17 files changed, 201 insertions(+), 82 deletions(-)


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.48.1


