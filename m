Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3504C52AC
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiBZAXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237834AbiBZAXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:23:33 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966E84D9F8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:22:59 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 195so8523097iou.0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m07rvPoGAywEi50efL+AmgwC/dtPWdvUl29YGfa/IFk=;
        b=bdgICM8Ev9N/71Y8csXRqIKe2bmf7tsU+9HMvxiVPVlth+SDZ/CbDWywVo4Dy0567k
         dgDk1Ionb8EVs7JqElL+FTMiuEiEFPWIlb8vB4Jzt8KPRUPsc+s7APEkIyD4cjDWHzAy
         ongld71VmJ+JiFIhLd+W0hGjrEDqdfLjmW2gdIIanClZmvf5p2N5qZnD3SG/seDQIaK+
         zNh8QLiNF6u5Z4NmO9zZQFJ/nbcoLdAXFsNgsPaw+0THpvybiAwV0p9KNwqy2yEQ8CKw
         dVDBb7jjI0Qf8ETMF+wPwQRDfK3gCPlQcMfyJ8pYWbFBxXDyJO1BBWKjh4x7XbFm/zIb
         /OoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m07rvPoGAywEi50efL+AmgwC/dtPWdvUl29YGfa/IFk=;
        b=ZF1qh9dl9g81WUMskmZBVJDK0SBglxR2AJRBJH0m2aBOQspVzAIRe2gagW+uavJUxT
         7CBQhlTZVTNUzXJgP0dhusumUzaCWCo2uSda0L34lBiyAoEheRE0UKGnPgcb9JC8i5os
         +OdSeVcX9Q9vA3c+Z6YkjblBmOTkrywR+gxZnSDtqtzsuSAz4T+1lHbvINH+ccc651xG
         +LtHdjNoQjtNw683p32QxgbZK9b6sBDr2yROzyW626jhkRGARRoBhtU/42KT0mwW7UxY
         jz/UuUzw0L0hm0Jluvhceaj2Shba3XAENWlY79RIbA/riFlXBXpZlg2jiwIcjD+Ed9rV
         mZHw==
X-Gm-Message-State: AOAM5333RtK0URH765PHYbeyc9qfTBunK+XXI5aPq+wjAPjluHJrqe9I
        MAP6rm6N9k/gZG8ARlIwkrWL6ylEgD3cYg==
X-Google-Smtp-Source: ABdhPJylNrQFL7DU1hJVbAdoaFCPpfhOzszGKm3cMVz8HHPBuq4GU1wjoASHAgn/zBPXJIs0UuFmGw==
X-Received: by 2002:a6b:fc07:0:b0:640:5cfd:4557 with SMTP id r7-20020a6bfc07000000b006405cfd4557mr7274404ioh.75.1645834978372;
        Fri, 25 Feb 2022 16:22:58 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d8785000000b00604cdf69dc8sm2352401ion.13.2022.02.25.16.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 16:22:57 -0800 (PST)
Date:   Sat, 26 Feb 2022 00:22:54 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
Message-ID: <Yhly3pMxhmtOtthr@google.com>
References: <20220226002124.2747985-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226002124.2747985-1-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022 at 12:21:24AM +0000, Oliver Upton wrote:
> KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
> advertise the set of quirks which may be disabled to userspace, so it is
> impossible to predict the behavior of KVM. Worse yet,
> KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
> it fails to reject attempts to set invalid quirk bits.
> 
> The only valid workaround for the quirky quirks API is to add a new CAP.
> Actually advertise the set of quirks that can be disabled to userspace
> so it can predict KVM's behavior. Reject values for cap->args[0] that
> contain invalid bits.
> 
> Finally, add documentation for the new capability and describe the
> existing quirks.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> 
>  This patch applies cleanly to 5.17-rc5. I am working on
>  another series that introduces yet another KVM quirk [1], but wanted to
>  send this patch out ahead of reworking that series.
> 
>  Should we introduce another quirk, KVM_X86_QUIRK_QUIRKY_DISABLE_QUIRKS,
>  that provides the new ABI to the old quirks capability? :-P
> 

 [1]: http://lore.kernel.org/r/20220225200823.2522321-1-oupton@google.com

>  Documentation/virt/kvm/api.rst  | 51 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  7 +++++
>  arch/x86/kvm/x86.c              |  8 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  4 files changed, 67 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..bad9e54cbb68 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6997,6 +6997,57 @@ indicated by the fd to the VM this is called on.
>  This is intended to support intra-host migration of VMs between userspace VMMs,
>  upgrading the VMM process without interrupting the guest.
>  
> +7.30 KVM_CAP_DISABLE_QUIRKS2
> +----------------------------
> +
> +:Capability: KVM_CAP_DISABLE_QUIRKS2
> +:Parameters: args[0] - set of KVM quirks to disable
> +:Architectures: x86
> +:Type: vm
> +
> +This capability, if enabled, will cause KVM to disable some behavior
> +quirks.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> +quirks that can be disabled in KVM.
> +
> +The argument to KVM_ENABLE_CAP for this capability is a bitmask of
> +quirks to disable, and must be a subset of the bitmask returned by
> +KVM_CHECK_EXTENSION.
> +
> +The valid bits in cap.args[0] are:
> +
> +=================================== ============================================
> + KVM_X86_QUIRK_LINT0_ENABLED        By default, the reset value for the LVT
> +                                    LINT0 register is 0x700 (APIC_MODE_EXTINT).
> +                                    When this quirk is disabled, the reset value
> +                                    is 0x10000 (APIC_LVT_MASKED).
> +
> + KVM_X86_QUIRK_CD_NW_CLEARED        By default, KVM clears CR0.CD and CR0.NW.
> +                                    When this quirk is disabled, KVM does not
> +                                    change the value of CR0.CD and CR0.NW.
> +
> + KVM_X86_QUIRK_LAPIC_MMIO_HOLE      By default, the MMIO LAPIC interface is
> +                                    available even when configured for x2APIC
> +                                    mode. When this quirk is disabled, KVM
> +                                    disables the MMIO LAPIC interface if the
> +                                    LAPIC is in x2APIC mode.
> +
> + KVM_X86_QUIRK_OUT_7E_INC_RIP       By default, KVM pre-increments %rip before
> +                                    exiting to userspace for an OUT instruction
> +                                    to port 0x7e. When this quirk is disabled,
> +                                    KVM does not pre-increment %rip before
> +                                    exiting to userspace.
> +
> + KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT When this quirk is disabled, KVM sets
> +                                    CPUID.01H:ECX[bit 3] (MONITOR/MWAIT) if
> +                                    IA32_MISC_ENABLE[bit 18] (MWAIT) is set.
> +                                    Additionally, when this quirk is disabled,
> +                                    KVM clears CPUID.01H:ECX[bit 3] if
> +                                    IA32_MISC_ENABLE[bit 18] is cleared.
> +=================================== ============================================
> +
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6dcccb304775..4f01eb977338 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1955,4 +1955,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>  #define KVM_CLOCK_VALID_FLAGS						\
>  	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
>  
> +#define KVM_X86_VALID_QUIRKS			\
> +	(KVM_X86_QUIRK_LINT0_REENABLED |	\
> +	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
> +	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
> +	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
> +	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 641044db415d..e5227aca9e7e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4331,6 +4331,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			r = sizeof(struct kvm_xsave);
>  		break;
>  	}
> +	case KVM_CAP_DISABLE_QUIRKS2:
> +		r = KVM_X86_VALID_QUIRKS;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -5877,6 +5880,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		return -EINVAL;
>  
>  	switch (cap->cap) {
> +	case KVM_CAP_DISABLE_QUIRKS2:
> +		r = -EINVAL;
> +		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> +			break;
> +		fallthrough;
>  	case KVM_CAP_DISABLE_QUIRKS:
>  		kvm->arch.disabled_quirks = cap->args[0];
>  		r = 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5191b57e1562..9f7410496b36 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_VM_GPA_BITS 207
>  #define KVM_CAP_XSAVE2 208
>  #define KVM_CAP_SYS_ATTRIBUTES 209
> +#define KVM_CAP_DISABLE_QUIRKS2 210
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
