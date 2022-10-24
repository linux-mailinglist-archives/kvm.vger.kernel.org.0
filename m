Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B660AECE
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiJXPPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 11:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiJXPPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 11:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7A6BBE27
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 06:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666619461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=boXDPcxpUocdHWEdF4boM/MTFdSB/GctSLK4grdDmW0=;
        b=JBWcOy6j5Lhale+tJeB2YuDYKGeLFp09hb7Zm3yakk5oaPBhEicp2/kynMtW832pWbpyUu
        UHa9zVIOh5VVmhbW2T9N8JkxfOjj5f/+75BQRQCP3C7w2xX8a4Dyvaji0qL0MXaRFwJCk1
        b2yirLxBIqR4R8rqhg1QM456OXO145I=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-576-kbW7kWNCOLCWR3zA-QPiRg-1; Mon, 24 Oct 2022 08:32:49 -0400
X-MC-Unique: kbW7kWNCOLCWR3zA-QPiRg-1
Received: by mail-qt1-f199.google.com with SMTP id 17-20020ac85711000000b0039ccd4c9a37so7027568qtw.20
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=boXDPcxpUocdHWEdF4boM/MTFdSB/GctSLK4grdDmW0=;
        b=fxWx3DcIUEntB2WYx0GMJaNzW/H5R1HbE5Nlw1fBgLL1oUzPys+iq0wnLKMaSWlYuY
         MKrKt2BetQO0PoEOIaiOmy2IZGlVobv7fX4g/0Zv6gZmZ8fBMYqXGK5VXI/x9v91SjrM
         1G/B/aeHlOzljOY5vt1d2YnZIOTISrK31aDf6YZMCNnly/R+eE6TCm07YW19hBID9Mi2
         WWy72mqcEgHQ8uNLxOgE3LBX5Tyd0fk+ZwoV3J6nifmMRCwyw8dFPxgJYlVyYDn2gRWY
         sYbvvHYU3cTejr0YpvcCKQGhKl1tJ2sOFW/4XiMeq5A/JXWc0njKlAce0nSUHTwrW/+w
         fdNA==
X-Gm-Message-State: ACrzQf3YBvZx73lxF4JZehaNNWZ+Wkoqm7e6J2Vk4MFblIwnUvGAnh9m
        uzn2Ha52k3lAB+0sVX5sn0FViazAuEhmosRhz2AZCn51gcnttUlWOkJ3zF62c6lbawSxpg+jI+F
        uLCuxZxzeDclC
X-Received: by 2002:a05:620a:204d:b0:6ec:7d7:c267 with SMTP id d13-20020a05620a204d00b006ec07d7c267mr22249337qka.590.1666614769170;
        Mon, 24 Oct 2022 05:32:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6UhB1DniE1v1NE2j7D6eQgJNHQkTjY/tKi8q+Ug9EaM9F0d6gOFPBNF3Bze0Eb+whBF2gc6w==
X-Received: by 2002:a05:620a:204d:b0:6ec:7d7:c267 with SMTP id d13-20020a05620a204d00b006ec07d7c267mr22249321qka.590.1666614768907;
        Mon, 24 Oct 2022 05:32:48 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id r28-20020ae9d61c000000b006ed30a8fb21sm14882555qkk.76.2022.10.24.05.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:32:48 -0700 (PDT)
Message-ID: <7bc85cd1e54300169ee287537fd794712ce93ea8.camel@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: allow compiling out SMM support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Date:   Mon, 24 Oct 2022 15:32:45 +0300
In-Reply-To: <20220929172016.319443-6-pbonzini@redhat.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
         <20220929172016.319443-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-29 at 13:20 -0400, Paolo Bonzini wrote:
