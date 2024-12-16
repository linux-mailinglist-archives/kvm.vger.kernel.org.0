Return-Path: <kvm+bounces-33883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7236A9F3E85
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88F4E168E6E
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5331DB377;
	Mon, 16 Dec 2024 23:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IIxlMfCt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71342A9B;
	Mon, 16 Dec 2024 23:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393431; cv=fail; b=F503IA/Rbw/yjr+CzYEr/Xah3WE9OyDiyBZ0rLsDm0W4ERUQD8e9FhJbB3cVSOOkLTKTAfnqtgn6XWE/8DoegzjJ2wL0YKF4muCLJSi7KzD2Lupu6ixWjqjmBhqeuci9x3NFEsJvBpCHziePziayq7FlL/ZaazZbaLBi2MxTS4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393431; c=relaxed/simple;
	bh=dJJemfUF6kQp0OcoAQJ7Mak+U//dkIMJ5/Sr5zr/2ns=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uLwViSznsg8ISFp2AJhSRxipDjw0A1w9llcfHCpuUbWXdAnraLGUerrIctMVJpfSi6dvtpRqKjAzsZit7MJe9jenrvwvOXZges2kFsaXvBA0nBut7+ptEy7/fc8QILxKmHDiTpd83BFAlecUGjYFRwqZYV8z9a32ubD+ykdC4Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IIxlMfCt; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cryt7Mvv8nNT+lhr86FbL+GM8m31TJN+od5g/Yg265hK3R9qVGsevxThhGRatWM7xiYJTrq1pwd+AgxciLSHE0HSYzoSK4EtZY8GhF7khnXwtimD3GswscIgA2d+5V+kiovMGhriYMh2dJV7Dy5zAKFtWXdIQKjatCCGUNSwbNpDQCkaT9O1MK+Pl3x7jEP2OSqBXUYkmUGeawTtRbgOZWGv0VcW8KypNzqSws+TsEphHNHkOApdbAWpSUo8n/M/szaEGIcSLaVDEO48Y/qoCP7+u3uht9EFPZJi6LJYehyT6uDChcZS5R2NyskLOM2APuP8exJeyik2x90H1KeOjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVve5oCMY2RZJ1nGX7TMKGmjTdccGcOH96XjIVdxu/I=;
 b=n+58kmkwr4mtdgLRjPC6HKsvRg9rSkyIjFX7cuFPK7e8jdTMyoLIvpwx5dAZywA9JBv5ezHvdZbV0+V6z7V5neuoQTucSEs4Tr3gATDjflxbYopV/3EQbYOuGDFimtK0Zd38t+WOKfqi5lY8fykAH1+rcstWeujZlw/vX2jp8o56HRRv2ZoU/1ivY3QydSa2ZF7XdrJOf7yIbPDP/SpTgxF/MFF+CxhqKgZhQngaot3QwPIZwVtjW5PDeOrzMS6tWd+I+mBOBs2XTk3IDGXNATY7Al6QMu5gi9FaWVL98Gj74d/ybxKruOYIofPFRCyGycxaz1gEh7A+F+hc26+plQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVve5oCMY2RZJ1nGX7TMKGmjTdccGcOH96XjIVdxu/I=;
 b=IIxlMfCtBgQeyI3HRTcescPu5iVUSttplORRsGVUlI6uFZY+2Y8HnWEuPjuprwKmM8W0UXRCFgxTE1FUy7/37Eo3wOaZo1LJWecwgZhq/ZL4yNGqsRH5hJWjEg/q3mlsLMPRQJUx6/0I0naPcqZb9M7mIBrs4SZ0Tg+jRi2HHdI=
