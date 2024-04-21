Return-Path: <kvm+bounces-15433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 100988AC07F
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F0B91F21171
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B003F9D9;
	Sun, 21 Apr 2024 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m49fIUlX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0933AC0F;
	Sun, 21 Apr 2024 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722755; cv=fail; b=dbR2Njo2M/PPp2iBP8W+n7TsBxScGV8QfHuikQb1wPunPI7hUKEsZ/K5qK0FVsZRnX71R9AuGcQHk5ogA8ac/xn0+mxLD2Ju78+9o1Ej5pzg9CBLcCP9X2wXsbR03pLNHpq+Gi/LyRIs3BcJeuUrbGPdWQJuo/p43CPv9N14xfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722755; c=relaxed/simple;
	bh=5RGTkNxVmm9O7uLueZ3Z2LKaosk2t9mjAE0jYIuuG3A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awgaP8IjxOoImpXXdUNWAUAGy/SHgD2UT9OTJp5x4pG8sk40H+kAUlN8wpUmCb+4izDETqx4pOIOYO7oFO4dPyRademIxFkLotx2QGXtDtLyy8N6xfooq0IKA1BYmYBtaNH5WZjaIJYbyDJc0t6+HVtNAlpn76q+CdFBzHQKUj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m49fIUlX; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8aEe7jkrfF4E5uYNpP5AEa3h/LG+nZk/FT3s0nYhOg48IDvRxKAq7J7UK/3OOCwue3OqunuL4rjSh2cQR9Pn/FOpflPFNTBqj4wYZMfRfXV8RqasmCcEyYxGe4JKgdhwnm92z2S5GLuG/fdP14+lWFoi04Qdu59AOVQ5CH+/Diy1gJ7PR4CQYKSDtBhT7/i79bfDuDxqDXlN4rpNtOP/8jiiitfsXMRYzYV4Av0aV+OeeA3RhPR96l7tY7WBBXfFi3oqIECBzK2lpVFHPFmanrydT++BZcFH7id5NajxvSp7sB7IM//3PYtrYz86NL7CZaT6xXbJ74O9nOkkUgvpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IAnBuGrHv5XET7nTC2pQ71BloNuV9/+sLv+g+toff4=;
 b=GCp8x4UI2NXk9KAqf5X+BQ9g6XnNM0l3mRPsBLKuDAGypvJmNwWbM4y07n0U9aiJgmMqF10TKfAFEzezcnFa1Vh2NdeuqyuOaVWF39FW3PZgkaVgcvhrrZj5mt7XAu+WOmS0Q2SAXx7Mu5yW8Y0uaeHYCCHodVnhUyvtOq23X5KkmBfLV66hmIM11UAIX3oowgaxLGEDSfl0UgiSW2uwoXhEwoaeT9O43gkvasaax4D1ZvQqvWzwb9zjbFs9QrRZHjNjqg+BYUyCf7zhpD0V5BoFv3fi/GBzwQvCYlCO4l4J4crCZ1ZR2zP7Yl/vfPnwzJK0HjeUmSz8xiZGNZYnbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IAnBuGrHv5XET7nTC2pQ71BloNuV9/+sLv+g+toff4=;
 b=m49fIUlXggrPhi6tGTUv2fEshDCT2nEDqc0HYyI01PiZ36PKIHSkTrbtqiJ1ojTOs3bUkJ91lRJE8hHsJXf+ABdJHCNQNRPJt83oyMP/i2ZIGFpXPrAKuPFE8rqy4QWUWs3XhTKYY99ms5/F+EkC+8jVWhnMIBjkVHlsofarIjI=
