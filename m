Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6265C35D164
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhDLTq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:46:27 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:64737
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237515AbhDLTq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:46:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6cap3g4O9SZFpLBQ+AGHHQ2bC44H0W19fks0XPYhGHD02DmD92nELDJy5wom1OjukfEnAOfM09SL6oLDQB6GjhXcpdhkveFSurypHVqATlMdWbCMWBIZUGZRSo4GlRyEPtY0jgVSJnir4tCkIstJ8Es0lgaaSgeJKKi8bs/Rcvpbyw5Luxqx5fjGZ9zH/4onqb+ftjFHwPqRcHj/PBK/O6/vHooIhtsVoB9NtKNfkO/AFUl/4neBhR2Oao0sB8lIjzYfL4Qvvb1S2fnWPRJ1TuPKoPVlAMvVBeidY7oFGOFnBkHpomvLW0XTpZRPmENy11sfrvQ9P7GnhpBewqQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQn0+bSotS0+VZNtBbAJ47s7Za1zmwlIygtFu6yEZhg=;
 b=jEBP+PTWt+bhWi8eVuJ2zQsPdRMFV54cLcUu492yx4zISQmRD/oXfXAmQidMU4mlkmfsAPXJJ5gP5J74SI5UNl65u5V49jz9968ymcEjuoPuhajsCIiwUK8xMsn7jJWgWSjY5tcvNFA0b5JXxl70j5myhDTKEdAQ3ybV0pO5CaST9wsBhqrbQKZ5mL1xTiMMzW+ENRrI66axrgLvtSB0AqOmLsFl7ehfTQHZi3mEwko1ghjxQOvhn0VOORLxa3lC/7iZhd5wjqMDRNLabWQ/jHc3wJThyKcmcCUEVYSxxga/nttvaigg7WRaCZKyk2S6mvxxH/TyirssVFkS89h7Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQn0+bSotS0+VZNtBbAJ47s7Za1zmwlIygtFu6yEZhg=;
 b=PqgparjvADPwayhAg92ffC6XnKVKm+Rr+uW7iw0P1R2fhqqVu2j3vIvBWkEYO7o2CY/klx8t4UT85OlvPqh1tr0zXHBRQZs3fEbLAsvf2eAlPqqPsZi+XSDdAKGmTx9gfBgH+HGNgNn2v957WwB8aI4+ogxQK4QNvt9AC5MSKfg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2367.namprd12.prod.outlook.com (2603:10b6:802:26::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 19:46:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:46:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 10/13] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Mon, 12 Apr 2021 19:45:57 +0000
