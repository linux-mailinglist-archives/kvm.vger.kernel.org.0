Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3DC3E3C84
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhHHT1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 15:27:51 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:5825
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhHHT1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 15:27:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mfyy7ABgLIOBzrCxZBSQa0QEi/0xk0N5ro+4zgbAOu3vezLD9vzj/zFksfxekWiKqc058fYlw7vXhx0I2AQNOBA+IIbt9xnoNcfG1tWDhZtNTK8D6u+khx0PSR412rmrwBbSLjmlWtzc3KOnVJ5Lr3qM7d93UVBat8o9JDqFBoIwgBDG0/WBRLsIU6y1tWL+D6NoDbbx1PWz+3ps2Lep4vquGkQ/nxUdvrZfE0Ea/N7/3edJXFA9kEPFWbFjh2nfS+kpV2KqEkgY8gqtFpJt9adbr7QZZnXWskNBoa+OsILVIzAgpF3g2RLJODGPO9E1K54OMynHGBLTjeCTsGehXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpWn8KDQgsMQWO3SFB0gik/8J8ue1W4N63N/fJsS3qE=;
 b=mlbjfVAcWrfvQCT/JrmoK2U4nK62L5x+g91V8iMo+UaFAjOFq1SnbIqkzLipdkiIVoAmNGohVAuQjipfDmO7Nvtat+UNlKlgNNT81wRWikZprVUqgZFhJKctqLhKq8EBUwzSpGygZ8jxCaHPu9dqRfubpEwvMqC/nDehX9Q6sKyQkwQcJO29+8KNvVVKyI47DuT50mD9esjMB6SAXq2Bwz9rASu7EMM21883mXuSVCd+OKQTnwMIsg/4mfRE2gywiZU4h87tf5R1KS9IjsO602XtzK0B1kDefTxeN09jCBpNQFFYTRSQmLZNAWm8/gbPzIp5TD0POCPDdz+tDf6/ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpWn8KDQgsMQWO3SFB0gik/8J8ue1W4N63N/fJsS3qE=;
 b=2NZm30Gv3vcoXaX0cQGlJKi+sInzSo1yXPOQhwfDtEz3wLvkCusAo8ZlD6F4Q9yOu5TplH3LP1B5PDiMks72Ufv6YJXZDPq0FKAVFPlxl+zs5ogUsAZvmPFhcp6nHzQX88ObgPdflw7vK5O/b07UALG1V6R/BNwxAaD2lYP4e6o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 19:27:29 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 19:27:29 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: [PATCH v2 2/3] KVM: x86: Handle the case of 5-level shadow page table
