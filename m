Return-Path: <kvm+bounces-18039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5818CD227
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 822CB283553
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7F613E032;
	Thu, 23 May 2024 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HCpj28EY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1A01E481;
	Thu, 23 May 2024 12:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716466750; cv=fail; b=L67VGWjlSIZYmmsF+Br8U601nF/fZMuMxyLfEk7eNjYbXJC9jHuJp4UNN71AFFGgNwZTuvgf1EyRn2ISt4PFu/kf6jkLjAaixGix+WXXeK7poE5dWol50uFIKATfqwUWuTQjfyBo5LlPkF37tiSeICanCcjFeR8e2kgBjLa3Hs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716466750; c=relaxed/simple;
	bh=ZtSAZdBcSQ2x5kN2frsV8HobMCaCNMmZkjAXeq0sVh0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=syVkNwikwYXpU25v5Bqx7rmvRDY3KgZqSYrfp856A4+nCRNO8U7x86qxkSy0hPX+AH+NiYqghtO2vlouFOLklDglpxfVEvkIMGxUHsjlpBxsmvkEvmhWfK+fUNuaqAA/HtXTzjMIp4cGEkuqGyEmhjzDwosSqs46JQwCU2VaEAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HCpj28EY; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBjD8l5NI68h+x+7XsA7XU3BGMh43CxRNOTFKz/zOzFxGfIhEbMyI6SpjcrbTPWK7an6XIsTvR+1toCe1DYWzyRg2iQMJLNx5MsVjJte6DdpEEYJhR+s9Yg8agrFIjcScwDpJNG1nk6SmgHsX1YW33vVpopKQwKaTof1hl/7dtEsoaZ33/Q/FuXo1tEs0g/rwPZGqTsxSOVJufE1atnuM6+obMHFWctZKB5hHy59dTNGf8Zfy1OpeugKmJmWmZlVq12ECGsK/1En3UVC8ZD0u8/p9Pk7QBvJ1dr7nFn1PSpIWMHmxUNY+GNS9DUmvyFInut23ieWI7vhs7AnRnWyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWk0V1FkcE7NnAPQ0o4eSIgTgAvMirKpZy2NHFQg34Q=;
 b=c8+OaZP6BIN8Nq970zUjOezboMXzIIodspeLCqv0ooeXejfohKyTp5nLAQml0mrXSENkm1ayiKasA4UrGJUkXvajBuikqAXJOEonfqKYfEKYFFh33H3cCsGBtK7SWBNo57xFtDJ0wNN8BxWEwwrxzWiaXnyhw4stMjOBpiLV36twocaGyvufLTHknknJCWeO4R4ysP35va7UeeKsKROdsLWxtb1kAIdigckbp/ZYGay6P8+5FNMbunpvbFo+J9OTYNVWIszRovJvnLl8Rla74Mn+4jFDaVQnfTndT+ZYqrKLmhnNpXC9sSp6GIL8rAtQUaafOiPJE0enAdOBl95fKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWk0V1FkcE7NnAPQ0o4eSIgTgAvMirKpZy2NHFQg34Q=;
 b=HCpj28EYEYP57Sbh9tqJKwDyQtdp1LsA/4cclnVnVlUFAyEPMXs/KUFpHEO6i/XCK7QA38LcGsmF0gpJtY6rWFlchtI2+MDz2loeRf50jfcsDhgJajPqjB7WilFZ8l0hPFT3n/xfcgrbx7c4foU2QYWqe4OARmd2qA6EBbQsl1c=
Received: from BN1PR13CA0012.namprd13.prod.outlook.com (2603:10b6:408:e2::17)
 by CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 12:19:03 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:e2:cafe::8a) by BN1PR13CA0012.outlook.office365.com
 (2603:10b6:408:e2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.9 via Frontend
 Transport; Thu, 23 May 2024 12:19:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Thu, 23 May 2024 12:19:03 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 23 May
 2024 07:18:55 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v3 0/3] KVM: SEV-ES: Fix KVM_{GET|SET}_MSRS and LBRV handling
