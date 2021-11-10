Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9082144C389
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhKJPDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 10:03:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbhKJPDu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 10:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636556462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cuzPpu25xMZj9bq/LSjhEetjUdKRTAJi3G60ivnlha8=;
        b=PmdhJfnqJfKS1Z4fxkqpbSgPuFSSSXgkrdP9NagfVw2nMvOL8zeSq0lD+vLZ0612DioZrk
        skl2b34U1nEBCeGv3yZrHS6dEe5Ef9zGY5HbqWgfjhh7nbqMQZXhj3yePOh35gyUvA1xdC
        ZKy7Flo3nqFUFewQ9RWuRltxufZtKKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-fDpyC4X_NH6CpTCXrN6_fw-1; Wed, 10 Nov 2021 10:00:59 -0500
X-MC-Unique: fDpyC4X_NH6CpTCXrN6_fw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 471C680A5D6;
        Wed, 10 Nov 2021 15:00:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C7CB1017E37;
        Wed, 10 Nov 2021 15:00:46 +0000 (UTC)
Message-ID: <18d77c7a10f283848c4efe0370401c436869f3a2.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: don't skip mmu initialization when
 mmu root level changes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Date:   Wed, 10 Nov 2021 17:00:45 +0200
In-Reply-To: <87r1bom5h3.fsf@vitty.brq.redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
         <20211110100018.367426-4-mlevitsk@redhat.com>
         <87r1bom5h3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-10 at 15:48 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > When running mix of 32 and 64 bit guests, it is possible to have mmu
> > reset with same mmu role but different root level (32 bit vs 64 bit paging)
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 354d2ca92df4d..763867475860f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4745,7 +4745,10 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> >  	union kvm_mmu_role new_role =
> >  		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
> >  
> > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > +	u8 new_root_level = role_regs_to_root_level(&regs);
> > +
> > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > +	    context->root_level == new_root_level)
> >  		return;
> 
> role_regs_to_root_level() uses 3 things: CR0.PG, EFER.LMA and CR4.PAE
> and two of these three are already encoded into extended mmu role
> (kvm_calc_mmu_role_ext()). Could we achieve the same result by adding
> EFER.LMA there?

Absolutely. I just wanted your feedback on this to see if there is any reason to not
do this.

Also it seems that only basic role is compared here.

I don't 100% know the reason why we have basic and extended roles - there is a
comment about basic/extended mmu role to minimize the size of arch.gfn_track,
but I haven't yet studied in depth why.

Best regards,
	Maxim Levitsky

> 
> >  
> >  	context->mmu_role.as_u64 = new_role.as_u64;
> > @@ -4757,7 +4760,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> >  	context->get_guest_pgd = get_cr3;
> >  	context->get_pdptr = kvm_pdptr_read;
> >  	context->inject_page_fault = kvm_inject_page_fault;
> > -	context->root_level = role_regs_to_root_level(&regs);
> > +	context->root_level = new_root_level;
> >  
> >  	if (!is_cr0_pg(context))
> >  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> > @@ -4806,7 +4809,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> >  				    struct kvm_mmu_role_regs *regs,
> >  				    union kvm_mmu_role new_role)
> >  {
> > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > +	u8 new_root_level = role_regs_to_root_level(regs);
> > +
> > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > +	    context->root_level == new_root_level)
> >  		return;
> >  
> >  	context->mmu_role.as_u64 = new_role.as_u64;
> > @@ -4817,8 +4823,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> >  		paging64_init_context(context);
> >  	else
> >  		paging32_init_context(context);
> > -	context->root_level = role_regs_to_root_level(regs);
> >  
> > +	context->root_level = new_root_level;
> >  	reset_guest_paging_metadata(vcpu, context);
> >  	context->shadow_root_level = new_role.base.level;


