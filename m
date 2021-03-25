Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD99349C36
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 23:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCYWZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 18:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhCYWZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 18:25:48 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4F4C06175F
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 15:25:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f10so3228921pgl.9
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 15:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jY0knDZjnojlbafB0upbDkUdeKYN5wYj26P3am1iUyk=;
        b=r9xjktG4YPA6dDf29ov2vc1r2E6U+UaynVBV3rxT2VcXWavHuciLHcVWH/I9GPXzSo
         3JbwuZfoZJs79w2yi9jf/cgfgEfVzMn1Kv3b3L3st1WFmZOADSrOt8rLXzVxmjts9IhV
         Das/XI9L7nWi9RHMc67Q9KbAtygwrhOKVHGrR2kIoCouxg/0PJNDYfizowJ1qgwidTZ7
         2tg4PHRFzvrluIk+/Ygj/ITN0S94nSkGFUzZ/1dUzKW25/JNJqu9kZc2q+aPAKJaIgnO
         4jj0TYs3GYCTZzvDKxxrss6cuSLgvbGfSwyfaahZ3obLBXWNwU+7mDABX/ac8lhPAcN5
         CAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jY0knDZjnojlbafB0upbDkUdeKYN5wYj26P3am1iUyk=;
        b=hTfI8JO6GAo3qCI8FptsqG8E1cIYCjPBqcMfp7INHsjtt1/Av6QgGYy/9AHCA9gQtE
         SpvePWnn9IOh6fCarIwLEPgNV5+WgFXl4fHT7D4/pfZ+lPY1Y+wEVvUkYqSQ6/kPuQAE
         sZCBVdqeaOl7qwzuD6wh756zSQuGXJUeCVmFceJZIJ6/J7SWx9SzbahTvkAPMhaPMzgw
         ojI/1/wj1/Pg+wVCgG5BWdjttTILhH2nop6tMLtNSBtGMnwEQ1XZemnzgUVGanLzdIYC
         glZSjZZZ6Zw1LOs8NuGblBodip0hxZHkf4tT73hwq6T2rkOYXiqYA/sruRwljWNzsVJh
         cbrw==
X-Gm-Message-State: AOAM530OO06gbFI/Wcn44i3mWzTJ8y78KALfs+zHdaN8KBlhba3P/n+u
        4Qkkfmck1+qwMhDOx1rJXP05gw==
X-Google-Smtp-Source: ABdhPJz5CB0vBr5vmkLK7if+tNGcbYQ+rIZTAsv+ro7Y/zNFCyracNYiLREaxdaYuWUzkJhZiOK2ng==
X-Received: by 2002:a17:902:d486:b029:e6:f007:706 with SMTP id c6-20020a170902d486b02900e6f0070706mr12103207plg.83.1616711148104;
        Thu, 25 Mar 2021 15:25:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y24sm6759544pfn.213.2021.03.25.15.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 15:25:47 -0700 (PDT)
Date:   Thu, 25 Mar 2021 22:25:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
Message-ID: <YF0N5/qsmsNHQeVy@google.com>
References: <20210325200119.1359384-1-seanjc@google.com>
 <20210325200119.1359384-4-seanjc@google.com>
 <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021, Ben Gardon wrote:
> On Thu, Mar 25, 2021 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > +static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
> > +                                            gfn_t end)
> > +{
> > +       return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
> > +}
> > +static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> 
> I'm a little leary of adding an interface which takes a non-root
> struct kvm_mmu_page as an argument to the TDP MMU.
> In the TDP MMU, the struct kvm_mmu_pages are protected rather subtly.
> I agree this is safe because we hold the MMU lock in write mode here,
> but if we ever wanted to convert to holding it in read mode things
> could get complicated fast.
> Maybe this is more of a concern if the function started to be used
> elsewhere since NX recovery is already so dependent on the write lock.

Agreed.  Even writing the comment below felt a bit awkward when thinking about
additional users holding mmu_lock for read.  Actually, I should remove that
specific blurb since zapping currently requires holding mmu_lock for write.

> Ideally though, NX reclaim could use MMU read lock +
> tdp_mmu_pages_lock to protect the list and do reclaim in parallel with
> everything else.

Yar, processing all legacy MMU pages, and then all TDP MMU pages to avoid some
of these dependencies crossed my mind.  But, it's hard to justify effectively
walking the list twice.  And maintaining two lists might lead to balancing
issues, e.g. the legacy MMU and thus nested VMs get zapped more often than the
TDP MMU, or vice versa.

> The nice thing about drawing the TDP MMU interface in terms of GFNs
> and address space IDs instead of SPs is that it doesn't put
> constraints on the implementation of the TDP MMU because those GFNs
> are always going to be valid / don't require any shared memory.
> This is kind of innocuous because it's immediately converted into that
> gfn interface, so I don't know how much it really matters.
> 
> In any case this change looks correct and I don't want to hold up
> progress with bikeshedding.
> WDYT?

I think we're kind of hosed either way.  Either we add a helper in the TDP MMU
that takes a SP, or we bleed a lot of information about the details of TDP MMU
into the common MMU.  E.g. the function could be open-coded verbatim, but the
whole comment below, and the motivation for not feeding in flush is very
dependent on the internal details of TDP MMU.

I don't have a super strong preference.  One thought would be to assert that
mmu_lock is held for write, and then it largely come future person's problem :-)

> > +{
> > +       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> > +
> > +       /*
> > +        * Don't allow yielding, as the caller may have a flush pending.  Note,
> > +        * if mmu_lock is held for write, zapping will never yield in this case,
> > +        * but explicitly disallow it for safety.  The TDP MMU does not yield
> > +        * until it has made forward progress (steps sideways), and when zapping
> > +        * a single shadow page that it's guaranteed to see (thus the mmu_lock
> > +        * requirement), its "step sideways" will always step beyond the bounds
> > +        * of the shadow page's gfn range and stop iterating before yielding.
> > +        */
> > +       return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
> > +}
> >  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> >
> >  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > --
> > 2.31.0.291.g576ba9dcdaf-goog
> >
