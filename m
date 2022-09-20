Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15475BE6B6
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiITNHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiITNHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92082C12
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663679258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP/FhjRBJu4QgnDFMKv2lZHPVdJrMyCLueqs7Q9AOAA=;
        b=FWkLSkCYw1O/GwpxUox/C+8w/Hhe1XzU4sMz5wych8Qb2B8p6lF+5xxHnYF09SDJzTvKwC
        D4SphzrCful/S8WGUeE50R4YEzQ8ShX5qcc30tpKh2rPPUbkjzjvNLBxES4c7jhXuvlIMx
        0z9w0F5nK5ZjCtGYrsnv1oQYCkoNiqo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-IVPtmcqxMCGr0gW53AXUsQ-1; Tue, 20 Sep 2022 09:07:37 -0400
X-MC-Unique: IVPtmcqxMCGr0gW53AXUsQ-1
Received: by mail-wr1-f70.google.com with SMTP id g15-20020adfbc8f000000b0022a4510a491so1135474wrh.12
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RP/FhjRBJu4QgnDFMKv2lZHPVdJrMyCLueqs7Q9AOAA=;
        b=FyFbxERyBmwBWF1Lqzk5blm2iMz/m/vBNIDjHVG+5kBT1j0BNG84uX8Lmy0xMezodm
         c/mWalQuJn8IE82Bz1Dny634qWqx/BzSJcvvP8aye7+pLv+JAd+3b4zSWwDAEDOwh+dZ
         hdz+ynVLdj29rnLoyxEUMcbxzp4w2WhMBWWUlVVlUmZMpmNzSxhRXscPG3xgdyChuWk2
         HFRl4Qhsk06Ya6/uXHZZXtx0YgjpEPXeI1cfaBlgF2TonV9Nu9ehI6NnzYFwMJ3wghGm
         86Okxcp/+JE1RyKVCs7yc5WRPZHzBC4m9mWra2jbselIUDigu2tTEAD+D8h04MNlA6+d
         2dog==
X-Gm-Message-State: ACrzQf3Ps7cT5oChfkXge/cucbVoOPJhztwITcdenaDEo2w4vERFjLqm
        Nivx/+moI0FH7uFOCwEow3mHF2i0xfX5x9JMfdyoeKVJB9Wer4hNsXuvwY9SWAqcYJEBrD3ZLAC
        cemvn7LLYkTQB
X-Received: by 2002:a05:6000:2c8:b0:22a:efdf:ecc0 with SMTP id o8-20020a05600002c800b0022aefdfecc0mr10233583wry.57.1663679255818;
        Tue, 20 Sep 2022 06:07:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7nbD0qAFobB2TAHT5HNyD7Nmg3ATLVMKnwvGOs/ZTJ2wTNsPqIVxA8Q7x0epYt4XeitiEftQ==
X-Received: by 2002:a05:6000:2c8:b0:22a:efdf:ecc0 with SMTP id o8-20020a05600002c800b0022aefdfecc0mr10233550wry.57.1663679255443;
        Tue, 20 Sep 2022 06:07:35 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c350900b003a4efb794d7sm3003600wmq.36.2022.09.20.06.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:07:34 -0700 (PDT)
Message-ID: <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU
 enables x2APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Tue, 20 Sep 2022 16:07:33 +0300
In-Reply-To: <20220903002254.2411750-5-seanjc@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
         <20220903002254.2411750-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-09-03 at 00:22 +0000, Sean Christopherson wrote:
> Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> to fix a bug where the APIC access page is visible to vCPUs that have
> x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> 
> On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> enabled even without x2AVIC support, the bug occurs any time AVIC is
> enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> that the guest is operating in x2APIC mode.
> 
> Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> the "Note:" down a line to conform to preferred kernel/KVM multi-line
> comment style.
> 
> Leave Intel as-is for now to avoid a subtle performance regression, even
> though Intel likely suffers from the same bug.  On Intel, in theory the
> bug rears its head only when vCPUs share host page tables (extremely
> likely) and x2APIC enabling is not consistent within the guest, i.e. if
> some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> except in certain situations, e.g. bringing up APs).

Are you sure about this?

This is what I am thinking will happen, I might be wrong but I am not sure:

Due to kvm internal memory slot at 0xfee00000 userspace is very unlikely
to put a memslot over this range - let assume that userspace didn't map
RAM over the 0xfee00000 page.

In fact if userspace did try to put the memory slot either first vCPU creation
will fail because this is where we create the private memslot,
or userspace memslot will fail if it was added later.

So assuming no guest RAM in the area, the correct x86 behavier should be:

xapic enabled - 0xfee00xxx acts as APIC
x2apic enabled - 0xfee00xxx is unmapped mmio, thus writes are dropped, reads return 0xFFFFFFFF.

