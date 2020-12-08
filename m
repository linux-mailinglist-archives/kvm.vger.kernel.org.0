Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D482D35F5
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgLHWJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:09:31 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:26709
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726421AbgLHWJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:09:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlZZOtY4hcjAs2OMEMeFh48bx2cP3ZFvy4utOcDtSB7G6vlmZDKuOriGVCwg8ezBnGMFqRC7MWDhYd0FiI1U9MqabUKo63siLobiLCAVBwUTzh7T77df1Z2801I2jZKv0G4bG/2U7QIYK1g909/3bZO9RcWvtOMi1twZVs1WrJtHLdSYtNY3mQdZiVXZ4i6UszekkuHQNX9ALEjbqtV4eRu3ZqiukiENZQBM1ko4Fya8XX2A5W9YVjGxp62dX/UwoF6pR4hCKMNUzhSo1/wadR2V0v6aOtjCMxdvBEV4rFQqX1sV8N7ZxRARHRm9DHeoyvSXtm9GQWW2jYXiNZtOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny1Gd7lV7WlaLdpwyPbHskbBU2WwJwrVGgHlVvGi90U=;
 b=Z6+vr0TR2ilRXK30aBAAN0FHrkrPJkqWvNqh8/eYN1S5Voa4QbR8IGU1FYHF/PK9ruU8lZcrR9Ts7F9Babfedf5B0EZNHt2+tItCg7dlsQsq6wEhWblYv0J4os5k9qY+foSkz/TFV+7nAYoLZ5jx4/05kNuI/Z0PSHp4b62cwtthTS+b0sYzA8zmjdFwPzAxIBAQY10c96qlC3lyrOj57tMjhhRS37l5vxUACHX4T+L2kndepcRCsieS1ydgDDx1leWovSYjxLJPEkuV84+cSEl36gd+StxAogzFek18U8Pb8hWkaeYB7HvTWNPXqJhXktCC8CAAr2BT+aCenVx4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny1Gd7lV7WlaLdpwyPbHskbBU2WwJwrVGgHlVvGi90U=;
 b=v1b9fVenJTUYJ22poT8fTDnUmIxiM7nyUOt9H6/F+iRgXk1GGWM1hDDFgBShj9asML8b3h+K5gfDWhRpSRMZMz8h4pG32Ad6PD71gLofgqx8IZ8KOieo7XH3kgYSk5wUgHy9ArUVp9DAA2itftWNfZCNhQbp3tfk0kJypelZL40=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:08:04 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:08:04 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Tue,  8 Dec 2020 22:07:55 +0000
