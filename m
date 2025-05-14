Return-Path: <kvm+bounces-46436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC48FAB640F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E2517839E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788AB1F4639;
	Wed, 14 May 2025 07:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qFm+jBus"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F241FF7B0;
	Wed, 14 May 2025 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207297; cv=fail; b=G6d27fcOTyT5aWq8Vybfzqd46gQ/MZfhFEa3uw5dgNS+4fRrK7U88WDwERhQ2oUhTT2kMrxk3gOLyjf1VULnk/E+GHycL/1k7h+/5+V6gS7NifPBjLWrgisgrSTCvygF5FrcnL7jWrDfDGNs3MEeb9WH3u++gPfE1kOPENsJXpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207297; c=relaxed/simple;
	bh=L8BkwlssXqbAnqT5W9QM+JU32Xx373tJawJL4w6iaGM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N96Gnpi+Hmo8AJi/voO7SgQ7tosYgOSVXNHNIFA7V726UDLgkusnemQ5GKXOLXnomrW2Z4e49p0N70uYxWIvCi4x9ItJ3O0P2edqDDefUPkhlTuUgz5Qpg56n3qwyXUouXKboC4OdlV1ln9ibhhVjyPAZ/vjOhovRjYj2pSFMpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qFm+jBus; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNFN4rEQrNFbKkhpp6wWtw/LdNGxCG8hBCjrWzIDvcoGqQJL0xXOcLwIVfLZY177JwBShFrFBJJQAyLwJVZC0X9Wx/7h9FsvBtZ1SeEfZWJSAfKKHgkm4rK0Lct85Qnslno0IrAzxvmP5ZagVURQdZndcIJ4DaX509+YWcFVj5cUQ7gqxCvR71azwnV2hRkTymL8RqAWR8CBL0Jea+cIKeDS0mnrpVzTMQ/9SEfmwO56Ph4EJvNxRVB8/q5MaoUQ/zF9rAithq0k83gujHsrHH9VglCx/i+64DxoRGHARQoJQJlIkIIWbFxoH9z14qCrLfvFlLvKSKBPpLghrtAT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ERt0eDd+vHAbyC7Weya6cMm/44985X0ll6EbD+DYT8=;
 b=XTymfYS8NbRxQRY6ZLOj9NpSajBtuKx16nImTpwBzgMOM7Rp6cIq74c9y6rNfZEffcg+4YXlvKFr0tn7Z5hGkWoI0jGZpBLdHnAbcXenSepl3ez/p0FZv4DG10k8K0NvCFQ8ninpHMVa+qnJLxfT04+OqScsyUWvGbg9vaOi5XA5x9VpjYNZwUUvTPXE7lEjRiC9ad5LtSfC9gUX5s2UpZomfsV38IiA0zVXq7o2QtZMjJMiXVX6/5VkFxxFWUl1OyzzvHM747uuWPLP9L0QkC3gYVtr3EL0/byzNLdw0fruv3Xrrg5jgDqMhAYSgOphFDABCg65nTM1dyFBrzXcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ERt0eDd+vHAbyC7Weya6cMm/44985X0ll6EbD+DYT8=;
 b=qFm+jBus/KLwpZtoZZ6A1GXmTF9b4MFHgSaiQ4WHtXR4bmM8lKJVeKxVd6w6c+DJqciSHVOI7rQc1Sk/bCDhdbZeTc/WPlgzhWRT/Q/Zu/wm176JNDL23DrvC+EuD8bxD35u3Yh+Vzhr0uLkJptdlV+U3oXjIHbKAFLc1UfL6DY=
Received: from PH7PR02CA0016.namprd02.prod.outlook.com (2603:10b6:510:33d::15)
 by CH1PPF2EB7CF87B.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 14 May
 2025 07:21:31 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::91) by PH7PR02CA0016.outlook.office365.com
 (2603:10b6:510:33d::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:21:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:21:31 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:21:21 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 08/32] x86/apic: Remove redundant parentheses around 'bitmap'
