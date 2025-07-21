Return-Path: <kvm+bounces-52984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FCEB0C5E9
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F24193A1951
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFF42DA77F;
	Mon, 21 Jul 2025 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wWZT/Rnj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2463429E0F8;
	Mon, 21 Jul 2025 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107153; cv=fail; b=UJEXMUKO1uK4bCYm99mRLSyaG1JwP7zPUecotB2DVrqpGXtQG47VlSWG06hy0lXm6OyQYX7scH23kQB1SzpYrLTq21VLWdD1K0jusH9uKiB0skNCaNhPBCGnRkSTNdw6pXuKQ9xug9ggLOgp9w2ojUrJvZVS3L4ygahOJG1cjbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107153; c=relaxed/simple;
	bh=E9C/jpxbS8+Y7ZRuqI5KFE8QnKCkOvjw0i7ulvsTLds=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NshWmq1jh5eXFiC+EZWiiIgRMfyN4NpLPIxBhvuEGTnCBFOIaGEpa9uYdo0Ca/eBxcqOASgHjtiSBsh4ZR553OmOAf29lRrBwybvL5yLndjDYVjX8+cyocrrDdA4OXoCkasCD9s2VYWghfrKNlYqHK5nlwffsysXB3nzYTNadqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wWZT/Rnj; arc=fail smtp.client-ip=40.107.95.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlnmNzHv9XsDFsEIolEe71U3t1zjC2+1W0dIg6sqYd1wTnS3g+IfJj81zv2Cy/yNOC5KlGce9zj2ZgkRNG/7QP/IkgvUBmXqlW3SnF1lPBoXi+wCcFiL4ok2F1maL/OqCoqqPfSeNUONThYdCM4cgDCIPHlD7deldL2TGvz7yc+N8QZhJ1DQ80sedislTsynTgNR3CHZdFgp85kj/ovg/ITsUwihn+HGc/zshhFarxuB2cAR2NDcLDdRA0ZKLCZRWU+N8OukFXy6vwaElhpAK/dMSnlLFeHNWiLbzc7MvjxDu3OrpOYXcESjm7btbtyoTWjBEi4H9oKDrGSRXq9vsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODUNjW478QzqTMP8xu7p6TCyYzL6z5LMDb+46qCPW04=;
 b=HKJNFvI7Hihy8NW/DX9itdUo+1HKGIWeJU8/qmcX/6S0m0rHwXNHSFPiD2gT666o/8B0R7WpnFdGkGoo+oGmt0i9Mlx/TucD89/6M0ZArunpZiTD6UxvCNc5s8abybePTXaTG/kzEHscIRz+gtibwXLQRV3kR1/FpSaWEOTU06BgNKHXeOpeYaL5+Zno7lfeSF9zZNKObv7NMP+34BWPGsz2Qrtc9gdqXDqgjFb8qg2CwifCKDWwBFrKxkBuTh3MvuwLhV1VdHnN+/+E2VqntKGSz8eEz8Qzu6ywEWPvmECCl+Yo1U4a4CRNLwy2AoVy9nYceCcAUTSr76ZmMxCimA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODUNjW478QzqTMP8xu7p6TCyYzL6z5LMDb+46qCPW04=;
 b=wWZT/Rnjzt7odmgtBHLAXDXwj6gpOTUHoS7Ramj7FoKjvqdQ7AE1+HYujTsjC7A30tnKsxKUJjwkb0LpWlb/OhWjFTvDMXXD20iXqjvEJnKxB6GfEG9sSD+vEaMj8FrsrZJYmjY1xdep/+5VdN8bxwQCpujfZatRBP0V8uLAScY=
