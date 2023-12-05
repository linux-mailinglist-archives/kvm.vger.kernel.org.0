Return-Path: <kvm+bounces-3481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BA7804FD4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CCBE1F21529
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A48A4CDFA;
	Tue,  5 Dec 2023 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZESB5l4q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB16A0
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YNNHmpMNFBOY/h9x5c114EYl0g1z36FHgIeTCRphg4=;
	b=ZESB5l4qx7t0F6vuX2SzOKzlKo+woFAHEAzUSHp4Mu520s3HeLrVtDBVd1iiwEuahvUgHg
	3iLUJZo905NY/W8ww/hUb+dUmupdE8QI9LSt3iiebaXHV+gP6PkYDNNirmi5ilYFhJXPEe
	idYKc5Lnx689z99P35hnVmgbzfjngNI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-mmwU00d_Nd-O8TYC5ap3Rw-1; Tue, 05 Dec 2023 05:07:50 -0500
X-MC-Unique: mmwU00d_Nd-O8TYC5ap3Rw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40b3d4d6417so37040285e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 02:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770869; x=1702375669;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/YNNHmpMNFBOY/h9x5c114EYl0g1z36FHgIeTCRphg4=;
        b=XpUwdiFEWkDyGh7qa9hII6QYnFMuceKA9pPfm95uj3ay9Joy9aZQzvaXj81THVxDdL
         Qz9zlaiaNxSwqeXY1Pz8iqQNHrocUbH8ec1AKcKUffYUVq1faPBq8Om0qSLtwDLzmmyz
         4l1olAReiGBuJO9C+Gh2p96bUKHIqAGbRW+AauRRanfWTqvTwg0vPUJfhcxaV5UMZiSj
         ymBhhWN9OmGH7y03HnT50bVe1m4mfRePFP8OLEGKNv2ODOifGlrvpQxJd2i748pFgiju
         zwv3RETdDAech3q+sNsdNZaIaNGlxy2cu6uNySLNT3bRcoebk/Bj6uXC6AY9LI5aRiRz
         lrpg==
X-Gm-Message-State: AOJu0YxJhQ9cxOW+DbZv3QlMdYfk62TQxfNis05a5QCQ64A6lI73aZdN
	sahbqmHT9tyvQhBzzmKLUYpwylrB3AJ5Wcy9frCL0Gno7dBzNiS8wU9UIEImBwKA6/DPto8Bl/H
	2yu8/4a51b6W6
X-Received: by 2002:a05:600c:4ecd:b0:40b:5e22:2f9 with SMTP id g13-20020a05600c4ecd00b0040b5e2202f9mr1700498wmq.101.1701770868968;
        Tue, 05 Dec 2023 02:07:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFv2Y1DeY0wyuFYKbEttQxlhEVe1d2A5rZXaYr80iyGrkukiUPA96xr7C6nP6ko43JxwkF6mA==
X-Received: by 2002:a05:600c:4ecd:b0:40b:5e22:2f9 with SMTP id g13-20020a05600c4ecd00b0040b5e2202f9mr1700489wmq.101.1701770868650;
        Tue, 05 Dec 2023 02:07:48 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id fm24-20020a05600c0c1800b0040b3e26872dsm22327129wmb.8.2023.12.05.02.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 02:07:48 -0800 (PST)
Message-ID: <6b508ee1ed3a121f2c4842c6a912bc5bd12ed469.camel@redhat.com>
Subject: Re: [PATCH v7 24/26] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com, kvm@vger.kernel.org
Date: Tue, 05 Dec 2023 12:07:46 +0200
In-Reply-To: <8b68d17c-9b65-4d01-8d3d-fccdb50306ac@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-25-weijiang.yang@intel.com>
	 <ad3156de93a31449e1e88c52169a08cd6fc7edb1.camel@redhat.com>
	 <8b68d17c-9b65-4d01-8d3d-fccdb50306ac@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2023-12-02 at 00:15 +0800, Yang, Weijiang wrote:
> On 12/1/2023 1:46 AM, Maxim Levitsky wrote:
> 
> [...]
> 
> > >   
> > > +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
> > > +{
> > > +	return	((u64)vmcs_config.basic_cap << 32) &
> > > +		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
> > > +}
> > I still think that we should add a comment explaining why this check is needed,
> > as I said in the previous review.
> 
> OK, I'll add some comments above the function. Thanks!
> 
> > > +
> > >   static inline bool cpu_has_virtual_nmis(void)
> > >   {
> > >   	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index c658f2f230df..a1aae8709939 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -2614,6 +2614,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> > >   		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
> > >   		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
> > >   		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
> > > +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
> > >   	};
> > >   
> > >   	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> > > @@ -4935,6 +4936,15 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >   
> > >   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
> > >   
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > > +		vmcs_writel(GUEST_SSP, 0);
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> > > +	    kvm_cpu_cap_has(X86_FEATURE_IBT))
> > > +		vmcs_writel(GUEST_S_CET, 0);
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> > > +	    IS_ENABLED(CONFIG_X86_64))
> > > +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> > Looks reasonable now.
> > > +
> > >   	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
> > >   
> > >   	vpid_sync_context(vmx->vpid);
> > > @@ -6354,6 +6364,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
> > >   	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
> > >   		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
> > >   
> > > +	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
> > > +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
> > > +		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
> > > +		pr_err("INTR SSP TABLE = 0x%016lx\n",
> > > +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
> > > +	}
> > >   	pr_err("*** Host State ***\n");
> > >   	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
> > >   	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
> > > @@ -6431,6 +6447,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
> > >   	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
> > >   		pr_err("Virtual processor ID = 0x%04x\n",
> > >   		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
> > > +	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
> > > +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
> > > +		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
> > > +		pr_err("INTR SSP TABLE = 0x%016lx\n",
> > > +		       vmcs_readl(HOST_INTR_SSP_TABLE));
> > > +	}
> > >   }
> > >   
> > >   /*
> > > @@ -7964,7 +7986,6 @@ static __init void vmx_set_cpu_caps(void)
> > >   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
> > >   
> > >   	/* CPUID 0xD.1 */
> > > -	kvm_caps.supported_xss = 0;
> > >   	if (!cpu_has_vmx_xsaves())
> > >   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> > >   
> > > @@ -7976,6 +7997,12 @@ static __init void vmx_set_cpu_caps(void)
> > >   
> > >   	if (cpu_has_vmx_waitpkg())
> > >   		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> > > +
> > > +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
> > > +	    !cpu_has_vmx_basic_no_hw_errcode()) {
> > > +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> > > +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> > > +	}
> > My review feedback from previous version still applies here, I don't have an
> > idea why this was not addressed....
> > 
> > "I think that here we also need to clear kvm_caps.supported_xss,
> > or even better, lets set the CET bits in kvm_caps.supported_xss only
> > once CET is fully enabled (both this check and check in __kvm_x86_vendor_init pass)."
> 
> Ah, previously I had a helper to check whether CET bits were enabled in kvm_caps.supported_xss,
> so need to set the bits earlier before vmx's hardware_setup.  I still want to keep the code as-is
> in case other features need to check the their related bits set before configure something in
> vmx hardware_setup.

