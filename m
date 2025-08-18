Return-Path: <kvm+bounces-54912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 752F1B2B23B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63CF2189718C
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BCB22A4EB;
	Mon, 18 Aug 2025 20:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DS9PF63l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C622615;
	Mon, 18 Aug 2025 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548308; cv=fail; b=i9HBFlz0moRCcJoJw0hIDI46JKv542LcRacD3Ht7AhvV3HuW8tamB6fG2CM/gFD5RWUOteWZsbJP6VbnKmsTeBalIIvnktnAoLJntCvnKwAwEg9lzvW0Ed1UN5S1ZWBmrlBEjPUvWdI5J6xIDy7baNq9p20cI86z0rO8O57JIQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548308; c=relaxed/simple;
	bh=BxvGVj9NPCYiBL+X31WaQNTSvkcO8AmCImRSztV3/xY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o0uznVgp3+PMeu8DeWgohItotiicY0xIT/edT1a38tocAKhooyTOj/z8tOZ9QNu8aQGcdnRhJTypAysDTAbyTKpruCP3VOx2s3iF2ZE9GaAQbZlzJvkPusKPK1N3zEMwFf75kVMFYX3LmGLmXhx3NaQJeebZS+oiEzWWaJiK7Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DS9PF63l; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTOdzamsghUNovclXvSnqTlq6aAF7mURaC8YYS/+Ty1IQYWTG+C3WFzEJ3u+xnVKgbd8HewWp87Q4/H+gkGlOOWi6Q0arclNEFu6WxYcZnB1e9r2GNTnZAryGbQD7ptUDiDXO44FkPxITbYysqbzAA0aPmhvp58IlDp2EcdLBKuhHz+VOnkMkF6gjgCQz23gL/MV58D/wyVZsCJB0GMm8+MPBSfFy7Y7ESst9A3RIL7cu3LyqsWgIEKzPbGCxh8bxCKrWG+BWbT3oB4I70z0Tmkc2dbS/zYDbnFyf5J/l6Ow4Gr4g9XblAi1Ge/8IbYEIbnRSc8YDSb1nsZgdeHzbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtjQqcfjCmcjmUNq9O1mttLv+edNEVifBK+8VQ8AfLg=;
 b=c8TF+s1ji9JB+klLtnSmfzwJf2tMcfTYny2uYUdternocUnnRg5EY0on+4lNQFeHX5stGc2SY3bTw58OlEyntCdNcyTBwQ1Xrv/q9z8xg1qkBYqWkJTIzVUhbOQY61Shc+HFa8suRX32q2dWhuUil0nChXkwVHo4278bHVLMea7yVsDNPPDKOS88WxdWfniTtON3rX8n71eWdtnL4sQD3TtKh29xsfBhElF+95q+PnvMas8v+xdV7OsqdFVH6h8A6FDTOva9PUORMWkhRXq0NZCYi00qMhJj89+6OL30NJumjC2qhz7LOSm/LKobFsnUyu6usWKMumdffxIa9Zo7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtjQqcfjCmcjmUNq9O1mttLv+edNEVifBK+8VQ8AfLg=;
 b=DS9PF63lTR6ZBCwtgoYsmsWNI0huENsWAK9g5sF8FFn2dZIg0rh4r7LTEaaaJpPi0+3TyQWcuitpovGuUnIm++MHzxckWoc24RsivomFJCJrdqfyWzqCX1ZrDl5bgrSWQxAlHffghYN9ngyCVkuUjkMn8OqG4sIMZBTMeEMGv4M=
