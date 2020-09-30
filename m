Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5527F5A0
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbgI3XDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730307AbgI3XDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 19:03:18 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA3BC0613D0
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:03:16 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q1so4112289ilt.6
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydei6tbieUrGV84RcjcDG5+cKSABmfDZaMX7u0/RNhs=;
        b=UPyxJUuPwzHVrtOgksQO8MAx7iiUFj9uPQ50sUQ5Oxl1pxUI7SSuQwnfj1EjV9ewEt
         lUrPC3/z+6+zAKRowAoBSarHNuTHMqBlHgT7D8oqYHt62PDoCNdmZzd9Ad8SbvxYLx7Z
         lxhQZCXq5Qjj7MIxo1/AdFPmHFjQxRwxtQhqEWClyEO4VeqAk/8VzvqNPGYXwlayPVct
         ++BA5NxlOHmBhgbTBQ3Pcfs4oZHNfO+4o12r7uHzw4MtPPVsGRGpvC5tHREoc+ALZTpU
         PD7gUAgqg0qZMZwBUC5FqjGq+zeC1Rou5vL6YONOY7h44Slry6qn7MQuq5ysmWI33Dtg
         N90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydei6tbieUrGV84RcjcDG5+cKSABmfDZaMX7u0/RNhs=;
        b=gX+zgHhyyHXiTmIzuN4fjaKjr3wTwNI01aLaZGUOoUc4w0f9YYxtO8wAZYcE0sMw5r
         phH13ZE4SdbjVg93pYRPA1iSMGT845w88li9C4p5uucmxn0tyUuo8GphH4bo6kH5XHKD
         +Y9RsdPJP6PQbDJES7IRONrjR2r4lip2nEjmdcYz2n2XDZPK4AVJJgc3z0MUJBqCsE0K
         CubcjUpP/MhdjfjI0ScG+jcgsMN3tviv+DMMHGr7gwlIrGkiU8TZIpb+sZ5p2y88o7va
         ce4jVGpT349EtVeDY+EFNo658jc2/5sW7DYRFj+IeVD0XJ8fGft08rkPmWDGwGvW3uIh
         YKKQ==
X-Gm-Message-State: AOAM533C15EvECO3FGyv/EsAMJFg7wdgoR03wEi/+0MOTI27APnPqCxr
        Xv8DhBNiiFdv0lePgNA/tPIPl3g9E7vbEwufTG9SQg==
X-Google-Smtp-Source: ABdhPJyPzLV68TYMUFkc5rTf3Up5AWaC/c2m12TOkz81yPsQTjgABy8I+JN0xq0k8sxi4YUqPdBOTCmSB6GAzfwAsnk=
X-Received: by 2002:a92:9a82:: with SMTP id c2mr148434ill.285.1601506995603;
 Wed, 30 Sep 2020 16:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-2-bgardon@google.com>
 <20200930045508.GA29405@linux.intel.com>
In-Reply-To: <20200930045508.GA29405@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 16:03:04 -0700
Message-ID: <CANgfPd9uUFHK8q29YtfQPrtj1hAHWLZAf6SCeVp6YUeHR-z6FA@mail.gmail.com>
Subject: Re: [PATCH 01/22] kvm: mmu: Separate making SPTEs from set_spte
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 9:55 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 02:22:41PM -0700, Ben Gardon wrote:
> > +static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> > +                 unsigned int pte_access, int level,
> > +                 gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> > +                 bool can_unsync, bool host_writable)
> > +{
> > +     u64 spte = 0;
> > +     struct kvm_mmu_page *sp;
> > +     int ret = 0;
> > +
> > +     if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
> > +             return 0;
> > +
> > +     sp = sptep_to_sp(sptep);
> > +
> > +     spte = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
> > +                      can_unsync, host_writable, sp_ad_disabled(sp), &ret);
> > +     if (!spte)
> > +             return 0;
>
> This is an impossible condition.  Well, maybe it's theoretically possible
> if page track is active, with EPT exec-only support (shadow_present_mask is
> zero), and pfn==0.  But in that case, returning early is wrong.
>
> Rather than return the spte, what about returning 'ret', passing 'new_spte'
> as a u64 *, and dropping the bail early path?  That would also eliminate
> the minor wart of make_spte() relying on the caller to initialize 'ret'.

I agree that would make this much cleaner.

>
> > +
> > +     if (spte & PT_WRITABLE_MASK)
> > +             kvm_vcpu_mark_page_dirty(vcpu, gfn);
> > +
> >       if (mmu_spte_update(sptep, spte))
> >               ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
> >       return ret;
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >
