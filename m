Return-Path: <kvm+bounces-16311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC978B8727
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E52E51C230D2
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DFD51C33;
	Wed,  1 May 2024 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CKVD1T99"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4045950299;
	Wed,  1 May 2024 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554246; cv=fail; b=jVCt28Nby11h7RxKEfjttDeMqtawHwKuXChR8MT2KL2atOchJtro/3DXaPQJ4l+K/ZHCcr4uKIFdYM/cRC4zj9n87deOwDJktNiHiFcRkgofJMeWi94mHyhYmpPtMW02YIGGa4QK6LdqVoficnRck4uuHNa9VpATnqcgOwWBYdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554246; c=relaxed/simple;
	bh=QGZqGIeWFDQXCI7RnwyVxOJ4YF9XhrWsIuXcoWkSd5Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTEH6jc25xsdwrZxUdQ02RFHt3+V7FgMcJIHbfnG2zmsnq3HiZvG/i4EyjObK0CJwos6CUJQTk75MFzPlcfDHZad69fqUWYcPg4eyBwEUO/ptOCW/iRz6ZOlt7UojvFLJwYb5/EWL319CmzHDaif+S9Ir4PzIe9PCeIowK6FiEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CKVD1T99; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Go3DDqk+xjPVac2IpbaR+B3V7USPwZCBYQs8FADUgyWOF2d7eGFlH150x5OaJIO4NzFxO32IXl8UiG1HbeYNSvp86SMTQY5YAlZfa9r3phxV3rS/Z9lJYHZTQ9IkH6jnH8tcTCIUeQpD2XRvuHwzQrHxJkcNmp36aufncRQzfWtwIqjONC05ZMkv3F9429+AyTgJ7mBMCFX9nq63jVoz51FqV7F9j+p/A53yJ2aHg6w52uqVk8IQmzyasBwAjXfdMz4BHEpHgO/8uIbc1OmFuuvw7yF5uL5BG6JJVxl2AwvU0HGMRXRImgHZ4taNFV5qmL4m11M2psBhWxt8a8R5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOUWBfJkRb3XEGVJSGFqVsBJr2cxraupp2c9EXMGQME=;
 b=dynUGmLZkfM7l4gxdA7XNar6CHHkk4c4BTvCnH9KWn+8Kt5YZAddPtXULlJqWjnlqkSXs17y8re37Q4nn9LeHlS2o2oCmvwK7LG/C+8TD1QOI5ssTZuY4I/tz2d1bBFR48oKmenSwIvZ/ptfXYvQql+VmHzUq1KBzY1U/mX5xxGp13bPnGYZl1RQpM6fyA6GD1PFHFXgDEi3agNh1DPp7iCKOsdsXlau5Q1ZGw25wsqDibdk6Lk9RlDgcxIxJmGae7UGO+gjNUBX6Xe3DsjnLQofQGkBbNT18tbFPGbCpa3WjfJnJIvHv54mYM3jbtDQKbXEw0exq2KbaCLVwzgPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOUWBfJkRb3XEGVJSGFqVsBJr2cxraupp2c9EXMGQME=;
 b=CKVD1T99Qv4L2kGrM+bSKR0l3M2kqsd9xpVl/zhI45Oh87/HIq+k2VZZtisYlde20mzuby3n+zZK2uAFxfskg1vst1uJEwVshjN1yB/7nav5Iwr5kBQdjPj1UEIVCyEvRxvtVApFO736escnTyGdIHpBhz4X/h1py3TaYwzk0gc=
