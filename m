Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5FF74DB25
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjGJQe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 12:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjGJQew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 12:34:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8230AB;
        Mon, 10 Jul 2023 09:34:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-263253063f9so3445167a91.1;
        Mon, 10 Jul 2023 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689006891; x=1691598891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=McmzJB5w4UGeZqusQBhdxfjqigG3UhKtoIfFccLuj2s=;
        b=UuZrn4FN/UbJwfewh85rKzjLye9uELQEX45+YZjjYTP/BYBPgS+1UF+XIPNG2dESCU
         W86RtEBWvSwsPMW2x13eLsYhpVucWKpqju+x0agjnUbM9X4mJPFqV5rxvm4kT+xeCHJ2
         VLT5n9dF1ENtaArZbX2UUhZour8m8LNq5DgukydBxaU2fh8GLhckDOL0rRtQHMK6r9Zy
         jdOMwsf8im36X5gkixxf9GaLSAwdB6NrArpT95n6SO2ZLoGIlJK/Rxm4qX2jwfk/k1E7
         Ou/qPcZpE/ua9W+K5ji+Kqm43nFA7KCT2k00BsUZLSUM4S3DFaj6X8Q0tH21tk5YJKRc
         ar2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689006891; x=1691598891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McmzJB5w4UGeZqusQBhdxfjqigG3UhKtoIfFccLuj2s=;
        b=evkAKDT0cLgFyquxKWBG/YBFtPJVctEyZXGq3jun5dnbfhkdwBgP9sE4C5kpybrZIr
         cCNxEuAEghN0WfCyFKLwf6psUEekJRQVXVcNJ+v/rqLjLHXF9eb8urERHAEk6temfgKx
         gOecd4cbYwJw1XYaeQ1JwJPOiErMgDg54uPxqOJEg1Y3mqgVW6HWL0URhguN4y+BlUkz
         0fpyg1uMUBVAH0V7ZtUxu4ATy0SiGuzNENBSW3exbuQG4N/kJxLmuPTwoCsKB/9kvqc/
         G5WMyfufLlRW2UvTgbVxtKFiPQ3Giv79+2we2FAX3DLee96ukcGIzEicCTYBgxShAhB8
         j/KQ==
X-Gm-Message-State: ABy/qLYEfwPHbXoGLrUR3jDeSG+im09glk/Fe9GUTgD90IiIJnKfYTrW
        /XMdcpoeRvvtKWp5mAYAAJc=
X-Google-Smtp-Source: APBJJlFGgItLHZLzX11JZjIS73D9W6Es/hAVqOzRDVW3J19VHlBJaksBcwskjpiGnATOLXIP8QCxUQ==
X-Received: by 2002:a17:90a:b315:b0:261:113e:50d2 with SMTP id d21-20020a17090ab31500b00261113e50d2mr13856226pjr.31.1689006890824;
        Mon, 10 Jul 2023 09:34:50 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090aae0800b00263f40cf83esm6456783pjq.47.2023.07.10.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 09:34:50 -0700 (PDT)
Date:   Mon, 10 Jul 2023 09:34:48 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230710163448.GE3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
 <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com>
 <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023 at 10:35:02AM +0900,
David Stevens <stevensd@chromium.org> wrote:

> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index e44ab512c3a1..b1607e314497 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > >
> > > > ...
> > > >
> > > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> > > > >       bool host_writable = !fault || fault->map_writable;
> > > > >       bool prefetch = !fault || fault->prefetch;
> > > > >       bool write_fault = fault && fault->write;
> > > > > +     bool is_refcounted = !fault || fault->is_refcounted_page;
> > > >
> > > > Just wonder, what if a non-refcounted page is prefetched?  Or is it possible in
> > > > practice?
> > >
> > > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > > FOLL_GET. That's fixable, but it's not something this series currently
> > > does.
> >
> > So if we prefetch a page, REFCOUNTED bit is cleared unconditionally with this
> > hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for prefetched
> > spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should represent
> > whether the corresponding page is ref-countable or not, right?
> >
> > Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(prefetch_pte)
> > is shadow paging, we need to test it with legacy KVM MMU or shadow paging to hit
> > the issue, though.
> >
> 
> direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
> fault parameter, so is_refcounted will evaluate to true. So the spte's
> refcounted bit will get set in that case.

Oops, my bad.  My point is "unconditionally".  Is the bit always set for
non-refcountable pages?  Or non-refcountable pages are not prefeched?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
