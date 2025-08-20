Return-Path: <kvm+bounces-55214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C87B2E810
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71E19682EC5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31EE2848B6;
	Wed, 20 Aug 2025 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YfFjkpar"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995C221739;
	Wed, 20 Aug 2025 22:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755728331; cv=fail; b=WlFgQ984WwPI4kpk8+oXf8LYovrGXcgrOnVAQViK7nRXGXy8bhXu48Kfx1Wbm9rJ3BRwxLxMRs7lqBiNjAhhk7CXBr6aAJGQv9naAi7c2qFEfD9efYquEJIkDg7xtSJrAe6bBLj9hTnAitaCkJzqZZXfA43WH9PAXail8JiE6M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755728331; c=relaxed/simple;
	bh=7vHOO58qSmws8r2TTKJJH04xorvXpOFNvseEvGaO5rA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MKMKp+J13C3fiurxtDlBC8V1HhjljndaxlYeu4JKvvigxjuhweLf0LNUF0m5aAly5ysX5z6YqcPr2AcDBy/X7J65YqPwfzr0SiOss8Y3F0UN7rdZZpDhHNdQbYqdR/3BGw/MVBJ3/yavta6fBMv03b+jIjxMnm6BRvRZDT3AHVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YfFjkpar; arc=fail smtp.client-ip=40.107.101.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWWCWuQED71Fjl0TZnJoO7H5KiPrsYVnxFbILeAD5BOr4WyvxksX7b89vmDutnlEWAD6XYhZp70vQk9Ker5oE7Cyg20sZYejcHZL9Qo2LzkK2u/QeYOimkvYWWYJWNASLBADCqMKRo2EDAoDevNRvAN62kAKIlds2xmOOrhxTeG2idkQtE1IaA7plvFbXPLr17PrYkA/rNoTlvnUkT/jyCAa5sxMI/jwtrgbUWqag00otCe+0A3B/F3zxwkHW0nLqTlFu4ccAv/KlyIk+HvhlFByhFtXo2jkk9SMVWQwqiqRQyyKpnTt241Xw8mxmVlmGc1ULWdyZOXsBbhp5hlCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WE5zOC9V9JG4XOtRKqRfOmmjS1OyQb93xjBqtMsOfdk=;
 b=ss1JunQmKgFlF/dEYD9HevhN4wOM/slfRDLsIH4eV8XFcGZ6qtHnYg2n4yM0eclsF+tkYxFKhNqIx9VEBHZj/Igzx9L57GIbPstoq6j4/mDLoXaeoH/esnvaMk5He14RSxbyYhMFp+RYOkp9F6MUOtg0s0OuigiCmFtYJEeHCQg7SB2bECW8KkRtTtcO3Z+hEm8z3EIvcGK75lASaNxFpS2qG/bU2C7XWSlAgn8XVmMW2cnrGEwNKkjfNeyynD7jPDVqGvpRkNr4GRRegLYmqocXNckzDSV3Xad6Im3utAn7ylRGIsPmqcvBnX/fF/3+IMCTi87jLaKsUVrAP9OWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE5zOC9V9JG4XOtRKqRfOmmjS1OyQb93xjBqtMsOfdk=;
 b=YfFjkparpA2MB2BL2PQRp73ZmLY4iFyk95NskmkrwYlfM0ruDq4s0UTfHROOx0owKk7gdnFpP82y8OtVJzBoiEjcEnHiNiqCd8NLIKo30anO69O7PG04iSvhAgOnaQ4b1D482Lx9q3n4vp/wd9P0cEm2NF+B1+oMt6DNeIfAgmc=
