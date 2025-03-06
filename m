Return-Path: <kvm+bounces-40290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD9BA55AB2
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61A5173C3E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C55027D777;
	Thu,  6 Mar 2025 23:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zUu/MqSE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E781311AC;
	Thu,  6 Mar 2025 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302573; cv=fail; b=PH5pod8fKbWHl1pQB10fUIQDuDuSDEXLjHkDPpzCndWqGrMghl7ZJcxkKJT8UMsIwyT5OJa1lhgNElKSATQoGfp2gMrpQm1HDbE6QQj71yXZwi34LSMf3YzpHUlfkuZ8UvImLxUIJ9B4hPncOGP96tVhdOM+lRvy/GF9tA1oap0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302573; c=relaxed/simple;
	bh=Td3dAMIiEbTlv+5kcgbKE8xXXc85tLf5zIvQwf7RONA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jo7Qm7BUfAacLA8oCw8CJL1nDG6DRK9IzFWtegu9wEmVSdkhMMPOPhl3U1nTpqSqQTyGcZLfeWXJVUIkEZbz8jCVw6EU7N/K/tT+Fm2dQLwUiuiU1epNAn1FLv2t/RZCcJECLmjVyybdbkxsIaeIF9wyagyFlPX97wqXraihSGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zUu/MqSE; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tng4chC2mnt6QSFHC14dlYm2rdGEMTOx6dBb18DPJlgJ54I1urwPKZy4EbmCFy+aNzE9Cv2vm53gEmJ0gz+5eITMxyaJHK3knqg2xIFWY83JJL80eVFmdV8AcqFVtEyMaTRp9/B1HfgATR8FU0f92k9SCwEXISczDtpE3uK2KhuMrfrnxeoZPLFy01OPyxfDyI9N7QmvS1+V2OWD/uSgn57dng2xTQseGjHSf4Ii4Mkp72fmopP2W5Ou1/MixqYLpAf7GXTBGf36XzUzxvjamXypmWlBtTMcrkh4wPbzSJS80w23UgqzQ90k58CckoUSHWMM1CmOBRjCLI5UtLBaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=catOQSpDwTeBt4evEQSLAia5ifAeKh1U1RZU0HrbfU8=;
 b=Bdb7/qX/4Q0qi55Ul/6TJ9BXhoQcG2Uou2EUv4H8PoyRwwnrNwyv6hYboW4yYdvWcmzhwbumet1eLT96ENafRTXElVHunQ3iGqk/VtOm7Zah13kBcVYrCaBIzxNCFy8+7sALk4a3BW2RPn39FlAv7Ssy5ez2kdd9AU4YzQDv6Cz8mHzz3xmnfw8h2MDR2SPbwnBeV/A7sbh2aYrVBmm+XFHclDuKXRp0hajtnC9UaKomA/CWyHZYehonQtrtWM7s9I1CsOsAmAYO5DD2MgsDzBwv2jfj8oqaGVsUTGzhfRoS3mJVG+8s69Gz0sJi4f2D5QO5SyXOyMXFN2XTiRR9hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=catOQSpDwTeBt4evEQSLAia5ifAeKh1U1RZU0HrbfU8=;
 b=zUu/MqSEWDXyzLQ+6G3aNZhFl867eHEVMXz9J9aQ5l2lk97iM4pyqQveLoOsA+YoQ1LZl7TdMBuK7CQFgMcOaIiSBbb7rqnQ9fmMK8trCZRc3qLtlDEex3NzCjKO7h7td3oRe71ErkZa1PpSonXVAQjdC4YTWN5DWg2e8DNJ0M0=
Received: from SA9PR13CA0077.namprd13.prod.outlook.com (2603:10b6:806:23::22)
 by DM4PR12MB6232.namprd12.prod.outlook.com (2603:10b6:8:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.17; Thu, 6 Mar 2025 23:09:26 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:806:23:cafe::c9) by SA9PR13CA0077.outlook.office365.com
 (2603:10b6:806:23::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.11 via Frontend Transport; Thu,
 6 Mar 2025 23:09:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:09:26 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:09:24 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 0/8] Move initializing SEV/SNP functionality to KVM
