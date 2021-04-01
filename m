Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE06F351789
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhDARmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbhDARhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:37:18 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E409AC031156
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:48:48 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id w2so2538314ilj.12
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LX7TTVacyu/SInUXeH7qzWi/YSD8f9C42RXcS3AUsk4=;
        b=nH/i/l/EVo2o/yF2p0uLVlOODn7z8Rqx1FgfFLqMWiil3e0T3lr2aezMDzwUkQagKW
         3zQ/tntQwYxMxrEelRBFoVLKpQSRZk/TBG1Z0AA8XM2z9AEhdnGWm+f+a2J5gpmjvsAt
         bFlAkTNprn1amjpUp3Laa/KRjz6cXbfTA0rGEvZNYujs6sUrA+DrqyICL9LQrpQ1O6A9
         ZaWO1pC69zpk3AOVocFivGbzVryLEDNC75A5EfuFRoWjq2BSgIaTZ674ah3Y3IlUbuKS
         fzfYibYEmW8JteKRBr9BkcEYEnZvVToDiMDs2wVb5vKZ2JpU+b9pNUx4e4NQZp7Wr58p
         c1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LX7TTVacyu/SInUXeH7qzWi/YSD8f9C42RXcS3AUsk4=;
        b=jL8P1WoBHnPss3kaNPB6cqf/j5q3xAWSn5HOSzlt5vaIba/Lgox+cgofBGmwMdheBE
         B1QsRbTa4B5d7EkcMVeZU7C7ViNZQjolXSeAmkZu/fUAixoTYC8fWOfu31clgoSde5el
         z4j+HQqnE7oxqziNNSX7Yt09AKivmo2ehuZwTXyIN4K33OZsidIm9nteDy/Lcp4dc129
         ek646hCXw4AXCYci1gWTKNLHJLX4KAu2bolxWaPXTPwd+y0qGJLS+QuKTuRF2oCwqA/8
         uJxAw2ZpvgsrSMGPZMBL9kNAQmiebRaQxWK9vlB/oEw4m9JiNkoe6s8G0nJhZOLyVOSZ
         ZGZA==
X-Gm-Message-State: AOAM5317g0jfQscnunF/HZTd8ByZCy88sJJLeBpcEOVPWz2IgrkI+ds2
        ILVKIn2jXhvWQxgzR0Fp8nQUWukw5XLKcORu4/ICcA==
X-Google-Smtp-Source: ABdhPJxn4MslQACG762qQXLuE+98Zx9vDaVa6WzFSlWG7o0gS55sNNFPnobyOdw0Pixw5xfJwCRy9GEAafIbY9N5JkY=
X-Received: by 2002:a92:7f03:: with SMTP id a3mr7335685ild.203.1617295728089;
 Thu, 01 Apr 2021 09:48:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com> <20210331210841.3996155-9-bgardon@google.com>
 <a030f6a6-4092-7c70-af4e-148debb801cc@redhat.com>
In-Reply-To: <a030f6a6-4092-7c70-af4e-148debb801cc@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Apr 2021 09:48:37 -0700
Message-ID: <CANgfPd87mz5Gqod6iRsqbdbUKxhETTrMp1R6ZqSerjvB0+mO8w@mail.gmail.com>
Subject: Re: [PATCH 08/13] KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
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

On Thu, Apr 1, 2021 at 2:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/03/21 23:08, Ben Gardon wrote:
> > Protect the contents of the TDP MMU roots list with RCU in preparation
> > for a future patch which will allow the iterator macro to be used under
> > the MMU lock in read mode.
> >
> > Signed-off-by: Ben Gardon<bgardon@google.com>
> > ---
> >   arch/x86/kvm/mmu/tdp_mmu.c | 64 +++++++++++++++++++++-----------------
> >   1 file changed, 36 insertions(+), 28 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > +     spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > +     list_del_rcu(&root->link);
> > +     spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>
>
> Please update the comment above tdp_mmu_pages_lock in
> arch/x86/include/asm/kvm_host.h as well.

Ah yes, thank you for catching that. Will do.

>
> >  /* Only safe under the MMU lock in write mode, without yielding. */
> >  #define for_each_tdp_mmu_root(_kvm, _root)                           \
> > -     list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
> > +     list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link, \
> > +                             lockdep_is_held_write(&kvm->mmu_lock))
>
> This should also add "... ||
> lockdep_is_help(&kvm->arch.tdp_mmu_pages_lock)", if only for
> documentation purposes.

Good idea. I hope we never have a function try to protect its loop
over the roots with that lock, but it would be correct.

>
> Paolo
>
