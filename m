Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3C641B9BF
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 23:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhI1WBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242958AbhI1WBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:01:14 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAE1C061749
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:59:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 66so94771pgc.9
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 14:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hR85GCZfhL4YJawbBftoxChN3cnahiYUmelBrtysYzQ=;
        b=d0JUHehyLXdFA5B/wgcgOjwuw3aZVkCR3Gk+OriLfpCmsGGgRbZi5+6+5dzXaHm/Rk
         H3TiGrTERzN09CS95iDAWiZDAmZQ7WtptNJXypeXDWyysDPrB9RadntKAmDj8faRpKjd
         fMchWKVs2KViwzp7iD2lGulOLLVhw7YhvFLNSrL+7iYLmoBrEXEPXy3mdg2HCz/DUqRI
         DfUngAkqbFuin6e/uZEVEtmEQ9sA6tW5M9iMir9UF/2O+6uyZKAnHgdD6XMtiWjc3kEe
         tZ6voUkCgJodnBe8T1C1vXvGgmHGQNNecVIO2odLcNPxegnl1sNnabyit3FrxNWbwdpX
         e9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hR85GCZfhL4YJawbBftoxChN3cnahiYUmelBrtysYzQ=;
        b=JwyyyrruuC5wPdJEG7zLY0B42mznFlwwdiP+RX2yFZ9lVujSi0ZjCXrzgzz44qBjSu
         0oUcuxBvEzxyECs9RUA9MaBKHckYH7LIQzIHyveSeiqeZ65/0ShH2LShR4XIzsnsk/05
         yv6UIt4aYfVMhY/1VqCTm44N9jtq4H7/AGm9OqnJEOiooQUTZnSt0J0IItaGihjotlHM
         tjryq/qL7aqXzk3KI3g7gbBXHhCyVI9f1yk3uLQtN8j1yFbJCdi5mw1DeSLTFIM8xzTZ
         xZk0gBlE4VZPQCQ3kiymVx9G4C45pHM4LP+bicI8fkNFy/b3fPgYoRV+cFjuq89QYxHC
         frmg==
X-Gm-Message-State: AOAM532X6LYKDjec67On3N8foHnIa961tq6c5UR/vi3tPQkjsVPq5Tdh
        VeNU5/wg92i7U5R4JhVN5g2jpQ==
X-Google-Smtp-Source: ABdhPJywxfOyjT/Bbb3z07Sb4ifGRgqWGAJFb2yLMs8NKV2zXEevYh6BB5SfG6ECW1CSnDRZbY3y1w==
X-Received: by 2002:a63:50b:: with SMTP id 11mr5654394pgf.308.1632866373808;
        Tue, 28 Sep 2021 14:59:33 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z14sm83969pjq.48.2021.09.28.14.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:59:32 -0700 (PDT)
Date:   Tue, 28 Sep 2021 21:59:29 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 08/14] KVM: x86: Tweak halt emulation helper names to
 free up kvm_vcpu_halt()
Message-ID: <YVOQQfgNDO3L0RsS@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-9-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:22PM -0700, Sean Christopherson wrote:
> Rename a variety of HLT-related helpers to free up the function name
> "kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
> between "block" and "halt".
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  arch/x86/kvm/x86.c              | 13 +++++++------
>  4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4e8c21083bdb..cfebef10b89c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1679,7 +1679,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
>  int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
>  int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
>  int kvm_emulate_halt(struct kvm_vcpu *vcpu);
> -int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
>  int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
>  int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index eedcebf58004..f689e463b678 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3618,7 +3618,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
>  		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
>  			vmx->nested.nested_run_pending = 0;
> -			return kvm_vcpu_halt(vcpu);
> +			return kvm_emulate_halt_noskip(vcpu);
>  		}
>  		break;
>  	case GUEST_ACTIVITY_WAIT_SIPI:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d118daed0530..858f5f1f1273 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4740,7 +4740,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
>  		if (kvm_emulate_instruction(vcpu, 0)) {
>  			if (vcpu->arch.halt_request) {
>  				vcpu->arch.halt_request = 0;
> -				return kvm_vcpu_halt(vcpu);
> +				return kvm_emulate_halt_noskip(vcpu);
>  			}
>  			return 1;
>  		}
> @@ -5414,7 +5414,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  
>  		if (vcpu->arch.halt_request) {
>  			vcpu->arch.halt_request = 0;
> -			return kvm_vcpu_halt(vcpu);
> +			return kvm_emulate_halt_noskip(vcpu);
>  		}
>  
>  		/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c21d42f453..eade8a2bdccf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8643,7 +8643,7 @@ void kvm_arch_exit(void)
>  #endif
>  }
>  
> -static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> +static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  {
>  	++vcpu->stat.halt_exits;
>  	if (lapic_in_kernel(vcpu)) {
> @@ -8655,11 +8655,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  	}
>  }
>  
> -int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
>  {
> -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
> +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
> +EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
>  
>  int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>  {
> @@ -8668,7 +8668,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>  	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
>  	 * KVM_EXIT_DEBUG here.
>  	 */
> -	return kvm_vcpu_halt(vcpu) && ret;
> +	return kvm_emulate_halt_noskip(vcpu) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
> @@ -8676,7 +8676,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
>  {
>  	int ret = kvm_skip_emulated_instruction(vcpu);
>  
> -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
> +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
> +					KVM_EXIT_AP_RESET_HOLD) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
