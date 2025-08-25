Return-Path: <kvm+bounces-55629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55831B34599
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6490B2A1397
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B3129D05;
	Mon, 25 Aug 2025 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QJTkbWI9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E7279789
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135231; cv=fail; b=AGKN+hyCix1CMjCzAA0+Dm8daRwBCrvr1NOxpdgLPP2AtZIr2oQVw6jgmv+HjL5/w4EC9S3hqzLWMXkodgPXpN6t06K+iHU0jOQk7W9NYxeyxAp0qicS41JerTutkA7moX7mIpzJyRSdT/+sqT5dv6/JtsjMx3XEOtxhSWdm1f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135231; c=relaxed/simple;
	bh=cC82ZAHSGZDNXYbZMaO414QbNBddudGEbglAbdIeNxk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uFvG+IazZOpQTWoofpge7nXXC/SmeC/5Pcb/euWpJCkT6I1mcFWlCEncX2LztD+chu3uNB3iRIs7qz+zIoMTe1LWGKWZrGLgPERqAuDSdVOuYUrZiGVGUbdgtxbO9idIvqwrBCxu5MmQ8bBKw4oMFMPAYOsvhnuU2M3mRQaG3HQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QJTkbWI9; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p+Q/SA9NzH/fGTNTGwPc5OehjILPZR1OuZ+81a4MEGHzUoFQCgEeHi3UqgItAQYgXlGbhZ014VpNOwrZuxjlVoxQo7ub3MAtQKHYawie37ZK50IFnCEh6cH0CyqmqLPQHWk4VFT3thnGDIluZr5HemAoOxvOf11Bnl3UBBSDcJ7YjT5/ZQl+HJKMaLHzIE50cBwRzvTSsDL62b1Trm20ICDZvdNOa7pTCPBMx+X0tp35byNoBlCLDYVYbvWgVBHXF4mRqFIViSbYCmQG63lZj78KE4ZkG+wIxUYQ+nlXqzc9dhGbbPMaVcdiZ3hBhfI0H7mSEgDyZVdu05NsouSU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1L9fgcbUMfJic3JvT9uEYecZKnOo4f/uAzBHETvrV9A=;
 b=Enr99x+mPvP66GGQe3mkQiSGSOjuo8iO1EXNKVdBjbA6WYg8mvbZP/O1xJUQmH0mKt7Re96FFo944p6X7SYvdBj6xKv6a6ByJ4ScwOXsG20k3A+K11CRtA9RSeVL3/V9amPICVdPtnRvhTqQJy0k+mpe2M4MPqo9chHlHTRdtuc7AmHbgyMF+SBoTVab8eB9XjyW7+BNPZ+xgl2aPyMDgR+P8REoISdV/qvwZ6nXM1hTkptiUf0TENLk1sxzZoA7mlnYauKCC5ZXCjLOn8uMEctT16sGKalgS5yPZz+VSyEMrcuBmZYR/s/yoWgNzL786qh/BZVV0XrPTBnju0ojVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1L9fgcbUMfJic3JvT9uEYecZKnOo4f/uAzBHETvrV9A=;
 b=QJTkbWI94Ohck0crsbVtIsyxXH/uHZen4YBvOxOuPyKStijoOOyLh5qNPXUpMDAt0NnfSJnOScoMMbNZRveGk1b0BU9b2xbaa2e2fFtBfNYE2lOi7F3fJqbWsvFchTCyPNX4wi0cB5VZaYtpunDSZLXQGHcQ47R2r2P7DmVVDxs=
