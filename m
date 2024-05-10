Return-Path: <kvm+bounces-17215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799C38C2BA8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DB941C20B29
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEB513BAF7;
	Fri, 10 May 2024 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zuj6y9k6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CEE13BAED;
	Fri, 10 May 2024 21:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375893; cv=fail; b=rkNSdUsxZ9OcEDbMf55TfHdOlByU/6DY+cpKFFC44A8peuiQa9QqfOKc2NmCvJM9LFNRsfpovoM4sDi8YVTkK84v9QVovsVvut9P+hE4361uYGesmOhEXyuy7Yrh56IVPmbm2KGoX/AEp7J9qpoXFHBK6IOq+G6R2LJAOEALZl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375893; c=relaxed/simple;
	bh=2P4JTNbSFbBas9NBCzHcY/9llXZydk8porZdEY5wMxk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+1kntxJJptNNHeYBV+Hhk0298bIe9nkxpONk8Rdx9bPgtBJUoZlMaiN4R8u28G/gfH6jvXs9PlJBhX4rVUGSv/GISFW4uUCmzEI3tAhJVFhZRN2LCfc2Z3kN/JUynZ5XO0WWKMsRMEWVKbN+MwYy9FktbYDhANCc7xLfQXzROU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zuj6y9k6; arc=fail smtp.client-ip=40.107.100.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnyl7BpamCJO+HblCggB8SNQpqmCWO7RTBrWW4EdYm4CpTjXqhW7uyRRMLBxdR+S8emHRKk4WF3J2LDbLGU6Dr9LHCVny/9+5roXwEYhBFJYHlLmvN1kWLkG4a3xLN4pcUK4NGoC0bUhzawLtJt0mR7qrAYFKpYSnScCshyUJ+ps5M+ZwQfiA81SRkWgd9FgpXv0tOgE1XPOr29y/HBFw/VX/gN5svPkXxnMTtftuERmw/1QHsTJawyFOrKut9w9qm2aCyBQtzG/+897RVzBvp8qhXVM/KGutG+dIbTPpp5NR2Y5bzfcIrMYSW61Mix7LCrEjh5dLOK1Cyf5/2x+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTsofH+TIDR97Ug9BLX4LJlsjJ32ksg/WW28J3TgUbM=;
 b=SL0SkXFrrPAjqaf8VaTraVZu4vEw0m8PkgKMFkZ0T3VB6USsSi+GMLtApsxDB2eMfV/3BaNHTUBVgce29sgYA99aSExFRqtS0GSxtq775BMPSc+GxOAvnEC9Ejixdia2D2ioiD4N3ysnMwE+CQxx84SoZH15de7N/4azhLCy9wPKCZ1V8aMfSRyGeL3PYn471hKVAsTeX+NB5Ibe5TwY+cB7d0baIVwa0R6A1ioOvEGmN0xm+sykmyq9vRs7krs8IDuVfNzaGMqdNR/5XNLjQJ+tl+ZXpJ4qlpDtARxfn3I7hYA6vS2pEsb1JCOT+Zf7pxgD2iVRleQABvReXmFG9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTsofH+TIDR97Ug9BLX4LJlsjJ32ksg/WW28J3TgUbM=;
 b=Zuj6y9k61O9sNuhwkNccGGmLMDPGUGWDFaDe3vTH9WwcUJJum9GmYtLspjSXpnOz6WOBsYHdmnc5MBRec6LI6QBI0jbS+JLZKAXUu+FFtRSUbuztISm9IqXaSEfolhrPtgC8lsiHopPRYeaKXFifaSP49ENVMQveYOXbHGZ7aMk=