Received: from MN2PR17CA0027.namprd17.prod.outlook.com (2603:10b6:208:15e::40)
 by BL1PR12MB5897.namprd12.prod.outlook.com (2603:10b6:208:395::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:05:51 +0000
Received: from MN1PEPF0000ECD7.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::3e) by MN2PR17CA0027.outlook.office365.com
 (2603:10b6:208:15e::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.30 via Frontend
 Transport; Sun, 21 Apr 2024 18:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD7.mail.protection.outlook.com (10.167.242.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:05:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:05:50 -0500
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
Subject: [PATCH v14 15/22] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Sun, 21 Apr 2024 13:01:15 -0500
Message-ID: <20240421180122.1650812-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD7:EE_|BL1PR12MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: e741124e-f421-4beb-6fe7-08dc622dae20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?csPeDVrNlJZJG62QCgZn+G0FTJFPpnXRTl1PONOpbPaTNrQCXFJ8tvCai2FE?=
 =?us-ascii?Q?2PSjTt4v8BpEoUP7/VYtvI4gyS2GqQMtBF2ylDaHT3mfaNUj94e/mJ7LlUqY?=
 =?us-ascii?Q?iGRX3QCZixZAGPVCMwGioNWnfi2SxDsdZvsKxC9lHadrdPXoRbpIXUUD/hO+?=
 =?us-ascii?Q?QERzYOBzw9fmi0bBrJC2TBZUN3NPXHtG3+DeSluTnAC+IH0Y0Litu3QdES4W?=
 =?us-ascii?Q?rFc7+K1M0dB95gIGB9iF8eHpOdaY0frWt/VU7aYkaMs06+GjXgkMVNbh3Ey5?=
 =?us-ascii?Q?y5bU6G+t9l6YdRpXk2u6Q3ohMmrgkDNo2p9dy+H+HmENil73z0Pt1RqPycZH?=
 =?us-ascii?Q?bEFpKC2dmUzIL74n+D9c09Dtq/u0DxuXiw1WG0UCo8t00rgPZdpZoRUgFjdR?=
 =?us-ascii?Q?FCCYtc/2atEvP5PLpi3u3eEEmp3nvktAoRhkqndwtZeKIM59kfecJkjUFTK8?=
 =?us-ascii?Q?MlkZIMMtnywqcqD4Te6lV48dxxjZr7DYKfr6XRR9YDPxd1gX0zgjEBmzsVYK?=
 =?us-ascii?Q?YFt8C4U/IC0IgQZcWixS38yOTkxUrtAitaVcaALtMR5ul1L2Bnv1JajlPVat?=
 =?us-ascii?Q?wzEG40rBxDvdAlZLKdfMjU2+y0DUDlvbxvffgG3OVGHtHOgIaGsTeBuaUN0q?=
 =?us-ascii?Q?mVagiBnHoKZiMM8O2NF0AxXxcqWQw3thhjwAUpWsFVwvtHgkzk2lqcV5VjcB?=
 =?us-ascii?Q?7hU7AhaqbPmIeuqiu7DgfaM/Etce1oJulVl0HaXdrHPsdeNiUMIWlQ1OT6Ns?=
 =?us-ascii?Q?QyxJsqjc1XBIr8vKk1PcyKYrBLyPb5ZNUdStQbXh5L/xLknu9vP2GpL/53VC?=
 =?us-ascii?Q?2bKzY/KZk7IGf1Nr1/b+WxY5kxmqC0FTwxPAsawRWTI+j14UhQ+rBf49v9Tq?=
 =?us-ascii?Q?bhxFPCG+B/oHCjuRyZuHU61N+j7uXW3VOkUyOsTl3qRNog4wo8xMY2FCXqns?=
 =?us-ascii?Q?TTWYNtybcMytSwqgKmDJKjaJX+yy7eNzJMZOts/OIJYNftGAHiTAH5ZJISrK?=
 =?us-ascii?Q?kZA0dKENCJWQjc091XexWW/8PwMEAwTILEuoQ4b7btYY5KuG9C1fJIpLib8w?=
 =?us-ascii?Q?L98ehi3XuHc4RMmhxM+OffGN+2vPjWTqkTR9geX2o3vCjfnx3Z4qT5IQjInG?=
 =?us-ascii?Q?h+ZLMYKVB+Af8LZSdVNZQDirhzNZ+BUsHmAlk1FgLDYYkwsybBRRYtPR1X0I?=
 =?us-ascii?Q?1C1PZPvUQaS+qbjcxtee5I5zLrZBtTBIFdeDvfNfZX8FTFG6tj5n8+okTa+J?=
 =?us-ascii?Q?RxhJy+PMR+FbXxSXYLeVNQYpHT1tGQqFntCjKNIawXjGsMs3miqPyDErn0M9?=
 =?us-ascii?Q?d/v+H9l4+mmMOE8yrIg7OiJI9RWH6YgMcAWV4GHkfoeikYRsa3YsQN5WAnyn?=
 =?us-ascii?Q?3TsoVac=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:05:51.3554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e741124e-f421-4beb-6fe7-08dc622dae20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5897

Implement a platform hook to do the work of restoring the direct map
entries of gmem-managed pages and transitioning the corresponding RMP
table entries back to the default shared/hypervisor-owned state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
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
index 2906fee3187d..ff9b8c68ae56 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4464,3 +4464,67 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
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
index 60783e9f2ae8..29dc5fa28d97 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5087,6 +5087,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7712ed90aae8..6721e5c6cf73 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -731,6 +731,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -751,6 +752,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 {
 	return 0;
 }
+static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
 
 #endif
 
-- 
2.25.1