Date: Thu, 6 Mar 2025 23:09:03 +0000
Message-ID: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|DM4PR12MB6232:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ab3f5d-d29f-44db-4a0a-08dd5d03f0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Di72ruvvQBDVplw6rT7YOnjcvnA/XWKNq9JYcLEEjTxDpbXSmVNZ/7NcGmXx?=
 =?us-ascii?Q?g8d3RGK6wht4ceWGACm3SfDg2eS2Oezq07410wY2XJ25uS4riIYuF7/smYGD?=
 =?us-ascii?Q?gOE+hZxH4znMrt1gtTiiMdFVyIAtmww8kl5Knm6CZt0JihXra2g3U2xwzvLk?=
 =?us-ascii?Q?C3+IXumcwMNrjezOl6OzLt8sRyWa50M2Z7DrGCTyVCh6uJCuxya3E8nERzaT?=
 =?us-ascii?Q?iMYa83g4DmtmbqSy/x2xtx9fBhxJy8yZrM3oVy1Iyepdgi4BEJ+RBmb7Xjoz?=
 =?us-ascii?Q?cbvE7etQUosN2qkXN72iM43Mr3CusOQRdsuZVdnEE1AnHMKRBMi4ijPZIpMM?=
 =?us-ascii?Q?NVrKdJkSHq81otwmhVv8fljXQ41dQkon+hCBACF4YdpS81qDNGO28F6Ocv0V?=
 =?us-ascii?Q?g9Xy+MWdan7cgGwCX1hgm/7U4//FXXWRiaV6Z2wWWjGo7tEg2pazSRCBGPU5?=
 =?us-ascii?Q?PZdC4gRLQDccTcuepPGaeg1vx0PCX8bJFJ6eIl/fyw+O47LV/iZMVrGuD49z?=
 =?us-ascii?Q?AMGe5tM/1pMHa0Xgt9MeRsd7UHVuWpVJX2JANDWLbLSyf3NdC8pTKBg69CUn?=
 =?us-ascii?Q?AmkQxr4s9WkARlBZA3UBXCfDFXSldm1hGB0IioSwiaruGW7n5ANdRYrhuCi7?=
 =?us-ascii?Q?yRdWvkKPiYIjbRtJ8wCl462LRwxlPjhYbZoQ4RhRHdXzYyZdPc+x+C/Ld6h9?=
 =?us-ascii?Q?P698haa0iuLOCFodvUAk32eOkxnzYUmXenNuhV0yh+PLPeTraBERrJB1e9Rm?=
 =?us-ascii?Q?vLzhhGqflN8QKQPDHlqaLLsAetUl8zRj/rTDrxa06xh+G36fbbVfpOlgpp75?=
 =?us-ascii?Q?TSMYnm5czNLaRSN1E9tnlYNSoUhAqqb7uhGPbob1CgdKzb4mnzH1q1tQTu2l?=
 =?us-ascii?Q?Om17wLgHmhUPQdtoeVdVSfRXD72PfpDhNu0+cRu1LwIW1a9UBEaYe4GBxqNO?=
 =?us-ascii?Q?SujvQqN98UqtUKkWjwg2FQCZuHbyjhH+szF5pYaElCfvyCT2HZnoEJn/yrZk?=
 =?us-ascii?Q?vVWph2aM30fVzHfdJwk8H+pX+6aTNZ8TPOcbbU04DE8H0/wjKopNB6jUS6SB?=
 =?us-ascii?Q?XA9eSaiKv55AyIkcoayuJqYB7DcHEIAd36jAObUrs83TaUyXfxD8YZHEucTm?=
 =?us-ascii?Q?9MFW7b2vGjbVCc5Sj5fl4biPrXUt+amfNcinD0uzEB9JBOUOnTibjStwUCWn?=
 =?us-ascii?Q?8sRNgjfmC+R8hVU6vIT8U1JIGhwcFnGeRgN+xniCQ+JUcOyuoi+5HFaSTHKD?=
 =?us-ascii?Q?hPEQF+SIY4h387znoBSzznnkabk/BOiCD4Mjh2cDRpTnydNx33HicIr3I0eR?=
 =?us-ascii?Q?ib/CegZeS8KYZvU5da5+kSYjrzNsm1RA1frYub2ZtOUtUkid98VfgBveUE9e?=
 =?us-ascii?Q?G71QTyR7en3D69f2RjNHZo/5Q39GbH1cPnqQ5kdbO7iH38GcmMU+tC9QQPzF?=
 =?us-ascii?Q?a5c0cGDmYEn06lz5RBzqUm56HRmlYsb0bNyAryHKEqrQ7Pnm7tDn9mqbkeWn?=
 =?us-ascii?Q?RYo867L3vWnmABSNmZlnuCYyjBxV0mcRRKPy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:09:26.0853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ab3f5d-d29f-44db-4a0a-08dd5d03f0bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6232

