Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D776A00A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjGaSJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjGaSJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:09:48 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981D3E7B
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:09:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-686ed1d2594so4613627b3a.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690826986; x=1691431786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jsZuyWI7KZo8u5qJzHB8Iz3lEzRGHNZVcfdqiF9Lvpw=;
        b=jHT/3E4k+ZMsjPoI7EWJeUciVPKM2GbnIsWVlXcBuTMjkDWc2zpXFeJfw/SGFQKWEO
         76fzzV8a71neETZ9OPJgOy0OZURYoY2nKsyo2PT7OsqzcBeVjUgHKvGhTZ7Du2hVTlKv
         tqeMl+1mGIh/MBiSRunWoI3kDwCh77ZYoCovhezGwJ0ywBBbqQyKYRxacx+o0euAF5Kf
         qmHMSdFYsXd4wZr56Gr+LpkQQXFFWZUnpM813tkRYrOYzQa6vDCHvCEYCI5ppdBRoHYI
         bWy6hCReDgVCKIuDGvi334qQHbZ9mePoi3by2d0d98NxLk1sLnVgBa4zpNH9o151K9dw
         DCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690826986; x=1691431786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsZuyWI7KZo8u5qJzHB8Iz3lEzRGHNZVcfdqiF9Lvpw=;
        b=dKunEzXvTHpJIOkyroree2m2Jv18/qe4fIXFM/xXN6I1ZMiC7L8hn8QQ6e95n6tL2O
         uFCv0nACw8kPgecutAqXA5D8f7Upo3QVFd7OJTWCaJfhGTG6S4lKazdvYpG3Qc3f1M7H
         6BDUOiDS5btBX13UkVa/0VJeWJytUF6+6olsgtaVxbmgFb2qoOXZ98RVwa+SFWmHXM3z
         3SLhD/WM2Um2lb48SzvfG4xHwqNTeyBVjrfECT1IF+r+L++HDuiM+vM11GmAcXLYw1cR
         R3lU5TEC4DwtqIEME7PkB1PHMnN5qV+i14jradQ8XZ9Cpfe07J+ek1lKRQvC3Ls0h5sy
         IWHw==
X-Gm-Message-State: ABy/qLZhkIPmQdLYVN0k1t6o7QkyWHGGvjz3+oSfqYPTXWTsUy6OY7nh
        b1dMoyx50oxvrD2RgprVCfX2kA==
X-Google-Smtp-Source: APBJJlETe73WrPLwmV4zXtqNT0+WhORRDNEW3QAd4H8MUg505KZPUmBNy2WrHTO+JRYA8+zWLAFd9A==
X-Received: by 2002:a05:6a21:2724:b0:137:74f8:62ee with SMTP id rm36-20020a056a21272400b0013774f862eemr10080254pzb.18.1690826985931;
        Mon, 31 Jul 2023 11:09:45 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7820a000000b006862e7f4648sm8107079pfi.99.2023.07.31.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 11:09:44 -0700 (PDT)
Date:   Mon, 31 Jul 2023 18:09:40 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v2 3/6] KVM: Documentation: Add the missing description
 for ptep in kvm_mmu_page
Message-ID: <ZMf45A9QU54GXEKd@google.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-4-mizhang@google.com>
 <ZJr/yoWzV7gHMuaG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJr/yoWzV7gHMuaG@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Mingwei Zhang wrote:
> > Add the missing description for ptep in kvm_mmu_page description. ptep is
> > used when TDP MMU is enabled and it shares the storage with parent_ptes.
> > Update the doc to help readers to get up-to-date info.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 4c9044b4dc6c..5cd6cd5e8926 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -237,6 +237,11 @@ Shadow pages contain the following information:
> >      parent_ptes points at this single spte, otherwise, there exists multiple
> >      sptes pointing at this page and (parent_ptes & ~0x1) points at a data
> >      structure with a list of parent sptes.
> > +  ptep:
> > +    The reverse mapping for the pte pointing at this page's spt. This field is
> 
> I don't think describing "reverse mapping" is necessary, and it's arguably even
> misleading.  A "reverse mapping" typically provides a way to find mappings given
> a (guest) physical address.  The TDP MMU doesn't bother with reverse mappings
> because there is exactly one possible mapping for any given gfn.  The "ptep" exists
> specifically to expedite zapping a single TDP MMU shadow page, i.e. allows zapping
> without having to traverse the paging tree.
> 
> The ptep field is just a pointer at the SPTE, no more no less.  Something like
> this?
> 
>   ptep:
>     The kernel virtual address of the SPTE that points at this shadow page.
>     Used exclusively by the TDP MMU, this field is a union with parent_ptes.
> 

Sure, I can this version instead. Technically, it is still a reverse
mapping, but yeah, I agree that introducing this one is confusing.

> > +    used in replace of parent_ptes when TDP MMU is used. In TDP MMU, each
> > +    non-root shadow page will have one parent, while each root shadow page has
> > +    no parent. Note that this field is a union with parent_ptes.
> >    unsync:
> >      If true, then the translations in this page may not match the guest's
> >      translation.  This is equivalent to the state of the tlb when a pte is
> > -- 
> > 2.41.0.162.gfafddb0af9-goog
> > 
