Return-Path: <kvm+bounces-16319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABD88B8740
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E52DC281F65
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624405101A;
	Wed,  1 May 2024 09:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1RniRHzq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E274E1CE;
	Wed,  1 May 2024 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554417; cv=fail; b=nf8J8n4rYsOQe7yq/bpYup7OTZJdzmdRDltmYM2Jry+9v4Yt1GJTxxaEi9XQbYjb+nD4tx3huhjoKi77UiytA2GUgn/gIYFuKyoeBoPglnTlIMY+Oep9yF0dwnq9RIWQMM1ytc6KkExE3w9i+YX0lZfd19/INT73XL6hDoKigKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554417; c=relaxed/simple;
	bh=6+Xu3VEmTUE7ESBzNS/FjAKGK9BVXpheciBLCAa3t+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KksnVKkXZ/QCofn/LJlQ3wNKg1YcdyHL9zXbqBDxlY610DU+lU4sEHBi/X7hOMdfPR/Oz1qCGDiXnGDGeQSZfUV94NLQoHtoUcRTISK5qy9b82YoQly6T4tOUSi1RKZ4E7KWucdIoB5g8XgQMHroTQCUDbg2XWiiXqhafKWtbKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1RniRHzq; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hs4Zpl/KDiYMOwiM6MGWXmc3tZVzsz0qzZvRlm9MYn0uN+RJjhcM/Q7rMHiOASNxm/musDM7CXY+u7o2qQdVwLEWIERNzFCsZIEjNy3zIzqweQgm9XlDS9DnqE4eGwMQhWyThGCtWd38x20lklXzRxWFBmwW4Hr0xtqbLMz2BHmnaNKtbMfKpD22JgdocuBldhf9kzRAtL7asLhIY+aUzNoW9X2lAxUzWFYubRalIxlZ+lkuAnIaKXQeWKiU3l/Zz4h/kE5nRMKb3RvNyLLoStpyJPPbN4vvqPQMWsYRLsfL2ocesYDKO8SkD9FTIkMlodjkIEpVeT/b0oUSEpv0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alTvwCC+QqKAYNVMqng3/wZwTqjTdFBEpHqD12DsSYs=;
 b=jAKrzLfBE+8cAr+TTxs+YEV35l9dzR5aGvP8nNLWq5bnYtqm6dLnAbm2SAwgcN7Fp8TkqwUePv3Ne81tsY84uynn9aef0zuVRSEeo+f7XIIKq1TN6I14HOvjy4JaokYR/cexbAHk7QkR5n3tAa2ingWQrx0fb7Jc34pVGaqoRMTdPjvuS1Hg0l5KHq0/bNi7LZa8tBH6/ayGOXEfJlcc4ga0Uqi8X4lRs7JxbObQkfaQtkXt9HlCbxLxYOzOJgiQoFeoPKQPhzt6Cpnc5LmZI/I+0FprGgNElcDsmZQ0O3zArTyRmGlfyoBtQt2fmIUh2ofUAm5nETZqIv4NMUIKlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alTvwCC+QqKAYNVMqng3/wZwTqjTdFBEpHqD12DsSYs=;
 b=1RniRHzq59ira0ee4CYBmOLd0r1cGkiWOJAQkr2v7DDe+iY6yDpWVgQuAZDl2hSqxh3cOUUgNDYv3jMpm0guwmimVgEiR/+bP6Ilmdlmv0YlmFlwIMX4k5lGBw4vTQbXtxQt/udWmmtYMEc6xgGMuXW8Z6XSJrsqPa1kMY5QYsI=
Received: from BN8PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:60::25)
 by PH7PR12MB5855.namprd12.prod.outlook.com (2603:10b6:510:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Wed, 1 May
 2024 09:06:53 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:60:cafe::b5) by BN8PR12CA0012.outlook.office365.com
 (2603:10b6:408:60::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:06:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:06:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:06:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v15 01/20] Revert "KVM: x86: Add gmem hook for determining max NPT mapping level"