However currently what will happen with APICv/AVIC (regardless of the hybrid mode):

1. we start with xapic, the guest accesses it once, and that populates our SPTE entry
for 0xfee00000, but since xapic is enabled, read/writes to it are redirected to apic backing page
(the spte is ignored)

2. guest changes mode to x2apic (even on all vCPUS).
That doesn't currently change any inhibits or so,
thus I *think* only vmx_set_virtual_apic_mode is called, and it doesn't flush the SPTE
for 0xfee00000, it remains present and writable.

3. guest accesses the 0xfee00xxx, assuming APICv/x2avic, the hardware won't redirect
the access to apic backing page, but will instead just use that SPTE and let the guest
read/write the private page that we mapped in the range, which is wrong.

Am I missing something?

Also I somewhat doen't like the partial inhibit - it is to some extent misleading.
I don't have a very strong option on using the inhibit, but its meaning just feels a bit overloaded.

So why not to do it this way:

1. zap the SPTE always when switching apic mode (e.g move the code in 
__kvm_set_or_clear_apicv_inhibit to a common funtion)

2. make kvm_faultin_pfn check a flag 'any vcpu enabled x2apic' and refuse
to re-install that spte?

Something like that (only compile tested, and likely misses memory barriers):


commit 0d00c3716d5073d58d018fab9e5a261600483e25
Author: Maxim Levitsky <mlevitsk@redhat.com>
Date:   Tue Sep 20 14:39:57 2022 +0300

    KVM: x86: hide APICv/AVIC mmio when guest enables x2apic
    
   
    TBD
    
    Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd4b8c27129cc9..fe8ba17481fe1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1356,6 +1356,9 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+
+	bool apicv_mmio_hidden;
 };
 
 struct kvm_vm_stat {
@@ -1914,6 +1917,8 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				    enum kvm_apicv_inhibit reason, bool set);
 
+void kvm_update_virtual_apic_mode(struct kvm_vcpu *vcpu);
+
 static inline void kvm_set_apicv_inhibit(struct kvm *kvm,
 					 enum kvm_apicv_inhibit reason)
 {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c448b6e4b3ad33..c18094b95c4ba9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2442,10 +2442,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
-	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
-		kvm_vcpu_update_apicv(vcpu);
-		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
-	}
+	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
+		kvm_update_virtual_apic_mode(vcpu);
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86fe9a7ced1700..4ef3c87662742d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4153,9 +4153,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * MMIO SPTE.  That way the cache doesn't need to be purged
 		 * when the AVIC is re-enabled.
 		 */
-		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
-			return RET_PF_EMULATE;
+		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT)
+			if (!kvm_apicv_activated(vcpu->kvm) || vcpu->kvm->arch.apicv_mmio_hidden)
+				return RET_PF_EMULATE;
 	}
 
 	async = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bc974cdcced10..fc0c6ec79ad194 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10127,6 +10127,13 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
+static void kvm_zap_apicv_memslot(struct kvm *kvm)
+{
+	unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
+
+	kvm_zap_gfn_range(kvm, gfn, gfn+1);
+}
+
 void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				      enum kvm_apicv_inhibit reason, bool set)
 {
@@ -10156,10 +10163,8 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		 */
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 		kvm->arch.apicv_inhibit_reasons = new;
-		if (new) {
-			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-			kvm_zap_gfn_range(kvm, gfn, gfn+1);
-		}
+		if (new)
+			kvm_zap_apicv_memslot(kvm);
 	} else {
 		kvm->arch.apicv_inhibit_reasons = new;
 	}
@@ -10177,6 +10182,31 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
+void kvm_update_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!enable_apicv)
+		return;
+
+	if (apic_x2apic_mode(vcpu->arch.apic) && !READ_ONCE(kvm->arch.apicv_mmio_hidden)) {
+		/*
+		 * Permanently hide APICv/AVIC private KVM memory slot when one of
+		 * vCPUs enables the X2APIC for the first time.
+		 *
+		 * That ensures that no vCPU could access this memory slot
+		 * in case of hardware supported x2apic acceleration
+		 * (apicv/x2avic), and also that in case of hybrid AVIC mode,
+		 * the AVIC doesn't continue to accelerate this MMIO.
+		 */
+		WRITE_ONCE(kvm->arch.apicv_mmio_hidden, true);
+		kvm_zap_apicv_memslot(kvm);
+	}
+
+	kvm_vcpu_update_apicv(vcpu);
+	static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
+}
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))



Best regards,
	Maxim Levitsky