Received: from BYAPR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:74::19)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:12:29 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:74:cafe::40) by BYAPR05CA0042.outlook.office365.com
 (2603:10b6:a03:74::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Mon,
 21 Jul 2025 14:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:12:29 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:12:27 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
Date: Mon, 21 Jul 2025 14:12:15 +0000
Message-ID: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|SA0PR12MB4461:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be2a7bb-16a2-4aac-843e-08ddc860a095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1245ZyiSIOueu462GAfu4iyC9DSp+/jyBSt10D9ke69tT+tPjfqn/tGt52h9?=
 =?us-ascii?Q?h3mU7vstOCOj1LfpTHaUbxdQZ1O/ZKUWsPmbee3cOHTGWHHnrM95M132IjMM?=
 =?us-ascii?Q?1QcqoXgk6i6/yszyH4wZqkmVZYULZKL74By5UPA5aSWgRQykVRag/svIFK+J?=
 =?us-ascii?Q?TkrtqF6QZrZF1EZwHa0PiDXGmjYcKPZPrybb6KwJ/FYIJZyeBf6qaTioa6aY?=
 =?us-ascii?Q?kF4Denep7DE0GczhEhDbf1gIa8rOWYIH2G7xumMQ0Qtx6tZtRlLBQTXFEzXE?=
 =?us-ascii?Q?Qqw7jc9F5NKHKlbPlDrmo/Qi6wrwSyujLy+KusNvktI14KpHDNKU68dmYJw7?=
 =?us-ascii?Q?ZittKg3FFhzgQJ7s3ACebFzl72lxuNy3m8n1YVbyCp0nD3ZuJz4/hc8Tjgvj?=
 =?us-ascii?Q?sV0B9xd7r/Mwvr/kufFTjcEGlfGEFOIo5kS1kY7U8mWC3FM5L7RWFagKWXmj?=
 =?us-ascii?Q?Cg4NXh4sLyh8N/VqrRvVpTCyl6rELlA1EHv31SjxILa9iHpy/ftKoexQWZ36?=
 =?us-ascii?Q?duLXtC4l7LA0omONROc3OLG3cKlqWYuaZyKwBk+XNN0Vx85Fg3Byd1E3x9Fy?=
 =?us-ascii?Q?AvTCyC0bO8LLchn1tn6NUmsMjhm7f/jo7JMTVRdHGLj6eb5Ate6xnK7HUL9C?=
 =?us-ascii?Q?9wSBGumQwVmYXk9s02Tkxsfk4l3HH5QGFD+mestidxXAutUTl8EL1FtpbgcJ?=
 =?us-ascii?Q?Y504CGJoYyOisZiBbCTQTOaPZt85lHZyRXHBPWrfTwYIU2UYsz3lPagmobXK?=
 =?us-ascii?Q?IuDk1NKxXn10XCTap5vTJv3e8xkuBifBmRwdBL3oUYsfBE1snSMN1l2uJpB2?=
 =?us-ascii?Q?8pjW6AghaH0FViEEIyL94WH4M+COIgkaWbikoRnPRXO+xPkfNZa7nK/zZLoJ?=
 =?us-ascii?Q?2U0qoQWhTT4yPecpQhF7Jd86fMMG1RVIfrKRaS6nofx2Am1Y69sUJL4FKGIg?=
 =?us-ascii?Q?JqaxVAMPQqPpkRG9Tv4bLOzm1P1gv+Vd8aDAKR57fVgbCu/wdwv90HllqSLE?=
 =?us-ascii?Q?f0yRIvyXKT1zCvsvdwUB6TZSX53ZgLr8eGVoGit/v6Ul7x4kQL3HSM1GLShm?=
 =?us-ascii?Q?zAdgwfB5AXDqcjTt7J4DIn+tRbP7E4NvDf8KV/l9lUSeEm4LRs4ziAv+hHIF?=
 =?us-ascii?Q?600O5jAOtkqd0sWx0T4+41ccov8o9XNhYn6dUD8hNj6oDxt+WaJbW4vw0JSV?=
 =?us-ascii?Q?EImFV0qJt0bg/UbXavA6U3SThLDp8lfoqKTuL/X4qp6wcFIvCa71GaR9EXRJ?=
 =?us-ascii?Q?X+B6cwuf5K9Um3xmMUqkht3KCx1Tg3dF/2UNLiTDd7DEENb/7Ejg8emsgvGi?=
 =?us-ascii?Q?A+Ck0N+vLJfSwOIUa1tahzy7HHwC4zD+tjRlz3eYCZm/FU0301eKX6g5P3XN?=
 =?us-ascii?Q?/JYDtrRhrR4oxlIeeenQFgIW+UYAIXKmV+Yqe+MHt9eLXc6KgPv12l0pBQh4?=
 =?us-ascii?Q?mpx6RtqhR1BrwlpQUsbMAxJt5aRG9q2a2Mv2HhKWbWfHLS2bAwZBZt8LzGyA?=
 =?us-ascii?Q?7oot+Y9bSBPCmJbqKY+H8nnm16fqAvSAHYcE8djViVTIo28U1e4p8k9/+A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:12:29.1701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be2a7bb-16a2-4aac-843e-08ddc860a095
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add new module parameter to the KVM module to enable ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is "max" then the complete SEV-ES/SEV-SNP
space is allocated to SEV-SNP guests.

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

Ashish Kalra (7):
  crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS
    command
  crypto: ccp - Cache SEV platform status and platform state
  crypto: ccp - Add support for SNP_FEATURE_INFO command
  crypto: ccp - Introduce new API interface to indicate SEV-SNP
    Ciphertext hiding feature
  crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
  KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
  KVM: SEV: Add SEV-SNP CipherTextHiding support

 .../admin-guide/kernel-parameters.txt         |  18 +++
 arch/x86/kvm/svm/sev.c                        |  96 +++++++++++--
 drivers/crypto/ccp/sev-dev.c                  | 127 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h                  |   6 +-
 include/linux/psp-sev.h                       |  44 +++++-
 include/uapi/linux/psp-sev.h                  |  10 +-
 6 files changed, 274 insertions(+), 27 deletions(-)

-- 
2.34.1


