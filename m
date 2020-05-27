Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7471E4186
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgE0MIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 08:08:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728483AbgE0MH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 08:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590581247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAOHEe2wXSlGLrnZFjFSmf34no8sDZWkhmsgq7pa2Tg=;
        b=J4eQtvbB3Xhn7/xzdQaxIOYIgtJxbkcX+I9w9bZ88xz36u2mbPyHYb+hjs1+BqxL1mpynq
        G6JeYI6JgyF6pNtNSn5tNFakgfl9/i05XvKD1+8K1uUWHjFOZxMO30qu4jTpQK9CssYwpb
        xQ26bfMy0j4vwJ5/1KYgS94e2sCvtgw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-fCSY9s4PP7-aHbiNL5-8Mg-1; Wed, 27 May 2020 08:07:25 -0400
X-MC-Unique: fCSY9s4PP7-aHbiNL5-8Mg-1
Received: by mail-ej1-f71.google.com with SMTP id nw19so8827757ejb.10
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 05:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JAOHEe2wXSlGLrnZFjFSmf34no8sDZWkhmsgq7pa2Tg=;
        b=nPeQldwZ0ju3M92B8MST1GPcHXLwQTQPlP9kF2WSpwm/zMGrLf/MiEHYhQyYZyxYjd
         nvEdD5iOoqCJIJ3uOfuhkBRlOiupyNJ81wg8NDx7OYbn+/FPwVdTjSGDeiyALAE8RNsl
         QLVxm3Pax3mb6yna6Naau0TSNR8XuIYcNQtedNXBQ4rc3DYKjxMQmtdhn3nhxh4vHmBE
         lNUK3E7Ei0g/QSbsjEP2k77w3qn8PEcBXltiFetyz3h2A1/BR2WpeOfAInzKSB509j1p
         M+2RBgqCVTYRT02aKCV4I3COa2cOr6nuLu9nWW+6mRf/jHO4j1qrI074hCC0xC2jQ7TS
         1/vw==
X-Gm-Message-State: AOAM531cQHHu3YcgA4vUHCR0HUuhixsqbt0+NAvqREKCjdGyswKRNQL7
        Pgl9ERkNZORZV8e8J4ZEIbvmkOiYVdGgpvpiWJ2vcGaa7AO1wWOKg2gbNdEycnf1KsP7CqkE+ea
        oA594SmqWx4hU
X-Received: by 2002:aa7:c6d1:: with SMTP id b17mr6119039eds.39.1590581244296;
        Wed, 27 May 2020 05:07:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPap1r2d6pve9ph5mq6UFpBkvveZ3/UVhwnGQUVfRWhjg9EfMvArNZv5Ea+DHovL+LUMT1dw==
X-Received: by 2002:aa7:c6d1:: with SMTP id b17mr6119007eds.39.1590581243987;
        Wed, 27 May 2020 05:07:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id gl19sm2526817ejb.34.2020.05.27.05.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 05:07:23 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't
 be generated
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200527084909.23492-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f88b71bb-74aa-9ff1-7aab-918d9f0a4a82@redhat.com>
Date:   Wed, 27 May 2020 14:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527084909.23492-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 10:49, Sean Christopherson wrote:
> Set the mmio_value to '0' instead of simply clearing the present bit to
> squash a benign warning in kvm_mmu_set_mmio_spte_mask() that complains
> about the mmio_value overlapping the lower GFN mask on systems with 52
> bits of PA space.
> 
> Opportunistically clean up the code and comments.
> 
> Fixes: 608831174100 ("KVM: x86: only do L1TF workaround on affected processors")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Queued, thanks (with Cc: to stable).

Paolo

> Thanks for the excuse to clean up kvm_set_mmio_spte_mask(), been wanting a
> reason to fix that mess for a few months now :-).
> 
>  arch/x86/kvm/mmu/mmu.c | 27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2df0f347655a4..aab90f4079ea9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6136,25 +6136,16 @@ static void kvm_set_mmio_spte_mask(void)
>  	u64 mask;
>  
>  	/*
> -	 * Set the reserved bits and the present bit of an paging-structure
> -	 * entry to generate page fault with PFER.RSV = 1.
> +	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
> +	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
> +	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
> +	 * 52-bit physical addresses then there are no reserved PA bits in the
> +	 * PTEs and so the reserved PA approach must be disabled.
>  	 */
> -
> -	/*
> -	 * Mask the uppermost physical address bit, which would be reserved as
> -	 * long as the supported physical address width is less than 52.
> -	 */
> -	mask = 1ull << 51;
> -
> -	/* Set the present bit. */
> -	mask |= 1ull;
> -
> -	/*
> -	 * If reserved bit is not supported, clear the present bit to disable
> -	 * mmio page fault.
> -	 */
> -	if (shadow_phys_bits == 52)
> -		mask &= ~1ull;
> +	if (shadow_phys_bits < 52)
> +		mask = BIT_ULL(51) | PT_PRESENT_MASK;
> +	else
> +		mask = 0;
>  
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
>  }



