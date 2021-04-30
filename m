Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B973536FAA0
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhD3Mlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:47 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:56448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232936AbhD3Mko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOWRCKDs4q4p/9IpVGoVoz7HJGNL08Uc2x27+SXIJ88rixuAsUsLgeV/sGlE2OzpTVF4S+RWlLaVHq/ise0MCt3w2bZDpKZ2hYL3U5HF7VL+mSTsYhBuX+6d6Akq0fxAD0T3uVvCZdq3BIFXXSIluOymN/wRNps+VSfDtABx2V04iMPZD4GfTX64prG0t0+gusWe6BgZTD4F4MfSpiI6fVPZ3jGkjckaZs3CGuvvDWNo+JtHqQPvtkp0Abi4qV2wmPkxnAHxvXg7iD8zvwaUUpWpIfFY571KQPPiMqLFv3MXsgvEtjGz0yBkRHjRg62sI3SxLwrL9Sg09d7OOjz2eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+orhr5GX3Q6RqGeyQHlODP8C6fwgfg9iszjhTmrz3OQ=;
 b=aOxfo9pPEOGcBN/JoeLJC6CCnp6+u2IzrlPvCLcOlzOVVzVeVyE88cOgUIM5dWlMdwAED/XWEV/L1h4rRU0AqsuZsIob+CVa6SmwLEMMat4ue+mXmi6fZEFJWdLxAiwriR3PUGfFlCHM1PL5fYiW4nXXHiGlfiBj0ASES6M7xIjOKKN1iM1b4Cnh9zQz+zJrmF9PTQ9tloPw8EkfLBQ/knYRkl/Z71LJE22FtTSX+6MbteUQNXWoKoBRFdx62YSFT6fzF2TpDsSrb7kzL3K4NBrakx8eKleyyfuDb2kM0dGK2bofsiIv7TJYqLaEW3cIg9ZyR55ilJKZCWdr2/qJkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+orhr5GX3Q6RqGeyQHlODP8C6fwgfg9iszjhTmrz3OQ=;
 b=b35HLcgywRKF7aS5ETny19OlIMJevyOI1ZphddnKpZD3DrMobN+is1FmDFY9PYltooKWphKOUqq84V0mZQBLLGGQnZq0x/yGB5tnMWiD/TkVbSViIlgG9Y8e0Loi8ZcfN541rUpNZ0qrbzmnl00Mi7dCG4zjuABUxmlxVMlYlYc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:15 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 28/37] KVM: X86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
