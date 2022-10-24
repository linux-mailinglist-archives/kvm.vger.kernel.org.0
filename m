Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14BB60B7F7
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 21:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiJXTip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 15:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiJXTi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 15:38:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92166CF66
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 11:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666634847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+fdcybGKKueQVmUkWfFf9NqNQ5vQiS0ZoMQxt1soXo=;
        b=LaYJMzH74Wb45+eS9q+MICTCJDpbv5hoGhO84fg7MSEkgi8YL8/2CkcO4K4OEko8YVTKfW
        jHoeQ0nytPL8qVQhuVoLr+sFxZPB574aYQIl01g3UXTaZHdHrkhdzAINu12okz+niCXdya
        pDJgpi3Zglo37B+SoB9vDl2sxLKqqxw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-i5YuIn6KPUCpsqnZGNhQXw-1; Mon, 24 Oct 2022 08:33:01 -0400
X-MC-Unique: i5YuIn6KPUCpsqnZGNhQXw-1
Received: by mail-qv1-f72.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso598678qvb.23
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W+fdcybGKKueQVmUkWfFf9NqNQ5vQiS0ZoMQxt1soXo=;
        b=rtVUQ+KDoqS+JLBQ5Vhezwzl3K/GeVMWU6Q7UzL3VZUhZCy9Fgiq5X+P1ykGR/X3FJ
         brZq+NUMV3vuuwJ/JeIdJ8Ccvn3imT8nWfAGtq9/EEsWscxkpPbjH1HUaDzI1zNITH77
         RUrhJtivOtrDxRmfYJw7X0IW96g/+gwy4+BBPmjnziCNC+Mprs7EKflUEr7HCenPTMIL
         UKmz1oprEnG8u02KkiO+CrLY4b5364qefO0LzkW1aBaYmPvqbjzQhhh301HrPXTPmYwS
         Nv5w5VL33aDAXcxV4+RxWk+YizsvueKFB03k9XwNNSyRkY57PIt/8uFhsYATOavfv9LP
         2wfw==
X-Gm-Message-State: ACrzQf3tcmE5sh0ZFAorA7u2nmgr58uVfFuFgfDO4nW2Ki9wDPZskSiP
        hTaWqPBJgb8N5m25kc1ZyaexmJ2pTyLjozseG2WEO+SlZRGWx+8+eK1V94IJpOJXKkNxVHBgjeA
        zr5SdGvzRtCWP
X-Received: by 2002:a05:622a:14ce:b0:39e:55d0:3adb with SMTP id u14-20020a05622a14ce00b0039e55d03adbmr13038024qtx.173.1666614779800;
        Mon, 24 Oct 2022 05:32:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM476vak4h7wQLJy0TX6bibVsI+8/xuysaR7DC0P+B1o2MYN8npGL19ECTQUWQ6ZiTy3AeMF1w==
X-Received: by 2002:a05:622a:14ce:b0:39e:55d0:3adb with SMTP id u14-20020a05622a14ce00b0039e55d03adbmr13038005qtx.173.1666614779527;
        Mon, 24 Oct 2022 05:32:59 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id cf17-20020a05622a401100b0039c7b9522ecsm12830568qtb.35.2022.10.24.05.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:32:59 -0700 (PDT)
Message-ID: <7a9fb4d7f3f9fbe977ab4bb38711520673aa03cc.camel@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: compile out vendor-specific code if
 SMM is disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Date:   Mon, 24 Oct 2022 15:32:56 +0300
In-Reply-To: <20220929172016.319443-7-pbonzini@redhat.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
         <20220929172016.319443-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-29 at 13:20 -0400, Paolo Bonzini wrote:
