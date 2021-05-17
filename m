Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547EE386BDD
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 23:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbhEQVFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbhEQVE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 17:04:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3EFC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:03:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x18so1530257pfi.9
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hX8pXX2gDo3bIEjeY+BvmHcSNEliE7BLLK2W/5PzHEs=;
        b=XmuD99E+xfOFpNvtovgVxbnjepYHvAk2+O1VlHN8p4+ZydQe/FVAuaTG00qbqkhn3Y
         DtIoVPuQLWCPVUy3HmQA/5krm01VYrRGzOxoYqgvd8UC85wDsKmgZn+7mAoOJuEClXsl
         LiH0TVwto4c4jRc0LrDKJEJIip8i2cgD9/MGegoMjP8tr/Run747383nNZMESEYjyyYY
         HtHRL01PyL+2/Te9tCJsuBBCIg/RfUbQOLmaT2OhXUmbxO3mAgKhHKvi5s1eTh5xiy/O
         zJIDUbVqzQY1DirZ0U/66zQ7/gUPjtCHLTzSt/RS6ZZvUQkdI5oqgSQx2twcemCuWRc+
         Dlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hX8pXX2gDo3bIEjeY+BvmHcSNEliE7BLLK2W/5PzHEs=;
        b=BcM3ms91SDqZM1pYRJQQ1sKD3Eznmpb0u2m4OzmjijKXsWkaCYoQGM6lCFsXB702kH
         vDSDI0BbSImYXMqnf+6W7xqFoUlvshrzNkBrEVuP4AcPXN0lQssoIqX7cRve9acjaaFB
         J7FABW1yNpToQ9yQvtFJXeJ6cKN9RAixa+5u9TxIbK3pYOCAuyljkLT0Ka9XR8LcLUzV
         riDYaSEOOjYwnYtCNm+CBuDOS9l+nXSmABOn5Arc1v3Y38jgMkTVFFayrxwErOj5NwUu
         G8LvPMxWGbgwYTDr5s4ikxvAQnsoCvORKl0X+jjFyW8zFRIVp2+eqiAewJj7HyesoO6x
         DSGw==
X-Gm-Message-State: AOAM530XkYqo3xGaqSMu5sPzL6xyj5aPjy3GSw23s7okb9GIMXvkt9K7
        GzEOytUMrQ0o/x9kdFIvyH8+7A==
X-Google-Smtp-Source: ABdhPJzxX5uTsD8c+Ygaz6N4l5tdQ0RZYQhRDQ35EuwwloI1+Z3ks4RAGVFtDj7uTw3chrL7yxy2Dg==
X-Received: by 2002:a65:424b:: with SMTP id d11mr1386837pgq.171.1621285422049;
        Mon, 17 May 2021 14:03:42 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t133sm11372658pgb.0.2021.05.17.14.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 14:03:41 -0700 (PDT)
Date:   Mon, 17 May 2021 21:03:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: Invert APICv/AVIC enablement check
Message-ID: <YKLaKV5Z+x30iNG9@google.com>
References: <20210513113710.1740398-1-vkuznets@redhat.com>
 <20210513113710.1740398-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513113710.1740398-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021, Vitaly Kuznetsov wrote:
> Currently, APICv/AVIC enablement is global ('enable_apicv' module parameter
> for Intel, 'avic' module parameter for AMD) but there's no way to check
> it from vendor-neutral code. Add 'apicv_supported()' to kvm_x86_ops and
> invert kvm_apicv_init() (which now doesn't need to be called from arch-
> specific code).

Rather than add a new hook, just move the variable to x86.c, and export it so
that VMX and SVM can give it different module names.  The only hiccup is that
avic is off by default, but I don't see why that can't be changed.

On a related topic, the AVIC dependency on CONFIG_X86_LOCAL_APIC is dead code
since commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").  Ditto for
cpu_has_vmx_posted_intr().


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..bf5807d35339 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1422,6 +1422,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;

 #define KVM_X86_OP(func) \
@@ -1661,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
                                struct x86_exception *exception);

 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
                              unsigned long bit);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712b4e0de481..ec4aa804395b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,10 +28,7 @@
 #include "svm.h"

 /* enable / disable AVIC */