Message-Id: <a67e0a02e8922e13d766c128708f5948fbda3a26.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0013.namprd05.prod.outlook.com
 (2603:10b6:803:40::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0013.namprd05.prod.outlook.com (2603:10b6:803:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Tue, 8 Dec 2020 22:08:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e29e0b37-269c-4863-bf0c-08d89bc5bc5d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44158F348D4EE5D7C721055D8ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/p0LSdIThXbWp02evdctzhkrpQvfN+1NaWAhhrhsb/GlY7p4vZY5HZGsifXafGpqqyhKh4Wgmv9nQxRro78lMahusDyJNbAYjQtFZ5iagf5CL30dekCGlBJhQp0VZ8bgbhuIFVzTemk231BlYp34nuYWEXtR19besSCCqYNqkFnueU1eO8qN2TeskP6cuLLeqaPsVuCQfsrR61RIg3n+ouj0OH989fEkQJ4l4xlKbUqf69DvsyiYs9vlx0St6Oe2sBKg1YiZlfIrh2qnrCCHQ4FgVOr3LRLDlAfX2cnyMzxdcr+UUqJ0F5EF62SnPmJmdZl3KVqai7aTxu+0ZZkbvDwwjIJ3z8biCbJJvsYtacXUytIepL3y0qoiUe6xmco
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nw61Sn/uJiLjzN/gJjHeoxG4seKXtEpPqlXZAtRVZDEYmfK0oHy/cWEtzukn?=
 =?us-ascii?Q?t9YCksIE9KqONo0dWc10b+DWe8RZtN0uw7Z24P9R/MIQxiU7VXVOjyO2F3WW?=
 =?us-ascii?Q?MipO+CuVd3UefCgdba9/LsIt/h2hpvVReV/XCND0qX3cAtBz/COBvUwfsRfu?=
 =?us-ascii?Q?LQV9Kkgar/CqqCl9/fChKHO+yPeePphSfpJrIFhwagzdwPlbGEm352PPV7J+?=
 =?us-ascii?Q?7mAuMwNXZfodTGTZgpBjOzgKeeTw+AGZOzKs/MJx3athTjhpwpzZ2y/e1MAI?=
 =?us-ascii?Q?sX01Rzo5IV7fNUng8zrct3Els4oKZRrsYCdGCLlLu+PmaZqJ9hahf4RXU7Cp?=
 =?us-ascii?Q?mGEhPMH1lOUKqOn8v+S3MrKGLkT89IJn3SF1VTesOWR9jl9Pq3FSJymyGhUO?=
 =?us-ascii?Q?snOXc9GpUvwY7NATyh27biHJ51SZA3aVJHu3eJTbMnsFOAFlOdos5bZEg6tB?=
 =?us-ascii?Q?GzV5+7aIuEq6ZXVwBGNR8YTP1fLVjxovskjV7OQa5zrTjAM2EiE9/2dJe67K?=
 =?us-ascii?Q?7XgJsxrWZ92WcwHIvt/SmkCcHU9c7N6A4pCC71FlZOreXINUxn9ZvIqBjypz?=
 =?us-ascii?Q?LIP641pQegPKW+JmV3u7GGCllTUAFFUWuUTx0nljCSjvlMMwjXd8bl9YGEb+?=
 =?us-ascii?Q?Ov2R389Yx9sOoYvN/dHMK4lzCKLh57RCIY1VJ2UFMu5oIaQDAnEKyu2V3i7k?=
 =?us-ascii?Q?GALECUPvt0+yil2rqhI4VBzpO/fOZIfFscAHSMcvkyhHsLwtJLVw02TBPEDk?=
 =?us-ascii?Q?caaNQbMuVPMXqwQerhO4RgqF2lN1rViGxu7oBGdkLx8p5fEbUSwgHlnsb/7+?=
 =?us-ascii?Q?331DqcPwF2kWomh5eBQ8XCqZmBBhW37Puxqy7AGMx4n5Qoe3c9bNXmroZ8ec?=
 =?us-ascii?Q?QYJFRE0YpL0AyzgcIXkAUqiuEh99oFoJUpjHYHyJ9bUjWfsDRugl/rpZz9q8?=
 =?us-ascii?Q?4Or3HWhpU2FYsPNFmn8E0X98YuPZ7YnMZLJ2MQprHBTwyT3Hz1fLTe8BfZNp?=
 =?us-ascii?Q?EzeD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:08:04.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e29e0b37-269c-4863-bf0c-08d89bc5bc5d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfGQlkRebI+aeFy0NbluZAb4j81xlanhXMY2EhPP5fvf75GoKT/wZx+W3Cb19ov2xsaqjSLBoUVoKSGFLBMCpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
feature.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/cpuid.rst     |  5 +++++
 Documentation/virt/kvm/msr.rst       | 16 ++++++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
 arch/x86/kvm/svm/sev.c               | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.h               |  2 ++
 6 files changed, 58 insertions(+)

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
index e37a14c323d2..ffac027aba5b 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,19 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_SEV_LIVE_MIG_EN:
+        0x4b564d08
+
+	Control SEV Live Migration features.
+
+data:
+        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
+        in other words, this is guest->host communication that it's properly
+        handling the encryption bitmap.
+
+        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions,
+        any future extensions related to this live migration support, such as
+        extensions/support for accelerated migration, etc.
+
+        All other bits are reserved.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..0e8e59115ce2 100644
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
+#define MSR_KVM_SEV_LIVE_MIG_EN	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -136,4 +138,7 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_SEV_LIVE_MIGRATION_ENABLED			(1 << 0)
+#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED	(1 << 1)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b87b6225d2da..83565e35fa09 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1483,6 +1483,17 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return 0;
 }
 
+void sev_update_migration_flags(struct kvm *kvm, u64 data)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_guest(kvm))
+		return;
+
+	if (data & KVM_SEV_LIVE_MIGRATION_ENABLED)
+		sev->live_migration_enabled = true;
+}
+
 int svm_get_page_enc_bitmap(struct kvm *kvm,
 				   struct kvm_page_enc_bitmap *bmap)
 {
@@ -1495,6 +1506,9 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
+	if (!sev->live_migration_enabled)
+		return -EINVAL;
+
 	gfn_start = bmap->start_gfn;
 	gfn_end = gfn_start + bmap->num_pages;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7aa7858c8209..6f47db7b8805 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2765,6 +2765,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_KVM_SEV_LIVE_MIG_EN:
+		sev_update_migration_flags(vcpu->kvm, data);
+		break;
 	case MSR_IA32_APICBASE:
 		if (kvm_vcpu_apicv_active(vcpu))
 			avic_update_vapic_bar(to_svm(vcpu), data);
@@ -3769,6 +3772,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
+        /*
+         * If SEV guest then enable the Live migration feature.
+         */
+        if (sev_guest(vcpu->kvm)) {
+              struct kvm_cpuid_entry2 *best;
+
+              best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+              if (!best)
+                      return;
+
+              best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
+        }
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5a4656bad681..d1f503dc2584 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -66,6 +66,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	bool live_migration_enabled;
 	unsigned long *page_enc_bmap;
 	unsigned long page_enc_bmap_size;
 };
@@ -505,5 +506,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+void sev_update_migration_flags(struct kvm *kvm, u64 data);
 
 #endif
-- 
2.17.1