Date:   Sun,  8 Aug 2021 14:26:57 -0500
Message-Id: <20210808192658.2923641-3-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210808192658.2923641-1-wei.huang2@amd.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:806:122::8) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN7PR04CA0093.namprd04.prod.outlook.com (2603:10b6:806:122::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 19:27:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc09662f-8f72-4cfa-73cd-08d95aa28fc1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14340FF1A9206D80F3DD9AC5CFF59@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kuhehwHRsHF0bb3QicaD7WaJz45yIduStSk58cz7pI67K7JlOkRBLwEbnkbcsOlrSQerlS8by59RTyAyIlOxt1o6HBoE6sRrmriu+Qi8T1zkxZkkcyFwVdGpbounaSEQcPSTOoC6LzdwMDZSze3TuIDQwNk30zT3NAK3mbv87b76lrnp5VQLNbSHaXUjJ7HZFD8a21+DCqBeHlvirxc+FcRnrmA2Rj5SKpltHWhywErqzk+64KWcVNp2QPJAZdnHGb3FIjXNqnmmAVQd71WSoRzbG7455bwRWw/ltkFygCfzNEY2NncC37eIJPplHGprywR9ZK/VKIzJuVeU5IMNbEt6GUal+RHDueaJUpAhlnvGyapQ5mX6Ca7amvAc5nlKPc76dkSfXR/ev6fw+WV4RChulPVwixsuN6WoZ7kHhs1P6e3HG4WXXeiXd9iSD2ePUwfE3c1R3p6w37oDcQ76i4NX8KjTDoGuKmQh3BPSsJWFgq1oMr3LPVN/anDGQAlvyZiyhuw9R2jUQAcXLsmIIBHn3LT9o3F6XvhS1g//p9PMbixQZrE+7eZd40uOPMhyHc3cV1blfPAjecuGAfwGwuNBr8jh08y3mWcS182NtSVH63seH56+RPrG6yGXFG1sdsmktcuhzwUtRMDQhfAf9G6tghgkOrLikpxLhE77WE9qTVln91eDGnoWHdxeMGXHErHrUrB2fEpeIfdeUSTTUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(6666004)(186003)(86362001)(83380400001)(4326008)(7416002)(6916009)(5660300002)(1076003)(8676002)(38350700002)(38100700002)(8936002)(66946007)(2616005)(66556008)(66476007)(52116002)(7696005)(956004)(2906002)(316002)(478600001)(6486002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ZbW+jVhIH+0lL3UgzdbCFVG0r46BTLsmZrxyPhyxiFhLYJJbVHbUIJ7p3lJ?=
 =?us-ascii?Q?SUqsnb+ieHmfJK6Utwb4vevpGEpUQcDJPzxcFOzYSdK8/RCOdWXWoTHZk3ME?=
 =?us-ascii?Q?/u/L5h/y4Xsh/MyVofdLd4x7rMBMGUXver21oFl5PiB4bQNTQUaowlA8MQ4v?=
 =?us-ascii?Q?/FuR3WtDgVsDXazAROnek17/t/gjlE6gPOKoUXs4WrpnX6QyJxmCmQEWNonz?=
 =?us-ascii?Q?h3G5Q2CmGC1l1SOpiaj1Z6tJ2ZaDc1DmJTZH91q2us4eqvnesfUP1jjiyKI5?=
 =?us-ascii?Q?cHtWXOaQJ4UC/F5d2TL0r3s9L56OVRewiSG7JJdA+ooa3zVRV4hZ2pHdC58k?=
 =?us-ascii?Q?sCtFefASm5DTAW3lBsluMv9ScGRTYQfCxXXzWzJFEqbhqBF3ieR0hEGvXrOa?=
 =?us-ascii?Q?Ub3oEEhGhFT93j8uojMhn1jGUrkyN1YQdklBPzjBq3PYTyuMpt5P2r2M/l5y?=
 =?us-ascii?Q?Bpz1ZPqMnOIrfT1exoenRIdRLpJgNnZJTkPdv5qOIgj4RKlDZ/k9eZ63vaHC?=
 =?us-ascii?Q?q9LcwYCiIbFPTtIvvHbeNyg+ig6vlsb4nGGxZhxSINgT9OYcHZO0ZG/XDZr8?=
 =?us-ascii?Q?yWC/G62NI8kKLC7YAlGUwJoHmmZXF0JkwXQAOQ4cKjMIggTaPUcZh1tg/d0r?=
 =?us-ascii?Q?9H53/G6H7rIYT4hX0iBvCPFGeHaEziIJ74TBGpN+TL2eLVVv675HqjZJkc39?=
 =?us-ascii?Q?1+tmsM0b4/MOGBiVTEhqeVuGr2nR23fFHNiEcA0e1wGK0enTkaqpFO7PyigY?=
 =?us-ascii?Q?bOU9oCQeT8AsSsIiUkHiLHnbUMgpihhhqap3QtSKTSX2mg1KlrgVM7KfIkMg?=
 =?us-ascii?Q?+AZOxs1LJknXqUvnzWGke5zLqql6072VzOxrJCT4I1h4ra7eCVIgm75OgVaO?=
 =?us-ascii?Q?HPyOhOULkoUorvn5gn1tMalGNTAx8OBat7SYZ6v8KE+G+9UhRxE51Kh1sInW?=
 =?us-ascii?Q?fkJRHMZt9yxkdEcGDnGsFFXkMu2+vjeohPxRuy/keG/gHZqf7n0K9cuA+JWy?=
 =?us-ascii?Q?0gI6/w2LqQwv8zHiyEGjlTYGF0o/5p93bmKL1/2VDYP0pxJCkRdnuiOcsymP?=
 =?us-ascii?Q?xhD1HLGzcIPg5iq7dD2/6Zbd17A/XzBjIXmmjzKG2KxyBmjnYTGwz5F7Sdm/?=
 =?us-ascii?Q?s4CZK1JjJcW3SLBO9WneLDSfMZUAEeukk+jfW+8uFhHiv2lE1Xccn8Zn2cA/?=
 =?us-ascii?Q?4DwUH2hlTafJ2W43yW1pMoUVhzHfwendvwu6s9Ge0VM0adNsJaINWiMUr+cV?=
 =?us-ascii?Q?g/L+NS3NkxaHr2yfZrUpYw8ztKL9op9aTHjNC1QZdnjGeEqDsy61Yu8fVmxy?=
 =?us-ascii?Q?yuarEj/6xaO95dJpS+B6CK7r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc09662f-8f72-4cfa-73cd-08d95aa28fc1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 19:27:29.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2Fhjr4+allgNt1ChR8hEjIP10umz8dpsHxPvnquXVEQ6P2WZs0mBi9f3Jux/FbK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
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
 arch/x86/kvm/mmu/mmu.c          | 48 +++++++++++++++++++++------------
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d16f75cc8da..5d66a94ca428 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -447,6 +447,7 @@ struct kvm_mmu {
 
 	u64 *pae_root;
 	u64 *pml4_root;
+	u64 *pml5_root;
 
 	/*
 	 * check zero bits on shadow page table entries, these
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c11ee4531f6d..9985488c9524 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3430,7 +3430,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
@@ -3457,10 +3457,19 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	/*
+	 * Depending on the shadow_root_level, build the root_hpa table by
+	 * chaining either pml5->pml4->pae or pml4->pae.
+	 */
+	mmu->root_hpa = __pa(mmu->pae_root);
+	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+		mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
 		mmu->root_hpa = __pa(mmu->pml4_root);
-	else
-		mmu->root_hpa = __pa(mmu->pae_root);
+	}
+	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
+		mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
+		mmu->root_hpa = __pa(mmu->pml5_root);
+	}
 
 set_root_pgd:
 	mmu->root_pgd = root_pgd;
