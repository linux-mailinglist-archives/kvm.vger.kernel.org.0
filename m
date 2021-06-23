Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1C43B1F40
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWROU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:14:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229794AbhFWROT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 13:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624468321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0HXfW00/ZiOTGZh8Pkhz1aco0hFAG0H/heQF1wGLg5k=;
        b=QE91AAGXuqPdxGEQ3h8PqY/UT/vGDlb81P2ykNHVwt8Q+O9x1uweP26JG2SO3/lNeTWwHw
        x4Sn8xJi6x5+/AgVd5/1+WyLrjF/faCwm3SsLRh4CKYi5Cyr1sPoS/taW2Wz/IcXmET1W+
        aCGu8TfyqzXqlk4bEs/6TEVQ1G1ssOk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-WbbeFtRDPImTK-dwF7gU_Q-1; Wed, 23 Jun 2021 13:12:00 -0400
X-MC-Unique: WbbeFtRDPImTK-dwF7gU_Q-1
Received: by mail-ej1-f71.google.com with SMTP id o12-20020a17090611ccb02904876d1b5532so1230914eja.11
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HXfW00/ZiOTGZh8Pkhz1aco0hFAG0H/heQF1wGLg5k=;
        b=bAWRXT3U1unBGXlAeIoF0UcufesarKkyXbN1cHDUZgFmS4rZH4eI5fQ8bIv2j3SMCq
         PErLd1c3cNOWOie89XKsEzLVoz0maeZVifd//2JRga3GTlgtEfXdZd20hshwMZLXMko3
         5qDs1AYpSg9nb7c2abpzwPo2fvgx7LBs1By8EHI0upPbS0a7VgIMfnTYfTnmkpm6jLh+
         W0fgd5EfJtVm+CYomlKBvkZ+UVdh1XsYpeXGxPTXyMu5hRS2g4L2g67C6zImRtztt4q7
         xxk44ggHBsJoHUKp6J4MrPAEd+LaHRTVOFwUjisf+WQ4MABivGQ9L2sFAml9ur5QXutx
         2Hew==
X-Gm-Message-State: AOAM532dh972up2uJN+C9CnGEGzA1PrKoXzv/hDvSTXTBslTwPzdBfPP
        HqqtuljPj5rn/Fq0TKZCjEGN2zPyv6wYXUHwBaLVj5aUAS1VFvxx2IHcZLbfd1PDrSy4cT/Hunb
        bbDP/h4orlSwb
X-Received: by 2002:aa7:ca0d:: with SMTP id y13mr1104296eds.374.1624468318933;
        Wed, 23 Jun 2021 10:11:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypFonSlzdpXsAn0U+RI+a4pvkbMfOGEKHcpih/Yn3xWQ6W8Ge9ous+iUsy2aPcUgGRos3wwg==
X-Received: by 2002:aa7:ca0d:: with SMTP id y13mr1104263eds.374.1624468318739;
        Wed, 23 Jun 2021 10:11:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id by1sm158365ejc.30.2021.06.23.10.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 10:11:58 -0700 (PDT)
Subject: Re: [PATCH 16/54] KVM: x86/mmu: Drop smep_andnot_wp check from "uses
 NX" for shadow MMUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-17-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4f8f250-14ac-b964-c82d-6a3ef48bd38f@redhat.com>
Date:   Wed, 23 Jun 2021 19:11:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-17-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> Drop the smep_andnot_wp role check from the "uses NX" calculation now
> that all non-nested shadow MMUs treat NX as used via the !TDP check.
> 
> The shadow MMU for nested NPT, which shares the helper, does not need to
> deal with SMEP (or WP) as NPT walks are always "user" accesses and WP is
> explicitly noted as being ignored:
> 
>    Table walks for guest page tables are always treated as user writes at
>    the nested page table level.
> 
>    A table walk for the guest page itself is always treated as a user
>    access at the nested page table level
> 
>    The host hCR0.WP bit is ignored under nested paging.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 96c16a6e0044..ca7680d1ea24 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4223,8 +4223,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
>   	 * NX can be used by any non-nested shadow MMU to avoid having to reset
>   	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
>   	 */
> -	bool uses_nx = context->nx || !tdp_enabled ||
> -		context->mmu_role.base.smep_andnot_wp;
> +	bool uses_nx = context->nx || !tdp_enabled;
>   	struct rsvd_bits_validate *shadow_zero_check;
>   	int i;
>   
> 

Good idea, but why not squash it into patch 2?

Paolo