-int avic;
-#ifdef CONFIG_X86_LOCAL_APIC
-module_param(avic, int, S_IRUGO);
-#endif
+module_param_named(avic, enable_apicv, bool, S_IRUGO);

 #define SVM_AVIC_DOORBELL      0xc001011b

@@ -126,7 +123,7 @@ void avic_vm_destroy(struct kvm *kvm)
        unsigned long flags;
        struct kvm_svm *kvm_svm = to_kvm_svm(kvm);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (kvm_svm->avic_logical_id_table_page)
@@ -149,7 +146,7 @@ int avic_vm_init(struct kvm *kvm)
        struct page *l_page;
        u32 vm_id;

-       if (!avic)
+       if (!enable_apicv)
                return 0;

        /* Allocating physical APIC ID table (4KB) */
@@ -571,7 +568,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
        int ret;
        struct kvm_vcpu *vcpu = &svm->vcpu;

-       if (!avic || !irqchip_in_kernel(vcpu->kvm))
+       if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(vcpu);
@@ -595,7 +592,7 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)

 void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
 {
-       if (!avic || !lapic_in_kernel(vcpu))
+       if (!enable_apicv || !lapic_in_kernel(vcpu))
                return;

        srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -655,7 +652,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
        struct vmcb *vmcb = svm->vmcb;
        bool activated = kvm_vcpu_apicv_active(vcpu);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (activated) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa351e605de..e650d4c466e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1009,11 +1009,9 @@ static __init int svm_hardware_setup(void)
                        nrips = false;
        }

-       if (avic) {
-               if (!npt_enabled ||
-                   !boot_cpu_has(X86_FEATURE_AVIC) ||
-                   !IS_ENABLED(CONFIG_X86_LOCAL_APIC)) {
-                       avic = false;
+       if (enable_apicv) {
+               if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC)) {
+                       enable_apicv = false;
                } else {
                        pr_info("AVIC enabled\n");

@@ -4429,13 +4427,12 @@ static int svm_vm_init(struct kvm *kvm)
        if (!pause_filter_count || !pause_filter_thresh)
                kvm->arch.pause_in_guest = true;

-       if (avic) {
+       if (enable_apicv) {
                int ret = avic_vm_init(kvm);
                if (ret)
                        return ret;
        }

-       kvm_apicv_init(kvm, avic);
        return 0;
 }

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e44567ceb865..a514b490db4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -479,8 +479,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..bf5807d35339 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1422,6 +1422,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;

 #define KVM_X86_OP(func) \
@@ -1661,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
                                struct x86_exception *exception);

 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
                              unsigned long bit);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712b4e0de481..ec4aa804395b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,10 +28,7 @@
 #include "svm.h"

 /* enable / disable AVIC */
-int avic;
-#ifdef CONFIG_X86_LOCAL_APIC
-module_param(avic, int, S_IRUGO);
-#endif
+module_param_named(avic, enable_apicv, bool, S_IRUGO);

 #define SVM_AVIC_DOORBELL      0xc001011b

@@ -126,7 +123,7 @@ void avic_vm_destroy(struct kvm *kvm)
        unsigned long flags;
        struct kvm_svm *kvm_svm = to_kvm_svm(kvm);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (kvm_svm->avic_logical_id_table_page)
@@ -149,7 +146,7 @@ int avic_vm_init(struct kvm *kvm)
        struct page *l_page;
        u32 vm_id;

-       if (!avic)
+       if (!enable_apicv)
                return 0;

        /* Allocating physical APIC ID table (4KB) */
@@ -571,7 +568,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
        int ret;
        struct kvm_vcpu *vcpu = &svm->vcpu;

-       if (!avic || !irqchip_in_kernel(vcpu->kvm))
+       if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(vcpu);
@@ -595,7 +592,7 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)

 void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
 {
-       if (!avic || !lapic_in_kernel(vcpu))
+       if (!enable_apicv || !lapic_in_kernel(vcpu))
                return;

        srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -655,7 +652,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
        struct vmcb *vmcb = svm->vmcb;
        bool activated = kvm_vcpu_apicv_active(vcpu);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (activated) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa351e605de..e650d4c466e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1009,11 +1009,9 @@ static __init int svm_hardware_setup(void)
                        nrips = false;
        }

