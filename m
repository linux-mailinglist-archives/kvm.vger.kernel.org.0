Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1D764EE27
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 16:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiLPPuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 10:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiLPPuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 10:50:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55896A742
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 07:49:58 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso6522306pjt.0
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 07:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rj5Uqkw1gZEmV+HNUxPQXfZdazuVrjKqfYi+1qz9emA=;
        b=jll4uLO1c2CaPoh6XOQ3WavXEgVbnnHlu2Yy6OlCSIyKOPsFIlNXIzKiUVQ309LeyH
         9KK3xkRbPhjeb+y0jNTJ9KZ3PNFo/bJqdgoYqBEGMKmoxWZSCNBAxTZpYkpgafWbqnri
         gkVVz1u6FTLazG5pBkc9RAz7Xv21yhJ7I5JpEyDob1YDU+nkQEqsDDnlpQwtWmGYXf3D
         0/FYy9Jo+KWeu/KpbXyo5T8A9VlqDiXZicmK/yf4GoRI/3DdWKuwm5vh6QBDMrOxHxVP
         A23y2nKmD4j3nREqZS4dT6KR2ep7MMVWgHalktDXtj0mVQkbr+xWPmEi5gIP/zToKOcY
         OQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rj5Uqkw1gZEmV+HNUxPQXfZdazuVrjKqfYi+1qz9emA=;
        b=e6y9483hJvJ8p8f5OXzJUxTg4vyGPVeX2axZl/fYdDz+gbxuU7kbSAKI5hrvyzgqE7
         FLkN7yB5upwhiFKfXPls8f2577qqQfUpXDraXLFuwAakpz4L7tv/EfRvQL5fLbi+Ha9l
         sw4UKD6/ku9jPRu7q3QdNGnVxQFVFNnReetIC46Mg7GuRqFBFFh3mqVvjbW3dnNrYsPH
         MymIoOCFLGXjZdqkQUjNTCW93e6phxct6o3zwfK6H1CVod9z7tT1a3LdG0Fgk3saGv6B
         F0REjkvfxjCJZ9dILNmkPFSfKhLWF5XNdLsfZ6XTG1dgpxDjZ5TP6rzv6UhlO5oWLymj
         U5NQ==
X-Gm-Message-State: AFqh2kpSww7+LzO3tlkyU8joc/xp/ks3uVFk5ZpUXkh77+z/xHnX26NK
        7uJgD7MVOmCvDqFFSig814zIiQ==
X-Google-Smtp-Source: AMrXdXtWv1fMD/s2vHYETVUYkT5dZGeaW9pUBEZZ1Q35QnTkJlPbA/J+DKN7qH2Hvq/VztqeTHt/ow==
X-Received: by 2002:a05:6a21:151b:b0:a3:49d2:9504 with SMTP id nq27-20020a056a21151b00b000a349d29504mr578160pzb.3.1671205798278;
        Fri, 16 Dec 2022 07:49:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r19-20020a63a553000000b00476b165ff8bsm1634017pgu.57.2022.12.16.07.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 07:49:56 -0800 (PST)
Date:   Fri, 16 Dec 2022 15:49:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 104/108] KVM: TDX: Silently ignore INIT/SIPI
Message-ID: <Y5yToW++7EVrMiMN@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <a888bb4d30de2e57b0eb5e61189349c86cab1a70.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a888bb4d30de2e57b0eb5e61189349c86cab1a70.1667110240.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 29, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
> Instead it defines the different protocols to boot application processors.
> Ignore INIT and SIPI events for the TDX guest.
> 
> There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
> error to guest TDs somehow.  Given that TDX guest is paravirtualized to
> boot AP, the option 1 is chosen for simplicity.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 4acba8d8cb27..d776d5d169d0 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -286,6 +286,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>  	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
>  }
>  
> +static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
> +}
> +
> +static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		/* TDX doesn't support INIT.  Ignore INIT event */
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +		return;
> +	}
> +
> +	kvm_vcpu_deliver_init(vcpu);
> +}
> +
>  static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
>  	if (is_td_vcpu(vcpu))
> @@ -627,7 +646,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.msr_filter_changed = vmx_msr_filter_changed,
>  	.complete_emulated_msr = kvm_complete_insn_gp,
>  
> -	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_init = vt_vcpu_deliver_init,

A simpler, and arguably more correct, appraoch would be to hook .apic_init_signal_blocked()
and have that return true for TDX.  Waiting until delivery means the vCPU will get
spurious wake events, e.g. KVM will wake the vCPU to service the INIT, but then
ignore the INIT.  Of course, sending the bogus INIT/SIPI in the first place
is a guest bug.

That would also prevent userspace from putting the vCPU into INIT/SIPI via
KVM_SET_MP_STATE.

Ideally, KVM would never mark INIT or SIPI pending in the first place, though I'm
not sure that's worth the effort.
