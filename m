Return-Path: <kvm+bounces-48005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4322AC838B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A43F11BA3E8B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35600293B61;
	Thu, 29 May 2025 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZO7RPN9d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EDE293B51;
	Thu, 29 May 2025 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553514; cv=fail; b=MAYFDhf44Noaro/Plup367lELKa/ubgMoSw3Bu9+AKZYtNReyAdogy/MZtJz9vNW0zBEd1hRWSC38Ynyj3rwfSWCTtRQ4HbAiemVlHULgedZKO70uv8m+RU/iQ7odlORwhU1CA3l/Ijwdq6dq53j6JxvVpa8lcKNIXzRZIInxb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553514; c=relaxed/simple;
	bh=okRprtViEXPA3y+d7c63XoOzHUERLnkj200Svu3AwHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YXMipgR3lhDsWCJLDCYdbNlvCef0jqE5B/MNBQWERdNl97Jev7I40M9TY4ZvD88XBdZElysnUTRB718BWvMCtD6qp7Fl+a0GVsREZKXdayTfWArapEh/4E3ixCLYFUI//UG0lmyiem3BRnChcOUzyYeIjlfXmpJNU31/Sn0DKaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZO7RPN9d; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYpcZopv3+w7VNxF/eryZsw7hbe0Q+whTCvBcOIWgrWlNzQqf8YTrBWc2/yjSf6OHEYVz6YnYDgcii9gto1pbuPqV1Bb9jrKy9jdjsxUaEMNM9aII2F3WBV1qKXJ7uCGh9sAyGacZltSAMBqytZCGCqTlydQOmF800RASENkifI4brKBgeNpkCZoAM4Pacuzg0GLksTeaJ6gYZSxTkb6AVsBUVjFHeg3jVs9luZLJ8Sd2SSDsLSHvfi3W//VDCfO17dA/BlrXkdc2p49O/f5BRE/x9pLoQo8c0dLcv5JnY6xDjatJtLVwi9LOGtF9bm+L6JEuwssG53YOeR954n83A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04YchuE/rcAL+3R3LxMNNradNz9oOwhaFzQqXNwwEtg=;
 b=rdsqCRJSGFTnVoHFRZkSTzhA4T1rblUnD1JrfDAVjcGNwOJAhxk1LN/EMWy3Cuaxax9E4OBX/vH9sbihjJO8ZCklYUMuy0k3PmLGu6ONp3jgoFoeJixKX+k10j14VlyVoHSQylP0kR8Uc6I4U9xz+bh/3kHbg80GN9mUpTBKp9x3/UW9s/vfy14a3QL85KO7QdvyADFbUnaT5MGn43I+ZHKgq/SSeGIoR1VUY+izsPQ3bVN7xu+Ym3QBj3MMQkSvVjB5y8F4o14H5ic4zFV055VuRD+Z+FiL7YvKOnCKASak3PUdAQBMv+Czh/7vsGia5df6VrPvgbf5HITkgVBDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04YchuE/rcAL+3R3LxMNNradNz9oOwhaFzQqXNwwEtg=;
 b=ZO7RPN9dfQJjjzZmliYrIaxYhi+8mYEznc2p992qSZkRgF/4JEh0l11OUKce5XA+Q0ZnokyKR5o5ERxnaHAdAhUcACjCB9veFUjisieTFqBNEUYZRyv860BLaWZ+uxeONCwhnPVDz8IFCtjC26q+TFTrZpNsWfTzME5kNvA9Svg=
