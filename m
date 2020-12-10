Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3186A2D6386
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404173AbgLJRQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:16:33 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404165AbgLJRQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz9jRXyz6nSO4sQqVazj3YIa60thpyVE+Pxl/vJtj2uzesdeD4vsZRZSVsrAbWxjJGi4pAPTCOkB1VEzjACfCeefoZ1L1eK7tDKFiw6tBtzcg/YaUi942EWHuoJwD8xMghsayI4o9kLy0LEodceNpyzdBK8o1jEwTSGJC5dkNmgQq551/7V5CK7bKR/3aQPL/lgE/IFcYXYYHlpU0NMRtXHtStbMstbV1efGH0682IeBVO0nYGsvLVw/oXUu+3ace+qSZo8c2FvGUcEv8PSFL4qkJulQnS9avV7aqxLM15hUzBiX2sTqYGQZ8NO0HowbhC3QmpSvjoJUg/o77JGuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axStllGh4c/BRI24N5KHMZrDmw3Zg+lxIF1p5Oijng8=;
 b=Uf9mJXVaXoGLGi1827eA7N8/EekgqpLVzMo8ipctC2Pcu2H9Ti9JUtKlVkrVz7gZ9hPY+Y8Xgd7tFK0s9LuOY6TsgEsHxVG26GXRnsCToBAb5RaXARfzfQWdfs2Oer+HxtxUTk6iDe1Kpt+oOHTHRhYE06TYP9sE/R4jmKVw1feSi83hAgQQ8GMmQT9OpKXxwB4vG3JgWpoiLSnYUb1MSI72EljwJM8zqIVu8nPk6XC8Fq9pYQdnEERrdDUjVv432AQVyPsj7TKqzoW5laL9IT15IreF3eSR4dVfJHuRLNtHkMNbqNLI6ngHU+CQoS4y0te/P5Gdp1CnEQ03w5ac9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axStllGh4c/BRI24N5KHMZrDmw3Zg+lxIF1p5Oijng8=;
 b=4So3U/r9URcxtN2LGFXE7kDpZrwWkfQFZZ5dOuRbJztSD4Ij0eQvWth2dYtbWh6bGdK0u+5WhluekPta5DNtbE6kUeQThkjoS/ZB67Cskpjpu8uJOrKMt3/JHRurwKJWMd+s0ITmgQNje11gmaCTNuw5YuOOQmmPyuR8vCD7RtM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:14:13 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:13 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 26/34] KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