@@ -3473,7 +3482,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 *pml4_root, *pae_root;
+	u64 *pml5_root, *pml4_root, *pae_root;
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3485,21 +3494,15 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
 		return 0;
 
-	/*
-	 * This mess only works with 4-level paging and needs to be updated to
-	 * work with 5-level paging.
-	 */
-	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
-		return -EIO;
-
-	if (mmu->pae_root && mmu->pml4_root)
+	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
 		return 0;
 
 	/*
 	 * The special roots should always be allocated in concert.  Yell and
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
+	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
+			 mmu->pml5_root))
 		return -EIO;
 
 	/*
@@ -3511,15 +3514,25 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pml4_root) {
-		free_page((unsigned long)pae_root);
-		return -ENOMEM;
+	if (!pml4_root)
+		goto err_pml4;
+
+	if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
+		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!pml5_root)
+			goto err_pml5;
 	}
 
 	mmu->pae_root = pae_root;
 	mmu->pml4_root = pml4_root;
+	mmu->pml5_root = pml5_root;
 
 	return 0;
+err_pml5:
+	free_page((unsigned long)pml4_root);
+err_pml4:
+	free_page((unsigned long)pae_root);
+	return -ENOMEM;
 }
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -5338,6 +5351,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->pml4_root);
+	free_page((unsigned long)mmu->pml5_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.31.1