As long as the code is correct I won't object.


Best regards,
	Maxim Levitsky

> 
> > In addition to that I just checked and unless I am mistaken:
> > 
> > vmx_set_cpu_caps() is called from vmx's hardware_setup(), which is called
> > from __kvm_x86_vendor_init.
> > 
> > After this call, __kvm_x86_vendor_init does clear kvm_caps.supported_xss,
> > but doesn't do this if the above code cleared X86_FEATURE_SHSTK/X86_FEATURE_IBT.
> > 
> Yeah, I checked the history, the similar logic was there until v6, I can pick it up, thanks!
> 
> > >   }
> > >   
> > >   static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index c2130d2c8e24..fb72819fbb41 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -480,7 +480,8 @@ static inline u8 vmx_get_rvi(void)
> > >   	 VM_ENTRY_LOAD_IA32_EFER |					\
> > >   	 VM_ENTRY_LOAD_BNDCFGS |					\
> > >   	 VM_ENTRY_PT_CONCEAL_PIP |					\
> > > -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> > > +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> > > +	 VM_ENTRY_LOAD_CET_STATE)
> > >   
> > >   #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
> > >   	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> > > @@ -502,7 +503,8 @@ static inline u8 vmx_get_rvi(void)
> > >   	       VM_EXIT_LOAD_IA32_EFER |					\
> > >   	       VM_EXIT_CLEAR_BNDCFGS |					\
> > >   	       VM_EXIT_PT_CONCEAL_PIP |					\
> > > -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
> > > +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
> > > +	       VM_EXIT_LOAD_CET_STATE)
> > >   
> > >   #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
> > >   	(PIN_BASED_EXT_INTR_MASK |					\
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index c6b57ede0f57..2bcf3c7923bf 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
> > >   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> > >   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
> > >   
> > > -#define KVM_SUPPORTED_XSS     0
> > > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> > > +				 XFEATURE_MASK_CET_KERNEL)
> > >   
> > >   u64 __read_mostly host_efer;
> > >   EXPORT_SYMBOL_GPL(host_efer);
> > > @@ -9854,6 +9855,15 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> > >   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> > >   		kvm_caps.supported_xss = 0;
> > >   
> > > +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> > > +	     XFEATURE_MASK_CET_KERNEL)) !=
> > > +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> > > +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> > > +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> > > +		kvm_caps.supported_xss &= ~XFEATURE_CET_USER;
> > > +		kvm_caps.supported_xss &= ~XFEATURE_CET_KERNEL;
> > > +	}
> > > +
> > >   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> > >   	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> > >   #undef __kvm_cpu_cap_has
> > > @@ -12319,7 +12329,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> > >   
> > >   static inline bool is_xstate_reset_needed(void)
> > >   {
> > > -	return kvm_cpu_cap_has(X86_FEATURE_MPX);
> > > +	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
> > > +	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> > > +	       kvm_cpu_cap_has(X86_FEATURE_IBT);
> > >   }
> > >   
> > >   void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > @@ -12396,6 +12408,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >   						       XFEATURE_BNDCSR);
> > >   		}
> > >   
> > > +		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> > > +			fpstate_clear_xstate_component(fpstate,
> > > +						       XFEATURE_CET_USER);
> > > +			fpstate_clear_xstate_component(fpstate,
> > > +						       XFEATURE_CET_KERNEL);
> > > +		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> > > +			fpstate_clear_xstate_component(fpstate,
> > > +						       XFEATURE_CET_USER);
> > > +		}
> > > +
> > >   		if (init_event)
> > >   			kvm_load_guest_fpu(vcpu);
> > >   	}
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index d9cc352cf421..dc79dcd733ac 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -531,6 +531,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
> > >   		__reserved_bits |= X86_CR4_VMXE;        \
> > >   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
> > >   		__reserved_bits |= X86_CR4_PCIDE;       \
> > > +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> > > +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> > > +		__reserved_bits |= X86_CR4_CET;         \
> > >   	__reserved_bits;                                \
> > >   })
> > >   
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > 





