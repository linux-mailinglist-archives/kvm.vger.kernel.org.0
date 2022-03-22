Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB994E37F5
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 05:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbiCVE35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 00:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiCVE3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 00:29:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1F270E
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:28:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g19so17189026pfc.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 21:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ha0vPVeUDzbZ9ELlg8Nq/jWp7wou24wRrMHx+56fZxo=;
        b=dS5HqZLfymPE1FEpGN8CF3og/rwMyQBSfx//mku/6Pb3G6uEDl1wZJYqx/0D7Av8DB
         0R1BwA2bSA0IC8XfDabP8u00zVP/zA3WEzNSMuXAkO7MmsKljJt6V2A+PNDvioOeH6nW
         3nMjlgOtfyZPoBBpMQ7fPsw9NKXjHT/jHE+CHbiVi5dDwxeXEaxlNCBDYLvjAb9INsyy
         +NtiEqpsIEdjuiUiLD9CBVdvQFZ7gF914nRZp1ZTPCTetElYHenjTD+iWWBdyCgIO8wf
         LHLPoTah47tJSxQZC9JAYxjhYswJL9+dc/IM37RbZ/8D0FgLmpFtpOgHSyGmpmDuHeDg
         hRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ha0vPVeUDzbZ9ELlg8Nq/jWp7wou24wRrMHx+56fZxo=;
        b=apyVcb0QmMZacF/s2RjTbmTCM6rUuoY/6whMaUAYJ8ISsRXx6L2lvxZKzgX5cOkBx3
         deWr46NZw1DzZu2aJevcgm2X8WHVdzA/Ik1nlxCSunbRfs60t/qRGon3z0+5CaFdtXME
         CqbhGD0jxPfcfFNHFkLKzEQWLlKR6RNksEOWUNrili3rMzP95JLwYSnTgvedjoOYVuXZ
         f7orvCnTRetepQJ29wVGWPq+cIp9TZ4whfMnvcTX5Dme077Ge/tx3+V+WeKt2kajwRI6
         xbnh5KN81QJtipSSwKo8j0aLO61hrnGz/6dTFdCTL1phvATNR3AcJ/egpur39vKJIViO
         ME1A==
X-Gm-Message-State: AOAM533zRPePit5F7QpKjJT7zITqengyKItGoTFeWrUbbkVj4YADEDOE
        5CGNIp/CWoxiGuOKeUeSwGi2zQ==
X-Google-Smtp-Source: ABdhPJxpDLeQvQGuL6QYWTg3aYYr3a61A1CbgUAeNp//ITGJB7BSDfO3WaM6VagN1VPMXBANuZedqA==
X-Received: by 2002:a05:6a00:1ac8:b0:4fa:917f:c1aa with SMTP id f8-20020a056a001ac800b004fa917fc1aamr11379307pfv.2.1647923303715;
        Mon, 21 Mar 2022 21:28:23 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id j3-20020a056a00234300b004faabba358fsm4600997pfj.14.2022.03.21.21.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 21:28:23 -0700 (PDT)
Date:   Tue, 22 Mar 2022 04:28:19 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YjlQY0EI1YMrCBm0@google.com>
References: <20220321002638.379672-1-mizhang@google.com>
 <20220321002638.379672-4-mizhang@google.com>
 <CANgfPd_CexHH-QDs899RdEpAO=xGnSfdf80FZzOsum5oYEPCMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_CexHH-QDs899RdEpAO=xGnSfdf80FZzOsum5oYEPCMw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022, Ben Gardon wrote:
> On Sun, Mar 20, 2022 at 5:26 PM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > Add extra check to specify the case of nx hugepage and allow KVM to
> > reconstruct large mapping after dirty logging is disabled. Existing code
> > works only for nx hugepage but the condition is too general in that does
> > not consider other usage case (such as dirty logging). Moreover, existing
> > code assumes that a present PMD or PUD indicates that there exist 'smaller
> > SPTEs' under the paging structure. This assumption may no be true if
> > consider the zapping leafs only behavior in MMU.
> >
> > Missing the check causes KVM incorrectly regards the faulting page as a NX
> > huge page and refuse to map it at desired level. And this leads to back
> > performance in shadow mmu and potentiall TDP mmu.
> >
> > Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> > Cc: stable@vger.kernel.org
> >
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5628d0ba637e..4d358c273f6c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2919,6 +2919,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> >             cur_level == fault->goal_level &&
> >             is_shadow_present_pte(spte) &&
> >             !is_large_pte(spte)) {
> > +               struct kvm_mmu_page *sp;
> > +               u64 page_mask;
> > +               /*
> > +                * When nx hugepage flag is not set, there is no reason to
> > +                * go down to another level. This helps demand paging to
> > +                * generate large mappings.
> > +                */
> 
> This comment is relevant to Google's internal demand paging scheme,
> but isn't really relevant to UFFD demand paging.
> Still, as demonstrated by the next commit, this is important for dirty
> loggin, so I'd suggest updating this comment to refer to that instead.
> 

Ah, leaking my true motivation :-) Definitely will update the comment.

> > +               sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > +               if (!sp->lpage_disallowed)
> > +                       return;
> >                 /*
> >                  * A small SPTE exists for this pfn, but FNAME(fetch)
> >                  * and __direct_map would like to create a large PTE
> > @@ -2926,8 +2936,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> >                  * patching back for them into pfn the next 9 bits of
> >                  * the address.
> >                  */
> > -               u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> > -                               KVM_PAGES_PER_HPAGE(cur_level - 1);
> > +               page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> > +                       KVM_PAGES_PER_HPAGE(cur_level - 1);
> >                 fault->pfn |= fault->gfn & page_mask;
> >                 fault->goal_level--;
> >         }
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >
