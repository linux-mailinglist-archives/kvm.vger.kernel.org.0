Return-Path: <kvm+bounces-5392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 945C88207E6
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73571C22229
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF68BE62;
	Sat, 30 Dec 2023 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3ipk5zOG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2069.outbound.protection.outlook.com [40.107.96.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3B14A9E;
	Sat, 30 Dec 2023 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOYOAdkSVu1CvcZHmp5SPQAfdjQm3AD0AvM8a63Mrcn7ooYRa5nfuf//TGjAUg7a8JcoKaHb/wbX8QiT6n2IEvaWlrEbPB8KC2OSk5YSse7Z9tWFRbXyZme/EwucY+MuzaZ0BI1sv6zV/6klL0oMz/i3iVbx9YIzvf4DlZlJb1nUYNGCiZu7MJ6LqocB8hshP/joOk2rrzqNLQDP03tjh0lsuDhmWSU0H72WDwZcI60fpjTRzY1OpK34okoLu6JOr+b3t6gR5vwLQtPXmAcRDQYmfGyS+2UbHU2OzX9QWW5RR0EkaRIirtpsgExOztGOlRr08WQiQQQYQkm0DylH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nruYejf6eK+AMzOkZTTv7WWVazHpogjU2bxi0QOJrAo=;
 b=icWwPk8KYgEFpQI6D4qiydR9MTFBmcY8lkIp3DCBKorBuB3MOcr4GUUrn8y/Gl/U4DU0DLlE5lU375o9zsO1D3kHhP5OH8sIC940E3OhBSon/i2iqxkzrME4jCgmy1Rcp5CHMs1TYRq5bbs6zBNNphVxE6HTBmzZHcglZRII+FlTJPEaZGBAOzm+oUt7b5f8UY1JzeMLFEaiZPk7tl/4NTnp2oUTaP1Vfcd1pZQxHSHoKaIYcVXwZJN/ZDi+igjzJf2Riqgc7Ooqoiw/rOmOlWuR4Ywsxp1QcDKY9OhCqIt13oo+wnjqNBIkNEO2KDd7zyXGSfU32SL37UQXzwO2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nruYejf6eK+AMzOkZTTv7WWVazHpogjU2bxi0QOJrAo=;
 b=3ipk5zOG3IP1XGhlJksNBzAK7srxitsGEi1yaiuwneKWTC1dR5v5Ratz4R34u+ajZG/Q8mtkbdzUSk1buMxV1JgeayAV3IYpn3XQhglwRLq5jvfBWO/BFvz31sqngoV406Wj1mTc9MZfIV1rLe9Du745jozJ6wL832V1vaa6Se0=
Received: from BY3PR04CA0009.namprd04.prod.outlook.com (2603:10b6:a03:217::14)
 by CH3PR12MB8211.namprd12.prod.outlook.com (2603:10b6:610:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:32:02 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:217:cafe::68) by BY3PR04CA0009.outlook.office365.com
 (2603:10b6:a03:217::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26 via Frontend
 Transport; Sat, 30 Dec 2023 17:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:32:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:31:59 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 29/35] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Sat, 30 Dec 2023 11:23:45 -0600
Message-ID: <20231230172351.574091-30-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|CH3PR12MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: ce84035b-f920-46d0-7512-08dc095d3abc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lKdgeJtGGNDjP1E2BuzzGV9PcCcCMwt7Cv67LjQkdzKU0qAhBxHcMV1JjwWc8aBKOQ6wIjuGCnAHZxgL/4R4FoKF+FCmlKes88ien6qH37zKokBQtRjxeyxpPYtB3Y6cSCJ1d9bjG2lLiTs1CoBrkMmHPyplJSXtOlusQJUNlulcL7wrSODuqts71o0j3HzsXB2SkvACHWYT28yDJElEiJ94JcK8lPCHK59wT8Zhniwrr0Ys1nY7WG4DAnSO14i+UCXNwMIWfj7oaKbn+ajB+yqfWVoqTsg2+gKHzhaqT9LPOTH2y3yzYGTgWdp6FiVfHvAktDykGL3FA91FZHl3CBJMl3wQjqwLWzE9hUUMx6NHHrk+xDxMgax8UnhXrRGPyZj7NaK90dKsO6K+f9XpAN3Xv7xx4CltmNE4w4UZPUGCEhV9kFgLlrqg73nt+4ZG40Zr4wmNB4yX4jERTkarTUrW4w+gcOMaWt2UZGVhfDPg5ArFlfJOtZXxdkMDnE3Y7/W5ZYuMccd3XVy1oz+JaksR8docPl24RPZPhiITetwZT4mYGM6etXjy124rGejATVHmwpWrzuZvv3znIM0wJ9mg3BzBG0u4KuBUGpUvk6If/pazgpi2JVI2NDXOh182aqjKihj4NDx9lANVe/29pQB+SMzJnSO2HGSGPVjVdoktxTiBcHnSFFzLdYNzZycVyZN8e0qXlNNttF05VipR2M6qUrpSQisk7QAUTyVAtE0G0jJfzSvneZAvavgMqXgEB/R8afbaWv3iNJie4RT3/w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(230922051799003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(46966006)(36840700001)(40470700004)(26005)(1076003)(54906003)(70586007)(70206006)(40460700003)(6916009)(40480700001)(2616005)(6666004)(83380400001)(4326008)(8676002)(8936002)(36756003)(316002)(336012)(426003)(478600001)(16526019)(44832011)(7416002)(7406005)(5660300002)(47076005)(86362001)(356005)(2906002)(81166007)(36860700001)(82740400003)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:32:00.0086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce84035b-f920-46d0-7512-08dc095d3abc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8211

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
index 79c002e1bb5c..eb8a09f9341a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -126,6 +126,7 @@ config KVM_AMD_SEV
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select KVM_GENERIC_PRIVATE_MEM
 	select HAVE_KVM_GMEM_PREPARE
+	select HAVE_KVM_GMEM_INVALIDATE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 91f53f4a6059..85f63b6842b6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4252,3 +4252,66 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
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
index 32cef8626b57..f26b8c2a8be4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5067,6 +5067,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9ece9612dbb9..a56109e100ac 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -726,6 +726,8 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 
 /* vmenter.S */
 
-- 
2.25.1


