Return-Path: <kvm+bounces-17216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B8A8C2BAB
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17EC52842E6
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEAD13C3CE;
	Fri, 10 May 2024 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NPlrfPBF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7756613B789;
	Fri, 10 May 2024 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375915; cv=fail; b=s72yc4ub/FZLG0tEtXTrq/Skgi0A9YG8cxEEj8uE3CXx7+GvyLRtCCk/Z/CecdrTL4hdp4WbW0jYA0713JvBDAdCYC2oUZENRGUsRFEyqjCZ0gW02HI0Sa/92pZKo8awFhmJ4SJyYiu1YJZOogfKOhhkdTLtBBpq1gDH0vkCLb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375915; c=relaxed/simple;
	bh=1slvbwcBV1cu6GGG6vbFi13UFN+j12sU3GEU4fyumJQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7f1tHx1Ovf0uDC3s/kmjS/ma3AQlpny7tiS9YWHlh+F7IWOaZED/0qUm4f+8bRG4lQbKQTcQUwmouvZtoU2HR8Bg4Q8M5qKb1ONLfNWcF2tBIhYOSU2IrG29+PjlOPqoaJACsVT6VZFEvImR/P+96871GeX5wyzexdM2VXJDUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NPlrfPBF; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxAqNcc1+Pwe4mmQatTsNj9LXUX1NaXHK+Y4t835ss2Yz/c53csC3wY8QjhyE0jTKMP94kBfRzrCHoSiLZ1iL7tcCzL0fFH8LYu18qMXikdnfpJRKJuJ0BBX155uTBXaRzl8Hi4hrHpPl6uXFHp6+/8n5tRaIlyGddenuLXvLViO2+hdGgRGTZPB420P1l60cfBzESC0Ygb1rzhrIdnDweVvpsW1toGhcEK7C0paO2/+OR2TWXDqnOPYZpPC1U8DPZYND2ma1e8SivwSVoPIwHcVwn0+jEA12rCpRyAwBimpzuMboFPVPLtgfi7l5waaSABapmbs0ZD6gH+z7taJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3RtZPSSBOzA9Vm6vLE98EaAy5syvEiaKlqSL7XgJ2Y=;
 b=EfXd+8nP6kICxfe2mZxXr2Eq6F8QEk62VwmQQwrJmsWaydSXc1/OO6sPO5dFGqxQbzw6HPDdJM5dKA7dKUDlFwWE0lM3CSaoO6KHOVxQI+7oWUdJ+hUyb0uKbmJzRs4HuffL5xDC+tpC0ARQjUG7+8C71XGTiyqisggOiWzDRwlhsrqEWWVbC3ig3ypgZ+AgmusJGksrrOJJ9FsQ/QiZCv7OyAD3in3vhjxNnqhY0WuvQB/lJlv5MWsmDztEou5tQJPpQ4gU/EfKXvkBkAg5058BjbpVgKRuTrrt8q8b+P5tw6rhz8F33oZMajQjPj3Ezq2v6cgqMoBNUDtrAEezZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3RtZPSSBOzA9Vm6vLE98EaAy5syvEiaKlqSL7XgJ2Y=;
 b=NPlrfPBF2gINsJKjh1qJ0uHuBd1MP+Shay3okar3lxCKE+PBYIJSFJSo+/rRpoiRAlH/tCiQ7rvObMd3iKPGsCeqDtFqPS1d+igTpUqEPPFejvyxpbZug7Idhtim0xxlOJQ6Ijbixj2RC3XMKwHilfeTpP4U4V5a6mZzeqBCCuE=
