Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE53F09A9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhHRQ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:56:46 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:24294
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231247AbhHRQ4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d58CBrMtBzsS+qtJ3/mAfUaPQIi48WcBpTZoesIrmdH47Tbkb2AaymfFRXyawdMykT6OFYZYRgNl36SdTlc11uPMefYWaq97pJMADm29GJRmOjwK9jNn/X2RKkjW9X9QO4N5QjbSt9cjdHLpezn/Nh6pnC5n6QESWXZXuq5DPhqXYHR67rVXMtLV/F4WFgQX97gYQoiToetiYt+Q6S1wRbkZ29XvHoYgb7tqm23lkBw2eyojm5CNuqqVzqPULFVkbulHY2IPDL3uwGqT+8lI3oA7Y4N5UDueV6RUtOb2ADRfEsXvv+DeUYZ/An4TYCzQ/YuPMx1V1qZ5WHAgrcIq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7Sylc3su9Sjow4qcqsgtoLrCn1GQji6RrIs/BRi41I=;
 b=ci52fQ8RUN9TARt+93mPSnqwh6hhwwTBnrs1HLwx7QcqP9vfI9fcOex4ma5H1kjOCEZG4IPgjZwjhKrax8pUJc4Qn56+kG5TR/Llj6tIF5o87cAsJrYKYfAz+RdLgRQRtReKQ7Sa0jpFSk+vkWD5x+R4UHVcVeTMoemZI47IVBQPgtHwfMrhKLxW8yhZaOhD2ddrJ4ayHcjl2IcuuVyeVOMGTexKnMvSHvWH5DOalXCc0s2wx0hy1OIaD/oqdwr4L7rlJdQkEA0hV6g4GXPLOhrhhKxeqCeztt0KwdsNP0Xq7HhdS40r57M+n/M2wVQzp2zwW+62PcFMJ0SAcCz8jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7Sylc3su9Sjow4qcqsgtoLrCn1GQji6RrIs/BRi41I=;
 b=2usfgmX8WFCqn2nNOUqAmY3sorRteaXFS8X6oDVUTnYuNEZBYsYx4KemGhi8/H7IKpt5Nziwzan2nkNeNzrpuv/G63T/4ybd3jSormv9yJDx/X1EwXmeodBS7R2QkeHLtRgSo/cJvBGJKGz5hyZDectDV7cUi3rO1uJxS6pLa80=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 16:56:08 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 16:56:08 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v3 1/3] KVM: x86: Allow CPU to force vendor-specific TDP level
