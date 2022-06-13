Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F7C549D52
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbiFMTT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351229AbiFMTTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:19:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52D927FDF
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:16:58 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so6325075pfb.4
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4TaaV2PEoFhV4y67SQr7QhEUHOK5RcdeAAxsIltPwAU=;
        b=WXComPS7WulpGwGpqiaTQf8XJe7dX407TYL+QI+yCy4IkSrjD27CrJzyYgd0MgGeCR
         jAKLJBGh87eIrgDAHVqFDk/DDcQM23qx/IMFDzQHSqenbwGV3Og2nUWk3co6hXYBkDPQ
         RdauMPRH9EfKpLJ8cHGxRoFrZOBGwMgsCI83FADyvT9EOU9ckqcEjwkGdOkSqE2y+noo
         Lj2C05rOlOkSFK31YS14nS0LP4SKUgHji02PrRX0Kl2KXWQWIvH89htw24DgSjnNEXfn
         MGhCMbyOjfyMp+6hzjfQoHllLlD+PF7vzfYpX2ItfQfQmz5WYPfr6RYr5UG9q7LhAY3g
         OKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4TaaV2PEoFhV4y67SQr7QhEUHOK5RcdeAAxsIltPwAU=;
        b=yq2r+YtkUCR2LbEUUrK5XcVLwnkJzBMqlDM1b6bXc74RUdKejipG+xxHZXBgyzjL/i
         533v/TR2WLhqU0vHffF6rJ0TwGKqFPrQTmoGD+zuhsc5PN3EtE50UfPk0BwB5MGp2bJt
         czsbL8S+nlVrbbID7apO0QqBfuBpXQtuWwf/VFZkbA2pQ6Fw42NzSmwtNEGJ0Qwt26Wh
         OFLIAjKAixAmrwJINkiiDPNmgcZFlb2CRBKOjLa7jSXpPNcEwIfsg+U/6OG8JnHF3s/+
         98ZeATe107Q+LToVJbM2dfaJiz7xZGlhSZkhnXANEMhq/DaBAXTPC+8yYor+mKQN8Kgu
         tV2Q==
X-Gm-Message-State: AOAM532cG91vcJmancPd0lzUlKpXU9RwitM1hyFY5D9xWxcj/blWKr5W
        nWFgZjmOrR5IfQrqxsq3qu/lqA==
X-Google-Smtp-Source: ABdhPJwMozkURIYk+QKnVhZsCbbtI2V04QuQtsbR5BUKWn9xwuZRWm3qzw0SOP0F4rx29MEGPm4ZKA==
X-Received: by 2002:a05:6a00:1585:b0:51c:3a6e:95f3 with SMTP id u5-20020a056a00158500b0051c3a6e95f3mr214729pfk.51.1655140617847;
        Mon, 13 Jun 2022 10:16:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k9-20020a056a00134900b0051bb0be7109sm5689429pfu.78.2022.06.13.10.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:16:57 -0700 (PDT)
Date:   Mon, 13 Jun 2022 17:16:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     wangguangju <wangguangju@baidu.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.co, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.orga
Subject: Re: [PATCH] KVM: x86: add a bool variable to distinguish whether to
 use PVIPI
Message-ID: <YqdxAFhkeLjvi7L5@google.com>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
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

The shortlog is not at all helpful, it doesn't say anything about what actual
functional change.

  KVM: x86: Don't advertise PV IPI to userspace if IPIs are virtualized

On Mon, Jun 13, 2022, wangguangju wrote:
> Commit d588bb9be1da ("KVM: VMX: enable IPI virtualization")
> enable IPI virtualization in Intel SPR platform.There is no point
> in using PVIPI if IPIv is supported, it doesn't work less good
> with PVIPI than without it.
> 
> So add a bool variable to distinguish whether to use PVIPI.

Similar complaint with the changelog, it doesn't actually call out why PV IPIs
are unwanted.

  Don't advertise PV IPI support to userspace if IPI virtualization is
  supported by the CPU.  Hardware virtualization of IPIs more performant
  as senders do not need to exit.

That said, I'm not sure that KVM should actually hide PV_SEND_IPI.  KVM still
supports the feature, and unlike sched_info_on(), IPI virtualization is platform
dependent and not fully controlled by software.  E.g. hiding PV_SEND_IPI could
cause problems when migrating from a platform without IPIv to a platform with IPIv,
as a paranoid VMM might complain that an exposed feature isn't supported by KVM.

There's also the question of what to do about AVIC.  AVIC has many more inhibits
than APICv, e.g. an x2APIC guest running on hardware that doesn't accelerate x2APIC
IPIs will probably be better off with PV IPIs.

Given that userspace should have read access to the module param, I'm tempted to
say KVM should let userspace make the decision of whether or not to advertise PV
IPIs to the guest.

> Signed-off-by: wangguangju <wangguangju@baidu.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/cpuid.c            | 4 +++-
>  arch/x86/kvm/vmx/vmx.c          | 1 +
>  arch/x86/kvm/x86.c              | 3 +++
>  4 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a4b9282..239c1a992 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1671,6 +1671,7 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>  			     bool mask);
>  
>  extern bool tdp_enabled;
> +extern bool kvm_ipiv_cap_supported;

Please use "struct kvm_caps", which was added specifically to avoid these one-off
bools.

>  u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d47222a..9643572 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1049,7 +1049,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			     (1 << KVM_FEATURE_PV_UNHALT) |
>  			     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
>  			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
> -			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
>  			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
>  			     (1 << KVM_FEATURE_ASYNC_PF_INT);
> @@ -1057,6 +1056,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
>  
> +		if (!kvm_ipiv_cap_supported)
> +			entry->eax |= (1 << KVM_FEATURE_PV_SEND_IPI);
> +
>  		entry->ebx = 0;
>  		entry->ecx = 0;
>  		entry->edx = 0;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f741de4..21b67f4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4490,6 +4490,7 @@ static int vmx_alloc_ipiv_pid_table(struct kvm *kvm)
>  		return -ENOMEM;
>  
>  	kvm_vmx->pid_table = (void *)page_address(pages);
> +	kvm_ipiv_cap_supported = true;

This is far too late, as allocation of the table doesn't happen until the first
VM is created.

E.g.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b959fe24c13b..73973b5901a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8221,6 +8221,7 @@ static __init int hardware_setup(void)
        kvm_caps.tsc_scaling_ratio_frac_bits = 48;
        kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
        kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
+       kvm_caps.has_ipi_virtualization = enable_ipiv;

        set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 501b884b8cc4..9b80aa67349f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -23,6 +23,7 @@ struct kvm_caps {
        bool has_bus_lock_exit;
        /* notify VM exit supported? */
        bool has_notify_vmexit;
+       bool has_ipi_virtualization;

        u64 supported_mce_cap;
        u64 supported_xcr0;


>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f9d0c56..099f76f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -226,6 +226,9 @@ EXPORT_SYMBOL_GPL(enable_apicv);
>  u64 __read_mostly host_xss;
>  EXPORT_SYMBOL_GPL(host_xss);
>  
> +bool __read_mostly kvm_ipiv_cap_supported = false;
> +EXPORT_SYMBOL_GPL(kvm_ipiv_cap_supported);
> +
>  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	KVM_GENERIC_VM_STATS(),
>  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
> -- 
> 2.9.4
> 