Date:   Fri, 30 Apr 2021 07:38:13 -0500
Message-Id: <20210430123822.13825-29-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea22ed2c-2ec6-4395-ba42-08d90bd4f680
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2688F89646F1AAFEEDE773F0E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNqP4+eSVgcv+BVpwn3BXDF0QiV3F9vJv8VSt/cTBkol4cwq5ipC4gCcmYOcZ5+7VSsRtDDnVbulvL8zlvix0TiWapL94/fQrqzPsU5tW4Uaka0rHuXYeYMdreb/MN6sKk51jDMz2KbXws7C1AAKoeOzW1jU7dr4U3dgR2CMNXdGJhjBa5Uoln/QwcX7h5jQwrEAQFaw/X3CaOrKKyEjfXb6QWIHaH0JgmqQ1QwnwMQ8EzlmQYYLI+kfOIrkjX54E7OwuF0Uhf49CAMVJYu8x5+Xe2Pta5iGpTRm+a73in4bOrvwaIO4CjrnO/lL7MRT10nHTYumxjXDpUTQ2nJIOwU2a1xlx5Kskpb3VoIA+eHd40PwLv20wuaCOt6qYhdFIrYCaAIl0u0+Kz65Y0fqmwhP3tH9SOo6ekZXpw4wS9pPR1WLZUy9nf8RWcPXyl/2x8Fse6sgUESvf81aas+QkzriOhkAmBLFXThu6nRgoBn9CCu2PVqnz+z4xxisnUDFWYeiXzaTyp8nE/qROeFL6I0O+YbpH/QkAw2TL82vIFeie05sUkroTHYEgOQ18Bnw4gTHpFYc/z+5blHE11hXFMY22hknF8kB3V1KL/t0bP/d6j78J2CFhtD6KiE4jTqgx8KhbZoiOlkey9KWEk7lpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DSp62iNQIVzHpvBtXX38jsmUaBtoZw7Bk2nHeTdiU5GLosgeFScfK+BPTeMi?=
 =?us-ascii?Q?6giKZbgfP7Gm6zBzppBejlMYHUDy7UryooOeeYO+/k8OOkZD7os8uwX6cjeS?=
 =?us-ascii?Q?rJE9XAJYdzqICB3Hx73Ortsf8thibBD+LBqqfgxUczCiNlNKAGK5ozuX5AO1?=
 =?us-ascii?Q?jtZROrMB3rTa1AzLQSGss1ckPu77EXtNB/+TtpeIaW5XSJwF6onsUeN0ICDv?=
 =?us-ascii?Q?0/c3o16CbWWZYC3chIg2seENmz577tlCBhqDfJwGkGRgon17S0o/+M4YM0bE?=
 =?us-ascii?Q?aanSMQFtv0AAJnf8yy+WLZixa7Ub7AO8fU7H/mvhBPilwl2WZUHi4GVxrmsa?=
 =?us-ascii?Q?HO3Fa7gJGFO/KS7rFdf0i6NvGzHtZK3hRQB2/ccSbbuGHstCC44z48WqpxDJ?=
 =?us-ascii?Q?iUCuKGSXC6WHi1PozuxVgF1Qu/u6Vr2CMNNNyvcLP2J7SYODx41GQntHUr32?=
 =?us-ascii?Q?lVi1RLizg5hDHf+PvGVH0Uo6kxfUOqAcKoDJiIKejVkwTCjtGBxiOPxBpRMs?=
 =?us-ascii?Q?VUaGh5Jpzldy66wv8V3vlWSn3Q14mTo3uiOz54yX2emq7IkM7VDFc3o++bMo?=
 =?us-ascii?Q?KlePlYkaK/w5XZ2k1pAwnZDU/8AEPn/t02cxfBwuechak2M8d9jPbKp9jCL+?=
 =?us-ascii?Q?EM+a4383TC7RPAqyv/cxJFGO+Yt6rRoEMzFqjZPEOrr4eXO2J9PNJmzUpyey?=
 =?us-ascii?Q?98UQMCruJPwAMCq0fgwot0/WyGcqL6+2NeT8xLJ+IkuLJ0Epvg8w9yECAZqt?=
 =?us-ascii?Q?pHiTiBPz4thhI5sToz2KdEdHES6UNCkEppXuwr24JfwoYV1qspJlufMYROJY?=
 =?us-ascii?Q?4JlmMbPUREZXhgWF5GYTekuUmWeGKJacHzNza1IVkvuPTjNlEpfYJbNRIjAR?=
 =?us-ascii?Q?3tsdIUs6xNzYLzzZ6bZ5SOWznCf0Ety91/9KbU9vRTeWdrAXthyI68SvYtJN?=
 =?us-ascii?Q?0HBc06QqHPcmyrqyDrtsY9eGve57EpO65dp54ePXh/+vB3eo8jGaDevsVrCC?=
 =?us-ascii?Q?SYtw5uhopm7FbKbJbOGNrX4b1YJHcEwUD7sB2mjMiKgH4WzXIEmaVqEy6bM0?=
 =?us-ascii?Q?gdeBOePWpIZBsWgCtStxAV7Wr9+j01pz69yE7OeG4ExKPawIppYsCmkPWig0?=
 =?us-ascii?Q?KLSXxgnNsyNCtuIGwEn96wGVKgE7C55jESg3K6XDEVjE4+wKHuWUxEi2QGsa?=
 =?us-ascii?Q?4RPJXHnHRyClXkxFLD6O0wXK0yHaDvCpvNktnyNIkaHka1+RxTEqJ14hWNeS?=
 =?us-ascii?Q?SK5MIXZP3gnF84QeKHdW8QJLu+AOVozuWa5MAZRSuEOgP73LTx+lqrkdijGE?=
 =?us-ascii?Q?aZe1UzlLh8Gf+/hSVHSw6nHS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea22ed2c-2ec6-4395-ba42-08d90bd4f680
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:14.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cliChkMZfXHCCZkUlz22qC8PR6ZCK6hNl470PLYfoNmenkTXViQsEJMfedid77c63nqOQe+91JeQxD0j0K0sxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP VMs may call the page state change VMGEXIT to add the GPA
as private or shared in the RMP table. The page state change VMGEXIT
will contain the RMP page level to be used in the RMP entry. If the
page level between the TDP and RMP does not match then, it will result
in nested-page-fault (RMP violation).

The SEV-SNP VMGEXIT handler will use the kvm_mmu_get_tdp_walk() to get
the current page-level in the TDP for the given GPA and calculate a
workable page level. If a GPA is mapped as a 4K-page in the TDP, but
the guest requested to add the GPA as a 2M in the RMP entry then the
2M request will be broken into 4K-pages to keep the RMP and TDP
page-levels in sync.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 005ce139c97d..147e76ab1536 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,6 +115,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
 int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level);
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d150201cf10c..956bbc747167 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3862,6 +3862,35 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int m
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	int leaf, root;
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, &root);
+	else
+		leaf = get_walk(vcpu, gpa, sptes, &root);
+
+	if (unlikely(leaf < 0))
+		return false;
+
+	/* Check if the leaf SPTE is present */
+	if (!is_shadow_present_pte(sptes[leaf]))
+		return false;
+
+	*pfn = spte_to_pfn(sptes[leaf]);
+	if (leaf > PG_LEVEL_4K) {
+		u64 page_mask = KVM_PAGES_PER_HPAGE(leaf) - KVM_PAGES_PER_HPAGE(leaf - 1);
+		*pfn |= (gpa_to_gfn(gpa) & page_mask);
+	}
+
+	*level = leaf;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
-- 
2.17.1

