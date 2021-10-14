Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162F642DF0B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhJNQWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 12:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231608AbhJNQWv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 12:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634228445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f/x0GMWtXzbHVSq1sXMLR+bmmD/sS6+vnmT+tCy96wk=;
        b=Xe7lzAJj6gxj2OtO71TRwGWs8iTIpCS4RNr3k4RW/VVWHCKirTvdV7OHA8s9feea/AfRt0
        pXP4hW7v1w/CKDXL8sWI2cu3qV3ZN8VKmXgHuG+tYzsJ590OzGVkUtWKTNJ9u6RTdastB4
        /DHEiQQJzbottWOCC1X7iKkH1FJv4rM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-8n_CWVRiNhSpxaUTLy0ytg-1; Thu, 14 Oct 2021 12:20:44 -0400
X-MC-Unique: 8n_CWVRiNhSpxaUTLy0ytg-1
Received: by mail-qt1-f197.google.com with SMTP id 13-20020ac8560d000000b0029f69548889so4878516qtr.3
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 09:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f/x0GMWtXzbHVSq1sXMLR+bmmD/sS6+vnmT+tCy96wk=;
        b=vsLb5JgAmmJU7sdQmf477IPlYs1rKE83ZI0VYgTkF7blxYgYLtCBdP3RsESkk1rgc6
         SMYFIt/T6OF111Tx0mV/ijv/f4MlNLwZURammdY+XeFpVoC1PLcdJB9HyezNkhqRjd0e
         Ehn+m/M/Zq0CdCs5bjVxa3cd3qsbeLiqyydtnZGIBAn0ZIWYiYbbdkPG9w8eXLd1yeqC
         ZFlRN/TWiJW+PW91U2sNoiDmzTm9KYr6yLXi1LbDxwAQ8VJCvLwwxW9/mWtAYwe0KrdB
         Cmr69JUUQ/FpkW2WEDH/GbgAbv77FzULibTjGwtNsWr6M8x7HgcmNfGoHke/GvoDN9Y8
         b/5A==
X-Gm-Message-State: AOAM532USBszHpT0xWwW9SDvpKLttJLCOocuccM9ChJEdbp3WBT4kYet
        xh7KA+nRASTeIyVHu2oE5/u/d3VlieHXGMgsoCUwNIM+vs53k/JJkg2cxqEPEuhArpj+ssq3NcG
        AoOX1+SA9RTxv
X-Received: by 2002:ac8:10a:: with SMTP id e10mr7607142qtg.406.1634228444123;
        Thu, 14 Oct 2021 09:20:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP6s5Caxb2ESan17RuUDUYd/oN90Ga/T3lVfd6666txoozRp5nG/hxM/ybPlKlcMqK0iKAQQ==
X-Received: by 2002:ac8:10a:: with SMTP id e10mr7607116qtg.406.1634228443916;
        Thu, 14 Oct 2021 09:20:43 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f15sm1578546qtm.37.2021.10.14.09.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 09:20:43 -0700 (PDT)
Date:   Thu, 14 Oct 2021 18:20:38 +0200
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
Message-ID: <20211014162038.cxdoedqlbsxtzw5l@gator>
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
> +	RAZ_WI(SYS_ERRSELR_EL1),
> +	RAZ_WI(SYS_ERXFR_EL1),
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

Reviewed-by: Andrew Jones <drjones@redhat.com>