> 
> Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
> Cc: stable@vger.kernel.org
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ++++++++++
>  arch/x86/kvm/lapic.c            |  4 +++-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/svm/avic.c         | 15 +++++++-------
>  arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++----
>  5 files changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..1fd1b66ceeb6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1132,6 +1132,15 @@ enum kvm_apicv_inhibit {
>          * AVIC is disabled because SEV doesn't support it.
>          */
>         APICV_INHIBIT_REASON_SEV,
> +
> +       /*
> +        * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> +        * inhibited if any vCPU has x2APIC enabled.  Note, this is a "partial"
> +        * inhibit; APICv can still be activated, but KVM mustn't retain/create
> +        * SPTEs for the APIC access page.  Like the APIC ID and APIC base
> +        * inhibits, this is sticky for simplicity.
> +        */
> +       APICV_INHIBIT_REASON_X2APIC,
>  };
>  
>  struct kvm_arch {
> @@ -1903,6 +1912,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
>  gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>                                 struct x86_exception *exception);
>  
> +bool kvm_apicv_memslot_activated(struct kvm *kvm);
>  bool kvm_apicv_activated(struct kvm *kvm);
>  bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 38e9b8e5278c..d956cd37908e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2394,8 +2394,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>                 }
>         }
>  
> -       if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> +       if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>                 kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +               kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
> +       }
>  
>         if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
>                 kvm_vcpu_update_apicv(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..cea25552869f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4150,7 +4150,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                  * when the AVIC is re-enabled.
>                  */
>                 if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -                   !kvm_apicv_activated(vcpu->kvm))
> +                   !kvm_apicv_memslot_activated(vcpu->kvm))
>                         return RET_PF_EMULATE;
>         }
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6a3d225eb02c..19be5f1afaac 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -72,12 +72,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  
>         vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>  
> -       /* Note:
> -        * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
> -        * MSR accesses, while interrupt injection to a running vCPU
> -        * can be achieved using AVIC doorbell. The AVIC hardware still
> -        * accelerate MMIO accesses, but this does not cause any harm
> -        * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
> +       /*
> +        * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
> +        * accesses, while interrupt injection to a running vCPU can be
> +        * achieved using AVIC doorbell.  KVM disables the APIC access page
> +        * (prevents mapping it into the guest) if any vCPU has x2APIC enabled,
> +        * thus enabling AVIC activates only the doorbell mechanism.
>          */
>         if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
>             avic_mode == AVIC_MODE_X2) {
> @@ -1014,7 +1014,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>                           BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>                           BIT(APICV_INHIBIT_REASON_SEV)      |
>                           BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -                         BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> +                         BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> +                         BIT(APICV_INHIBIT_REASON_X2APIC);
>  
>         return supported & BIT(reason);
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..6ab9088c2531 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9379,15 +9379,29 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>         kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
>  }
>  
> -bool kvm_apicv_activated(struct kvm *kvm)
> +bool kvm_apicv_memslot_activated(struct kvm *kvm)
>  {
>         return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
>  }
> +
> +static unsigned long kvm_apicv_get_inhibit_reasons(struct kvm *kvm)
> +{
> +       /*
> +        * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
> +        * APICv can continue to be utilized.
> +        */
> +       return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~APICV_INHIBIT_REASON_X2APIC;
> +}
> +
> +bool kvm_apicv_activated(struct kvm *kvm)
> +{
> +       return !kvm_apicv_get_inhibit_reasons(kvm);
> +}
>  EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>  
>  bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
>  {
> -       ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
> +       ulong vm_reasons = kvm_apicv_get_inhibit_reasons(vcpu->kvm);
>         ulong vcpu_reasons = static_call(kvm_x86_vcpu_get_apicv_inhibit_reasons)(vcpu);
>  
>         return (vm_reasons | vcpu_reasons) == 0;
> @@ -10122,7 +10136,15 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  
>         set_or_clear_apicv_inhibit(&new, reason, set);
>  
> -       if (!!old != !!new) {
> +       /*
> +        * If the overall "is APICv activated" status is unchanged, simply add
> +        * or remove the inihbit from the pile.  x2APIC is an exception, as it
> +        * is a partial inhibit (only blocks SPTEs for the APIC access page).
> +        * If x2APIC is the only inhibit in either the old or the new set, then
> +        * vCPUs need to be kicked to transition between partially-inhibited
> +        * and fully-inhibited.
> +        */
> +       if ((!!old != !!new) || old == X2APIC_ENABLE || new == X2APIC_ENABLE) {
>                 /*
>                  * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
>                  * false positives in the sanity check WARN in svm_vcpu_run().
> @@ -10137,7 +10159,12 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>                  */
>                 kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>                 kvm->arch.apicv_inhibit_reasons = new;
> -               if (new) {
> +
> +               /*
> +                * Zap SPTEs for the APIC access page if APICv is newly
> +                * inhibited (partially or fully).
> +                */
> +               if (new && !old) {
>                         unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
>                         kvm_zap_gfn_range(kvm, gfn, gfn+1);
>                 }


