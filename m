Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E323E3C82
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 21:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhHHT1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 15:27:40 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:51329
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhHHT1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 15:27:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgIWzAm/c4OIcu8v9jS/esg6XiEatfhLNAFcpKX+lbZCJlKgcz232BRzMX4s+I/SzDCbsxAn10Vs1LlehVQ29Ifc8gorBZDN3JGA4hSTyc3D8VKghfkCijzC55jHbNGYBbu96P26TsvdB6/z16af1ZX5T8UXdpHWYOAQtO+mtBG+hQo6tqPc5cH0EPIhljS7IYeA/HQnXAgJS7nsCwP1Xrq5c5F6PhKfUOlc3GEzUs/DEROslz/aKJ2Ll1aG44wUmeSbqB0owdenQ5rDZejiCMC59VJXy9hGXeXxZM6MLlGiFxmp0RWX9/y8mE5b0CSDBU+KlzazTtjtxsprW2E72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRiocPb7W5RqICT9XtJfGEw5d/H/fAdhW0nsD6tdI6U=;
 b=NO+rUrkEJrzfXO9DQnsgVXJ/91aE3Rc1EW9qqcc1wOUHPn7Tv4hNUKnzuREPOV8r3mR9cUtTJN0eLyHVRSpc7No+TqzEunLRPUrAS4+iTmfLdvDmYUvlMRcFGuB5HyA+1NeAUD8BhuiQCtd166DOatX1djgBLWSShsly6ug80+dMpYgo2napF7ldK1xNtQXhjfLcU6t1W5cxYzRtK+uHOAZsiKUkuXPlONpgWey0HRFEyO+z8KTHpJ8hxW1S7LVU7l4+LVbeRvZW0zZ5Xq35p7jRbiCKKWqf8d8T6nY4CyUUfIjeQnzDAw/J1jBS8oZj/lcihtgcXfs+Qm1Vbl451g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRiocPb7W5RqICT9XtJfGEw5d/H/fAdhW0nsD6tdI6U=;
 b=2a4Ln5rzI13aQ7OFc2VUI3Umwlxc+VKlQM+MhzHXg2RlDQF+4mBeI/E+qFwYQ8FOiyhiPwcgdm0IWVdDwteX8vdoDhIa4I+ASgrcnkfuZxI5Rs8dIoifJIU0B7j4PBXqyJJKkywjMw8zCnIGeiMIQp2EB9jIfG08ge4Qqbw8WcA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 19:27:17 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 19:27:17 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP level