Message-Id: <3232806199b2f4b307d28f6fd4f756d487b4e482.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0185.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0185.namprd11.prod.outlook.com (2603:10b6:806:1bc::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.19 via Frontend Transport; Mon, 12 Apr 2021 19:46:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3312096b-1410-40e9-25ae-08d8fdeb9cc1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2367CBB6F489DE4410E50C228E709@SN1PR12MB2367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7v9qiNLnY5P4ZaqmbomOY0HAEZzV24cI16qLxv5mvC7aEW/gHGA+n0mKSuC2MT0XqMNPZRrs5MtflTmPp0DQmJmIKR47Bl7CjESuZTjIPszv5RodfrzNs4G/BcEFL2nQzrd/HdHDutsuPnCkDP5vDIbGblwar3xyNBrhNneXL98zROdGT6gsRORhGxUcZLISBgXZVfap+CnwWtTmLY1oEHraifFmGFFiw92TNoQ3qr+cie0GNOl4HrO9jTVBUeYLj4WM7j4TkxxQEYPJstGJ3h6j3DcSViEW01z0smeAOrk8woRthLjgXSmFHjHFbjD4dIG/O9af1exSKqlPHc5FHd4+C0Wf20LHHyHXjeZcl0yfniKsM2T4TJhxH6u/qd454ARLAudBHow4X3zmKYjMTX7F6KhIWUrcoieXsqNg92uG4nThmN9JTMOqn2LGZlpkekNR0+hyeIEdezf7Br3fN4nzeS8gRoZowcU7S5ZmAQ8u5DS/pC7FzYtEbeyjIoSz3ktQiUwU5gcUV8ag3yntlzveFN4clSWSqwFtZQvntUc1w/CzxWBQIILkLZv5hhg4y6tzHLvXUtBWkDOCOUg9JjVJw3UoNzxQY1rHLPKo3fESCig0IPJFMpfTJdHOpzIAmClEEY3HrtCV1z3mPdOq/K8lGipG77bvXkKAydvX4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(6666004)(36756003)(16526019)(7416002)(38100700002)(6916009)(956004)(38350700002)(2616005)(8676002)(8936002)(2906002)(26005)(478600001)(5660300002)(52116002)(86362001)(316002)(4326008)(83380400001)(66556008)(66476007)(186003)(6486002)(66946007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LhvKwSIg3kpWmnJWGhphmWiU5PoecXv2sY3/vVITPYAVWlw3Ape3/00pi/y4?=
 =?us-ascii?Q?M7TLlidcKMZhGOvtmDCmUvIALBi4Ap9aeLrVobKk3BYYjY/qRCXoLMH/9lwt?=
 =?us-ascii?Q?qkoWGWRkL5cKKr1inoOOw5lyq9swEi3YaANVwLFIt8suW40jwrCx16UBExZX?=
 =?us-ascii?Q?LugRjCS6tS5dCWd9t+YrPwunL18JnL5m2vQ//aedV9mcsARHttlgtmm9MZ/y?=
 =?us-ascii?Q?EEqzjAsXdx3vgf7tP0suLU09swYRpAZjfvhzHjpNcrdKxgp8PKIPAPMFIo47?=
 =?us-ascii?Q?iImCkz/3B9qpr63Pxh9kjZv9SOhX5XG9CS3wBrjZu6Xh3JfQQ/y2xprNtgYf?=
 =?us-ascii?Q?zOy/EKfKPr7V5udyYq/AKaCPthutvLjefyI6B5PHUraHYP5Nv8gIf3gRYXFq?=
 =?us-ascii?Q?r/V1OOyD1gfa3k7AeQQKtmR45aK2yiYQ/tdn2LTe1mMwiDnBQ89J23rKUvUB?=
 =?us-ascii?Q?WAZcBhTaz5xKT48+v1OxJlV7cmFrE/Bjw/qUyrccpofu19z0kEi65+tBnvLF?=
 =?us-ascii?Q?v/CEDZRVOUx93ijjrsUxl5G54m3xB4FmfyOaU0Ao7PLftTi/Fgk77iCJkk/R?=
 =?us-ascii?Q?tQZZJ1FSmFEn6n5Bd4rGaXDS8PKv6E8nRjmsj6Ke1g6eIaRKMMb354cE5K/1?=
 =?us-ascii?Q?uXw83GPIMr7KuDd018UB1jKgnuaw1MpNCsYrwgIFaPKMbCCfPcUiA6qHmKdP?=
 =?us-ascii?Q?8pJ7lsBLB0N5Wuau+crJQbpSJHbSNXPsrltFaV9D0RrCFJpItM4CNuKE1cBZ?=
 =?us-ascii?Q?d/k1tETVXv2KoWPQRORDfl4tEzmt7PAnTbaKcKZ2JdbWcqueH3s5DKpnYeds?=
 =?us-ascii?Q?d+gzuq82GycCfBMjCB/MzSEK/Jsf6EZB3XmkVDFaJYNaIBN1KSgJk1HIt5eY?=
 =?us-ascii?Q?F7JzTuyhaGtVUGs4PpPiA5hi+J6zYjPuzGFOSj27P3+Ewf3zBQgLdKb/w60U?=
 =?us-ascii?Q?a4o9w53EJB6KjquI4E+K5LUGA0OJIb1U6Gq701/VOyTNJ1nDUQ3S8/d5DUGm?=
 =?us-ascii?Q?L17B/mCUahEMFtO0po2tGVgRiWKCLDS2pULLcFKdf8JlG2+0TmsbylD9VYUr?=
 =?us-ascii?Q?9caV3g/j0dyYoQCilx+16hRJpIAWl3LOV8T5GeqiG7LaYhnGR9vybiP6TAtM?=
 =?us-ascii?Q?TBaGvgUI7YyM27nw6I/Lbaph+FdrC53TinqTo/USOItTbMmG3vcIAQoN6onB?=
 =?us-ascii?Q?VyrxlVPBrY0j5p7NIdcbhneMMIUrhZ3kRNcPf7Q4o7Ap/kER9+RXO+tP7fbL?=
 =?us-ascii?Q?BUpDz+PA/lBtrb/jI9Su2pTPRq/fFdXDbxL9hJ/lpN65xqAOd307bYn3nylo?=
 =?us-ascii?Q?nQ6UG/UL2XoEgh3NNRovYhSt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3312096b-1410-40e9-25ae-08d8fdeb9cc1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:46:06.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2P8ynhwPBbFiNRIhF2TQre15nm7XnOgEH2BSF0KaSau5QNeGOu5nKEzsHS+oOf53mEa+/+27UJesbDPg53D4AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2367
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
feature.

MSR is handled by userspace using MSR filters.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/cpuid.rst     |  5 +++++
 Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..0bdb6cdb12d3 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..020245d16087 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,15 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_SEV_LIVE_MIGRATION:
+        0x4b564d08
+
+	Control SEV Live Migration features.
+
+data:
+        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
+        in other words, this is guest->host communication that it's properly
+        handling the shared pages list.
+
+        All other bits are reserved.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..f6bfa138874f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
 
 #define KVM_HINTS_REALTIME      0
 
@@ -54,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..4e2e69a692aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
2.17.1

