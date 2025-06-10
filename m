Return-Path: <kvm+bounces-48830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3038AD4172
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42E807ACC64
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF687247280;
	Tue, 10 Jun 2025 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OhwgGINp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973424500E;
	Tue, 10 Jun 2025 17:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578393; cv=fail; b=Y6kk/z22M0lUSDq+AP89E34XBdPIK8+6BVauccs7llkoYewyyjpiz3MlYN885WW0Z4MfFgJPUjieCdT5hZDe6q3az4zT8pBi5P2Nbrhn6+99/0qweXYz0gYzAoCuj+SGVg1W6UQz48me3XUWs/HoMVz8GefxiLRQ5yW3xiy5NoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578393; c=relaxed/simple;
	bh=Ad/jxD8pi+s+XLQrKjxYOCqxsehbvDPjkvDrW9px0xo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6Ybx4Zju9znZUs2lLu6lz176fzYCW53lpmfaDPlYOVC9S12Om1eOaIA+hY8T3Vm2YZ23bOM/+Abe2hnNgYgCLOL1CHFOfksvN2LKJ8yzqial/i5iNrsBrhEmET0YKrgEz2OQe/LqWQs93ZxEleS9uSUAIcETHJNz2k4KombSLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OhwgGINp; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/B4jQ2NDIB9lD8izU4pPfpCGcKMShk2bSOMG3YAhYBJB2iyTGsudB90MP3M5ZTTs6LQhHjvcAZbE4q0v7XuPpSnFujv03CVtJ9rG41SBcrXb50XpKd8Z/lAtuz3awyiDDAWY2Iy0UlwtGyzmkDm0InC9ERUduFBxx47r6HR7HEvCdftTO+5qOMGyBUXrWK6OXmO9N/IGWg0kfBu/p/QtuOc7LNaJFeutyu6YJzZv6ZhhqCL6S1VLTPA/6t5iXFa2DLNnLSMoO0UCjiI4QvVi8W4TzU6huCyFyuJQa1swnM73L4YLFh8QSTZUagWj5t9xS2tTxqYkGFX+vEd5iRU5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQUBkz9MI+HS76u9yxeLvbbRHTBus2mvth4HpRZpzvw=;
 b=SrM6DY710E4vmtVRYpXrzbRweePu/AKXQQr9M2Lh15Xo5bQCZF4/Tc2+C1aC9XSrztcvge+nAMc7KrFVJZgq0aJOoRH6Jp24BG5OXPYX98dsUTtBPJ7Yr0XFzx4XTrhbUapvZi/pEjoHmXwW6957WPqvBjz7XyV+IlZUmtkIsjgNVfwveMc5kWRN3OW0obz7lqYImbxyf7UsJnQ2Rc/Ml6pNscDGmepQ1ATe6pirCTNTu4Fcix1qfYjYSBqNjd5zdxiO44dNI3uqVzq9UqR9v7z6X+2ebqshnL30vD8qGxAbt1Qpz074XKu7BDtvl+709oHvgPvDKEDriswFkBfe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQUBkz9MI+HS76u9yxeLvbbRHTBus2mvth4HpRZpzvw=;
 b=OhwgGINp8crgGrodtIeXGPxJY1LPgixwIOU0NRxf7AcdPGNOANm0NO18at7+4A1iz5LkzYGub3QICkGHhlR3CLIAKOy+Gj35taJoOvj++DNCPHTiIAxi3xoxJ/wPmqLe8QH8itCHF0qA09Lsg1Ast1MDoNTtjbJI3ZRQFJ4kGT8=
