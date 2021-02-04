Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E962930E8E8
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhBDAtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:49:33 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234376AbhBDAnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUsk03q8cGcj5bX9RTqxYzg7a9x75wUm59aGmulg4w4T1VskuICWmStA/N2XUq0995FQX8PHwXsWUsiUoO4Tyt00z/a2IlNS/7IPJKR8PHeg9LFOnS8f0qvWPW9cHtlSFhf478HXn2EV7eOETj93ogCP3rAS2nWFWwJp9k0qIqFR7vP0f6xxuJJVuMP48OxHEMD7JsQGHs/KYLuifl/2QhaNl3qjj5Vw04X/KsPkQjLdILiqZBwA85RBhfP55YbYjyxy1skjjcKN5oCYe0DrlmT6WgTEBMvypLeMUPkH+BPyuy5GusD4RyPyiSzS0hxIsiKoQiO7mJ9MMTIYAm7dmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/41AGRjX/t++aDIDKX4dzoQAPqMoBrcSZ8cmr48u0c=;
 b=ggHYXduQr9k5zuIuietugR2r0tX+5fdgsJYCAoIpT3fTbGl5iU3mT4SPF2IT0CmHJzvYkl0HCWmjNbZ55ca916pgjPzcJPV3xHHoafOI/I7v4/oGM+vQv7IcpCtOOH3Ge4z+rAgcor0ZVGxBA7ccU3NLzf7YUB8XhQybrDnDcgsh8B6LWq31Vb8KEa5xS7VShqjkyw46zfr/w9Klk0aKsdOXNyi5qc8CPcoYBgBOH3eJh4BuQBjlOJO9hF4WXPaJdfrgeOgpnr4VohXqGifw6Xf8vsC2AAYm0RdG00cBI6gkGg3pq0JHENbmpFWhUgfIsRbEh8967acFCTY0mAUlOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/41AGRjX/t++aDIDKX4dzoQAPqMoBrcSZ8cmr48u0c=;
 b=22361wu3+pHjX50E5zWC2qjQJAyBZ1wGzY0mFMVZ/J8Vmcu0ce9peg6dXvoXltLduz4edLHWZjoKatcDq50kMUbCbypddrw5oMLup7Fmgq8Gi1kqOR3kiLuMidwyAkOAv36kRTa7rmFsY8/YOcXJkN3pvDiylL1o9+VgFmjrtrY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:39:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:39:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 12/16] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Thu,  4 Feb 2021 00:39:47 +0000
