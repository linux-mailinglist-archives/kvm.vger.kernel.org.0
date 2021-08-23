Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2713F5021
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 20:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHWSMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 14:12:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231716AbhHWSMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 14:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629742280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kv9YiknVEko7VMAZHkVAmLtEQonqFOw4c0vjxRiulTE=;
        b=aj8gX65HzxTOigm4z9RcMILW9mwo7ViUh/+gf8bvIokXuQl8GlOOSrJySQTzw4HHDYTqR9
        xlVQ8mAkOhLUff4OwvaRalfJu1USo8V4cIpZZwGwAwSIM1YX2osGymymXbl3PhNIe/NQIG
        bY7zVkD/8aMBiJQ0zL2TDr5xaYf6Xas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-g2UOMuQRO1KSwSohP4RoNw-1; Mon, 23 Aug 2021 14:11:15 -0400
X-MC-Unique: g2UOMuQRO1KSwSohP4RoNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 002168CC5D1;
        Mon, 23 Aug 2021 18:10:52 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F30E660854;
        Mon, 23 Aug 2021 18:10:47 +0000 (UTC)
Message-ID: <e5b8b03e1079b6f7f36edb7695a48021b9a0a936.camel@redhat.com>
Subject: Re: [PATCH v3 0/3] SVM 5-level page table support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Date:   Mon, 23 Aug 2021 21:10:46 +0300
In-Reply-To: <YSPIgBNiMZkwAOSG@google.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
         <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
         <c10faf24c11fc86074945ca535572a8c5926dcf9.camel@redhat.com>
         <20210823151549.rkkrktvtpu6yapmd@weiserver.amd.com>
         <YSPIgBNiMZkwAOSG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-23 at 16:10 +0000, Sean Christopherson wrote:
> On Mon, Aug 23, 2021, Wei Huang wrote:
> > On 08/23 12:20, Maxim Levitsky wrote:
> > > This hack makes it work again for me (I don't yet use TDP mmu).
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index caa3f9aee7d1..c25e0d40a620 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3562,7 +3562,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
> > >             mmu->shadow_root_level < PT64_ROOT_4LEVEL)
> > >                 return 0;
> > >  
> > > -       if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
> 
> Maxim, I assume you hit this WARN and bail?
Yep.
> 
>         if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
>                          mmu->pml5_root))
> 		return -EIO;
> 
> Because as the comment states, KVM expects all the special roots to be allocated
> together.  The 5-level paging supported breaks that assumption because pml5_root
> will be allocated iff the host is using 5-level paging.
> 
>         if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
>                 pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>                 if (!pml5_root)
>                         goto err_pml5;
>         }
> 
> I think this is the least awful fix, I'll test and send a proper patch later today.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..93b2ed422b48 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3548,6 +3548,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
> +       bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
>         u64 *pml5_root = NULL;
>         u64 *pml4_root = NULL;
>         u64 *pae_root;
> @@ -3562,7 +3563,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>             mmu->shadow_root_level < PT64_ROOT_4LEVEL)
>                 return 0;
> 
> -       if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
> +       /*
> +        * NPT, the only paging mode that uses this horror, uses a fixed number
> +        * of levels for the shadow page tables, e.g. all MMUs are 4-level or
> +        * all MMus are 5-level.  Thus, this can safely require that pml5_root
> +        * is allocated if the other roots are valid and pml5 is needed, as any
> +        * prior MMU would also have required pml5.
> +        */
> +       if (mmu->pae_root && mmu->pml4_root && (!need_pml5 || mmu->pml5_root))
>                 return 0;
> 
>         /*
> @@ -3570,7 +3578,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>          * bail if KVM ends up in a state where only one of the roots is valid.
>          */
>         if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
> -                        mmu->pml5_root))
> +                        (need_pml5 && mmu->pml5_root)))
>                 return -EIO;
> 
>         /*
> 
> > > +       if (mmu->pae_root && mmu->pml4_root)
> > >                 return 0;
> > >  
> > >         /*

Makes sense, works, and without digging too much into this
I expected this to be fixed by something like that, so:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks,
Best regards,
	Maxim Levitsky



> > > 
> > > 
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 


