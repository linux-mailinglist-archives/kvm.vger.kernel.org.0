Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4454A1C62E7
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgEEVTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:19:34 -0400
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:34596
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728737AbgEEVTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:19:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dduXz3mTTOUsZ051mMnwfo4Vc5hDdxzlmR63ouRZtdflx/ZhdxpyypNxNkffMCYJkao9mkWXU4GAwSVPW6ErVCTZRxHcoYVAuECIR+3QXb2QPYfzEltjvHB68p5jlHSYTUm2B+TT09wJ1KmSp/HFSphHtUcnKX8qdIeb0YkRvth4rxBjYmQeGrFgojPG6qguqLcxWTaNp9RYallUny1Z5FltusnmTn6lfwnfgvLwszMpZchPItc5zKMJ1fOoexLU1GWLHgFt4rQ/2vbBFJe/XpRaMhccvLhJsYPeFRhNh771xMxsWJ9o1EaCtsTgTXo2mtTb6PCZk8RuKDDwuv9Bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuXaRdjmmHCPd9wR81thyrxqDncCwgKk5BxExn3Vw/M=;
 b=bXv3ceeHLAQ9i/Dv8fVvD2ooCcsW4cQFVyjxZKudrDmUQF0DgsBViLsLio+CghXlVk6Tw6XMy7lyekBgw8gmAcTcb7QWGupaJFxC/gkiNv0WsiUVyIHAy5pJhxLMyiTo+IAHkfMWiaCCj8vKyZ8R2ZKE4PwH3UH/u6sF5EdzZeIlKjHYTtBW8pfe0xQtcy4wXrjFewrawDJwKjeN0frTq2lcYGZRtoY8oxj/7DlCifgEeafE2wJKC7VOQcwOmX1XT+CR6nAUtKcZiORcd8/znGMQlwwBnZIS3s4zou1VdzU8yqaUnFHZyhRLZ7QJFvFxdIG5xeVLB9ZUVbiujf55qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuXaRdjmmHCPd9wR81thyrxqDncCwgKk5BxExn3Vw/M=;
 b=jGKPB6Hh9a+ZIfs98ZuMO183CPcZKcHBvJukkMeXs9tziugkYFfLQN21YjqdTqMUylF/UI3G5kzSrgMJAxy9WYeBZtqPhwABcVIDi19n76fc/toI1sY3M3OsPgipzaZ+uaDnCWVBBXMZf32e+4dYsBuOzqere/coj3Ix3T8RvsU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:19:30 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:19:30 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Tue,  5 May 2020 21:19:17 +0000
