Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6642D619
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhJNJeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:34:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229513AbhJNJea (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 05:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634203945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wi15Ur3KlO1RcGZUz0YgACO/6MX5vtNsrghcoTR65A4=;
        b=KvTz96lhNN/WS4fql04IMwdESI97/H5/nRiISrgp3plyd0+XgoQ18N4y1DEobcN+jKJ7P6
        lU31q7nn9Dn7kkwIPAFFpSRu3TPVlobcXxvJfqvJDMrrKiTTml2J93KQrkhryKWC7akXhO
        F9nT9VqTN0FlTKhh0hpSMY+3oVhdX2g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-7fL0ms6kMwCOJoEdDskRQA-1; Thu, 14 Oct 2021 05:32:24 -0400
X-MC-Unique: 7fL0ms6kMwCOJoEdDskRQA-1
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a50f185000000b003db0f796903so4646362edl.18
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wi15Ur3KlO1RcGZUz0YgACO/6MX5vtNsrghcoTR65A4=;
        b=V7me3g60RZB4kqWDh32RDmYbObNokc1t92QaVzTDgYs5M0nrcZHtcHGBUG/cIYrJta
         upnzioPFwY+0Qn2yOxqXZLmNnpgtOGmwcuDIxtyEqv6jAW3Ta791inaXo6OhMYvBRV4R
         C3+T3z1T1IDIYTfSvcYnyJOZjRKpDsdmFqaw6aVTrhaeyHU3IaWiFYScA3PYH27NBdG0
         +NW74BCyGg4EuVrPDF0wNN/Rsqmia2tPzQeCS3CzcIapmEsDwxlkhfYstXUUoA/fUyop
         Rn41IY9/FeEl18dnz2353HldknOdXv2ZPlPIgQqHOsjaJs4Y/M7jEQFJWJNk6wbFCt/D
         IuWg==
X-Gm-Message-State: AOAM5310QNfiCOzWqlneS+anTQtwwxl8DNzbLo/WTi7ib0g/Jmi8ZD+s
        7X5qadFHKThOL0Dlr5MzOXfc/YFDVRpvzZjrq8n7pdQJiCqmDCLSz6m5uw6a+9dvNLZVeJxs2Br
        a4pg5ruokoK2l
X-Received: by 2002:a17:906:bb0c:: with SMTP id jz12mr2415834ejb.455.1634203942966;
        Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtVNEOaUZN/thRjJPIlW9SJat0i5pMBR7vZyAEyhc6jryGDj27ElPWGuFo/lT48kERbeIA6A==
X-Received: by 2002:a17:906:bb0c:: with SMTP id jz12mr2415804ejb.455.1634203942750;
        Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id r16sm1484675ejj.89.2021.10.14.02.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
Date:   Thu, 14 Oct 2021 11:32:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com,
        tabba@google.com
Subject: Re: [PATCH v9 14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1
 registers RAZ/WI
Message-ID: <20211014093220.ylnqb3ohuh5qayps@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013120346.2926621-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 01:03:38PM +0100, Marc Zyngier wrote:
> The ERR*/ERX* registers should be handled as RAZ/WI, and there
> should be no need to involve EL1 for that.
> 
> Add a helper that handles such registers, and repaint the sysreg
> table to declare these registers as RAZ/WI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 33 ++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index f125d6a52880..042a1c0be7e0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -248,6 +248,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
>  }
>  
> +/* Handler to RAZ/WI sysregs */
> +static bool pvm_access_raz_wi(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	if (!p->is_write)
> +		p->regval = 0;
> +
> +	return true;
> +}
> +
>  /*
>   * Accessor for AArch32 feature id registers.
>   *
> @@ -270,9 +280,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
>  	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
>  		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_ELx_64BIT_ONLY);
>  
> -	/* Use 0 for architecturally "unknown" values. */
> -	p->regval = 0;
> -	return true;
> +	return pvm_access_raz_wi(vcpu, p, r);
>  }
>  
>  /*
> @@ -301,6 +309,9 @@ static bool pvm_access_id_aarch64(struct kvm_vcpu *vcpu,
>  /* Mark the specified system register as an AArch64 feature id register. */
>  #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
>  
> +/* Mark the specified system register as Read-As-Zero/Write-Ignored */
> +#define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
> +
>  /* Mark the specified system register as not being handled in hyp. */
>  #define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
>  
> @@ -388,14 +399,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  	HOST_HANDLED(SYS_AFSR1_EL1),
>  	HOST_HANDLED(SYS_ESR_EL1),
>  
> -	HOST_HANDLED(SYS_ERRIDR_EL1),
> -	HOST_HANDLED(SYS_ERRSELR_EL1),
> -	HOST_HANDLED(SYS_ERXFR_EL1),
> -	HOST_HANDLED(SYS_ERXCTLR_EL1),
> -	HOST_HANDLED(SYS_ERXSTATUS_EL1),
> -	HOST_HANDLED(SYS_ERXADDR_EL1),
> -	HOST_HANDLED(SYS_ERXMISC0_EL1),
> -	HOST_HANDLED(SYS_ERXMISC1_EL1),
> +	RAZ_WI(SYS_ERRIDR_EL1),

This is a read-only register. Is write-ignore correct? I'd expect we to
inject an exception.

> +	RAZ_WI(SYS_ERRSELR_EL1),
> +	RAZ_WI(SYS_ERXFR_EL1),

Another read-only reg.

> +	RAZ_WI(SYS_ERXCTLR_EL1),
> +	RAZ_WI(SYS_ERXSTATUS_EL1),
> +	RAZ_WI(SYS_ERXADDR_EL1),
> +	RAZ_WI(SYS_ERXMISC0_EL1),
> +	RAZ_WI(SYS_ERXMISC1_EL1),
>  
>  	HOST_HANDLED(SYS_TFSR_EL1),
>  	HOST_HANDLED(SYS_TFSRE0_EL1),
> -- 
> 2.30.2
>

Thanks,
drew 

