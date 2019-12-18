Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0D125229
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfLRTqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:46:05 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:1696
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbfLRTqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:46:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1jhN/CsMzbEf3V5BSXymJz15qm6iUzjPCx3Kv36wLE6CLNAiV6x2XZAw+MyRk3El5vyOd9fhTExPpz6qJqv2sncAPI0bKSoLVuj7Uj3wimFqeXDKOOf4lVgPrwv9fecD0NOQYkh169PHKGc+qXeWYGSlfGo2p42ycOeo7CEmRMQKEdDgckqd3kxpkjU0gMa72Z/Rb8Rh0Z3zX/aXD/ORRmUGgIWRZM7ZITWhuabzP2D4+Bsl1ylK23jJ7Vl3lDpmxXQrSimtxXu8K3FIuyEUkHLRibSIx4+JoeBJCPUv8T+8xb2sj9LOiFujMzkrraMJHOTjcT7Yqq7nukwpQQ7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n7QwQXGNQ6ppLI/MVD8trVnB8lmkWVFEwS1QvP80UQ=;
 b=Z/OAhSHgiW0naw7ncY1svQJtOy5wYvGH5+2lS3hbjJmdIEHJUphoyDRfdf4g6kJju9wO4Rswzb/p/v8z5HDVQNlqcim3G7L6mYs82ShHMyaP+Pela4j9VYfwbDhYrqOzraO1QoyGLeCay0cgSwBD49e4HTjlSZkLbWfa7V2CjSyh1anHePTd3RDT9Iau985SwOi0MKmdUtSH+kabYraWfZ7hnn9vLoA0U70wV73S7xJzDWP8z53vsDvjTn7rxFECuFXEYlQySB2GLxu8FrrjxQZiiwzZl8lGocUh5WlcT6qbac10IBKlKFC1fbFgYOs9t6IfvuZY6MFivTz6gg9tDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n7QwQXGNQ6ppLI/MVD8trVnB8lmkWVFEwS1QvP80UQ=;
 b=vvHo6vw/4bB19Ct2RXOKIqrXhcuxef4DSNpfwaK3P+nQM8QAU9LgA2X6b23zklEWKP5G1ZvcNhPoCFCJCkiTH0RYu0hYESjkG1Oc5SekXo8jazHqmTQSsJ6RCMWvIm2Y2G2zfhyUBP/XwWZ3fiSE7dazgQlGiyQnez+ttc7vNus=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB2876.namprd12.prod.outlook.com (20.179.71.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 19:46:01 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 19:46:01 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 1/2] KVM: x86/mmu: Allow for overriding MMIO SPTE mask
Date:   Wed, 18 Dec 2019 13:45:46 -0600
Message-Id: <10fdb77c9b6795f68137cf4315571ab791ab6feb.1576698347.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1576698347.git.thomas.lendacky@amd.com>
References: <cover.1576698347.git.thomas.lendacky@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:5:174::17) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b8ce194-c421-47db-80da-08d783f2e8e0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2876:|DM6PR12MB2876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28767ED9BED1F9AD881F1B28EC530@DM6PR12MB2876.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(478600001)(5660300002)(81156014)(66946007)(81166006)(6486002)(6512007)(186003)(52116002)(54906003)(36756003)(86362001)(6666004)(4326008)(8676002)(66476007)(8936002)(66556008)(2616005)(6506007)(2906002)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2876;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAZCAzc2kqxErVv/335x8QtK+oyaJTgp0fCoY3B6Pc5kD4rb2GP2KqBlTXZVGF0rUEvEVyF46V7aZ7qP8GVqMLjglQBdGODEweSsNQUIm+OVBACFUW66RcVJRK3sBkBlp7lJp+e3asK8nH3KsQCN6n5SvkaWNGrVZrg5XQLOvMjL9RJxChvTD9kgzMOgAEBQnreUGvk0zFCl2XqlOnqJeNx4pXcTHH1yjiAJ+EFibriIjd3QDCNSnq90zZb0mNzZNaZJv7O+OmIx5kY7GqgwaR5GBGZt9EKCivJmm01Jr6Pnpc6hpc90XS94FdYRt3RuI3NZH3X8OozRQB4m2Q1CEJ3Ld32qXXVVgHbD0Xp7LxgB6gVvZW/p8Ny0W7BwutSvYFrWVJn0PiGS5VbtUgXb0G1ay4AjedEHC76NwKZanMD2R5p45VLTim0togeoldl/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8ce194-c421-47db-80da-08d783f2e8e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 19:46:01.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pS9fcRgxUbjg9ob29U0vR1XSjbg+dMX3ppBwuUfkUrRTGuJpNJ2DGoE8gGQFSn0K6SzmPa1qL89VZiS45xAK8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2876
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
faults when a guest performs MMIO. The AMD memory encryption support uses
CPUID functions to define the encryption bit position. Given this, KVM
can't assume that bit 51 will be safe all the time.