Received: from BN9PR03CA0909.namprd03.prod.outlook.com (2603:10b6:408:107::14)
 by IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 21:18:04 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:107:cafe::e0) by BN9PR03CA0909.outlook.office365.com
 (2603:10b6:408:107::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 21:18:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:18:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:18:04 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>
Subject: [PULL 12/19] KVM: SEV: Implement gmem hook for initializing private pages
Date: Fri, 10 May 2024 16:10:17 -0500
Message-ID: <20240510211024.556136-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|IA1PR12MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: c1defcc7-c915-403c-ea17-08dc7136ae4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZRn1BfNpzpweSNos5kRIZSevFjpnD5/bMDW8jo9JVOKZ+baqaHlnhgILMb6r?=
 =?us-ascii?Q?kyZEEy2REqdYQFoU6b4zV+e3omfDkjWhJlPIcok0ZCNF6/nl71KpBAZgl3lJ?=
 =?us-ascii?Q?LgRoSInJbWGdS+BqTNRZ2qG4Gc5Loa5UT+il/tCYWDNIoQZQbbWCMFvBqmgY?=
 =?us-ascii?Q?wh+rE4sQOwTNcS67EiUdDtSqstL1HYwQwx1iupS7uWoLll/pvb9GRUttKJ2Y?=
 =?us-ascii?Q?1YQgs9+KQLk6CbcL+LH3SgMNuB7y8xqKUf4efSxlK1A9oOQKu9Qr8c3T0J1L?=
 =?us-ascii?Q?Qc/CoOH9FrH0GyO+qonR9tRjy5cgpIpB5NJ9eU9fgTCPGCFq4G6n/UtHdQ1y?=
 =?us-ascii?Q?0jnontDe1NDtmVUnTx1sJ0uW1HH49+fOCANFKeTxNS3proacAJmvW5NTIKQ5?=
 =?us-ascii?Q?HS72uBrcWnpxecupiMmTIuD0g1n+JlLRnbnlFPbo6IHFRNCvA8ky6YQ4M74f?=
 =?us-ascii?Q?jukESN6ZYKZzxl3nOlA0yRYupElXqPZqyjE8B2ISdY4I4eSO02gLATPE9x04?=
 =?us-ascii?Q?L7bAXIky8JyNdHzatzHXDrlW8hwc+jSWeojF8HjhSnDyxHPy8jFRdjache7Q?=
 =?us-ascii?Q?kKov82fEnGbxkg40D5o4fFGtDdl760NSdEmSfYXTmefJu5jVl8wbd6crRZRw?=
 =?us-ascii?Q?fYRD8OaEUlUSaGLA7F+kUX/H5JqbhcHeUzGrH4E/73u2rFoX0zL8WmCN/jB8?=
 =?us-ascii?Q?Wl/WksjM05LednckjrEIPeqxo0pdR+ydUDwfweDWgeKzkCGCA7A/p3rNZ2gD?=
 =?us-ascii?Q?/qoE/FJEFqmvXQEATILR9AZb/DFte7Bh8FYsoOocmRDnKTOppseVGE3XYzg0?=
 =?us-ascii?Q?dI1iH41Z1c246QK1szJcVYKiqGHWjQY3RQ8gi4x+2Xa/XR0qiLwRl+lhft/R?=
 =?us-ascii?Q?vd6/uavtzJ0Rd2JB6qfpPzKUpVZHjETWoIrTuw9BjWUOeEyhW45WJA1ViJlr?=
 =?us-ascii?Q?LooLXVzpTWPC59bEpc+bHpi8auJPOf4fwSM2XLMHOL9r6H9TfeVLES7n6YPW?=
 =?us-ascii?Q?NC24r741nK2hn1u+t9Dwoq6IcOGQC/YlKJl2JadmarBZDEtuqsgdkkWKmhMh?=
 =?us-ascii?Q?yfwzcWPOs9c+tZ/mtJfZvkTjF5vxPNbDomUvEv7QJu61PhxJeq1VpM1YlE11?=
 =?us-ascii?Q?6LSclIlNiAGLrn3ep6YhU3fKXqfswnf336JR+Bxic+S1ug6XoSdZLwDcRmz1?=
 =?us-ascii?Q?qOqdkjmH4BHBYLQez6TWUv7Tgn9DbbBn7o6dDUb8xqiWQ1SdK1hxR0gLDvFC?=
 =?us-ascii?Q?GbO1X9PxtRyMeP89N0pqYsNMW1fXjzelCF0t3AcwPtLf5vlbTMs3dB9u/u1f?=
 =?us-ascii?Q?m7mhIFs/4loS9QFSog0EJugWkuuXRTmzDpXoprKNFDUtCiHn7cjgoxYqqxxF?=
 =?us-ascii?Q?TVeg1WP756RQixXW9oh475C6REbz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:18:04.5969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1defcc7-c915-403c-ea17-08dc7136ae4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080

This will handle the RMP table updates needed to put a page into a
private state before mapping it into an SEV-SNP guest.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-14-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  5 +++
 arch/x86/kvm/x86.c     |  5 +++
 virt/kvm/guest_memfd.c |  4 +-
 6 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 5e72faca4e8f..10768f13b240 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -137,6 +137,7 @@ config KVM_AMD_SEV
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
+	select HAVE_KVM_GMEM_PREPARE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 518c44296f8d..2bc4aa91cd31 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4565,3 +4565,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 out_no_trace:
 	put_page(pfn_to_page(pfn));
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn = start;
+
+	while (pfn < end) {
+		int ret, rmp_level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (ret) {
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
+					    pfn, start, end, rmp_level, ret);
+			return false;
+		}
+
+		if (assigned) {
+			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
+				 __func__, pfn, start, end, rmp_level);
+			return false;
+		}
+
+		pfn++;
+	}
+
+	return true;
+}
+
+static u8 max_level_for_order(int order)
+{
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
+{
+	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+
+	/*
+	 * If this is a large folio, and the entire 2M range containing the
+	 * PFN is currently shared, then the entire 2M-aligned range can be
+	 * set to private via a single 2M RMP entry.
+	 */
+	if (max_level_for_order(order) > PG_LEVEL_4K &&
+	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
+		return true;
+
+	return false;
+}
+
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_aligned;
+	gfn_t gfn_aligned;
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
+				   gfn, pfn, rc);
+		return -ENOENT;
+	}
+
+	if (assigned) {
+		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
+			 __func__, gfn, pfn, max_order, level);
+		return 0;
+	}
+
+	if (is_large_rmp_possible(kvm, pfn, max_order)) {
+		level = PG_LEVEL_2M;
+		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
+	} else {
+		level = PG_LEVEL_4K;
+		pfn_aligned = pfn;
+		gfn_aligned = gfn;
+	}
+
+	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
+		 __func__, gfn, pfn, pfn_aligned, max_order, level);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 546656606b44..b9ecc06f8934 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5081,6 +5081,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 926bfce571a6..4203bd9012e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -736,6 +736,7 @@ extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -752,6 +753,10 @@ static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXI
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
 static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
+static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	return 0;
+}
 
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 62a0474e1346..f82a137640d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13617,6 +13617,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_SNP_VM;
+}
+
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
 	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index dfe50c64a552..9714add38852 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -39,8 +39,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		gfn = slot->base_gfn + index - slot->gmem.pgoff;
 		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
 		if (rc) {
-			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
-					    index, rc);
+			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
+					    index, gfn, pfn, rc);
 			return rc;
 		}
 	}
-- 
2.25.1