Message-Id: <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0237.namprd04.prod.outlook.com
 (2603:10b6:806:127::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0237.namprd04.prod.outlook.com (2603:10b6:806:127::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:39:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b6f055e-76db-4e3f-bd7f-08d8c8a564de
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43847DA1E05E1DA87D37F6588EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yk3lyNd1RzeaM5LMMw1VIsYI99eZ4vsEDGv/gi311b+ixqw+Ko7GlbK/bPEkxnH8WUNx7okC3lAk82mtPYox+JVQCkj47XcIriyvs206hYkejuN1zGXwnDOyWi7zOVX8akSA3deJPmNhwkhyojDUel6JlRxbiimRD8DNpXQHXUEhv57kG95tNRgQJeegz7zRMSS5C+gxnKy17A16jun0VZ+5rPXjrhqNstcv5DKrK545bUnw9urRIOcZBdhqs9vrzLpU+lT80r+muqnZKHg0O5WBK5s3QHG3IxLz8XitnAA/aeR1n+wJcV29ktvsBqb95k3o+KCaggQ+LkaRA3PRO5JXIkmhwOmngR/HbantnEd/mL21gDon/xC4ry4u1PB1fpufoMLV8fMxkklWMMJWz1IahEyg1zQTH/JGBNFrd6Z08f8GWlCASZV66hBSHTyJaxT1N5iv1d5E9h/gG4StfeQHRrqG3hYAhmetZPb1iGhjk2+j0G+hbUeHseIdeb/RYUHMfaCLjflvA3nXVJKsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9wpyFRrVTUlhkm+JLVfioJ9RizywRnyzH3nEyP55t/hXRpV0d2EM1K2ImcJy?=
 =?us-ascii?Q?uIbRzGa5xWbEtyFfJbHHFy8LQkklI0xFhd6cz5T/OTUJduoXq7C69BmKj/A2?=
 =?us-ascii?Q?xpvDZJSCZPpqwtk1Vi+8b3Vg2JzLxrWHow5dcCTFkLKC/vIPdFGSg2oPneO0?=
 =?us-ascii?Q?PiYfMtfKMBxOP/zG47fyf1qrOMKN92DgwAEqmiJCY0IxmyDE8mwX7QJZP9PV?=
 =?us-ascii?Q?98XVbfnC3ER5rVL6ktwVsdx7kqPFLLxkyI3xyn4UgI1all5M2Fr4ikdsxab2?=
 =?us-ascii?Q?V9p9HUYLmQrzkQAowo+kBOgNsGFCHGFTLJKgwuXGLcjUp9E55Taruf7D13RY?=
 =?us-ascii?Q?2RIkFGYnLxaQJp8x3pl82nUFkGeAFDMfLyojg0nePLcvBq5l4mcSaLSWhCPN?=
 =?us-ascii?Q?UpHelll1LGJ+89lGC22dAIxnrCw8erI4Qen23SScDXXSdJQphusNZhHp+Nvr?=
 =?us-ascii?Q?AzcpZrS6TUdwsOdtz5uIj3x3mdylmljVWE8qtR+hjP8xhj1OdFGagEYHesmL?=
 =?us-ascii?Q?jGdf0itovy79rbqaGPXRSytKQob4j9gdaEhN1kBrmi+loH9F/r/zQ3wyF4JT?=
 =?us-ascii?Q?pcUArtCuwnElTWNkE4HBWmqTE8SQXZRAwq5XN07bgJ3dOZmcjBA47SBQDLGr?=
 =?us-ascii?Q?JnMw+lEFw81Oj1U+JQ8ZyXqrPMP5v7OBoge9d1pWJOMjsfkp3Qu8WKN58tGY?=
 =?us-ascii?Q?Xe5CzGmNG5BtJwStiDRgv6w6ZPlq5TvV7yEo+1DUODQlggVUDmvif01sHyTI?=
 =?us-ascii?Q?HBaeMSoARIwq+6lYI13w0HxUjWQCRzOVmhxMCYMGPf4kCYk4tj/cQVSvEoT7?=
 =?us-ascii?Q?WZchXGWSHNd1rmUTqO9RD0Bg8QfgTpnEGCWE45YKkXqBMSZBg7fMU+GsGfOW?=
 =?us-ascii?Q?AJTozbbcZvm4pP+XpbUAUZTRpg/uIPMB59/jHZ7l+mJjqdk2mr070eprNR3L?=
 =?us-ascii?Q?fxjsRXIqMAd+bopXvgcy0jM9TW18CWV8/cqO16VgJinl/2jSSGhKXV6KdhsV?=
 =?us-ascii?Q?Qu949TaI4ieDJEJ8+ZeJg2hwk+fZnBXXQ/yw3dIvS7CPEYVz5jnjR3tzQUyw?=
 =?us-ascii?Q?iLj6Mpzvy3yEhJtvS+2Yuc4S7bckN1cJbso2Eyx/H/TkDYe6DmTQ90kHTEu5?=
 =?us-ascii?Q?iJWP8uOPE1hGfg7IzcTiMxet3tlVy86uENXaeH4MqwjlmXfDck8J6oA1wosi?=
 =?us-ascii?Q?aViGIlfSVitfF7zfC1HjhoCyhgwDYy6hEgMZ7HnbifCAC044wKYTx03XSaGu?=
 =?us-ascii?Q?24C+LvhK23k09chty5VJB/ihBLlIrBVhsKMQ1wNvoK/oiFB5u/SNpVlkQ05H?=
 =?us-ascii?Q?JLnlH/OidE0KzTfwkJbkwQDO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6f055e-76db-4e3f-bd7f-08d8c8a564de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:39:56.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RPPWWb89S9UBIyKj4uzjuBPo609X/ZdPMnZr6dd/1werDhGuucxqd/1h51shp98ULRYLDTu97+7KOxN1QXIXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
feature.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/cpuid.rst     |  5 +++++
 Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.h               |  2 ++
 6 files changed, 52 insertions(+)

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
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b0d324aed515..93f42b3d3e33 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return ret;
 }
 
+void sev_update_migration_flags(struct kvm *kvm, u64 data)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_guest(kvm))
+		return;
+
+	sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
+}
+
 int svm_get_shared_pages_list(struct kvm *kvm,
 			      struct kvm_shared_pages_list *list)
 {
@@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
+	if (!sev->live_migration_enabled)
+		return -EINVAL;
+
 	if (!list->size)
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f89f83caab..43ea5061926f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_KVM_SEV_LIVE_MIGRATION:
+		sev_update_migration_flags(vcpu->kvm, data);
+		break;
 	case MSR_IA32_APICBASE:
 		if (kvm_vcpu_apicv_active(vcpu))
 			avic_update_vapic_bar(to_svm(vcpu), data);
@@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
+	/*
+	 * If SEV guest then enable the Live migration feature.
+	 */
+	if (sev_guest(vcpu->kvm)) {
+		struct kvm_cpuid_entry2 *best;
+
+		best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+		if (!best)
+			return;
+
+		best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
+	}
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 066ca2a9f1e6..e1bffc11e425 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	bool live_migration_enabled;
 	/* List and count of shared pages */
 	int shared_pages_list_count;
 	struct list_head shared_pages_list;
@@ -592,6 +593,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+void sev_update_migration_flags(struct kvm *kvm, u64 data);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.17.1

