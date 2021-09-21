Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0310641357B
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhIUOjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 10:39:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233744AbhIUOjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 10:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632235066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k0O7QoPLWspZx6BtAPcQquZycVQ3JnmWHZekZJRvmzk=;
        b=ArdAyv7388KOVnawfyyy2JotMdVBS8v5T+4IlGedbricg3viFo7MESwYEZikZ6ncIgL+zx
        lXMiYZcRrIg3FkGw7Rw2CPatvsGrMMq0/dakJTll0IERXyHu4/NxIJdbAjSbBs9vSVK9SM
        0RU6y8NvMAcCXwzkKWC+rrRdpu07spw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-5l7E38qLOQiUoAxqE61L5w-1; Tue, 21 Sep 2021 10:37:44 -0400
X-MC-Unique: 5l7E38qLOQiUoAxqE61L5w-1
Received: by mail-wr1-f70.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso3943326wrg.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 07:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k0O7QoPLWspZx6BtAPcQquZycVQ3JnmWHZekZJRvmzk=;
        b=i2/llbMdVCBiU65ZlqSpKzJP8PuKfVMSUNkC2F71b0T5m2KNC9n9qtIeuVgUN8N/PB
         mpoyJz9+SIWsBF4ZjleQADMpWKt8EF5Bv9hg/rbEzgM/aax9NwkkNnamHNp5/QfGCTn7
         WbXZofcECw2NI7IQ+WbiMK/0F5OtuWRw1toIZT49bYZE4sQRyMQaN+sIq7F/lpTmg/60
         a7B5pxcd5ZgqOcqICtDtjdpMNBrQlfl5phKuX3MhoTHP8QcF+gjzhsQgZ5zMiVuSzvsA
         M/FVb7ovf4t4io+J/Adjsrr8tccTEfCvLX04k1hYakgKouv5Qtlr2mYxvKbBOivg5S7t
         v4tw==
X-Gm-Message-State: AOAM531R8QSb+5U19FkQgBTSf03R2iG8FQwTrd17VfR7TOJN3lrPftrg
        AQgmF6Mn2JCGsVIeXN1CVIad7zyt71U5suY//RRocHMG2jo8bRQU6kVib9BXWSrOS3qG9bktw+Y
        JIH6OIH5QXHfE
X-Received: by 2002:a1c:2056:: with SMTP id g83mr4966840wmg.27.1632235063675;
        Tue, 21 Sep 2021 07:37:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOhtVDx1wjCMqGuF0SrwkNbv1M0n5PyDTKOHEe0ouzPcLmgHlypcvqzU6rba7ynbULjyMCpQ==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr4966811wmg.27.1632235063447;
        Tue, 21 Sep 2021 07:37:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c17sm23850602wrn.54.2021.09.21.07.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:37:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 05/10] KVM: x86: Remove defunct setting of XCR0 for
 guest during vCPU create
In-Reply-To: <20210921000303.400537-6-seanjc@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-6-seanjc@google.com>
Date:   Tue, 21 Sep 2021 16:37:41 +0200
Message-ID: <87wnna805m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Drop code to initialize XCR0 during fx_init(), a.k.a. vCPU creation, as
> XCR0 has been initialized during kvm_vcpu_reset() (for RESET) since
> commit a554d207dc46 ("KVM: X86: Processor States following Reset or INIT").
>
> Back when XCR0 support was added by commit 2acf923e38fb ("KVM: VMX:
> Enable XSAVE/XRSTOR for guest"), KVM didn't differentiate between RESET
> and INIT.  Ignoring the fact that calling fx_init() for INIT is obviously
> wrong, e.g. FPU state after INIT is not the same as after RESET, setting
> XCR0 in fx_init() was correct.
>
> Eventually fx_init() got moved to kvm_arch_vcpu_init(), a.k.a. vCPU
> creation (ignore the terrible name) by commit 0ee6a5172573 ("x86/fpu,
> kvm: Simplify fx_init()").  Finally, commit 95a0d01eef7a ("KVM: x86: Move
> all vcpu init code into kvm_arch_vcpu_create()") killed off
> kvm_arch_vcpu_init(),

Technically, empty kvm_arch_vcpu_init() was still alive for a few more
commits and only ddd259c9aaba ("KVM: Drop kvm_arch_vcpu_init() and
kvm_arch_vcpu_uninit()") killed it for real but a curious reader can
find all these gory details himself)

> leaving behind the oddity of redundant setting of
> guest state during vCPU creation.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0bff5473813..6fd3fe21863e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -993,7 +993,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  	/*
>  	 * Do not allow the guest to set bits that we do not support
>  	 * saving.  However, xcr0 bit 0 is always set, even if the
> -	 * emulated CPU does not support XSAVE (see fx_init).
> +	 * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
>  	 */
>  	valid_bits = vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
>  	if (xcr0 & ~valid_bits)
> @@ -10623,11 +10623,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
>  			host_xcr0 | XSTATE_COMPACTION_ENABLED;
> -
> -	/*
> -	 * Ensure guest xcr0 is valid for loading
> -	 */
> -	vcpu->arch.xcr0 = XFEATURE_MASK_FP;
>  }
>  
>  void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

