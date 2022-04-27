Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C71F511926
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiD0OLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiD0OLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:11:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B886B4B40F
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 07:08:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id iq10so1625177pjb.0
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wcKBX/x7aHbwy2eQa/0b3oj/jc0z2fTHrAAn+gTDCRc=;
        b=cbQDMg9fNNcB4Lp8zQBGRiZIVuDVCRQBnuWm0ShFQvBTPTyKeBHwxnZEZ2Qm5ge2V/
         /A3xdNy/M1a5/U74cSqRRBxYfwVLFs8ZmroqKiPQyvWubn5q5GZMqkcDZ1Jkwu4tNREX
         VxngRXDJgMRyrMVbJP6lhs/vPVcl/H6HPtEryQUcGXDOlNpB0UTjLaIy1tUxHDGnjN7f
         VNNA3TYpSs5UOPWE7zg0KYHTUdCTZOQhzKnw5gZ1nNqN1FZnO8O1RPg5alkEfgyFRgkK
         hObGk09T5NHAiQ6nCJxlaR3/hWY60yA4oN+4DyoYk9I0A+NnhBS8f+n1MCMfe+OY2K0p
         NulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wcKBX/x7aHbwy2eQa/0b3oj/jc0z2fTHrAAn+gTDCRc=;
        b=tEtkGcRWrwm9tSBG0vYv7sO4Kfc/9O5Ewy7ZhP0ucL4PD8ZjTx0KkDJAbUeBgqTLrq
         xq38aD/7RA0L7nWkOSzCffKhcypdbmiHvkbjUCg97gh+ZXFv6beTCRbQiSFSdemMIQrZ
         s0e+LxGfxEnPcOzSCgP/H67nHu/6L55M7r8B6vz7HbvJTSJ1ildq5I776A9z30zXFcaZ
         Bs3wd5c4DPWircQGX97wl06pl8Q4HXXbCDcBnx0rB0A1/iWTbjHBaBHBf2UqsZa8AQmh
         uiZrKLzzxNA9eL6d6KaFP3GmkIWPM7bqmWWsG6+7LlgtvCKGE/q39Op+7c6D6uG39E6K
         Fpgw==
X-Gm-Message-State: AOAM531ACeORhTGzVJ86GrPMm1dgm5M8xZZAsbgCkYcSgznISvBCmyrF
        8MxW53wLJ4jHRSexnGwIdz77dQ==
X-Google-Smtp-Source: ABdhPJxMFkyeA50O/t8Mv2R7XyttGzuDp/Jy9gQJ5gEhceX+lGxbN7XZKDrSvie2PtooYYn/Uez/vQ==
X-Received: by 2002:a17:902:8e81:b0:158:fd26:1b95 with SMTP id bg1-20020a1709028e8100b00158fd261b95mr28443970plb.142.1651068504045;
        Wed, 27 Apr 2022 07:08:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z23-20020a17090a609700b001d93118827asm2969315pji.57.2022.04.27.07.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 07:08:23 -0700 (PDT)
Date:   Wed, 27 Apr 2022 14:08:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Message-ID: <YmlOVNAQodY+5p/N@google.com>
References: <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com>
 <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
 <Ymg1lzsYAd6v/vGw@google.com>
 <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
 <YmiZcZf9YXxMVcfx@google.com>
 <CAL715W+nMyF_f762Qif8ZsiOT8vgxXJ3Rm8EjgG8A=b7iM-cbg@mail.gmail.com>
 <YmiczBawg5s1z2DN@google.com>
 <CAL715W+iZ+uwctT80pcsBrHsF96zWZMAfeVgvWcvvboLz0MkaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715W+iZ+uwctT80pcsBrHsF96zWZMAfeVgvWcvvboLz0MkaQ@mail.gmail.com>
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

On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> On Tue, Apr 26, 2022 at 6:30 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > > On Tue, Apr 26, 2022 at 6:16 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > > > > > I completely agree that lookup_address() and friends are unnecessarily fragile,
> > > > > > but I think that attempting to harden them to fix this KVM bug will open a can
> > > > > > of worms and end up delaying getting KVM fixed.
> > > > >
> > > > > So basically, we need to:
> > > > >  - choose perf_get_page_size() instead of using any of the
> > > > > lookup_address*() in mm.
> > > > >  - add a wrapper layer to adapt: 1) irq disabling/enabling and 2) size
> > > > > -> level translation.
> > > > >
> > > > > Agree?
> > > >
> > > > Drat, I didn't see that it returns the page size, not the level.  That's a bit
> > > > unfortunate.  It definitely makes me less averse to fixing lookup_address_in_pgd()
> > > >
> > > > Hrm.  I guess since we know there's at least one broken user, and in theory
> > > > fixing lookup_address_in_pgd() should do no harm to users that don't need protection,
> > > > it makes sense to just fix lookup_address_in_pgd() and see if the x86 maintainers
> > > > push back.
> > >
> > > Yeah, fixing lookup_address_in_pgd() should be cleaner(), since the
> > > page fault usage case does not need irq save/restore. But the other
> > > one needs it. So, we can easily fix the function with READ_ONCE and
> > > lockless staff. But wrapping the function with irq save/restore from
> > > the KVM side.
> >
> > I think it makes sense to do the save/restore in lookup_address_in_pgd().  The
> > Those helpers are exported, so odds are good there are broken users that will
> > benefit from fixing all paths.
> 
> no, lookup_address_in_pgd() is probably just broken for KVM. In other
> call sites, some may already disable IRQ, so doing that again inside
> lookup_address_in_pgd() will be bad.

No, it's not bad.  local_irq_save/restore() intended preciesly for cases where
IRQs need to be disabled but IRQs may or may not have already been disabled by
the caller.   PUSHF+POPF is not expensive relatively speaking, 

> I am looking at here:
> https://elixir.bootlin.com/linux/latest/source/arch/arm/kernel/traps.c#L304

That's arm code, lookup_address_in_pgd() is x86 specific.  :-) That said, I'm sure
there exists at least one caller that runs with IRQs disabled.  But as above,
it's not a problem.

> so, the save/restore are done in oops_begin() and oops_end(), which is
> wrapping show_fault_oops() that calls lookup_address_in_pgd().
> 
> So, I think we need to ensure the READ_ONCE.
> 
> hmm, regarding the lockless macros, Paolo is right, for x86 it makes
> no difference. s390 seems to have a different implementation, but
> kvm_mmu_max_mapping_level() as well as host_pfn_mapping_level are both
> functions in x86 mmu.

Yep, all of this is x86 specific.