Received: from SJ0PR03CA0188.namprd03.prod.outlook.com (2603:10b6:a03:2ef::13)
 by CY8PR12MB7315.namprd12.prod.outlook.com (2603:10b6:930:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Mon, 16 Dec
 2024 23:57:05 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::73) by SJ0PR03CA0188.outlook.office365.com
 (2603:10b6:a03:2ef::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.22 via Frontend Transport; Mon,
 16 Dec 2024 23:57:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:57:04 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:57:03 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
Date: Mon, 16 Dec 2024 23:56:54 +0000
Message-ID: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|CY8PR12MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: a820b379-cf2c-4b69-8579-08dd1e2d57c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G1eA2CgVv8OK5SJDxapUWsOzexo7GuHyal5FUf9TOyGDCC1rAOWQbCthS0k4?=
 =?us-ascii?Q?awpR7Bt4xir/7HfE5tWdN7+6Tey56Dfj80RD2xRh3ykbbJF3awg6+DFwqygS?=
 =?us-ascii?Q?3Vp8JKLMcKN4QdSR0X6iZKaKXwfEAynbCGjUmpcNFvQpsKE1vLkUtXrDlVVy?=
 =?us-ascii?Q?F+Cd0/5gph/eyPP89Sm0PF2pkNBFz47s+/xGnNC4DMjeN84QtMHqWbcjJGPK?=
 =?us-ascii?Q?4F5+WRwHThbHj6Q44KoJCZRKYjLuJWmYnHZIjta7AYOd4JC6bDRYdsyoz068?=
 =?us-ascii?Q?PIQG25PtgEAvnUQVRm9xgpOSBB6zdYKnkj5NGCWuwsxt0ywkg9WT+ofVJYSE?=
 =?us-ascii?Q?tUr0J9Qg7utGwM1rnuewKp8nWJ3/rbcaWg7u0W5VMQkOBK5/VoOJ6xfbAc8L?=
 =?us-ascii?Q?uGeZ8/VhI4j6uxnKI1EjO5fVShW57U2ZrIiku6dvXaZe0Qnd2j77ooAZ0AaT?=
 =?us-ascii?Q?T2SxJvvb+/N+TjP/pRu9aHatlzTSn/wLZhUha3sPg4KAPNA4sSdbapOKu/E0?=
 =?us-ascii?Q?Kn6hIdfy5DYE31LYuaCpF5iQkf1TQR6TUruN6MC1SJ4ZkTik3juYZrVaks8J?=
 =?us-ascii?Q?SdHAWtG4K3Kq0ctU/HWUHoC9qPsuOYFaoKVbALDNBj6w4OqelXzVPLSiUSQz?=
 =?us-ascii?Q?toi3mccdbHD7sOV0OBvOvpd132kNemaW7XrA/t16cSrIQrZsbOI7rwEL655c?=
 =?us-ascii?Q?DsQdhEXZRvajtPgBKCxfPcHO5Glqei3r7BxzazCJc5SQykwi5UUeZNkhpst4?=
 =?us-ascii?Q?B0sK6jXdo2jjVtCMkwdfTMvpPfLLwYBdnZ43xvHmExLfwX8hs5WhvAhXgPOY?=
 =?us-ascii?Q?P0wWkG/XqCvGw15rnU6eellPnialrnkDjbWJ21tRnpAM18Ssj5Ls9rxLUbKp?=
 =?us-ascii?Q?gLSwYEG+RvVjQZ53aXVWMW3NHA5ApG0jZ9PtFstD32KhRjWbpo0OkFtZTwG9?=
 =?us-ascii?Q?jWkSaEHMmdfrZ/6U/jkHZtoOByCge33UeoH9BeQgzz4GiEvNP/4Wgob5UBtW?=
 =?us-ascii?Q?Ag3JNrcmWe4saPpZTxmVNFZKxqgd7E2QpWBItMXiGVz/d3tDgNCk8TN5zD7d?=
 =?us-ascii?Q?LSPCpAT1O82JB8d0AEHvA9xTTO84Zx1ZRXurSnXN9I5yzs8h0gAm1DicWFsj?=
 =?us-ascii?Q?OB4eWUtQEVC31KElsKOD7Wtw2dG6xrejIcXT5eijVBTuZzM2ztmhym4eIpMA?=
 =?us-ascii?Q?L3ONiKJA5gC/v3uIpAW4NNPkw3EThk1C850ak91a+9FY+hG9Q/VMmTG+Q5Rz?=
 =?us-ascii?Q?m/0TbBEjZ/j7Csz8Sh49Couar6rAxEogcoDHoI7SFQcGlR/DT5a8P0789Kxp?=
 =?us-ascii?Q?83Qt6cPLUSJ5eKgYCwozkq4JbH4zo2zulSlN1Us/WJiy86HXlQXSvEaHkNLr?=
 =?us-ascii?Q?3J30NhrsIp/wwpKhe1SgIa0f8kWEgta2o/Vau2r/zVDuieyai7+Yk+otqRe6?=
 =?us-ascii?Q?QCBL5Q6rb7IIcVcM9mDRxLkcwYBxc1FPxWINPgGn/cUscagSMnd35ydfk2UF?=
 =?us-ascii?Q?WZEETG9z4j7nOWw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:57:04.9840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a820b379-cf2c-4b69-8579-08dd1e2d57c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7315

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

The on-demand SEV initialization support requires a fix in QEMU to 
remove check for SEV initialization to be done prior to launching
SEV/SEV-ES VMs. 
NOTE: With the above fix for QEMU, older QEMU versions will be broken
with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
older QEMU versions require SEV initialization to be done before
launching SEV/SEV-ES VMs.

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

Ashish Kalra (9):
  crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
  crypto: ccp: Fix implicit SEV/SNP init and shutdown in ioctls
  crypto: ccp: Reset TMR size at SNP Shutdown
  crypto: ccp: Register SNP panic notifier only if SNP is enabled
  crypto: ccp: Add new SEV platform shutdown API
  crypto: ccp: Add new SEV/SNP platform shutdown API
  crypto: ccp: Add new SEV/SNP platform initialization API
  KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
  crypto: ccp: Move SEV/SNP Platform initialization to KVM

 arch/x86/kvm/svm/sev.c       |  33 +++-
 drivers/crypto/ccp/sev-dev.c | 283 ++++++++++++++++++++++++-----------
 include/linux/psp-sev.h      |  27 +++-
 3 files changed, 248 insertions(+), 95 deletions(-)

-- 
2.34.1


