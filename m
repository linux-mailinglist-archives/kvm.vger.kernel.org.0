Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A165AFD53A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 06:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfKOF40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 00:56:26 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42088 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfKOF4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 00:56:25 -0500
Received: by mail-ot1-f68.google.com with SMTP id b16so7068887otk.9;
        Thu, 14 Nov 2019 21:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LVpr5hsgmURnDoh3tA1zn4tm7Jg5t52+Xjbnuuac3hM=;
        b=kMNK/inTqoOb1WDG90MmZ+dA0fPZny/1BWMreJMUhfYKsuRgj0ApSZ5nJuourZQvR6
         E7Ibkhqdz4tvovzjcPLtJCkfHZLW4/UWVbqO+aG9cRk1pXOl8Sr/481klIcLtixxS8xH
         MZShKsacEq6OiVuYZ5tNWb0I42tcz7/MLGUtl+amXz5Vb+KXs4DL7QxTA8pwrVg0RWOc
         paIe/52dwy2fOTBe5ziecS/OkJSFaEjL3f+8J2KusIfwZzUujaSrrIcXMCDhV1Rt+deC
         eDmQYAIrwocNo42Rnpse+SK70GRnuNTCNapfKver6Z0Bj7EyWNPAU4lrciGIJ3GvOkB4
         fU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LVpr5hsgmURnDoh3tA1zn4tm7Jg5t52+Xjbnuuac3hM=;
        b=XdJJIDwxmBXvtZgdCgEtIxrpx/UZrsp/uQ3eYxvgiYCBM3bIcMkuMCg62joG0gY8Xo
         RM4Is7Xbcof6NjN+HUUxRztbQnMOPaBZWlCWHNtVt0ocRtKcw0fq1Cc6XBhxyHRE7n/d
         TdW384vJuuRT4DpL+t+HV6chnAoFCkRehY8jlSg7MV8OGEqwYuUJkPPOG7Xik13elUVP
         0f4gUd4zruxy/TgIiLcOmiKFkKwiuas7ProEGJrFdt7bIdQ2ELFgRoL7cXMiqTgr3oBO
         dflrXJFKe7esqRYyQVxhZMTAWDOgCyHEtSyY4Wt+vc9iY1zMG52ymE+B7VvASvWRKZ7T
         uz1A==
X-Gm-Message-State: APjAAAWbkeAbsYbLiYQjcxI/rB/vA5jH3ODi09y7WcidF/v52pZjAOUE
        d1ucy70Eba8+AdQRXpxPNFoXxQcIgJ44v42vcLQHnPY8
X-Google-Smtp-Source: APXvYqyD0OkeS3fxNolVx3MFMXYulT4wGkElX3ryk2nxpiYc2al8foZ8o4uNXDtuHmIeARF+GxFON0E0uotzsAofO2o=
X-Received: by 2002:a05:6830:1d8b:: with SMTP id y11mr9273902oti.45.1573797384621;
 Thu, 14 Nov 2019 21:56:24 -0800 (PST)
MIME-Version: 1.0
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <6c2c7bbb-39f4-2a77-632e-7730e9887fc5@redhat.com> <20191114152235.GC24045@linux.intel.com>
 <857e6494-4ed8-be4a-c21a-577ab99a5711@redhat.com> <20191114163444.GD24045@linux.intel.com>
In-Reply-To: <20191114163444.GD24045@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 15 Nov 2019 13:56:14 +0800
Message-ID: <CANRm+CwdXz9HO-U47kO4j9-6+CaaTU6R7ZP_swtGF7RMF7uVEA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 at 00:34, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Nov 14, 2019 at 04:44:33PM +0100, Paolo Bonzini wrote:
> > On 14/11/19 16:22, Sean Christopherson wrote:
> > >> Instead of a separate vcpu->fast_vmexit, perhaps you can set exit_reason
> > >> to vmx->exit_reason to -1 if the fast path succeeds.
> > >
> > > Actually, rather than make this super special case, what about moving the
> > > handling into vmx_handle_exit_irqoff()?  Practically speaking that would
> > > only add ~50 cycles (two VMREADs) relative to the code being run right
> > > after kvm_put_guest_xcr0().  It has the advantage of restoring the host's
> > > hardware breakpoints, preserving a semi-accurate last_guest_tsc, and
> > > running with vcpu->mode set back to OUTSIDE_GUEST_MODE.  Hopefully it'd
> > > also be more intuitive for people unfamiliar with the code.
> >
> > Yes, that's a good idea.  The expensive bit between handle_exit_irqoff
> > and handle_exit is srcu_read_lock, which has two memory barriers in it.

