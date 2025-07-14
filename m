Return-Path: <kvm+bounces-52365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE35B04ACC
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C551E7A1C1B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D5A242D6E;
	Mon, 14 Jul 2025 22:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oy5ranA8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78F62C86D;
	Mon, 14 Jul 2025 22:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532768; cv=fail; b=WDf9w+WISlKag26EaTA0HpSTOXPU5M4jw9SNmqbsHysXx5iDM0Olfh2kA9qG396FCZMaJ0QoJfa5zJuzVm0eQV4/FBg1mFEHAcM1y48WSXfjBqkC0amiUtC6pv4xRAkAadGsC/jdCIlSi2kWIMF3oGXoPfdGx4VeIbD+6ZWYBhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532768; c=relaxed/simple;
	bh=7toR4iyZuYylMZ8F3iXPwU9OzjTf+xKPNeQSnLZseT8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T+grtEeG19OPWRHLpNtvU7XoLmFWhaCSGoOwjxKS/PDsU/c675kK2vI0Ih58VVQqxZDG7Xbkjjesq4qmFYF/44o9VBSoCps+CyxD/wUcnWUuSMufBBi2bB1ytgU/S7S7oPn8VHk8byHNvQsHo87J9tiFUUvvS/kLYFnApkRH/g0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oy5ranA8; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHkRAIVkjDyX9DajAU86M+HeJnjG8/j53qs6le9BchssXZf6Q6Br1O6TehgeyVBUKWg8+nr+aWb7KAo0ko/lM7Up/pOsU2peE2uSgEianm12jFVMZId7A+p+MX6/TaLbQlWAw63w7WfnboaTzmlehhlYkPrXKXkLfgK/UqCvnSu7SyGcpQVIt2jeAnvGUa7xIfqDO/u9JREUyqO2cSdDm/MnegeUcLyQlDPP+o6aybRpWsPiM2bwtrIe8XCQo1E5L7/OcCaXXlnIaYCgfL6NTydw9quLeX+siUKxp7PrgmfgZ3dru8LtbHP30j9DEwAkEqOArey4CifOySq5ciU/Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=892jIfaFx2+sBGgwJqhHIx6GUfYbFomvua9bLUcG/Jc=;
 b=u+Rb8tWWOSOlZHRuZx9ijjwZ8ulSkdUJA5N9jxMe4aG9ZElXFbouxnxAlqjTFOZmdVQ1JQJ7NhqKieeh2E3X2FhRrKt25BJkffq3MrHZYbq9vzPJtAc1qrGffNRZ3WImXT3uGwmwXbFR4MP5JqqRjUvztUDHWRzjfqoRLVKI/8ejhOw+bJLYeMoVV3QNNobWw4lXOBwDFfQpsLd2lOxYuwx6IU9PncMfwb6aNekwOOYwd/TXYIamasvBSgIUMuOivTSgb5RwR04U9vxH8pUQScjs3kh4qCv6FrcoWR6jowtxfABm+OBGmP+j7T+hKnhdgZjyQUMI6u9XBw3EWhfVgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=892jIfaFx2+sBGgwJqhHIx6GUfYbFomvua9bLUcG/Jc=;
 b=oy5ranA8v2osLY1CKlCS6Qm+9FZg6IWBzS8fn1qrOPduySR62kPc49fXu7E+Xsr5W4BByhRARBrXTkV273zBEtWhFTJ73B1aTNl5hoeQyIBiSW249la8lRklbHzgkAhm7khRUieDbyc1XRod2oNMnJASIfVtqh0lz//nuKDoBBY=