Received: from BN0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:408:e6::20)
 by DS7PR12MB8291.namprd12.prod.outlook.com (2603:10b6:8:e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 20:18:23 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::8e) by BN0PR03CA0015.outlook.office365.com
 (2603:10b6:408:e6::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Mon,
 18 Aug 2025 20:18:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 20:18:23 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 15:18:21 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [RESEND PATCH v2 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Mon, 18 Aug 2025 20:18:12 +0000
Message-ID: <cover.1755548015.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|DS7PR12MB8291:EE_
X-MS-Office365-Filtering-Correlation-Id: eb107d90-ab74-4762-de35-08ddde9461ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jzixEOskWgIRu5kQEGQWSqykA+ZORTvuaeB4gbfhRJBEY0MxJ8e2nBxouVLb?=
 =?us-ascii?Q?zKf+PXfosdyJEvmEwg/grr0HTA/TkWEK4cuVqYH6svbn5a4eHb/DavfUaxvf?=
 =?us-ascii?Q?y4Byb9mNWMfS2VYiFzl1dMMU7EHRD5OsVYKDAWKGWZEjm3ACDyMD0tByYcFR?=
 =?us-ascii?Q?UFxOtG6+owzn+VAdj+UrIfGemEvX62Q0p7paf74dJ3x+lCUws3mOjhibvhO4?=
 =?us-ascii?Q?LAoRMPQJ8tgQUxOiinPNjm2/FYZEAfhtkAzbl5rsJvisuItNH2Zi3tqJNe81?=
 =?us-ascii?Q?4z60EPEfLBswcMZRx6C9MNWEqtRMUpBu4jMTVcM3nEFrf1/lDlepDinQ29Jv?=
 =?us-ascii?Q?8vbYwFr8+YUv5T+jo5uOB4B4ecnkKcvL8km/QuOJa/0wen9pASFveh4qRucS?=
 =?us-ascii?Q?cASbKfBodF7TFlEkZVNIhihKMrzh/Knvh/qz0No0UVEtaQQ5ogc4EJBvK7Bo?=
 =?us-ascii?Q?ccPYgUUnaGjcAmwOGi8W2bcTZF3kARxyiMRAdYbQno8XfriBiehr7r4igG5Z?=
 =?us-ascii?Q?v4LbQTEHgmzMQiW5UZAP+FA9Nl0x65DBvT8jEGb2AGFkYqPKpd9eY4FiP+nX?=
 =?us-ascii?Q?MVERwySXFN7VsQkvsAGrACsG6nEiMTb89Bo25Aq1hONfvirqQA2Qdpw0URzD?=
 =?us-ascii?Q?IWVYreb7Hx7qwntZqRvV8kOUBU+Os2uZnne0R9AE+2O1RARbz64Ty5Ieee25?=
 =?us-ascii?Q?6KBZfp7PPAG5AjmH3E7eHudoB3JNYu9J46NMJRtjkYOEvCOovs02aGneFojv?=
 =?us-ascii?Q?ivSjH2hQstyMJJSfN6hzA2B8mxb6r5GKka7Ts7vxgi1eS44pD0ncdkrIIo39?=
 =?us-ascii?Q?GBuPjYniswQp4ST6zChqv7PgweZj61BdkM+tHc0eP9QK+P4bqOzHRJE3vILb?=
 =?us-ascii?Q?el8iBWFPWmUDsjIVbX+MJRuQniXwTSuXCWjDZbWdMFXDljiz9Q9wJilI530p?=
 =?us-ascii?Q?UI5yIp/YKswrp2tsqcACyoCJV5/nrQ02xiS1BnjjZhVTlQ0HcWjAYGYTXKVq?=
 =?us-ascii?Q?YC9IhCKN6ZLNZ16pXdfAZQN98EZKrhaayAqMtH3wd+k8s2nERaiJLWpGqt1H?=
 =?us-ascii?Q?Jz7XR37Q0S+gJNO7Yi13sgVB24dmLi4KVH61HzvgjCH632PwD0b7xdqAutQb?=
 =?us-ascii?Q?Yem8fKm2IcC8LN5FWYqx+cUe6CpqepKda7JwQdyqSY0qpeI7V/79jEVB1wsM?=
 =?us-ascii?Q?Ya7gQcSvA1TFUlmgok0MpjiyUwlNRd3qwESpaEaNuY0TegGR7u1wWaGiYclc?=
 =?us-ascii?Q?f1ZZWKCDI61uMQ1Ve2kwYZOQqTwjm10JGsLAKjwYzaixBl1Dp4cELGNEp1Pg?=
 =?us-ascii?Q?CWQb0/h91VFLAD2nimCDfj1zzYQXHX5jB3zeAjSgvymeOiIWSsq/JHRKgdpk?=
 =?us-ascii?Q?SVQ5B+nD9vlytGUqpo64K4DB4bt3X+wBMDX6N4v4nyfXSzuKHYaP1pw3bF/M?=
 =?us-ascii?Q?1DoxOgV4/UfcwLHpkODrxJd7kw5B91cLRb8YcugyahTRjsajiNPqNa1C62+F?=
 =?us-ascii?Q?LSMF0X0TQzwd51WGkKogIebicumcqr5KhOQ4U4QMA5qdhBrmcMYDmxfh5A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 20:18:23.1349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb107d90-ab74-4762-de35-08ddde9461ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8291

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
  x86/sev: Add new quiet parameter to snp_leak_pages() API
  crypto: ccp - Add new HV-Fixed page allocation/free API.
  crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver

 arch/x86/include/asm/sev.h          |   4 +-
 arch/x86/kvm/svm/sev.c              |   4 +-
 arch/x86/virt/svm/sev.c             |   5 +-
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        | 184 ++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 12 files changed, 660 insertions(+), 9 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1


