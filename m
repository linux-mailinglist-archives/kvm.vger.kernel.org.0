Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C90446666
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 16:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhKEPv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 11:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKEPv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 11:51:28 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2815C061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 08:48:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id p8so7383355pgh.11
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 08:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BQvAChtGkGopxkASFYsDwmXZHmFC6+xDduRNBAB5e/o=;
        b=thcOmkTShq9Bj+tVLe+cwd6h3zcbAFPcJkJmzQdKhBNgKCY0vYLnO4CWPof9vab67N
         aPiQmqFs9U1sTyPYwAtbOcpQ9uQrua8mQHuNm2X2pcMfp9zzSEjuyqMNxm9BRNcZpK10
         dTElB6AgVPcof8XDSgFPwjxa4XpeBuQVNbF2IH3OoyHYlOFMWnuN9x7Mre3fKmmVHSXy
         gOKVS3HJ+EyZe7nnuQT72uASNAUyZvP3OGgzuS8Nm9x+2XSfq+mYj8tA/evJa8mSmNnS
         +GvFivhfjdC5gr7ATBpR1XCdBRTNFOC92qcmnLfdSMi5s/NJiS1dDXekDmRiyqPAEgx7
         jT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQvAChtGkGopxkASFYsDwmXZHmFC6+xDduRNBAB5e/o=;
        b=pdtlcwGyBSLlElBnuDe07GjRfezjNFsdW1KVC2bzOHcZLSCILOYTGdnv47/7rMUIk7
         /riDh4BVETkIoeqPHY4jFDOgQhI+8c/c3dt/zsKRepvGu8/vsdvLESxCbWWLT3tc7kdi
         AaOoU/Sf1nLjrsMr+H+oVOK7Dm3RkUaTXvgQXPiQqPkrWFzF5zs/zb3nBU2Gprq/n1Nf
         0hXk/BszORnofFTRpoIf8NADylrA4so4hyQjgA73mui551ae9NBnaq7tFD6/duOSfEH/
         QstU7J2dGwROOtrSSNJFsfcnOWfNedAVJmL8YkMj8IKtLLlnMXmmH3EVSTDjHTir51BU
         +EWQ==
X-Gm-Message-State: AOAM532RNghS6AP00BL9LYrTpEE2MykYGLfXxKXvtq22RulcVNl5PiY6
        JY7aLNgEyO/7mUfe+GjRVaN6Zw==
X-Google-Smtp-Source: ABdhPJwXas/ahUMjBO+7ij7kGm7PUrKGVTLhKaKoZjF9MnmCtV5p81sAuZ0C1I0ZWjOOHbbl7b3Bug==
X-Received: by 2002:aa7:8883:0:b0:49f:9e4b:3047 with SMTP id z3-20020aa78883000000b0049f9e4b3047mr4187915pfe.48.1636127328031;
        Fri, 05 Nov 2021 08:48:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lw1sm10743182pjb.38.2021.11.05.08.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:48:47 -0700 (PDT)
Date:   Fri, 5 Nov 2021 15:48:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: Introduce definitions to support static
 calls for kvm_pmu_ops
Message-ID: <YYVSW4Jr75oJ6MhC@google.com>
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-3-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103070310.43380-3-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Like Xu wrote:
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 0db1887137d9..b6f08c719125 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -50,6 +50,13 @@
>  struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_pmu_ops);
>  
> +#define	KVM_X86_PMU_OP(func)	\
> +	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
> +				*(((struct kvm_pmu_ops *)0)->func))
> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP

More of a question for the existing code, what's the point of KVM_X86_OP_NULL?
AFAICT, it always resolves to KVM_X86_OP.  Unless there's some magic I'm missing,
I vote we remove KVM_X86_OP_NULL and then not introduce KVM_X86_PMU_OP_NULL.
And I'm pretty sure it's useless, e.g. get_cs_db_l_bits is defined with the NULL
variant, but it's never NULL and its calls aren't guarded with anything.  And if
KVM_X86_OP_NULL is intended to aid in documenting behavior, it's doing a pretty
miserable job of that :-)

> +#include <asm/kvm-x86-pmu-ops.h>
> +EXPORT_STATIC_CALL_GPL(kvm_x86_pmu_is_valid_msr);

I'll double down on my nVMX suggestion so that this export can be avoided.

>  static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>  {
>  	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index b2fe135d395a..e5550d4acf14 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -3,6 +3,8 @@
>  #define __KVM_X86_PMU_H
>  
>  #include <linux/nospec.h>
> +#include <linux/static_call_types.h>
> +#include <linux/static_call.h>
>  
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
>  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> @@ -45,6 +47,19 @@ struct kvm_pmu_ops {
>  	void (*cleanup)(struct kvm_vcpu *vcpu);
>  };
>  
> +#define	KVM_X86_PMU_OP(func)	\
> +	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
> +#include <asm/kvm-x86-pmu-ops.h>
> +
> +static inline void kvm_pmu_ops_static_call_update(void)
> +{
> +#define	KVM_X86_PMU_OP(func)	\
> +	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func)
> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
> +#include <asm/kvm-x86-pmu-ops.h>
> +}

As alluded to in patch 01, I'd prefer these go in kvm_ops_static_call_update()
to keep the static call magic somewhat contained.

> +
>  static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -- 
> 2.33.0
> 
