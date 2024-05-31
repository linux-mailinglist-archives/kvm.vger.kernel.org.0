Return-Path: <kvm+bounces-18494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3650D8D5998
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9C3E1F26FDD
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BBC78C73;
	Fri, 31 May 2024 04:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DagV9Y10"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2B91C6A7;
	Fri, 31 May 2024 04:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130832; cv=fail; b=MDZvoX/sGnYB1Nw7aVzRxg7r2lq+VU9BsRnOpmgsYsbPTF7QAYtCQMzE/nKhZHxr9zuxz+PbMAVaurQuq/rs2qnZ/8AlcK+SNMZdubCQiQm9iCqOnjxL2hSnUVJBtsRVMT1Qpmn9cFbvA3nmR1jR1dbZgvAcxfbx1MAYrASl4ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130832; c=relaxed/simple;
	bh=lXhwSMFjg9f6AS3nNRxFR9l54GWY7xQp4RYz7rayW/o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LoCmoPhFVrw70TZT1XZOl/ivzZjk7U+ack4qXu+vDggg62Axadv01ctZBtZank76vhsHj9iogvCfPkRVvnF9x2gjCaZM7Bp2piHinhfxyUnqWW8odr82yET6oBGtx2c4iqTP+9ArraLbUiCNNeLnipvH0tr8p/sGjhIYw6ZINyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DagV9Y10; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck6DcsDu6TBCoMX7ymJVsqNEfobW07ltiQHnK/k1W6+rp27zhZzYeguoC5XMsu9r0nImVSMj6JmQaQCN5o5d30fZj1XVymAmfQz1ra8sqVujlstXLZsUioS2X6x+V+NLGClRyRB9YspKFcqHiZFcL7YpJCmbOJW+941QfVWYKSRtCNQdz4TEN0P085WAf0z+V/mLjlBjyMuaWDUnae4yQkDe249IlWuPz03m1d63ME4uXpw9MB5QEGNB0PNNkSQuQCxLcRy/L+sGm9aNCP+7jKWQ1QddqhMifAlba4Wo60lMLI1FQsAB6nO4pAzM8yP1kDGWeljulnlTfNexKA8F6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5D+hEajpekl4UBUO8vQZ/jW+oy8Wc7UoCOsritHIstk=;
 b=GuRIStBIK/y6kcdi7S79VcD77Tjv0bAJA1dw3ub6itBH+xtIzqaEpQPEST4kG8t8lteyt8z2KADvlhpHQ/CwcEykc77lc5iXmV0J+VgW+BKJIzCcVe9OzCeNmyikbxG7dXzvC6WLoqtIJnnQvirKRVA4gFYveI84F9ZfQZO1D/2I+BkwXlhHk9xKX2wbyM7T0SL4uxewOpTBLHYx9FE53ZoH+D80CWiraGVhiGMxJ8oFP4+bHKQjPZLYVP9HXBkvdG5iywiejKCjef4T5mA9Eea1JKul9LQeAao1D5iS8VGkVESIUaFKoP1EqE2jpYKw2hXXRnRLCoKXyU2UAT75lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D+hEajpekl4UBUO8vQZ/jW+oy8Wc7UoCOsritHIstk=;
 b=DagV9Y10GHadvXofcbHIHj+jFv8+oksw8Hkhw6yInSpuE3HpHSm0Z5hp4yoBSWlbTzuEw7VzJ7IsPykRPGwshj7C3u0RWllbFP9Es/ztmH6fJE+9OC0/HowErEuSBrOquRbpQ9LZvEQ7aYhhWcWW1kYbsWddvFN9Y+Dwbi/98FE=
Received: from CH2PR07CA0059.namprd07.prod.outlook.com (2603:10b6:610:5b::33)
 by SN7PR12MB6690.namprd12.prod.outlook.com (2603:10b6:806:272::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:47:07 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::26) by CH2PR07CA0059.outlook.office365.com
 (2603:10b6:610:5b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Fri, 31 May 2024 04:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:47:06 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:47:02 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v4 0/3] KVM: SEV-ES: Fix KVM_{GET|SET}_MSRS and LBRV handling
