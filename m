Return-Path: <kvm+bounces-58178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDAFB8B04A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69BD11CC4DD9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12FF27B359;
	Fri, 19 Sep 2025 19:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aVbcWJdh"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012058.outbound.protection.outlook.com [52.101.48.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BC6264A77;
	Fri, 19 Sep 2025 19:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308435; cv=fail; b=FWeOiorukT6xIkrSKyp3crgMy8aAhXusrv0gOxMu5Apw1qkrDgzzlwVSuX8SlIZl+Lj9wLoemtvmt7fRtnNSCyzS6Nq042DJpEMYlvyQ7vh5Jw60usiwp93FRuyC/XzCx9AjbjmnCM6o4aiyHfkZqI6Os2mZexy1XzyuWVjN8K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308435; c=relaxed/simple;
	bh=upSg6pwjnP4CS774hzPNOGR7FXO2eEgl6OiAEG7PXlo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ih4GcacCWT1GsMXcSM/jHA5p3eebYg/ha9PM6OnnqR38eCtk+dWp6SpUntxmkr5XSFSiVRlFLfYdAOTAbStwbzc1K5LC+kWUER8zrjyaD+Df2NzY4GpbfTJXtETJRnrnOC+cE3quTQx9IKtGwAhqfzKAwzVXi6/gbvfaHDNio8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aVbcWJdh; arc=fail smtp.client-ip=52.101.48.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3tMP0hxVCT39PDwxo6J4NrMkYXoRQJAIW9TU/SUH38c2rlsFOrLdXxFBrr93cP33wCIwi0VI4aUzdmXUJvXExrJwTcG/9lDQVMRcfuG7GOhMXprD1MVIxpKockWH/Jwq6EPO70hLlT5+00UHhvs8+5/M2AzloLmCiap4rBKLAykya4290eYcj3g5PKoZNhJAsSwhwfhylgBlhZ9dennRyM3FzC7rjNcVpzcEQ1VMP0Q8xXaudrRKeeGLdR+GWTOICDxNtDLCclCJ0vBSTqvItkSn0FKSHKxE0wiGYqLKRCjPGByMaiu3oyB6V6ddF2R/3W03x5mh+sQNectm5CvLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ye/PJIWY5XzKEsOgTVKe4p/MRURmQEjRGz/mlgDzFg=;
 b=PXx2HMwjy/9CvVkeAu9kDGZDpp9Giqm1GS1WWbpLJ2vJaDvjmNymzRmQiOG6c3EtlBJa+XH/eKBoKMRJfXdmbMDt/lVeqpXGWqsE31yoctRQE+pF4+3mjTWzGe7Z81Wo4/lGPHmiKT7ozQu+RUQvWoCl4bXTZ7+6CK0eBF58qN7mu6iD5hi/hwXePuXkf25AExaVPmev+jiqhDX8G7T2f9ReCUBvDnc5Ba7/HPHJ7QBBM9DMG9aCsm5rl+oxqgYcQrRdYcFIAjRhWE65n+1eahSN8Ac3oErdPsrPmNLvvkvL4Dta0034m3hrJipA1F9Tg+7NmP1i6E2TbgcFgPgC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ye/PJIWY5XzKEsOgTVKe4p/MRURmQEjRGz/mlgDzFg=;
 b=aVbcWJdhZw+onQgD8mr8cv9p8OJ8JnW140XNS69vLm7OQSRHKIJ7txL8QJyMPNZleb1R1LJxTFIbaXw2arhtoHsNSiXckR1s87TJ4d54PEbkwi8UvrZ5FJjU4G8KRvyuvmVPV9xYkMuIm+YKVTzd+F+6KiF6XZdQ9oyH592a5GA=
Received: from MW4PR04CA0386.namprd04.prod.outlook.com (2603:10b6:303:81::31)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 19:00:30 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:303:81:cafe::dd) by MW4PR04CA0386.outlook.office365.com
 (2603:10b6:303:81::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.15 via Frontend Transport; Fri,
 19 Sep 2025 19:00:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.0 via Frontend Transport; Fri, 19 Sep 2025 19:00:29 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 12:00:27 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 0/4] SEV-SNP guest policy bit support updates
