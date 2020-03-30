Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0ABB197219
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgC3Bip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:38:45 -0400
Received: from mail-eopbgr750043.outbound.protection.outlook.com ([40.107.75.43]:19870
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728297AbgC3Bip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:38:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1Bd9wRwx9T7uF5FUVTjS4aPX+eFYTQHyK1faHvVCc98kzpINLEHqHwW9PMgrSPcb/ml/olE65r2VnEninXeiS6yhogAzltpc5cnyRHPgA+9kkD7jSphjd7PkQmuU51LuhSVfWg50N1qGsukfckztZVoMoAjpu+7leITcdSCHieF9+v1JGvnNbRmLUolnQxmW/o/blRpWRKszlwFj94bMSKjXlwic8Re+Z6M+XT+/cRi1BQRvcV9A8NduAw5XpfioPCh+W+tRB/JBIGfKRhbJSeqyo7Q1tG36F8+u1q6GcYPIrg8d8AsjVfNbD5SR/V6Itw8CAN+961FsPPwtCznLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o676g9aBnVUbDNobCs1Bakfbgep3HSLh9e8GPmRqNlM=;
 b=KyvCpD/sNlqh4sDtRDX3+OKjkrRasSU4ZNFE1JdqtNY6ZJVIazDlwfZrs2O0FVOLHmjBUujmhpF0s3BgTrx9jGW9O9gtqKR6uyH7U7JkIAHxYW3j+dYoWT8ttpV3w4SXjBCwIPUS/4ACh0h0X/a1zyQcWuVMLSGMK+q5cyVn2WX/Zq0aS/Uzks43LeGHsbiCDCT47rVKYgl4oEmm9sT6mT6zNwaGaJy4/LlzXahJ9v8vxQqJJN7Kh7TLw4bJJWLtcDlQ9j5Ez0YnIUEUcioBDwGq1/os6hJf3bmibSj6viH0TOcnhn38xCcr/E6l405PqUgVsz6D4FATTumr6n2MDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o676g9aBnVUbDNobCs1Bakfbgep3HSLh9e8GPmRqNlM=;
 b=3A6XlOvBFVYLX+M7lfaXSu+YGxBDT9zXE5H6Kipabx+4CwDe+2e/D3hP7obk9ORZ1uiY5MHOMOPcdbvCs6z3wu1pFoZP0v2C7gNG+Zc1j3kOVmJtc2KZdmKoV0mzTOT44YVLK4tXAHPnAQ/KI3RAdY7Lx60IYRMuf7AG9QsQ9uw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:38:05 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:38:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 13/14] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Mon, 30 Mar 2020 01:37:56 +0000
Message-Id: <b5ac53bf18ec30ebac36884d21a812fbdce63549.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0019.namprd05.prod.outlook.com
 (2603:10b6:803:40::32) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0019.namprd05.prod.outlook.com (2603:10b6:803:40::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Mon, 30 Mar 2020 01:38:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d314986-d87a-4f18-6256-08d7d44afe1b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB138794C9CE980E9DCE533CD68ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPK0FxuzJthtVwRCrx7wwCxQssMikYyeJn2ISfg/vnTzGUZ0xK8Wk/NrPVhiQS2Nan+C8A4guKuM8nBipiJ6ANJXbTxCyHEDz2/tcSurKp3tXjHF/cWmFzdKVYhy4d+rhV0afKW6iXxNbvDEU5kzMZf75vKGeBjP+/mqxy7N5r6ZbOEPQjmBtXY986jCy4zGpHav9mOhT72ZGc4rTHBODnpxVUsoG9RuzSVo5bmZ8wnzeOuueHBq4B3+TXhZJvjK7poV0Bk8J4jD/E0CruZ4G9+ef7ji0hNifIftehJgsj6azAl2eQrbSGeLBtpqQRX8KiRutHVN/c5cqpQ8kW8F+Dawiuu2gxM6emXCbR0fsMe8FjTv33VMnPCuQoxTSXi0kflCXgZ1lnC9hy1+IwgKMrsMnVb3+0C4E09xguz/IfSYqCnIgDFFxN1g2S5XvqzV1FgQKiPf83JXUik2Vqrne+D66DfAWqptkjQ9dQTln3p2HV6hJgOkeu/ZlhlGxQn4
X-MS-Exchange-AntiSpam-MessageData: BfxoRhZBQcdf9uRrws128kOFZ9Ic3+D/rSfNL+YKfKoKQfFRLu03S0ROOWG4z5L++TnA7hqTEXyHbvhhaCRxEGMloOXAUZIrSzMKKSvg4NeNwldUzxXWtOvpm+cyUemTJxEcHo59FDwjlXYwfi9uQA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d314986-d87a-4f18-6256-08d7d44afe1b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:38:05.3739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Up6nXld4Re5y4A9ZLbreAfAtl2J70jE5GGAixQ/9hQifCQ+I5/yx1eaInXG6FwLz10wgPftcu53OOZe3UjhEHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
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
index d74773573811..8c6839a97974 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7632,12 +7632,17 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_vcpu *vcpu = kvm->vcpus[0];
 	gfn_t gfn_start, gfn_end;
 	int ret;
 
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

