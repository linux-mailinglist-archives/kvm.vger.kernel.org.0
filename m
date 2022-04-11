Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066E14FC750
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 00:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiDKWHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 18:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350418AbiDKWHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 18:07:36 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFD11FA5A
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:05:20 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id 75so9512256qkk.8
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mub+V7xFFXRdwh5J41falSS4UullJ6qzBmVcOTDmxgk=;
        b=egT0WxHMUqej3A8vHlkTMS6AVjxNKvBf6Y1To2j4V/eq0V3F15Z1gz1VdYUe5p2tDD
         g+7HNELN8XvasTyhABrdYBH428t5oP3Gl1PkoOdscRBajL9C0r7l6HqJ1UkJQUbIY//c
         8DZpqcQX7PA9vGb5UsEDkUqZm44FXCLmXrU5QWnHyXQqM5n83XFzz77HbtgzwQge/L6K
         ZzTML2RMfp7YqX434QpEkz1bOaQC0czADaX889KqDqojI05S/6DR0jWipvTnha5MdAdf
         VC0NFvviRjL/+zYhL5u5HMep13eg9LjgfHZxln/RcJg91Oh8WIVMwNXoS86TE04PZxlb
         xXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mub+V7xFFXRdwh5J41falSS4UullJ6qzBmVcOTDmxgk=;
        b=xzM35p89sjZwtNjjAanxdExhtTjNi/ltdGbNB24wcDRiN6QBlhmdY6DLCUdj2+wQF5
         gQKY5XCgXzLU1rJmhZnwMOnWsOR8eAZJcKyk7/O+jNQnn+0x7RLNo8HWJwn9LpM4ZvC3
         DdvQOXkRADPDjlMp5M7uVddZmIklvDAHDPnwvg5ZSXbQHc7V7IWuXtr+9oxHjNBGkNDx
         XbnBv3jeCtG5z1egUmhL3QpJrIJxMa9WFXIa6fcE5JqcHUAmJHGuOsCYwJANYEW6jnav
         LBirFam8LRYwSP5brGcFSS6Ek60aGftrMH6DRVc9bDDb8unM1DZsOZb7S6XSmrbLASO+
         JJZw==
X-Gm-Message-State: AOAM531NVR6yVXbe4R//eJFR8ZZ+yoNCh7vV3DU8jYThXaAMnV7Ctmyb
        8sspwVgjmyJW8cxFYMs4shYYSszrS0Z0YDBcR1MC6g==
X-Google-Smtp-Source: ABdhPJxcmDQu+qNfZ6YKxOWUrvyXbXfbcHHU+1f8W+SrYJM0YDz/aCKCEh8LI+RA4P/WqT3wIO8LeJ9U7ZBZDexkpew=
X-Received: by 2002:a37:aec2:0:b0:69a:4a5:925 with SMTP id x185-20020a37aec2000000b0069a04a50925mr1112459qke.292.1649714719525;
 Mon, 11 Apr 2022 15:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com> <20220409003847.819686-3-seanjc@google.com>
 <YlRn+8bYsHqNIbTU@google.com> <YlR0a4PG5xzweeMZ@google.com>
In-Reply-To: <YlR0a4PG5xzweeMZ@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 11 Apr 2022 15:05:08 -0700
Message-ID: <CAL715WL-ji6V8BdCGsjLQ80V658_P0ccymtJgsmXGh+x-wM2Yw@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 11:33 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Apr 11, 2022, Mingwei Zhang wrote:
> > On Sat, Apr 09, 2022, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 671cfeccf04e..89df062d5921 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -191,6 +191,15 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >             .user = err & PFERR_USER_MASK,
> > >             .prefetch = prefetch,
> > >             .is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> > > +
> > > +           /*
> > > +            * Note, enforcing the NX huge page mitigation for nonpaging
> > > +            * MMUs (shadow paging, CR0.PG=0 in the guest) is completely
> > > +            * unnecessary.  The guest doesn't have any page tables to
> > > +            * abuse and is guaranteed to switch to a different MMU when
> > > +            * CR0.PG is toggled on (may not always be guaranteed when KVM
> > > +            * is using TDP).  See make_spte() for details.
> > > +            */
> > >             .nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
> >
> > hmm. I think there could be a minor issue here (even in original code).
> > The nx_huge_page_workaround_enabled is attached here with page fault.
> > However, at the time of make_spte(), we call is_nx_huge_page_enabled()
> > again. Since this function will directly check the module parameter,
> > there might be a race condition here. eg., at the time of page fault,
> > the workround was 'true', while by the time we reach make_spte(), the
> > parameter was set to 'false'.
>
> Toggling the mitigation invalidates and zaps all roots.  Any page fault acquires
> mmu_lock after the toggling is guaranteed to see the correct value, any page fault
> that completed before kvm_mmu_zap_all_fast() is guaranteed to be zapped.

hmm. ok.
>
> > I have not figured out what the side effect is. But I feel like the
> > make_spte() should just follow the information in kvm_page_fault instead
> > of directly querying the global config.
>
> I started down this exact path :-)  The problem is that, even without Ben's series,
> KVM uses make_spte() for things other than page faults.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
