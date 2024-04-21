Return-Path: <kvm+bounces-15432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E478AC07C
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2EE91F211B1
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C071B3CF79;
	Sun, 21 Apr 2024 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PO5o7L7c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF4C3AC0F;
	Sun, 21 Apr 2024 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722738; cv=fail; b=DcyW5Ze+i/tDkE25T9O67ER57/MUtrmVGXc/0PLyNnt4zOh1Z6Fqfm4AoDi5q1sLKQXw+FwROiUN2SjBUrIyAHyxyyeCVoEi68o3Q8Cphb2DdNMLLSM+FxYYcrA5BJAub4Hx6GevDhJg+z1xZ0Bo9mP7wTYpPv8UAvNsAXzSXSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722738; c=relaxed/simple;
	bh=X/ZZ7zEBKKcsiU8tV9hOgck7NCCXYlWn8ndCAUfZ2Hs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irOK++z1rE0+WO3+cWolkdWFMpP9yNRlSI7T9sCXix0CknTXW5m2NQjVieaWBYnqb5WVw3K2oZxvEfNY+OrDhHBs5M2lUVijqkZBMMzwwdHi6ZX1XkyTRXAt16ZML/CMwOtQ4p6FJlmSdiW8ebuvq0W5Im23KXdekXrQn4/06cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PO5o7L7c; arc=fail smtp.client-ip=40.107.237.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPSHmGuG8eNka05y4OArI3qYG+Pmojcz9i2TcB66GKpSHzDIEdtREjPUx++/l6x0n97wfZLrRHu1aD2NuawIvvlDxQJWNwQegJ8Gr9WOube9/QNZaLRYdyk2sJN/5YdvjTRe2SKlotje73ArkcqMM6Aq6PNpLlu3O7m4rRHtfu+KGUMmWc8GX4WF01HwaK0z3pjZ7asMJJBQfzGZtYLIunmCI9gfyiz1RS6LcWiAOsTPup5rzqh7KsqAB14ROOK7l36iuSGcwP0GyJ1JNq/n6W+X8OMuAm/9DvGKQVZzW2qxllDC9Y6oFyFiSsTz3ZyIBMogiz+lZOOGQvq+NAnSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1ja8RHXJaIbh2PVGzrVcY1yY9fmZFt6AG053sx89PQ=;
 b=c2o8C9adjCYfzM5bokHQyjs0GAmhwsjJHcuYPkEQZGFyl4gny/znma2qx78hoYVC6OSC0YpF/AGmS0s0pIhboRAqXbNpQ1w7NvwBJs32gWml5EwuIHs+m0V8JB467H6AlFtenNhJ8oZOA6IsO68rOt5nuerhfJ1XJGp1QNklGLztnLn4Z9Z2x1K/o3NRDS4Oq0Bc5q1I2MkLR4fAPdmVOl4z+uDfqFEYJ1pvNK8gVDCUeRFFovTFCsnKslXtNUj5hGQdwlRnjh6SnGn9CuPbmjqRItyLalAfw8MnMop/VdURIavQ5ygbyLKQGb8eKhbfHGQ7AY8TkphT8iMdBv71+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1ja8RHXJaIbh2PVGzrVcY1yY9fmZFt6AG053sx89PQ=;
 b=PO5o7L7cy8+AiJCjiTXgR8VpDjHPU/sdz43fElM3yAxAHEDADeqApujzJCovUyb+wTYk8RQHk9nid3eCdmC4SHN1j7TJkHYCxwxB8jH7hpJsf0NsY8Ih8Jeu4lS62aTo7pbFyRrzeYE0JG5TlYw3Nwzuud1FnMljyCz2VEZoGOs=