Date:   Wed, 18 Aug 2021 11:55:47 -0500
Message-Id: <20210818165549.3771014-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818165549.3771014-1-wei.huang2@amd.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0047.namprd05.prod.outlook.com
 (2603:10b6:803:41::24) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN4PR0501CA0047.namprd05.prod.outlook.com (2603:10b6:803:41::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.11 via Frontend Transport; Wed, 18 Aug 2021 16:56:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8059fa95-bfba-4e4b-2f09-08d962691315
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB248789DD98D930F409FCDF9FCFFF9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MtRLF/75jJL4MHf1NVx2ae31b9RoBDRi5NolidcZExEaEwwTvYfiF2BVEl761KtYfA1BTzBxJGvW+Urp6XAcr/2RmcAtL51MNVrhXrpXJ6vIlMMGgpwqnf/avVMrqVjs5aWcp/kO8Iv3TpCLxrrIswVXF58KdIGXwIXas8com4oCcHl9VCznCJKAB2xc4UCA8MbqMtMRoFdWrhrxrLPRMmKPSkG7De+6DAZoX0sQx7yk3a+Ym/Pp686gFLvBEWx8XAM3rQgqOBte6zlwJjFMpfoATDtXVgYqTJuZDeGgUsQcHGB6BAUN1VgowgmYH8x+cwg9DWV77y9R/Esc7DlNFsen5sqwSptbcD0WsbyLeKwwUaegS0rX3G6L8fUbNSE3QARqJhm9M5kx0NpitmJMgSRgY0ay6u8OJnKmVv+iXdlm7M4YUZxenkg4ZJLdnYzTMv3LF0YOqqFbGr5gMmnvu02zI9CyuPP7qZ86qZBLiycXabMdeY4rJvb65idU/U0yLpjvcBJ4IbwjNbdcGZpUXNnrEWHhh8Cv6FPqfYdoal/JT2jRqJ0UbmtxU6jJUyyGuqbiKjnlsiqKj8jIgjKyk76xdmDCiL3Hunz0s6t29Ptq9y+p2gf2t9hl2evedBRaGLHDQc5xYlZp9qjpZ5tN1P2GECrprIBvAz1bTq4vetshg23my0CZE1PZjjjg87DFHcRJ3bCQ8fVOUnhJ9M6ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(478600001)(26005)(38350700002)(52116002)(66946007)(66556008)(66476007)(7696005)(4326008)(6486002)(38100700002)(2906002)(6916009)(6666004)(36756003)(83380400001)(2616005)(1076003)(956004)(8676002)(8936002)(7416002)(86362001)(316002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?flnl8yz9N8zMpy4shYgTWlQ/tMQ76XSwLdVeGkfSBHzkLIszkgU6VtpwrE4g?=
 =?us-ascii?Q?wpP8ANKkcN9LwHLjYW3tCVcCdcqYdTfXhd5BVSTqxEENua6wEnrhaMyHnBHw?=
 =?us-ascii?Q?kqHSyZTBs/U39rkJ+Rtc1HL5yTWVSjQfoXYbUcJSfIW6vPgFArKWvVOK8qfm?=
 =?us-ascii?Q?Q9l+w9Ggy+27EWdLJEMKe0EsnEFzBoVy6ms9frtbfT+JqvdhMFWtO3X7LN45?=
 =?us-ascii?Q?Qse1jTCbeg6ntYv3l3bfStB5YOHl7740A81J+c0Eb6J1IpEihAeKwtE6ifyj?=
 =?us-ascii?Q?CoRnGKhqQAZIqAAjSp844NpaTRAYeps98Yx+pPoYzE0JSLEs6zwFA7j753mp?=
 =?us-ascii?Q?E9wEFKTMvny91G40G2Cu2dfnuRu7T6mZgdXKRoBzOePjtgw8cxn2dn+Y0hCl?=
 =?us-ascii?Q?vsYEzGnPXHIb5uPVutTOT0lkAhVtDqwQp8MxPVKRv0knbVzrheVrPD9Ld7lv?=
 =?us-ascii?Q?8DJ50EmlLSBV7uBGKfRQ0iItDvQocfhiOFBexouIB3fg1qIgNziPVCaCQ9zo?=
 =?us-ascii?Q?7SZeQL4tw7cJGOJYvNwmE/iANOWaw/fCap4lKT3O0ce+tbsyj2HHoLCQhgBm?=
 =?us-ascii?Q?PNlBxwYVgVDKsGcByZzwXgkjnR91Ka1SutwM9CsJl+GsrPrdhFVRY6SMI0JR?=
 =?us-ascii?Q?MKzN06129J4rrbi8Kxiuss42GqBcOoOnUOGQjoAixavQ1yBQ65IiNWi6eQke?=
 =?us-ascii?Q?3BS3BenPkBm28sGGKSK+3gouDmSKYr16tQDgjsmTci+Ps+EbFRTDzixkDV7S?=
 =?us-ascii?Q?oReP7yDSEpNgF+GxflMWNZdqsGJ6jRMUETajsUnBk5AStdHLfJse6LwG1sX2?=
 =?us-ascii?Q?mYiAjcWM1/4xt+ECURL/OpqYPgYIvydqbxnwoEuV2urG4E74kW0fsczxYwVU?=
 =?us-ascii?Q?yEXlXmLJX21zg/Ri84i9rhbyVxGIMeDwYIMGktw1NEQ+mMXJjrV18wdzdfc4?=
 =?us-ascii?Q?s5FFsvVHGoxKH3shUBwIClFAfHuUJkBOxVw2EzfCtSe41buxalKI+Kh7//5V?=
 =?us-ascii?Q?CRjLYIvx5Gxlek9gEIzHuUUM8wuFVLKRM3oPCrBNFXWqBL5OSa7VpAvslNuq?=
 =?us-ascii?Q?xkAxv1gbjWT4XBaODQy7dUBa6CxL+o+Rdrmsy7Ybk5OZYoQhEWY+Lm1WDXAh?=
 =?us-ascii?Q?5t+xCqk9VzkdSUJBo/zo8HgLyTT/pA7qT2H9yLf0ZD8Om707yWw16QX8vgF8?=
 =?us-ascii?Q?Cos6SG4U3Hi3WB33CX8owV1Ta1ENc/hRqRVA6ctru9EhLYdrXLGzBBEVpTN3?=
 =?us-ascii?Q?dvxJeqA2v0+O559ub9faId0QYb66ubYWKe5pms/3dIf6hHwSz3wIjXYbci0G?=
 =?us-ascii?Q?nwOUomE7IWmq+TTX6jc43VaG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8059fa95-bfba-4e4b-2f09-08d962691315
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 16:56:08.3068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aghpXb5RXaXiqF9clYrtUAK244ZAyarZsUt+BR4w61Po1LpE5XbPMGXVHEArZ9sU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
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
index af6ce8d4c86a..9daa86aa5649 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
-	int max_tdp_level;
 
 	/* emulate context */
 
@@ -1754,8 +1753,8 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-		       int tdp_huge_page_level);
+void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
+		       int tdp_max_root_level, int tdp_huge_page_level);
 
 static inline u16 kvm_read_ldt(void)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47b765270239..14eac57bdaaa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 bool tdp_enabled = false;
 
 static int max_huge_page_level __read_mostly;
+static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
 enum {
@@ -4588,6 +4589,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
+	/* tdp_root_level is architecture forced level, use it if nonzero */
+	if (tdp_root_level)
+		return tdp_root_level;
+
 	/* Use 5-level TDP if and only if it's useful/necessary. */
 	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
 		return 4;
@@ -5279,10 +5284,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
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
index 69639f9624f5..b34840a2ffa7 100644
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

