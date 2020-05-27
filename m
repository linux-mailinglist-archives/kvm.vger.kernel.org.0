Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3A71E3E8F
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgE0KHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:07:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725294AbgE0KHH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 06:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590574026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XxzCdpe6pn5gC4pyxBkCeZjhm3W+/QqJpz6pNOd91FM=;
        b=DI97Rr466ITJBOP9k9fKOuurDfG5mrn1/JEgkMF5E0W/Ke47s0pulHf4GzECMLohTT4Biu
        McVZdc4Stmpty5QQyzkQYSGgMg/jSISyHuCEcp3XtvcgRLq2ypwyibbL070bEbx82Cc7yt
        wzqXWvL4HY2AlbzCrUbsQIKYlQmSeGU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-nBFd8WU2M9Kf-NRqL3ftDA-1; Wed, 27 May 2020 06:07:04 -0400
X-MC-Unique: nBFd8WU2M9Kf-NRqL3ftDA-1
Received: by mail-ej1-f72.google.com with SMTP id h6so8631378ejb.17
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 03:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XxzCdpe6pn5gC4pyxBkCeZjhm3W+/QqJpz6pNOd91FM=;
        b=WxUHtII/uqcl5wGDKayrZYvYJhE7vy+A7M/oZb4rFEeSctyk1cw6tNr4W05nd721KR
         eQmb/dVbDON0zh/2548hrkWBdqSBLFRQKpT9xiwnfRu8nGZnlQ+2Wz01z4SRrsA/vWeo
         D/KY+CmcQ9l+l4ardCQTCPXJqZE9Nxz/fXhIB5g8q3UEVJUcRa9+CvUiQWtHOcnyc19K
         2RPuSzWLHpea2WhRfZGkU8wqwvYlECllX4fAid4GhosUtg0GGfqT4SFBnL6R+MS7ItUk
         1+7/UKg5xLRMjvRvahvWH39Ww1Z3uRTdbEChDoUMay7II4wkCr/lAvAnLRQKRIWS/MCo
         gFDg==
X-Gm-Message-State: AOAM530juaQNTL2vhnhMNtFp/HdpSGqgh8bXPNEfScIAYvx5RkGYVhLu
        dsWsw9y0yZvtLfDI0cQKdrQR57SfXzZW5jEw6AIR9EcoLUj1KPmNjjnt8NaDOAt0G8WS//hrHkS
        LFbUaeRvr+1cn
X-Received: by 2002:a17:906:278e:: with SMTP id j14mr5125287ejc.270.1590574023109;
        Wed, 27 May 2020 03:07:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwagjGJIW4hm5iAPguqRbQjGvtaTGt7NuXFde9thBIO8Xens6mtXRCLxBhn2D0X8jpEhyIhKg==
X-Received: by 2002:a17:906:278e:: with SMTP id j14mr5125267ejc.270.1590574022888;
        Wed, 27 May 2020 03:07:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id wr19sm2345602ejb.67.2020.05.27.03.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:07:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated
In-Reply-To: <20200527084909.23492-1-sean.j.christopherson@intel.com>
References: <20200527084909.23492-1-sean.j.christopherson@intel.com>
Date:   Wed, 27 May 2020 12:07:01 +0200
Message-ID: <87367l669m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Set the mmio_value to '0' instead of simply clearing the present bit to
> squash a benign warning in kvm_mmu_set_mmio_spte_mask() that complains
> about the mmio_value overlapping the lower GFN mask on systems with 52
> bits of PA space.
>
> Opportunistically clean up the code and comments.
>
> Fixes: 608831174100 ("KVM: x86: only do L1TF workaround on affected processors")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
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

Nice cleanup,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

