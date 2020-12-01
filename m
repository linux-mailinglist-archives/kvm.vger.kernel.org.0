Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A765F2C9449
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgLAAtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:49:25 -0500
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:43744
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731164AbgLAAtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:49:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asqgm/AptjJwV4Dq64WVra1R2ExJnIir6JFiwFfRt+gLuO/yRfEIcsPkrw6j9R91mpigKsKFNOK8ACGVeDhFugVwSGFL+Gjxh86rqzfANqWwelcvT5Krj2rA8qMB/kPJfu8p4i+nzf+epwx0jLiGcS2LPpilgZIoiYNLDMWBZw0IdPxRfckK4qGGwDOls4Q+kpyMBPxTZcTKp6FR2zSa5Uk8MVoDf0Sdt1fyN7Vztru3EAHLQzrupM81ejNeV9AOJEMmyClmI/YBoB2LaugdKjb805Moh5Tv9PFz86q6HbQiLYWbkpFOJr7KG+5k8dVEthdwb9W/w7fK5lRrd5AF7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfjTj73r9E1MDANZStvNQbw43ITNMT9SAbhg2D9G7rM=;
 b=McOkAYzSQa4+BNA1qK53cHI8Ej7hKv05ICS/zdUemgohElcvM9edqR4Br+eX0mtRLRA5TbPQfTHPw7WwEcBTDHHnU3Wratpo6ijdr5Rd33tH+kXDzlU2EAuzBHCzHB+pjwbBBlf33wDt7YxLmUTLyblP3aDY0qp/eFnK6zDdxZ1pOSDgJ7X5S22XJ+qlYGYT5fj1X8sfasioA2k7/cNgCPb7IVVP+RJrfI/+Oejn/bpcydEHWxxtsUq55hlXVz51NqSS88DuIa85hE3+To1DkwaU7wMF8ta9U3i9dkbrEHcmBdc95mAT8XFJrGN03LQosS36LYf+COMk+2cWodAqBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfjTj73r9E1MDANZStvNQbw43ITNMT9SAbhg2D9G7rM=;
 b=rG1n2D/ee+NApkXhjKbDddqKOtQknH/TCd6FscNtE7ShoqTNdvpNWykB/eQzdQzCzsDe0MTGUKQJ5Z7gn8pIhyfNnDCiO4BmuletyrySpOaInFaDHlki75qZinbZx8bW3sEq/rJ3RSJ9v4EAhYSTlncDIB8bF3BRb35wBMV90lo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 00:48:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:48:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 6/9] KVM: SVM: Add support for static allocation of unified Page Encryption Bitmap.
