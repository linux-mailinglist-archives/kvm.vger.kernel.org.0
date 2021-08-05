Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54EF3E1DA3
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhHEUzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 16:55:40 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:12288
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241412AbhHEUzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 16:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St/j4JfvII3agciJhwsts4e/nhiS0TFzOCV6DomaxxdrUj9qgawzz7iG6xbox7CL9HfzbwbxvkE1LobOKPoN3ds1EwdeYl2pog84eSzbMu/zl8wl95qyBdJvypIFJA2PCeinM3ER8sue7Ae4yesapXqgrQzRHWWiIRSvOeiDIutIYFjmV5JtTuT5Djjre2JDjDPyjsBB5S6D/2hbECrELCrcO/AuuiwLp/baVNk2Du5rus4h1OS/3c9mktigx0W7Ed4FHWYUNbLWqStN7Gmgsi3gfLE0Y4xA3iqNa+GBZgrNz8sI1+dQcXnq2WcqFEaMXnz/UGD3632CaGQ+tmU3Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jq2/H6+qQJj2fFeb3gwwk57ehl1SWWoDwsCArOvWM2s=;
 b=gMaNa0nLkP6tKNh0lx3vkw4N0+OZ5LYw8b01EC0Hk91eqzkxcedjfSIY8HZ+Iunmv9ZNZfCdpvryZskYOD0XbrbmmTWfeOYhT0I8k5EFTWOo8JLrNbQzuB/vtKUMCPEbOJcJmNcOwuY78PKeXqjYWD4IPGAc6LRp9A5Go0iInCb+IPkPtaJK56E8gbmhWQ+y9R4z4RubArDAU7c/+B5wZ22IBqmRkUppBz3lHsSroeJJXbjscjfMsm/bf23bcEOptCHZKE95MrAi5937APwmGwfagnXGUC+PbMxiL9xN4JOaN2azA0IPnKkRWVJgNX10Y2RaHV26NqEWASlWb1yPEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jq2/H6+qQJj2fFeb3gwwk57ehl1SWWoDwsCArOvWM2s=;
 b=tswh0eC1iOwBJzjfU8oME8IaKBZ5jyU3hjGkjLAy7mbwv2CiOrynoSlL8OC5ColE7s8BdgMm971crGA0ZVoQAPx9Ee62S9+R1m/YFIofdrJOI3ovTceiY2aD+moHVXlZrYatBGgnyTgMqxRzH9Sdd+GIta1sioO7i3d9gntxjds=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1241.namprd12.prod.outlook.com (2603:10b6:3:72::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Thu, 5 Aug
 2021 20:55:22 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 20:55:22 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to vendor's specific code
Date:   Thu,  5 Aug 2021 15:55:02 -0500
Message-Id: <20210805205504.2647362-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805205504.2647362-1-wei.huang2@amd.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0003.namprd04.prod.outlook.com
 (2603:10b6:803:21::13) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN4PR0401CA0003.namprd04.prod.outlook.com (2603:10b6:803:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 20:55:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a793df1-b75e-480b-f59e-08d9585357b7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1241902240D3B27D96C67EE4CFF29@DM5PR12MB1241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqc5z910aXTrDEsqAwUx+4vD+SMBwEUZf5Lj2497MJ+6NKeJpoiaaVUYMOo3iFSEyHjB4Ng6WrahNQn/n9eehj65Q7VtbbMEjWq0jbbkDQ5tKTp8gmNmBOP/QG7+nHiVJCIHIYOSw3M+CyxrWU1+abYmY8NNGHnSoHDUpANwXGbvlhd8s10GFScyc0q4KEDSAfOJqhcJgqjs3swuQk4CuF9fDISdAIZlB/qplzeXGbfFayh2O/z69uS/g+TwVIQTEJQzSjpQzo06ygS4dbq7xVYN56TYmFoUkd6aK5/n1TvEs0LODPMSUo9Sdd/IMe4aB0BtZDugdwC6SRgTjWOctQHlAKZFM6lhb0c/o1MorgWHvbo18wiclNcKQlGowMImXWqiU2M5eVOTb+dybZswPUW/5FSj4+GQp0ny2yw08U6vhqRwYWQZSngW0ZgvVMcL63uUudSTZeF9UdYosCtl+kH809O3mvB7+uSmqgJyX85wWR88j8phKedslMo/kE8b314jnTmBy2+Ac2wpnMkfZ2BLEF4PrVAvm8Bnwa0uaWnPa51efjrvwTTLAd7BX/NUcMYa6jKZ7ZMl3EnoJwV+maFZg9cZXwkhGVqcr4k7/No+/nWyIjheke+C0pSWUUa5/8/YsZKlFNPPoAJksocTwPQPvsMZJeKNISOG0eliFwnAs6WNkSzCwUt9dTO+FlTHsncXqMBIAGiONkeP1oNcFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(66946007)(86362001)(66556008)(2616005)(956004)(83380400001)(66476007)(6666004)(316002)(26005)(6916009)(2906002)(36756003)(8676002)(186003)(7696005)(1076003)(5660300002)(4326008)(6486002)(7416002)(38350700002)(8936002)(478600001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hFHbP0GM0anhBI9Bc8JSRxwpk1WTB2RQ0H7wMmIdJPSYP5lt0BPBAyEfUCQH?=
 =?us-ascii?Q?KtZOgw/C/r66lY1q/2tMm6DWmQ974e4ZbGGklFMCg1xC1kpqTt1z+xRfZbxc?=
 =?us-ascii?Q?mOEgw8l6mRu8SYMGsLwvdBQ4qE97ybp+smPSDSLLWVf9JrehKnwxoTWZvmbi?=
 =?us-ascii?Q?b4fkMV9Vetju8yHCf3UFYQcrJ1wWT6tdJtKEj1e2KQIQaFIixyYFSDSmghWT?=
 =?us-ascii?Q?sNPepKeE9KJYG5KOH87qVNMqh92+25Ws2/2oLK1zcngNoZtbIUBWNhQF1JJc?=
 =?us-ascii?Q?76xJQgqQxnO1Q/KPxsjU0iD5uTeLOYqLr+g1XIqYXLPx1esuHUQs11AHQh8Y?=
 =?us-ascii?Q?zVEeIwjLUtOE+y5pfGLJTlGtze+umbqonpc+sMTaC9Qj0fCTFjo3Yu8imWn/?=
 =?us-ascii?Q?RfSye1hV8Z4yQb2xuficzRr/rH4A1I1Q9Be0KYSqmz+NRW+07T01LJgG6F7p?=
 =?us-ascii?Q?LtmF+E/nd0E1gm9So/1VbnED48NdNH4t5lOwN36YxO9fJMYQpXeHFRGa9tdA?=
 =?us-ascii?Q?iN3l8c863kgT/qf8vWDbmj1nRBYBBn5sBWcX39HADJMCUCnVG5eB0QRbo/7q?=
 =?us-ascii?Q?JpMPGJa/LyDBWIsH+X3TwnWU6xPEqrbY6FxoiLwJSA33p7MdorP/R36bnlfE?=
 =?us-ascii?Q?azf5Ef3iHmgBiEX1M0M0CyK2r/2lvWGTYBdPiJWvs4oDgk6zIopbZH8EtJ3S?=
 =?us-ascii?Q?f3X0KH4b1VdNnbKKeuDBDzsxGxUItUnV8eCWI6JTBPCiUiyzSh+txXekkSBj?=
 =?us-ascii?Q?W7NTZOJUmEU4ybgOSVmDcXg3mFdqNpTidMr359Hg3ZCyeJ0S4R3/870GgIsg?=
 =?us-ascii?Q?P5qWA225XlWVIuhbJ4lKmlw2IdOhKn67Ou08NYlXvXm77DN0UEocLTycs5NB?=
 =?us-ascii?Q?DcCLL3riqSLFPqtT8k9isO7wPLPIAoF1AUBivqgA5jdaQqN57/qX5ydu7ilL?=
 =?us-ascii?Q?rddrqOfMupOsitloSerlCm7fO3mJjR7KuLmFnL22fjaN1nwx88/88KjHOUhT?=
 =?us-ascii?Q?P0bCAKxUT3Fthwmd0yjqGzgpNimX++IsqXOCCbb/3L1hUc6S4fddWbeu8IHW?=
 =?us-ascii?Q?pYYt4D8Fh1BBqUl9qniEe8yuntkRiRY636YUfWUXwqtzF69WrbuichNJbD7s?=
 =?us-ascii?Q?X6u3VEJrYY+IA/89cnXJ2JTctCai5xx7nB6JbY9RimfK4zvMfJFShgNWb8/9?=
 =?us-ascii?Q?AHev3hNOmfe7GuKNFkke19HzK4DevimRMRspDIHcQQT46sBqXI45OMPt589n?=
 =?us-ascii?Q?vaLXwXr7j12E8qiD6CBmvZvHr3HlSh4bNw5IavP7Qu8PqucjUX1BzM9WYxQG?=
 =?us-ascii?Q?Pa03UNFpQ2oR9YRhG592LPab?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a793df1-b75e-480b-f59e-08d9585357b7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 20:55:22.8478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8khWwR76kB0tu0ZiFgnPQa0+CDh/22p9xSWFyKupAlWgpjk+YmxiKF5cwY/ObQf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1241
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the TDP level for x86 vCPU is calculated by checking both
MAXPHYADDR and max_tdp_level. This design assumes that all x86 CPUs have
the flexibility of changing the nested page table level different from host
CPU. This assumption might not be true. To solve this problem, let us
create a kvm_x86_ops specific function for TDP level calculation.

Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 ++---
 arch/x86/kvm/mmu/mmu.c             | 22 +++++-----------------
 arch/x86/kvm/svm/svm.c             |  5 +++--
 arch/x86/kvm/vmx/vmx.c             |  7 ++++---
 5 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a12a4987154e..9853a7c9e4b7 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -85,6 +85,7 @@ KVM_X86_OP_NULL(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
+KVM_X86_OP(get_tdp_level)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..20ddfbac966e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
-	int max_tdp_level;
 
 	/* emulate context */
 
@@ -1365,6 +1364,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
@@ -1747,8 +1747,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-		       int tdp_huge_page_level);
+void kvm_configure_mmu(bool enable_tdp, int tdp_huge_page_level);
 
 static inline u16 kvm_read_ldt(void)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 66f7f5bc3482..44e4561e41f5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -97,7 +97,6 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 bool tdp_enabled = false;
 
 static int max_huge_page_level __read_mostly;
-static int max_tdp_level __read_mostly;
 
 enum {
 	AUDIT_PRE_PAGE_FAULT,
@@ -4560,15 +4559,6 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
-{
-	/* Use 5-level TDP if and only if it's useful/necessary. */
-	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
-		return 4;
-
-	return max_tdp_level;
-}
-
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				struct kvm_mmu_role_regs *regs, bool base_only)
@@ -4576,7 +4566,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
+	role.base.level = static_call(kvm_x86_get_tdp_level)(vcpu);
 	role.base.direct = true;
 	role.base.gpte_is_8_bytes = true;
 
@@ -4597,7 +4587,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
+	context->shadow_root_level = static_call(kvm_x86_get_tdp_level)(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -4688,7 +4678,7 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
 
 	role.base.direct = false;
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
+	role.base.level = static_call(kvm_x86_get_tdp_level)(vcpu);
 
 	return role;
 }
@@ -5253,11 +5243,9 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	 */
 }
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-		       int tdp_huge_page_level)
+void kvm_configure_mmu(bool enable_tdp, int tdp_huge_page_level)
 {
 	tdp_enabled = enable_tdp;
-	max_tdp_level = tdp_max_root_level;
 
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
@@ -5356,7 +5344,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
 	 * KVM; that horror is handled on-demand by mmu_alloc_shadow_roots().
 	 */
-	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+	if (tdp_enabled && static_call(kvm_x86_get_tdp_level)(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
 
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e8ccab50ebf6..04710e10d04a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -258,7 +258,7 @@ u32 svm_msrpm_offset(u32 msr)
 
 #define MAX_INST_SIZE 15
 
-static int get_max_npt_level(void)
+static int svm_get_npt_level(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	return PT64_ROOT_4LEVEL;
@@ -1015,7 +1015,7 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
+	kvm_configure_mmu(npt_enabled, PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	/* Note, SEV setup consumes npt_enabled. */
@@ -4619,6 +4619,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
 	.get_mt_mask = svm_get_mt_mask,
+	.get_tdp_level = svm_get_npt_level,
 
 	.get_exit_info = svm_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..419cea586646 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3062,9 +3062,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vmx->emulation_required = emulation_required(vcpu);
 }
 
-static int vmx_get_max_tdp_level(void)
+static int vmx_get_tdp_level(struct kvm_vcpu *vcpu)
 {
-	if (cpu_has_vmx_ept_5levels())
+	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
 }
@@ -7613,6 +7613,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
+	.get_tdp_level = vmx_get_tdp_level,
 
 	.get_exit_info = vmx_get_exit_info,
 
@@ -7803,7 +7804,7 @@ static __init int hardware_setup(void)
 		ept_lpage_level = PG_LEVEL_2M;
 	else
 		ept_lpage_level = PG_LEVEL_4K;
-	kvm_configure_mmu(enable_ept, vmx_get_max_tdp_level(), ept_lpage_level);
+	kvm_configure_mmu(enable_ept, ept_lpage_level);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
-- 
2.31.1

