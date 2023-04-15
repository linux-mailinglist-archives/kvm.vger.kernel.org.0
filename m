Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777746E2EC0
	for <lists+kvm@lfdr.de>; Sat, 15 Apr 2023 05:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDODLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 23:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDODLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 23:11:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835FE1AC
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 20:11:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a273b3b466so353915ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 20:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681528278; x=1684120278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvRefNBdCntu+pZy/U4eeOw/+P3jSNTuSKl+Y+gg558=;
        b=OaOvmpDzv3+8A9qM0qt9IBR6/9mwsQAdQ1m6VNkf9JoXLA1xW95KIz9IV7p9qDwB/R
         erNPV+9DAqp+ny5DIU6YGDnc4QuaoBlrLXVS2UnfB/xrrNCTt5mXxPLgoqmj0sGQid7Z
         bFcyOanzbtEWTa65RmFlRPcWtTJM7yT/0GmKd9aSB8uKwlEKyS1cKPleQgMP3aKF+QmO
         8clATWzgmpwh8UlfmPMhTp42jUyrmvkuxTtu05CEfEJnK+WQUW+HHESiwPOOcmnt7QZ/
         OWizNb8hrGOWjopFvr5fje68NSgxCJAR9kX5Q8VLkO4W3HJWfxEjVksgzskzp3Jb/lbP
         aUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681528278; x=1684120278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvRefNBdCntu+pZy/U4eeOw/+P3jSNTuSKl+Y+gg558=;
        b=SUyH6D5IJMAwjZYZ2wQk4h7efiGcFS0jKYuT/oDh+pqcwlQA0p+1SMl52GVXh/+4QZ
         iiYbNQefhkO3k/OW7ru9xWA6kDPYb810V3WQMmxwvuzXOeIuqrAeohVVPsDFA4uAP6Pr
         fIwJPEP9SoQYD/Dqe1OIRg7RcGwVAOUzcBDxX4L6tdcT4xYII0zbU9Hg/nkX5y49+XwD
         XhFo0XL9wFu861X8XHlNsXRPXVpA9ubgLR+fP7BUsMe9/6ufBCT4uGeKWGNxadYmZ9wn
         iN5rS9OPPZXY+As90sOjfaY6l3L0UpXEmHYQpFzYhJCFuBPfRfuNnspFQyik+WRyc9Ua
         5GCw==
X-Gm-Message-State: AAQBX9fvSSiyPcxi7UBxT1uju4hdk41t0TrTG704kp4bdxSNevwaIKR1
        q+3XnMlMZYBRQR3IM4EOwxFd4w==
X-Google-Smtp-Source: AKy350aoUX99YiXsrWHE9U96HGSkzRYFTGlU9fSvZAsPt4wh+G9nV4c/x4EB7232wRvYCSx1HZcJ0w==
X-Received: by 2002:a17:902:f0d4:b0:19a:5a9d:3c with SMTP id v20-20020a170902f0d400b0019a5a9d003cmr73915pla.16.1681528277707;
        Fri, 14 Apr 2023 20:11:17 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i12-20020a63cd0c000000b00517be28bcf9sm3412025pgg.86.2023.04.14.20.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 20:11:16 -0700 (PDT)
Date:   Fri, 14 Apr 2023 20:11:12 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <20230415031112.gdb4vghgs3q42koa@google.com>
References: <20230408034759.2369068-1-reijiw@google.com>
 <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N>
 <20230412051410.emaip77vyak624pu@google.com>
 <ZDZ3xbSePtOD3CSX@FVFF77S0Q05N>
 <86v8i1l7ru.wl-maz@kernel.org>
 <CAAeT=FwUZ-TTn+4tt9pcesB59b7_=_zxkeRftMh5aQDUqnMz8g@mail.gmail.com>
 <86jzygkvmw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzygkvmw.wl-maz@kernel.org>
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

> > > > > Uh, right, interrupts are not masked during those windows...
> > > > >
> > > > > What I am currently considering on this would be disabling
> > > > > IRQs while manipulating the register, and introducing a new flag
> > > > > to indicate whether the PMUSERENR for the guest EL0 is loaded,
> > > > > and having kvm_set_pmuserenr() check the new flag.
> > > > >
> > > > > The code would be something like below (local_irq_save/local_irq_restore
> > > > > needs to be excluded for NVHE though).
> > >
> > > It shouldn't need to be excluded. It should be fairly harmless, unless
> > > I'm missing something really obvious?
> > 
> > The reason why I think local_irq_{save,restore} should be excluded
> > are because they use trace_hardirqs_{on,off} (Since IRQs are
> > masked here for NVHE, practically, they shouldn't be called with
> > the current KVM implementation though).
> 
> Gah. Indeed, we end-up with a lot of unwanted crap, and absolutely no
> way to locally override it.
> 
> > I'm looking at using "ifndef __KVM_NVHE_HYPERVISOR__" or other
> > ways to organize the code for this.
> 
> I'd vote for something like the code below:

Thank you for the suggestion.
Considering that we may have similar cases in the future,
I will implement as you suggested in v3.

Thank you,
Reiji

> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 530347cdebe3..1796fadb26cc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,7 +10,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
>  # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
>  # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> -ccflags-y += -fno-stack-protector	\
> +ccflags-y += -fno-stack-protector	-DNO_TRACE_IRQFLAGS \
>  	     -DDISABLE_BRANCH_PROFILING	\
>  	     $(DISABLE_STACKLEAK_PLUGIN)
>  
> diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
> index 5ec0fa71399e..ab0ae58dd797 100644
> --- a/include/linux/irqflags.h
> +++ b/include/linux/irqflags.h
> @@ -198,9 +198,10 @@ extern void warn_bogus_irq_restore(void);
>  
>  /*
>   * The local_irq_*() APIs are equal to the raw_local_irq*()
> - * if !TRACE_IRQFLAGS.
> + * if !TRACE_IRQFLAGS or if NO_TRACE_IRQFLAGS is localy
> + * set.
>   */
> -#ifdef CONFIG_TRACE_IRQFLAGS
> +#if defined(CONFIG_TRACE_IRQFLAGS) && !defined(NO_TRACE_IRQFLAGS)
>  
>  #define local_irq_enable()				\
>  	do {						\
> 
> 
> > Since {__activate,__deactivate}_traps_common() are pretty lightweight
> > functions, I'm also considering disabling IRQs in their call sites
> > (i.e. activate_traps_vhe_load/deactivate_traps_vhe_put), instead of in
> > __{de}activate_traps_common() (Thanks for this suggestion, Oliver).
> 
> That would work too.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