From: Ashish Kalra <ashish.kalra@amd.com>

Remove initializing SEV/SNP functionality from PSP driver and instead add
support to KVM to explicitly initialize the PSP if KVM wants to use
SEV/SNP functionality.

This removes SEV/SNP initialization at PSP module probe time and does
on-demand SEV/SNP initialization when KVM really wants to use 
SEV/SNP functionality. This will allow running legacy non-confidential
VMs without initializating SEV functionality. 

The patch-set includes the fix to not continue with SEV INIT if SNP
INIT fails as RMP table must be initialized before calling SEV INIT
if host SNP support is enabled.

This will assist in adding SNP CipherTextHiding support and SEV firmware
hotloading support in KVM without sharing SEV ASID management and SNP
guest context support between PSP driver and KVM and keeping all that
support only in KVM.

To support SEV firmware hotloading, SEV Shutdown will be done explicitly
prior to DOWNLOAD_FIRMWARE_EX and SEV INIT post it to work with the
requirement of SEV to be in UNINIT state for DOWNLOAD_FIRMWARE_EX.
NOTE: SEV firmware hotloading will only be supported if there are no
active SEV/SEV-ES guests. 

v6:
- Add fix to not continue with SEV INIT if SNP INIT fails as RMP table 
must be initialized before calling SEV INIT if host SNP support is enabled.
- Ensure that for SEV IOCTLs requiring SEV to be initialized, 
_sev_platform_init_locked() is called instead of __sev_platform_init_locked()
to ensure that both implicit SNP and SEV INIT is done for these ioctls and
followed by __sev_firmware_shutdown() to do both SEV and SNP shutdown.
- Refactor doing SEV and SNP INIT implicitly for specific SEV and SNP
ioctls into sev_move_to_init_state() and snp_move_to_init_state(). 
- Ensure correct error code is returned from sev_ioctl_do_pdh_export() 
if platform is not in INIT state.
- Remove dev_info() from sev_pci_init() because this would have printed
a duplicate message.

v5:
- To maintain 1-to-1 mapping between the ioctl commands and the SEV/SNP commands, 
handle the implicit INIT in the same way as SHUTDOWN, which is to use a local error
for INIT and in case of implicit INIT failures, let the error logs from 
__sev_platform_init_locked() OR __sev_snp_init_locked() be printed and always return
INVALID_PLATFORM_STATE as error back to the caller.
- Add better error logging for SEV/SNP INIT and SHUTDOWN commands.
- Fix commit logs.
- Add more acked-by's, reviewed-by's, suggested-by's.

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

Ashish Kalra (8):
  crypto: ccp: Abort doing SEV INIT if SNP INIT fails
  crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
  crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV/SNP platform shutdown API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  12 ++
 drivers/crypto/ccp/sev-dev.c | 245 +++++++++++++++++++++++++----------
 include/linux/psp-sev.h      |   3 +
 3 files changed, 194 insertions(+), 66 deletions(-)

-- 
2.34.1


