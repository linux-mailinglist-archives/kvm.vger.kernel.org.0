Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4AF170240
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBZPXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:23:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727023AbgBZPXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 10:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582730609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4ucQrDY+iQOfed8DTaG5mdXUDW/n4hSrzqLX+ul7io=;
        b=VM3JQw9g0HHGYzQHYxlPcwTeJ8chcbLpFh4WCzg6Lj55jx6eoUo3BGnm0fqtrRCP5YVDzG
        zFBCjW/cEj9ai+XwJhgZENR3Ajk7U2qz25laDab7kYRsk/10UYAAeHV4VBe8lwQvcm6kNn
        izTayd4DFYH+/f4UcYrgOrjBA5jsWag=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-c01fnvj2NMSczCzuMMUhGA-1; Wed, 26 Feb 2020 10:23:27 -0500
X-MC-Unique: c01fnvj2NMSczCzuMMUhGA-1
Received: by mail-wm1-f72.google.com with SMTP id p2so769295wmi.8
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 07:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k4ucQrDY+iQOfed8DTaG5mdXUDW/n4hSrzqLX+ul7io=;
        b=qzsfIzvsKHVh5mZKVvbbETNR2jhmpF2HKfyQxKJw0V/LMqgz6P0NRjDWGtngDjCijG
         iC9pvuXwaDzYoXtPOnxyxOJYrSH3oMciNQKZKqfcPGxG20nC6UmYSfqICc4RB07W3G5v
         DGJjsXgaW+Ry5d81pN5UQ8H8aqQdsD9TjZ3rH3+W3zNK9asuLbB4MA7n+nZFrvtfQt+S
         X2Sis0tBcANsVgtxOMSuNM51geh3GuDZj1tUBWNaAhBOZ96arIeRfF4lWyGEVz1U00im
         qKWmZpmiS+3PJl+86+NzDs90yj03/0pytKBsd2yWMbqXwKJYn1ItdcTNXSK5dUQwOkWA
         01Yg==
X-Gm-Message-State: APjAAAV21U+emOtNllhq6ci44ICsMz4Ko4cxY3U5mHWCnA65EuCN0jG6
        rTCoSgCCid9hf84O0RLoq4nWwIb/dW3tIVJ2S0QtaSZ71JqMHIc7Bbw2kTLsaw7+kd2z2O7kaWx
        9Sv+i0Msb/uRZ
X-Received: by 2002:adf:a285:: with SMTP id s5mr6439609wra.118.1582730605676;
        Wed, 26 Feb 2020 07:23:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqyy/7n4R6zrNnUx6owfpYEWU1qQMIdGRDXzWekMmbc65pA/gD75QqCNxkxzeVMLZ081R7pK+A==
X-Received: by 2002:adf:a285:: with SMTP id s5mr6439577wra.118.1582730605395;
        Wed, 26 Feb 2020 07:23:25 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm3560478wrq.21.2020.02.26.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:23:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/13] KVM: x86: Move emulation-only helpers to emulate.c
In-Reply-To: <20200218232953.5724-4-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-4-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 16:23:23 +0100
Message-ID: <87blpljrtg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move ctxt_virt_addr_bits() and emul_is_noncanonical_address() from x86.h
> to emulate.c.  This eliminates all references to struct x86_emulate_ctxt
> from x86.h, and sets the stage for a future patch to stop including
> kvm_emulate.h in asm/kvm_host.h.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/emulate.c | 11 +++++++++++
>  arch/x86/kvm/x86.h     | 11 -----------
>  2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index ddbc61984227..1e394cb190ce 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -673,6 +673,17 @@ static void set_segment_selector(struct x86_emulate_ctxt *ctxt, u16 selector,
>  	ctxt->ops->set_segment(ctxt, selector, &desc, base3, seg);
>  }
>  
> +static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
> +{
> +	return (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_LA57) ? 57 : 48;
> +}
> +
> +static inline bool emul_is_noncanonical_address(u64 la,
> +						struct x86_emulate_ctxt *ctxt)
> +{
> +	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
> +}
> +
>  /*
>   * x86 defines three classes of vector instructions: explicitly
>   * aligned, explicitly unaligned, and the rest, which change behaviour
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3624665acee4..8409842a25d9 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -149,11 +149,6 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
>  }
>  
> -static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
> -{
> -	return (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_LA57) ? 57 : 48;
> -}
> -
>  static inline u64 get_canonical(u64 la, u8 vaddr_bits)
>  {
>  	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> @@ -164,12 +159,6 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>  	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
>  }
>  
> -static inline bool emul_is_noncanonical_address(u64 la,
> -						struct x86_emulate_ctxt *ctxt)
> -{
> -	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
> -}
> -
>  static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>  					gva_t gva, gfn_t gfn, unsigned access)
>  {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

