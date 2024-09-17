Return-Path: <kvm+bounces-27057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E59C997B47D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 22:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77F621F2577D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 20:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C2018BB9C;
	Tue, 17 Sep 2024 20:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CfOKPR3T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26213777E;
	Tue, 17 Sep 2024 20:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604134; cv=fail; b=XK7sD3oIO6E5GIU0p2wHk8GgbxQAA7tRSNVmFlWIk+Ha4xgNLyvRkyDjauugzg73ANtF8AXQuDG86i6LO8XOESZkYGfgcoxGqpuogDeQQFRNaJGM0GoXvnJc3EJTrXyYAPgOC5cCEFiP7lZGbsY0wjEiQyCgUfgPUNDFejd+XSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604134; c=relaxed/simple;
	bh=ZzvI/KdCN0hpptFF9PoFLiYdIfFdJ+rS2sb9gO3Fn/Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m30S2juxEieZ9Jvy2dkTXp4DS+wA+XMg3jpJ54xgfSPm2wNKNxBI05gpPHuTAnqCi2qmBAcvjU1uDi57y0/XxH512rtzVqPrV+MEa3pcINu/OujZzzqJ+mHcb0auYAvxx2wGPVHP5mMfeHG3fY5NO7y8Jawdluy5c18FfLZ2kxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CfOKPR3T; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iq1kztq+D7CnRbTyd6CeED3KkwGFKny+vP/YY0rtWEgH+h7TPnVDpwQ5SPaJcCGfRFYicOu6sJnMGoLC4Vcel3gEDgN+yodlPSEHzF4m8/ecZIsMNSZ+xk+ruNBJE9j/CwvNDlQXR3xH6gLNyvKImud01CDiJLQp/FFKEPnuGNm4Sv1fKqlhfa2zwTw6ng9bGAVchzcytGcfEMCxbYwcDcki3f8wy9lOuBrG+Nkbh9FMwFaH+7+8RbG4sm1NzPHQcpY3ceiIgwR8RgdsdUmrZybUxJTGBsYqmywjPbTodeIPFxUMMU6G/dK+4/hBaE1P0SCJ6AsBxsivi7rZbt2nEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJQ3vKgpt68MV83MZwcbBV1ks5AtEuGvL6neQdoETLQ=;
 b=tBNPLIjB8wJHtku9QQexFsmx1TanJgWVgi8+x0NBJ1z56WHY/6OJqo0Jr45rVieVhDykNSsM8ZdPQWFT5NRD4h5x3vGHqfhU1ZX7veOWQL4xT8PzbvYmjkFpYoQ7kB68ck2E0Nr+XYH8rvvr6t7yIVjsccgEGuEIE7ftgQEIF07BPM9M041zcafUo2+e0mEWAx5vcveh4L/M17GAH+pRNe+aAvpXi+uAPZ9tE8Bd/Yo87wTcd3YqW7am/xocySlAM6mdnl66EDYOsscGVw/rCvcyboGjOh1aokiXiJuD8785QLbkZ2+z6wPllFVQfC9w7Ps0SWCL8Wo++EpGi/ySFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJQ3vKgpt68MV83MZwcbBV1ks5AtEuGvL6neQdoETLQ=;
 b=CfOKPR3TSiMUDqzu/WcaWZGV9iB2GFNyBtDWO0jIJUzHjpVKAQoQLV1u2AjJMJJQqtrcDy/AVJ+m//0l4arBRhpFq72dLX3O6UGXSDh1fkkcJBeP67WVMRpPCpEVe15zUbhzKGT8zVugdfAZxzCiMKovP1vWgwm8rGbhmwrx0iA=
Received: from BYAPR04CA0012.namprd04.prod.outlook.com (2603:10b6:a03:40::25)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.16; Tue, 17 Sep
 2024 20:15:26 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::18) by BYAPR04CA0012.outlook.office365.com
 (2603:10b6:a03:40::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.29 via Frontend
 Transport; Tue, 17 Sep 2024 20:15:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 20:15:26 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Sep
 2024 15:15:23 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 0/3] Add SEV-SNP CipherTextHiding feature support
