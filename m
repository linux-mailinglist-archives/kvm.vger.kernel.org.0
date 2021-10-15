Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA742EE89
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbhJOKPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 06:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237713AbhJOKPK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 06:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634292784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2wKSd8eRy2pD7AkaeNeFHMLzezM6aIro+x06mkpfA4=;
        b=BOESvxw3z4vaxIT8l6YKqg3vHGVbfkcWdl1YwQqE+Efhy1q1AcoiK51CqoV6t8R/ZR4plE
        P58AiFSDDcepbcKfH0ouAVZwIgyVxxbrPwYCaFglNQ725JHsQ9XbEv4QYkHTolq68PZ3zz
        q4FfaUkZAvbJCarA++BmKTMbPKAFTw8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-H5JBnbWMMkaxyRzswrUZHA-1; Fri, 15 Oct 2021 06:13:03 -0400
X-MC-Unique: H5JBnbWMMkaxyRzswrUZHA-1
Received: by mail-wr1-f70.google.com with SMTP id l6-20020adfa386000000b00160c4c1866eso5772196wrb.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 03:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2wKSd8eRy2pD7AkaeNeFHMLzezM6aIro+x06mkpfA4=;
        b=60RFzOS3dN6nNWMPKq+ly8CoJXF2U8BHv6w4OyZS/YKaPDzvbtygrLovNMwRGUppep
         kDSteNxSUFNSJmMm0CouDIMrDZWDxd/5pp27InnQsHkMq4gv9b6HR76zYJYdLgee8J3r
         aHm2wJPH7m+rEgTWiKyqFDy5E4K8puUpxqbB/XTiGvlP7GjuXc+UTZmnruEbh92eofkF
         s/rfF3WS0Llofk2xmtzJWhrMGzlsqWtus0eqlQqIlzIJC9GlCvtD/hzu0tmYQGRha++f
         DqXh+yI4OzunP46gGYDnYPq5aDC52bhg8XhuniZX8AB2geIfkU0/3fuxy2pIYDv6TEnp
         IXpA==
X-Gm-Message-State: AOAM532uf7kSuWWTmwSt0hWVUzY7Al0Or9FY1f1gOy5ldh7rotRkSaTR
        sTnKvtDQDyRuae0aIgZsIbB1oT+RY0TzpZmhJCe+dTnXfc342qXOeab+4FQnE+Msr9SyK4/Wber
        a/IpEUFcRxztU
X-Received: by 2002:a1c:208:: with SMTP id 8mr25341124wmc.114.1634292781985;
        Fri, 15 Oct 2021 03:13:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySQyml7m4lUYWHcFoNKT7dSS0DKGc0cSC3P/sTwgEM1cRhAW6jGm/Uuh+3uSwKU+ZfUSK9FQ==
X-Received: by 2002:a1c:208:: with SMTP id 8mr25341109wmc.114.1634292781779;
        Fri, 15 Oct 2021 03:13:01 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id g1sm11222799wmk.2.2021.10.15.03.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 03:13:01 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:12:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH 01/25] KVM: arm64: Add has_reset_once flag for vcpu
Message-ID: <20211015101259.4lmlgk5ll2mrnohd@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012043535.500493-2-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 09:35:11PM -0700, Reiji Watanabe wrote:
> Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> if the vCPU reset has been done once, for later use.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/reset.c            | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..9b5e7a3b6011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +	bool has_reset_once;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)						\
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5ce36b0a3343..4d34e5c1586c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_load(vcpu, smp_processor_id());
>  	preempt_enable();
> +
> +	if (!ret && !vcpu->arch.has_reset_once)
> +		vcpu->arch.has_reset_once = true;
> +
>  	return ret;
>  }
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Hi Reiji,

Can't we use kvm_vcpu_initialized(vcpu)? vcpu->arch.target should
only be >= when we've successfully reset the vcpu at least once.

Thanks,
drew