Received: from BN9P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::21)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 21:18:26 +0000
Received: from BN1PEPF00004683.namprd03.prod.outlook.com
 (2603:10b6:408:10c:cafe::f7) by BN9P222CA0016.outlook.office365.com
 (2603:10b6:408:10c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:18:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004683.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:18:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:18:24 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>
Subject: [PULL 13/19] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Fri, 10 May 2024 16:10:18 -0500
Message-ID: <20240510211024.556136-14-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004683:EE_|MW4PR12MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d2a2326-e8d0-4866-2269-08dc7136baad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9fEwvTNGb4jyf0xAQAd2kUZP/nBvJYm8dmJL4Z17GsLf9+DISbmrf1dxXqlN?=
 =?us-ascii?Q?cWXYI+9iuNZj+fqKv8Ov+XiWK+tcc7XubJLd6p9f4fyFUswJYl5PvdJKOaj4?=
 =?us-ascii?Q?fC0MTfF4kyI1AXLBScOdWyEpdXU69yhpd6J8vtWhNBToRW8ZgIOzujmu8z3J?=
 =?us-ascii?Q?LO6sTWXqqXuRYgdMLeerT2HP2zEpwiW/LCwpRgKbkjZ7pvPMkANj7bp8aFMO?=
 =?us-ascii?Q?zedboxJ5D83PUvMxIF/7/TnneCQtpSiS0pL/mYJLCH+fviSO+dHwc9lZBVVG?=
 =?us-ascii?Q?RoXjuMjSa8lQ/y2sg8nMKjHF4vEBEbdt17Zb6yIkTFFbLsHub1biKDqfr4JL?=
 =?us-ascii?Q?2Oq4iII8ORZDwz2oSxS6tv/4aRYYYQb+u5pHZhigj0bNKx8DKMKuwzHiN8uP?=
 =?us-ascii?Q?EySEdmH6jd3ngbQugDtXHiU4Sq9UX+BomsdEqHnR0JUOKu+05OZXKIi36anu?=
 =?us-ascii?Q?9kLMk3uXNo9IdfPXk7Hdjrfln59fJ1LjXi14ala7R2SbgQ+aJV0Xm+pjBGz9?=
 =?us-ascii?Q?hupqYG/aY0O1sOyebGMVJC4e7yfF36NI1lFq+wOwF610FGJ8djNhZY2ogM3b?=
 =?us-ascii?Q?6hEX7RKDDt5mG6P7fkRJWJZNNbIUqQ+RHaKsKt3Pa7Ut/Xceq7cjsrfMdxBc?=
 =?us-ascii?Q?0KO5lK2tX682qYCkN8Wc9zmDr0b4cQLvOXjjYDfVJU70qq294jvOEH/zIjAy?=
 =?us-ascii?Q?zWgg1ZLVlTzLNyI0hW5KaoYVyeZNXupGI7voczj91IrlzVE8C0IVNiXilbB/?=
 =?us-ascii?Q?LOj7Gh4/V3Kc+BDxR/ZEUag0zqa3lFXY5K9Kd03WghMtkEqFs9BhuNswgNSB?=
 =?us-ascii?Q?2RJab/s80bH1a2jnhfuJ2QVxecj1AdxK9o0tEGawy8CK8wtGNQJeHICYi2BZ?=
 =?us-ascii?Q?5zIg5eoyGWO2GNTviOY+hV2ttBi7UIS7dwaXp04F7lZpoy1/w4yf7TmdtXvP?=
 =?us-ascii?Q?0GVLxHYR94VOPKiXD4mivjlLOTfvahZCXMaf0rF3ss2l6allVgz5pN424EEr?=
 =?us-ascii?Q?NWT8m/kepbjLaCcGNfTHZ8lFBH5cEKbsx4g/N7xpL/t5LQs8f1Wn63SgtB1+?=
 =?us-ascii?Q?9iYuIa5M5kCbm24fZtZo2pTHuIk43HtzU/iv/YtxohUY6y/A3hmD9vvh3QCm?=
 =?us-ascii?Q?gzgAsivovsvivEuwcM+ItDBzb1Ttv7CsUgz0w/ECk6uZuUnrdRtKNDgl09cZ?=
 =?us-ascii?Q?6bnP0JR/v7xTDCh3iPk/kSddYD/frjTOR/lBO+RBJ9YbqIvVeNgUp0UgyNe3?=
 =?us-ascii?Q?ntlKuV986ei0GBS4LyeWqrFhUYqYn2L5FG3QTcgJPKzoxcmB0Pnwf2BG4234?=
 =?us-ascii?Q?iNcmCQTsyGTgFdYxhGKiajE44BkxOSE6w98p+oKe9PXY7ptOBKWBKB8eB9Tv?=
 =?us-ascii?Q?8IFpjB4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:18:25.3536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2a2326-e8d0-4866-2269-08dc7136baad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004683.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603

Implement a platform hook to do the work of restoring the direct map
entries of gmem-managed pages and transitioning the corresponding RMP
table entries back to the default shared/hypervisor-owned state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-15-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 64 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 ++
 4 files changed, 68 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 10768f13b240..2a7f69abcac3 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -138,6 +138,7 @@ config KVM_AMD_SEV
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
 	select HAVE_KVM_GMEM_PREPARE
+	select HAVE_KVM_GMEM_INVALIDATE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2bc4aa91cd31..379ac6efd74e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4663,3 +4663,67 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
 	return 0;
 }
+
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn;
+
+	pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n", __func__, start, end);
+
+	for (pfn = start; pfn < end;) {
+		bool use_2m_update = false;
+		int rc, rmp_level;
+		bool assigned;
+
+		rc = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
+			      pfn, rc))
+			goto next_pfn;
+
+		if (!assigned)
+			goto next_pfn;
+
+		use_2m_update = IS_ALIGNED(pfn, PTRS_PER_PMD) &&
+				end >= (pfn + PTRS_PER_PMD) &&
+				rmp_level > PG_LEVEL_4K;
+
+		/*
+		 * If an unaligned PFN corresponds to a 2M region assigned as a
+		 * large page in the RMP table, PSMASH the region into individual
+		 * 4K RMP entries before attempting to convert a 4K sub-page.
+		 */
+		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
+			/*
+			 * This shouldn't fail, but if it does, report it, but
+			 * still try to update RMP entry to shared and pray this
+			 * was a spurious error that can be addressed later.
+			 */
+			rc = snp_rmptable_psmash(pfn);
+			WARN_ONCE(rc, "SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
+				  pfn, rc);
+		}
+
+		rc = rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
+		if (WARN_ONCE(rc, "SEV: Failed to update RMP entry for PFN 0x%llx error %d\n",
+			      pfn, rc))
+			goto next_pfn;
+
+		/*
+		 * SEV-ES avoids host/guest cache coherency issues through
+		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * KVM's VM destroy path at shutdown. Those MMU notifier events
+		 * don't cover gmem since there is no requirement to map pages
+		 * to a HVA in order to use them for a running guest. While the
+		 * shutdown path would still likely cover things for SNP guests,
+		 * userspace may also free gmem pages during run-time via
+		 * hole-punching operations on the guest_memfd, so flush the
+		 * cache entries for these pages before free'ing them back to
+		 * the host.
+		 */
+		clflush_cache_range(__va(pfn_to_hpa(pfn)),
+				    use_2m_update ? PMD_SIZE : PAGE_SIZE);
+next_pfn:
+		pfn += use_2m_update ? PTRS_PER_PMD : 1;
+		cond_resched();
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b9ecc06f8934..653cdb23a7d1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5083,6 +5083,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4203bd9012e9..3cea024a7c18 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -737,6 +737,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -757,6 +758,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 {
 	return 0;
 }
+static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
 
 #endif
 
-- 
2.25.1


