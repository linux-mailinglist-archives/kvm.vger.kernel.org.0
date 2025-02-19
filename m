Return-Path: <kvm+bounces-38596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8DAEA3CA66
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC763171A7B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBE924FBE3;
	Wed, 19 Feb 2025 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kVGUmRoR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1937224E4BE;
	Wed, 19 Feb 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998367; cv=fail; b=WfD5TlrrRptuMZjHYZuZrWsQVFeLM1YXtjOEnrJgcRtHRATszaV1GmLoUd4lP1drbEb12MAvy2kVXT9C+BV4gKmvbWvD6ozqjUdWiUj3u5Idr6ETZATIxo3lp/lfOAX2bkYMkKIEjPpzL5mkEb8kTvN4B582JOU/lAlbEnV/i4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998367; c=relaxed/simple;
	bh=CmlVh+q0/bqdomwJA/1IqzVSiu64oSuzNaN3blETCds=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r4O5bJc05lFhPbVHLf5pE5IqAzq3ubrXiJ8hKyESG5rpfXUbzywJEkH0gnL7eBNm8A/5s26joj3YKAy65ATVzwexbq9h+BaKmfz78qHiPKC63YE81tNQeP/gLDXNfTh5pCCj1vd9AlJZEfAC0Fq8HYpgRNfiQvTG8wJZDuuUHjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kVGUmRoR; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTDUODDDUrEfP9YB+s0xs56K+2/s/YHnijuFz6l/r4OKfiJIt69cgb2JSIDwfhUOITQQFlR3vqVuErVwk1Xz/b24K/ID0W5/uAV5YEJG1D8V6vf4mAjHSIHWliZidpNQ17bkyfT7J+8Kq6zPRWwL7iVAXVzmAdlN+EF9GCI4H6h+Ipm4k2ZbK8ffNqiviPdZAjs1nSG7Vtdr/6Y27u+E6JQAmfm/LEFfgV6cbfQE+2qvYDFEU1eR/aOtSsyX6T+dCMOjBZdq38SWuFE9cE24hYoAqjdCvU8dBk0gP08/oxt+Hbu7CliIUTVyRIneL/J6n9c15bHBSWFLD7+buX6M3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8ja4oFTdUHWzLfek+8sdWrBfE8dkgB1g0k6toCOb/M=;
 b=WSCb3DZ6S+LTgqTZP4W8bM7pcd7PlZobg3AXOLrouJ4H1cIOae9cJp7qjX7Zb6vSRqJEI+BdXKInkXaDE8AIKrfiFRcZ0fAV5ii3HAke1gkzzCBOnHrcsNw+0zpbzdoD/YCbC0d3xmOuZVaXJ9RKMijsMd0k0cnnaOaFXeOSowD5Gr2DtoBKzw0IQbZigF+P8tGNFEPMzT4KIS0anmSRnffA45mPTxwoMS1I7pENAO7GnUgVJPniE0RWEiCkR6gQyT8BgE9UJO61NkdOdkBAtuAayre3+0KMK/ZNTx8OHIWzCORQEcqi5bkxorapHZlbdHNUKit8DHSktCpeNKb5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8ja4oFTdUHWzLfek+8sdWrBfE8dkgB1g0k6toCOb/M=;
 b=kVGUmRoRvWOzVLG8qvZ4aEt35Wlf8QTW4ifjrNnh6gdHezL1v0xgdj3KiD018fY7Cx5o3ZE1YznSEE9018A2HoDRe0qrgF2PJM3bHdCKlU17tnYOZ7T1S7aNxShftYxX2rcAk20nkB95ERE5ujJbLbLF8Uu3nEMpAhDGNGybd/4=
Received: from SA0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:806:130::31)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 20:52:41 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::24) by SA0PR13CA0026.outlook.office365.com
 (2603:10b6:806:130::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 20:52:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:52:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:52:39 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 0/7] Move initializing SEV/SNP functionality to KVM
