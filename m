Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24014197472
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgC3GXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:23:38 -0400
Received: from mail-eopbgr760045.outbound.protection.outlook.com ([40.107.76.45]:33259
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729036AbgC3GXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:23:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGkX/1jUHYI5NLTO+zztzqBgGzaFPvCFBw5ykw5LoVKXvwqYgr8afxc74i9EoHnQKS6tt3tfPjOMQyGvH385YB1RLsLKBHt4/aYjJsYFOaLtiOFIuXbWPg+XCDo0Z6rb0Wi480LrVRZAArP3S3ogG7xIwrzb/kQmy+CwhfTXtIDtxbcMHWUr2RyFuEVV+leFgblhO6nAIsuOH0jSA6AgPOFQjaXtfywwhkmrKWqzcuBO+6GTIsvkFAIJqUpKNvMOTXQ61Relrve7yBbbQf1eSn1qbMB5tHrx3hd8TxT105LlMBeovn20GoocDnzIK8AtzKZaYhqbOdm9s+chJb/pTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OzZU/ZbBLos9G0s/Am1HGIhQ35vfmfA1nh6tV3LVFw=;
 b=SRD+vycX1BHOsDBuGTNm+3i+k5vOT9bW9Yd4FfEjbCvfBaS4uC0/Q9owF91tU8SGsAuNmdaFdhDoOSDjU4KUfac5txkUjvs4+sGKNrPC+0/BAxD7z/E5/mhtv4dydbJ1OFrRCAwQjwzOOyFfGqGYhVf7g/xOuIpV6bdjdDvbMIshJ5SAf/m3/wiUKadAmKq/lyt8p9rZbdnW1mrR73IDita84kgA8URorH7NrDdlluvCkjxxKsgvncKlPj8AHb2xGGd0NkMQ0bbiragyUvwu1ya0jG6voVJ3zDrqBYezrz2o00ZWEvOCcfVyeisUzi2caJZpAN8PhM/J5uM1z0fFbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OzZU/ZbBLos9G0s/Am1HGIhQ35vfmfA1nh6tV3LVFw=;
 b=vmayMsoEsiTxFNifSyjXbiKV10SdfZVs06NQnSseyby5PYG8PBgdnlIZMF7g9SoWPOmMENHVxTx8fVgB2yDHelfhr1wR7KUMX10pT3hOxYmA3x50go9X3YbZ5tjeHXqufMUqzXePKGeX5ELaTDoNBuTZIlzu1p6RBbdhjCHekiw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:23:35 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:23:35 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 13/14] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Mon, 30 Mar 2020 06:23:26 +0000
Message-Id: <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0096.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::37) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0096.namprd02.prod.outlook.com (2603:10b6:5:1f4::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:23:34 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e38c1e90-9419-4a48-3c8e-08d7d472e056
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692E1A787A29BCFD4FE9B698ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEYcpydsZeYsz7JdvIsB/r4J3/SyV3LAgmfMfYZy8J+evYEsCBL2HOQYjlKzBnrNwomqb+qzoHCcptc+PoiSNxVmxxmabN62nrUQCuPy16gnmBkgMxLVtx834se/NmWt1olnjjR6z45a5POmRYLeX6ZH3/t8kjMbgDJ8K2ifp31JNF+PJBqMoVvlcD+alPq096EoSRikWRUOrzt1c3jwdyBO7KyzUQGWjhxwGnJhz5A3DSmJmvL2DQtCHR1fVBax2/tVDaRszoAoujU9ZkfoxKdezL4cZ6As4lyYP/KFbhu7qvB2jDReLoOpEdnR7z6W4i2H6Gm1PGRegdpvJKnMz3MVG/rx4WvC/6eg8z+k2MRfh3e6DIcp2CCzpDHuQXHDBRn+LteM6LID/pyiWhr70YQtRHh0sv/dpByJHf1LJVhJzQJHOJm+AO1rBVrMQRgFpIEu6gDGzTA6kyY9TjKxdEcMj1UrtYrW1hQY5qdiqxLxW8kvdgv5UkL+XDBUxoV0
X-MS-Exchange-AntiSpam-MessageData: plVQo4DVukju9H6S0qzUp69W/hzt4lfpljb0/sVYlPKWTXJM0z+ynaiS49AC4RTO2sAk5o8XhOIPJsaejqPe6LvMxjLWw7drVOl9KkhPfPMs6/xC/m4Q+DN4CcURR+ElspdFHAdMHJLsN/OG+YmJ3w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38c1e90-9419-4a48-3c8e-08d7d472e056
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:23:35.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oV0LukUhjbZ5QGDlNCZn1We9xuR7hY1qN4ZRym1j+ykEeY7j+Qm5uhoVaaFvSEXTLiMGe5EFxiR2qlSvqzpDHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
feature.

Also, ensure that _bss_decrypted section is marked as decrypted in the
page encryption bitmap.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/cpuid.rst     |  4 ++++
 Documentation/virt/kvm/msr.rst       | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h      |  3 +++
 arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
 arch/x86/kernel/kvm.c                |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/svm.c                   |  5 +++++
 arch/x86/kvm/x86.c                   |  7 +++++++
 arch/x86/mm/mem_encrypt.c            | 14 +++++++++++++-
 9 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..fcb191bb3016 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit
+                                              before enabling SEV live
+                                              migration feature.
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
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a96ef6338cd2..ad5faaed43c0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -780,6 +780,9 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
+	/* SEV Live Migration MSR (AMD only) */
+	u64 msr_kvm_sev_live_migration_flag;
+
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
 	 * more of the PTEs used to translate the write itself, i.e. the access
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
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..8fcee0b45231 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -418,6 +418,10 @@ static void __init sev_map_percpu_data(void)
 	if (!sev_active())
 		return;
 
+	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
+		wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
+	}
+
 	for_each_possible_cpu(cpu) {
 		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
 		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..74c8b2a7270c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c99b0207a443..60ddc242a133 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7632,6 +7632,7 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_vcpu *vcpu = kvm->vcpus[0];
 	kvm_pfn_t pfn_start, pfn_end;
 	gfn_t gfn_start, gfn_end;
 	int ret;
@@ -7639,6 +7640,10 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	if (!sev_guest(kvm))
 		return -EINVAL;
 
+	if (!(vcpu->arch.msr_kvm_sev_live_migration_flag &
+		KVM_SEV_LIVE_MIGRATION_ENABLED))
+		return -ENOTTY;
+
 	if (!npages)
 		return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2127ed937f53..82867b8798f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2880,6 +2880,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_SEV_LIVE_MIG_EN:
+		vcpu->arch.msr_kvm_sev_live_migration_flag = data;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3126,6 +3130,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_POLL_CONTROL:
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_SEV_LIVE_MIG_EN:
+		msr_info->data = vcpu->arch.msr_kvm_sev_live_migration_flag;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index c9800fa811f6..f6a841494845 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -502,8 +502,20 @@ void __init mem_encrypt_init(void)
 	 * With SEV, we need to make a hypercall when page encryption state is
 	 * changed.
 	 */
-	if (sev_active())
+	if (sev_active()) {
+		unsigned long nr_pages;
+
 		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
+
+		/*
+		 * Ensure that _bss_decrypted section is marked as decrypted in the
+		 * page encryption bitmap.
+		 */
+		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
+			PAGE_SIZE);
+		set_memory_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
+			nr_pages, 0);
+	}
 #endif
 
 	pr_info("AMD %s active\n",
-- 
2.17.1