Date:   Tue,  1 Dec 2020 00:47:51 +0000
Message-Id: <b1a3224518020c7fd11375b45c2f8f09e257517a.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:806:6e::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR11CA0012.namprd11.prod.outlook.com (2603:10b6:806:6e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25 via Frontend Transport; Tue, 1 Dec 2020 00:48:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ef437d5-1839-481e-6c03-08d89592c11a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751A5D81E969699268601FC8EF40@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:267;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjbttJHemeR4BDnC72EURuHs/fGq3+LVqJ+n8BOkWCuWOZ/l1XMWibFVCeMqnaeaYSdPxGlTg+o+TR9StsUX09zvJZf527tgMh6Y7SPKWfJf5Wz4tvgcZjBnEfsiszm+KbfLeA93S9Lv48Bp8yN3bLKzcXreWFtmI+g2NggXKeYqjKqzmKBSq9bk/3tsZjfzNQtSjS90CeaZM1VK9dw4nN1nk1eAIz8mZjXXZZacJ250SXESVIb/QE/DapFMcKjmHm5jKIHBa3A9xmheQv3SGforF/OgEEKw1+HvJEvvvnxZ3ot0KUd4KXkBW++vqhlRsjVMGzwP8HxxEtaoJMerTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(83380400001)(6666004)(186003)(2616005)(6916009)(478600001)(4326008)(316002)(16526019)(52116002)(956004)(26005)(6486002)(7696005)(8936002)(8676002)(7416002)(86362001)(66946007)(66476007)(5660300002)(66556008)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xj2rIJApgHTvIYRoEqD1wP3r8UeVnzX5BkYNrWhg/g+No7enA2ZrP4mX1CuL?=
 =?us-ascii?Q?F28XYCJ86UpgSk98qsdpGDgiKAwoOKGjEZSVwGR57kEiRvS+TYDkUgTKKEsa?=
 =?us-ascii?Q?mLRJRy3i4u9quYXCoPOH6YFUCaW6Y+ONGbE9GfKt8rnl4UsCHkab+vEg6bOw?=
 =?us-ascii?Q?Ti/B+KGW7dCfTgDqsSwXRxRQUvs2/F5SiXIu29psaD/Wp0WebZpgVQKiO0h7?=
 =?us-ascii?Q?7acEkCDduLlAoALP2yXE2efHvt2zst8mNEsVGjhKM+kAkKxSwTvXg/qM8vXk?=
 =?us-ascii?Q?3M+I0bEL5fYiMP/qzXpVD++dFV78SBf8PYcsfhL6pRt6PxIuKQPaEQrIe+pl?=
 =?us-ascii?Q?rujll9LUgW8o9TPAkV+93QOQFauc5f/h60y5sNCYbdP9j1yDnxuMfmXJlP4r?=
 =?us-ascii?Q?KTluONlrwnhnhyCqp9LiwHHE9vFSA4N1hd30dqn17BH9PhmdkAQnSJXbVxuw?=
 =?us-ascii?Q?gs7e2TsE7AXNoAH4yL+xQwUxdwC9LMkV6N80TWxZEoMf1zXty0NPhOsKviw7?=
 =?us-ascii?Q?zQjH85NWRdQWxJbVNabNmjgMtHjDBWmWwkUBG+Ua+uqkeWOHZ+elParmKrQe?=
 =?us-ascii?Q?o1v1dQeUC6515Gd3ryl6yOVpt3/Bi3/XIfEIA5ic0rN6549Nziv2tBDKQbOC?=
 =?us-ascii?Q?8tRvWAcx1e0wrOTZO834m23BSOVWt51Oe6E3cakHpfbtHdpbFPloLThuz2Cb?=
 =?us-ascii?Q?Wuqyc043D29gn60gsMRXSYcWWoqjNJ8uqwtkiFFw3MWUGyazTWO5L0gW0ZBj?=
 =?us-ascii?Q?2f5ZOZ+PhyOMXCU9p26q2zlitr4vygLTPbWHzP81LI9OzHE1gQg2V9JhiJoC?=
 =?us-ascii?Q?o42f5khDK8QqIlKN/hzwg90FBEwL0JR20I+VthUyMMUnesUUIrCi2eQtIA9T?=
 =?us-ascii?Q?HaHd8UoFUwo5STfKpG6FuRuWy8R0nM/q9zRoE68EsK/So4u6ioiAv821VL74?=
 =?us-ascii?Q?/BZMantuig4fj3+W5n3mwsS1TOzgxH+62BqLYzdajsdz5/XB+qwhBctlYac+?=
 =?us-ascii?Q?9l+S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef437d5-1839-481e-6c03-08d89592c11a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:48:01.1672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkP6LrbMgRoKBAlV04DWO51ndBsIbP6lOsotfo5MSMbePEStHiBsIFkIJ6f7QUP+2nAclPk1068GAmbpNaDYAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add support for static allocation of the unified Page encryption bitmap by
extending kvm_arch_commit_memory_region() callack to add svm specific x86_ops
which can read the userspace provided memory region/memslots and calculate
the amount of guest RAM managed by the KVM and grow the bitmap based
on that information, i.e. the highest guest PA that is mapped by a memslot.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 35 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              |  5 +++++
 5 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 352ebc576036..91fc22d793e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1282,6 +1282,7 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	void (*commit_memory_region)(struct kvm *kvm, enum kvm_mr_change change);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e99ea9c711de..8b089cef1eba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -957,6 +957,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
 	return 0;
 }
 
+void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	gfn_t start, end = 0;
+
+	spin_lock(&kvm->mmu_lock);
+	if (change == KVM_MR_CREATE) {
+		slots = kvm_memslots(kvm);
+		kvm_for_each_memslot(memslot, slots) {
+			start = memslot->base_gfn;
+			end = memslot->base_gfn + memslot->npages;
+			/*
+			 * KVM memslots is a sorted list, starting with
+			 * the highest mapped guest PA, so pick the topmost
+			 * valid guest PA.
+			 */
+			if (memslot->npages)
+				break;
+		}
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (end) {
+		/*
+		 * NORE: This callback is invoked in vm ioctl
+		 * set_user_memory_region, hence we can use a
+		 * mutex here.
+		 */
+		mutex_lock(&kvm->lock);
+		sev_resize_page_enc_bitmap(kvm, end);
+		mutex_unlock(&kvm->lock);
+	}
+}
+
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6ebdf20773ea..7aa7858c8209 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4313,6 +4313,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.msr_filter_changed = svm_msr_filter_changed,
 
+	.commit_memory_region = svm_commit_memory_region,
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2268c0ab650b..5a4656bad681 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -415,6 +415,7 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3cf64a94004f..c1acbd397b50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10717,6 +10717,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	/* Free the arrays associated with the old memslot. */
 	if (change == KVM_MR_MOVE)
 		kvm_arch_free_memslot(kvm, old);
+
+	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
+		if (kvm_x86_ops.commit_memory_region)
+			kvm_x86_ops.commit_memory_region(kvm, change);
+	}
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
2.17.1

