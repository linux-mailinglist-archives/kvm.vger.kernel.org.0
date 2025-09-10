Return-Path: <kvm+bounces-57260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD0AB5244C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 00:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69223A06C23
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9867630F932;
	Wed, 10 Sep 2025 22:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j1FylNE+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044BF3FE7;
	Wed, 10 Sep 2025 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757544926; cv=fail; b=gNyA1sz19HJ3C7UeJ/YELy+HPw5md7WakElZiTCs1hw/SIbolngcd7gTduq1++WqDlp12RleXlGVLTGUbe+M3u10zu+JlfYVpig4e1ThaM/DOF9Qa2NLuLhk10nuSUaQ5KerSLX2QpmlzjqoBmRwVQY/Gkv/ZVs2DeAIu58VX2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757544926; c=relaxed/simple;
	bh=ChGepcv2I0XB3nZSI2DYHYPh4Lof3I/9hpTs+0qGhLk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N7Yc3L2RdVSPIdiCioRK+S3DdyKa2ATJ3xQhwb8JKDFG4HikFm61vOZDT9yQkzvZK3NByNfhwmnSR4RqTkt3X4equbIqaTEl7xSap24tXGw3ol0bGOli/2481b3jMWJGwoKPhwnNUDJAEvhbYVqAknEHCmYHxduR/3YOd0m+9Rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j1FylNE+; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAFelUzUEXPOY0bff3cQqnhTyCZkKkvaJGNRGnp3aFerXCBnrMdte/fqwDWRiUC9v1jvd1LXJOrTJbD81+UIbLg0iaV8nr+do/BB2V72w7q1fp0/zWq68AcIYT5NybL908O45fpH7qo7Mo5dDu9s5cr/hyeVi5j8PX+mgkKTT7p0rKHIXM9AeMrGq0d/T22rT4yqPscwVqkc77NEUg/O0yfMAMLjlW6ALCiqoPb0fX0pomodi5JXJSFAfFXf/6i6VnfH4ohux0D/z5ee9hfDHs2g8ANWOccKwejkrb/VWp89zvFuEYjXhc+9UrXLzDMyzRdukYZe7khJeH2u5DkYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzsU+gCHtaN8tXPhzHui5dfHld3JTrYn+bS620vEUog=;
 b=puQpxdHH37lNbHZdgZs+twZPVPB9h0acvpswNu1urd9C4aZR/OHURe4x48tIWUHzDCcaDnoGSCTelH6l9i2ompCRdyTfD2z8GuSXKU0ofHWzgW29CbS6+Lapl/cCDxWP7oHEbAsHDDNkso/C5zewwCuXjSdhFxH8iWYC9FKkx1SZendDwAMy1yeyIOfewyF6wE8nPDFlvu/BLhu0524fVzDMbDlWJ2onAjj+ADSRo/AcWdZ8n6SqlYQWp0o6otZ516CsbKkjqn9CCd+ZesYpMjE9eykNHbOTc2I7oIrOx+nvL/6oBzrv75bpWI+LYsLnQNQRyHMjkfv/LQ7skpqm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzsU+gCHtaN8tXPhzHui5dfHld3JTrYn+bS620vEUog=;
 b=j1FylNE+G1l4g70I3kTteGWy1iNICsB960xPaWQcW955E+o93SMrKT5TvIqhfIspwxr8aHrbWi4OoR5Wcqnq+uNQh/bdAk7TuluOfjKkbZdKewBIcVNxm5QWYjbHP/Gn8Yq1FsNJqrw4cQPpMEdOoiLErIwG5/Iu7HUXTHlOEdE=
