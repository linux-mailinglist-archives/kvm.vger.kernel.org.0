Return-Path: <kvm+bounces-51215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49831AF046C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 289E64485AF
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C14284B26;
	Tue,  1 Jul 2025 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kkvu88fu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B77823B60B;
	Tue,  1 Jul 2025 20:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400888; cv=fail; b=MeJdiiX2DCL1skYTZCnhgUEoDj9tueddw9ZyQJGYdSOuqpJor1Z81fI3UEh1rycTTUBlSveVSPm59QFPJI+gu9AlytqCsyDFJLEiu73b8h9hU4GKRvsvgZrjDTbcIBPQsSW1cKLUyyhhAlqrTYd5mD68Kh2n0j+jWSsNVKdFT5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400888; c=relaxed/simple;
	bh=yCEw89DFwh3GyOrT4icPgJ1Y/1MpNaCEoB2ZiEtshRw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FKZoTwjZPABlg5uFcV268/pal9mALqrzkbT0eF6X0s/3AR2pMRHV5WGRsdT69jwG5b5cVcGE8mkMdbyTMmj217kGM3CEc9KViyEce5HG6f3OYUQNyKgu/N4Ceruml/VgC68M3UUmI9ymkRHMX0wNtpx9WFpGWb85fAsj0nmpmR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kkvu88fu; arc=fail smtp.client-ip=40.107.101.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmzzOokgfxIh+bVPNUGEMElHBcZIsgVhXa4EdaaXmBTnUT5F0IneN9IOZHRQOOeHPGo/6ncaQkCvSUVJEcyqtp5g4+426OXlejp9swkTkh5CCltjDJdlJ469lk9NxXVgUpAkjyhudbl9tWiYb5mcTrBgisx4tXR/HdEmrM+/1R2y8W7XJ71vA44K8UBRQ8kla8y2lBlkqHYnDI1OKKn+DnpWw8xcA77DJeF1I3kn6CUpsIv3H+vAGOcp7wlxx9bWxh+wvMjl2cuM1n08uu116719AwPf91jw4gMxw8I3bxMyfPO1duGFyFQV2LilNfuhowTig/DR6/FAka9E5eoKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dD2hRDA6Jz2yUi0F1VuTG9ingGTJo0Kq3jKl+pEb5c=;
 b=lNdMohPquhRepWSTtaO3lkT+ZN+AbvOSWOPQko7lncCn/Y0jfppUFparQ1wV6t5NjReKxdlVJm6/PL4Rnb1KA1uWBw6emmI4Pr3YNbehObiFjvg+tqM/BUu3X4djJbhndTbLsWwZJ8Hns18EMmHHoflRLCMoWh41mEFZK9EBQZe3ZgIKt1TMkwcbe/L7SMr9IJgCvN0wGOJVzQ6O9gUCyen6W2h3qv/X3Gd25W9K5tuScp54BwwdgqlNQ6F6QwcEQcUS/CT5a8zt+MLgfSYSia7zBGdlp+1rzoSWeXsvYNa8O7WPxBLMbh+F0mXMORXxmAAe/77m+G59/zyiTB/Ueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dD2hRDA6Jz2yUi0F1VuTG9ingGTJo0Kq3jKl+pEb5c=;
 b=kkvu88fuH19rHrTPEVSVe2ZIDe1LVbWQVdEliKvzwlTk54gn0asYdtasf+UXt18qfFFFOfcI/Yeknouf4+CxQKKjkcHjHa6fJSSKp5J62IYC+xsROlwU1oeQUfuqYfvHzc8GKYiXfcVR1xl0pdzIwxeT60KNfuJABzNUpxcOaaM=