Received: from CH0PR03CA0271.namprd03.prod.outlook.com (2603:10b6:610:e6::6)
 by CH1PPFF5B95D789.namprd12.prod.outlook.com (2603:10b6:61f:fc00::62a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Thu, 29 May
 2025 21:18:28 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:e6:cafe::9) by CH0PR03CA0271.outlook.office365.com
 (2603:10b6:610:e6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.19 via Frontend Transport; Thu,
 29 May 2025 21:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 21:18:28 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 16:18:27 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET
Date: Thu, 29 May 2025 16:18:00 -0500
Message-ID: <4c51018dd3e4f2c543935134d2c4f47076f109f6.1748553480.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1748553480.git.thomas.lendacky@amd.com>
References: <cover.1748553480.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|CH1PPFF5B95D789:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f9d39a-81b2-495d-c13b-08dd9ef65b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qm+ynDRGokrLSeEhR2qTcPUjf0SaClkkYpNxelN4YLJG8MPBAxRxtO/FsItC?=
 =?us-ascii?Q?We/QV13RuMyVGmnR9mNl92bHU7Jvj++Cvxf6poXDWOvCbfJ7n71tigSJPulM?=
 =?us-ascii?Q?BwL+NKjaoTMzB+F3DeFDmEgPIFMMWr54Awtmi+e7CbrsTdiiq+Yp7qGac5Uv?=
 =?us-ascii?Q?0JAa/6Crgq7rdtckn+/kYDwUNYoJuWpd2vp2b6Jwn4ePgNc34/gp2ZBqEaJd?=
 =?us-ascii?Q?QcSw9kbXPOxnUwJUl+X5a49bpQC56SKAPPatuTF4e/wqlWV5EqbCwXIlJCVc?=
 =?us-ascii?Q?jV/CAVqwN2g9TJ4xGbIC2giuPDq6h+9y9CjyJZvHWTdeZ0IS+bOngc/0t2GD?=
 =?us-ascii?Q?37jg0eG10KMVuaW0BrhkH8D608+vT9tFyMj7H9vmPs9WOIOvuLypIIu8dCbX?=
 =?us-ascii?Q?0EfbCpRWlta7m98p8ryE/MUoHKdKsZSNu9gHlkEaTWHp/Gr4rXuFD02CdyBy?=
 =?us-ascii?Q?jpfIt9IeoUxB2NxA37YCGlbHDbDzYpkgQroXEX5sFnPfq3g54b8nA62rQE32?=
 =?us-ascii?Q?MonVRcgqFvhNRqb0HbPb57J5SYZrnvC4Gisf4rNCUXRi6bpeG26LCJKGaCF8?=
 =?us-ascii?Q?hEIa5EPMdZ3hVFOmVmdcPjEmthV7f8Dj0KrS2AEgbxerwccks9SySMWUb5RA?=
 =?us-ascii?Q?EA8SsJuEXJOLgARJ3hTd+Yvm5W/KOp64in0cetjh3bSDODmIWojI9bR4d4Ss?=
 =?us-ascii?Q?K2N3oS+1BiiWZsgeQvLyE1h+X1YSweCmIZsf5QehFd6AFn51WmB9xDuImzcH?=
 =?us-ascii?Q?dOcxmpLv+L1zZ0JkmJilBu30dqe+5lC8Be63eJ9C+UZlWSHqpFxaHQu3YwsN?=
 =?us-ascii?Q?jvPxUzBj5wEny6U4Gmavb5D/5B6YQ0GMpudL9RUTHk558Z7zP+Gub2XgHMG6?=
 =?us-ascii?Q?ig+MsuDPeWp27oQDPcfouHhqCMxaOFEHjAQzRgLW7ddn3TmfUz1bqhrc7h/O?=
 =?us-ascii?Q?0e8Jn7Euo8c3fMe7ey6S/ZNDK1P4gnEUfR5NfuG066dNwVScIfldFBER3fav?=
 =?us-ascii?Q?LI/Nj5/RXoU0TVoIS3Vxp/GJ35AuolKpCGd8Li8e8dzGI61vfxIFjO7/foG+?=
 =?us-ascii?Q?pw6W2O5mdUz9Ahp7S3WgfPtsZTCBxpazcPx9LKeku+VlQ26KTrQLC+jZZBn0?=
 =?us-ascii?Q?L1V+QuZCyncC6h8vRT9UCaMMwIA4dKiOWl2C7cbNVUvcSrJL7k10bsnJcwcV?=
 =?us-ascii?Q?GrRPTqOgFgL6VsAf7hyAwkc23JUCRKbgttC8bHSpu7jrQIhDSDIWZkyw68d8?=
 =?us-ascii?Q?vvc5YAf2ZemDqcAbHG8ljG2S5vHQ2YJt+TeNGNtVvIlQ0jv0K1xdEiCBxLR/?=
 =?us-ascii?Q?2sokdF4PQRvitGoeZDcHLzMBo+yj4/sSb3nUaC7eYbIF5kNnbk1ashAkUDoZ?=
 =?us-ascii?Q?MIARkSj8V0OCYQdS052igTYQOSADTQWP5XvxvaVvDS73uCeer/fqhQ6UN2BY?=
 =?us-ascii?Q?ITBvTp2CgJrCgrktJLV4PoiP5w+pQ5TXovC43l14fhkSg97jL9JQ2hsTO/Qi?=
 =?us-ascii?Q?ChZw9GorTzm+nGg0Lz66LgOS6DuUp4u4l7tB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:18:28.6425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f9d39a-81b2-495d-c13b-08dd9ef65b46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFF5B95D789

KVM currently returns -EINVAL when it attempts to create an SNP guest if
the SINGLE_SOCKET guest policy bit is set. The reason for this action is
that KVM would need specific support (SNP_ACTIVATE_EX command support) to
achieve this when running on a system with more than one socket. However,
the SEV firmware will make the proper check and return POLICY_FAILURE
during SNP_ACTIVATE if the single socket guest policy bit is set and the
system has more than one socket:

 - System with one socket
   - Guest policy SINGLE_SOCKET == 0 ==> SNP_ACTIVATE succeeds
   - Guest policy SINGLE_SOCKET == 1 ==> SNP_ACTIVATE succeeds

 - System with more than one socket
   - Guest policy SINGLE_SOCKET == 0 ==> SNP_ACTIVATE succeeds
   - Guest policy SINGLE_SOCKET == 1 ==> SNP_ACTIVATE fails with
     POLICY_FAILURE

Remove the check for the SINGLE_SOCKET policy bit from snp_launch_start()
and allow the firmware to perform the proper checking.

This does have the effect of allowing an SNP guest with the SINGLE_SOCKET
policy bit set to run on a single socket system, but fail when run on a
system with more than one socket. However, this should not affect existing
SNP guests as setting the SINGLE_SOCKET policy bit is not allowed today.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 77eb036cd6d4..4802edfc5d9e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2197,9 +2197,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO))
 		return -EINVAL;
 
-	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
-		return -EINVAL;
-
 	sev->policy = params.policy;
 
 	sev->snp_context = snp_context_create(kvm, argp);
-- 
2.46.2