Received: from BLAPR05CA0036.namprd05.prod.outlook.com (2603:10b6:208:335::17)
 by IA1PR12MB8586.namprd12.prod.outlook.com (2603:10b6:208:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:05:30 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::d6) by BLAPR05CA0036.outlook.office365.com
 (2603:10b6:208:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:05:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:05:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:05:29 -0500
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
Subject: [PATCH v14 14/22] KVM: SEV: Implement gmem hook for initializing private pages
Date: Sun, 21 Apr 2024 13:01:14 -0500
Message-ID: <20240421180122.1650812-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|IA1PR12MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a72c89-d34c-4f91-4991-08dc622da164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fj/nMYNjh+mMQS/rR+1N9Dnz0F+VRop69BImcshPFGEU70FRAonn1lks5AzB?=
 =?us-ascii?Q?6V4Ykhkd73YcCmDjAO6M6gwSfCWQpR2AsB+mfcSy8kYbr1IWZ5x1hpKEWL52?=
 =?us-ascii?Q?Fr0Udag7WUDMmqOp/vKMFWEnY4xhteLF1AgrOISV9RaVsy4pqkMf9ECLx+Zc?=
 =?us-ascii?Q?s3YLlgel8YsHQs9Oq1Pw2pKroJN+Ab6lpJYlp3EqYc3fdYgQQ/ZAjUY+hYOO?=
 =?us-ascii?Q?m7XAyrq5A8WxFDaPiAvVTrn74jaTnyw44FyudQEam5eqbWpqKKgpmbW9K3u/?=
 =?us-ascii?Q?87pCm2mQWZQcx7vqIEG9frHuGBkaWAdIgKc0lXpzVeh4fI7lFBEVeVemJZpS?=
 =?us-ascii?Q?DVXLK8E63euxdBrQl+swUSCjmxMYhl3DpICJSDAELVP5DpTzx04+1S893Sgz?=
 =?us-ascii?Q?2a1aqZFaZgHFscHEKhkm95rzDEfSyMiuwgLGCq2yZusSSjYsYjl/stqo3jL/?=
 =?us-ascii?Q?NNTmRAPZdRIzCUw1c7X4PEtpxhzStjKX50Z3dwYiBRcNUJ9cMQm2s4jpXY2w?=
 =?us-ascii?Q?omufyadOTMox7bcFuRWQBIGufXJHXbCYOf4iISnR3fHM0LfU5pK4myKIlest?=
 =?us-ascii?Q?0tMzO0T2IuUMl+CrxzmNAUDkM9qP8RWIheYd/7dE/5PI8PPqRO/l1zyULyyX?=
 =?us-ascii?Q?q31fIfIIWk4cjqjCC6hthhwC6CJB2nrSz4xWpSyp91+spRnX1ldW1z2dDazh?=
 =?us-ascii?Q?sN7iBkXvS/gYB8Em2XT8ar37hoK8OX0T7QQIdz65j1sxG4Iwuq1j8WE/3jal?=
 =?us-ascii?Q?re+hY95+VJa1htP5zewS/SdzlaUaZnouRff3uUUSoT9EWxgiVhv+Fik/imqw?=
 =?us-ascii?Q?Iry6II2L7nD4Je5Ka5YJkxosqhU4vUAeBaO0YS+ZzJyvc3tk6n/4GLu2BJF8?=
 =?us-ascii?Q?uPozlK3JYcdREfXslB06QgY2cXFOdVzucu9Lq4LPgIzXcyqFRNMjzpiJ94L9?=
 =?us-ascii?Q?qp/qc5NcIY0jMZn5db6LSNVS+WT4dDlZqJ1BFM8kPV9Hb+7+XL4ba123GzMh?=
 =?us-ascii?Q?3KpXXe7dFvOwSYG1y2sHcYANKLOYXY0MxyRSumGe1M79eMc3BfukPzA0qhi1?=
 =?us-ascii?Q?NooUFm2QSVYilwj/zmSMO8SluYwE1makczw6NUXJy41boIZLOWiHfrrGLmzw?=
 =?us-ascii?Q?w1d+13MmlvkXuPpfn0H/1LMtuhH9+BAytrvz0D+5nyni/NxsrdNTN1DJiNWl?=
 =?us-ascii?Q?LukuaWJWLr4dy0S38MN3+NhKKoMPTyA7napZLQqjLz1Yi6MqwiS03SQ2Sz7+?=
 =?us-ascii?Q?V37twZV2erl4mSagJlqynX5FEma3ifxNMn55onxFPv0Xmvrrn0sa7Q9ZyrTn?=
 =?us-ascii?Q?cC+lOuNsrix2mRSgjOPJ70Judz2gUqeVvpgcwGbcbbNq4TBOL0D4LEOubdzI?=
 =?us-ascii?Q?beGEgD5HQTvRfHKheCn8X1Gi+SQM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:05:29.9897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a72c89-d34c-4f91-4991-08dc622da164
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8586

This will handle the RMP table updates needed to put a page into a
private state before mapping it into an SEV-SNP guest.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
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
index 1d18e3497b4e..2906fee3187d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4366,3 +4366,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
index b70556608e8d..60783e9f2ae8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5085,6 +5085,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 81e335dca281..7712ed90aae8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXI
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
 static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
+static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	return 0;
+}
 
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b20f6c1b8214..0fb76ef9b7e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13610,6 +13610,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
index a44f983eb673..7d3932e5a689 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
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