-       if (avic) {
-               if (!npt_enabled ||
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..bf5807d35339 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1422,6 +1422,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;

 #define KVM_X86_OP(func) \
@@ -1661,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
                                struct x86_exception *exception);

 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
                              unsigned long bit);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712b4e0de481..ec4aa804395b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,10 +28,7 @@
 #include "svm.h"

 /* enable / disable AVIC */
-int avic;
-#ifdef CONFIG_X86_LOCAL_APIC
-module_param(avic, int, S_IRUGO);
-#endif
+module_param_named(avic, enable_apicv, bool, S_IRUGO);

 #define SVM_AVIC_DOORBELL      0xc001011b

@@ -126,7 +123,7 @@ void avic_vm_destroy(struct kvm *kvm)
        unsigned long flags;
        struct kvm_svm *kvm_svm = to_kvm_svm(kvm);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (kvm_svm->avic_logical_id_table_page)
@@ -149,7 +146,7 @@ int avic_vm_init(struct kvm *kvm)
        struct page *l_page;
        u32 vm_id;

-       if (!avic)
+       if (!enable_apicv)
                return 0;

        /* Allocating physical APIC ID table (4KB) */
@@ -571,7 +568,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
        int ret;
        struct kvm_vcpu *vcpu = &svm->vcpu;

-       if (!avic || !irqchip_in_kernel(vcpu->kvm))
+       if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(vcpu);
@@ -595,7 +592,7 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)

 void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
 {
-       if (!avic || !lapic_in_kernel(vcpu))
+       if (!enable_apicv || !lapic_in_kernel(vcpu))
                return;

        srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -655,7 +652,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
        struct vmcb *vmcb = svm->vmcb;
        bool activated = kvm_vcpu_apicv_active(vcpu);

-       if (!avic)
+       if (!enable_apicv)
                return;

        if (activated) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa351e605de..e650d4c466e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1009,11 +1009,9 @@ static __init int svm_hardware_setup(void)
                        nrips = false;
        }

-       if (avic) {
-               if (!npt_enabled ||
...skipping...

 #define VMCB_AVIC_APIC_BAR_MASK                0xFFFFFFFFFF000ULL

-extern int avic;
-
 static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
 {
        svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8dee8a5fbc17..4705ad55abb5 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,7 +12,6 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
-extern bool __read_mostly enable_apicv;
 extern int __read_mostly pt_mode;

 #define PT_MODE_SYSTEM         0
@@ -90,8 +89,7 @@ static inline bool cpu_has_vmx_preemption_timer(void)

 static inline bool cpu_has_vmx_posted_intr(void)
 {
-       return IS_ENABLED(CONFIG_X86_LOCAL_APIC) &&
-               vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
+       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
 }

 static inline bool cpu_has_load_ia32_efer(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..697dd54c7df8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -101,7 +101,6 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);

-bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);

 /*
@@ -7001,7 +7000,6 @@ static int vmx_vm_init(struct kvm *kvm)
                        break;
                }
        }
-       kvm_apicv_init(kvm, enable_apicv);
        return 0;
 }

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..22a1e2b438c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -209,6 +209,9 @@ EXPORT_SYMBOL_GPL(host_efer);
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);

+bool __read_mostly enable_apicv = true;
+EXPORT_SYMBOL_GPL(enable_apicv);
+
 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
@@ -8342,16 +8345,15 @@ bool kvm_apicv_activated(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);

-void kvm_apicv_init(struct kvm *kvm, bool enable)
+static void kvm_apicv_init(struct kvm *kvm)
 {
-       if (enable)
+       if (enable_apicv)
                clear_bit(APICV_INHIBIT_REASON_DISABLE,
                          &kvm->arch.apicv_inhibit_reasons);
        else
                set_bit(APICV_INHIBIT_REASON_DISABLE,
                        &kvm->arch.apicv_inhibit_reasons);
 }
-EXPORT_SYMBOL_GPL(kvm_apicv_init);

 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 {
@@ -10736,6 +10738,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
        INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);

+       kvm_apicv_init(kvm);
        kvm_hv_init_vm(kvm);
        kvm_page_track_init(kvm);
        kvm_mmu_init_vm(kvm);


