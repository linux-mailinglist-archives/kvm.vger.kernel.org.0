Return-Path: <kvm+bounces-56407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A46B3D8A8
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4C8E3AC3D3
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874B7239E8A;
	Mon,  1 Sep 2025 05:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jh8IL+JE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6AC220F24;
	Mon,  1 Sep 2025 05:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704209; cv=fail; b=MKjN5UWbLJLla7lCFyQA6VDoigy3URuw2wWRQE7DEf4WxTWo/d3qWldUX1k7oh+22LeyV4Bx1Q3CWnxirde1LWzQFD47QE8m/+Br06ZPIcpcMgLUUHrEbSAsMW1ygfWjNJEyXK5jPM+ODe9nCQ2RuY7Tjqad/HJAH9u6QUINfUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704209; c=relaxed/simple;
	bh=YtvdGOc1ZcTDVBrrwhL2m9au8TjcJP6t4mmpxSS03oY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=InmPEVWwm6bUiN9489vaMhVVGJ/NW2MtpoP38KHE+oKIN6cNjCIZ5L+/Y2PwsfgoP4PHDxUgmIjDs23DYvKfY50Pm2mUIpdMcZEdcoBjNHFaSkZEAUxU5jODIoan00iv5PP0ef8SvnrncmfBtJyYwMHOVzAMwzd96zi3mg/k45M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jh8IL+JE; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ehq/7IFJ26g3Cv6DenvUFac0+A4dTdksolvz8C/LZj99G3XE5SVWShAPx+sZhEnUvb+fZTeS8sS0UzMEisV3fr92rfgGMJdSfdKslUc5slUiAvDLUqr29O0RSyo7UsDNFITADX4kBAWX01XO07JjlzuyYQ+jh2mdGwr0rv/k5qkpTZuegMfqwZ0B4JyHSK5khitRRKnQMSev9crCyuoX894GFY2ZK9Za5RvbGCSUbnLxJtBNlw8hBOREnthzgKhXSahb6BBBJ1MVM6euVv10owBa1LeUL7TqHSw676x9NPY2qLLvEd8J6GOJFncuDJRD0wTbQUQdpG6qNn2Zh2HgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHer2RysEC9GepzesNIjZ9MizSNR2h2EtXL6AqyFk/s=;
 b=Mh5qU3/suuHs7iwDJK6HnV3tmJiJARfwBP7/92l+uMGkNe2vNGBnnYjbyuGHi7DYUXKgTahnbIxM8aMZWZkob1naDHZVycdFBstHZx1JlXa15du9kISmS1ybip45HZqin/9z3ZnjaogXY9OPJjr9aaCCb3tJBolXYgzumC2Qws/8brQ/iZXwbiqXdGq+hTphRFa9gOnMzXwxRfF/tWBH1xjnJwSph28K5xs9Mfb0EepKblWjmPJvVVwl7n6BzDVfZAXWe+SLy7mUtg6yQroJozHQBhtaCPC6+/eBYqQNmHogBHnhyTQAHnAOquttacNe22oiS7PXmfe6MG64K57CtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHer2RysEC9GepzesNIjZ9MizSNR2h2EtXL6AqyFk/s=;
 b=jh8IL+JERXIzoJj2cW5pbtM5R4ka/fpoBikLLFfOdE0MK6sLBo1gQjri0oP0godm4mPzbUFIecqP+6MT35B+3vp4SzyQ05Aqxe7oupjhmCIB7ZE0ijkZGbCueSJP1o831O6zmy9UYLGzOpSh1z0JxPc7zH3gmM8EizAA/9sGzgc=
Received: from MW4PR04CA0296.namprd04.prod.outlook.com (2603:10b6:303:89::31)
 by BN7PPF49208036B.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 05:23:23 +0000
Received: from SJ5PEPF000001D4.namprd05.prod.outlook.com
 (2603:10b6:303:89:cafe::1b) by MW4PR04CA0296.outlook.office365.com
 (2603:10b6:303:89::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 05:23:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D4.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:23:22 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:23:21 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:23:17 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 06/12] x86/cpufeatures: Add CPUID feature bit for VIBS in SVM/SEV guests