Date: Wed, 19 Feb 2025 20:52:29 +0000
Message-ID: <cover.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: cebc594d-1a29-4755-5956-08dd512759c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Cjj/bNwUJkAjgOimTRli1LCxD6iu9l2v7YCXOwlXTpplG7EPIeOmWJuUg3bm?=
 =?us-ascii?Q?AkO4AXt6rT6Y95P2dVZSOMMlsG00Gkqr8DCFvVTk3Q8vYlUYysqS9HLkQ2qI?=
 =?us-ascii?Q?gM/kFHMyHMpVPuOz9ZX3EHZ/XAkvy0xoG7VEsMRKJNsD3fXCKY6wjfv8hs3z?=
 =?us-ascii?Q?fvtFdTcH5S1AXqsu9gSjEz0cT0BEUZlueecCTK9HQXirqdwus6JRsyP4Pdrc?=
 =?us-ascii?Q?vqhCKvlYxLNcs3N1+oIPp+l6h0xv7APv3GE492SZJYTfDUWi4eOzzdtY8mbs?=
 =?us-ascii?Q?y/KvJrXAvdiL1nDadE9QDkSZDb/ZiOGU+Li5awGqSbRLmrhyGaomwxcZdGxs?=
 =?us-ascii?Q?EVjzCRzTdpnMw16sBDuPS17mS3O/Y/hJDDLTL1G6Ppr0rfQl3gh01/I1MRcO?=
 =?us-ascii?Q?HlD6PFTG3j3nVuHPX1+hMQWCOo3ZT6EPiScbKCU7iPWxo//0R+4ebHcD7gr+?=
 =?us-ascii?Q?CquunQVDtPRJtN+zaTNTadHoK8NgWG56AkBvLwwFsnNT5T9zpaqK+gncSO79?=
 =?us-ascii?Q?xCHBIcw2lbjmKQ9agCil/dzGPvTvOErIl+vmCzIldElKWeNRfsPpTcublDAn?=
 =?us-ascii?Q?oaIA2pgMb10Wj+oxfB6NWJyNIeyYQ+l3JQVxd+vDXA8QEWAp0ttsKFQIKDWl?=
 =?us-ascii?Q?ZiotjIolTbqdjHQjCVvByj8dnRnkcKwDSiy2Yfid6XyvNbG5LHeQyWWQAZSF?=
 =?us-ascii?Q?YOrtXNZrNGGQTeMRZFqiBUjtHm0FOA4Q+b4b2qsBka55cQekOFJkQMaqUkf/?=
 =?us-ascii?Q?lcxQ6lh5vr8hj8tQuiGIQwXA1cW1xjET6NkclCxCub1wsDN+yR/fLnE2szXH?=
 =?us-ascii?Q?zb2Py8w73MQYSvq3zuYsvoRhIvdeCg2uFRMFtYI6IPLEHQW3t9/DmWa1Aw+H?=
 =?us-ascii?Q?LweUaR9PHqiAArg/GDbeROScButJwr0AydjxnNedH/GHDRGXQrlEChkTrTGY?=
 =?us-ascii?Q?ZDyfOYZ2ODGIhwBP3lC8s+TwlhYMwkIYvstpsAJYc9BxdNC0UAPSVgsf7VJ/?=
 =?us-ascii?Q?kFkgtg/pU9Eq+Js5FUD/lWiZZUsr13Io5U+eZc0eFp64mK/P2N3v1j8eZXRO?=
 =?us-ascii?Q?fBP9s/JT25r0H9LbIjHsISWDrwugXIYeHQ6RPXi9FHh/2ldwl5UZK5+6TMpj?=
 =?us-ascii?Q?ushewzfLALrPsKr/ozLsWR9ImrOVgFFCBP/Oq33G4M6pD8/eBdq9PeLlF/0Z?=
 =?us-ascii?Q?pPc/y68KXoemt8VJFSyOpS0q/qQzQYeRLmgHqB2Scpywv0kLkqqu4bsx9ryW?=
 =?us-ascii?Q?vKBm0CmosySscYzP+ATJiTu19vyk200s229vTPETgrIlbnqsTmwXSjtrPvnn?=
 =?us-ascii?Q?E0kuLoCfM7ebg6Hq4jyfET/yAPajkI4+VoTjABcpLEHurtj5y3iK1dBHQ8N2?=
 =?us-ascii?Q?pifJY8RwmoKFEpuaJVyrnZRE0JCgMmi1ov/by40mZeVlJgQcPJugy0RID6f2?=
 =?us-ascii?Q?cXRYS9ePR8FlvG9lAVKM24Qfum6an5j3b1BBzDWZJxYm3C2UrdN43Pl+S/Lq?=
 =?us-ascii?Q?ozfs8wfP36XricP8iIRYDQWp76g7CZOMZr8o?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:52:40.7352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cebc594d-1a29-4755-5956-08dd512759c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697

