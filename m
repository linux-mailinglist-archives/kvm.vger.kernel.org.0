Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B627CAA11
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjJPNoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbjJPNoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:44:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01361B6;
        Mon, 16 Oct 2023 06:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axCt6HEyQTZokTWMMyVLy14NxpyS8C6qqjwgj0vzyB5r3jG5MSasCXWvHJognNPg2ZaaHBfMv9eqYlGLkZpP9avJ1NMWGjp2IXI3fQEzefF2AILbKqa6GoaEBK+Z5RmPj3MJn+7CBlsmGiXGOnrrA+QorPTJJiQhu41dFVDCdNdaFisqM6UX67Lb1Cc0eNvS8NYmJoxzmCdPbyjjNc7hO4YHLZmywe0DGGLLzUNmwqi/lkhMqOc8C9AB4qGvMhdRczQplwdY3HjSyiQD8We7qeBcfLLouUbj6+SjzpQekrtsQOTe5qdJkxgadHYsz+abOEV2wdZXIPPeagUTZ2M9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0BItP21TMokf/7PbhApPDE+AFmeFaseWrdieGwU510=;
 b=OTYMg4RRPpfvncVgtGjjnCVM9U3K6rVSEYOntp26iR1GUD8xK1c0BuvtcnDw5g8rIFVmhCOe6FO2Qj1iLZUHV+eh//jxGnAYEe3BlAd3Ox+/F/THo8df1JwhonDSCgThJWTcRgM9Jn7QauCd+NXY+D4TbcxtzeCCNLzgiULLCsYv4F70LHlWfRL1oV0H+t+DpzrL8vBH/7mfAAFx1oasnjz5pG0Rfi3M+Ra0cVE6TJevF+AxAufAcRLck7Sjd61YASz7C8uXQkJOqwF+aZyPbglHm8up1WYQfNt9mF/GvsVB5Z8EGK+WsMkPZ/vwHfbjVYvw0a34ntf+k1TRFLIFcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0BItP21TMokf/7PbhApPDE+AFmeFaseWrdieGwU510=;
 b=4NVCJj6lGmzx3ZPNw3q+MW/kfrMbbMCjt+lsNUpUHlo9yYhhJ6himVxdWxQWzfY0+vpNVVsa2ytAQvRifIRbjXGQytZ/a60Vhn8qK7gNpd8IKo7w3Apdv03efbiuoFYyDKJtaKA+lEjGVEEpoAjNrxP1ygc5dCBbF0O4xd1Cvj8=
Received: from SA9PR13CA0149.namprd13.prod.outlook.com (2603:10b6:806:27::34)
 by CY8PR12MB8361.namprd12.prod.outlook.com (2603:10b6:930:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:43:56 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::13) by SA9PR13CA0149.outlook.office365.com
 (2603:10b6:806:27::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:43:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:43:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:43:56 -0500
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
Subject: [PATCH v10 41/50] KVM: x86: Add gmem hook for determining max NPT mapping level
Date:   Mon, 16 Oct 2023 08:28:10 -0500
Message-ID: <20231016132819.1002933-42-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|CY8PR12MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c548af0-be41-4070-6608-08dbce4df1bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwUcXb5XlMTTcvlrswstMDTo3m2QHW7cFiRMSBs7qyq1hm0piign5obsbWMUkrfYz2s64n6OCp6Gp0y7I6zsK5Te4QQhoITLYtwX30n+x/IuHnxY1QKiwVNJZM1/C/AOBQJK08zXmpNXnP3RRCDDGAQBnoT7SKFYhR6+pgQe1XyeTutZ04TMNx8WbUGOsYpEzz96gPgcGvRth9gkRdHHoy2U2BOJmJkdzlOdZ3U4YBoyh9Cx82mnjzbE5iKGGxlY0L8Q1StNdN82uOrVUVMTWYK09Rgtk411o872fTO7JxSSwfjGF9laoJ87oEg+daIhQBGHnRI3pGZBypPYPEMGPvuDmtbubMMEOPVlsivsma6VgUmU+uwBHT6yWM/OoBWKEbBwuY+9oGVuiA1vEcfxoYEtMtvV9i6GoA2j+fXZdxCLZQ/MujBa1OtKmJQsXPo9sddQk2ayHk3tnGgIUwYQNErPcF5tDmVWiDHwFVatYMlj/US0Enmx+1m7bYZspS79nu3L8xbTyLI7cwayJxrKrR8vvkKkVfzq/7Af9J3pslAzLoUpD8Dv0ksJ+m1s5ZR0PGxZyOvzLmqwmrIFA+mTjVNCYYQ5AIzk8HKnpqwE4Vi9BDQFtiOW2tc2cPDGqBIgQHkTDU1gnyUm2LZ5gLswSSg0UOzPTgMiSCuQeD+j9fBuO/OHOh83SjbcTexjAorV4DoDqZf9oLMImOy6cWEyHTi576Q+BrB+Ffz4IKhUiKnk+/uWD3xscM37G+05dqeaesN8b88wL6H5qhMV7gg63Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(70206006)(70586007)(2616005)(6916009)(54906003)(478600001)(316002)(7406005)(426003)(1076003)(336012)(26005)(16526019)(5660300002)(8676002)(8936002)(4326008)(44832011)(2906002)(7416002)(41300700001)(86362001)(6666004)(36756003)(82740400003)(356005)(47076005)(83380400001)(36860700001)(81166007)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:43:56.5513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c548af0-be41-4070-6608-08dbce4df1bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8361
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Add a hook to determine the max NPT mapping size in situations like
this.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             | 12 ++++++++++--
 arch/x86/kvm/svm/sev.c             | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 5 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 4ef2eca14287..7f2e00c48d3b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -135,6 +135,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL_RET0(gmem_max_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd4bfe0b7deb..6dda4d24dbef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1764,6 +1764,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c78807e0f45..64f6cb428b32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4304,6 +4304,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
 	int max_order, r;
+	u8 max_level;
 
 	if (!kvm_slot_can_be_private(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4317,8 +4318,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->max_level = min(kvm_max_level_for_order(max_order),
-			       fault->max_level);
+	max_level = kvm_max_level_for_order(max_order);
+	r = static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
+						fault->gfn, &max_level);
+	if (r) {
+		kvm_release_pfn_clean(fault->pfn);
+		return r;
+	}
+
+	fault->max_level = min(max_level, fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5b3a3bbfebee..6c6d5a320d72 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4293,3 +4293,30 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		pfn += use_2m_update ? PTRS_PER_PMD : 1;
 	}
 }
+
+int sev_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level = level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9cff302b4402..d97ec673b63d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5043,6 +5043,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_max_level = sev_gmem_max_level,
 	.gmem_invalidate = sev_gmem_invalidate,
 };
 
-- 
2.25.1

