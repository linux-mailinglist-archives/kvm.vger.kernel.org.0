Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D414742A3BD
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 14:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhJLMCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 08:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232665AbhJLMCr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 08:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634040044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ArgBgcgWfB7RQoup0CVP5TK2CbpCWPXqRtbofxvJguQ=;
        b=YniB631t3fVHmAPeu5gl8f/6VgFMbEdf0bfdeV2OnzFyn49Pz2+Kr/V2pTdW8zP1ZMBvIX
        a4P724JWN2kwm9/GaYTLzLaBiGbM6al750Oud/77nSuJLH+HmN2SHbFmJw8zUcl9oslayf
        j6nrc+7llKCNuA+4YuwxxVaqYPBPf2M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-qSJKYk3sNZSb25GwyhXFrQ-1; Tue, 12 Oct 2021 08:00:43 -0400
X-MC-Unique: qSJKYk3sNZSb25GwyhXFrQ-1
Received: by mail-wr1-f70.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso15635881wrg.7
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 05:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ArgBgcgWfB7RQoup0CVP5TK2CbpCWPXqRtbofxvJguQ=;
        b=bd55W9TLCg8b+N+WiMAh9nRLYP4ZMHjy5oyRQjgcD96GEqbVcLNtOFiWg3RJ6n0a0c
         75iovbetDofE0eNWoRZrdxq6AdJwXX4s8j+3YipJTO7qB/uavf0guURtKJL14UffcDET
         uBKtcY189hyJ3XO4sK45riF5IJWkX//WisvB8vkOB44w5wWZp2Mj2JMG8nmjtGsYkq+0
         4DbcrmyM0gYpEs6qH8VTpvvTu4YyvYXzrYelJsVM0ELaFePse16dr/PUD7s2MfdlIgws
         prFrfS4RHLTkDjYNAv/fXyHOybL64gQ01gYuuGOYcA1f4LQC6IMmf54mkVJfgqDF0kze
         83Tg==
X-Gm-Message-State: AOAM531jvt3zAehyj8/a5tnNtWRUL43egsY856BHCjiovh7WmAdD18QY
        CKrnYwfe/c4EClq036IZghZLrpuxgw2o/Bou+dTQVs+wUinnG+sS2aV/WPDL29gbXYzovU8xow6
        bJ48KFRn0E+2n
X-Received: by 2002:adf:dc43:: with SMTP id m3mr30931542wrj.66.1634040042654;
        Tue, 12 Oct 2021 05:00:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy098exPSYXNknZRGqFiNvB6xq+K6t+GZwbU2j/QF+La5PGmZVBnf+CM7JtvpArPd++nJPDzg==
X-Received: by 2002:adf:dc43:: with SMTP id m3mr30931488wrj.66.1634040042184;
        Tue, 12 Oct 2021 05:00:42 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a63sm398292wmd.34.2021.10.12.05.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:00:41 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:00:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix reporting of endianess when the access
 originates at EL0
Message-ID: <20211012120040.4tfkzlm7uju2n3sa@gator>
References: <20211012112312.1247467-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012112312.1247467-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 12:23:12PM +0100, Marc Zyngier wrote:
> We currently check SCTLR_EL1.EE when computing the address of
> a faulting guest access. However, the fault could have occured at
> EL0, in which case the right bit to check would be SCTLR_EL1.E0E.
> 
> This is pretty unlikely to cause any issue in practice: You'd have
> to have a guest with a LE EL1 and a BE EL0 (or the other way around),
> and have mapped a device into the EL0 page tables.

I wonder if that's something a usermode network driver might want?

> 
> Good luck with that!
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 1fadb5d98a36..14ee8319b1ce 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -396,7 +396,10 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
>  	if (vcpu_mode_is_32bit(vcpu))
>  		return !!(*vcpu_cpsr(vcpu) & PSR_AA32_E_BIT);
>  
> -	return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & (1 << 25));
> +	if (vcpu_mode_priv(vcpu))
> +		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_EE);
> +	else
> +		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_EL1_E0E);
>  }
>  
>  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

