Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED8F3B214C
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 21:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFWTjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 15:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFWTjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 15:39:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB8FC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 12:36:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d12so2630948pgd.9
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 12:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DlZY/TglFz9Z+A/FXNVmCx8+XtZYKOCmoni9885067M=;
        b=P2kxwQz7RbtSVh2sDIXBaHMTo7nhNcUuMgEys+kaa61inUPicr0NuRffqlBA4+7anp
         3FN9ufvskOQ+YDx9TQPxPrk/vpRopw7QRnYnYG734rPrUe5k0xedegvZuA7O8efRjQRn
         twFIga5jSf0f/rLLspvYuTzQ+NuhgCOr2J0e2zpVoBxIjdKHseBd4ezqwGThXvMU4yb9
         y2KJmK5fLZKDWv261UiwKxKNJIVti8Fi2aOyxpDqfPQsthM4aP4zN6xLOLQ9Zv1LgwuK
         30bshb9jzrJA+W0AJk4rJ5665/OYhoGYuxsuWAfeYxOiy9FZMhTalIvrmQtJhVjj0yLI
         eNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DlZY/TglFz9Z+A/FXNVmCx8+XtZYKOCmoni9885067M=;
        b=pYD9z8tW05TXYrrxapS8mOkCk2VxXYNZDhqeOCwdoe1rzmCSjuAJMiQTE+EM8eFrmn
         azNhuElEjjAy4rOgfGo5XM3zpCoG/QyklI71jTfvF+cOXebqURr152YDSyZvY2iB0WZR
         Bf/2krWrmNQ6SZWCGD0qCu2g55iCSYUYQuWf11izUiIPLyqkhFQtPYkFwmEYZ4xJGJlZ
         hvfEpOU8sAWXjwXxzwP1IErqH2R2nN7SIz5g3eF8wSDsWZBRgRCvTkCp51ZZccfUJdGY
         4xuIr7rNac+kOFGFDlv5R1/0BHb+wPaS9r8NdclyWG9y0dcaPzPggStBEcS01g6rfbD6
         UAuQ==
X-Gm-Message-State: AOAM532RMzIYlF6x9Ef/CvSOXTRYnB+s/OncMqL33oE64KZ4YvM8g3VD
        dKmDO0NFehVLRlkRDYdoeQCdww==
X-Google-Smtp-Source: ABdhPJyYMVuea+gbeWDgtzHw4uopdhfLoWSqWVlRSJHP5Vpf+/KUJ8I3RIpiQwtQJ55NkVDAEmUgSg==
X-Received: by 2002:a65:5ac9:: with SMTP id d9mr986290pgt.293.1624477018561;
        Wed, 23 Jun 2021 12:36:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6sm578633pfa.215.2021.06.23.12.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:36:57 -0700 (PDT)
Date:   Wed, 23 Jun 2021 19:36:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 16/54] KVM: x86/mmu: Drop smep_andnot_wp check from "uses
 NX" for shadow MMUs
Message-ID: <YNONVux/a+/fuw0I@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-17-seanjc@google.com>
 <b4f8f250-14ac-b964-c82d-6a3ef48bd38f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f8f250-14ac-b964-c82d-6a3ef48bd38f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:57, Sean Christopherson wrote:
> > Drop the smep_andnot_wp role check from the "uses NX" calculation now
> > that all non-nested shadow MMUs treat NX as used via the !TDP check.
> > 
> > The shadow MMU for nested NPT, which shares the helper, does not need to
> > deal with SMEP (or WP) as NPT walks are always "user" accesses and WP is
> > explicitly noted as being ignored:
> > 
> >    Table walks for guest page tables are always treated as user writes at
> >    the nested page table level.
> > 
> >    A table walk for the guest page itself is always treated as a user
> >    access at the nested page table level
> > 
> >    The host hCR0.WP bit is ignored under nested paging.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 96c16a6e0044..ca7680d1ea24 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4223,8 +4223,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
> >   	 * NX can be used by any non-nested shadow MMU to avoid having to reset
> >   	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
> >   	 */
> > -	bool uses_nx = context->nx || !tdp_enabled ||
> > -		context->mmu_role.base.smep_andnot_wp;
> > +	bool uses_nx = context->nx || !tdp_enabled;
> >   	struct rsvd_bits_validate *shadow_zero_check;
> >   	int i;
> > 
> 
> Good idea, but why not squash it into patch 2?

Because that patch is marked for stable and dropping the smep_andnot_wp is not
necessary to fix the bug.  At worst, the too-liberal uses_nx will suppress the
WARN in handle_mmio_page_fault() because this is for checking KVM's SPTEs, not
the guest's SPTEs, i.e. KVM won't miss a guest reserved NX #PF.

That said, I'm not at all opposed to squashing this.  I have a feeling I originally
split the patches because I wasn't super confident about either change, and never
revisited them.