Received: from CH2PR03CA0029.namprd03.prod.outlook.com (2603:10b6:610:59::39)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 10 Jun
 2025 17:59:46 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::ff) by CH2PR03CA0029.outlook.office365.com
 (2603:10b6:610:59::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:59:46 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:59:38 -0500
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
Subject: [RFC PATCH v7 14/37] KVM: x86: Move lapic set/clear_vector() helpers to common code
Date: Tue, 10 Jun 2025 23:24:01 +0530
Message-ID: <20250610175424.209796-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 43e0185b-7372-4854-f558-08dda84895cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?biszSFRB1Dsv9H0/ejzauTGV7UNdUPxYWnsDsVIi4XlNQCo8uyE6i3h+IwQY?=
 =?us-ascii?Q?ImrRFVhOUtapEAmLU3jNaG75wzbgCmuiay1jhC22RJfDMQqL9suvF1C8kHgT?=
 =?us-ascii?Q?byAJ+1NQpnYxDNcIhgj/YBSPFcbRnh8zARD88usTc5gUdrnsN//OdhET0sX8?=
 =?us-ascii?Q?Un7akijWJKFY2ORmrTLP8WwW3QcpJpdZGfsvnJhimWfV6dLe+E2IYtHEqr98?=
 =?us-ascii?Q?oQhNVGxsufoNi3ARAkjxtGssMcL9ZkohgNN7Ao9z30ZAzpCeMzcZkcJzkkE1?=
 =?us-ascii?Q?8koL/+0u8n/W1mRv+5qBh9kz9AH3rn+FTe1uLVvNhrCtJVy8DsmLB5JhiqKk?=
 =?us-ascii?Q?3YJ2k3vIU4Wsi7Hd8sxPOdG7eILc2N9gsa0X7nZjgITwyU9DP4lyFn8dz24u?=
 =?us-ascii?Q?8iECJq1gPgd4psfbDyTQPAMe1VW79pWwaf/82c9woL5yOWh12AOuf/no5usd?=
 =?us-ascii?Q?SrEQgTaynyOQxIS0LXsYgE5LdEDJbsnsFC6698+YpkmUAMHfO+ZB5bj2gi5l?=
 =?us-ascii?Q?O2BmhOvjmVLgdd6CZlcpet/0BGkcJiPkB+MsC5cPhVzacuqL4yBOWSW8DSUy?=
 =?us-ascii?Q?zOih9ntIP8IGZaxZ5eI8JTGy6PysBpQi1uKQJpIaBfCRw/cjiCDaxPIFQij6?=
 =?us-ascii?Q?SnE3fC2i2hI12XAVoRk6I5NUdXW/N4aUldBf85VvP96YTM8rlZCvySP6nwod?=
 =?us-ascii?Q?UfknZcnhykEfhCozMGz8p5vQyUIjIj/JYiV5FtxKo4zGqwYPSMjHK3DmiBNs?=
 =?us-ascii?Q?lLTrVlwMwIdbh3QheVJr8XS19NRHXQUyCMRLnmsXtKDHE0CBm2G+DCfNrqZe?=
 =?us-ascii?Q?BzAPF62z8lRifjRQl9dPdrAPAz/t2Lo982GrPF49ajdVsuuaaL3ljatvz/4B?=
 =?us-ascii?Q?q4CBEQJ3kruoPZnZaywxJyZNvcPxniwzh/8GDYiNh0krh6cLoolYpcdydYjG?=
 =?us-ascii?Q?iY1cKK319QRdtK8JcxrRfa36vDkmHGXE9SDnUjTdy2q1mvYhNqAq0IadAbh+?=
 =?us-ascii?Q?LLsSDRDVg/RtLQreCSMBN6JE+fuHBBFZlXt/OPinzEXl0CxfcAtyIOJ2bBh8?=
 =?us-ascii?Q?1KpNsyf0Fpmepg9+t6/AvdMA5Qm0QLVWQgnIyXHL8VOXyTJIMMkjgLA9nbGj?=
 =?us-ascii?Q?5r8m7YYSVg5lpyrrmjl2xDsaF1NG3t5c/zjvwW/NYXj14c1K66+m7dbc+CmI?=
 =?us-ascii?Q?sm+ZAGgjy87ZWkUhAcAVbp92agCNy7mDBD4DQDUenDOIPSIWL3EQlYCaR72l?=
 =?us-ascii?Q?iKTB1PqJf2e4h/zLUKDB1ujeRaB7GOZdq/AeJs2NOCRvDOceO2kAa2MrZruW?=
 =?us-ascii?Q?0yMnY0eH5BgcEKfXdDVY7zkTLM0qMfYr8+Hr9vd15XdVZ7u2fqRi8XoTFzOJ?=
 =?us-ascii?Q?zbWbjd1L/6o4Xdk31SJImr3EImHjuswhDsA16+CKA/cWb08rnRGbCu17MfsH?=
 =?us-ascii?Q?zUTuMuCzN+PRNIhhtC2Fqth4M+e1pvlK8bfMhNbU83V1hrpbgv7ySJuP7UTO?=
 =?us-ascii?Q?LZP03ZYVSy44HMG8LmCybGCj60JlotU2uwDr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:59:46.0287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e0185b-7372-4854-f558-08dda84895cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284

Move apic_clear_vector() and apic_set_vector() helper functions to
apic.h in order to reuse them in the Secure AVIC guest apic driver
in later patches to atomically set/clear vectors in the APIC backing
page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Moved function and macro renames outside of this patch.

 arch/x86/include/asm/apic.h | 10 ++++++++++
 arch/x86/kvm/lapic.h        | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b8b5fe875bde..c6d1c51f71ec 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -547,6 +547,16 @@ static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 	*((u64 *) (regs + reg)) = val;
 }
 
+static inline void apic_clear_vector(int vec, void *bitmap)
+{
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
+static inline void apic_set_vector(int vec, void *bitmap)
+{
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 174df6996404..31284ec61a6a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -147,16 +147,6 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-static inline void apic_clear_vector(int vec, void *bitmap)
-{
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
-static inline void apic_set_vector(int vec, void *bitmap)
-{
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
 	apic_set_vector(vec, apic->regs + APIC_IRR);
-- 
2.34.1


