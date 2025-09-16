Return-Path: <kvm+bounces-57789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D52B5A3F0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADB3A1C00E2F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8261E2E7F03;
	Tue, 16 Sep 2025 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4G8W90nA"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AD231BC99;
	Tue, 16 Sep 2025 21:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058146; cv=fail; b=VXSLxSBJoqKoypr5Amf5dfklWdGx0naWYxM5GecB8Tj/ytbC8B1bSfQ43d2q0Jc3qSlpi+PPM0Xd+wYMx9GN2GMSxICu62IKMXSw4gXNRHa98myOwfq4ZopzZket3A85B4wY34O4eoZfBJkjhhiSnBPbxDeGtMgQY3t4WxQNyQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058146; c=relaxed/simple;
	bh=usKsUYjR6/DrWhLHWZWS8Ds+4+H+vAeJGPa7bv5D9KA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PfI9lRoQYQNemGUWrV96gp0Glr9rzz2GIAPtutYjl4BbAjx/TZ8EDzMfEeXjnvEL1g9eEjc5pYN+PCPdMpR6mwlNT7VDSCUCgg35/9xO9cZI4x9zvMTYuFXjUiZ752RAe7Hev276v9Ze7sW8AOdZNdYf3piodCoalu+Iietd06Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4G8W90nA; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hC1WcsB1zhrSa2na/JKxR42h7J96Y7k4G4WIYgACyX5nkkS3bKl/aJR8dGVpofoBpECUz7d/n/O93FFyO4SeHSKBWJLMU8uYjJ2i8HhKgCkW5d962yBJMpX8A/L/Gpad32XxW/9XRHFNKGVkaIBPQ1Jr3Lwgq7EzCt42s0EoLhV+CbN/i6Rkm3rlHmZ9M5NHOe7m7FdMQc6++KPttKMHrSP7/JPcd1tiNErP7xaNf4XWRgA5ns4C+1ZUHPQnX34wdI/tigfbYqU98P1M9U3NVY+GFWPAvcEdS0FXSaca3QjVONPLYRckOG/Q9Sohe3CBNwElHrJN0gm0HLiU2J3JAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHxy7nPYdbTnXWL7wcAbcXvbSCUOYgfXOWWUKaPzEYU=;
 b=n0T+MT1eOdV+JRcyEaMSlrCRlEV17s0XBblKBZxHOgD8SpTyrEP4DPrSgN+a7jJDD5oTy3F3PzAh0s9wQ41QRmeq4+2rZYkhdVKo6TuGgC2pVdqcfkqEJpDR7A+58NnC8a4ffUM9ow5s9peJws0oXBDhZodOHZBHBebyCFOlD4Y6FRMu5Ws9YTE422oHRWd6rhpX5C7bR+OJUm00r/2fxqM1kqf1VgNfQK14HdTXOBeunTrdLP7wOEc+6uZSMFkKyfdeChCKBUP55lgwObn5wS5pUwNpQVVw9uBjRHp9vKiqNHwF8xJlSUOyU0qEoUu0frsWfiaawtAdz+QE1eQcGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHxy7nPYdbTnXWL7wcAbcXvbSCUOYgfXOWWUKaPzEYU=;
 b=4G8W90nAAx+oNMg4J+fPOFuKO2Gzr59LaP35e1gE3nougbScTalsvnb1561kTglp3FsMsWFNYgVW4/5cfm7Sl7puk0QoAsyfEt9DdlXsw2717ZYmbxSwyeSfNaC8jlScSp3pmssnAMuVg9zoavlXtHLmlqFLH3RdQOkh700nY+o=
