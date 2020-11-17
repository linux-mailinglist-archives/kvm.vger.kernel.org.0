Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06492B6B58
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgKQRLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:37 -0500
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:62158
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729507AbgKQRLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MChXBBhBH5n87S3D9xt5i+CQ50rjyOK7zeCs6ZjkKwmtFCDRZNffwfP3+Fpubra64tHMuZ4ojFcBNqxuLgBnrj7EB3TaplNsAjyukJjYiJ8/vlnhXtqAIKO33ytC9wROjjiuOi95hgrxe3baXoMqfhIz1NrnnfTxluslArri1BeWcv26AvLMN+f2J8sESARCjBLxALKk72EbnlAcxnnVHbeJKJQlDBkMQG9vEGWXamzGoDL9pU2jmaz7wNU9fyxCeX3S5p6fF7vXDXkJzgU0q/3ki6b6agc2ysfZtm14idOzqJADQMKbRhxSV/j1YYwpP3Cu6wY7+Sc0m6u+J4aLtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s4gHbxKgncogRlR/VpvQYV14CkmuxR/vPYouEqrkV4=;
 b=K1VoZ5Yl2UT1zNjKa/3bQUfSx6vzP84FDeDxVz8Wy+zyKDbjyoTY1OnS1NimLhARGunscVTtPCO4ilbAfjUsuiLxYBnCe64gzqr9k4bL3+bCmUds0FJ6BaJo3/yQSfpAeD2P7MdECOXSrs4094nYw4ylTagotbD/7YL7SP7aKmEMTtkazPFh/Hn5+u1DuxtzsV0VA9NxneqofFQVQeNi2Xh1AKbMZ8dfOyipRZl6dJW0wO23vb5HXLCUx0dH9HfK3JhEP2d1BZfpxoDS5Sodo+DA1VuG+1FFolfvVTLPPIp9VPpxJcaQQhIZCklLSa3sHYQZWRml440FWybVnttwyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s4gHbxKgncogRlR/VpvQYV14CkmuxR/vPYouEqrkV4=;
 b=C3eXltmYRlTdn3kXTzKoJ+TO38qEc6YFP+nUZ0p6EC01GdGwE4aAnATFsZ4T95Vi3WJfJo01q42lQHbRh8AXRgiWOFZWm1l3ycTkMkgnvkAVcIKOpWEPrx6i/m5ncY5RbPlviHDPWwYzvpSHjZ8GZFWqyJeBf6upnhYy4waXIHw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:11:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:11:30 +0000
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
Subject: [PATCH v4 26/34] KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:29 -0600
Message-Id: <9e49532e433b61558e53230aaf82495bf22645bd.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0801CA0020.namprd08.prod.outlook.com
 (2603:10b6:803:29::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0801CA0020.namprd08.prod.outlook.com (2603:10b6:803:29::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:11:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 073ff9ec-32e4-42d5-a9b6-08d88b1bd388
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772F737A08864C2E80A2FEAECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //pJ/3f+wn1ko26C9Y2moWSBp+h87Xlre8vI7ddXfDZb0z3MZ7WoMyyvuZrHw9yQNAWWCe/6DuWoBjKotPTOMHsvkpK1SzEdNfNY0i71bQ1a26YVKqa9Jw4SCIwVOFhIQydEgyQvWPU+DT/WHTC8pXy5oB9fWM0wDxXdf/2o+65R1NkYXijGKn1Z6pb94yjCaQETz43yZAGcrmFqeb4N8MwEEHgenrcx+dsyKLeSqr5L+/u2Dx1lQm41AeGHCFcKNNtAHQ9nf3iboN+AxRDyTfruRhJtwvA+leimm2PZ1Qp+lJQyzVby0zoyiWJ80WWLa76tr544nK8nT9/W1hQjiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: chuo0iEW8anw1FzwZhfV/zBIHxV1UFIyuRlTaD6J6F/obiJwCBdEkYBKrc0kQoWm/jAzucZlQKzWu5Vu48EwNZynBSK1LC3wj4tJIXqqmm5+12K1PYTzkEOwHhSvaFjcox6u+H0F8gmG5P2Whoj7e10glRUBCF+YDTeqioGRvsvHvupT9yOd5YTe4E/VtdeyR99vDvDBtunhwIYcg2ML+zNwroZzOtJWjgK22eAX/6ueoJh6ZttYnVvyOp8e/s7T5DFUD54+wAgxBg7WNItYja5Zfi/ARao5lJzndk9VpD99pU9/8Z1LTlxcNBelZnbVh/6kgMRioP0gQjsrwt8gMCo2QMVEQRd+fQsz9CiPGud/y+nNuCQ7HI8szezT4L1Ae3CFgTQGddDqtRy0lgkFlI0GQqg+/gv2VVamRDQWqsI7x1xTPlz0Lr614Wwmnh+8T8ysUMApGvY7OyyGrN/4KFLipCSMpSRO63sNAiFPXiLHX090AM5TdrVP+/LeY3LCJBYRADD0Uww9N6hvBcwDAZXj55jmAWgczLm29kIEVklKLsRuMldQJHUxD8MOrTzDtNyBbd9UH38v/TpRVz3vZ5e+iEhsuoKPqcC4vkRjsbtPJI/hNipWKooBSKEvXEgpUPlrjvJDo6S7Cbtrn3KWhg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073ff9ec-32e4-42d5-a9b6-08d88b1bd388
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:11:30.4061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0o3PSPpAEAQIJXNaX7MXYhE4EYnG4jPGARpVwOfhSGQI9RuQArltTHio9BsueNk8mXftMynjMj1e+FJGsMalw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The guest FPU state is automatically restored on VMRUN and saved on VMEXIT
by the hardware, so there is no reason to do this in KVM. Eliminate the
allocation of the guest_fpu save area and key off that to skip operations
related to the guest FPU state.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          |  8 +++++
 arch/x86/kvm/x86.c              | 56 +++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 51343c7e69fb..3ef63ab71701 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1473,6 +1473,8 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+void kvm_free_guest_fpu(struct kvm_vcpu *vcpu);
+
 int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f68e6284c3c6..63a609a8abf6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1317,6 +1317,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
+
+		/*
+		 * SEV-ES guests maintain an encrypted version of their FPU
+		 * state which is restored and saved on VMRUN and VMEXIT.
+		 * Free the fpu structure to prevent KVM from attempting to
+		 * access the FPU state.
+		 */
+		kvm_free_guest_fpu(vcpu);
 	}
 
 	err = avic_init_vcpu(svm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ac0edecc5f9..27b9243f2f68 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4494,6 +4494,9 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
@@ -4511,9 +4514,14 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
-	u64 xstate_bv =
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
-	u32 mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
+	u64 xstate_bv;
+	u32 mxcsr;
+
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
+	xstate_bv = *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
+	mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		/*
@@ -9238,9 +9246,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.user_fpu);
 
-	/* PKRU is separately restored in kvm_x86_ops.run.  */
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
-				~XFEATURE_MASK_PKRU);
+	/*
+	 * Guests with protected state can't have it set by the hypervisor,
+	 * so skip trying to set it.
+	 */
+	if (vcpu->arch.guest_fpu)
+		/* PKRU is separately restored in kvm_x86_ops.run. */
+		__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
+					~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -9253,7 +9266,12 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	kvm_save_current_fpu(vcpu->arch.guest_fpu);
+	/*
+	 * Guests with protected state can't have it read by the hypervisor,
+	 * so skip trying to save it.
+	 */
+	if (vcpu->arch.guest_fpu)
+		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
@@ -9769,6 +9787,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9789,6 +9810,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9847,6 +9871,9 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	fpstate_init(&vcpu->arch.guest_fpu->state);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
@@ -9860,6 +9887,15 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
+void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.guest_fpu) {
+		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+		vcpu->arch.guest_fpu = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
@@ -9955,7 +9991,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_guest_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 free_emulate_ctxt:
@@ -10009,7 +10045,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
@@ -10057,7 +10093,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
 		void *mpx_state_buffer;
 
 		/*
-- 
2.28.0

