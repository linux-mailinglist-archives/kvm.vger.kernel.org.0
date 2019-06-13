Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28314489F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393588AbfFMRJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:09:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45776 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393276AbfFMRDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so21542468wre.12;
        Thu, 13 Jun 2019 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BGAkMmyoFXei/C+Osz0W44dM/FTzgOJ4Csn0iH4sTgA=;
        b=QAp6ZWfH8FyIUQjW0G4Raf644l/P9qNLuvnIF1EcEp/jage8AOChR+IU8BmzDNgNQc
         WOZYr1ZQweKHGZqGhxd8w4CiVgWZs4mS16yH4iNQcYY2pBnAFfvuITUMGNVgR9CGdepK
         hLQv/R6a1cH96mcGIa4GMSybK8ioaO1WtNbEYyaCHsAkFt3dqok5Ih8Uya58B4gdDaBz
         kfBF1W8ws2ODu2zATaocHIR9U960SmuhPbZOFAz5jDqQL4hfHex1jeXw6WTNNeWxr6oX
         OxP0vuv4A2S6UjhIzXbYYIumNsfOGxt7gwML6+2uHThCEReBqdpQ5070rSOIdeo1rEJt
         OmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=BGAkMmyoFXei/C+Osz0W44dM/FTzgOJ4Csn0iH4sTgA=;
        b=Dx6vj1G0ALFUw2K11sSwE/JrDrtEPTuDafoLKYfGytPHo8NLwxSawdopp63f1n+4XS
         CXlae9bNYLMy6z3JEnNjSAy7YiQrdlCAf/d/dbVU/7r/xuP3ke2bZON4ACzTe9PFso23
         A7jVvo1eYdHEw4Z/6THMGJw3yHnaozr2BFxhrfIBm8dgr2dZX3/tY7RVZ3AVuO68/bC2
         Kyo7KTEkoyQC2Z7asHgaa8ceQB3yVbOtbD+nmgHek2W4ZuNDhZ8go7ZV+aS6YaXeTdN0
         yvTXHPvSCArCGdErxeXJVU4qik44+7kxGOfRMP2SuVfIgkTvyT5vqtS9CRakT3aQ93LR
         nICQ==
X-Gm-Message-State: APjAAAW5OxfbMPz+eE+xWpZdzAQTAni8cel+w8Ywom0KBGn+T7HcDJx2
        AfhspTOEJfZxLVT4Y78L+B0Bbzfu
X-Google-Smtp-Source: APXvYqztY30HU9/MPMjHnjpRsb1TI0dZe7Wp0HAYpmXZE1d1egPRxmLguoJyN54DCG7bpSBCN5Iv3w==
X-Received: by 2002:adf:db02:: with SMTP id s2mr24573519wri.326.1560445414776;
        Thu, 13 Jun 2019 10:03:34 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:34 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 04/43] KVM: VMX: Store the host kernel's IDT base in a global variable
Date:   Thu, 13 Jun 2019 19:02:50 +0200
Message-Id: <1560445409-17363-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Although the kernel may use multiple IDTs, KVM should only ever see the
"real" IDT, e.g. the early init IDT is long gone by the time KVM runs
and the debug stack IDT is only used for small windows of time in very
specific flows.

Before commit a547c6db4d2f1 ("KVM: VMX: Enable acknowledge interupt on
vmexit"), the kernel's IDT base was consumed by KVM only when setting
constant VMCS state, i.e. to set VMCS.HOST_IDTR_BASE.  Because constant
host state is done once per vCPU, there was ostensibly no need to cache
the kernel's IDT base.

When support for "ack interrupt on exit" was introduced, KVM added a
second consumer of the IDT base as handling already-acked interrupts
requires directly calling the interrupt handler, i.e. KVM uses the IDT
base to find the address of the handler.  Because interrupts are a fast
path, KVM cached the IDT base to avoid having to VMREAD HOST_IDTR_BASE.
Presumably, the IDT base was cached on a per-vCPU basis simply because
the existing code grabbed the IDT base on a per-vCPU (VMCS) basis.

Note, all post-boot IDTs use the same handlers for external interrupts,
i.e. the "ack interrupt on exit" use of the IDT base would be unaffected
even if the cached IDT somehow did not match the current IDT.  And as
for the original use case of setting VMCS.HOST_IDTR_BASE, if any of the
above analysis is wrong then KVM has had a bug since the beginning of
time since KVM has effectively been caching the IDT at vCPU creation
since commit a8b732ca01c ("[PATCH] kvm: userspace interface").

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.h |  1 -
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b541fe2c6347..c90abf33b509 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -392,6 +392,7 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 };
 
 u64 host_efer;
+static unsigned long host_idt_base;
 
 /*
  * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
@@ -3728,7 +3729,6 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 {
 	u32 low32, high32;
 	unsigned long tmpl;
-	struct desc_ptr dt;
 	unsigned long cr0, cr3, cr4;
 
 	cr0 = read_cr0();
@@ -3764,9 +3764,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	store_idt(&dt);
-	vmcs_writel(HOST_IDTR_BASE, dt.address);   /* 22.2.4 */
-	vmx->host_idt_base = dt.address;
+	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
@@ -6144,7 +6142,7 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 		return;
 
 	vector = intr_info & INTR_INFO_VECTOR_MASK;
-	desc = (gate_desc *)vmx->host_idt_base + vector;
+	desc = (gate_desc *)host_idt_base + vector;
 	entry = gate_offset(desc);
 
 	asm volatile(
@@ -7429,10 +7427,14 @@ static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
+	struct desc_ptr dt;
 	int r, i;
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
+	store_idt(&dt);
+	host_idt_base = dt.address;
+
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
 		kvm_define_shared_msr(i, vmx_msr_index[i]);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1cdaa5af8245..decd31055da8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -187,7 +187,6 @@ struct vcpu_vmx {
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_dirty;
-	unsigned long	      host_idt_base;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
-- 
1.8.3.1


