Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF964CFE2
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbiLNTJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLNTJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:09:10 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9942654
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:09:09 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id js9so7982392pjb.2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FIlNxfH2N14uQxL9gQjMu+4jFBzMKkxQj54k3fDEAoM=;
        b=ki7KXMuMgFSwbFlvvSqSuOQhI4nnWJpLKfKstanOkB/onj5nUHoVz525QhfZ8nokKB
         VXeBAUiQXL7JxbcSrDvQSoa4lSwXeMjbkvKivBYSZ0TEpYbXer0eJBuO5rSLLr9It5WK
         fvs+dp4wbuKBP0yy+S1uOP84czNeK8nhe/1Uifui5WzzQ+tKUtXjnaV2x0inbQFe8dNk
         qOUQLOFp3Ks0/MP/nhesJP/lViUPuMv+FypbFBL4U08YgIe7ET0AWrPZN0TUa7vtcmVX
         4UPcD3345eJMKynVDVcjhWoPJZZ1z1i5AX6S+YpLVZ/1/YeT1xAjXv5yV02NAAay6VtC
         Kq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIlNxfH2N14uQxL9gQjMu+4jFBzMKkxQj54k3fDEAoM=;
        b=jqdjNw3SP+JSRYzaMYZg/Re1WpcqBU9RlEHGZD+u2YOSzSXL6q1+FbCAZ5Rv/fqosE
         7ooE83CulB7oEcDKKpoxga8xYfuegVArphuycWuX2tRxoXs+ei/+Z7D5F/1udbu5eeKw
         8Q28ETXvqoLQFMD+lD1H+uU2XKf8Hj7Yo8B/uC+/Uj0sV8nixnSajbiQJSn1C4XDOZST
         1+haV554bayaj2f99D4Kym1DEoQNAUxPnMaUnUBU4zjBN/9McobQ7Og9Uw5bItWFfAtK
         tvpKUTfKNk9SbsJnywfvBxRbxJRiZ1WCOJpTGE5hIITMm0WTK83krp7fFo12RRm+Yga7
         vIyA==
X-Gm-Message-State: ANoB5plc1dWzAzDjpV+isYYKylwRskF5H+Ux2yrfMrDN/21H2RmD1oG6
        qgmxyWbHJEPp8TDG7AXYVTT8cg==
X-Google-Smtp-Source: AA0mqf7VDwtO7bD7iDYUg1CUV8sCconizPsDQAtMy4jK4dIm4X3K9Vibe1wrX4pKJoLBdYIM/pjdjg==
X-Received: by 2002:a05:6a21:2d8f:b0:a7:882e:3a18 with SMTP id ty15-20020a056a212d8f00b000a7882e3a18mr671791pzb.1.1671044948611;
        Wed, 14 Dec 2022 11:09:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e28-20020aa7981c000000b00575b6f8b84esm234502pfl.26.2022.12.14.11.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 11:09:06 -0800 (PST)
Date:   Wed, 14 Dec 2022 19:09:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Reduce the update to the spte in
 FNAME(sync_page)
Message-ID: <Y5ofTvOwg46xHeDk@google.com>
References: <20221212153205.3360-1-jiangshanlai@gmail.com>
 <20221212153205.3360-2-jiangshanlai@gmail.com>
 <Y5jAbS4kwRAdrWwM@google.com>
 <CAJhGHyAksXZHO_BC391ax4rHgQLE=xWeZu6dxN60gSgGij+ZLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyAksXZHO_BC391ax4rHgQLE=xWeZu6dxN60gSgGij+ZLg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Lai Jiangshan wrote:
> Hello Sean,
> 
> On Wed, Dec 14, 2022 at 2:12 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Dec 12, 2022, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > >
> > > Sometimes when the guest updates its pagetable, it adds only new gptes
> > > to it without changing any existed one, so there is no point to update
> > > the sptes for these existed gptes.
> > >
> > > Also when the sptes for these unchanged gptes are updated, the AD
> > > bits are also removed since make_spte() is called with prefetch=true
> > > which might result unneeded TLB flushing.
> >
> > If either of the proposed changes is kept, please move this to a separate patch.
> > Skipping updates for PTEs with the same protections is separate logical change
> > from skipping updates when making the SPTE writable.
> >
> > Actually, can't we just pass @prefetch=false to make_spte()?  FNAME(prefetch_invalid_gpte)
> > has already verified the Accessed bit is set in the GPTE, so at least for guest
> > correctness there's no need to access-track the SPTE.  Host page aging is already
> > fuzzy so I don't think there are problems there.
> 
> FNAME(prefetch_invalid_gpte) has already verified the Accessed bit is set
> in the GPTE and FNAME(protect_clean_gpte) has already verified the Dirty
> bit is set in the GPTE.  These are only for guest AD bits.
> 
> And I don't think it is a good idea to pass @prefetch=false to make_spte(),
> since the host might have cleared AD bit in the spte for aging or dirty-log,
> The AD bits in the spte are better to be kept as before.

Drat, I was thinking KVM never flushes when aging SPTEs, but forgot about
clear_flush_young().

Rather than skipping if the Accessed bit is the only thing that's changing, what
about simply preserving the Accessed bit?  And s/prefetch/accessed in make_spte()
so that future changes to make_spte() don't make incorrect assumptions about the
meaning of "prefetch".

Another alternative would be to conditionally preserve the Accessed bit, i.e. clear
it if a flush is needed anyways, but that seems unnecessarily complex.

> Though passing @prefetch=false would not cause any correctness problem
> in the view of maintaining guest AD bits.
> 
> >
> > > Do nothing if the permissions are unchanged or only write-access is
> > > being added.
> >
> > I'm pretty sure skipping the "make writable" case is architecturally wrong.  On a
> > #PF, any TLB entries for the faulting virtual address are required to be removed.
> > That means KVM _must_ refresh the SPTE if a vCPU takes a !WRITABLE fault on an
> > unsync page.  E.g. see kvm_inject_emulated_page_fault().
> 
> I might misunderstand what you meant or I failed to connect it with
> the SDM properly.
> 
> I think there is no #PF here.
> 
> And even if the guest is requesting writable, the hypervisor is allowed to
> set it non-writable and prepared to handle it in the ensuing write-fault.

Yeah, you're right.  The host will see the "spurious" page fault but it will
never get injected into the guest.

> Skipping to make it writable is a kind of lazy operation and considered
> to be "the hypervisor doesn't grant the writable permission for a period
> before next write-fault".

But that raises the question of why?  No TLB flush is needed precisely because any
!WRITABLE fault will be treated as a spurious fault.  The cost of writing the
SPTE is minimal.  So why skip?  Skipping just to reclaim a low SPTE bit doesn't
seem like a good tradeoff, especially without a concrete use case for the SPTE bit.

E.g. on pre-Nehalem Intel CPUs, i.e. CPUs that don't support EPT and thus have
to use shadow paging, the CPU automatically retries accesses after the TLB flush
on permission faults.  The lazy approach might introduce a noticeable performance
regression on such CPUs due to causing more #PF VM-Exits than the current approach.
