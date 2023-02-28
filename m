Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101846A5E70
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 18:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjB1RzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 12:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjB1RzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 12:55:16 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1F3252D;
        Tue, 28 Feb 2023 09:55:13 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id h3so11162191lja.12;
        Tue, 28 Feb 2023 09:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677606911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g42GCCt47V4a1ei6C2RFgd9uWZdEc2D6bH9r/m2UprI=;
        b=hyB1f2OqzV3l8cMM1BI6pAxPCa4HgmZD9eP1HmoWlb5h4khDbuFV+Thn3xSa447to3
         ILN3FFBDcVcYqdfrgXSmMfsAJyxIJIZzrgNvuledEooq/A21SmTrbMhZtojEgPyToDuT
         7ktwE/717eBYcj4+ELqKHqgbHDbb5wnjFE/db4BJ2+15b63LEEXcxsxBCcFIRnGRCBN5
         ZSwbYg4fzizft65Ve3rlpXjNiVKCKnUV5d2OgMUl9H3S+42K3W0x9v8gE+ewjTh6xKAn
         /29J3sv++OEyJDcKgjlv015bLLvWQWh+xjLnm9AGgZV/ZWhnQlbUCB0ZRLp8lvX9lXvZ
         uEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677606911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g42GCCt47V4a1ei6C2RFgd9uWZdEc2D6bH9r/m2UprI=;
        b=7uMrvTGK4mVhwB/rN6yHeT6+DEIxCQzoS1PU6J5c7PKN9Hwixw7a3eaHuvSsTwoPGa
         +Hz4A0pbRyUYLDAs4uSuyrJTysp0P3Byls+4oN/dBQisMEREojRHVlgNzwPfm8er0LAP
         t2f7lsF+AcYi15cFiUxEKR9gyMsgqTdqG0pRZXM7DDXU3x0GZ/BU0iFT+X+63EoupMqq
         yYp/KPL/OOo0MPZlpHuSbLxK1i3THHaZWRwzNK9urJybF0PipdeHSns++aCNuOARhTS2
         IRnhD/4+Sq2T9zUP3fKMwnrwZ2KMt5DeD6obM655TGAY1EN4e/xPQRIGxql3W1MMsYmY
         WO9A==
X-Gm-Message-State: AO0yUKVECXfSG/5YhSFYUJyiKV5ED8WNKfFUZV3+bPQorAtpzadxUDNf
        /vgPJnk+xKO6gbzRe2n13EU=
