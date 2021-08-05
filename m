Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA93E1DA5
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhHEUzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 16:55:53 -0400
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:14560
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241239AbhHEUzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 16:55:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpzLMZtwM8/Y0r3xYa4WP+4Qlw/aO32goeoVDxo+FRpjNJEbjI1v0jmHtBrxSCOLjVHJ9MdyKbeAJBfGxuOKC8aTeWjJU+fKFm9Ry/IbrcfsSMNKk1TGj/vTwR8/No3msBRseROJLg4Vt9r+GsOlQTtPFHsirPzJy19NYW80Is2rixYrG9oAS2qXAIES3+jFnmi1nvvtFwL6duOXNJm93IvuugW+8D5vrhpuvwCzEGTL7wVHM9xWIuoXvs1FzqABFkRNh3uG9zoERMRXaVGyBedd3vQSeIT0iKBi9Rs3l1HNEC4BzjoJb8wgzNzJDEdoKjqFQNRLmVPr3XSsTj1EDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g27hjmkedGRGmf+8gKKG29fsY2XQVwDNYQgJFq1AtzE=;
 b=KSIe/fGQS8oxDEsjKrr+XfVuFKYgVnWqUDRKP4RqHV8VE/jBxP8+UFLlCLhbZyr7LROOE2D8QTywjPs5behlw3eiLVRIqt2y+U0ta5RgvFCYX6UzbcaRLWpH8U0dYFlf5A/zdh28X7VYuDppImhstgKCyjp1as4j6QM7t0YD25pXF7MmCTWSeCLXiGroh9utKhv+QufjOzyJH2NlzPcY0lu5HohKSEtlg0Y8BJ5G+XaKyZkpP8BmXgVUHau89k5Lf7v5UiVd7Cyd/SdEnGNREiDbmhzdV5JzAAx0udIt51tGmuoi4n89C43L2c8CpJIMlkMBAdEb/VEtvHRjRUgOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g27hjmkedGRGmf+8gKKG29fsY2XQVwDNYQgJFq1AtzE=;
 b=ZyTZHuqTpJnDs190W0S4xBuohLbdFMtAnf8VBjka64NIhSlekt1CVPfO99QHbnfdkmmEoqN9hHXJc1P4/4yAY/Fx0Rs7WS975hfgBok3QQLsEt5lKGbLoxkZ/pv+nLVUqsCs/JLxkkQeCwCXdhQ0/qrvL71IdcmZsbpkeVtd9R8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Thu, 5 Aug
 2021 20:55:35 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 20:55:35 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v1 2/3] KVM: x86: Handle the case of 5-level shadow page table