Received: from SJ0PR13CA0184.namprd13.prod.outlook.com (2603:10b6:a03:2c3::9)
 by SA1PR12MB7412.namprd12.prod.outlook.com (2603:10b6:806:2b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 22:18:46 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::1) by SJ0PR13CA0184.outlook.office365.com
 (2603:10b6:a03:2c3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.5 via Frontend Transport; Wed,
 20 Aug 2025 22:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 22:18:45 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 17:18:44 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v3 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Wed, 20 Aug 2025 22:17:13 +0000
Message-ID: <cover.1755727173.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|SA1PR12MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: c34341ec-a66e-4fd4-2158-08dde03787b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5dok+FfFt3CvZuqGFEMSmdqjibqXVvOBoRS9NAdNhBkC0c9PSX6j1CWkiCW9?=
 =?us-ascii?Q?m9uxFVV7F8s5Gov4/2dwXF5g2dSN+1UgrxQAqH6TZcMrve24+ZxOR5MNyfWn?=
 =?us-ascii?Q?9j23ZyaF9flwDLxCuGh5u6A5rUq5vIUO2nCgXpqkQvRtw5iAz2XOOEUwD77t?=
 =?us-ascii?Q?f/vVAHwP+75LOciDD+Y637iIs7v6rzPSG+zwm8ainIONMk1mM0KGX9J27Bfr?=
 =?us-ascii?Q?Mfa5/hmjlZOhIaNWLEm4TtdWSf96931EvvQLBaDX7BC4mFfrfOK4HZKqmnOe?=
 =?us-ascii?Q?ACQmOPyTnkWxirLCPjqTrX6ubMGzCChQSOKArnvl3KOROFj+bftGsRdnZ+eZ?=
 =?us-ascii?Q?NETpBjDDfPztNadytB90/EtVYwQnlzqkCF1o2DujUhuUkkyhr/N2Rd/AoZlS?=
 =?us-ascii?Q?lux3+1p+IcUTJEqBz7surWKecCOvzRaYkq4YbpRXorMw41AV8vTSCEIjLl+w?=
 =?us-ascii?Q?lFbjh7/TIIzHQh2aGNJKc5GuhpA285mDHWi+kCYS26tYeikD9fUAx0o2S9f2?=
 =?us-ascii?Q?Y1p0krs/TqaZRNkp7ZSuIVMFKub8BMzEu0MZHwq39UDwN7Xyqh7XAgb3asf+?=
 =?us-ascii?Q?/iOPORGJo/3B+FJqsR5LWt5VOLajzmuQ6ATuBiE6vxNTpNYiBPi6YIUyv+cC?=
 =?us-ascii?Q?YQ0nsO5M89sQ7Rmhv2SW2UV7v4EKNkKzsZ2gZQnaWG0oVLAKzMBxHmF3xfJb?=
 =?us-ascii?Q?RxfrgKYC6sYEpBxoLm0SRtZ5eRKTPIcgA2LYYRuKiNZ8lDToq8X8YMvDBTp5?=
 =?us-ascii?Q?AmeWcmvhzXBSgFsXztXwA6HqU0Ie9O9nSR755VM2Hov6gELrI8kByZ22bRNk?=
 =?us-ascii?Q?nQiU9BWoRfXPWp4aek+442prnS/j3XzFuIxovzx6yS8QMpPV3ILGLUsn4Ylr?=
 =?us-ascii?Q?WlkZSFJj1+/AGpJa7FGNFNQxk09fiPKUFFGKHHJ8dtXgoVf4ARTeC6b6OwKO?=
 =?us-ascii?Q?qdopEZqMn1ckwZOM4YJ0a6i7cMz1te7zHg3XBr2x+zzixD6iGbd1ZFFFhMpi?=
 =?us-ascii?Q?YIYNBq6t9YvDTRYdZhSRM6hsDkD3HGG601pTosUFLF8dRenWAImUREiLaoPk?=
 =?us-ascii?Q?HNT6ZiZBWyv7vpTRtJk+KHGyGHff89vFbSxPaPcQUJYuMqx/wvRZykI8HVr7?=
 =?us-ascii?Q?WSt75y0mTJ9XRs5ytBD9Wz7DzNeme9y5hQXw8TxhhkpQCB9eruqYJe1BIQEI?=
 =?us-ascii?Q?Is6jHop4mwXnVYU2SZJ2Zob1fT+/3GuRPqSQ7FlqQuft0TY3X9LPjCeqxVA0?=
 =?us-ascii?Q?jmDFdLdX278I7Ylwur4l1rJ38J/6HtEvlKUU9UjdPIIDHKtHUtcevMIO5ToY?=
 =?us-ascii?Q?/yLBl/RUyBUoCexrkS0fu0ZPJTr0Lpbiy1bkQwU/XgnU6Ko9X4REDArSKqrm?=
 =?us-ascii?Q?njMbK9amg+p3MUWNNQhkk81mIi+0x8FrBFHWZzHfp/QeZsfPbTN9V/J4iNiQ?=
 =?us-ascii?Q?MeC5DKOFUbEtrG/woc22NwJ4MhC40ws9ESKNfVHVJKRgfsnzDdsotPOA4E8t?=
 =?us-ascii?Q?fPVEOamX197f9tvBtL45R7RXAoyDUn1Iv4KGI2J2h9KduyHud3InPG05EA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 22:18:45.9879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c34341ec-a66e-4fd4-2158-08dde03787b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7412

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

 arch/x86/include/asm/sev.h          |   8 +-
 arch/x86/virt/svm/sev.c             |   7 +-
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        | 182 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 11 files changed, 663 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1