Received: from BN9PR03CA0319.namprd03.prod.outlook.com (2603:10b6:408:112::24)
 by SJ2PR12MB8926.namprd12.prod.outlook.com (2603:10b6:a03:53b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 22:55:19 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::f) by BN9PR03CA0319.outlook.office365.com
 (2603:10b6:408:112::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Wed,
 10 Sep 2025 22:55:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 22:55:19 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 15:55:11 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v4 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Wed, 10 Sep 2025 22:55:00 +0000
Message-ID: <cover.1757543774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|SJ2PR12MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2ea7f0-4301-4390-8864-08ddf0bd1d7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kwnbD102yz1MhFAJ0PTjCBDZ7Rav6rTJkstyBEXG8qThpGu3QyXobT1fHK9y?=
 =?us-ascii?Q?04cOz48MxRVUkG6J91hWihRe/17MWlRmjm7rPPEJTNzf7ufGgXRPRIkBsvg0?=
 =?us-ascii?Q?yCsJcd2HIufupzfQtT52dOlkY9v8IRKDjq9woeZ1rhAFJVy0cv5l0fj7alny?=
 =?us-ascii?Q?LmGQc4ntcjvDCsMh9ua1ex6nmPh3zilWzztPlJF5Iya+4Sn6a40tGAsRn62r?=
 =?us-ascii?Q?vpLn+fRDFZQgk7NhHtBt96K727IBsFNJThpDir/X7xXvdYoeO4vu45GjOyWe?=
 =?us-ascii?Q?drnaFfzrkYuuVVnklvu1XdiRpxeANviXxYm01sc5EtiLhaR8urrKi2ZAYyc2?=
 =?us-ascii?Q?lrnFqLA6ArKwlPb7PtwbK2pAGgDuB3bmNV9Zzt22S55h5FMz/THXhU0A7i/u?=
 =?us-ascii?Q?l8LBWIogG6bzeaoa5e0yMHU6i/t0W9aOYKP6xth87GTHkek8+nszZqFhXv5A?=
 =?us-ascii?Q?l4lzzgsJVxBygOLnD7TqNVs6WKuVkqPqEUtQ2svlH350dwiNHMU9fzfZ4nJd?=
 =?us-ascii?Q?DVtU3ph8uYxkmCCb+1FNoBd37VOQoqa54iDTUTaD1x7mGsY4nWRLkBpdYqbx?=
 =?us-ascii?Q?8zk7HePZp82bFCq+7O8c/39Uy0tvNVCjSVYSbtw4QW6FCIdk7YXcnXwMSjTG?=
 =?us-ascii?Q?Ku+Rkg2CTSpLRIwIQLCPcyCdet5kBCZhoaG6YVK0fibkdyEeIpw+NLUR5/oq?=
 =?us-ascii?Q?hOLRGB9XlcNxz/mPyetRmEfGV2AtIOoCJYLFwql5zGWNfY1sZhBAApDpTnfB?=
 =?us-ascii?Q?FhReAQAmvRuNWCM8X6XnCm45ujTeg/2gaG/TALer45J2lHbb6tZr4bQidbyP?=
 =?us-ascii?Q?vEpHggNJGEe2f8AuboSFpFG2UcyDDiWDvSGA7dvnNYCE4mPfVUKwdHpfsGV3?=
 =?us-ascii?Q?DMILTVjjXgetxkFyOAa1xznSFDmyQXnpCNe4uiFornZrL6IBwSdmTfiQfAjF?=
 =?us-ascii?Q?2kwBAeoOY7Uaehui0v8Vs3z4NuNTWLSkE6GiOhrqLAdzA2eVbFZJYbs4hQc/?=
 =?us-ascii?Q?Gb8O+oIh2ijIWOtEAz+NtwwNXq6kRD8ZvdeN4VC6SN7qPyhiRXEuhe3fxcMq?=
 =?us-ascii?Q?v9rvoiAijkjhIio/6G1TJpMFJGUU8doxRowmo28pb93ggnlvCVGyaQWCFcvu?=
 =?us-ascii?Q?dmtagcqzztc/8Icrsn8WaIoMXK5HcxmqT2/+gKd203LakHeVcHKKqO3kEeOO?=
 =?us-ascii?Q?YPTvC81guTDidPHaJ5CbUQ6n2OccgBV3sxv2P36+xxqVtf41SSJD6nT8yz1I?=
 =?us-ascii?Q?hV0uMmzSGE5wqVV5MUKRspS/ClCTnaZUtwFdcvc6aYF/ds8KMqReOWmlMyrL?=
 =?us-ascii?Q?UHJZjhucvwfMYlb/N1bXZmW47NnsBjXAsL2s816b2QDeR9A9jlbkIXMaBqdK?=
 =?us-ascii?Q?uBsSH8LQEHVjAft5DL4SHNUjraVbtMvgYPZ/6ejBSuaihYlE77sPTYFDjHyP?=
 =?us-ascii?Q?KQxxusAgxi7T/FIFrrv1MxtSFGtXQgxawUINZwRezRZC4dTVj4BdtSQAytBA?=
 =?us-ascii?Q?Kg/mC8OA37lXt9ielO6cBWrSPL9m0EFL8uJRvtEgzjoSO1ygcpxuifhWWQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 22:55:19.0166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2ea7f0-4301-4390-8864-08ddf0bd1d7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8926

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

 arch/x86/include/asm/sev.h          |   8 +-
 arch/x86/virt/svm/sev.c             |   7 +-
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        | 182 ++++++++++++++++
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 310 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 11 files changed, 671 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1


