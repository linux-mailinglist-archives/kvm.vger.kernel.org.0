Return-Path: <kvm+bounces-58451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051ADB9445B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE7A72A7C4A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F1730DEA0;
	Tue, 23 Sep 2025 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nvvt4s65"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AC378F20;
	Tue, 23 Sep 2025 05:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603833; cv=fail; b=Vr3yvOPhA8ZD+rtegwTmETwFIw5Fm8Yv4FXMse4aGKHqwm7TEtW65Mf2P9JME3nCbvKJl5x+5tdJGQAAHXoVcT8c3DAsWF56djqCpRPFQ9kTU2ffUKd7vGlkwgBdtqbLSt6xfRe3pobcYHjHS9Zi1M+N1V8n4b1KN9YLGreu6G4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603833; c=relaxed/simple;
	bh=2tiWmj5tbWPnqt+KzIU3n8r32FslmLXKDjxgjYgBawc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVJ4UGqXn0dNyTAuEc6qdLmwMENbAbe6QPxMiS5ctzo2J47SjkZyOw/qY5qP0XgWoS3rGi8mIVtiMDMH2SSORnApCY958Ht3F4KE3wRx1mg3rGYcTigMH7aGfrgXC+x6NboV7/sWHxeXUGERBRr1wIfUc9hP/NANBOcMzcpWbuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nvvt4s65; arc=fail smtp.client-ip=40.93.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQAgONYl/EvJLFo9Tw8pm02Dn4BbGi5xuhNjyROHdJ14+3jrm+sGq1+eRl15QwHlDHhRa56GLrV2j2MKtvcUJcYybV0GhP3gvLqYxVbopXInljWT7f2kHzeQ59hm31geyoW5aeGYANzfKLdqwAAcN2k8tohOc78SNnyAr9OXl3DnqW7PZ78wuAAaVjFTBqgS1XVP2Z1GSndEFYmrLbMOOe0MkWg8o9z6ZeOg4nt7GXmLeEHexU+NKZhSMRRngNSrQqNACRiiWghqNfq2xMBKzijE0OZnWdMAU6ymyzwVNZrQJfGPWbL7NTRDpZwFuiMU+W4rGaQUEah7+MBaJv1INw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOgofAUOqeVeyu/S/Mb2UWuWgCZeSmaKMloA9eXd0Ug=;
 b=DzW2c23hG+HENrZKETZBk5tWJZK5PgulJoTuSQ7qGShOv+CK66EoXlVDkQ4qgz+zCzlic6+9NqyfcmFlo/hDKXz4xMTaK6OjJGf6XdiRjghhPOcFbeKJlor+StOYSxaIIwN2wuZnCJ2TUoJ5loZwFG2z0eZt6IuYz1a1Qjws7znn8Advuo5I1BdFPmle5om9POy8giPE0KV02etaTdgkPb2U433089B/Mdt3c9jPw4VTNGDPVxfAHBndABh6i5Uf4GBQy+4tzek4lceIyoqfdPDs83Lh4FUITip6lr9plIZKLLKC8SogvQb7dzvTzhe/WA5E9SsOFDrld0hs0UtkkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOgofAUOqeVeyu/S/Mb2UWuWgCZeSmaKMloA9eXd0Ug=;
 b=nvvt4s65/RanfojOK3LIZb4fA0HPW56Zk3ZJSAhg5On78xjNMBurq6bItKvbJDhGakfglkgNRBMKobLM/ykSqvMihtFtQ9F1ArCAZLtriv56d92WMV3rkXzPy8mkJtHFaYdaN1GD3kBbzWWcYgrVoHrQknbezdo2HSIGoMubgzE=
Received: from SJ0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:a03:33a::9)
 by CH3PR12MB9028.namprd12.prod.outlook.com (2603:10b6:610:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:03:47 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::aa) by SJ0PR03CA0004.outlook.office365.com
 (2603:10b6:a03:33a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:03:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:03:47 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:03:42 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 01/17] KVM: x86/lapic: Differentiate protected APIC interrupt mechanisms