> Vendor-specific code that deals with SMI injection and saving/restoring
> SMM state is not needed if CONFIG_KVM_SMM is disabled, so remove the
> four callbacks smi_allowed, enter_smm, leave_smm and enable_smi_window.
> The users in svm/nested.c and x86.c also have to be compiled out; the
> amount of #ifdef'ed code is small and it's not worth moving it to
> smm.c.
> 
> enter_smm is now used only within #ifdef CONFIG_KVM_SMM, and the stub
> can therefore be removed.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 ++
>  arch/x86/include/asm/kvm_host.h    | 2 ++
>  arch/x86/kvm/smm.h                 | 1 -
>  arch/x86/kvm/svm/nested.c          | 2 ++
>  arch/x86/kvm/svm/svm.c             | 4 ++++
>  arch/x86/kvm/vmx/vmx.c             | 4 ++++
>  arch/x86/kvm/x86.c                 | 4 ++++
>  7 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 82ba4a564e58..ea58e67e9a67 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -110,10 +110,12 @@ KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
>  KVM_X86_OP_OPTIONAL(set_hv_timer)
>  KVM_X86_OP_OPTIONAL(cancel_hv_timer)
>  KVM_X86_OP(setup_mce)
> +#ifdef CONFIG_KVM_SMM
>  KVM_X86_OP(smi_allowed)
>  KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
> +#endif
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b7d078cd768d..cb88da02d965 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1606,10 +1606,12 @@ struct kvm_x86_ops {
>  
>  	void (*setup_mce)(struct kvm_vcpu *vcpu);
>  
> +#ifdef CONFIG_KVM_SMM
>  	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
>  	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
>  	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
> +#endif
>  
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index 4c699fee4492..7ccce6b655ca 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -28,7 +28,6 @@ void process_smi(struct kvm_vcpu *vcpu);
>  static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
>  static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
>  static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
> -static inline void enter_smm(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
>  static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
>  
>  /*
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cc0fd75f7cba..b258d6988f5d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1378,6 +1378,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  		return 0;
>  	}
>  
> +#ifdef CONFIG_KVM_SMM
>  	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
>  		if (block_nested_events)
>  			return -EBUSY;
> @@ -1386,6 +1387,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  		nested_svm_simple_vmexit(svm, SVM_EXIT_SMI);
>  		return 0;
>  	}
> +#endif
>  
>  	if (vcpu->arch.nmi_pending && !svm_nmi_blocked(vcpu)) {
>  		if (block_nested_events)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6f7ceb35d2ff..2200b8aa7273 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4408,6 +4408,7 @@ static void svm_setup_mce(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mcg_cap &= 0x1ff;
>  }
>  
> +#ifdef CONFIG_KVM_SMM
>  bool svm_smi_blocked(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4557,6 +4558,7 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
>  		/* We must be in SMM; RSM will cause a vmexit anyway.  */
>  	}
>  }
> +#endif
>  
>  static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>  					void *insn, int insn_len)
> @@ -4832,10 +4834,12 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.pi_update_irte = avic_pi_update_irte,
>  	.setup_mce = svm_setup_mce,
>  
> +#ifdef CONFIG_KVM_SMM
>  	.smi_allowed = svm_smi_allowed,
>  	.enter_smm = svm_enter_smm,
>  	.leave_smm = svm_leave_smm,
>  	.enable_smi_window = svm_enable_smi_window,
> +#endif
>  
>  	.mem_enc_ioctl = sev_mem_enc_ioctl,
>  	.mem_enc_register_region = sev_mem_enc_register_region,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b22330a15adb..107fc035c91b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7905,6 +7905,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
>  			~FEAT_CTL_LMCE_ENABLED;
>  }
>  
> +#ifdef CONFIG_KVM_SMM
>  static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  {
>  	/* we need a nested vmexit to enter SMM, postpone if run is pending */
> @@ -7959,6 +7960,7 @@ static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
>  {
>  	/* RSM will cause a vmexit anyway.  */
>  }
> +#endif
>  
>  static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  {
> @@ -8126,10 +8128,12 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.setup_mce = vmx_setup_mce,
>  
> +#ifdef CONFIG_KVM_SMM
>  	.smi_allowed = vmx_smi_allowed,
>  	.enter_smm = vmx_enter_smm,
>  	.leave_smm = vmx_leave_smm,
>  	.enable_smi_window = vmx_enable_smi_window,
> +#endif
>  
>  	.can_emulate_instruction = vmx_can_emulate_instruction,
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9e050aefea6..e22184bad92b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9863,6 +9863,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>  	 * in order to make progress and get back here for another iteration.
>  	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
>  	 */
> +#ifdef CONFIG_KVM_SMM
>  	if (vcpu->arch.smi_pending) {
>  		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
>  		if (r < 0)
> @@ -9875,6 +9876,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>  		} else
>  			static_call(kvm_x86_enable_smi_window)(vcpu);
>  	}
> +#endif
>  
>  	if (vcpu->arch.nmi_pending) {
>  		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
> @@ -12491,10 +12493,12 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  	     static_call(kvm_x86_nmi_allowed)(vcpu, false)))
>  		return true;
>  
> +#ifdef CONFIG_KVM_SMM
>  	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
>  	    (vcpu->arch.smi_pending &&
>  	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
>  		return true;
> +#endif
>  
>  	if (kvm_arch_interrupt_allowed(vcpu) &&
>  	    (kvm_cpu_has_interrupt(vcpu) ||


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


