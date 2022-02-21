Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD484BD47D
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 05:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245660AbiBUDwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 22:52:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiBUDwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 22:52:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A045D63D8;
        Sun, 20 Feb 2022 19:51:50 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z16so7602521pfh.3;
        Sun, 20 Feb 2022 19:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=f58UHmtxA9Fxr43BgobESkkdQEZYyN1KurW08pnfsyw=;
        b=bF11WpDeIhsCBe1iNQehlQLMeMHtVfIjgWxshHjU04dlvEI4NqInlbCIvKTGcxejkU
         ewmcqAYciG1DPcmK1hqLhWPqrV6RNdKK2ZoOsGMfPvuE4md94jBK5TeqcZTZOj7G5d7i
         iqQE0xcNCf00NJnvYoufj115HZWC0bDw6fOu2pRWhXBjUR99WzQtvdgYgGOWysQ8ceGA
         4TX3el7r/ohcVi9jyzP8tyo2Bov6wGo8qZZKT8q8HyL9m8w2f9agaqodGfqKRtpX3h2I
         I8rIn1eAOaQkSbC3pyiEFUHgirxOcbUl78jlUpLUVbJfjEcY84kHJkoWTW2M+tflEdu3
         2mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=f58UHmtxA9Fxr43BgobESkkdQEZYyN1KurW08pnfsyw=;
        b=3CGCdRKpHYKPu2o22I+a5fVUzB4j8LEZfzEOXAbki/uKPAngfnuUe7zziC/n/bzkj3
         3XXqeqDvpL3gfeotYM0xb2Zus984zW62ud3zZ2LYrqGqwGlQHUNCQ+brf0+7DAbHkY0H
         1Gghrokhkioo5VliwG5UPYQzUgFtjPzpfBwOrvwtPvwVRNnALq0fWtCDNrJdg17KhpDl
         Ru5xuWyCuXTqSFsx9IYizrPGC6Zo6fPfIDL7L+G8mTscbhBxThhxvwJ4qWJKt7hwxzCS
         OdAdraDSTZN3SnLJ/77/SwaDvoSPQE7amIASXelXXqiJRnbXvTBZZrDQdEzwm5CsM9u1
         Vhww==
X-Gm-Message-State: AOAM533zF+Fkc126xi3ZlSgbshsRzZ2EuI6spzUzSuuGMt9GiVu8JpzA
        inGdVZlGukxn/XCCv8kb9yc=
X-Google-Smtp-Source: ABdhPJxDfJ+dFbFgKehDa2W6rO79nRH+lOJSWgJufMosXRXPGlzK2+IOP+Fer6BLyTphlbynfO7QYQ==
X-Received: by 2002:a63:2a53:0:b0:372:cb6d:3d61 with SMTP id q80-20020a632a53000000b00372cb6d3d61mr14718909pgq.575.1645415510087;
        Sun, 20 Feb 2022 19:51:50 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x1sm16241413pga.40.2022.02.20.19.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 19:51:49 -0800 (PST)
Message-ID: <0ef7609d-3668-9102-50c5-83b25104207e@gmail.com>
Date:   Mon, 21 Feb 2022 11:51:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2] KVM: x86: pull kvm->srcu read-side to
 kvm_arch_vcpu_ioctl_run
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20220219093404.367207-1-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220219093404.367207-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/2/2022 5:34 pm, Paolo Bonzini wrote:
> kvm_arch_vcpu_ioctl_run is already doing srcu_read_lock/unlock in two
> places, namely vcpu_run and post_kvm_run_save, and a third is actually
> needed around the call to vcpu->arch.complete_userspace_io to avoid
> the following splat:
> 
>    WARNING: suspicious RCU usage
>    arch/x86/kvm/pmu.c:190 suspicious rcu_dereference_check() usage!
>    other info that might help us debug this:
>    rcu_scheduler_active = 2, debug_locks = 1
>    1 lock held by CPU 28/KVM/370841:
>    #0: ff11004089f280b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x87/0x730 [kvm]
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x59/0x73
>     reprogram_fixed_counter+0x15d/0x1a0 [kvm]
>     kvm_pmu_trigger_event+0x1a3/0x260 [kvm]
>     ? free_moved_vector+0x1b4/0x1e0
>     complete_fast_pio_in+0x8a/0xd0 [kvm]
> 
> This splat is not at all unexpected, since complete_userspace_io
> callbacks can execute similar code to vmexits.  For example, SVM
> with nrips=false will call into the emulator from
> svm_skip_emulated_instruction().
> 
> Reported-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v2: actually commit what I tested... srcu_read_lock must be
> 	    before all "goto out"s.
> 
>   arch/x86/kvm/x86.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 82a9dcd8c67f..e55de9b48d1a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9180,6 +9180,7 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
>   		likely(!pic_in_kernel(vcpu->kvm));
>   }
>   
> +/* Called within kvm->srcu read side.  */
>   static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *kvm_run = vcpu->run;
> @@ -9188,16 +9189,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>   	kvm_run->cr8 = kvm_get_cr8(vcpu);
>   	kvm_run->apic_base = kvm_get_apic_base(vcpu);
>   
> -	/*
> -	 * The call to kvm_ready_for_interrupt_injection() may end up in
> -	 * kvm_xen_has_interrupt() which may require the srcu lock to be
> -	 * held, to protect against changes in the vcpu_info address.
> -	 */
> -	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>   	kvm_run->ready_for_interrupt_injection =
>   		pic_in_kernel(vcpu->kvm) ||
>   		kvm_vcpu_ready_for_interrupt_injection(vcpu);
> -	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>   
>   	if (is_smm(vcpu))
>   		kvm_run->flags |= KVM_RUN_X86_SMM;
> @@ -9815,6 +9809,7 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>   
>   /*
> + * Called within kvm->srcu read side.
>    * Returns 1 to let vcpu_run() continue the guest execution loop without
>    * exiting to the userspace.  Otherwise, the value will be returned to the
>    * userspace.
> @@ -10193,6 +10188,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	return r;
>   }
>   
> +/* Called within kvm->srcu read side.  */
>   static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>   {
>   	bool hv_timer;
> @@ -10252,12 +10248,12 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>   		!vcpu->arch.apf.halted);
>   }
>   
> +/* Called within kvm->srcu read side.  */
>   static int vcpu_run(struct kvm_vcpu *vcpu)
>   {
>   	int r;
>   	struct kvm *kvm = vcpu->kvm;
>   
> -	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>   	vcpu->arch.l1tf_flush_l1d = true;
>   
>   	for (;;) {
> @@ -10291,8 +10287,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>   		}
>   	}
>   
> -	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -
>   	return r;
>   }
>   
> @@ -10398,6 +10392,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>   int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *kvm_run = vcpu->run;
> +	struct kvm *kvm = vcpu->kvm;
>   	int r;
>   
>   	vcpu_load(vcpu);
> @@ -10405,6 +10400,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   	kvm_run->flags = 0;
>   	kvm_load_guest_fpu(vcpu);
>   
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);

With this patch (based on ec756e40e271), the kworker/140:1+rcu_gp task on the host
will be overused that it won't even be possible to quickly boot a 2U4G VM with QEMU.

>   	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
>   		if (kvm_run->immediate_exit) {
>   			r = -EINTR;
> @@ -10475,8 +10471,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   	if (kvm_run->kvm_valid_regs)
>   		store_regs(vcpu);
>   	post_kvm_run_save(vcpu);
> -	kvm_sigset_deactivate(vcpu);
> +	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>   
> +	kvm_sigset_deactivate(vcpu);
>   	vcpu_put(vcpu);
>   	return r;
>   }