Date: Mon, 1 Sep 2025 10:53:04 +0530
Message-ID: <20250901052304.209199-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D4:EE_|BN7PPF49208036B:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc7f837-dac3-45d7-b14c-08dde917ab59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PBbWbCBFX7Qwmv/yeP10vSXNByElqt+pJabvtMdAPgOfJgk1v5+5VqEHQ5iQ?=
 =?us-ascii?Q?qULDeFclMPGlXU7pyVl6ygADiL3vvQPYDk4OAPv4Vt4MwERVZC/nvmq7J9BY?=
 =?us-ascii?Q?zE1f9oohIYBCq6FR+ABzOn86pnPnnMb54UrPBsuavdtwK74OA4Adk5Lx/+qG?=
 =?us-ascii?Q?NOYa5fomRVrB+64UhTs5RqC2O0iSh3RzxXVPSgn/wXeKkaBqT/elmJclRDMk?=
 =?us-ascii?Q?aLNR1aeKZXdb9qSPZkMwPNPY/C9YNvl+M26fouT3T9aovc0U9ld89o+XePWc?=
 =?us-ascii?Q?Pv+NwG5CZagmo3wx4LOD1EOjwNxFiXhhzgc6i6sdOcdmBqK7mP3PLvHLFAPF?=
 =?us-ascii?Q?8LzepjC0lqH7I4XRFJfcCQWzQFQsXawkJjIp04wIVEYuWJc5hS7xDKcUyJCO?=
 =?us-ascii?Q?PJeQBZ1lILzJpgKZsw+0hvWRMpI/T2Qiq0be7LdvQ3aEl99nd1nO8bpzUZ5D?=
 =?us-ascii?Q?z23RNmwnldHPTS+ActZY0ttsGq6h08Vc+7ud1gR+TvCH/MY257XW3lc1DZbI?=
 =?us-ascii?Q?xjahR1iOJfcvRtzaD+12ehvzLlDPJrCl5TG8AJURRlNMq/pvKPe3BiIRlqQb?=
 =?us-ascii?Q?cesVW9VRITSTJWk4OZwxhBFqHbxwAKv8RtNKlaKCGxV2QIEHojfczfBVTjoi?=
 =?us-ascii?Q?i1EBhdaamEs5byiaA8EGOk2tkg+/S4wxCqX/+re4llp399z+QmWjcgSEblRj?=
 =?us-ascii?Q?wz9OyjjOOiOlPFxcAcaEfkAH1SV0qeaEbfm+4GMgcue5oFMloNfyHrnrwQ+C?=
 =?us-ascii?Q?jtpDObUDIWot0HDh3nYzUaq6gYiQ8EFlSCT/TUeBIZgTNWMa5fYYFybMXz7n?=
 =?us-ascii?Q?kI5zjgs/20xCl4SpI+QaxW06ZdLUWzBGfIaHVHnUlNmKRcXR5ehnU9F2az7M?=
 =?us-ascii?Q?iyMeeeSwaPkvA6SAmJqwqsyGvrECylLnR+qwyIbi8w++hrviCqFIglYjpbTP?=
 =?us-ascii?Q?5jtbRBwxQF4PgMQHb+UVv58UvbgdZzw5BYigC6pOJZlZPHI0IzFrYQgPK7R7?=
 =?us-ascii?Q?y2aSR4UZWbVcdTKxq1YIWIvTOzHelwAB3jS0Yal0kM7ux3xDZbdsWumTHcEP?=
 =?us-ascii?Q?BmUmRdd+HcstwTPTCQWO/1dunzhjtcPaJYSoaZLha0wt1WvUlVKcbXU//yLa?=
 =?us-ascii?Q?KaEIJwui3BPK3ciNOdy1eSzcSK1jb19C2SLBqjszA/MUZZjF/7ZVuNsrt+mo?=
 =?us-ascii?Q?N6NNRPKFNBr72WsZOBcNAq6SYSucyLnS5Kk4bxX3HIPAkuZ27gUnNysdOGWT?=
 =?us-ascii?Q?xHOtjXcq4/IzebKfeLBNYKHF/xRF5mOe9ITcb91qhaNSzUwvrFJr86TWBOT6?=
 =?us-ascii?Q?qL6wtwbnKm07NW8xmh123Khj9inSk43TdCg1ZfI1yzkdX1iBtYg3L50kJ37w?=
 =?us-ascii?Q?0TnXd2cKle2HLdLfZqLpt+Naz3HR/sSVrXAOhXzQVYpXK/m0SHfEpuJeWTt/?=
 =?us-ascii?Q?aAtDQH30TK3vC/vZHH42tdDn2ejE4hohJlx4i8ExyMpOJzDhDI+csuyCeUT6?=
 =?us-ascii?Q?8MJhvCzvKsphef9L3YNWLjJ+Frp5DtG7ZajG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:23:22.3441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc7f837-dac3-45d7-b14c-08dde917ab59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF49208036B

From: Santosh Shukla <santosh.shukla@amd.com>

The virtualized IBS (VIBS) feature allows the guest to collect IBS
samples without exiting the guest.

Presence of the VIBS feature is indicated via CPUID function
0x8000000A_EDX[26].

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0dd44cbf7196..3c31dea00671 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -379,6 +379,7 @@
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
 #define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
+#define X86_FEATURE_VIBS		(15*32+26) /* Virtual IBS */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
 #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
 #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
-- 
2.43.0


