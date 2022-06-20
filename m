Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EA95527CB
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbiFTXKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244066AbiFTXJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:09:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849A62ADF;
        Mon, 20 Jun 2022 16:09:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GApmMJtp/sdbNaUpBAX7GPkPkhT0aMCsd8B6oVBor9OIVSMiDPzsf1DtrmD0ujkaW608h0cHm/z7A7M/nAfAMIOiXNkB66GgVMpqz5y/X6HU4RNQDmTDhaeMmMTMJVVeiIuPZtJJofYXjoVYLVs32xSM0cH4blgCAIXJTOFa+OGxXXgiKxNHKYQsbPbDL5j9YgmFYtxrFOzOVPO2IUGkDuge9S9v5h9O/8W8mKvwNW0YvonsNXg2D6DBInLu3wck888lv8sNBVDc9AJ/6GaWTgeB60MBMKaHSic5AvTOsH2u4qOWjiOqd7IVy4rTKl40m7znqjaad+pF5H7en5KlZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VE0/55hWO+m8twwKj5kywDI4TexQwfjtuIHdQhO/qkY=;
 b=T/z32YwAVlNHNZx1tVKsjg/m6iXoSaViZhzNIZscSj7t/AEdiTgIQYfRgHGLo68o/zIFtWOFd220ItaVwsuuCB5t3ihPJdYzb/jtVsMJyv0D0mPU4lafoA4BYlzFg9uorThnLheX0zhXTbvtr2alTGpRaL+CpHUBmGJ4HeTdBo2OEo00in7BUjFrjpCC5VsEouHwVwx3KcNBmqXCik8pZEfRM3qWh70JAn1HqtroJApanDZlBPV05pdgD2Fq6yp1nUIp6MuSsc/l7nsMlO9gYkAoR9S0o3gJvOkKOVxbcdgzdLgLCRSN73aERoVFhqRVFJJFNtExp01//vIENsxg4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VE0/55hWO+m8twwKj5kywDI4TexQwfjtuIHdQhO/qkY=;
 b=Qmng41KwAuBIT+G1sfI9U9PlG/I4xA1ToIUF1JSs4PPlkNKTusqdu+/rdNvdjcCJ6AgTf7wYls+MSpXR5waAZwO9S1gEh511eAT3cR9F9pLGS/H/iTxwu6QogeMUE1m3SyzDIqVX+C7KfV7GQP7hkYnGogKvtiRw8pehGT8W5rc=
Received: from DM5PR12CA0055.namprd12.prod.outlook.com (2603:10b6:3:103::17)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:09:14 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::1d) by DM5PR12CA0055.outlook.office365.com
 (2603:10b6:3:103::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Mon, 20 Jun 2022 23:09:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:09:14 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:09:11 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 29/49] KVM: X86: Keep the NPT and RMP page level in sync
Date:   Mon, 20 Jun 2022 23:08:57 +0000
Message-ID: <ae4475bc740eb0b9d031a76412b0117339794139.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 970a2641-b2c2-4d82-e331-08da5311e4ba
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB457542DC838A9E2E35775B1A8EB09@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8OSXV13BPGsNPCSAxtAhoGeJ/WDaJEG9DivGgEGJ6htLx53DruoCicJXG3g6oCdyXVasqmrimhOT3TGaALrLoBtwen/Z0dQ4yKT7yRIPAbu10RYRGl7SKKFZ/9bSaV2oNba+XCiBmofS2xZm2hHVU0JPrZSOumca7MAee3S0whAtPTXvhVag0PiCPGi0MNDicURVCTmT1AeEMZ485YjVPoZWsfSKDZZMxqqP7omXbtT4+FkDZR9RcDE0FjdqwG5idYidkIi2xAth4C4gq2qRdtHVmFwsm+WmEzR6Bgd2W3XyyPAJlH+9/V9oKngHU0OjLUufr9dkeoRM5bRUfNBpTEmt+OlKqQtLAiKIVACAGZAqOML8eTL5rlTYD0BXzAEJiCn26ho9j6HKuNnvCZigH8Mi6RsYUxIg6MPpQ/dQChZftMWUVG2NqLhrjVR7DRjbh9G6yL1a62yi8kasgXfAgLwJ6JFltcB6o+o8a+hnZ98SW1CefEif01DWluLr7zCtKpHTTGShBEjUEvDzryI8rOEsPGu1dZvyc9p5I6S/LpeS9jUjrRIL1Dx1VHFXRhpccP6vj73I8JvjdyCWPmkP4zEaaV0pjNpIeATsjpitNnfpo1UxURlPdZsNqpbBmNrofCy9nbmOIXLEX9aEdY/rCFWcBK+5m2qCvhiutbopmraSDip2YmtI6EFduSymH+9rEpnlfskEkD2uSVAO75IW6LkLBerkLAlLpR+VbLa1dvR+PfPfYZwBuMdiy/KmTa41L5pTInFsavougkjpLhfxw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(36840700001)(40470700004)(46966006)(356005)(2616005)(7696005)(81166007)(41300700001)(86362001)(82740400003)(6666004)(26005)(426003)(186003)(16526019)(336012)(83380400001)(47076005)(70206006)(7406005)(8676002)(40460700003)(4326008)(36860700001)(7416002)(8936002)(5660300002)(40480700001)(36756003)(82310400005)(110136005)(478600001)(2906002)(54906003)(70586007)(316002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:09:14.2255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 970a2641-b2c2-4d82-e331-08da5311e4ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the NPT translation (gva->gpa->spa). The NPT page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             |  5 ++++
 arch/x86/kvm/svm/sev.c             | 46 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a66292dae698..e0068e702692 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -129,6 +129,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP(alloc_apic_backing_page)
+KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0205e2944067..2748c69609e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1514,6 +1514,7 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c623019929a7..997318ecebd1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -43,6 +43,7 @@
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
 #include <linux/kthread.h>
+#include <linux/sev.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -2824,6 +2825,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (unlikely(!pte))
 		return PG_LEVEL_4K;
 
+	/* Adjust the page level based on the SEV-SNP RMP page level. */
+	if (kvm_x86_ops.rmp_page_level_adjust)
+		static_call(kvm_x86_rmp_page_level_adjust)(kvm, pfn, &level);
+
 	return level;
 }
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a5b90469683f..91d3d24e60d2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3597,3 +3597,49 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return pfn_to_page(pfn);
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	int level;
+
+	while (end > start) {
+		if (snp_lookup_rmpentry(start, &level) != 0)
+			return false;
+		start++;
+	}
+
+	return true;
+}
+
+void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)
+{
+	int rmp_level, assigned;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		return;
+
+	if (!assigned) {
+		/*
+		 * If all the pages are shared then no need to keep the RMP
+		 * and NPT in sync.
+		 */
+		pfn = pfn & ~(PTRS_PER_PMD - 1);
+		if (is_pfn_range_shared(pfn, pfn + PTRS_PER_PMD))
+			return;
+	}
+
+	/*
+	 * The hardware installs 2MB TLB entries to access to 1GB pages,
+	 * therefore allow NPT to use 1GB pages when pfn was added as 2MB
+	 * in the RMP table.
+	 */
+	if (rmp_level == PG_LEVEL_2M && (*level == PG_LEVEL_1G))
+		return;
+
+	/* Adjust the level to keep the NPT and RMP in sync */
+	*level = min_t(size_t, *level, rmp_level);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b4bd64f94d3a..18e2cd4d9559 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4734,6 +4734,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 71c011af098e..7782312a1cda 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -673,6 +673,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 
 /* vmenter.S */
 
-- 
2.25.1

