Return-Path: <kvm+bounces-57623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0774FB58698
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B75DA3B4605
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BA82C028E;
	Mon, 15 Sep 2025 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4vvqCsp9"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB514AD2D;
	Mon, 15 Sep 2025 21:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971318; cv=fail; b=HgxmtmQGyP5hCom+4dmXWRkBKPV4CQx1SWV1lsRI8r9y4UV/iNhpE4a5IBBuMHeiyBVzpnyLnTF5kUAi0CUFqwXU9d8CbfUaIM+unI8Y5PNTtUsvRb06qWIlFxH97DCH1WcTOoa3vMFlN8NA/wiNxZoDuUXPBTWM5JjG8V8VErY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971318; c=relaxed/simple;
	bh=YJpWvKxb0J7rbrG/diyp1Tzm637wOba/eh/oEvDZLiA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ew/03uJtSRfbFV3GMf+oLHG3DtHeKKDsmMJltlJMytwGBa6g9I4UuMwR2h7UZQjHpi+lihc44BwhRadhm5InmIfJu5vH4JcWA2Vv+8lJcbUw6QapsqG+uQUfs216KqI1/ixbNRn+P/XwVdO/vQYgkQ+l54G9jms3v+TcU/Nuk/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4vvqCsp9; arc=fail smtp.client-ip=52.101.56.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TNAxFDvEjH9YSd3V/KLUZVdyClz98bJMO6xuCjtPwrI1PYLPSwe0KqoPJofKVeVSMM7TiH52cwxN/E4nrC8bqlPb3F6XnbS2b+G7tY/2ihQ0UopV9bhDrR68aotT+T7iCsasFCdEQyMuOqsRLtz85ktpTiqJJw4FxaeO0TTh2pFARG3Nm3SHZKPkpptbcekbdfU6OR+A8ieSMagZdeYL3W+zkOMm3LbpvB8fHXj4bCwft1Jfe/Nr2aVOIyt/j0YwgTW/2VAe5sZHZatg/RrerDmJh0c02nyFltbDcrhq0NPlgGDREhRmY1XtEIEClJDXKuz9wLhKuP+UZzLJDxQp6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4YqOAxGjf7o+m5IXAxW/gqbgxkcI1qwv5driwqy/kc=;
 b=MzmT5uGqG+lVZaOgOR/fupR616JRHGY6RKBk79Lhm/+0hJ7VVzCogi2kux42fFU8kdfi6NlgSSOq5b+1InrQTW9/lOGjg0jduyyk+PUY6mTXpnfLO0QIZ2IavO8TgRb8G9hk6rLBQfN2xGcD8WnMzsIHwuxmwKkIE72fUsTsRY+Tuyw+luPMyVQFMcgXsElo81y9aqR49vkY4xSNp+qjDklgFE0nOSOP+M4im376wW61OMhiaNTHtmxO+XnN36sD8d9eybxkTHcGkzp77CYcjlSTChkPleYxLvyP2OIP4iA/gNalIVyPgLONG1X/f4m/jxUznKDB1gOpyQUPDHfhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4YqOAxGjf7o+m5IXAxW/gqbgxkcI1qwv5driwqy/kc=;
 b=4vvqCsp9FBxNzXD30OPUWDoHVmIDpX5QdNC/0PANISNsHngYgs/YQZak4lLIff7gizi4ni/w0VRlhWBUrGsbmGKrT8EnR+5rUEleYKPJnQNhCJUdhdJ9EmuI56XBBXAbkFgBW8epr+BA5lv2YGQfBI2doFfpMP+QOFxrpGCkQxQ=