Add a callback to return a reserved bit(s) mask that can be used for the
MMIO pagetable entries. The callback is not responsible for setting the
present bit.

If a callback is registered:
  - any non-zero mask returned is updated with the present bit and used
    as the MMIO SPTE mask.
  - a zero mask returned results in a mask with only bit 51 set (i.e. no
    present bit) as the MMIO SPTE mask, similar to the way 52-bit physical
    addressing is handled.

If no callback is registered, the current method of setting the MMIO SPTE
mask is used.

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++-
 arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..0c666c10f1a2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1233,6 +1233,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	u64 (*get_reserved_mask)(void);
 };
 
 struct kvm_arch_async_pf {
@@ -1266,7 +1268,7 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
-int kvm_mmu_module_init(void);
+int kvm_mmu_module_init(struct kvm_x86_ops *ops);
 void kvm_mmu_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..d419df7a4056 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6227,30 +6227,44 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
-static void kvm_set_mmio_spte_mask(void)
+static void kvm_set_mmio_spte_mask(struct kvm_x86_ops *ops)
 {
 	u64 mask;
 
-	/*
-	 * Set the reserved bits and the present bit of an paging-structure
-	 * entry to generate page fault with PFER.RSV = 1.
-	 */
+	if (ops->get_reserved_mask) {
+		mask = ops->get_reserved_mask();
 
-	/*
-	 * Mask the uppermost physical address bit, which would be reserved as
-	 * long as the supported physical address width is less than 52.
-	 */
-	mask = 1ull << 51;
+		/*
+		 * If there are reserved bits available, add the present bit
+		 * to the mask to generate a page fault with PFER.RSV = 1.
+		 * If there are no reserved bits available, mask the uppermost
+		 * physical address bit, but keep the present bit cleared.
+		 */
+		if (mask)
+			mask |= 1ull;
+		else
+			mask = 1ull << 51;
+	} else {
+		/*
+		 * Set the reserved bits and the present bit of a
+		 * paging-structure entry to generate page fault with
+		 * PFER.RSV = 1.
+		 */
 
-	/* Set the present bit. */
-	mask |= 1ull;
+		/*
+		 * Mask the uppermost physical address bit, which would be
+		 * reserved as long as the supported physical address width
+		 * is less than 52.
+		 */
+		mask = 1ull << 51;
 
-	/*
-	 * If reserved bit is not supported, clear the present bit to disable
-	 * mmio page fault.
-	 */
-	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
-		mask &= ~1ull;
+		/*
+		 * If reserved bit is not supported, don't set the present bit
+		 * to disable mmio page fault.
+		 */
+		if (!IS_ENABLED(CONFIG_X86_64) || shadow_phys_bits != 52)
+			mask |= 1ull;
+	}
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }
@@ -6301,7 +6315,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-int kvm_mmu_module_init(void)
+int kvm_mmu_module_init(struct kvm_x86_ops *ops)
 {
 	int ret = -ENOMEM;
 
@@ -6320,7 +6334,7 @@ int kvm_mmu_module_init(void)
 
 	kvm_mmu_reset_all_pte_masks();
 
-	kvm_set_mmio_spte_mask();
+	kvm_set_mmio_spte_mask(ops);
 
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ed167e039e5..311da4ed423d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7234,7 +7234,7 @@ int kvm_arch_init(void *opaque)
 		goto out_free_x86_fpu_cache;
 	}
 
-	r = kvm_mmu_module_init();
+	r = kvm_mmu_module_init(ops);
 	if (r)
 		goto out_free_percpu;
 
-- 
2.17.1

