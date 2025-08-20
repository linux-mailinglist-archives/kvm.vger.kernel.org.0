Return-Path: <kvm+bounces-55208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 722A3B2E6F8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF60618988ED
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 20:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF25D1E1E19;
	Wed, 20 Aug 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T+AAO9Tw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162902D6402;
	Wed, 20 Aug 2025 20:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755723004; cv=fail; b=EM8BHUOMcxva4Pn6vY/dIlmt6Kpd5rblFDUhr5ScmHYuJvK5fJD4yJ1jjb+dh+Cuk9xKEWhsIyAczTkpgl9hcDtvT8zXKenEv4Zcf/vTCHiF2r1Tsl1YzvVLDgTM9rab1RylD0/nrODq02CwjX372hXLa0esWx7H6z9+2YhKHL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755723004; c=relaxed/simple;
	bh=5CuEOyRWhssYlMNIOuXrzRK3g566j8EP9HM/SZgq9zA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NI7Kt/Yru6KWkk78t78m06Rao4BdhHNQ2FLTTuynHaQBD+v4wzGDs84ZyNiJyEh5tvA7mWZKwtVbdg2p/jh0IjBUzCaz52feC6+NTccSNjSbt07/ffpEw38ro0xJeugULqa5YLFqn/94IJB0c0HJX9oh/v6oIJ2QvNX80cwgxyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T+AAO9Tw; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJlGbRuUGorI7OVq9vkWRHN6lzHxEidMtyDKxs72ZUq55ZK2R9fvgQofoa3QLHrF7u4wO4JeEer7GFFtaT/tx+CSvvy8Y7/Y4gwaqMr0a+j0N8Io7Vvwz9D0ACvLymDnsc96AjTwZYa3kcL7tS+ft3EJHdCYK4Ml4XZbLqBodCdz88EeVnXaaCo2qcP8nNDFdVQyyiTWFcqIxRscLEAlwR7J/00Eo/+jDH5x7XrS7aVMhsNu2HE5dxPpYnAO/5TbpTTEY909G0L/6LfX5ddQB9p7Ep5HHabB8sfgpEswfcE/LFItiylx6Y2xPltC5jrFXY9Ei3Z4DojLakRt45fIyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yMFHAbvVy5MtFGrWVc6OXKst/9NAaF6ckgdjGKFM6s=;
 b=atVX4/pyRZBloDQUL5nWVBos5peIX3/n9HCwIjruS9G1E5p6syRlVztlPY4yMJANmFfoY5MMZFzsSc7qg1c/kyFTSeOFjQkc2HRp+XxVzGpDOZYCB6ZOrUvNyLRMOMhuUTNSC/mK9dAfSj/rszyhwBK7WqVZAX0rjnrwQKzxIxRvTgpYsRYQB9RuG3K5UyLqbn4K7BeZ/m3AZgVFH/HfwCLF2hD94sT4bK/NAncezkGOtXj9ig+qEEDX4dubdiWwWhvTrFHWKgWBKyKJpHZRtxBdBLOA2mj0dJywhBqluMp1nAJWVqHMbxn3PslVki08FYVXPQitqOfI0yh0WbVS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yMFHAbvVy5MtFGrWVc6OXKst/9NAaF6ckgdjGKFM6s=;
 b=T+AAO9TwVXjsmJtWFi8F7tjlL/pLvJN3BzrkSgDVkxF3+JFPjx9ClaojKkMABJIGnUjhnYy7lrWzoA+d7HXEi3Yv/QbZ84MJJFLV7M7dOapjkOA0zY2nlnS8Opw6Hd9E/Z2s7ALoIJrFDYkNy03KoJSZ7sEHUhjZeol5CRMrWjI=
Received: from SJ0PR13CA0159.namprd13.prod.outlook.com (2603:10b6:a03:2c7::14)
 by BN7PPF02710D35B.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 20:49:59 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::8d) by SJ0PR13CA0159.outlook.office365.com
 (2603:10b6:a03:2c7::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.6 via Frontend Transport; Wed,
 20 Aug 2025 20:49:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 20:49:57 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 15:49:55 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v9 0/2] Add SEV-SNP CipherTextHiding feature support