Received: from MN2PR08CA0004.namprd08.prod.outlook.com (2603:10b6:208:239::9)
 by DM4PR12MB7766.namprd12.prod.outlook.com (2603:10b6:8:101::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 21:21:52 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:239:cafe::17) by MN2PR08CA0004.outlook.office365.com
 (2603:10b6:208:239::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 21:21:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 21:21:51 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 14:21:49 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v5 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Mon, 15 Sep 2025 21:21:32 +0000
Message-ID: <cover.1757969371.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|DM4PR12MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aeab85e-34dc-4cea-cd46-08ddf49de361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/J0ikTm9j6Sr8WC9GmwYfY2/VqMwLOiX0o0nhWUPeAr+D1gdJiWfR3bxd5pN?=
 =?us-ascii?Q?WqXu0/pM7Zbt7VH6Y+dQa6Im3jUtgE4Yefea8z/Vd37CbJQiej9xER8kpY8C?=
 =?us-ascii?Q?qdHeZuDscuuGytq/jTyO5tBlhMluINIMDNtmmeGLN2yH0UJ2iqZwCxWE8w2B?=
 =?us-ascii?Q?fJ+y8mslcHLCqzdR2ohVUXmnvuyZP8FzMIc8JXmKUUbizCWHnjx7TRrWqn0e?=
 =?us-ascii?Q?W7IajX2oGVxmcXelWu8+Iwsz+fRxqOxhPXQ0wurOh9WVMokaqiRvrLVGEuqf?=
 =?us-ascii?Q?jVtWHF58FIExqVoxdT/HD4pvuNTp1wU7RsfVGT0EJEV7Ys6J0Nr72ka/r2Uh?=
 =?us-ascii?Q?ikBD29r9enN48As5zjpWj/iQiVgpI4Pxp5S9h+04PxS32oHyf09fOF6Wrf6Q?=
 =?us-ascii?Q?rNLsNVKlLe2205P9C8+R1tnYq6djaAVzD5gGftn3oB+fUt6MCGpWQzriYUCW?=
 =?us-ascii?Q?sTY4u3MAWtMFfIcGFhXAMdU1lTrISC1gqG21kZVTuAIl4100+QmfOx9x+7NY?=
 =?us-ascii?Q?bH9pmF9G6XXciAWNh+R9wutwCQ7f2Ar/rs0ZQ/bqwmVWDrwZWxOOL07ALLMP?=
 =?us-ascii?Q?CpKutJquuMSSY1Ylgi/5iMQ6mX2ma2NiHx0VZhCgkUoTU0H8HRV7syt17bhy?=
 =?us-ascii?Q?iCrSXm0e0M0tH9RxNUMdaxYpw4GW6Ckj1upMb2HQ10PA+J+fKnhqVfT0EGWb?=
 =?us-ascii?Q?l+uvpfF5om6FpMmmmcfTQXBJDf9LM8dXPMiCHJSsBfTbw5m8ujdnYK0wu0Ma?=
 =?us-ascii?Q?mIWeoXGnHUN9P8RVJhqicvqswyuXGqYpWSP9tPPwxgTpbZBa6HM07PcisxuH?=
 =?us-ascii?Q?NK/7uOQRKfRdTwdilIhO9Hqd8zZoWtWiIzcH8J6swpb6t88PyD6/+CD+UTW3?=
 =?us-ascii?Q?3O2fIMvUr+DlO9T4xEUkWLR8ExPs2S9M4TiayqFBYhgvOVaVh1YDe2bcTiFq?=
 =?us-ascii?Q?Yaw4GlWkE4Rl/h81ZFaOZwFHhGRAMLwUCtwHAawSbvLuCrIlDoFFGCxQJkak?=
 =?us-ascii?Q?dxSwYu56Ck1Wo7+Zibx17lxw2jLitxYSoMhrrR0GduM6wNJ39j2lNy23OiDk?=
 =?us-ascii?Q?29gLUvmIVybPSMjCNYQQCnWV3iM/a1Ziqd3oEorpMlCi+rN3tO5Xgjckey1H?=
 =?us-ascii?Q?NITCQ/1kH6g2ayFT/r78oro8aRBkV5MXY9JZs9Gb1ENVQjNgz6WMl+5haOOs?=
 =?us-ascii?Q?rQE1e491M801jxIj4jU6vJb/YxJpyy3OgqRSdznzrXQQ6vUcbMo792WvAmyP?=
 =?us-ascii?Q?KzyvFA9W6NNuF/dSp2S7SUcnb8wjz8wT2OQI+JNEJ3RT+5qcQd7ezbYVtPIh?=
 =?us-ascii?Q?Bp9ytLxomHQuBFtlbUXviNVQhayYzYCm3iQ5xpphC8chZUq+3osJz5BNxoVv?=
 =?us-ascii?Q?uT2Dd2+43Bdq6VnBgYalikM+0l+WV0DrvhAynLc3T8uJOXx2a3LHintArzAK?=
 =?us-ascii?Q?Q1xfpARIPbpN8P1sNP55gz9HQd+deOjtq/zMu528tU+27YiCTMyzKd2h7xZL?=
 =?us-ascii?Q?HM5TXx7A214xTZHvwOxf1t+HpzftQfIgYFgH3euPzbym2teYlpiO2mtj4g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 21:21:51.7938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aeab85e-34dc-4cea-cd46-08ddf49de361
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7766

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

 arch/x86/include/asm/sev.h          |   8 +-
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
 11 files changed, 672 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1


