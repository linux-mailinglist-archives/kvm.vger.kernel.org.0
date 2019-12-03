Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F046911064E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 22:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLCVIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 16:08:30 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:42493 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfLCVIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 16:08:30 -0500
Received: by mail-pg1-f201.google.com with SMTP id x189so2317450pgd.9
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 13:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DASVXSs5oWILH0sAvzGTTCKaB1RC91AoYiNLZyw2dxI=;
        b=gHZaPldSI9LEKFQ/ihgZl1LgWH5jVT3dO0odaKXcPGrstFHtODiy+L2QmfdAtImI86
         Z6dpEqR4MivzNR1to2+1UJbAXaZp+SQxYSFpPVRJyFtC+IwPKTTmLnvtD3CHwI2TII2N
         ufasLwR43qkTiAxEtrJP2zdKjcj8ICmpiTCESgtK1tWpLk7D8/RZ7NeDt8BqjgzI0oEF
         +woZg4+8XwIdg8jAOfA29TUgZ5jZquT6rjrZVe9Vr5M4NvWNDfCHJ4ndvRtYXFs8YgcR
         N6DfTGX2I1MRblm/F3rirWAp3Gpr/CwgXm6JcSi4nrdrcN4Yx7HBWoN0nylYYmKcar2t
         Vhzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DASVXSs5oWILH0sAvzGTTCKaB1RC91AoYiNLZyw2dxI=;
        b=Cli8v+yz9JDPw4RXE4UFxIDS2S1H2p+loraXmAh5/nQz3GCEZCaGKeZ7VPCkqYO0k/
         GPUiMgcUQe/vC0y4qaM5lFTG69LnvThbwTjPN0zLxeiJ3q00V8HsJuXjM5b5ApV0TPwV
         0cboxiMEIUZSzt1QoTMz7TGunSrfzgHMtXHpvuGpxDgvQE5hl+IVz1KrkaUxBPWH1c3d
         7N79qiofJv8EFHcbm5r/2kIhQD8z5g1D1I6Y/IX2oH/qnKc3dqD+X67wyg1gZeTIsDjX
         JSoaCQSQ1swBs41As082TO+k0gje66hg06Jgsl8R2HvLqlPF9lAb/BYu/PYm3+jY2Vuc
         OWSg==
X-Gm-Message-State: APjAAAUvXLXWnqWtk43PWxUaFsn89icYsbpm9cboDfaxtdMwSybyIIYY
        hitwC30IgprUSEI+fnxwQWKVW9QjTOz3AGyDsZMjXjw1JRB4mQ0XXtzgTOSgiUdgG4tDnEmMtl+
        48DLNUGELJxwxpaVn8KI+jNMJWJcaidVop8pRIWoVePvMTtNLDOL2olgfr8Em/lA=
X-Google-Smtp-Source: APXvYqzDdPCX/Axm2kbMjLuWjQBtU1S0fU+UOxex/V+hWf66/Q5FtBzUMP5UAtGRCyLwP/pKA3VUgBiDs3le2g==
X-Received: by 2002:a65:66d7:: with SMTP id c23mr7740607pgw.40.1575407309430;
 Tue, 03 Dec 2019 13:08:29 -0800 (PST)
Date:   Tue,  3 Dec 2019 13:08:25 -0800
Message-Id: <20191203210825.26827-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH] kvm: vmx: Stop wasting a page for guest_msrs
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will never need more guest_msrs than there are indices in
vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
168 bytes.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++------------
 arch/x86/kvm/vmx/vmx.h |  8 +++++++-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b9ab4166397d..0b3c7524456f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -443,7 +443,7 @@ static unsigned long host_idt_base;
  * support this emulation, IA32_STAR must always be included in
  * vmx_msr_index[], even in i386 builds.
  */
-const u32 vmx_msr_index[] = {
+const u32 vmx_msr_index[NR_GUEST_MSRS] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
@@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
-	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
@@ -6723,13 +6722,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			goto uninit_vcpu;
 	}
 
-	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
-		     > PAGE_SIZE);
-
-	if (!vmx->guest_msrs)
-		goto free_pml;
-
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
@@ -6760,7 +6752,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
 	if (err < 0)
-		goto free_msrs;
+		goto free_pml;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
@@ -6822,8 +6814,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
-free_msrs:
-	kfree(vmx->guest_msrs);
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 uninit_vcpu:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7c1b978b2df44..08bc24fa59909 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
+#ifdef CONFIG_X86_64
+#define NR_GUEST_MSRS	7
+#else
+#define NR_GUEST_MSRS	4
+#endif
+
 #define NR_LOADSTORE_MSRS 8
 
 struct vmx_msrs {
@@ -206,7 +212,7 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct shared_msr_entry *guest_msrs;
+	struct shared_msr_entry guest_msrs[NR_GUEST_MSRS];
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
-- 
2.24.0.393.g34dc348eaf-goog

