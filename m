Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C390536DD53
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbhD1Qq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 12:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241162AbhD1Qqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 12:46:55 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B469AC0613ED
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:46:08 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id u21-20020a0568301195b02902a2119f7613so12036765otq.10
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DmiskXVVNt5ciuwEiKHO8o/4wceYpi0Zcrr9JiPcz+4=;
        b=tKlQZLtx45gwtX02vXG4am95yPgB8gzjVWGEGzkBK5rHSLQtuz5IZ04D40M7aqZ8UA
         SQrj2s883sseBmwH71ouOzMNI+nk8lJvYORtMOX1fHSPdSmTYM4FgiLNSmREZxAzSaR3
         MqJ+Vk3vjL9lIS0E0F6NJ0j9VzeXhtVyH+fTVmgE83MhD/Gb3dVdfpD84wFeBMAb2PWR
         AuJlum8cNObwRmHDfiuGAdA93msryBFu9PTQ1F8YBTwzkIBJh/Yf4Rh98+8ks4HQ7g6K
         6FiQfzCzyaDxawWQPgKOnVJLKo/6MvQ+R9VGPKwgB7hs4v5qkwXjiJJgkP2K9kczPgWP
         x2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DmiskXVVNt5ciuwEiKHO8o/4wceYpi0Zcrr9JiPcz+4=;
        b=bsfeCl6jYr6VDSEt7JBrtomRJiQwRZKzr0QOoKp3DVDrEulaaX7aN9ZRBJJ4OgSalI
         FmVXi/G1OXxWJG0HSeatDAqwRUWQ6QNuaTKNAZIy5E2exyMGZQ2foTUONXBX+VpoZuvY
         rj84fdGlmrfbcyIVFaAKkZ1y6e382Z6Ky+tXuKU1TXfDRaYglyCzDjddC+hIKPulmPwi
         fqgcUY3hFkBeew1EusaEJb3EWWMzikp4ooXC/FEyB3Z2Oo6+5WMlHeNWtSSnsk/QEhDQ
         3BchujJ+Y9t4bDhfPl/O9gx41ckD0Zo2tRnrPBNNmLCQ5cskgv8vxe/gh3RnL1myRnLl
         caqA==
X-Gm-Message-State: AOAM5314EH99f0vZ2My2tXYXddUaxuR8P9P1vvyye4YNeBdW2npiJw3O
        DYy+g12LXflth/zzbLjTfVOBawhdd45Qvo6LeWVmlA==
X-Google-Smtp-Source: ABdhPJxm9/4vsmoaNUh37g6GSvioejnyYo2lL7TUff8Bnx5tp58+g23lXhmGQX5QBlQ6T0GCLeWBILuDhGRYFHMfqSo=
X-Received: by 2002:a9d:7857:: with SMTP id c23mr15021583otm.208.1619628367968;
 Wed, 28 Apr 2021 09:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com> <20210427223635.2711774-7-bgardon@google.com>
 <1b598516-4478-4de2-4241-d4b517ec03fa@redhat.com>
In-Reply-To: <1b598516-4478-4de2-4241-d4b517ec03fa@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Apr 2021 09:45:56 -0700
Message-ID: <CANgfPd_o+UA4ry7Kpw3WbcPZYm32r+1o=hQmZdazsrZvO4aynA@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: x86/mmu: Lazily allocate memslot rmaps
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
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

On Wed, Apr 28, 2021 at 3:04 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/04/21 00:36, Ben Gardon wrote:
> > -static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> > +static int kvm_alloc_memslot_metadata(struct kvm *kvm,
> > +                                   struct kvm_memory_slot *slot,
> >                                     unsigned long npages)
> >   {
> >       int i;
> > @@ -10892,7 +10950,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >        */
> >       memset(&slot->arch, 0, sizeof(slot->arch));
> >
> > -     r = alloc_memslot_rmap(slot, npages);
> > +     r = alloc_memslot_rmap(kvm, slot, npages);
> >       if (r)
> >               return r;
> >
>
> I wonder why you need alloc_memslot_rmap at all here in
> kvm_alloc_memslot_metadata, or alternatively why you need to do it in
> kvm_arch_assign_memslots.  It seems like only one of those would be
> necessary.

Oh, that's a good point. We need it in kvm_arch_assign_memslots
because of the race I identified in the thread for patch 5 of this
series, but we could remove it from kvm_alloc_memslot_metadata with
this patch.

Of course, it would be much nicer if we could just keep it in
kvm_alloc_memslot_metadata and find some other way to stop memslots
without rmaps from being inappropriately installed, if anyone has a
simpler way to accomplish that.

>
> Paolo
>