Received: from MW4PR04CA0305.namprd04.prod.outlook.com (2603:10b6:303:82::10)
 by DM4PR12MB8476.namprd12.prod.outlook.com (2603:10b6:8:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:04:01 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:303:82:cafe::33) by MW4PR04CA0305.outlook.office365.com
 (2603:10b6:303:82::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:04:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:04:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:03:59 -0500
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
Subject: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing private pages
Date: Wed, 1 May 2024 03:52:03 -0500
Message-ID: <20240501085210.2213060-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|DM4PR12MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: 86e91425-1926-488c-178e-08dc69bda46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400014|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SW/JOBv3MzAhkUQaMpFRm2ZXEpT+AEIPr4ENcaOZDPwZyX/cSJK/vQWyUUZJ?=
 =?us-ascii?Q?mxUSlz1zd0JskBHzP6MNS18miJAKZkqZBAtOrQl2ttxZAT/7A5bi3QDP8Ju0?=
 =?us-ascii?Q?EWl7fI8wEnJgtKEYA1e+yagOoQ5iOTOG1vI+PK3BAff9xywBu0oCu9WPRzei?=
 =?us-ascii?Q?/DnsSKAYzvkiOxTc+9lBGif6y6X3NIgtMU7QD3ZUDs4OBzEewy5rFRsSOxIC?=
 =?us-ascii?Q?VhTJiq9TLRbI4yEWwa+ian9yE1w7Lp7AIWNPHmiNSaVJ70D/Cwm5Eff4p4mR?=
 =?us-ascii?Q?LHLkS2iNmACdJzvGZsxLdwp/td5Nw6uIinY3H2C22Zj3jssMGZcwXwm/PZNw?=
 =?us-ascii?Q?tfbwXOtI6VtVKI+56vWA2KF5A77rA7zK1kwOGi3nO2SGWKvpJbkc02iicAOd?=
 =?us-ascii?Q?5r4NvdAYVDmNzE9fMmhPDikk9qvIoMcPXwef693vEXtoTMtGH1srr3Q0xDFf?=
 =?us-ascii?Q?d4FimfiOgUYcZ1isaSSBcxJp7QkAgNVGPc2ua7/cWRe0kdDHjpadA/9qa1mD?=
 =?us-ascii?Q?rpx71oRGTiYUwpRa4YVao/fW2Xz6H3Lp+D53QTieV0Ebfm0g9mmEIMJWxunW?=
 =?us-ascii?Q?YTXp+nSmApfAXjxdQDWX4ElAPIKdoSz0/+L0xRSqAQo9TFVR0t5ddPLDo7U4?=
 =?us-ascii?Q?2BREha73CaByqTavaHI0AFx93NAqT0dbukD6gDAfNuHBnAwg+nQCz8wuWLNs?=
 =?us-ascii?Q?WyzsRrHLZ9EzqoGS7zo3dMkOZeMHibQeiOfQVcG5qY1DsKlY7Twoa3MUDqCv?=
 =?us-ascii?Q?UphQB+QYLCajoHJvk9oSpvGfJychQUF2UVNKQ5DRG/5zBDUiqFxWsNhXyoEs?=
 =?us-ascii?Q?7EfN7LYtdosxYr4jNHrE4nuLSd61lx1Rbw8oBY6R23shrjBowPe/osLmLIDq?=
 =?us-ascii?Q?C1SIrmpShfJDaVXFoodNkMljJJlhqxU98n2BGUAL+b4fiybFLOR9Ya5Xdjeu?=
 =?us-ascii?Q?Hk6rLuAVIq31Qi2XNgCj65MzlZzZ7NDzg/c96iiG5KcTMYEOEj5PbXNYY3X2?=
 =?us-ascii?Q?hVLc/389X6C+rWdJnEb84Y0plR+Tm89/OL0GvBd84LVf09vpCfnOpeORuJcI?=
 =?us-ascii?Q?3y6UXMtmPYY2NaqmC8S5ALrRgx3zM0Q9h/1QYYj+6FUwdiXlSB7fB/UgPAoK?=
 =?us-ascii?Q?bZVkvlw563bPiaY1JGrpFk2txTd0xQ+W3MphUb3IaZXty3VpC2aTIdI1XklA?=
 =?us-ascii?Q?q0AH5gkIGQbolp0quOv4rFjQRBkN+isdymuv3DeGBg12AAPU5nRrLS/D6VGV?=
 =?us-ascii?Q?UVeDoE3F947fd77lf5nCs44vDPN4Hz04128IWYgMLSZsOJvLVjkxqnqyK5FT?=
 =?us-ascii?Q?0uu1ow3xNE6Qy0ZoyNFcvpdcG7f4wJOnKF6a/dVd09dhjwYQH/eL899eCWuA?=
 =?us-ascii?Q?9hJSU4Yy9A9wmZL/M+tCCN1cps6W?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:04:00.6084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e91425-1926-488c-178e-08dc69bda46d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8476

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
index 69ec8f577763..0439ec12fa90 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4557,3 +4557,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
index 858e74a26fab..ff1aca7e10e9 100644
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