From: Ashish Kalra <ashish.kalra@amd.com>

Remove initializing SEV/SNP functionality from PSP driver and instead add
support to KVM to explicitly initialize the PSP if KVM wants to use
SEV/SNP functionality.

This removes SEV/SNP initialization at PSP module probe time and does
on-demand SEV/SNP initialization when KVM really wants to use 
SEV/SNP functionality. This will allow running legacy non-confidential
VMs without initializating SEV functionality. 

This will assist in adding SNP CipherTextHiding support and SEV firmware
hotloading support in KVM without sharing SEV ASID management and SNP
guest context support between PSP driver and KVM and keeping all that
support only in KVM.

To support SEV firmware hotloading, SEV Shutdown will be done explicitly
prior to DOWNLOAD_FIRMWARE_EX and SEV INIT post it to work with the
requirement of SEV to be in UNINIT state for DOWNLOAD_FIRMWARE_EX.
NOTE: SEV firmware hotloading will only be supported if there are no
active SEV/SEV-ES guests. 

v4:
- Rebase on linux-next which has the fix for SNP broken with kvm_amd
module built-in.
- Fix commit logs.
- Add explicit SEV/SNP initialization and shutdown error logs instead
of using a common exit point.
- Move SEV/SNP shutdown error logs from callers into __sev_platform_shutdown_locked()
and __sev_snp_shutdown_locked().
- Make sure that we continue to support both the probe field and psp_init_on_probe
module parameter for PSP module to support SEV INIT_EX.
- Add reviewed-by's.

v3:
- Move back to do both SNP and SEV platform initialization at KVM module
load time instead of SEV initialization on demand at SEV/SEV-ES VM launch
to prevent breaking QEMU which has a check for SEV to be initialized 
prior to launching SEV/SEV-ES VMs. 
- As both SNP and SEV platform initialization and shutdown is now done at
KVM module load and unload time remove patches for separate SEV and SNP
platform initialization and shutdown.

v2:
- Added support for separate SEV and SNP platform initalization, while
SNP platform initialization is done at KVM module load time, SEV 
platform initialization is done on demand at SEV/SEV-ES VM launch.
- Added support for separate SEV and SNP platform shutdown, both 
SEV and SNP shutdown done at KVM module unload time, only SEV
shutdown down when all SEV/SEV-ES VMs have been destroyed, this
allows SEV firmware hotloading support anytime during system lifetime.
- Updated commit messages for couple of patches in the series with
reference to the feedback received on v1 patches.

Ashish Kalra (7):
  crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
  crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV/SNP platform shutdown API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  15 +++
 drivers/crypto/ccp/sev-dev.c | 219 ++++++++++++++++++++++++-----------
 include/linux/psp-sev.h      |   3 +
 3 files changed, 171 insertions(+), 66 deletions(-)

-- 
2.34.1


