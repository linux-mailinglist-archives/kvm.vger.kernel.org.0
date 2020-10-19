Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC65D293089
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 23:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbgJSVdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 17:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733109AbgJSVdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 17:33:18 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B24C0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 14:33:18 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k21so1618701ioa.9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mdj1p7VnDdxT5I8Z1qkpE2oOywsVCZLla3gZhFHy3jU=;
        b=XPF+oDHHW//dsEqICCHUU8aasr8/d2Izf+Yl0wnGj2ZbdcqIvMKiDRfEacCkjCl+dm
         +x6DymxUcfHs3jkBOwABRrjUj4K1FN/mWgsQQ9sEfOR2gfJE2hdtZ4d5gfTXXsoQW9en
         sp10cV9D9NqdeVnJv9YnZm2xT4kkNUFHqvuKUq9Fj93qqPb5XmQsqEUo7Oy3MSix6q3I
         U7X1VpJ1u74ns8HrjDZYIX9ruOvzhILiqP6iYwYqgUVqZGiDyeUQqdgO1o5Af57vqJY8
         u2mftXJD+Hb5S3VfhiZF2K6A+xpzfQiUeQN0S1VoLIWyFtPpXy1cIqb6FvVtg04zFMkH
         P++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mdj1p7VnDdxT5I8Z1qkpE2oOywsVCZLla3gZhFHy3jU=;
        b=Ic0QByfXq/KwWGUvNeh1KRlNAXzwtl7qE7DGE0yRQnSkgnxv3HyLZ2FmmBzhn8GrtM
         FBuZkSLBe5nyiG5ReI+5G3r+rE5gY74nGQsTw3gn20dbGleBuRby9Qhr6iRvD3vKLAE4
         ACNVqGGYYhAU3+hgS8mRqLrnApKeZ0wpi0MGxTlzobL7/EkoRp8hexJZEcFwvQpOQvht
         tV8pPGqDf8vDOZju6zpIA4eMw4QsRi+iuW1AhMYRDNfozwcoMOk261MLfa72fJW8fMbf
         p25l5jv1BU8WTRYc3rM7Iemue88IkeMoOjpwwFmIFbrnE6P4CEoWGdbst6H8TAhuOnny
         Yw/w==
X-Gm-Message-State: AOAM53147XCVNDmFgiN3R8HRmn9DDzS6d88+aTGKfWL/rWBNNVEonnv9
        zCBv7uHfAlhO1HcLl5Jv+ATfTTwRqa4k1BaWTqwYbjwvKxn4J5gg
X-Google-Smtp-Source: ABdhPJyIUjmTQziMIJfx7ZRZrfuRE3wJaNY0JSJ+oedy9d8Dxf9Vou6fV3TtI4Va94wdQ7my2Wl19KK18/SEvUH8Uzw=
X-Received: by 2002:a02:7817:: with SMTP id p23mr1644891jac.57.1603143197455;
 Mon, 19 Oct 2020 14:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com> <20201014182700.2888246-8-bgardon@google.com>
 <e13ab415da6376dfd7337052d5876a42f4c0a11e.camel@intel.com>
In-Reply-To: <e13ab415da6376dfd7337052d5876a42f4c0a11e.camel@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Oct 2020 14:33:06 -0700
Message-ID: <CANgfPd8Nudf2U8N4AY0=wT6TX8qFf3DsLbV1yjrVBBxPHSSUww@mail.gmail.com>
Subject: Re: [PATCH v2 07/20] kvm: x86/mmu: Support zapping SPTEs in the TDP MMU
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "yulei.kernel@gmail.com" <yulei.kernel@gmail.com>,
        "pshier@google.com" <pshier@google.com>,
        "pfeiner@google.com" <pfeiner@google.com>,
        "cannonmatthews@google.com" <cannonmatthews@google.com>,
        "xiaoguangrong.eric@gmail.com" <xiaoguangrong.eric@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "junaids@google.com" <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 19, 2020 at 1:50 PM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Wed, 2020-10-14 at 11:26 -0700, Ben Gardon wrote:
> > @@ -5827,6 +5831,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t
> > gfn_start, gfn_t gfn_end)
> >         struct kvm_memslots *slots;
> >         struct kvm_memory_slot *memslot;
> >         int i;
> > +       bool flush;
> >
> >         spin_lock(&kvm->mmu_lock);
> >         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > @@ -5846,6 +5851,12 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t
> > gfn_start, gfn_t gfn_end)
> >                 }
> >         }
> >
> > +       if (kvm->arch.tdp_mmu_enabled) {
> > +               flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start,
> > gfn_end);
> > +               if (flush)
> > +                       kvm_flush_remote_tlbs(kvm);
> > +       }
> > +
> >         spin_unlock(&kvm->mmu_lock);
> >  }
>
> Hi,
>
> I'm just going through this looking at how I might integrate some other
> MMU changes I had been working on. But as long as I am, I'll toss out
> an extremely small comment that the "flush" bool seems unnecessary.

I agree this could easily be replaced with:
if (kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end))
        kvm_flush_remote_tlbs(kvm);

I like the flush variable just because I think it gives a little more
explanation to the code, but I agree both are perfectly good.

>
> I'm also wondering a bit about this function in general. It seems that
> this change adds an extra flush in the nested case, but this operation
> already flushed for each memslot in order to facilitate the spin break.
> If slot_handle_level_range() took some extra parameters it could maybe
> be avoided. Not sure if it's worth it.

I agree, there's a lot of room for optimization here to reduce the
number of TLB flushes. In this series I have not been too concerned
about optimizing performance. I wanted it to be easy to review and to
minimize the number of bugs in the code.

Future patch series will optimize the TDP MMU and make it actually
performant. Two specific changes I have planned to reduce the number
of TLB flushes are 1.) a deferred TLB flush scheme using the existing
vm-global tlbs_dirty count and 2.) a system for skipping the "legacy
MMU" handlers for various operations if the TDP MMU is enabled and the
"legacy MMU" has not been used on that VM. I believe both of these are
present in the original RFC I sent out a year ago if you're
interested. I'll CC you on those future optimizations.

>
> Rick
