Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39444C355
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 15:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhKJOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 09:51:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhKJOvh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 09:51:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636555728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onLRqby/eIAq81jKitDiy/r/F+xHidt2JfJxJtklnSk=;
        b=QinoGde5wh2OLsyEnbf3PJZgEG5+GO77d7urQ9gq4Sq3ENZtHab3bCmc1OxpsWzlL7/oUM
        0Za7lTil1NA0/XQ5TpSN55xxtuNdRnrczal3ptKLFRJI3qWL70JfpQU4ikgkcGJY2HClJ5
        /5pHZ8eQu4RrUbfQaTl7j3s/L09tFYI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-B42XrR1-O4SrhWRkfTl3WA-1; Wed, 10 Nov 2021 09:48:47 -0500
X-MC-Unique: B42XrR1-O4SrhWRkfTl3WA-1
Received: by mail-ed1-f72.google.com with SMTP id w13-20020a05640234cd00b003e2fde5ff8aso2507213edc.14
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 06:48:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=onLRqby/eIAq81jKitDiy/r/F+xHidt2JfJxJtklnSk=;
        b=aGFMiZV1pk7B3nGdLDFWvrjydHvvF34k8Hal5n3wWO1bywpht5A+qtLLRlvWyPYVcm
         uHguMe47cvq8mBkrHbTo7JvSS0wyGqiQcXYnDQEMHdQq7lN8viIXzgx/LGBx+n2Zqj7D
         H+32sJ3UM4uPxH+kEyk/wZ5nC285JX7GLjNgRiHd4+5U8WR/uqwUvALVNxpc1PeRL1GF
         KAyAxVopMbeqZ8MchS6tzuvqQat4av87nSqYt7BoO11dQK5r8KTncN2SEw2bRfOpj5oF
         oFmIqm5nRFquucjplUsTDyMu75LSZFGnkADSTVDfpjyKUOk/RI1uPvSsEL0mwcce5UZu
         8SOQ==
X-Gm-Message-State: AOAM530pEkKluTC8i7+b75cSRlkVx1y751VNAE5VxPQR84mm0oE8QFCw
        Di8xAR6X70lP/waZD+pKcfjXAOP9hhuqRZuZFv+52Hj9bK7jd7u8zsMPnyYRIhmkeSWIWGBR4/J
        m3SlHX60zHh5N
X-Received: by 2002:aa7:c693:: with SMTP id n19mr131548edq.101.1636555725061;
        Wed, 10 Nov 2021 06:48:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycgjlrgpdudJbIXw52pMUGEBH8ONRvqGHDlcIB26TAbCbcDxYXjODus0tdOlyWBNvNweOtJg==
X-Received: by 2002:aa7:c693:: with SMTP id n19mr131150edq.101.1636555721957;
        Wed, 10 Nov 2021 06:48:41 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m11sm9463538edd.58.2021.11.10.06.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:48:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: don't skip mmu initialization when
 mmu root level changes
In-Reply-To: <20211110100018.367426-4-mlevitsk@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
 <20211110100018.367426-4-mlevitsk@redhat.com>
Date:   Wed, 10 Nov 2021 15:48:40 +0100
Message-ID: <87r1bom5h3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> When running mix of 32 and 64 bit guests, it is possible to have mmu
> reset with same mmu role but different root level (32 bit vs 64 bit paging)
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4d..763867475860f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4745,7 +4745,10 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	union kvm_mmu_role new_role =
>  		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
>  
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> +	u8 new_root_level = role_regs_to_root_level(&regs);
> +
> +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> +	    context->root_level == new_root_level)
>  		return;

role_regs_to_root_level() uses 3 things: CR0.PG, EFER.LMA and CR4.PAE
and two of these three are already encoded into extended mmu role
(kvm_calc_mmu_role_ext()). Could we achieve the same result by adding
EFER.LMA there?

>  
>  	context->mmu_role.as_u64 = new_role.as_u64;
> @@ -4757,7 +4760,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->root_level = role_regs_to_root_level(&regs);
> +	context->root_level = new_root_level;
>  
>  	if (!is_cr0_pg(context))
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> @@ -4806,7 +4809,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  				    struct kvm_mmu_role_regs *regs,
>  				    union kvm_mmu_role new_role)
>  {
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> +	u8 new_root_level = role_regs_to_root_level(regs);
> +
> +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> +	    context->root_level == new_root_level)
>  		return;
>  
>  	context->mmu_role.as_u64 = new_role.as_u64;
> @@ -4817,8 +4823,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  		paging64_init_context(context);
>  	else
>  		paging32_init_context(context);
> -	context->root_level = role_regs_to_root_level(regs);
>  
> +	context->root_level = new_root_level;
>  	reset_guest_paging_metadata(vcpu, context);
>  	context->shadow_root_level = new_role.base.level;

-- 
Vitaly

