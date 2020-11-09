Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0822AC88F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbgKIW3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:40 -0500
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:59553
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731104AbgKIW3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMtAWbVZW2qcwP8PGDxuf8Okp57ZmWf12yCqbAez8QDBFOxLtskwDMlYsjItsZBAjcrZ+XSN3ocxTCymLxYKlUVXvioPJML58ZcYPQrVei8FEa8BtU9IjerjbD1KUkLyJpVUA8ql2AVjyrbcPSylQEAspWn+3j9e6RkCX+Qd33BOgIWX1A7zUqAEEUBj4yrMoR+DM9aqPL51ylrQc7t+m5yyPoa91VPLFs1lThH1AyJUgDnNBXK7Bz1f0yd2VGXbGflHxroQvl/oab4+inxPQY5jvMEPNjBSCkiuDx/YwxIASjTC3mOnj5FvUQo/XZbAhE1QwVmv9N9BmfJbbr7x6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xU4eahfyZ4CFi0EhqiPF9Sx0rFNN64Gjp+M+ePo7qg=;
 b=UfBcZjWCT92Sj0jxRBZ40WL62lgoQZLcvA9/jGYNQ66MX+7VOxfI5Vvp2mPWPvMpKmhuk8P54uO3aYWprRB/xS94o1RLpwKweWTN726BZNPilna/2XVLGYA7X9qwO1XxMTF0G7gTCqKbFli8TA4zy2C01u0E06QpSiPURJ1Kp5FnYht22N8YIwDIcLzQlGhDDWTlN6UUp/5eDBHYVgECzdA15hKyi0qR/3F0UeiuJzMOn0hTJ3oympR80uYq+8tnAP1W/j3KPkJ+uomSkJrMGF4XFm77D3oFUKJm0aPDxEEU/JvB4k95M6yqB/8y2v2pye1rhyr78woHT5FfdtKbHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xU4eahfyZ4CFi0EhqiPF9Sx0rFNN64Gjp+M+ePo7qg=;
 b=TjGfXxvdZ2jimlXr0qGitPS2Cdr7OtB055E54W8OdRW6zaS8zSBTOiVmshZt5F9HnJs5cMkcraVLpg2tsDhz8ICndtoUUG5BZcjEWO1s3nZo7CrI/YlrLbq69H27vLm0wE35VO4gA2qwOlFJRrtAJFUA1Qsl4fNcgmjwNlwrJwU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:36 +0000
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
Subject: [PATCH v3 26/34] KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:52 -0600
Message-Id: <579db8e765d66dddb9546f11b5917880073ccdcf.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0002.namprd19.prod.outlook.com
 (2603:10b6:3:151::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0002.namprd19.prod.outlook.com (2603:10b6:3:151::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c615b069-68e8-4461-6a45-08d884fef0a4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40580B31AF218FB1DC82B2A9ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZZt9zK79ZS2kxXzQD9iYURceF5TdP5Rj/0dTt5njraKSl9en5USd/XHOBDU15tbjq+CU9+pZ9gcVvQhryJksAG8l8LuaXG4rvUWh0pjmEST/QBGFi7HyuaWmfVcOGQt6BrCmreEbQGSoiVl5DHSldXb2BFmB6VyqDu/pBOPwyw/RqINyCYgxJqJmsubLAuDLj5/6sKjPtr40goMQTdi7Ijg4+IdetV1LL7Kx/ZyHqI+9Ri2xwbdsY9RMVb2Esu7Seys42lMnfP9Lergd2Oke0SiVE05KOS8szNB2XQJx3XxXaGSuyu/sDV9VkXahjUkiFuq2IVbhtkhRb0MB8lJqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fo0LU7GHHeyUFlKaIKRWoVEijnZDGxkJz24sHNh6EcZzvfll2JeA31vkS6F8c20HvVg+qKzE4S+GeZoZXuZJnO8sVhIdikB8R0rBCGBSojtQKmMb+h3CxWbzpuy51AfSzJZxHfcV8bSQtqbM8aFhnnzewTrihCZNgOEoKvlTpufOrbE28CqSfCu9fnidW97OqN/1f8gAZSbpIk7C8g+soajO3Dk9NYFC4Q78AAF4Nb62a80uQHsnNFvdF5qnc+1l1+CNfK3GKFeh3R7Ld2BVETxUr/dJtAKMyr1RPJ7lx0KZZVsejzVwlsU6jD8EXfyvwhhmwDDghgHz4CiJ0qYs00jZGKn8njTMd5IvG2zCVeAuAm8uOjgzOWfyQtakkN0DmOG7L7u953thVvqaLgqw2XTMAHJFS1aRMt8X7Y2fk6ukrsbkVR9e3qiGw7WNQ++a+2DYzhPB30lr5tZF+2BBpnZ+ZyVFMAAxBAGXCLynldUx4vqRHFMuUAzMnlb+wANlx2J73sI/fBmGu3tLOLgudDQ43EKCxt3fG3FYZ1xdwyI6g0ih6V6kcL0QrKjWqna51lysuXgJt5E0TZbCxF9yXnGyiceTTNc+qXMs+8Fu6MCehxmEqVzNnEwaCulCW20Ct4jGV3AH4+MIE30SxPwP7g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c615b069-68e8-4461-6a45-08d884fef0a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:36.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHRe+jDWMbt2F4sObVKEytP9u9hlr9WvJL6uEBNvQVG966UBqdOqXgAStPSl3KrpSjFvfLpU7LCllx3hE/Fd8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index b8167a889d8d..ecec3d872922 100644
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
index aecd931f46be..c0a33d5cdc00 100644
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