Date: Wed, 14 May 2025 12:47:39 +0530
Message-ID: <20250514071803.209166-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|CH1PPF2EB7CF87B:EE_
X-MS-Office365-Filtering-Correlation-Id: f0194000-f252-40e0-4ec6-08dd92b7f30f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QmuhEVOdHDNouQ23BLfUD6FiAFfqrLH9NVuezJe6VLKf4eOmfrA+/pq9AVgR?=
 =?us-ascii?Q?XHaS280lMLcnGRWPzL7Uc1wS1nqc9v2rdxi+boEUh9etGwys9/JVcCYgYPFB?=
 =?us-ascii?Q?9rhH9+VFNNSaJaSQRmhQS+747PqPdqMCryUc60kcRs+3qOTSX0sKw2TW1gdt?=
 =?us-ascii?Q?7hOwmIgwV1AF7Rf8vY0WqQHThi7JQSMgZFLSQrFRMv/cfRJB2eogj8Lb9Leu?=
 =?us-ascii?Q?h9ZFOktkn7Sx93Y+qq5J8f2xrDqOe7OJKgjdStWcABtQ1SbHqFRR450oYpXV?=
 =?us-ascii?Q?F39QODzTboDKZ0qtIsjhiEo6PPzN+Lw6z7oHvNDGyHxWMf6s2ha6/RHC7iUN?=
 =?us-ascii?Q?c4uqZCAaHU8S86PXGTa8GQYm7s7lLoHMOOeaVNfUAvQbs/e2MiPtGfXcn0fC?=
 =?us-ascii?Q?9kEr+oTvHBnuw/MZsO2N+B++HDtpT4xJEnsUpMisZvtIO9c2slKzJgn8NaT9?=
 =?us-ascii?Q?OyNExmyM+v8MJeMzby3bHXQT3EMgljKxGJMuNo7/3VJSaSN+Fw00uLXob4qe?=
 =?us-ascii?Q?IrBp5tlOuEFIz6rTz2yrw8/XO9Bfw8LkHp/kjTFS8DdFOyiZR3NceLgkfYC0?=
 =?us-ascii?Q?w7uGgirigYe+W+BwAjPxM4X6bVhaHutIcHU/x8XxYHoY17PLfz1J4EvyM8r6?=
 =?us-ascii?Q?0sGa1Jk6FMVryPeL+98zylEzIOvsMKzWHhSgC1DO/K2aBC+gJyzSKnX8FXmC?=
 =?us-ascii?Q?wztPfYf20MHyTVeoZO/+1mOvuTH3CsOGrkFs5QaM2NhNWm4WQHT4cmUeOGy+?=
 =?us-ascii?Q?sTdSGAcj0UQl2hzWlGE+AbCV7bhHHMBU0Lvj3lYQAzBZoMeAQrDjMO9o/llY?=
 =?us-ascii?Q?zTsZ6v9ZMTehUwOXdBEe/JPvvaZCQ2i9lkJWQMHx+n8OBh+6a0O6GfJSrI5n?=
 =?us-ascii?Q?ZPMjJjK5072DMFeZhz4mhozITLOqaycDYGBvgXvJkchbIsPvHTcxgeY5rHWM?=
 =?us-ascii?Q?cygDQgX/N6TUE5aUZxgvrzu/vbSGU3X0sssLORxGZ+gWUCB2mL4X1VkZwG2Z?=
 =?us-ascii?Q?JYgz6Dq1Kwv+kr+PflJgvpOtYFj0XBVTB6LHWa4HC/iu9cjj0+41iDVo6ZLc?=
 =?us-ascii?Q?B4jaAgyhmKvkYfrr8VF3SMZe5Xy0TiMCENVUcblHeVAoGrdDfNPM8lhiwp43?=
 =?us-ascii?Q?Q16fKIpMgWkqULLQ5Sq+X4Xh9YRsZFpkgtzc0PFR36lMqHis5VFzUuSeumSM?=
 =?us-ascii?Q?WJRJOe/sdINYD9TwP/dIxFzYjZpfL//r32aOKu6r325FqcaCQa2uPwtJoq7t?=
 =?us-ascii?Q?I66xcuzw7E70hrCl6BHT/gEJVr4UvBbXuhw15Gu47MBbdYNl9CMOL1DQL6eP?=
 =?us-ascii?Q?N8g73ttE050pk+sM+I9Kz7+oT3x107nxlbgpNSYvlij0GqOfXRjnA7zgKxdd?=
 =?us-ascii?Q?qfzQvkMO9gRB+aIEMkvPzXPUkTBgxaNIgqmyCvRC9QN72YHx9RF9U0YlOaDx?=
 =?us-ascii?Q?fCzlEICQwdejIn3ARCn8jZ6N63bfaC//5xF6PH8ct7tajZ4GM4g8e8H8DB4n?=
 =?us-ascii?Q?hVPD0I2rMd/SEUrzhiexyMPxeACPTy8LI3bf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:21:31.0330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0194000-f252-40e0-4ec6-08dd92b7f30f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF2EB7CF87B

When doing pointer arithmetic in apic_{clear|set|test}_vector(),
remove the unnecessary parentheses surrounding the 'bitmap'
parameter.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d7377615d93a..fb0efd297066 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -549,17 +549,17 @@ static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
 
 static inline void apic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void apic_set_vector(int vec, void *bitmap)
 {
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 /*
-- 
2.34.1