Received: from SA9PR13CA0078.namprd13.prod.outlook.com (2603:10b6:806:23::23)
 by MN2PR12MB4422.namprd12.prod.outlook.com (2603:10b6:208:265::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 21:29:01 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:806:23:cafe::8b) by SA9PR13CA0078.outlook.office365.com
 (2603:10b6:806:23::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.10 via Frontend Transport; Tue,
 16 Sep 2025 21:29:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 21:29:00 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 14:28:58 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v6 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Tue, 16 Sep 2025 21:28:49 +0000
Message-ID: <cover.1758057691.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|MN2PR12MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: 91186b13-7360-41e5-ab9d-08ddf5680d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?niFTSe7tzwSI2AQ5PrfarvdpennUtjNGs4Ve+z/3f6TBD42cw+Zp3DlSVSBL?=
 =?us-ascii?Q?WZdBiNm4Cp7h8Q6T6jODHDKU5RNdV+t9zhhproAj6AXY3poPNFMznccZawoh?=
 =?us-ascii?Q?g03lUx3AVeudU7jGrXXm37xxSjG7WPPzkm4IFSuj5VlRPuzznr97c4jaFdRc?=
 =?us-ascii?Q?28e+IizAyugahpD4G4zLUjQVK3ZtK66rECqPt+awMCjxrj+m/ztIdrG6XKA3?=
 =?us-ascii?Q?RYXBJudT7M61IpJmIQzOMAdoaX5nUoIV1iahhoLMIQBv71zPHk78gLHWZ9y7?=
 =?us-ascii?Q?XGRq8bncxzMaEyncWFZkaaRBTU8kKNaHftE6m3e14FD27kqXYCUb6WG5dlc4?=
 =?us-ascii?Q?7QWQT+YZX82QDtnJCxjvsMvj0osSfqc3ZqOCZwBedBcOtMC2DLPwMBt4ljBY?=
 =?us-ascii?Q?mQLMZWQPTNtwMvrKTTyxRo2qkW5EPHAZR4QqP1Q2la6YogYy52RR8SmHx6fN?=
 =?us-ascii?Q?AKQVMSSlyQRlPGfAHDbOJTkJDFYbWwQPO9ycB5pU1zi18fTcw+tbTLxMTB9g?=
 =?us-ascii?Q?DmDx77aDFN7u2OYzyBDAvDXVicApJ3Q+LmdB8FGETb0b3oBVUy1QJ+NszuEu?=
 =?us-ascii?Q?h87yeR7TNL9rO8TQdx5+6uD+4xN96Ffy4kko16RKd/qRwtsxUcBLchwdgiDr?=
 =?us-ascii?Q?k0/Lmnc1PRoEJgOi+aTatKw00FOuZVnTv5/mpaqrEtzrBtqb6B2R0C5X8ADv?=
 =?us-ascii?Q?vmo28Uk6myYiMgRZEzjIba0/8qEuWT9QQPnSsiKjKMPrR9/EI6NIPLTaCKD1?=
 =?us-ascii?Q?/9JEsQilVQ7ro8YCOG/Y/LSgXioPfqHV+wR7AFbEtraSumWS6V1F2rrZtRNM?=
 =?us-ascii?Q?5eVqIoP9BJxur0QnYcWbQaZEOBrN2gs7aRw+255GWE9SUw/nbzryx8KLVDnZ?=
 =?us-ascii?Q?PGOcVGQRSgbs4Zx3AIhf6oWwB3sjI8nKuomN8KEHsnaIpEybnFrgIKTZtCge?=
 =?us-ascii?Q?bkI2+gDoQh43dXZ/GO5Onq/Snjeh/aKxFj6fxCiNIS8sEbqher5A7R1q8GzM?=
 =?us-ascii?Q?yUg6HpqhXbf28hZCT1jsXQ2egDBSFK89nYUpdmsUsu+OyRKfyoLEBi8LEjIh?=
 =?us-ascii?Q?YLqBdxog1cAdJOzkWs4y0kPobnmav7vPU4C/fp5LRWo7nRB59+pN0jD1NzW6?=
 =?us-ascii?Q?hhcvWZPyWJlBX7OlSEEgX4+6lJd3QQB6v0iIw3DRfearf1Rgt63+pOcg6RjF?=
 =?us-ascii?Q?apL1R4q9+CrFx/Ux247P736kP4q0oFbjs7wFPrUJ5oSnhPxxQJhkCQ/yMKqX?=
 =?us-ascii?Q?j7L47ywEomDBFMq3D8WIyQ4rLP8QVaV+BIe3Dswp5N8X+cKxlRG6TK30d0Xp?=
 =?us-ascii?Q?gllNVTHEIvj9DAe4eJY5NLh+kWgLjV1ITMGX8Z4aq7kyvkxL11p0Rqy4ke0R?=
 =?us-ascii?Q?BM5nwEPGUWF8Ow7l1u2DDUWGLX9wTPlUpRz0od2WJSucT8u5WNzONWfhVj0j?=
 =?us-ascii?Q?KJNB9nvpWs1SdFPK01XzAekBRo45dXjCne+HVe4aTk8vM4a1IfXvhzwYQ5MG?=
 =?us-ascii?Q?wsBL25Ca+R/UbWH/R73Ea3RErZD0Gz22NRibE1st6pm+KvixBRr3XkOWzA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 21:29:00.4586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91186b13-7360-41e5-ab9d-08ddf5680d50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4422

From: Ashish Kalra <ashish.kalra@amd.com>

AMD Seamless Firmware Servicing (SFS) is a secure method to allow
non-persistent updates to running firmware and settings without
requiring BIOS reflash and/or system reset.

SFS does not address anything that runs on the x86 processors and
it can be used to update ASP firmware, modules, register settings
and update firmware for other microprocessors like TMPM, etc.

SFS driver support adds ioctl support to communicate the SFS
commands to the ASP/PSP by using the TEE mailbox interface.

The Seamless Firmware Servicing (SFS) driver is added as a
PSP sub-device.

Includes pre-patch to add new generic SEV API interface to allocate/free
hypervisor fixed pages which abstracts hypervisor fixed page allocation
and free for PSP sub devices. The API internally uses SNP_INIT_EX to
transition pages to HV-Fixed page state.

For detailed information, please look at the SFS specifications:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

v6:
- Rebase on top of the tip/master branch.

v5:
- Print pathname for firmware_request_nowarn() failure message.
- Changed all dev_warn() to dev_warn_ratelimited() for all ioctl
  error mesages.
- Add Reviewed-by's for all patches.

v4:
- Ensure that sev_cmd_mutex is acquired before the snp_initialized check
  in snp_alloc_hv_fixed_pages().
- Restore memory attributes back to the default "write-back" type in
  sfs_dev_destroy() and cleanup path for the error handling in
  sfs_dev_init().

v3:
- As not dumping the RMP entry is the rare case, crafting the APIs to
reflect that, i.e. make snp_leak_pages() a wrapper for the common case
to allow existing users to continue to dump RMP entries by calling
new __snp_leak_pages() API with dump_rmp bool parameter set to true.
The new parameter also adds support to continue adding pages to the
snp_leaked_pages_list but not issue dump_rmpentry().
- Fix kernel test robot build warning for uninitialized "ret" variable.

v2:
- Change API interface from adding/removing HV_Fixed pages to
  allocate/free HV_Fixed pages.
- Move to guard() for all mutexes/spinlocks.
- Handle case of SFS capability bit being set on multiple PSPs, add
  protection based on sev_dev_init() and sev_misc_init().
- Add new sfs_command structure and use it for programming both the
  GetFirmareVersions and UpdatePackage command.
- Use sfs_user_get_fw_versions and sfs_user_update_package structures
  for copy_to_/copy_from_user for the iotcls.
- Fix payload_path buffer size to prevent buffer overrun/stack
  corruption issues and also sanitize user provided payload_name to
  ensure it is null-terminated and use snprintf() to setup payload_path.
- Add new quiet parameter to snp_leak_pages() API and additionally change 
  all existing users of this API to pass quiet=false parameter
  maintaining current behavior.
- Remove mutex_init() and mutex_destroy() calls for statically declared
  mutex.
- Fix comments and commit logs.

Ashish Kalra (3):
  x86/sev: Add new dump_rmp parameter to snp_leak_pages() API
  crypto: ccp - Add new HV-Fixed page allocation/free API.
  crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver

 arch/x86/include/asm/sev.h          |   7 +-
 arch/x86/virt/svm/sev.c             |   7 +-
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        | 182 ++++++++++++++++
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 311 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 11 files changed, 671 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1


