Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4787D281896
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbgJBREv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:04:51 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388358AbgJBREu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:04:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzDP8KHUWpvs74rPNQF6KjFR10DqreoV7CYpBYw594XDyeYudEDN9H8u8Z/PC39v/AtcxANEj477OfSw4AL5/AWwVKOW/j6awBfyb8RAK1mbwTERfEpy6vjVsq1OqlQ/iEj9YvC29Sgh2UNnoSP5MIxR7wzWRlASHul97C4KcA+SecNBgKVDwu/uzwpuVnJkBT8IeUFoUd/Ov6Bm/RWJNJTUpTnEyDLc2r6GJNN7rdOpNWwqNlUjJW94tbad0MaiUm+1sAKV1vY3vIc5omh7th7TJD4RJWh8Kri0CVMea4dmc30l37krxIIwkQb2GCCrbcT8sp0igh6doZ8zwVGUkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHe1/H1R9nvBZURCgRxtN8uloVcUWuswUBY+Km+KqBs=;
 b=Ayx+DUGwrw1eIMHYCAcNknASU7zTDd3Mydy2biyypaKDStlfYuSnPhIuPkeAyErGzO6ttXbP9ioyg0cfmsUm3ud44p7jkiHIctSdH+bvJr8cPx7ufRn7WDUNybUbcwVOeO1X2WePx23a1wtBEmxADQDfckwgYN06XNsLy4XcYJDn/D6F/LMNSaNKr4K6Ff4p280QfC0BIlAWH4L6pr0L2/hlB6iBb2suj7DRapXMZ4ndTp5FGx7guvm3VruRw5dL1T+gyPQcvgG8isFlEEWALO+xI29GGxO1lYRq32MlBIUZL8B60xA7VbwYc4ol9nLB9M+ZGyXboNKY+8SnXhAd1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHe1/H1R9nvBZURCgRxtN8uloVcUWuswUBY+Km+KqBs=;
 b=mXC77w7oOLmUggPP63Y3XT2rY1OD1dfis+oP1xIxOw2BiVGUtzjndPxUXr+0E0IZklHuTBjg7wy0gCiOQm74kGGbtYVJ3FpiUCKjBiwxpKJ6tO0hdlJopfBCrTCVTUTrTkaKtaoPXVKKWUumSaQOICmVz69UzlJYYvBrKWMIWAY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:12 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:12 +0000
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
Subject: [RFC PATCH v2 07/33] KVM: SVM: Prevent debugging under SEV-ES
Date:   Fri,  2 Oct 2020 12:02:31 -0500
Message-Id: <c11bde239b08b184f4c4a7306424da1d26dfea20.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0023.namprd04.prod.outlook.com
 (2603:10b6:803:21::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0023.namprd04.prod.outlook.com (2603:10b6:803:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:04:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62e5ad33-8b69-497e-e427-08d866f52f96
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB170692C07943D26408C0F8F6EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8JuxmHdpsuv/s3sZFIajmJqLtTwBVkHuktjb90d+mDhTAWDSOVcsP3VZ0ZvE9rJsloJhOY1bRPzxtp+M11qGDNvlWIC/+ABBXMIOLcPCrNAVaDZclP7MI/J2ej6oPnyogND0AjyoAYdpZWu7XQb0J6KCWZyY5FKourRJ12jstSOrLygR1n2WcTZQk+2dmC0O4agU40l6jtUJWJpEZaskgmQhZDyVrEcBdCUo9/nmI64jqqv6iJee24N0BTB9mEp8gTk7ZEAQk5gptgHuezh7zaIxCAEwXIaBrKq4n7JP2Rwt3jBGp2FFwWobZcpSt9l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VAhY6IO2rlfaxfKC4iyf55PHcruTgrV+oaHEhAA/9kp6vYMpU3kiQDDygLyHxxlZzFZ08wTUHD1DCgs6BpgRZ7rYU69+LZRKfwtBxsrHgIN49xGJ6YlBJXEFemG0AoDusLMlR3m5rKqp0GYdqIfGu+ZT3bVjsrAXMKgcHbD5E1mfCjK2ZRJgXFxs9eMd0LjsBxdgc5p9FM6eqUeFCRrmrBPRGbnb+f5cdQgN1zqQPLoKVb3Qknhr99BpV/nfIVeJj/iLuJlKM3xJc614OENIHvgY9sS1ifAWpFNH/HdLXK9T5U+bTjzGW+cw9NglZfECFGGmHhWG/soEPlAAibgSRoPtkK0/JIaIm+aHuUrJmcdcL6KchweGlRhKG2wJrQvxA8VcC3OaSulTyM9srkhpBRVkY5qLNnisY+bkJOxJb+NBDMOnQ32B/eaq9Ifrs5FBoKlNu80KjU6hQBFjq0BN9N5REOT0SkhRY5I2gTAswEQ8V9T/ccw2GLFyTy8PD9EvVVtSFxqoIGoQw43u+zuunHSCswUrMTfZ+ki4ODH1vVgBTa8eqJHKZOhid5o4Hh6Iy3E/+NAxYXeTzbPxwpRxKc7JNsThvCAI6fyOHlJefwdq35v4wLyetsuH4wGXIrO4311CeOXQZNScgzgEGByNYA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e5ad33-8b69-497e-e427-08d866f52f96
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:12.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIVZC9YEs7QtyfTVlepPJ226MdhF7nF0Sr7nmKD2sr78hQJwO91WsRmelktIEX1pnu8P7H5Y0qIBclLoti1wuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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
index fb0e8a0881f8..5270735bbdd8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1817,6 +1817,9 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
+	if (svm->vcpu.arch.guest_state_protected)
+		return;
+
 	if (unlikely(value != vmcb->save.dr6)) {
 		vmcb->save.dr6 = value;
 		vmcb_mark_dirty(vmcb, VMCB_DR);
@@ -1827,6 +1830,9 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
@@ -1845,6 +1851,9 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	svm->vmcb->save.dr7 = value;
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 09e78487e5d0..e6900c62f164 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -196,6 +196,28 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
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
@@ -247,21 +269,24 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
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
@@ -273,6 +298,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
 	recalc_intercepts(svm);
 }
 
@@ -472,28 +503,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
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
index 08812eb0b73e..6b9125f49ddc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9550,6 +9550,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
-- 
2.28.0