Date:   Thu,  5 Aug 2021 15:55:03 -0500
Message-Id: <20210805205504.2647362-3-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805205504.2647362-1-wei.huang2@amd.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0082.prod.exchangelabs.com (2603:10b6:800::50) To
 DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN2PR01CA0082.prod.exchangelabs.com (2603:10b6:800::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 20:55:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5179ff0f-36ca-4854-74fb-08d958535f06
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0107ADE945A3863B5184D62CCFF29@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bvgDoASsg9piFNtaxGiJNssTHqT9MMxNxXqukgruHa9IZlIP4LCVadvZx60wR8C3tsWaMise+vA3VjEKWsFFJcXESinV/IcCUFdl/DK5vyWnRTWhxI7qUGgmeyPsmHuOfWiaozD3rcjntwHqd+D9oQ8Goyd2LziVJx6HweDGUYp8nosM8ZheCZMHFJHxeeSv5aQMP8g/5AeRgYhdudP/y0RQd/TxWsjKlebCkApIRm8MkzBdOo19LNfBOr8uQlj2w9BrMzyh7QDCmubT48tvXvOwo9IiX8AJ7GNCJs1VMWYm6KOT4mTe/lHAAQxrIZD8LJEzbQIiqYUzZ/P8tv1jmLjZmNwII4qJt/qJMXSBk41iRtjECb+vGsv0/Y5stPiJ43Zq7ZNkwlxWoZr4iqz9d3isl//pYhYBn5vHr0RnrjRn2VDOL8e5V8G1cazHf57lWGXQXw8OU97dV3/ZLgHUhiOTsXsnnYW4Ub5o0GSsDbUKMhSLXJpElzuqxK0RVYhLlOZboY+WpifBC75yfbm2rtMik/b8AszX4rCKU61x6bFUcoex1SxqR7JfwQ03PoUrd6qCdJveyW9kHeDXuGL7bXTileERSmsKP2pwVEje/e3EwLmp07o3BVxOx9cGvSwbTrYfxyvZA2Lm+LfzwUOhjGe+cuUaauDhV1HzAAdnFVoWIJnv6Mg4OzUoFO9tKgNg9bZoKQ2UVe+jhhX870xcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(7416002)(26005)(6666004)(6916009)(66556008)(66476007)(66946007)(186003)(7696005)(52116002)(8936002)(86362001)(83380400001)(8676002)(2906002)(36756003)(956004)(1076003)(38350700002)(6486002)(316002)(2616005)(478600001)(5660300002)(38100700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WxvQ66RACsyrTZ+PsgwVC1l2TdxcFfs9oDWTddAg3F9tJaHgP2i71I7NeKmI?=
 =?us-ascii?Q?l880/ZyYR0WmKNif6WpdgbbMAu/o1gcO/emiaX2SrIsmDJKuDNKiWwopGYQ9?=
 =?us-ascii?Q?QDSL3zjdCJX+lUvLi+VWSMRfKg+iVqFlssh6v8wS+7q5rYe8prXyHeLUKV3j?=
 =?us-ascii?Q?mJmMaAtLqz4z+tomBim73Gxh4sIr8AXQp9yDrRqgvKDeoHTbtTofRqXv+uyF?=
 =?us-ascii?Q?klD2gUjJAwYfsW5B5U4Je3IJ7xD8SH2J7at5ndlSaywAea/Bk5N8fGj6ruLj?=
 =?us-ascii?Q?uJ3G2V0Rr96wvkA/HutOGk10Tjgjxg+fjU3j292JWoqwGxOGQNLN8BOa4Xrd?=
 =?us-ascii?Q?jfpsnLYyf8vX6CfpDoQZVyThAAXdQ3fhh7sgRgX4KYLY4+x9220KU7WSw4Ob?=
 =?us-ascii?Q?SbOmpOlf5JWLzdkYCJQ93Ap4Z4i6s2kuoPDUmhrAU7/dxQK5dytw6tNRHepX?=
 =?us-ascii?Q?RzpsDkrjlkitVHkE3yeufWmmUfVdeo9mVVgB/ksWimgnztPcOH02TjPRvMpu?=
 =?us-ascii?Q?t5RjGYlwJSpsBvynBxL+tMWpWuLI1wKsq8yD2Rb4HOXokWVxYDtzRkkvYekp?=
 =?us-ascii?Q?mh+wMrQ111qxqk7EW9IjRQdg0rVXodNgAVnlv2Umc8pOL+sN7YIYm3X9fE6L?=
 =?us-ascii?Q?1EZ79C36GHISFyjGtc/V+bhuvMiM7MGUAuWO3LJRB418DiY8bH0BCQ3tzkfs?=
 =?us-ascii?Q?0EiBKyfCs1JytAQYJBj7BX2SnMF1/aeqEDHJ5A+HrZfzAImeI8gcRADf9jY8?=
 =?us-ascii?Q?+D5cMiBs7XnYTxZBhvNTZPclQnWPF6/K/hTtNxRdPQ5aINHrPxzqLlCZevlA?=
 =?us-ascii?Q?IjSrkS46cRv+1jCzqjV4l30TGJ4ff1c9jPEgN8hEgy3waPjsUDr7xE+Wi7Rw?=
 =?us-ascii?Q?7DexD7CGuSKXpmmbotNKUAcYZKNpiCvQoOSfp89k0XANG1m45COfXzpQ0mlX?=
 =?us-ascii?Q?h8vbN/sogn+DbTUPWZB3uAx6rpimP2ibAauLCFwDKbKwLdPcd6tKKGtSpF8n?=
 =?us-ascii?Q?wvEURwvcDA9/VEAmKg/s1699U/E/KZ9hcfumG6rytpLz2wAKfj43NA1lGL+6?=
 =?us-ascii?Q?qOaAxxvjJUnI5a+Ro1MDQN8+aNLqZ6sajBYSeHHzAxIKM9T6Y2aWLLaP8xR+?=
 =?us-ascii?Q?ORfVvzNxRGAZD29mP2/vk3WHM412H1jp38QUIo2TfI5O3oZhAUBc/FF2y9sc?=
 =?us-ascii?Q?FDjgXKeauAN4ig908Z3BVDzntrxttatHwtpxzWpkZbifQFO9RKdjW8Vtjpb/?=
 =?us-ascii?Q?GIC2hsUlAnt8UNCqsYKySl6acG4g7D3hm71+gPdWAGVo2Vn1Y7b0u5cjmvdX?=
 =?us-ascii?Q?ikMvUdUyZMSI66Me6gN4fvsI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5179ff0f-36ca-4854-74fb-08d958535f06
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 20:55:35.1533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTimOkO3I6xw20zKXpoHGXkk9oVc6xYf8oCuDHMChVTOFI6Nf17+oqHJL6hdJoaR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the 5-level page table CPU flag is exposed, KVM code needs to handle
this case by pointing mmu->root_hpa to a properly-constructed 5-level page
table.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 46 +++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20ddfbac966e..8586ffdf4de8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -447,6 +447,7 @@ struct kvm_mmu {
 
 	u64 *pae_root;
 	u64 *pml4_root;
+	u64 *pml5_root;
 
 	/*
 	 * check zero bits on shadow page table entries, these
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 44e4561e41f5..b162c3e530aa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3428,7 +3428,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
@@ -3454,11 +3454,17 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				      PT32_ROOT_LEVEL, false);
 		mmu->pae_root[i] = root | pm_mask;
 	}
+	mmu->root_hpa = __pa(mmu->pae_root);
 
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+		mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
 		mmu->root_hpa = __pa(mmu->pml4_root);
-	else
-		mmu->root_hpa = __pa(mmu->pae_root);
+	}
+
+	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
+		mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
+		mmu->root_hpa = __pa(mmu->pml5_root);
+	}
 
 set_root_pgd:
 	mmu->root_pgd = root_pgd;
@@ -3471,7 +3477,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 *pml4_root, *pae_root;
+	u64 *pml5_root, *pml4_root, *pae_root;
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3487,17 +3493,18 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * This mess only works with 4-level paging and needs to be updated to
 	 * work with 5-level paging.
 	 */
-	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
+	if (WARN_ON_ONCE(mmu->shadow_root_level < PT64_ROOT_4LEVEL)) {
 		return -EIO;
+	}
 
-	if (mmu->pae_root && mmu->pml4_root)
+	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
 		return 0;
 
 	/*
 	 * The special roots should always be allocated in concert.  Yell and
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
+	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root || mmu->pml5_root))
 		return -EIO;
 
 	/*
@@ -3506,18 +3513,30 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 */
 	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pae_root)
-		return -ENOMEM;
+		goto err_out;
 
 	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pml4_root) {
-		free_page((unsigned long)pae_root);
-		return -ENOMEM;
-	}
+	if (!pml4_root)
+		goto err_out;
+
+	pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!pml5_root)
+		goto err_out;
 
 	mmu->pae_root = pae_root;
 	mmu->pml4_root = pml4_root;
+	mmu->pml5_root = pml5_root;
 
 	return 0;
+err_out:
+	if (pae_root)
+		free_page((unsigned long)pae_root);
+	if (pml4_root)
+		free_page((unsigned long)pml4_root);
+	if (pml5_root)
+		free_page((unsigned long)pml5_root);
+
+	return -ENOMEM;
 }
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -5320,6 +5339,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->pml4_root);
+	free_page((unsigned long)mmu->pml5_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.31.1

