Return-Path: <kvm+bounces-41859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E09A6E53D
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 597A87A8990
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0AA1DF73D;
	Mon, 24 Mar 2025 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="trredStR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BED18EB0;
	Mon, 24 Mar 2025 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850842; cv=fail; b=L9DC9WLhI2cw5NbIn2UPkC6Duk/c0AKbMA/SAKTKn7T6eP8K/AmLLhHx6bURg9bWxMZJZHyoLzv+v3Ui5j4xyM+B0wF3kQWxAwXAbHvZkXbYNn1ZjvbnpxmV2APlu5HwGxUE9b0w/QHloxwTJlZYV3BxIxUvC6qdi4Ifz7hckYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850842; c=relaxed/simple;
	bh=SuaZ5yeDjTvEs6D4wf2l0YtyWY4c5Thp9zzRV4KsA6w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V6+G+yUefdSSuQHJeFg2g2tNESXfxIWFIGB9gWOuOyGg86waCc2ZVu1M8j+Dwl7bK7VMLGTk0fbqci73d8grVsKs4Cekp7s36GUK8/8Ow89hrzG1y/ZtBMsBGuS4kfDNmciFbOx3NYyEYwqiYLu7DmEfT6nczRDD734Ig8PYY14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=trredStR; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWjxGhwprVDsS91Mc/naGw5zUc0/etCjVphh3r1PoW0E13zi3liayxAFWHA4gchCITVYisaGKUuk3x3SnL9DMbjtflXoxDpaQ5jrLGk2lbNWVX4D6GXWbsNunuJJ8CUS++CuHjSgic8R4xWgJ1jB0LdW/t6yVVN9ChxPaOhyPLtaaf9LsjYdYAmmXM4zlhljOXgmRMm8o5b4e4v7/k89tmOnKi6Zm4DEySkXfSL+yRc36Gk36pr7HxdMUjoIwMvR/t4fgbHZMCf18+VKyyYkoMuMvV4f16GQbmxZs5G51dKjiP67pD/pfmemL/nRxI/y2bZ/t08Ujr8GpJXTV9vWww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioN0f3Zqi29FW+zSq2ziGzRcaiH/OCCN3hQA+kOJqEk=;
 b=C7oPRaQVQRB0HiATBMqR6zOBdOAJl5zs4uI6XQJNPxQ9BZkql6JVyNutjuSfDszpVpA8nd5LzuFoE55ANvAQ1FNaxAT/JGqlJiCkf46Bc1xhyro2E+nW+V6JRBc9p9Y5BZM8i4ddb7BqIL+Dwi/QY6Trr7/RM3a9MjfIXHNd8FKO6KxUpUqttwKEvOF2qzVgNA4r/s2fY3XvuVF40mUtryUohIphyTyAvBnzsgnxm6HNEukCNlMe1nnABWe/rmxCj7b2f5CuezA26pcHU1kKTSSKMLZ3d+HZTuTEHzDD5OfOGd5BfLPDKlIWFTGdKyII1fvId/D0fVCdfQexMvbwmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioN0f3Zqi29FW+zSq2ziGzRcaiH/OCCN3hQA+kOJqEk=;
 b=trredStRh4Ia7zVqsEZOfXJ+FFQhd1SdqS13fROULZ+mUrk/GM0C0VXVz2V6PGKntWM5B11D+7OS7A/drFPF0sxl7l9SXyxukJQqRs1PYJAGfTFni61Kf+mPE0vJN38jnS4Cj+JObPjPIpqnht+SPTLoOKFw3EtA1wy44XEHd0A=
Received: from MW4PR03CA0280.namprd03.prod.outlook.com (2603:10b6:303:b5::15)
 by DS0PR12MB9399.namprd12.prod.outlook.com (2603:10b6:8:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:13:53 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:303:b5:cafe::87) by MW4PR03CA0280.outlook.office365.com
 (2603:10b6:303:b5::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:13:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:13:52 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:13:51 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 0/8] Move initializing SEV/SNP functionality to KVM
