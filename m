Return-Path: <kvm+bounces-43734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F3BA95A20
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EEC2174542
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C4F156678;
	Tue, 22 Apr 2025 00:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RElzo4uH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2914578F5F;
	Tue, 22 Apr 2025 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281463; cv=fail; b=Mp6zOQjIHqFgGAukaORP4x0FMZsLFq96YX8sZxtd1nTQcnWtO8D4xqh5pNZ62ypkb3BmN09eUpT5GY6hhQxU+PDqYIIalzscmQPmKOFnwo6amf7PfDtqSos6PnG2n8kV+/5GYn3dFQQ3xQoGdlHFFB8YbBchy9SK4fg+eN7Iva0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281463; c=relaxed/simple;
	bh=Z0fveAUtE+wvo7dlJbKAp9Ww90G72z7QgcrKwQQhKQs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oCDi5i+7hJY3dPfmuqm30VhKBS7CcnfWifqNN1I7lmzXFvJ9lSkdEK57l0XMixs7nEaub4v4FU5n0C+giJO3RUvnT/3m71hBNEWrdokHsIOHeVBC1yPhlIiSNlGZYNzP+w82ZsyX/5wdH7Rinw1V5bOkfiYNqooehUwykUtT9u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RElzo4uH; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avSl/0x4jzqIdk30pVTLrW4SvNwXZL4gK5TtxLayGHunNrhcEFEb0whEePsiwSWDHGLAIuEkBxHqVeDahQOXB4/BTxAecJDhW3XSsO1e8dZdirzzp/ZWe9Bp9r+dtjH9TjOWJLN5jItAVZnB+/kpUXE2pAnRYlRr52oog4KuOEKAyX7IfZju+hRWKNH/bm/NM7vnoMXURTQoIvOM8bTkCMcwtHB7PFNCYp4E9tP2iQpihE2owLLeIvta/L98sBf/yod3PgTzAfLM52+9sM5OAE99aQQ/r+rWdlivf2vHtUe5hH23sDgn+hOVAUwCZS+CXtXIUfukMBoDNEnsmowLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5c3jD0089Q2jyh1hb18+K2i5WjzHT3HqYiqbSlfr58=;
 b=ZvJv4N8QaTvbEx8kKnHSFYo9QYgD9kbdhldL9e3BUYBgpljGeVp9/2NIq4w80pEryRzTT5C/GuI7AW3hnjsvThk8hoj+cxEjzXpGvCBARM3ywkOqgZ/BCnF0RAWa1oZ20bRYiCB475EMT4wYMGk9xnoa8JiFJKJgEKDDT9QyjcuInttdgcz9VzuV2ZAT2qbZrg+qgJ7p9f2kMAFRuU4jCZl0d2+rMqt5dqCs9jBQ5l/vWgrTfjO0WfPfjFuuFGere4de6t3oq+WWb01dm5FGOTjUFUmNs0yxeF2Ea6bb6BGe3//gFIDFrRK/AMaV8YrFtDEF4cTcZL5JNkXZRnL9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5c3jD0089Q2jyh1hb18+K2i5WjzHT3HqYiqbSlfr58=;
 b=RElzo4uHQNiH2uuPAAPhorscZleDutGFYmPfhnBkDSxIHuv5OJd42Ld/r2PUdrnsVtT1+sUbVnAPCdlrzPkygCxLW61LLn5zLD+jOvRLrlSeiSlz2x4YRLfIS3U+Az6Ezqcgv4OFvbBXD+hlvycl9sR+iHusqo5OU1ATUNJzBUc=