> Some users of KVM implement the UEFI variable store through a paravirtual device
> that does not require the "SMM lockbox" component of edk2; allow them to
> compile out system management mode, which is not a full implementation
> especially in how it interacts with nested virtualization.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/Kconfig                          | 11 ++++++++++
>  arch/x86/kvm/Makefile                         |  2 +-
>  arch/x86/kvm/smm.h                            | 13 ++++++++++++
>  arch/x86/kvm/svm/svm.c                        |  2 ++
>  arch/x86/kvm/vmx/vmx.c                        |  2 ++
>  arch/x86/kvm/x86.c                            | 21 +++++++++++++++++--
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  2 ++
>  7 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index a107df22ffee..1679f9b4e96d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -88,6 +88,17 @@ config KVM_INTEL
>  	  To compile this as a module, choose M here: the module
>  	  will be called kvm-intel.
>  
> +config KVM_SMM
> +	bool "System Management Mode emulation"
> +	default y
> +	depends on KVM
> +	help
> +	  Provides support for KVM to emulate System Management Mode (SMM)
> +	  in virtual machines.  This can be used by the virtual machine
> +	  firmware to implement UEFI secure boot.
> +
> +	  If unsure, say Y.
> +
>  config X86_SGX_KVM
>  	bool "Software Guard eXtensions (SGX) Virtualization"
>  	depends on X86_SGX && KVM_INTEL
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index ec6f7656254b..6cf40f668277 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -20,7 +20,7 @@ endif
>  
>  kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
>  kvm-$(CONFIG_KVM_XEN)	+= xen.o
> -kvm-y			+= smm.o
> +kvm-$(CONFIG_KVM_SMM)	+= smm.o
>  
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>  			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index b0602a92e511..4c699fee4492 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -8,6 +8,7 @@
>  #define PUT_SMSTATE(type, buf, offset, val)                      \
>  	*(type *)((buf) + (offset) - 0x7e00) = val
>  
> +#ifdef CONFIG_KVM_SMM
>  static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
>  {
>  	kvm_make_request(KVM_REQ_SMI, vcpu);
> @@ -23,5 +24,17 @@ void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm);
>  void enter_smm(struct kvm_vcpu *vcpu);
>  int emulator_leave_smm(struct x86_emulate_ctxt *ctxt);
>  void process_smi(struct kvm_vcpu *vcpu);
> +#else
> +static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
> +static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
> +static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
> +static inline void enter_smm(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
> +static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
> +
> +/*
> + * emulator_leave_smm is used as a function pointer, so the
> + * stub is defined in x86.c.

Took me a while to figure out this comment.
I think it might be worth it to remove it, I don't think it helps much.

Or maybe even #ifdef the .leave_smm out of emulate_ops and check for NULL pointer,
in em_rsm (which should just #UD at the very start of it anyway.

Besides this:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky



> + */
> +#endif
>  
>  #endif
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 496ee7d1ae2f..6f7ceb35d2ff 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4150,6 +4150,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>  	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
>  		return false;
>  	case MSR_IA32_SMBASE:
> +		if (!IS_ENABLED(CONFIG_KVM_SMM))
> +			return false;
>  		/* SEV-ES guests do not support SMM, so report false */
>  		if (kvm && sev_es_guest(kvm))
>  			return false;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 038809c68006..b22330a15adb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6841,6 +6841,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
>  {
>  	switch (index) {
>  	case MSR_IA32_SMBASE:
> +		if (!IS_ENABLED(CONFIG_KVM_SMM))
> +			return false;
>  		/*
>  		 * We cannot do SMM unless we can run the guest in big
>  		 * real mode.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 97a871635986..a9e050aefea6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3636,7 +3636,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	}
>  	case MSR_IA32_SMBASE:
> -		if (!msr_info->host_initiated)
> +		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
>  			return 1;
>  		vcpu->arch.smbase = data;
>  		break;
> @@ -4052,7 +4052,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
>  		break;
>  	case MSR_IA32_SMBASE:
> -		if (!msr_info->host_initiated)
> +		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
>  			return 1;
>  		msr_info->data = vcpu->arch.smbase;
>  		break;
> @@ -4426,6 +4426,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			r |= KVM_X86_DISABLE_EXITS_MWAIT;
>  		break;
>  	case KVM_CAP_X86_SMM:
> +		if (!IS_ENABLED(CONFIG_KVM_SMM))
> +			break;
> +
>  		/* SMBASE is usually relocated above 1M on modern chipsets,
>  		 * and SMM handlers might indeed rely on 4G segment limits,
>  		 * so do not report SMM to be available if real mode is
> @@ -5176,6 +5179,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  		vcpu->arch.apic->sipi_vector = events->sipi_vector;
>  
>  	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
> +		if (!IS_ENABLED(CONFIG_KVM_SMM) &&
> +		    (events->smi.smm ||
> +		     events->smi.pending ||
> +		     events->smi.smm_inside_nmi))
> +			return -EINVAL;
> +
>  		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
>  			kvm_x86_ops.nested_ops->leave_nested(vcpu);
>  			kvm_smm_changed(vcpu, events->smi.smm);
> @@ -8066,6 +8075,14 @@ static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
>  	return emul_to_vcpu(ctxt)->arch.hflags;
>  }
>  
> +#ifndef CONFIG_KVM_SMM
> +static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
> +{
> +	WARN_ON_ONCE(1);
> +	return X86EMUL_UNHANDLEABLE;
> +}
> +#endif
> +
>  static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
>  {
>  	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 1f136a81858e..cb38a478e1f6 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -137,6 +137,8 @@ int main(int argc, char *argv[])
>  	struct kvm_x86_state *state;
>  	int stage, stage_reported;
>  
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_SMM));
> +
>  	/* Create VM */
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  