Date: Tue, 17 Sep 2024 20:15:13 +0000
Message-ID: <cover.1726602374.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 7446bf52-d969-4e53-338a-08dcd75577e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xguOO+yYuwnpTmsGBtRA8+BiAUf4HKvueC02iKxXDwzfAe2yDGOT+My1ALkV?=
 =?us-ascii?Q?R/nzYb9WSPqmBXMzyKlB55d1+SBHlHOVoOXPA6C7yAhfX5aqHBsy1vMrM1ro?=
 =?us-ascii?Q?l6UpfmToQ9nN2X0bshavUi3ETngAg1XmQqUbuBhpkmQKEirAjPxa39Ojfrpx?=
 =?us-ascii?Q?Oe7pcSOwg+9wzQYg4/i/cSatOG8k2371kcA3zZxqIlPpUWAQQru4g9cCANh0?=
 =?us-ascii?Q?3KT+JYm0uBBYZf+3C5i660MEmLS94t8M7dx90t36vjtgD7VMOVZkU+WSLsPY?=
 =?us-ascii?Q?OZ6sKwcU0esrWXVqH07Cq7bDSKvoe1szsHtv4cWC4tVEnDY/tRtY8E/cZd2F?=
 =?us-ascii?Q?Fb/YTRaU0qIdWfSQTy0dJVpd+nih4OZAfwUNPMMhWgTe60HQHbVVrSYsSolM?=
 =?us-ascii?Q?Xe+AiHml/0pct+U6BSOVRjcARv4yvvReCLct9yqD02mM2CjWUHKayhnYbbOe?=
 =?us-ascii?Q?lfZp+/cfcEPlxjUu9+NpTDFLfOn+i98E61Yk5YU7On14JvHZCgUmZFjNmzag?=
 =?us-ascii?Q?KYarIKrOw1cZLAZqAFgTA4bL83DqgTVNWxOdz+xLc35zbTFN4fB+81tm3i3x?=
 =?us-ascii?Q?VgIjcFl4Sj3Q/LN/XEMaWrHxJYTYY8jgI49fsNAJug8rRUS83rk02De05Q4R?=
 =?us-ascii?Q?SUTrDOSdxCqDpi6wUJoJFxrjFG8A+ImKjKVxt5MNecAfBJBvpNAdBC9CRBTx?=
 =?us-ascii?Q?x0d5uyzfDo6pCyG/b706tjLAvUqNXUhRvFuhx5oFKuBEzrKFoQq48y6tcpad?=
 =?us-ascii?Q?iZVIrIOaN4M2oNPTzdd3lQtLt23BUHSarevwV6DfYRYD5is0hI1tzU9ubMgJ?=
 =?us-ascii?Q?I2SBD4/7UuKd+n8yqYWeBJGxZRIVtXdvWLWsUvpb3ODtmxzSeL42cDS5Thn9?=
 =?us-ascii?Q?7cmQXftbzslHYba9YhhK7BSD5niYI/Y0ax+XxeKSaUE12H702oZq1QImbbM4?=
 =?us-ascii?Q?SL3Ejv241ueea5ocQoy0gHsEIIAzYPztl9uH3i/pnyCiKusz2dHYZ/Vz0mej?=
 =?us-ascii?Q?SOYpbstJ5iYTgRBnLFk4QGXH3yM3jFlo6KwEIpHF1UR5yEQ/jgMaxqi7Z50Z?=
 =?us-ascii?Q?CEjARcXtNViznQFD57H6qXPsd0EgYP+B0xtvqgkH1BuGtjJEicnRh3lxOG5i?=
 =?us-ascii?Q?2cP2SXyRL6eJopnmLaQciPXfou6p22VSJSvh4Y4oVHViOMPLeHS6x2MAYZeq?=
 =?us-ascii?Q?kfUnJ7RYSaJ7p9hkBpENXHxC+dIfONNY8z/7CYb6+Irx3FdL0YxGHtu39BvK?=
 =?us-ascii?Q?l34xoyoA8RMyeSCVtwtLIGNuaXuJAuv4+1BwXBxz1zGNerB6VHIrJ8rl5ZUG?=
 =?us-ascii?Q?4l3wk3aXvuExBXeJ2LNxM+lQoYx4IZ59Qs+wOdhBBEd5Sejq9iLT3gqv1bOf?=
 =?us-ascii?Q?tLP+iukpUFX4x15p4Lf3oCeOJTy2PWEjf6tIksXcs+ypYGu4vFUDxJ8z9Oho?=
 =?us-ascii?Q?YTewWlOUAk1YsUYyKdC8CzVYGmCP1byp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 20:15:26.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7446bf52-d969-4e53-338a-08dcd75577e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and 
host ASIDs. All SNP active guests must have an ASID less than or
equal to MAX_SNP_ASID provided to the SNP_INIT_EX command.
All SEV-legacy guests must be greater than MAX_SNP_ASID.

This patch-set adds a new module parameter to the CCP driver defined
as psp_max_snp_asid which is a user configurable MAX_SNP_ASID to
define the system-wide maximum SNP ASID value. If this value is
not set, then the ASID space is equally divided between SEV-SNP
and SEV-ES guests.

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

Ashish Kalra (3):
  crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
  crypto: ccp: Add support for SNP_FEATURE_INFO command
  x86/sev: Add SEV-SNP CipherTextHiding support

 arch/x86/kvm/svm/sev.c       | 26 ++++++++--
 drivers/crypto/ccp/sev-dev.c | 99 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 41 ++++++++++++++-
 include/uapi/linux/psp-sev.h | 10 +++-
 5 files changed, 171 insertions(+), 8 deletions(-)

-- 
2.34.1


