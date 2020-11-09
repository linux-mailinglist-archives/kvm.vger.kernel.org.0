Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69B72AC863
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgKIW1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:22 -0500
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:20363
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730647AbgKIW1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8yPoJdaV5OkTmH3R7FhRddGXtlxnWcqm7F4n7nVn/yjdqpBMNDE9w6sT/MBPsMcltj8Y49g+yuQcH3d7VCVoLtXOUjXi+ZmKFOlTXuJAQpit+JPN46NnIdMut1KcFKG2sbkJLl0ogykOFje3qkrruPhETrMzV0iZk+bwBIeTxcq5xUUnNxLfUM/8eFRMdQ9BurbT8NNCWEnhy1zO4QzvPtFyUA5ksUgMplrz3UE8Z3c6w8sIpRGoIRhseqmr+C3R+HYTsZov9jN9L2KRJQT1drTGMiGItW1e1ixJ3OUM8Dj+TjouaRRsS5SMfsPK1eNwUyzRu6/DbnZK0ctYMMiIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6XKK5knHG3n+HFC+WTUWLA+DRNa2OYCXiU9WPJ3EU=;
 b=Kh3cAGFOQGww6TPMm4iL+onLdYnXSQlUc5bo6+qXk5LiwcohuBCSch0fTHL5QtyedWtogykjrDizjt6T250TM278Dj9ceoB6UzFnVyUTbpAj54qDknDO53I2syy3T/FDFYfl7AktsNnT8GrAli5X5gV0rL8Cn37Gbk+MF/D4U0uRuGBMJcGgVbodGA2CIZrcOCC85uFdb/fUwi9CkBIKaFzdYqRAy6o50Iky1FAbpBkdaNbp37xLJqcTv4HyT/4eqwmTcdnZmP2ntNv0FmCDcELXIIu8dMgKgR6jx7z8COvvWFc5pfVXKM1G0+/hkDIPGtau+sxIKxhnxk0d/ZhAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6XKK5knHG3n+HFC+WTUWLA+DRNa2OYCXiU9WPJ3EU=;
 b=knUTvscQfhow0cyvS68jcsbChiv7NFAY5IYItCn52nH48/5MhFwzHND8fAnDUHP65jznXnvUHqOr3Gz9qSzCFzVKfKjpDFHD/gE9c98ezSv2XJ0WlKYAucgLIPbG2TB/4YTBXKcfJV5DOa0TmQIIyEDh9jWNe9eEV1poUjjcdtw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:19 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 08/34] KVM: SVM: Prevent debugging under SEV-ES
Date:   Mon,  9 Nov 2020 16:25:34 -0600
Message-Id: <c06d0df6d1bd06f9171df8a42d1b08b5911d39ae.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:3:5d::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR06CA0038.namprd06.prod.outlook.com (2603:10b6:3:5d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f22a06b0-2703-40eb-48d6-08d884fe9e99
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40586D3B280D36F8ADF7E333ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUvDGgqhxw3PZGZ3+egrh6rPkYsoPdV3vswcaylzKD89xYn1GPGadgkw68NX+5OB3QYW8O225L195wVvLxPAcNBlmOGQd/lhi6FEHKcv24Bn76Sm250QiBso+5OWYkG7/X/PFipcRaQJzH4qWDqQKJpBBpCG/1Osp0HceEPscfE3wQxyxTwWSRNDt6fjvIYMk9tYAwnm5IEke6vL9t5zCYABJubXOhjykBtUrvw5aMc7bA6+2pRsyyGT9r++3aTaWk4as8UW0q0cZ2+dXhmOJ1dNO/X6Rsg1fa1lsMcCxKkV4rSLHBJpXdHjTMY+eyNPw8uTDzJtURaGeCfTW/KNHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e9AS1IBBYja9s7KQlj3hvlflGJvO3/t25SKPMrTpl2xF7IDWByReXtrZpnbJJi3L16lX8T2lka7m5sBonBly1+RN8ykdBNl6HoH7WijTGFAg1KvmyKIAgSPSqb9YcewtO2+63DTaYpCuFsujPt7m3n6lzYScvASEdodOb3P5tNohKQUiiWWZgyZ6WrOF6vhIio1akmtVOIAa5mq+YcRtiVmC1dyGg/jjUoNbbdyurbsUZu6XT4VPCYG+A+E14HfKC/h1asGfkDdRDMVFm/Ae7AsptWeAWZ/9WV3gzKFx6P9S0x4vfxY5sUromTzbENE4UaCGFeQKiJR4OE7eXlQoLZkhtrsQd/klGG7FO4e2MCDDvT/087ms6gP1Csx4ozkCSAs+AytyYTPF1F6bvvZ+tglHfH/dxc+tBKLZWKJ4mfUgVyv1Pq/ayEfhUfyVOojx6iFZ3cuHZKBU9LNlI8MTzYrkLqgtk9gV20pkldlxGC4uT5yy/iHaBt8jd9wL3BHjzd9sq4xaxr+JDozxpkZ5YaaB/6WHKAg/mjN4ybLLyOdXR/7MhGMW3io6A8VJLs2ULfrWTkmjmn03vKc2z29duEEvSIOMLpRqQIcu/B2Odd0Us0AoCET105idX6Wgm78Z4bJyrmZF0faGNLMHfJF75g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22a06b0-2703-40eb-48d6-08d884fe9e99
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:19.2099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkKUgKTNDiWK/Fvr+h7CM5TZW3YfBsbTXtT7dR6UL+cjoHwZiUF/j2rnDn91yhW1SJ9tGXBkx9bbGI5GdnLdSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since the guest register state of an SEV-ES guest is encrypted, debugging
is not supported. Update the code to prevent guest debugging when the
guest has protected state.

Additionally, an SEV-ES guest must only and always intercept DR7 reads and
writes. Update set_dr_intercepts() and clr_dr_intercepts() to account for
this.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c |  9 +++++
 arch/x86/kvm/svm/svm.h | 81 +++++++++++++++++++++++-------------------
 arch/x86/kvm/x86.c     |  3 ++
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a3d57ed997f..7f805cd5bbe7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1802,6 +1802,9 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
+	if (svm->vcpu.arch.guest_state_protected)
+		return;
+
 	if (unlikely(value != vmcb->save.dr6)) {
 		vmcb->save.dr6 = value;
 		vmcb_mark_dirty(vmcb, VMCB_DR);
@@ -1812,6 +1815,9 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
@@ -1830,6 +1836,9 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	svm->vmcb->save.dr7 = value;
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8f0a3ed0d790..66ea889f71ed 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,6 +198,28 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
+static inline bool sev_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev->active;
+#else
+	return false;
+#endif
+}
+
+static inline bool sev_es_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_guest(kvm) && sev->es_active;
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -249,21 +271,24 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
@@ -275,6 +300,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
 	recalc_intercepts(svm);
 }
 
@@ -480,28 +511,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool sev_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->active;
-#else
-	return false;
-#endif
-}
-
-static inline bool sev_es_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev_guest(kvm) && sev->es_active;
-#else
-	return false;
-#endif
-}
-
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3aafbd2540be..569fbdb4ee87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9663,6 +9663,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
-- 
2.28.0