Date: Fri, 31 May 2024 04:46:41 +0000
Message-ID: <20240531044644.768-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|SN7PR12MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: aceb9b78-b882-4a36-188e-08dc812cb986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xgIhCpsMtI9CpeEnCUpkW/ELHAipGnrlk1oTwuUKTety/TMxvg/GpXxSLQSC?=
 =?us-ascii?Q?f/mhS/Cd2tF4MuE01nUGU1/tCmtzJUHaISkC74ShInDAFw2zYxm0Qzb5bKNa?=
 =?us-ascii?Q?4d6VtGfKPDeySVEAOEX3oTavPOTImej6inkfufndUCda649SCihp6+eNyp5Z?=
 =?us-ascii?Q?PHq+/RAGrYBpZ+HGZbzFRh/SoTsfDNa+4RR+c2PHcdW3/XSNrTSeW1jmk9/n?=
 =?us-ascii?Q?idSgA0lMtQ0EGLhNzRu7+Qf3RGGutvOzqktoHnRCR4qCD70c9AarKOBz5y1f?=
 =?us-ascii?Q?nxGIE0/skq/0fHP7Yw8cilUqsNEUCzAPkGbRwypaLU3VkS64LOTN3ezv/qbG?=
 =?us-ascii?Q?jEkmBS0lERFIqK9uxvKVVpTIPICsUjThVuUljVk/D47EMZAeWgB5mpiI629+?=
 =?us-ascii?Q?M8v9JretIMICGLpILc8XBTx6L7ILGVdl2ZTGs1wldIFcEoguOFNuiDlhI9fG?=
 =?us-ascii?Q?TsCcWDnk9yBiB2H29Wkvml7MhXvpN5QNi/qFNcQpmIIkgbr5NZDrf8Zr8QuJ?=
 =?us-ascii?Q?p0hl7LrNvZspncBUNIEfknz6qWgvXdc3du2paE24w/etJi8hfYig0N4Fl8IP?=
 =?us-ascii?Q?6+H7Wx2r2SQPn48XkIFnOp2NA242P0HKcKkUpV+sQGB8qq0MvoWP0kjbHAq5?=
 =?us-ascii?Q?7NQ7tCVidGD+vJu+FJP7U0Tgjh/Sa8KuXqPI9HmHPdJoOSi3s/TfF+dMUBG+?=
 =?us-ascii?Q?IS1RB7N1fYYkIVb7/RY0eh3w/IQfHS4w8e6WxzZOE2C+G2s4r+45SyjHmL5/?=
 =?us-ascii?Q?UP1aQD4Zz3jvKd/foP0Kfv+RmyIjlS4Mn1ydQ6ivEPmjA5kXQIwiiHhZI+8w?=
 =?us-ascii?Q?jhCrqi7ilh22YsCrZQ3mHVqDTTjQB9GyRW7A60+0p+umntbpz/GpeSTdumoF?=
 =?us-ascii?Q?lcPfIW0ZSYYocmacd/QHUiQf644vccuVV4jhLXlDAKZGKckct+cEDRFcGPEl?=
 =?us-ascii?Q?0oUPbaYTQEZ2+vQdF9IQNshjASZzZw5Cj/FqJICWnG6qsz74L6d+iLi8CEqD?=
 =?us-ascii?Q?AyQYH7NrQjmPGZAoHg7PP6oYZoOopyi/YL59WndlrHbkZ2AgnbKcbBladIaQ?=
 =?us-ascii?Q?JqoXksjmZD5FxQjIgBvM9a4DCAb5BvmUk11HIUSSXQt5Saow4kaJYiciNiCM?=
 =?us-ascii?Q?IzLfoZiKtzqmlKN6Lal+YPxmiwgItQsMpT5wB1TfXCn3toR7QoYMi0fykaim?=
 =?us-ascii?Q?BXGwVQm1aAPLHurU1HoPlZ6j/Ns9eOMu79E6nBgZGhqSDaGHE0Kwa2nOiJW3?=
 =?us-ascii?Q?JWH/tOsf66J5ssp5tyt+X9XFOkMHy8rZ4YXmo3GTEqZtkry5fueDD8zy3zqq?=
 =?us-ascii?Q?UUi2iFG49/6oausw8KquHirF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:47:06.9947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aceb9b78-b882-4a36-188e-08dc812cb986
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6690

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

v3: https://lore.kernel.org/r/20240523121828.808-1-ravi.bangoria@amd.com
v3->v4:
 - Return -EINVAL instead of 0 while preventing MSR accesses post VMSA
   encryption.
 - Make 'lbrv' a global variable instead of passing it as function
   argument, this follows the pattern used by other variables.

Nikunj A Dadhania (1):
  KVM: SEV-ES: Prevent MSR access post VMSA encryption

Ravi Bangoria (2):
  KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
  KVM: SEV-ES: Fix LBRV code

 arch/x86/kvm/svm/sev.c | 19 ++++++++++++++-----
 arch/x86/kvm/svm/svm.c | 42 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h |  4 +++-
 3 files changed, 49 insertions(+), 16 deletions(-)

-- 
2.45.1