Date: Wed, 1 May 2024 03:51:51 -0500
Message-ID: <20240501085210.2213060-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|PH7PR12MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: d13c5f51-a792-44ee-c5e7-08dc69be0b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|36860700004|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pE+Dw05hoQsBzaunELHWHwft+hszd+4S4vLIt5eeMUk8Aj8aIeKeC9SYREri?=
 =?us-ascii?Q?kfcv9BaesLFsCoqzI/R7rjMj+3i6gbOj8MrRD4qRsvfDS9MFgkP58OIMUd3k?=
 =?us-ascii?Q?zJqfdlJ+cy+3h1O9Eb9OQMPfFcPdJ/URTiyI+YAUwrj6Ul0+VfI5qfsctB6S?=
 =?us-ascii?Q?yK/L1md0OWQPV/Cef9Q/iol1rE8txlwcOgtogp76CP5nKmUTJskeJcgRP3TS?=
 =?us-ascii?Q?4LpQW85wuEV4Ti2EYU2tmqqVMhTaPnPHNfC6WeyYkdX9rLFOd/AFdTkr5FPX?=
 =?us-ascii?Q?b/X3/k1KEsOyAC8IG3lpjKN/JGRHrZvN775Mun3PDYlJ8QbCfVJaoty/dkgo?=
 =?us-ascii?Q?W4SFTnOHxqapTeJBkyayZbmltgdTejO1+YSDjVFmizds96I5A+rLNvvbbH+U?=
 =?us-ascii?Q?JKf4PWA53/AXodQJESOvoDjSAE4S5LwIvSEePMVe3G3VK1Jx9DYKuNOYxkPl?=
 =?us-ascii?Q?nTEfouviaOQbNJ3xK8++XdeDPaMx5bwoMVbEH4v/4Mh9jXmm4MhrLUPHExF6?=
 =?us-ascii?Q?3nmvAvFZs99Dpn/T7Eum1LGzMfxPuMsP/R8rTE+OSBZ0sFx2iL9VQb/2nD6S?=
 =?us-ascii?Q?Ifk+rbX1EC5d7ex3aZN73xmKNxdd86mmCjKUdSPHmburFljdd7paTVNuMXci?=
 =?us-ascii?Q?0LfqsbP36E18wXPbrWKQ+Ky9lkI8+/DUYVJsN+14ub2W9GgsIRlPX1LN++cj?=
 =?us-ascii?Q?XR9/hzBHVlO1Y7pjByE+t69L7IEI9KJEnP2iW3Kg36kDhoQ0T7C6/R4oudLn?=
 =?us-ascii?Q?mFw/6a6EXS8/qMKfgd25+7GBKff59o0SCbiC74DSwVIiss1HihXVHU6a4MYE?=
 =?us-ascii?Q?nl1jW5sCknRJh49QtE2jUA/lah6Ap4rq8XA/1SG9z/+J/5kxXxcBrYkr8+Dr?=
 =?us-ascii?Q?VaJ23t2lwvtVt0exiRIuSLXzl54cxzv0IFb9cOodS93ZfNrfd6yq8KRU1++p?=
 =?us-ascii?Q?KiigXhy1TKaYjyZGF9w6hvUrsNZYNPOiegsoN1WHMxHMzjiTbcgnWGeQQTCz?=
 =?us-ascii?Q?0mtvBk1fQu3qKHzz6nM1CteKYIH8kSEB8DQzo6ILa4GON2RlQkrd4S9hT387?=
 =?us-ascii?Q?eN12lUzGMV+CdksC63OEVEUs0366bLPvn3hUTmwdkQYTXSimB9SDXZIvKNVA?=
 =?us-ascii?Q?1bLG/RY0l2l1Un0EJKzTO6WdRx3oQAzMMoJHN25HNTTMbwsJPd5W7hnzq8Pe?=
 =?us-ascii?Q?m4CebrCwERGP3i151CNmXvYmD+Cqh0ftUQT/U3UkppBxNXCcCAWSeNM+lRYp?=
 =?us-ascii?Q?gYf1Jj69r/8FSqQvMIaeH32G2sCsek11GR38Nv6u0fcNH0Xm4p0b6hhbI767?=
 =?us-ascii?Q?THbj4qPGWtrGvF0m9v97rjNw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:06:53.4762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d13c5f51-a792-44ee-c5e7-08dc69be0b5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5855

This reverts commit 20cc50a0410f338657e23e77fcc21fee2bc291e6.

As pointed out here[1], this patch has a few issues:
  - the error response could theoretically kill a guest in cases where
    retrying based on mmu_invalidate_seq might have been sufficient and
    so it should purely be a means to find the max mapping level that
    never returns error
  - the gpa/private arguments are not currently needed for anything
  - it's not really a "gmem" hook but uses the same naming convention
    as actual gmem hooks

Revert it so can replaced with a fully-intact replacement patch that
addresses the above.

[1] https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 -
 arch/x86/include/asm/kvm_host.h    | 2 --
 arch/x86/kvm/mmu/mmu.c             | 8 --------
 3 files changed, 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 2db87a6fd52a..c81990937ab4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,7 +140,6 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c9d8a22840a..c6c5018376be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1816,8 +1816,6 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
-				   u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eebb1562c5bc..510eb1117012 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4292,14 +4292,6 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
-	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
-						     fault->gfn, fault->is_private,
-						     &fault->max_level);
-	if (r) {
-		kvm_release_pfn_clean(fault->pfn);
-		return r;
-	}
-
 	return RET_PF_CONTINUE;
 }
 
-- 
2.25.1