Date: Fri, 19 Sep 2025 14:00:04 -0500
Message-ID: <cover.1758308408.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: b928cd83-af38-4072-39c5-08ddf7aecd69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pCO+cOA7u+7ecSOuhJNyn43dqNzQv6VMp+Mmzn8dbFfLlf2IgKRj7dnXSNXW?=
 =?us-ascii?Q?/NWjtN0/3uyvzW+yItii3Lx953uoiLFSOI1Ix7RaUQuMPYJtoZDyTRY/AgwL?=
 =?us-ascii?Q?w8N7J41909i1T+LpKiVriBiiB0E5OMmZsnbrXWfXOHieoHQI7YAp8kpWXEJ3?=
 =?us-ascii?Q?zdM+4HOqHYbmR7cfEsHFXgL3/cYGrlAQSWxIQLi74mmBzeej06ZMnQQKR4XN?=
 =?us-ascii?Q?8Aps4r2QE3fafN4srglwJq8tZzWhfUNSmam8hDCO6LHXWA5ZdVWN7YWC4gFq?=
 =?us-ascii?Q?tgbQU0pLhUPSysbqCx6FjeHEc5ibrH82CHNtccBrgItwkuH+4Rvs/mEvBlUN?=
 =?us-ascii?Q?fhZ0m0np/apeImBK5BSBRBVNhODzvKDk2r+1dQb2nRN7VlmwchGibmev99XG?=
 =?us-ascii?Q?FGaZcil08xQqhreLJbpx0pPe00EeEA3RRXrVu0tUn6tP6TpwmZabPh2dZ25A?=
 =?us-ascii?Q?HSZomxnOy0Rha1uqCz4bIae17MlyVhFA7Qx1KIQFro1W8AjYFZRzFL3XuPKK?=
 =?us-ascii?Q?rpNmTw9zm+KLPyq948lSaQaxUKmDskKaXQnru8A+749yxlD2MDPT0rZX1Cy7?=
 =?us-ascii?Q?VNoLIH890OIQGtx5BibC5GoLdD1qH+/Kg1f7vYlxcTJ4Dwcr7llNRcioZiIA?=
 =?us-ascii?Q?7vk0SuLa7knNIdjcfF61YTxe9d/d38tkZZ0vMbNCNC5uPgP/w5EbMBv7T8rw?=
 =?us-ascii?Q?YSbshB23kdUDfUzSjTIVICNDNWmBQl5sqNApSSQvnxmqYdWnapYjjRMdBvdq?=
 =?us-ascii?Q?QTzDZCqRmEHFROI2D25muJ8xBGzxMunmlrhqn1LIyh704Pae8+hVYP0PV9bY?=
 =?us-ascii?Q?/BXrSmDeUn2pROIVPKUfXXYLaP4PziBhyOYTIxpH/kzsHPN0IxW4lJtjsbNg?=
 =?us-ascii?Q?zLVzi21YgIwUTWpnzmUlLiNBMlp7d8Gh/4E3jpbzz0nVBtnPF1ob0xYKgT9B?=
 =?us-ascii?Q?t5A1bPgJvB/PtZniSqfyJB0KHqLJHzzpVrZsRwZ9e14DAa06N7CuJe3001RK?=
 =?us-ascii?Q?IUrhaDcsTej/6lI71GY34DjVCJV96lBfGVD5EabqMoPj0yTK4Z0TvtjsNkLz?=
 =?us-ascii?Q?d182LI9UiHq/By2r8MTLhSMg1VseNTc5XEK6HySnMuRiEWfby+zS8UHXkXU1?=
 =?us-ascii?Q?f9dD7pNQzCmWvSVBzWIWP70qM0z/YddbeCCaeM8hxH2xtESwsha9a00H4yH+?=
 =?us-ascii?Q?giKXsXCP1VnSsP5GXgWlxzo6SvbhsPzwG/tsbrOkqrUf3IfrnbVTIYniW8hK?=
 =?us-ascii?Q?kRFDfe5MYm0OEQVJxc4LogWlYHvuaIILltGmRwJlHUtq1GTe5HIA+udQzRT8?=
 =?us-ascii?Q?pNcBnU/PEj1Uj3JxZdZ1gOZPQNrXqtQcKXiP1NhqBrZclsLGyPUB1SqolgG8?=
 =?us-ascii?Q?nkmJUatGfZJkYVh5ILtEBp7FyufmLnCAQvla/RKQVsvdBZTnGNoU1UW0yo3E?=
 =?us-ascii?Q?xKFE/yGYUBVXKBQ7g8X1RcVAUesQPo+eEehU0IlZBeh7C/Ou0lkqje4dXmwT?=
 =?us-ascii?Q?WN8HFXsIRFUwR2Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:00:29.7731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b928cd83-af38-4072-39c5-08ddf7aecd69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774

This series aims to allow more flexibility in specifying SEV-SNP policy
bits by improving discoverability of supported policy bits from userspace
and enabling support for newer policy bits.

- The first patch adds a new KVM_X86_GRP_SEV attribute group,
  KVM_X86_SNP_POLICY_BITS, that can be used to return the supported
  SEV-SNP policy bits. The initial support for this attribute will return
  the current KVM supported policy bitmask.

- The next 3 patches provide for adding to the known SEV-SNP policy
  bits. Since some policy bits are dependent on specific levels of SEV
  firmware support, the CCP driver is updated to provide an API to return
  the supported policy bits.

  The supported policy bits bitmask used by KVM is generated by taking the
  policy bitmask returned by the CCP driver and ANDing it with the KVM
  supported policy bits. KVM supported policy bits are policy bits that
  do not require any specific implementation support from KVM to allow.

This series has a prereq against the ciphertext hiding patches and so
it is based on the ciphertext branch of the kvm-x86 repo.

The series is based off of:
  https://github.com/kvm-x86/linux.git ciphertext

---

Changes for v2:
  - Marked the KVM supported policy bits as read-only after init.

Tom Lendacky (4):
  KVM: SEV: Publish supported SEV-SNP policy bits
  KVM: SEV: Consolidate the SEV policy bits in a single header file
  crypto: ccp - Add an API to return the supported SEV-SNP policy bits
  KVM: SEV: Add known supported SEV-SNP policy bits

 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 45 ++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |  3 ---
 drivers/crypto/ccp/sev-dev.c    | 37 +++++++++++++++++++++++++++
 include/linux/psp-sev.h         | 39 ++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 20 deletions(-)


base-commit: 6c7c620585c6537dd5dcc75f972b875caf00f773
-- 
2.46.2


