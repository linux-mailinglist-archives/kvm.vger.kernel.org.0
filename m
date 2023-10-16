Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961257CAA0A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjJPNnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbjJPNnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:43:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65397171E;
        Mon, 16 Oct 2023 06:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knk/Y0NYJV69GWd8j4VrJR75/KbJQlxDLCJu07DtBGVgCGhpw/enZfOfdq07wvV7/RA+16LM4/MAHxyqVdtoQQZHpCrNAQVeZNu5voDgEujbU9nJytdly9+xuRKrLm5Nwvm4yyykM7OAuc4Irccux8f1TxyNtZWASHlbNcM2UPKA5jH08itEz7cJMXGaH7FTJSgddUp0FTa5JO22HthRI3xc+2T5yGLqXoi94jC1Ho2rV0GVKpv0QkQNsZ7saqaqtUy7WcEK5pw3euc7QzC9vNMudeWo+X3TeoiQBMvAg9jiImvFiAkT4rpyNBgaDIjMbtZ8LoU/k7+pwm9+rDbYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7Mbl041b1klKFpTG/hZsMgCD2LPQQlrF/scjxp8wOo=;
 b=aNCdtOncw4i668jAZOydDzdAJR+WPZrq1LWdGfNJL6LPQRye9CJnlBB6X3qJYxz4NAi5uzKxCN41Oq+K13Brhchpqi2y9koYjI49P/EUJRZD6BwGLc4GWFFNmMcOcY1Pol+d70hRQ9dOYEYVKBJsD1cafpjX1LKHyMhkv9uPT7zwrgTkIpatFHiyGvAo+wlOAqS092UGuOvJDrG/R5z/em/QZpB26KzamczGv/aof7TciVlIrZAoZCnMdmKqY5SeAFQtor+FLU8T5m4OuxnuNp9mHJQ7ROOytMOWB2PKGPcD8g26YP/v4M77Q7F7aLptFnuVolrMw3hRnxJJ4KnEEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7Mbl041b1klKFpTG/hZsMgCD2LPQQlrF/scjxp8wOo=;
 b=hc4CBoF5lnrcCu131vgOvfwu8nK/bw4Th5ENmz7mVnYpL+QIqAS+ojm0p1hLFIv3XdhU35t/14YAnRXT9CSrwLLWXKbh1lNuLln2y4dwNaYyKcoAGGV72D+cbE08LlcpIj5jE2hM30uRlEvxYxjInWrtC+AAfc60PeN7/J/ZWFA=
Received: from BY3PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:39a::10)
 by SA1PR12MB7319.namprd12.prod.outlook.com (2603:10b6:806:2b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:43:15 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::37) by BY3PR03CA0005.outlook.office365.com
 (2603:10b6:a03:39a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:43:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:43:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:43:14 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 40/50] KVM: SEV: Implement gmem hook for invalidating private pages
Date:   Mon, 16 Oct 2023 08:28:09 -0500
Message-ID: <20231016132819.1002933-41-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|SA1PR12MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 631fcebe-1429-4e64-25a9-08dbce4dd8dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcOB04eQ9Uvj4v5EhIrKqV+v3GgaBVCXnYERiOHypXxL8Veb8wI+lo3+lZkIuQU+APf+hWRfaOK45zc8Idsz65uAiD/SIqMBh0ZljGxqe4cZ4OMzQWa6IrUvk2R/+GrMxXgSdVyYXLWw7kf5xhsemY5s1BqClx281BNWeg0EiDQD1VPsy4SSxeAtvB+bjZInNJTQxIef6jBwfj8JP+P6b9GRuMP2LOcru0FO/i0HqxBNKCO5NKZxnZzJbAv+F1eEoJuAcFx6RavDD0Cal8AUTaMn5zhCEEZWH19fljJT8Potr8siBbT0Q+jX29T+vePDSdtoZCtrasshlvVdjPDxjajSVs0zeXoUhZ+aSmcySwpf8shhC/z7SqfDBC51t1JUZRYnRX1X0b9NJTXJCzyDcRCddqS0hqdFlgI4V9xmXUJK3Of3V5IOXh2pz9xXaVX+p9D147ezIWLpAud+JoXRSNdMzU9ha9o2OK6b+k4FEgV//3QzukciGzWqQW8RhrM3diXQwD0Pa7S24J5ljBO8dO3BmrKTuiUdSDDYLT+NZsMU4X2CA9jBMkuJ7cRaZxDjxadoLbaStl66FRIss9tdxn36LsUKHu6FJw1+0XqiRP24OdoMRFm0G6jNBAd9yRKYrCleqXwDoop3er4KGaNkyP7TVn5zJwJZk5sd48AzgP8DkvARfs+lTybT7WFs/ydXnsvzXOYZKoJGQr5bxGUydl0w1AsIvUkn39hYOgLeervB65ie3S9G+wYOEy++vXN6ueKmP3WFm9PRNaqFGSuEUA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(136003)(376002)(230922051799003)(186009)(1800799009)(64100799003)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(36860700001)(47076005)(40480700001)(356005)(81166007)(82740400003)(478600001)(2906002)(6666004)(7416002)(70586007)(316002)(54906003)(70206006)(6916009)(4326008)(41300700001)(5660300002)(44832011)(8936002)(8676002)(7406005)(83380400001)(336012)(426003)(1076003)(26005)(2616005)(16526019)(40460700003)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:43:14.8451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 631fcebe-1429-4e64-25a9-08dbce4dd8dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7319
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 8caf2eb6add8..dfc857db389f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -128,6 +128,7 @@ config KVM_AMD_SEV
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select KVM_SW_PROTECTED_VM
 	select HAVE_KVM_GMEM_PREPARE
+	select HAVE_KVM_GMEM_INVALIDATE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8cf2d19597b1..5b3a3bbfebee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4230,3 +4230,66 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
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
index b3ed424533b0..9cff302b4402 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5043,6 +5043,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c5cee554176e..1fd90a88b0db 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -724,6 +724,8 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 
 /* vmenter.S */
 
-- 
2.25.1