Date:   Sun,  8 Aug 2021 14:26:56 -0500
Message-Id: <20210808192658.2923641-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210808192658.2923641-1-wei.huang2@amd.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN1PR12CA0057.namprd12.prod.outlook.com (2603:10b6:802:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 19:27:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c60caf61-6a3e-4fb7-22cd-08d95aa288a5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB143483EEA42DA393655F44EACFF59@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBdUgeiaN+RfLO83nHsmQS/emPzSDYewip9GasxR7RbObtYlgmfFxelRIEDpvjGFEysRtcVLG6QLqJu4iLPFg+NDs2np2GBG5As1g6aWLFjr3tuHvg8oAVuuSbl1dzsTVjscX5m+fj4FDJUkcVgFsFeSX9iMYhBLKiZxVZtZH8pbfjbnXft1Fj8iGh4CfLxHeNP2VtZ+HAMke6uYWW4kb7WigbkB/66MnI++5zqyhEAq0IORcV8Jz8fgP9Ynu/faUFT83okNCbTlb4ZlT5n2K10UsSbCGJ4Q38BgvwWZacA6f/goRnL3kbVxSB9o+ogrIfmGhpvhLeZcA3eomO43o/1XAH5XV7FLRuUGsLBHC5igkNFEr8STbb5n4ChbU9GgOAitoS06kDEYQkj2if4LZFieGv21nbvAKhEmtrZzg1hpLlb/ZmF2fWvVPzolS73UWQ6z/STt89Be4E4ZjQbSboeahCEY2Gx3jqQ//cjjyYQLU+uMnv1hhcrmPijtGzhfi4WMbEENkDP3vHsqvLEvq82zsJsPKFR5ZLh+8cheB82VDH7Sf8RGeX75N+mGLlZN1XcQ9RmBNFHuZaUdz5IfntqZ+ehkK08Cj68dCZBxbuZh/p3WLhVrfCns4w9ao/eZE6AY/Fb3s8+S8Gtrt2oGN/SAsjfD9K0KyWEaA16G6S3n/lIhPk8PqCHFyYIh4Ai0kfxS4GBJOlQGXzxdjC43Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(6666004)(186003)(86362001)(83380400001)(4326008)(7416002)(6916009)(5660300002)(1076003)(8676002)(38350700002)(38100700002)(8936002)(66946007)(2616005)(66556008)(66476007)(52116002)(7696005)(956004)(2906002)(316002)(478600001)(6486002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ye+Zwbkz3mGrP6fter3q46kbRizCrfkl0++ARO4Vu5Mny7Kf0nRZiRZzDTaO?=
 =?us-ascii?Q?DwBNQ2GgsaLrZhU4mEMVz5b6qcMYl6nMQkclTY4nv/TqrULSET/jqFi7JoaF?=
 =?us-ascii?Q?DdYaLyqvZX9r/+5aLf/ghbZTXxEnw65HpjGPYhT1oh+piqs1+HPlLHe6eDw7?=
 =?us-ascii?Q?6kffIwTtsj2ey8vbJncTryw3kar8MRFwKuLWhvBsjx1nJhTcynRvgVzpBhU5?=
 =?us-ascii?Q?yER+vxiZet7XCnG7pN2RsjI9cJRJSv9ynLo6Fcu64SPZySwvlLC3MGYS/7mE?=
 =?us-ascii?Q?0GOSoKLqqI1kvDB8PNs9GHsS4/nIdmm5Yu41AueS8NcH5EwVj6CW/JQeb1Qs?=
 =?us-ascii?Q?wWjGLtinZgnN5gx84/LBPE1IgKsWksPNkC15kSq57DFSJDL7c361RDzZmqH4?=
 =?us-ascii?Q?BuhZju5ykdPq2WOJaUOtb644kpY5JrbUlP4tSTnHtoslVGkv6q0PJywL2K2v?=
 =?us-ascii?Q?m7R7aiZzDAsmpqvku4ZxQUtt6c7i5+J6O/W5ET6stlEJgeOxivXkC/2F5LY6?=
 =?us-ascii?Q?eRryoMjKdOHzYkZhALoAVq8kcLz0tujXH4gbfdxdfNX87W7y59SdrZxZJ6QU?=
 =?us-ascii?Q?3Ox+Xmt3YF82ZeJlermU65i0s8YAWuv3pIJqP4KDbSR9CXImX487k0E13jAX?=
 =?us-ascii?Q?hMIVLSDPPuIh/LMKip/OpMids/WY4heZMl1HKoj5LQORbE6hJyv6k0JmRgWF?=
 =?us-ascii?Q?Q79EvaXhl3daRbdPu2h/IG46lMaNJfETgm0d/94RRrEoLzubn8RiPNhcBCys?=
 =?us-ascii?Q?wpzOI/yghp3zDCt4drMhjwN916LIATI64GONdh38D8g5RTQelOpeUysJyK5I?=
 =?us-ascii?Q?YOC/b4sB7aXtqFY1spbzFjoqxS2tCvN+4RnGq0gAX2Ct8lAeY/8N2IxrRTeL?=
 =?us-ascii?Q?s6r3S6LLOEwFEBrqk5qHOirDdbFOx+DwQUVirtKE6hBD9H3pWHAuDiA28qfK?=
 =?us-ascii?Q?DW9trZXs5sGUE/g+HdqSiRJkCj0uwgCOGetMeO8uG+gmVzxL62cNztualZ+z?=
 =?us-ascii?Q?wue/E1FswFPZJwBb12eCV/a4nwQcrX9dVe2L3tb8bcOS7zM8TRPlHHSOg3uR?=
 =?us-ascii?Q?oIXsyWXvNO7MR/hw/GrB9B7x/+4O9xl/Br5ruC5su+LlRivL1p8HTJ46o8FP?=
 =?us-ascii?Q?vm06MIIVFhlyklGaZHxoZWIgpLbM++mDC3DbzZTuCZOyEraYFPzlj1oZ41HB?=
 =?us-ascii?Q?F6zZHvB7OuIjx610I+h7JR2j2ZWNr8ZhFCgcMtEKwz4uNPv34GVr8D/0YW+G?=
 =?us-ascii?Q?NSVypNQJ/nkzuZ96gW7hpGvxp7X24S9dqxEdOCDPUQxAo01U3NSb7CzgfqUf?=
 =?us-ascii?Q?0X8lMu5RQ62P0B+l6UxTM9OB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60caf61-6a3e-4fb7-22cd-08d95aa288a5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 19:27:17.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujFbqg8906HZQ7s8QMjPPwm74n505EZ8CfTo6jcRUHJgkX0aO8wTAf0bEiPeiE6A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.
To prevent kvm_mmu_get_tdp_level() from incorrectly changing NPT level
on behalf of CPUs, add a new parameter in kvm_configure_mmu() to force
a fixed TDP level.

Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++---
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++--
 arch/x86/kvm/svm/svm.c          |  4 +++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..6d16f75cc8da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
-	int max_tdp_level;
 
 	/* emulate context */
 
@@ -1747,8 +1746,8 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-		       int tdp_huge_page_level);
+void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
+		       int tdp_max_root_level, int tdp_huge_page_level);
 
 static inline u16 kvm_read_ldt(void)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 66f7f5bc3482..c11ee4531f6d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 bool tdp_enabled = false;
 
 static int max_huge_page_level __read_mostly;
+static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
 enum {
@@ -4562,6 +4563,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
+	/* tdp_root_level is architecture forced level, use it if nonzero */
+	if (tdp_root_level)
+		return tdp_root_level;
+
 	/* Use 5-level TDP if and only if it's useful/necessary. */
 	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
 		return 4;
@@ -5253,10 +5258,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	 */
 }
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-		       int tdp_huge_page_level)
+void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
+		       int tdp_max_root_level, int tdp_huge_page_level)
 {
 	tdp_enabled = enable_tdp;
+	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e8ccab50ebf6..f361d466e18e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1015,7 +1015,9 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
+	/* Force VM NPT level equal to the host's max NPT level */
+	kvm_configure_mmu(npt_enabled, get_max_npt_level(),
+			  get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	/* Note, SEV setup consumes npt_enabled. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..034e1397c7d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7803,7 +7803,8 @@ static __init int hardware_setup(void)
 		ept_lpage_level = PG_LEVEL_2M;
 	else
 		ept_lpage_level = PG_LEVEL_4K;
-	kvm_configure_mmu(enable_ept, vmx_get_max_tdp_level(), ept_lpage_level);
+	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
+			  ept_lpage_level);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
-- 
2.31.1

