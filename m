Return-Path: <kvm+bounces-13127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2299E892784
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 800C51F25A82
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F3A13E41A;
	Fri, 29 Mar 2024 23:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cc0uyUYN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988361E4AF;
	Fri, 29 Mar 2024 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753461; cv=fail; b=VB6KNT/X6FPchSdWa0YduFNEEeAxomwI4sjLhHCBYmtBxFq1lgp3NuQyHB8ktF5jAuwSfmEP5YUM+fPSzhGSxGlCmC5zfnNWXKLDPFT5PCuap5jZC1cceRTImIC+3WbVTS/c3YIWhi8iP3QasMlMst1tW30jVJl3bnS8BvA2CHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753461; c=relaxed/simple;
	bh=LO1MvQObDosu1VlgSkhz7lfHECcSMcglWFSDmOtm/Yg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBUNZx2rQib1jpnn5Vb+rBH+T7x8emCrxlPklGNj2AedyIonzOVcUSlNPnC/wIWSocSrBKoLv7iE8eyUYFR3/V1594kjIP3FSzwlSjFcTTPhIaYzmmFvJ8z4x6mGSg4GuNnlY+Y20U0emAwIbOd9sMqKirN5jlq+HJxRP2sh8aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cc0uyUYN; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Egwx+Yj+O9GqycHKkixz6q6WqQl2025+we8G7RWNBTOQwjXQrBQqzMlyS+v1FZCUop1DmJ9GWptxdse59prYS3Cjkt209sM8gcipEcuvecX6w4Z20PkW9h5jiVDY3wiHc4ZCqCK3v0LFI4SvKzMNx7NAphkvnpxLBDozJ0sfxTCdqhkpHBboS0pNDzZLpIlSQhRJ5mALAlkSdkvipum0XSjmehyE1WqgMacyz9sCitAzrBQBG2/+DZa+0oOODguJ9zQKWZtor1atdnq6nenllic/7avtJkFRREXbDMoXGECUaAAzwm/sz2urFNmoqPUIIAVEi91G5WDL71V5QPx1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aC7aySI043+XZrY5VGR6Yx8968W+cYuttAiNqJpHqGA=;
 b=cTUTSp2GpeLZpZGwUPRSO/T8EXWC74ipA2NnD+VzU9tW/SqQYNV0bxZgsBaTYcHTQLNm+hGNsyquRQlMvda//nXQ5GmUAGEnV0cqN49172en3KaNUovSESj87XEfPACp3b24PoQYXaIfICZ+N4muvvu0dbQaRGUo7jGEH2mtj5iddh273Fipx4Tk2ETKfdS1rnvtzmwX5IaZOouhJvANNBAiwou//elVD3+oHT0/zgqSHSMkiHXkrOZS1MP4KCHWZ+u9ktEFjc2IolaVwkoiNMSHB9dlRTRBdhLJgpqxB3oIjlNQIBME3DXYwp7Ba26e9hdt3NkXwKOPfYfY2oIowA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC7aySI043+XZrY5VGR6Yx8968W+cYuttAiNqJpHqGA=;
 b=cc0uyUYNMyeAQ5K8eq2/q/ZPuUjv9DGzNEi//Z9zc0EC0ANF6fCUIWdrv+bm+cAiEfgIeXRCeHAAqvX1/vTx2aft6GpjnWr6vZ4H744mfOHLmYVqfaYmRaAr5pm/FVtNs0d56wu2NB9ee6PhfEokC9e7br1hkCDym/i0c+Xqut8=
Received: from BYAPR07CA0068.namprd07.prod.outlook.com (2603:10b6:a03:60::45)
 by CY5PR12MB6574.namprd12.prod.outlook.com (2603:10b6:930:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.38; Fri, 29 Mar
 2024 23:04:16 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::c) by BYAPR07CA0068.outlook.office365.com
 (2603:10b6:a03:60::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:04:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:04:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:04:15 -0500
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
Subject: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Fri, 29 Mar 2024 17:58:28 -0500
Message-ID: <20240329225835.400662-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|CY5PR12MB6574:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a3b550-3de1-448e-bc04-08dc50448eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PgmESFyaAzP5udG4PZdmIr/pO1stMQNxvv7F1a0Km6GDitf+qO+H4IhrR7V57XHkeTfeeMvszrda85nNEQ9MNqktCq8ek5e7U60wxWG1t6xIGz9UaLWojzFwE35ePid2KvjHglVbkFBTm7KCkoyHuHxMcCSimyzWAuLz8Y3PTHIF2V2jhmRy5QjNTr9DKz5kP4B8i3ysj3iT4+dV8W68wtYbyrum1Byc0B+S3Yj2TiKhZxtbUzfitCyHZ2rKpvuAW23sL1ajklH+GAujLxR7dDgoxN7iUEcCgsMvO5YhDo/iG2fn0SZJuSfIslZcyxCgNFaaIoDy7bcFfDw+m+vTNasy8OJS8a8JFPs0J0aqKu8L2miJn8KbhevGTLOIFsrE/dtHfMzUTh6YX/+cXuItNVDfxBlMo8ydcz1JspIJi2CgWwhGjbhhv33yiy5xH3CP8rqqwBlPrfp6qQb4MOx0RzJXzlTlFFwcfCKVUjCq0zVqIg/I7wTP532CnhooxFtUfGG1KLwTGH2NLu0iTyUvNl82wJlKDWjaRTCWosDL5EG/cmFNMiDG7vbpaQDa4LDJhAnh6xKnnTlrsXirNBtyHha4GulEaldPg/2lSf2oXgB48YqI1mJpKam90pW3Z8H6pqCj0JM4L3Srwfcb6ANNEe5pyf8KCKx0QKcLnC6i41VJ62nN8CaEbK0hpPCLf+yNrXaCSSlqrwSqIFUXR0ZNZXmOLEVWtA1rzVeSwf9wsUrMC0Mr+so4hGqUl4l/T10A
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:04:15.9550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a3b550-3de1-448e-bc04-08dc50448eae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6574

Implement a platform hook to do the work of restoring the direct map
entries of gmem-managed pages and transitioning the corresponding RMP
table entries back to the default shared/hypervisor-owned state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 ++
 4 files changed, 67 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 286b40d0b07c..32a5c37cbf88 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -125,6 +125,7 @@ config KVM_AMD_SEV
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
 	select HAVE_KVM_GMEM_PREPARE
+	select HAVE_KVM_GMEM_INVALIDATE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e1f8be1df219..87d621d013a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4380,3 +4380,66 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
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
+		if (rc) {
+			pr_debug_ratelimited("SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
+					     pfn, rc);
+			goto next_pfn;
+		}
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
+		 * large page in he RMP table, PSMASH the region into individual
+		 * 4K RMP entries before attempting to convert a 4K sub-page.
+		 */
+		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
+			rc = snp_rmptable_psmash(pfn);
+			if (rc)
+				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
+						   pfn, rc);
+		}
+
+		rc = rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
+		if (WARN_ON_ONCE(rc)) {
+			pr_err_ratelimited("SEV: Failed to update RMP entry for PFN 0x%llx error %d\n",
+					   pfn, rc);
+			goto next_pfn;
+		}
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
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c099154e326a..b456906f2670 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5080,6 +5080,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 53618cfc2b89..3f1f6d3d3ade 100644
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