Date:   Thu, 10 Dec 2020 11:10:01 -0600
Message-Id: <173e429b4d0d962c6a443c4553ffdaf31b7665a4.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:610:20::39) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0026.namprd07.prod.outlook.com (2603:10b6:610:20::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:14:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3cb60ed-c9ce-4c35-0260-08d89d2f0462
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014954CB6D57A61526BA7FBBECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/HAlJUWhTDRwFHe7EiQv49LyAEFkK5QgPnnBOSdAftRAzBgoyl7L5A1MN+4QAfbl5xF9v+AjfQyvmi7v82OGj4Ubw3c+Qwbw1oJALEDOul54Yucbghwx4hyM1JicGcXmCublgi9T7KRsLHWU7ky3Vhim1sy9wv42e8nsPK9mrJMIA6GjKaQgyrhsqXIzNWdVwM5rUrchVhkMQ5YrWB4JQYn2Ct3dJnGo1cv5O+sgkGOGQ2exOUdJgPGDDJGa2NW2SDKlckYJfb6byklmNYO4oXJreVbWny7RRDeM1xJhyees/5NBYO3AhQBafyvGipel4Jgi1EyiSgbcJQSAa4ylbcH7hXIEmsp1wYZYd/GzQSskSgdxfiRK/C9XkhcJfmc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vkCxZ96X3fgyuA36O5njn1e55Xg0XDJHxCJuDHG+3VxLYHu/N+1i2T2mBNDV?=
 =?us-ascii?Q?HeK/TQZQLqzMoQf4m19v1KhO/1BOFHMZNqmmvL1dLNqxEUaxPiV+mX7qUfkQ?=
 =?us-ascii?Q?gERuOFpnhRQQvPxOfG1cj8B4hz2VoqIZ5c9b7tOwRV6Uav75F0Vk0omaZT2W?=
 =?us-ascii?Q?Lcd5nxgLTJS81wV/RG73eqmBlceg3lDZQuTqtEmtSDXNDsnPNS9r5TdI4fMH?=
 =?us-ascii?Q?W3TTCvo46e61dMGLTrr/99y3mNT6iaGkkccS2qGfz1+OQ1CVB/RSN6F4cCN3?=
 =?us-ascii?Q?EpPMC+ZOhb99+Ntcy9/xdm6Ic0bWlE91OZIupaRQ13VutMhe2g03j1++y41S?=
 =?us-ascii?Q?enTdyAHv1RYtZHWYjARIUF/kqouFzkjOL4zfRQi/u9ySya4nfXVe4dqcwXxw?=
 =?us-ascii?Q?YBzoprsT90I+TQI5fbTrvb9aE3chZvRsTdB0XOS3ZU0IqwBj0me+/K9440WL?=
 =?us-ascii?Q?m/BXpv4dh+clhgOvTIH6qf0Xy/n0n2YIu/dQaoJcUlT/g/0WcxX5Qq6fB7a+?=
 =?us-ascii?Q?VaRHNO2CuFJApb7XwOX+1Bougj/RMclVkEvpnLMXLPj0xEWZvgs1mJ5pMYLK?=
 =?us-ascii?Q?LZl19pq4Zn/9XJ8X0NR3MDb1KEn4hXq9lXU9ioRxAwpnDq9ASDnU46zL3IhY?=
 =?us-ascii?Q?UHmQvqTF/FIt6/k31J6seeUjJV8BJ4G0YnQf2JyLj+afgF1EDWCp22xmnUqd?=
 =?us-ascii?Q?uYKqjUgjor6iDpQ/+/GJJ2Je161uDESyQiVS96wUZdzhYHzuIL5CuZ+33k6x?=
 =?us-ascii?Q?QlW28kohfZdzsFwBV48xomlu722LwAV7hXd2pfTcT6dcknHh8NZZnu11zI0X?=
 =?us-ascii?Q?nwxFio01w8zTxcRs5DH7Y/X15upcRhak6Cei1Qirjq9562v19ApiKx0WG0kA?=
 =?us-ascii?Q?YLwGCsN2V2YJLjBRaLylwIaZsI+Iu6QiCBVJtJyw+ARPv8J7dDtu1zdaCGpb?=
 =?us-ascii?Q?Sf3OGNh0gJVnMx94JRcafT6OO9DJbgmDUj0s6tOhqOXp3chJC7bgWJzhdqTt?=
 =?us-ascii?Q?aDwo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:13.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cb60ed-c9ce-4c35-0260-08d89d2f0462
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jV3yTyQknM3eYeeGtmNBwOytTKYsyU451aqjpoKKRMIjhgzy471shu3Kbb52+ioxG9Z31iaTuHSlG0JZFYz/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index cecd0eca66c7..048b08437c33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,6 +1476,8 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+void kvm_free_guest_fpu(struct kvm_vcpu *vcpu);
+
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3e6d79593b8d..8d22ae25a0f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1318,6 +1318,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
index 53fe34fd1a7f..ddd614a76744 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4515,6 +4515,9 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
@@ -4532,9 +4535,14 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
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
@@ -9252,9 +9260,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
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
@@ -9267,7 +9280,12 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
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
 
@@ -9777,6 +9795,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9797,6 +9818,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
+	if (!vcpu->arch.guest_fpu)
+		return 0;
+
 	vcpu_load(vcpu);
 
 	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
@@ -9855,6 +9879,9 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->arch.guest_fpu)
+		return;
+
 	fpstate_init(&vcpu->arch.guest_fpu->state);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
@@ -9868,6 +9895,15 @@ static void fx_init(struct kvm_vcpu *vcpu)
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
@@ -9963,7 +9999,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_guest_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 free_emulate_ctxt:
@@ -10017,7 +10053,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+	kvm_free_guest_fpu(vcpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
@@ -10065,7 +10101,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
 		void *mpx_state_buffer;
 
 		/*
-- 
2.28.0