Message-Id: <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0002.namprd02.prod.outlook.com
 (2603:10b6:803:2b::12) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0002.namprd02.prod.outlook.com (2603:10b6:803:2b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:19:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 30c44a4e-17a9-4692-c133-08d7f139ff76
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25182D3F36E98E73EB25D1338EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4Aoe7YrfbzYPdFhQPBjHB8JQRME1Pc6EQe0d4w7OP3YHkPrEucw3k79qMuTyAIQMP0xpZXe9ohD1Y48yAIX/VcroCjOfbACatqOWroE7gyLsVlvJr/4Vni4afk7CtB4oVOGaF8ZAUUIybtOwQTAtNzVwrU66Cp2ZdW4NHP3laOyTdF30Hi+lyqZfB+g0d+WOm02rlzRElbvSOBNtMhNyJTmoTeJ7oY7AzoHe8ZpXw+2CWnznV0OQdf9fMwTBpSdj7JEmsN31Nh9ZInxQtt8MZHwQZUADCuziWEdq0RPnjJwFrq9jh6KubfqvXlC4ySYLurp7yqrINdf+hxE2cbJxnUqivPNZsMjw/xNX/T9KPAPA5VVy2jGWnbwUlBADoVQvONk7ZG0LqZ4oakyW1bKHPjlTMpM7DFyksa3uNjsoXdmlfhBEbOdkhr4ImlXZ83BQbhRwCCvNELqu4iuCXt72VaSu1uXS2paEavbzATF6E/CjiBQ24qAH/ZMTlaJRdOZnIt5ouamiFi5Sjmusu8HIAr3peedyh/kSjvhlPiJPWSxvV6acCIspHZ0rtSVeKGw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ghI6GI7EUZgzu5afUfm8T9tdQ124xf6yIar+p2mJabI5bR+ON5APNc0nW2NsggiSMQQHwO85HIgDoA6qe4i2AJcGVYi/LNCazp29OQbOYiS2K8udpGNUNC0pPc+YzAKQu+loT6M6PorL0v2na2XmlwiZNJXw928sIx1NSVsdjMEIpgm7Xrz+IL7CbryfqAaTUKRvxGAhuITvOD28eS5rP/qJuxHQPRzvbjGnxXDDmK1WI6JB9mNA/a9ki/L/jM8942d9HmphNUhl/MoPsyN69uBco4qPkcKSS1NoSQCmfqN//PKeWzzKPI7D5B3858TRMb4iZTB4Gq9fbbdb+n1rpvrImw9Q9YV2j8VmwWPpjXJfa4dtpN0ytnb7q5EtAn0u88LWRMFltz2SAo8fFnYC7nSavBORwB23ksGdd6BpjKB0zYFy9ZuoJmu9FSQb0X3TzJWihXYHz0B81IhtGrg1D9r+5pq5mePuroMFSHNxKjIJljO/q9r9dNk3g458yYsw0dcQJjwB7ww1Y/StVYnaSZh1VLVsxvpP1HDJL8P04NTzRKQQUi0K3zMWoebNGCaEt6Pj6rKGoPAVjYIm1ldMvFvVDP/TxuGFd94qlGuZ3B+pB/AoHOFXMFPJWFqIZAPDpPn67IlF89w4bdEUtwk4mFT43liLZiDJx3mvhwOOkqzVHMjhz9Wjk+44//rRaXk87jowU1aFzHrvuDS0zqFacNNSMVc5OelvaAG3iiYLU6DbriiR+BUeUW7qgW8+6XcKDWKNJEsdRNjiyb0lpEkvFiijZJfe3b8tyiTqEuxBeIA=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c44a4e-17a9-4692-c133-08d7f139ff76
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:19:29.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyj5F8nnXqm3xHhpy5FCePPgRJGwoLZG3r/Mx+THD7rZ6vt8Ulm6KZzUA8zKpL1xZQvffS+vYecE88/8RHZmxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
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
 Documentation/virt/kvm/msr.rst       | 10 ++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
 arch/x86/kvm/svm/sev.c               | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.h               |  2 ++
 6 files changed, 52 insertions(+)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..0514523e00cd 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,11 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit before
+                                              using the page encryption state
+                                              hypercall to notify the page state
+                                              change
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 33892036672d..7cd7786bbb03 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -319,3 +319,13 @@ data:
 
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
+
+MSR_KVM_SEV_LIVE_MIG_EN:
+        0x4b564d06
+
+	Control SEV Live Migration features.
+
+data:
+        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature.
+        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions.
+        All other bits are reserved.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..d9d4953b42ad 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_SEV_LIVE_MIGRATION	14
 
 #define KVM_HINTS_REALTIME      0
 
@@ -50,6 +51,7 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_SEV_LIVE_MIG_EN	0x4b564d06
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -122,4 +124,7 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_SEV_LIVE_MIGRATION_ENABLED			(1 << 0)
+#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED	(1 << 1)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0d7043a0627..6f69c3a47583 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1469,6 +1469,17 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
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
@@ -1481,6 +1492,9 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
+	if (!sev->live_migration_enabled)
+		return -EINVAL;
+
 	gfn_start = bmap->start_gfn;
 	gfn_end = gfn_start + bmap->num_pages;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 442adbbb0641..a99f5457f244 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2633,6 +2633,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_KVM_SEV_LIVE_MIG_EN:
+		sev_update_migration_flags(vcpu->kvm, data);
+		break;
 	case MSR_IA32_APICBASE:
 		if (kvm_vcpu_apicv_active(vcpu))
 			avic_update_vapic_bar(to_svm(vcpu), data);
@@ -3493,6 +3496,19 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
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
index fd99e0a5417a..77f132a6fead 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	bool live_migration_enabled;
 	unsigned long *page_enc_bmap;
 	unsigned long page_enc_bmap_size;
 };
@@ -494,5 +495,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+void sev_update_migration_flags(struct kvm *kvm, u64 data);
 
 #endif
-- 
2.17.1