Date: Wed, 20 Aug 2025 20:49:45 +0000
Message-ID: <cover.1755721927.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|BN7PPF02710D35B:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bbd0970-0950-4cdc-d8e4-08dde02b1fae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EFxGod+34Fp/Zlxq3kVTx0q0QqQafGkuq84zw51NDq1kGtb8orsJlxcCV3YD?=
 =?us-ascii?Q?sgYCUKYPHEaIboYF3ccgJHqDr97Wo0HgGFauwlYOEaWGt3lqqhVKp1Ka4Gat?=
 =?us-ascii?Q?HBctESeYX0tkFINHPRLsykWvxxbOvEW3thXzi5BEOGYjIUcbQl66lZrdvta0?=
 =?us-ascii?Q?g3QvXTy51kvHWMUT2RA990z3N5UCZvP8XO3mYc3P+m9TeMZuxd11tGJn/OzU?=
 =?us-ascii?Q?S5qizxI8bGgPfMEZ/AqTXROpgkD1jCT6w72fxnW3VAqFA2p9rUjoVHkvUeZR?=
 =?us-ascii?Q?JZ9MNdh1cjpYFIWz5pUoyfQzCNCpVPmJBn1efEo8N8h6HtMZ0GgmmLoKg2Vd?=
 =?us-ascii?Q?cFSpxGRWVJUA0coN63LYDqRzJF00UIRBX7ZnlO4qha3KXjMDzwu4/TSCl6/6?=
 =?us-ascii?Q?EOqVyKxJiS1l72M59vwkoGinlATFQ8ZQQuac8Pbp7MJfGvdAeTlsmNGsyH+y?=
 =?us-ascii?Q?lk/P0IXRVBDwV4tvaAJqCLxq+U60irKelYbEOspeIw7Ptl08vXDodRYI6/xR?=
 =?us-ascii?Q?YLwfc4Tglm4TaCpjf1VBH3eS6KzBLUhpSllP+hbPSKlZNBbytZ0o8TM0dDKh?=
 =?us-ascii?Q?g3RzqKZlFoO82KBbngSdrmfH18tIfDRE0fMhFoA0MIStsiWZ7QJ3T+mUh6ks?=
 =?us-ascii?Q?iCD0m3fAHFhvdwncXDorntTaab+pKFFOQcHqEl5hrrseuu1NpCZ/J1luadYi?=
 =?us-ascii?Q?nIkQVKj1PeUROpMDJ5V8gPw3IPV33FlxMnpuDDl0jWeR5rlEbltVWAAI7IuM?=
 =?us-ascii?Q?LMw3xrU6XMMWMlNdvfrHxkTlWY6jjaRetsWZbhkGYnWIzP5mueZqb4I5G3lc?=
 =?us-ascii?Q?6UoYZUIpKYXifkOzuUmTcbsMVHjaG1QNVbS5/1iLaU4WQCMmB9ZBMEgU0fzp?=
 =?us-ascii?Q?WF+2CpraN8GKZAToBZE8kGPFAmO8dZ3DOKWyGevfgzYrTRViAbaj77lFYeax?=
 =?us-ascii?Q?PDMJDDhY0mA1pdG8CVbwD+S3eio2CShq2xeEEKXLIvNBz+v3D6ups1BlkTgp?=
 =?us-ascii?Q?waBq4DCTq4OTkthhnNHT5qGGvV7HNKZ3jpID+WGR1W1usZezYHrXFwyNfO+X?=
 =?us-ascii?Q?Y38k9guJUEN9uDBh/lEP8YUaB2BF34O3M5J6BseFZ1LwlYLaY1XGt2rHxQVL?=
 =?us-ascii?Q?DgxnkaQWRYYlV7tmcVA7f2LPSw2qeSz1mRuJphKjKh59+27D1OCbXnWSbF26?=
 =?us-ascii?Q?s4fW6ox/Bq61dEMHHzy1/bVDQPcjKxB+s8do6FxKTfxHNrWsnXWsXpXR5/5a?=
 =?us-ascii?Q?cMSonh9ceQliC1TK8lGq5wKpXjQpCDBPtUp32QBtn2h10fs7LA9Qv9tdO1k7?=
 =?us-ascii?Q?zn+6Q0t9wD/7tToeLc+i+1gZx8FRdSbWuw3wG1m0cqZtnSYZw72OnPufrteb?=
 =?us-ascii?Q?BMEPOUBkgZ9utcOvr60Btvr4Xyxbd8IsRDyZ3/Gfb4bKbxJv3blPADqANlSu?=
 =?us-ascii?Q?8Hy8FZtAGez8KEVGMyFUyMwh6T2s86CsFN7uMkSDDymbo524IXLcrd7EGRF4?=
 =?us-ascii?Q?BuzmRxPN1oDT8wAo2yTrKmpqJf4PeXKYSp7VME9BUmMvO+gAaqJmtKloHaUl?=
 =?us-ascii?Q?qrdRGHDObji6++ZIA/U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 20:49:57.4902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbd0970-0950-4cdc-d8e4-08dde02b1fae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF02710D35B

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add new module parameter to the KVM module to enable ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is '-1' then the complete SEV-ES/SEV-SNP
space is allocated to SEV-SNP guests.

Based on linux-next.

Depends on the CCP driver patch-series for SEV-SNP ciphertext hiding 
feature support:
https://lore.kernel.org/lkml/e1740fa2-f26c-4c3b-b139-b31dd654bea6@amd.com/T/#m1100d65b99cbb022c8a2d04ec88082d3ba68a219

v9:
- Drop the special case of the module paramter value of -1.
Make the param a uint and cap it at that maximum possible value.

v8:
- Change module parameter to enable ciphertext hiding to use '-1' 
instead of the string "max" to assign complete SEV-ES/SEV-SNP ASID
space to SEV-SNP guests, this simplifies the implementation and moves
most error checking to the module loader itself.

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

Ashish Kalra (2):
  KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
  KVM: SEV: Add SEV-SNP CipherTextHiding support

 .../admin-guide/kernel-parameters.txt         | 19 ++++++
 arch/x86/kvm/svm/sev.c                        | 68 ++++++++++++++++---
 2 files changed, 77 insertions(+), 10 deletions(-)

-- 
2.34.1