Received: from SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33)
 by MW3PR12MB4444.namprd12.prod.outlook.com (2603:10b6:303:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 22:39:22 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::81) by SJ0PR03CA0268.outlook.office365.com
 (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.33 via Frontend Transport; Mon,
 14 Jul 2025 22:39:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:39:21 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:39:19 -0500
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
Subject: [PATCH v6 0/7] Add SEV-SNP CipherTextHiding feature support
Date: Mon, 14 Jul 2025 22:39:09 +0000
Message-ID: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|MW3PR12MB4444:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8806c2-0110-463d-7cd4-08ddc32746d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ez6TnKz9Rjfcu/FWN7yMr4GKDEfqeF2RcmFIVYUXL15fR2hXyvhMq2rcs+fC?=
 =?us-ascii?Q?154aobGeJwonerrsW4zQFqyXTnpN9yiOIocP2qBV9PmYENELBdyKczOhG1EI?=
 =?us-ascii?Q?1NvgkB8jy7XJkJIxTR6axvhc39KADL/eg7CMJPUsJAP8r/SIhkzjx1aXFXuD?=
 =?us-ascii?Q?TK6EQkO7VjDLRvvqfD3ILH/oEMJD9phCqf3rk4YaPEezIic6WgXOxmVGexWb?=
 =?us-ascii?Q?pzJDTBsdeCKOjFyTzY0G9Zlathp7Hs8rNBuWvyeH1qBrmKDJtgq0Ay84Zn7E?=
 =?us-ascii?Q?keOIB0OdGLGrUSJbAjjgWT5OplRkQ/H9hCUR4TtQ0IJVaxZJa0RKAJGKvD0a?=
 =?us-ascii?Q?E24YFlI444RbYbwk7Zg0zrkJDMkxDsmdho8r4SR2j4DF89NDwUPWbyFmfKN9?=
 =?us-ascii?Q?iEk3G7X+EUxl4ZPuXKvYGRxuy7VDtLpfgH4faLxOxUfpVuncQbbR11teYm3V?=
 =?us-ascii?Q?eiIY++45BejC5aW6LbS3RnSOWPwS0wd78aA7Grjl/XM2jHCb24FYiqDsi50a?=
 =?us-ascii?Q?nbWe4PH3KU29aSNy5cPtcLFlBTpOSOi2xOw1YkVVSRlbqDJY6JeLDJ2mpFGu?=
 =?us-ascii?Q?tT0LMYSp/Qf3R7CP8luphtnZxYMKY2rYH2PDyis0anqnpc+6PaZ4fQXDNLlV?=
 =?us-ascii?Q?4pYGdgz83Oj3oVxox4rv+CER4kMFKWp4niWltbwWva3WwzD2noDcPgFZZ1UN?=
 =?us-ascii?Q?ptFx9aPBkoJ1N+Azw2i1K5NSkb8+eQNAJ9wCcc2bopz5vORtfUwNWPkAj7lh?=
 =?us-ascii?Q?JVzShBsxjKT9b1mFoAi2ZgR61EGFsvPOfVxzSu98J7E3M4QW3468uW+JX4vP?=
 =?us-ascii?Q?qYqLDGHiir9xRBaNG+99rvK89WX24eq1qT3Q+ja1sMmEH+3ZnTCEZLf5+KNj?=
 =?us-ascii?Q?0EQBc4IE6KpsMjhxwQOwBWlvJj1LzwRC9BtkZFMGwV/90/qk6ehH28tz9R13?=
 =?us-ascii?Q?GcoucHhWnYB21lb1Sd5CEDyY8kx3rTEPM4dQM51jSl0V2B8UGc4AEbFzUn9l?=
 =?us-ascii?Q?DEwVgkFyZcJNzOP4CNiCttaCEQPx+L1y51PiqnEXg/ygT+8eGfgMQXXQGr20?=
 =?us-ascii?Q?UJdyJ3ksKdiTyJNXohbF2r+9pk/muJLz5z79bkDwSv1uQL15YPP0fvvx1RwR?=
 =?us-ascii?Q?hyf0Mc88UFihAlQ9WgfHq0gAZUy38eZNwsMV6dMJDwYe+plaKB+ihCBASjNn?=
 =?us-ascii?Q?Y63+rzLMiiQVLeyWujd9fVXOp1rgnZaBb6GKLuhwtRtV7n4s63+qGxyv26JZ?=
 =?us-ascii?Q?/PqSxHWak/HY8qrFn9SRxSpIEqOxwKk2PLfHgDsvmTqmVwb8b26qQTneubKu?=
 =?us-ascii?Q?3Zap9OqfzrUzlFNAXz6JF79NkCG/3XkZELtmLjisNDPvX2wupVaizpouR4Zf?=
 =?us-ascii?Q?jO9CozSu/OH48Kykns7Uh39VgjKGbXYin/Cw5j9tKibDSbBzcT8v41ueLIeZ?=
 =?us-ascii?Q?wmryMo27ffa5XcLD4FQ3+Dt0lYP3iMyeSo0HIYWWkH68I4ri7pF6meLVNqJi?=
 =?us-ascii?Q?UmRcbmB5iuwdZ7ubwJizj+8GjIjx4aBwMscuV27TV0JVfIr0+5ERRVfZjw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:39:21.5154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8806c2-0110-463d-7cd4-08ddc32746d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4444

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
 arch/x86/kvm/svm/sev.c                        |  97 +++++++++++--
 drivers/crypto/ccp/sev-dev.c                  | 127 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h                  |   6 +-
 include/linux/psp-sev.h                       |  44 +++++-
 include/uapi/linux/psp-sev.h                  |  10 +-
 6 files changed, 275 insertions(+), 27 deletions(-)

-- 
2.34.1