Received: from BN9PR03CA0350.namprd03.prod.outlook.com (2603:10b6:408:f6::25)
 by DS2PR12MB9613.namprd12.prod.outlook.com (2603:10b6:8:276::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 15:20:25 +0000
Received: from BN3PEPF0000B06E.namprd21.prod.outlook.com
 (2603:10b6:408:f6:cafe::c5) by BN9PR03CA0350.outlook.office365.com
 (2603:10b6:408:f6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 15:20:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06E.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 15:20:25 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 10:20:22 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>
Subject: [RFC PATCH 0/4] KVM: SVM: Add Page Modification Logging (PML) support
Date: Mon, 25 Aug 2025 15:20:05 +0000
Message-ID: <20250825152009.3512-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06E:EE_|DS2PR12MB9613:EE_
X-MS-Office365-Filtering-Correlation-Id: e004e803-fec7-401f-92c2-08dde3eaeaa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3dgSzMibDvyOs2WIWZj/gHNjHJQZl//5SBRJfxV09eBG7cLGuCIhU5vvLYn9?=
 =?us-ascii?Q?GpIObpPH4yeDyNxQrTaLPvgAHtOPDaj5YkiBZJ3gdFKwm+Qh2kHHzkGn3z6f?=
 =?us-ascii?Q?y/C0KFaZ1hjOs90Wsyjf3U1Wi9Nfnzr6dazzicdAQe/sejCOLvRDX90zXwYy?=
 =?us-ascii?Q?I7pHb+vICbZz+eq/YZhYTUaSo7KwgEsXPUF0viNlCbkW87+VU8mRP+uNPvHZ?=
 =?us-ascii?Q?1DVz8M/e4X9xqJnHrGyV+ukbe2aIkmU2cry3+raPRfR58SDO3Z4azF6fTOxc?=
 =?us-ascii?Q?N24kKwJcHh6mW1e3xnwOwHy0QVM0OfjLMq2djnHKkR4YKC3gtkWfHupIJefW?=
 =?us-ascii?Q?5GD6L8ormyqLORIORfXwfSIm5yiSRFmV0lWOu7dPj1ZVnRi6fvePQN14ILoH?=
 =?us-ascii?Q?AkD+beJ1AdfjsXtpNF6iLeoYTd2Ha/G+j8nFSyxhG9FFLH5CaYipxBPc3mTq?=
 =?us-ascii?Q?KwlLV5/24na7sA8pDo1TSFvJOpVyOs/APr03Jw/I1zBcW8JrWlf0XWPO6C7a?=
 =?us-ascii?Q?AX7lMJgjiO4zxb28qGiwI1S8z540JpEtHpGHZfwgOHszxcDh015Jn1eA13+0?=
 =?us-ascii?Q?JS03I/2f3D5gGjjMChvLulzROFaqgcBaEdjmlR8qBprOoz6QnT9ngp2o6zE7?=
 =?us-ascii?Q?mE1+R+gVUUhK3r6VAVYiDQ6VLcVh2XaDv1naauR0jwSsk7pzvyz8DIY2m0cu?=
 =?us-ascii?Q?zjo/A6rYJsdfMpLC4uezyYC/Agp0xVcRiBindLgYjZInw9B5fsy2wzSDrSrA?=
 =?us-ascii?Q?M31KUzhFG9RDYRJIn4iq6cWd2V+tmQ/50KvbcmhmBaXiAezp8e4qINAe5Sik?=
 =?us-ascii?Q?bfRNEg4btcVk3VXuXoTHtAPtnMyDPwPmziJhiT0yzdoLWT+/H5V7RsCPL8At?=
 =?us-ascii?Q?pcP0InGAq4rxhYcaIoYJNV/+nKRI4HbtwY2IiUHcTRQBqQpEWZoeeqR194hv?=
 =?us-ascii?Q?O61nmYEWYn7NvbjHeIZrzBxKH4sOsgjaI/mR5mTKysN2sO4DUG6s7xrqg7mv?=
 =?us-ascii?Q?uPv71Khc07x56GxSyN0p/g7+WRhYn9zTR0C0svFhKX5zut49i36iL7BNlvJv?=
 =?us-ascii?Q?7WDgyZAvjEQjFvAB1V7oHt65ONBwHQ89LsfuysWKpluOYm5eZgWrjGlwC0SE?=
 =?us-ascii?Q?y+UAgq2Wka4de9xQcyNHfYVCTJuWxUrMMZ0BIWuRi2LNXT+g0nb4xg0f76PF?=
 =?us-ascii?Q?//2rxjkRvSfKcp5lEqYPD8Inu+eU81/1dgiGss3XrLvYR4Sw49KHYO4anOXz?=
 =?us-ascii?Q?WrpMzaTP6o1TaNpsd1nGnlBziNEDl8eJ4/tawl+yCsDFPOqA8qzN4Jr/bV+A?=
 =?us-ascii?Q?sBObEolE5Y+7mxsiX7Hg5LnLgWJIoUx7cx/AMHDEoUrePGHFkTsDWxyCoN2P?=
 =?us-ascii?Q?GSxBv3lZwmX/AaHU0hLVpAATTAvakx4EjoMr1Z9l8CCe76GlAThjiaZFmqcy?=
 =?us-ascii?Q?JT8/oOfpX61TydHONgI4WbstrbxK0sGqs9zS3Nt+2fHYMjv6RL2qMWw2+cvu?=
 =?us-ascii?Q?l6VatycSUdFrkfk2ZeOtE+hHijsGuwfBDF4p?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:20:25.4887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e004e803-fec7-401f-92c2-08dde3eaeaa9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9613

This series implements Page Modification Logging (PML) for guests, bringing
hardware-assisted dirty logging support. PML is designed to track guest
modified memory pages. PML enables the hypervisor to identify which pages in a
guest's memory have been modified since the last checkpoint or during live
migration.

The PML feature uses two new VMCB fields (PML_ADDR and PML_INDEX) and
generates a VMEXIT when the 4KB log buffer becomes full.

Patch breakdown:
1. Refactor existing VMX PML code to be shared between VMX and SVM
2. Skip SNP-safe alloc when HvInUseWrAllowed is available
3. Add AMD SVM PML CPUID
4. Implement SVM PML support using the shared infrastructure

The feature is enabled by default when hardware support is detected and
can be disabled via the 'pml' module parameter.


Nikunj A Dadhania (4):
  KVM: x86: Carve out PML flush routine
  KVM: SEV: Skip SNP-safe allocation when HvInUseWrAllowed is supported
  x86/cpufeatures: Add Page modification logging
  KVM: SVM: Add Page modification logging support

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +-
 arch/x86/include/uapi/asm/svm.h    |  2 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/svm/sev.c             |  3 +-
 arch/x86/kvm/svm/svm.c             | 99 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |  4 ++
 arch/x86/kvm/vmx/vmx.c             | 26 +-------
 arch/x86/kvm/vmx/vmx.h             |  5 --
 arch/x86/kvm/x86.c                 | 31 ++++++++++
 arch/x86/kvm/x86.h                 |  7 +++
 11 files changed, 151 insertions(+), 34 deletions(-)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
--
2.43.0