Date: Mon, 24 Mar 2025 21:13:41 +0000
Message-ID: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DS0PR12MB9399:EE_
X-MS-Office365-Filtering-Correlation-Id: 413d577f-a757-48e5-4c2c-08dd6b18c788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?alzlJ1UgXptIwC7I+2ceJkLtsNSSYNuEwdZ7mnVddU0ACmMXZ/8IoNOeqU3o?=
 =?us-ascii?Q?sypzOM3oc3SZU+PAWg6ukqjAu/9i9eUsWpVnIaz53OtQaTK8oo7YhBhMXpqL?=
 =?us-ascii?Q?01p2Jx4EWPYAOBlsr3JW+mB7746JHdNy90fW4Yz53l1gVpckXyjh6gjOu11Q?=
 =?us-ascii?Q?I7AGdDWFTaFj2kPx9lFLEw55iwgrfxutxU9fnFmiJqsDpFlB8km4dNnpEmyW?=
 =?us-ascii?Q?PkNubxGmxI99duU2vI0/Lmv4DVXYs5fz7bEU/3ktf63baAYLiKozEkce6F24?=
 =?us-ascii?Q?3gQiHBTYK9MLgfQUvhLFTqvZbx/S2ww4mm4eQHTB3JMx6EAuraemaubVUXXN?=
 =?us-ascii?Q?EuhbATKQIIxFMYkJqyih+Op5rqwzTNwspFMArJU37yGhpt92ZEN1qS0e+yvY?=
 =?us-ascii?Q?T2xFSY99+6FgDO5bB8onzrMVYGFY31L23DVsonch6vRA+G18mghbBj3V/kKQ?=
 =?us-ascii?Q?O249HBvZSdniJRFr4HvKiOT20kdC2LgLfsN17MhbIqY7fhzBAKlAQ6+EOTzD?=
 =?us-ascii?Q?9TN97XG7pIDHkcgmwoGVokML2QehWG/5oJ7Gyf9iz3cV4CRjCqf8SpJKmyqN?=
 =?us-ascii?Q?Z+0DfSEQeGDVd0u3M4l6f1geDkWrKWy6QsPGSb5jAXvLcXyRzO11nruVa7z6?=
 =?us-ascii?Q?s30vzLxuzOEbgqXSv+4ak0G/1JJ3DQaG7aaO5KAZK28fDkV5pFln0ohIM9Oo?=
 =?us-ascii?Q?VnJ/mxMDXqikQ8asGX2r8NvNbaluTMLFcziwxhQvdmDeRjcppi8Ut27GQgE+?=
 =?us-ascii?Q?2GhrgybErFuUYQVW5D18nkvz75LNHfIKNjchDPeJcBuYzNZ/rwY4arerwltE?=
 =?us-ascii?Q?C19zyI//hYBWpGLX+kPGSTCPZZwjqlrqDDSJKt8t6QNMyORZMm9VzpSgBQG3?=
 =?us-ascii?Q?Xk13eoV7ZrC6LY5WmUrlkYII5M+tc8vNr5nQhYK1T1bgKe0v+0m38Hke5U3h?=
 =?us-ascii?Q?G816D8AHsB+QNODxnmKzPQ2nvC1iCT4A1YWJt6MofjxCAU4DQrLzi0jsxvpp?=
 =?us-ascii?Q?umJLiy9iGZgJ8fJlBllzSJBJf9CoOJbwA+SCgzZ+N/u/B4vuqYPKJiDE5wsf?=
 =?us-ascii?Q?1goZMBWq2PuCuu97FEtOZqlTXXX3AUnAYn1tjP5QVp4uLonXhcXuoZgiCswS?=
 =?us-ascii?Q?zimMt4bbxE/PbzkifG9i86mL+BLXqkuRtwSr7v3NK923WJV8JmwluRnRDmPv?=
 =?us-ascii?Q?zeI09gNfkEUuY3P4ud65piQam8HJ/nMSpUxJQblf+C1EouHH1U1adENF3NK8?=
 =?us-ascii?Q?UmRhUT27ZPuLNm9xog2DD58HP2yH2A4A4E+qI9JSRBugLT3fR/fSgZ8dJGm7?=
 =?us-ascii?Q?R3kufVdP9LsYoNxopfWT2BhxuCwjC2Xn9N2sf581kI4tsJ+MfMxogY2sq+w5?=
 =?us-ascii?Q?CT6Cq7Qr4XjcN14i9J/HNKo9RIApwhZxgWQGcaLuYN6BR70MAkCb2mBigY4F?=
 =?us-ascii?Q?RUPCTBcZm4qAOFGVTH+cf2/l4SDVm2iiro6Jf8IL1J+RZRB3yuj5KAl3qhyw?=
 =?us-ascii?Q?fIg/iD++pLQeSzM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:13:52.6057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 413d577f-a757-48e5-4c2c-08dd6b18c788
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9399

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

v7:
-  Drop the Fixes: tag for patch 01, as continuing with SEV INIT
after SNP INIT(_EX) failure will still cause SEV INIT to fail,
we are simply aborting here after SNP INIT(_EX) failure.
- Fix commit logs.
- Add additional reviewed-by's.

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