Date: Thu, 23 May 2024 12:18:25 +0000
Message-ID: <20240523121828.808-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|CH2PR12MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be3b846-84e2-461a-b52f-08dc7b2288ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vl8qOoS9sho6KpQYaBcu4Jr77ZFWuBcIlCdUpYqC1omKsRPSf3vQZYQrDG6B?=
 =?us-ascii?Q?79KsbDCxGc7fqJ/ZVcq3VXo5mXA7SVcWcJU8qQ9eDMlJU+/2VvNMJHyA/5Y2?=
 =?us-ascii?Q?7OJcG0OsR201t/dm3Ty3GvVGrU+/QO0oUjNQewuYN2PR8KxJkomS70En05mT?=
 =?us-ascii?Q?em8y02ilkqk2kUmpFOWLQoIi/44RDNKs1kKgQCC2EC8i6ojc1uJd2hkhN8tT?=
 =?us-ascii?Q?8jjFg56c4vEQiSi0//VZip+QXrblNna/UqW56kKIqoVh6SYpmnf80jYHOKSH?=
 =?us-ascii?Q?c2E/Sfp0Q6z6RnIwwO9TBMcgFbWw7+duuJTY2hyW3xYrSFrTrlxE+D1xMpz/?=
 =?us-ascii?Q?g7xaw5fqIm5LLgQQ0W995GcSs8qH/EeAhT+uJ2A3ATxghsSdqLkpwdahD4N2?=
 =?us-ascii?Q?vyEngygzm0q82o6IcnnbuvVf7VTZQri5OG67Hst3+B5EgNIb1n4bkvV++Qgu?=
 =?us-ascii?Q?XwIBOzoTmwWPqVksn/t6gE5u897D4bVrimTwSQKi5hwGgmPlWPkRfLnC8RB5?=
 =?us-ascii?Q?JEkGYlrOCMc3zVvvVCSfLl9ZcSg/sMptlh0HEvY/mSF5F44suK7fpfbROJ/W?=
 =?us-ascii?Q?neJHaPd/b7ofb4N3/JZLAlyuwLjVBC07/5kerRGelqV5zyNHQXBEV1/SWmoM?=
 =?us-ascii?Q?6KZAB6ovHEE/LOHseeYS3Ae2WCHRYowILdiSNkNl4HDHMdJJUuTkFkOeBohU?=
 =?us-ascii?Q?Ijt2OqvpUoqmdzybKQiplk9YkyIR1aNWkuNhgMVm3hbknNchO4077anwT1yk?=
 =?us-ascii?Q?DTDkIQFWMa7s4n35MBGDPCZ9sU7Fiz5Y+3vtfeBCSYqGdsFc+cQkvTnDtM2E?=
 =?us-ascii?Q?MySrMXWN5hGOn3NpLEq8bSFAJpqSN/Bmha6+cXYzlGLxY0aUrcihiqhUcVRb?=
 =?us-ascii?Q?bTgfjJTpFqLDBuCFngo11TuVAFlpRNWz1EFLBK6uUzXN4Xd5Kitw2MvQ5IHV?=
 =?us-ascii?Q?Cje+mDSXkXhHnyt91Z8Y+vtHn7Zws0sWVa+cgxGfGAa2F4ZYEzk7T7sptydt?=
 =?us-ascii?Q?QWmQ7kecVNdZ210vLHNNIPK/63hBgp15wZpDndKOf0oP3rBbuaw+alXSWGVM?=
 =?us-ascii?Q?1iops57/OAlYawCxEVNdcH7nHJRpJgAY5hBVNve7HTp6XjhPmyJLcxFa5xb2?=
 =?us-ascii?Q?3iJcUbv4zyhLtf+x+yPTKphd3oJpStRg0UpC0p2RmjHv4X73MtkdaJRb4iKq?=
 =?us-ascii?Q?PH1xAwwRDg6B23et6wRsoPx4z4I2+qIhtTF7dYi+EkUJdBRPGeMlu40eB6eu?=
 =?us-ascii?Q?x32g5tjxNz/IZfdsTYjNRvyzF7gIAg8zYhDSE+4NtmMoWlyhlmdHUYeogUuC?=
 =?us-ascii?Q?4aPaEZPqpaPx9/CALvMRicA3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 12:19:03.3807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be3b846-84e2-461a-b52f-08dc7b2288ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152

Fix couple of interrelated issues:

o KVM currently allows userspace to access MSRs even after the VMSA is
  encrypted. This can result into issues if MSR update has side effects on
  VM configuration. Patch 1 fixes that by preventing KVM_{GET|SET}_MSRS
  for SEV-ES guests once VMSA is encrypted.

o As documented in APM, LBR Virtualization must be enabled for SEV-ES
  guests. However, KVM currently enables LBRV unconditionally without
  checking feature bit, which is wrong. Patch 2 prevents SEV-ES guests
  when LBRV support is missing.

o Although LBRV is enabled for SEV-ES guests, MSR_IA32_DEBUGCTLMSR was
  still intercepted. This can crash SEV-ES guest if used inadvertently.
  Patch 3 fixes it.

Patches prepared on kvm/next (6f627b425378)

v2: https://lore.kernel.org/r/20240416050338.517-1-ravi.bangoria@amd.com
v2->v3: Fix all affiliated issues along with fixing MSR_IA32_DEBUGCTLMSR
   interception:
 - Block KVM_{GET|SET}_MSRS for SEV-ES guests post VMSA encryption (new)
 - Block SEV-ES guest creation when LBRV is disabled/not supported (new)
 - Move LBRV enablement code after VMSA encryption to avoid a scenario
   where LBRV can be disabled inadvertently through MSR_IA32_DEBUGCTLMSR
   write. (new)
 - Removed all 'Reviewed-by' since the code has changed quite a bit.

Nikunj A Dadhania (1):
  KVM: SEV-ES: Prevent MSR access post VMSA encryption

Ravi Bangoria (2):
  KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
  KVM: SEV-ES: Fix LBRV code

 arch/x86/kvm/svm/sev.c | 21 +++++++++++++++------
 arch/x86/kvm/svm/svm.c | 42 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h |  7 ++++---
 3 files changed, 51 insertions(+), 19 deletions(-)

-- 
2.45.1