Received: from MN2PR06CA0007.namprd06.prod.outlook.com (2603:10b6:208:23d::12)
 by CY8PR12MB7196.namprd12.prod.outlook.com (2603:10b6:930:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 00:24:15 +0000
Received: from BN3PEPF0000B06E.namprd21.prod.outlook.com
 (2603:10b6:208:23d:cafe::18) by MN2PR06CA0007.outlook.office365.com
 (2603:10b6:208:23d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Tue,
 22 Apr 2025 00:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06E.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.1 via Frontend Transport; Tue, 22 Apr 2025 00:24:14 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 19:24:12 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v3 0/4] Add SEV-SNP CipherTextHiding feature support
Date: Tue, 22 Apr 2025 00:24:00 +0000
Message-ID: <cover.1745279916.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06E:EE_|CY8PR12MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: d167b89c-c221-40b1-0b72-08dd8134031e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ue4O5sI4YkED1biupsrZMbWXlrhicS8mdpyU5gOCf8Pi9pJTZzV5tjouDHiw?=
 =?us-ascii?Q?NiEAEjCpX8ptr+Ls9o5DfVIiTck3jGa2IvCMqWj8hjpcT5FrfcxeqU4TVxJE?=
 =?us-ascii?Q?3h1bhsht9z1OvkBk2Eh60simNgDg7ybRAH9qn0w7ctxadj7RRqBUePAVBV53?=
 =?us-ascii?Q?yPMho6m4h53qN/ctkBXbYe+8+nJ60uTq/4CHBMw0lNWJdw7MpezPRMLrxAYc?=
 =?us-ascii?Q?7P0gmavZAYtRrOhIL+tj5hMQuqeo06i5QPRvIBqBVxQH6Dgc5rFI4E4KOj2/?=
 =?us-ascii?Q?R3RO4OKsUuEeB5+9frHmICMvRULK7cjerE5bBT8L1IoLzUF8AIWXvnfDngdw?=
 =?us-ascii?Q?C2H42SPSvrGD7+FiNhr/J4J1dtA0b0xnm9DMHk2PYOgkJJiv3nJx+PijEsBR?=
 =?us-ascii?Q?hvmjCbkB+BHT9a51eB5F3VSG/YGcdep9OJb3YyVCCFAcUlDA5PLzYHy4UBe6?=
 =?us-ascii?Q?PfVxccFAotn8C/wXeDd73urpM3/JUtj9QMwXWKv9CrMjui2En8Lou3ubrLkO?=
 =?us-ascii?Q?mYR35b7zsyReMKLyfg+QnG0tV33jxXmj+3RnTRc8jPMOy6GbWOWXYn6/XEOX?=
 =?us-ascii?Q?nUHO6TO7AE4KUt0VE0uhVCdjHnvDYJgdoL+ssi711RAm8T4bQmxMIAZ5XLhb?=
 =?us-ascii?Q?bB1okP13QUYeBEgMBnSGyoPtWheiSJ8eHLlrhsx/KS50/Mv+3ekAjZ4q9Khw?=
 =?us-ascii?Q?E7PI6CyaxSQTF5d8XdUqtLx0QTwv+9u3Ra26KdxlzOj1r818YnSk33tXZXIG?=
 =?us-ascii?Q?Q/HL6wV/pFn/++Fn6cXiUN/sHBxSE+/I7NRCD5hCdmqckDwmsNNGgdiIvz6m?=
 =?us-ascii?Q?p6Us8LwZzOePLvCISxZ7KUMGtGADECen8/EzD154lljgizLCU5347WtpGHC0?=
 =?us-ascii?Q?aodFsAWlUFV5HqolXY/XdPbvlF34MifdENqme5KFVllGPwZoToik3J+/rPfA?=
 =?us-ascii?Q?o5/RNBck2M4IWQMLipm1ODjY6m2KZUEIGghVPdotQBXmTbyymhjg8xcHBbI6?=
 =?us-ascii?Q?d1xDAJ5Wu5qObE+9AfzcKBWsDiHeadVNi6M0ddEFnbiY7KDP55nvXCp1WLx3?=
 =?us-ascii?Q?Ltg4F7vjw2tpeYE0cbK4RDgd9bzll396HGiuYy0D085p4TV6znN3eXzxdk9I?=
 =?us-ascii?Q?dnZfWmT0MECI6hY9+l69Blxjzb0jN7NdQ/HWJFxnebaMbf9sVyGg+bMHbQI2?=
 =?us-ascii?Q?2oC6v44blsVuxgakMDthf0R5WaWRmOLy64vmHZqaBzcHwzsHyL1uVh8LTQHV?=
 =?us-ascii?Q?0akZv8O/KRbOpplT3SxNaEXiZ8V6L36tVTcWL88DFiaa9U8PWVxCQSduq7ka?=
 =?us-ascii?Q?v42IliPpBVM77FQwyEv2BdL+SajSr5DT/z5YdQl3vapVMfQjKRHUinHqVm8f?=
 =?us-ascii?Q?eCWxYkYs6cDeCvXcZrtl6+I++9eI7Nl2QuPo2an2ZkZtvYY4wFcwdp4i9mn6?=
 =?us-ascii?Q?uibKuPNi4W8uiAM8XibsOqovq0KVw33BwfQ6ZKPfgGzCYBzA1x77atOzpBo6?=
 =?us-ascii?Q?7gFssWDWMI/APVwnPVE1M6YwQ6Vpd2vtt6R3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:24:14.6633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d167b89c-c221-40b1-0b72-08dd8134031e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7196

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and 
host ASIDs. All SNP active guests must have an ASID less than or
equal to MAX_SNP_ASID provided to the SNP_INIT_EX command.
All SEV-legacy guests must be greater than MAX_SNP_ASID.

This patch-set adds two new module parameters to the KVM module
to enable SNP CipherTextHiding support and user configurable
MAX_SNP_ASID to define the system-wide maximum SNP ASID value.
If this value is not set, then the ASID space is equally divided
between SEV-SNP and SEV-ES guests.

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

Ashish Kalra (4):
  crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
  crypto: ccp: Add support for SNP_FEATURE_INFO command
  crypto: ccp: Add support to enable CipherTextHiding on SNP_INIT_EX
  KVM: SVM: Add SEV-SNP CipherTextHiding support

 arch/x86/kvm/svm/sev.c       | 50 ++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c | 78 ++++++++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 47 +++++++++++++++++++++-
 include/uapi/linux/psp-sev.h | 10 ++++-
 5 files changed, 177 insertions(+), 11 deletions(-)

-- 
2.34.1