Moving the handling into vmx_handle_exit_irqoff() can worse ~100
cycles than right after kvm_put_guest_xcr0() in my testing. So, which
one do you prefer?

For moving the handling into vmx_handle_exit_irqoff(), how about the
patch below:

---8<---

From 1b20b0a80c6da18b721f125cc40f8be5ad31f4b1 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Fri, 15 Nov 2019 10:18:09 +0800
Subject: [PATCH v2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  5 +++--
 5 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24d6598..3604f3a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1067,7 +1067,7 @@ struct kvm_x86_ops {
     void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);

     void (*run)(struct kvm_vcpu *vcpu);
-    int (*handle_exit)(struct kvm_vcpu *vcpu);
+    int (*handle_exit)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
     int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
     void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
     u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
@@ -1117,7 +1117,7 @@ struct kvm_x86_ops {
     int (*check_intercept)(struct kvm_vcpu *vcpu,
                    struct x86_instruction_info *info,
                    enum x86_intercept_stage stage);
-    void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
+    void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
     bool (*mpx_supported)(void);
     bool (*xsaves_supported)(void);
     bool (*umip_emulated)(void);
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 3eb8411..b33c6e1 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -88,6 +88,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1

 #define VMX_EXIT_REASONS \
     { EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c5673bd..3bb0661 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4927,7 +4927,7 @@ static void svm_get_exit_info(struct kvm_vcpu
*vcpu, u64 *info1, u64 *info2)
     *info2 = control->exit_info_2;
 }

-static int handle_exit(struct kvm_vcpu *vcpu)
+static int handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
 {
     struct vcpu_svm *svm = to_svm(vcpu);
     struct kvm_run *kvm_run = vcpu->run;
@@ -6171,7 +6171,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
     return ret;
 }

-static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32
*vcpu_exit_reason)
 {

 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d21a4a..073fe1f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5838,7 +5838,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu)
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
 {
     struct vcpu_vmx *vmx = to_vmx(vcpu);
     u32 exit_reason = vmx->exit_reason;
@@ -5924,7 +5924,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
         }
     }

-    if (exit_reason < kvm_vmx_max_exit_handlers
+    if (*vcpu_exit_reason == EXIT_REASON_NEED_SKIP_EMULATED_INSN) {
+        kvm_skip_emulated_instruction(vcpu);
+        return 1;
+    } else if (exit_reason < kvm_vmx_max_exit_handlers
         && kvm_vmx_exit_handlers[exit_reason])
         return kvm_vmx_exit_handlers[exit_reason](vcpu);
     else {
@@ -6255,7 +6258,36 @@ static void
handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 }
 STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);

-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static u32 handle_ipi_fastpath(struct kvm_vcpu *vcpu)
+{
+    u32 index;
+    u64 data;
+    int ret = 0;
+
+    if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) {
+        /*
+         * fastpath to IPI target, FIXED+PHYSICAL which is popular
+         */
+        index = kvm_rcx_read(vcpu);
+        data = kvm_read_edx_eax(vcpu);
+
+        if (((index - APIC_BASE_MSR) << 4 == APIC_ICR) &&
+            ((data & KVM_APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
+            ((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
+
+            trace_kvm_msr_write(index, data);
+            kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
+            ret = kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
+
+            if (ret == 0)
+                return EXIT_REASON_NEED_SKIP_EMULATED_INSN;
+        }
+    }
+
+    return ret;
+}
+
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_reason)
 {
     struct vcpu_vmx *vmx = to_vmx(vcpu);

@@ -6263,6 +6295,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
         handle_external_interrupt_irqoff(vcpu);
     else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
         handle_exception_nmi_irqoff(vmx);
+    else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+        *exit_reason = handle_ipi_fastpath(vcpu);
 }

 static bool vmx_has_emulated_msr(int index)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f8..130576b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7931,6 +7931,7 @@ EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
     int r;
+    u32 exit_reason = 0;
     bool req_int_win =
         dm_request_for_irq_injection(vcpu) &&
         kvm_cpu_accept_dm_intr(vcpu);
@@ -8180,7 +8181,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
     vcpu->mode = OUTSIDE_GUEST_MODE;
     smp_wmb();

-    kvm_x86_ops->handle_exit_irqoff(vcpu);
+    kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_reason);

     /*
      * Consume any pending interrupts, including the possible source of
@@ -8224,7 +8225,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
         kvm_lapic_sync_from_vapic(vcpu);

     vcpu->arch.gpa_available = false;
-    r = kvm_x86_ops->handle_exit(vcpu);
+    r = kvm_x86_ops->handle_exit(vcpu, &exit_reason);
     return r;

 cancel_injection:
--
2.7.4