X-Google-Smtp-Source: AK7set9uab77UcSCkVxAua3TfuISyMxW5sdPUk78+OLLHGSy2yQdZ5MQvoIm2u+6+V/TeHwBRlEkCQ==
X-Received: by 2002:a2e:91d9:0:b0:295:b9da:f3cb with SMTP id u25-20020a2e91d9000000b00295b9daf3cbmr977760ljg.3.1677606911281;
        Tue, 28 Feb 2023 09:55:11 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id bi12-20020a05651c230c00b002932b817990sm1298005ljb.31.2023.02.28.09.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 09:55:11 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Tue, 28 Feb 2023 19:55:09 +0200
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230228195509.000073da@intel.com>
In-Reply-To: <20230227234914.GU4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
        <20230116124606.00003872@gmail.com>
        <20230227234914.GU4175971@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Feb 2023 15:49:14 -0800
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Mon, Jan 16, 2023 at 12:46:06PM +0200,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > On Thu, 12 Jan 2023 08:31:31 -0800
> > isaku.yamahata@intel.com wrote:
> > 
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> > > structures, partially initialize it.  Allocate pages of TDX vcpu for the
> > > TDX module.  Actual donation TDX vcpu pages to the TDX module is not done
> > > yet.
> > > 
> > > In the case of the conventional case, cpuid is empty at the initialization.
> > > and cpuid is configured after the vcpu initialization.  Because TDX
> > > supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
> > > on the vcpu initialization.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > > Changes v10 -> v11:
> > > - NULL check of kvmalloc_array() in tdx_vcpu_reset. Move it to
> > >   tdx_vcpu_create()
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/main.c    | 40 ++++++++++++++++++--
> > >  arch/x86/kvm/vmx/tdx.c     | 75 ++++++++++++++++++++++++++++++++++++++
> > >  arch/x86/kvm/vmx/x86_ops.h | 10 +++++
> > >  arch/x86/kvm/x86.c         |  2 +
> > >  4 files changed, 123 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > index ddf0742f1f67..59813ca05f36 100644
> > > --- a/arch/x86/kvm/vmx/main.c
> > > +++ b/arch/x86/kvm/vmx/main.c
> > > @@ -63,6 +63,38 @@ static void vt_vm_free(struct kvm *kvm)
> > >  		tdx_vm_free(kvm);
> > >  }
> > >  
> > > +static int vt_vcpu_precreate(struct kvm *kvm)
> > > +{
> > > +	if (is_td(kvm))
> > > +		return 0;
> > > +
> > > +	return vmx_vcpu_precreate(kvm);
> > > +}
> > > +
> > > +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (is_td_vcpu(vcpu))
> > > +		return tdx_vcpu_create(vcpu);
> > > +
> > > +	return vmx_vcpu_create(vcpu);
> > > +}
> > > +
> > 
> > -----
> > > +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (is_td_vcpu(vcpu))
> > > +		return tdx_vcpu_free(vcpu);
> > > +
> > > +	return vmx_vcpu_free(vcpu);
> > > +}
> > > +
> > > +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > +{
> > > +	if (is_td_vcpu(vcpu))
> > > +		return tdx_vcpu_reset(vcpu, init_event);
> > > +
> > > +	return vmx_vcpu_reset(vcpu, init_event);
> > > +}
> > > +
> > ----
> > 
> > It seems a little strange to use return in this style. Would it be better like:
> > 
> > -----
> > if (xxx) {
> > 	tdx_vcpu_reset(xxx);
> > 	return; 
> > }
> > 
> > vmx_vcpu_reset(xxx);
> > ----
> > 
> > ?
> 
> It's C11.  I updated the code to not use the feature.
> 
> 
> > >  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> > >  {
> > >  	if (!is_td(kvm))
> > > @@ -90,10 +122,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> > >  	.vm_destroy = vt_vm_destroy,
> > >  	.vm_free = vt_vm_free,
> > >  
> > > -	.vcpu_precreate = vmx_vcpu_precreate,
> > > -	.vcpu_create = vmx_vcpu_create,
> > > -	.vcpu_free = vmx_vcpu_free,
> > > -	.vcpu_reset = vmx_vcpu_reset,
> > > +	.vcpu_precreate = vt_vcpu_precreate,
> > > +	.vcpu_create = vt_vcpu_create,
> > > +	.vcpu_free = vt_vcpu_free,
> > > +	.vcpu_reset = vt_vcpu_reset,
> > >  
> > >  	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> > >  	.vcpu_load = vmx_vcpu_load,
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 557a609c5147..099f0737a5aa 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -281,6 +281,81 @@ int tdx_vm_init(struct kvm *kvm)
> > >  	return 0;
> > >  }
> > >  
> > > +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_cpuid_entry2 *e;
> > > +
> > > +	/*
> > > +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> > > +	 * X2APIC feature to allow X2APIC.
> > > +	 * Because vcpu_reset() can't return error, allocation is done here.
> > > +	 */
> > > +	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> > > +	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> > > +	e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
> > > +	if (!e)
> > > +		return -ENOMEM;
> > > +	*e  = (struct kvm_cpuid_entry2) {
> > > +		.function = 1,	/* Features for X2APIC */
> > > +		.index = 0,
> > > +		.eax = 0,
> > > +		.ebx = 0,
> > > +		.ecx = 1ULL << 21,	/* X2APIC */
> > > +		.edx = 0,
> > > +	};
> > > +	vcpu->arch.cpuid_entries = e;
> > > +	vcpu->arch.cpuid_nent = 1;
> > > +
> > > +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > > +	if (!vcpu->arch.apic)
> > > +		return -EINVAL;
> > > +
> > > +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> > > +
> > > +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > > +
> > > +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> > > +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > > +
> > > +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> > > +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> > > +	vcpu->arch.guest_state_protected =
> > > +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/* This is stub for now.  More logic will come. */
> > > +}
> > > +
> > > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > +{
> > > +	struct msr_data apic_base_msr;
> > > +
> > > +	/* TDX doesn't support INIT event. */
> > > +	if (WARN_ON_ONCE(init_event))
> > > +		goto td_bugged;
> > > +
> > > +	/* TDX rquires X2APIC. */
> >                 ^
> >                requires
> > > +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > > +	if (kvm_vcpu_is_reset_bsp(vcpu))
> > > +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> > > +	apic_base_msr.host_initiated = true;
> > > +	if (WARN_ON_ONCE(kvm_set_apic_base(vcpu, &apic_base_msr)))
> > > +		goto td_bugged;
> > > +
> > > +	/*
> > > +	 * Don't update mp_state to runnable because more initialization
> > > +	 * is needed by TDX_VCPU_INIT.
> > > +	 */
> > > +	return;
> > > +
> > > +td_bugged:
> > > +	vcpu->kvm->vm_bugged = true;
> > > +}
> > > +
> > 
> > 1) Using vm_bugged to terminate the VM creation feels off. When
> > using it in creation path, the termination still happens in xx_vcpu_run().
> > 
> > Thus, even something wrong happens at a certain point of the creation path,
> > the VM creation still continues. Until the xxx_vcpu_run(), the VM termination
> > finally happens.
> > 
> > Why not just fail in the creation path?
> 
> I converted vm_bugged to KVM_BUG_ON.  Because the td_bugged case shouldn't
> happen for TDX case, it's worthwhile for KVM_BUG_ON()
> 
> 
> > 2) Move 
> > 
> > > +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > > +	if (kvm_vcpu_is_reset_bsp(vcpu))
> > > +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> > > +	apic_base_msr.host_initiated = true;
> > 
> > to:
> > 
> > void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> > {
> >         struct kvm_lapic *apic = vcpu->arch.apic;
> >         u64 msr_val;
> >         int i;
> > 
> >         if (!init_event) {
> >                 msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
> > 
> > 		/* here */
> > 		if (is_td_vcpu(vcpu)) 
> > 			msr_val = xxxx;
> >                 if (kvm_vcpu_is_reset_bsp(vcpu))
> >                         msr_val |= MSR_IA32_APICBASE_BSP;
> >                 kvm_lapic_set_base(vcpu, msr_val);
> >         }
> 
> No. Because I'm trying to contain is_td/is_td_vcpu in vmx specific and not use
> in common x86 code.
>

I guess so. Centeralizing the initialization would be the nice and greatly
improve the readablity of the code. Maybe adding a new callback in kvm x86_ops
like .get_default_msr_val instead.

> 
> > PS: Is there any reason that APIC MSR in TDX doesn't need
> > MSR_IA32_APICBASE_ENABLE?
> 
> because LAPIC_MODE_X2APIC includes MSR_IA32_APICBASE_ENABLE.
> In lapic.h
>         LAPIC_MODE_X2APIC = MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE,
> 
> 
> 
> > 3) Change the following:
> > 
> > > +
> > > +	/* TDX doesn't support INIT event. */
> > > +	if (WARN_ON_ONCE(init_event))
> > > +		goto td_bugged;
> > > +
> > 
> > to 
> > 	WARN_ON_ONCE(init_event);
> > 
> > kvm_cpu_deliver_init() will trigger a kvm_vcpu_reset(xxx, init_event=true),
> > but you have already avoided this in vt_vcpu_deliver_init(). A warn
> > is good enough to remind people.
> 
> I converted it into KVM_BUG_ON().
> 
> 
> > With these changes, tdx_vcpu_reset() will only contain the CPUID configuration
> > , using the vm_bugged to terminate the VM in tdx_vcpu_reset() can be removed.
> > 
> > >  int tdx_dev_ioctl(void __user *argp)
> > >  {
> > >  	struct kvm_tdx_capabilities __user *user_caps;
> > > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > > index 6c40dda1cc2f..37ab2cfd35bc 100644
> > > --- a/arch/x86/kvm/vmx/x86_ops.h
> > > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > > @@ -147,7 +147,12 @@ int tdx_offline_cpu(void);
> > >  int tdx_vm_init(struct kvm *kvm);
> > >  void tdx_mmu_release_hkid(struct kvm *kvm);
> > >  void tdx_vm_free(struct kvm *kvm);
> > > +
> > >  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> > > +
> > > +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> > > +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> > > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> > >  #else
> > >  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
> > >  static inline void tdx_hardware_unsetup(void) {}
> > > @@ -159,7 +164,12 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> > >  static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> > >  static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
> > >  static inline void tdx_vm_free(struct kvm *kvm) {}
> > > +
> > >  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> > > +
> > > +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> > > +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> > > +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> > >  #endif
> > >  
> > >  #endif /* __KVM_X86_VMX_X86_OPS_H */
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 1fb135e0c98f..e8bc66031a1d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -492,6 +492,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >  	kvm_recalculate_apic_map(vcpu->kvm);
> > >  	return 0;
> > >  }
> > > +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
> > >  
> > >  /*
> > >   * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> > > @@ -12109,6 +12110,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> > >  {
> > >  	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
> > >  }
> > > +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
> > >
> > 
> > The symbols don't need to be exported with the changes mentioned above.
> >   
> > >  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
> > >  {
> > 
> 