Date: Tue, 23 Sep 2025 10:33:01 +0530
Message-ID: <20250923050317.205482-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|CH3PR12MB9028:EE_
X-MS-Office365-Filtering-Correlation-Id: f47ccb9d-3f1e-482b-46c5-08ddfa5e941b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HYbgWipPEV/XB+tmBEXYV7sc4c5jSkxnHLUrsyDe+mlwHPTKtDKW0rNqhJ+9?=
 =?us-ascii?Q?/ILWGgqLWUADIIE5q/8wWON34ve5o4G6lDB6/v/x86TWcOnIeO0+Yh+nzmIG?=
 =?us-ascii?Q?Dh+uNNRPC/7hbQJb+S8zgqvQgqPWxdUHMQN5ALvCQBl2DYmA6L68XGL7jtin?=
 =?us-ascii?Q?2pLygttpM9kqt6biLGvw5QnD0D4BlmfjDufYy+omQYHvohgECW24hEqP2mSm?=
 =?us-ascii?Q?kWup8lkYPAYS2LXKOXNQXeqvSkoc2zJCSSAP5uCGsz5eWAK+CuDxhhGO71mH?=
 =?us-ascii?Q?xSSX8TKpvprL8bBbFujjhDtU12qTihxCEi+q8f0PIZxPM9T8htOT9wqKqG4L?=
 =?us-ascii?Q?yrpiSN6hANj3BXahGWLHswZQ9xtRz1EkZdhTt/leu9Zs+h9DNk/uL1jB4L5V?=
 =?us-ascii?Q?pcZVBu8HenIs18MXu4takvF25V+PPhw+3OrhyrmnHuCvKM2ktnPOwsCGfEFC?=
 =?us-ascii?Q?IM5TzTzjTd+ASKNRJSvoSSlwFyuDaHC0+0UYVoNjqwwHK7uVa3FAcHjw1QWc?=
 =?us-ascii?Q?caYSbcH4wT6OIH8BGWIDBWz7zkaqA9TrAe6hsJ41o2bm5+M6+FOaJ4fyxRVy?=
 =?us-ascii?Q?7xjb80wF4EpmPmLZZepqnwfT9OWH8RLh2I65OkODhc5uaTbZex5RGU0leuTl?=
 =?us-ascii?Q?7WNvOAqvOLolremVUSvrDjF3+NdQI2GnexwAjufbsrCiWKykUOX/OdEtq8lY?=
 =?us-ascii?Q?D42E58J1o7jyDzZFYKH2udlB0tOPoMNAZ0ErAwBher7ZAgrMiDd1cRGMpou/?=
 =?us-ascii?Q?6xBI5wsYb9U1RRJ1AE8zf+VsrVAXcuZkE98UMlDW2J51uVJc3NA1TwPgsf46?=
 =?us-ascii?Q?2xo87qnP5AFUN9zv7K3gCNc9nSdECU2xWGCxFcX/zbYthlx9gKYuqvR+oVPL?=
 =?us-ascii?Q?of6Kl6aIY2KvgZSagO70LAaLo92EJyNph/dMjl13pTHybKKDvSqVVbJzzAws?=
 =?us-ascii?Q?Nkjiok1gK9Cle/nMYgI04RoV16MsSrduUwL+Dz9zHCjw1w/pH0lbN2rKUXX6?=
 =?us-ascii?Q?f9GUnube0z0TEBVUFxR9gdnleFTPvnXmlemXFblyU6a/3goq5fgXl5u+x/mt?=
 =?us-ascii?Q?CH8jrXKIQj1cva8+Cy8VXYE8xJZgYttjzMS33jQwBR9xdGQC3Mtxu66tkcNE?=
 =?us-ascii?Q?TF1aCfaP7/f0F27umm9fbMO2UnJ0mq+ro1BnJHWnLNcKzdbnpvnl2019WpXk?=
 =?us-ascii?Q?D7+CpoRWFGDuB5PYFhBfoZ8Pcu45cQipxHdk1iECpW3H3oLlHS2tp4e0St6W?=
 =?us-ascii?Q?Op0bzpSNRdEtFoIgHkYrWzvhL5wlx48G7oiEvl0e1EIP7iTDsjCJM3XvE6kS?=
 =?us-ascii?Q?shPXw05fKjMKokWifpXYMbXk8RGHMECW9Q+SooowT2Df00qYaBpusWLrpwen?=
 =?us-ascii?Q?iZ2iNAf3TcecVi8d9lAPnBheiCRFI7hQYb/xKhXwFKpJa1pv2hk5/HkWXBmg?=
 =?us-ascii?Q?1dW5NCjFHJtiSdPzyZrjWxXoIuGVcpgmKAKIwDQsA61qFdKoy5Nca4q7DGZR?=
 =?us-ascii?Q?fB+PIdx9j//2QfjReMtXff4eTnBNp0Bkgzux?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:03:47.3808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f47ccb9d-3f1e-482b-46c5-08ddfa5e941b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9028

The existing guest_apic_protected boolean flag is insufficient for
handling different protected guest technologies. While both Intel TDX
and AMD SNP (with Secure AVIC) protect the virtual APIC, they use
fundamentally different interrupt delivery mechanisms.

TDX relies on hardware-managed Posted Interrupts, whereas Secure AVIC
requires KVM to perform explicit software-based interrupt injection.
The current flag cannot distinguish between these two models.

To address this, introduce a new flag, prot_apic_intr_inject. This flag
is true for protected guests that require KVM to inject interrupts and
false for those that use a hardware-managed delivery mechanism.

This preparatory change allows subsequent commits to implement the correct
interrupt handling logic for Secure AVIC.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/lapic.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 72de14527698..f48218fd4638 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -70,7 +70,10 @@ struct kvm_lapic {
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
 	/* Select registers in the vAPIC cannot be read/written. */
-	bool guest_apic_protected;
+	struct {
+		bool guest_apic_protected;
+		bool prot_apic_intr_inject;
+	};
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
-- 
2.34.1


