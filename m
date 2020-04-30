Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87051BF354
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgD3IqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:46:25 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:14689
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbgD3IqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:46:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjBPo2nfDDYGceeUL4cVe7A8yWoBNPBiDXrdfacJlv8lQ1Gz3uM2kw6TX63IO17pF/CUGzR0jzXAS4zjdJYuitQtTenCtDqdwDFTUnSYx9lxDXmSDd/yp8ypZdtJgDiwXtGr6MOj68+KtgoFC5f4cjrZA4Shn8bIzgyYQvrNI9TaqeiH5CTAn1muIXMNZi4AjPD10SAWlVZeF4WgIklmQpXU46o/R+4eVDk/wJva9ZiG5NuOFfMrBJ8Ly/MGNgyZKy50UBMRaUO4FGc1zacNTEQn/UxlvUDB8oifxkCHOh4I7GCsBmb8QqgJDgS5/9ME9Xyj+llnwKHEndiP/26WrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hT8CBOMYv6cdJeX95Ltogepk0p3OUE0tkeZ7OuWxJ4w=;
 b=oWzuyV5A3t9ba+S7GNt248wUquB565pipvj2Ttep8Ivs9vtDY6NaZ+ccbM2IFfW3nuGw15d9chgpxMdXFzZ9JbgWotZkTcTtAOvWfo97kWqLKMdALtYWLhdJqI+dIAEa1tkY1RtqCwyii8vQYyZBDX0SzG5CaODZ3BbJ6+otcn58kzDcXaX7F1dAI49thYzxr8qTudWsahJJF/d4RyK4Heo/koXKa7LSmFmYIBN/bdT5iMq6j1Vo8LitiATF1lvE517eLNdZ+MqCh09NMA3hAgThfWSFhkj/u0m3vvtXBTZkcqm4WIftyv7rUCmFM/avRhyjiTvUfGe295EPnN33OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hT8CBOMYv6cdJeX95Ltogepk0p3OUE0tkeZ7OuWxJ4w=;
 b=17AmAffWuqX8+0CmKdKbKeHBh1LCaD4qVsYI+UUOJvSZDyAB4k4hVPSK2CMTRLoT8G5xhrNtMHZGfAn2OBW87dAXjoIxRB+abv/WLpsO3A6d4qQYOM8bul+SPtzS/314ARsNhlXFif2HFv7U1T1aVwx32DmiYKB0NVw19O0Cfd8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:46:20 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:46:20 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 14/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Thu, 30 Apr 2020 08:46:10 +0000
Message-Id: <17482f099a66e4eb3533f79eac138725c3945ace.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0004.namprd06.prod.outlook.com
 (2603:10b6:803:2f::14) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0004.namprd06.prod.outlook.com (2603:10b6:803:2f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 08:46:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf05f6b7-1f89-49bf-3026-08d7ece2f421
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB146547C0B164CBB8D5FD2EFA8EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTLT9G6Zkr3sYOKuN1u5Pb4qT9owZPDLT0ySAzsuYz4Zgl2JiGMDY6CWNDPyoagHuyE8dYLtm0vbu7c9HdX9VQWnYbJP5d3shvfNKJGzkvGjiAehjvBMxdUqQYnA/aj/7nex5M3zrtmnfMCAAojlMA3nWGKma3cPseFA8isNj2doisuPGQyfZ8VZ6WyzgLKoeCx7eUEb1tmE+IUTJOu1XcpkSzUiE2Fu7+VBVIiO4IaXiBoGAX42WlUGMn5sHf5kJ9dmPgN2uIOB+Z0CJqVQbxg+9mPuzzLjutE0wKHwLBcxWeaAm6qZ0CN6DaN9OwVe/j7QvzgvOdANS1Gh7E4OB6ReddcdiYOL0HVnTIiPCXJNBE0vyht1J9qfifoenjFfCOyT4YgD9CFpGdzZPQ83ZCqf1z3SwICFCnYProvgLVP5BHTuXT6K+zsulh3IN60pQGI4DFVkRkW4KBmjbrCvyIKxeLDlY67Zgvwzavwjjs56DSIJH/6jq92d1imgpOnB
X-MS-Exchange-AntiSpam-MessageData: sbrMfv8gzViQoRlQ+UkuRwHzURW0SiCCEmt54HShL0PUaRUtFRQypSUYCgWgnt7OVVSbTcfEiBEgGvbxgXQZ5Mdo2TCCCh1BT6+ZJfSPseiv42yGKV19AFTqSkhB0cHL0CyUOTRFdbh+w0D2L/1m90NwHf+GZVP1hT645b8HGXBiEy0wm3d5xLkGDCMeeLJC/3u5HZWEcf4ZuLL5MlOyCSBTrdL+rau0OJeJspTejGmj7uClHQ6Y4/JKADww1K4Y0OuZMgCJpb8EoyqHrXn+SlIcp6YNxX8xMyj5hP56WjB7WHvfq7ijVZvKvT6QyQa96GYiSfVx1VAFvuNk3XYy7W61AG9vR5JrJYhlWbzI3EJKLZEm/7wv6SNEfpIGxET+lfZazOMfrHU4IYOc7EptzpNu4o6bBxyZ+9e5YhIHqAYaZqqkXTg+k4dEp7zvmuPI7hjZ1b155s8ALrW6SMtykcEHMuewB1AmZUDJjnlsd1PxzbOteWPgjyudIQ/Wz7uisEmxB6P/oQJUnK0CE4BjnPQ7cjSMWBoFIzs6cNCdhCT61FgUypSsileRmcLiBgiRHgNhCx+0gGtEzva51YKMxPHOuJaxqqJq2QkrhwGUbuhlap7VpzyjCYtSW4MmV8d2Rfpe+PwZ+yMsm6dQ/XlprjhV8/vwBqW0mQWyZaaeS+GdALzKmNP6Y9SoChBXtoRK0OTLVIje+PWN6r9MimqTjEczB9pzpCdz/bGGzEWWEXmkpqvn8N5BTbwQuZfgNSCB7QjWlkBYvv0kRrw5uFVhSMCY/vhz+5p3CmPYa7sEKOY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf05f6b7-1f89-49bf-3026-08d7ece2f421
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:46:20.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +z7t5btL06j6Ssm7gbMGY41+497yKfz3pU/L/JCTHlXWmxJPc2jqmvM63yPfQ5dTrlKFNNeF8x0/FJgUFlGQNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
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
index ba5ecd1de644..0ac82e4aac33 100644
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