Received: from MW4PR03CA0177.namprd03.prod.outlook.com (2603:10b6:303:8d::32)
 by DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 20:14:42 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:303:8d:cafe::e0) by MW4PR03CA0177.outlook.office365.com
 (2603:10b6:303:8d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.32 via Frontend Transport; Tue,
 1 Jul 2025 20:14:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:14:41 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:14:38 -0500
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
Subject: [PATCH v5 0/7] Add SEV-SNP CipherTextHiding feature support
Date: Tue, 1 Jul 2025 20:14:28 +0000
Message-ID: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|DS7PR12MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: bfba663a-ff65-4a8a-547c-08ddb8dbe9d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8X5FdhsfWysR84ZmOMEnauOUkDeD3OwP+XIq0QqYXu6TFXSpY14N/6LPVOlu?=
 =?us-ascii?Q?ehlfabkFhzIr6v84hFOF9CvGMPwrOmYMc4suIU06HpZXnQmlPT4vQTsHnR5a?=
 =?us-ascii?Q?WlurwT5QXe6crcX/qBxV/y9GDVU+qPieGpIjtFbKGZYyjWlfxwiik5lkFXyB?=
 =?us-ascii?Q?DkL6Aku0XwbCRcErLC6loExWaZ/EB3W6t9TEUw3QrwYIdq2k0uNsK+SPIgU8?=
 =?us-ascii?Q?O0QbHwyUFx1Q8T3YHgRiK5FsGyjLlBsfvHhwT74nt8YSbK6+b9/ISKdktEqd?=
 =?us-ascii?Q?XBvZnK/iE0D2r2pOs3yiXBRLT/Al0QBUMRAnGHq7SrueLGE1F6wY+xWcIgTI?=
 =?us-ascii?Q?iswGp23bXjurk5aZHzU0c55fVWJQjXkrpLv0tQniH4VQE98mSI42iirCCx7C?=
 =?us-ascii?Q?VqG+mXxX2Td9sMlrjaQpBNR8LJv05B8/g9f3DNyRhq4nPHpJnIfzc1GJ5ltN?=
 =?us-ascii?Q?Tm66XdiT1U/Zaqiqm5mbM1CNsAAPLYBovZ/Bhfv1NJABM764YX0oV1q9sK0b?=
 =?us-ascii?Q?F6y0PTiWcj0tjQxhH4e2pWU7meNSOSuMcXiUC48Z5MwPXB5rEYL4l/0/Olj7?=
 =?us-ascii?Q?mhxSUjahpdWK8S8QmGoUa2+PtV3GGueaRL8kcuUDjvCYs1/1aABalZvlS8Gh?=
 =?us-ascii?Q?d6VszkowSbc4ye3To2auyb47YI1KHTU25DTecx8AJb5ICkuK77A0OWg+adrK?=
 =?us-ascii?Q?YHVtW3KwZAo4qqoYgBQG2jQjNk8K/BKCtcoPgWkplr7DWbxXRt/W8ZqifkYe?=
 =?us-ascii?Q?SH/QEDWHlPZuXdy6bjZ0nHlZ1Qkarrp3jpmSV9pwYvKsBM1O0BgQsdf1g7bi?=
 =?us-ascii?Q?LhOgsCnuF8e2CQxTnbnHpysSZlKPzWkHk1U+NZygmuf5wxeSXy5F+/kvZu6e?=
 =?us-ascii?Q?BxJJla6PRKpkxQgW9bz3XrF70s4QwC213mb80QqtI2w3GocHu/xFoY0gYurw?=
 =?us-ascii?Q?/hx83UWDVgt8h5qSCYFnI+JFvZH0khpkrLI/9lY87EP+NfTHvkJ6xH4WoVwV?=
 =?us-ascii?Q?QS4n4xQ8kR3TytlfXOSDQ9c4KTT7XF5sFKlDSXNZtiQmIkD2pLzmRDTHCWx2?=
 =?us-ascii?Q?QKDFuYB0/3k/1yz2FcEvzgz8EcJMPEo431Ly6p3LcHY6esHaj+RYjuaHBLJu?=
 =?us-ascii?Q?kadf3OH4gubrQc0Ad9z9wkF1mq06x97FtxGwCNCxGd7SWAcXNuKIduNwmIiB?=
 =?us-ascii?Q?tznURMxv2pF+11h89uX+VQNhjVfJhJFl56yN7emfE3cpyXjpeDrWbjTq5mtn?=
 =?us-ascii?Q?+X+zLFzGoiQftAUy4QIYdHpVhNPBBmZbx6Tv0pfCzKhkXDBuRiBJZnAHkgbc?=
 =?us-ascii?Q?5Z5sXj+4UTgF6+XsttB0KdU717XEjuDH9Zgh2ocwCcKnr/7vAFhbg3iYSP+h?=
 =?us-ascii?Q?oNsv/SkURUZTjZEE9v2DQfeurBlvQ+mYI8CJiO7uUpZ+L6ICH8Jixd69bO9B?=
 =?us-ascii?Q?ltc6wJlQNojuNZxEcB7QQGUZ1yMypmKLSZOCmodpAK8hQWVOcfFVa0+VflVJ?=
 =?us-ascii?Q?tf3wSxuU827ggjAqJtT2/yyEDC/Zcsw19rPBXfFqR8QY+njKVVgQ0qoZwA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:14:41.5621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfba663a-ff65-4a8a-547c-08ddb8dbe9d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

The SEV ASID space is basically split into legacy SEV and SEV-ES+.
CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
and SEV-SNP.

Add new module parameter to the KVM module to enable CipherTextHiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is "max" then the complete SEV-ES+ ASID
space is allocated to SEV-SNP guests.

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

 .../admin-guide/kernel-parameters.txt         |  19 +++
 arch/x86/kvm/svm/sev.c                        |  94 +++++++++++--
 drivers/crypto/ccp/sev-dev.c                  | 127 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h                  |   6 +-
 include/linux/psp-sev.h                       |  44 +++++-
 include/uapi/linux/psp-sev.h                  |  10 +-
 6 files changed, 273 insertions(+), 27 deletions(-)

-- 
2.34.1


