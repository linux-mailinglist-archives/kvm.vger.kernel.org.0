Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7F459851
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 00:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhKVXTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 18:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhKVXTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 18:19:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0CAC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:15:54 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so15452389plg.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nVnyNoswxokQnIp8Sl4QeAE/5l97hmGoQDaJg8lEee0=;
        b=bXgw2P3rx9AgGhvco+g9dtKPOB7N1sgFLBRZ7W3edCUECJx+PDePPq8cuzlWMJ6rZI
         swMuf5G8aL47MHZhOZYst8mSuOEDnvkY2zo6+Szi7BYfsbf8vElNhh/+xEH6W5xpZIiA
         h1/ZYEQut9aaEOJqjcVMof4F74Dalz4kxIkXJhDAdujK9SFaaFPo3JAzfGfgdtSAifA2
         ms1wlRPffyWoYe7E0H3aqanqnVDrIHkqNkt1Nom1uvvbmUoczfNiWmUJu/7hvBw2pifs
         40y2/epKg7LuppIdCZN1Nl+n3XHJufLKBC7rYLk4EKvupbyr2SlAA2cC6pl7lf52H+ql
         Dbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nVnyNoswxokQnIp8Sl4QeAE/5l97hmGoQDaJg8lEee0=;
        b=CCJvwwAuiczUrZt5j7YDKexF185z6+FcJoRq9SYvXo4kURJ50NOn1iVXlDiC52uwcE
         LcFmw5vBefbhGQjpZo+SxcEJScPmFQYZGh20mBulAhCtPDLZYa8Honz3/t+uAfGZQWsF
         P9JVzw8m1hnZaE3h+c6JgMGO9YDKpGtoKXkDUWfY/zMBjpS7S28PVuJRhS7G79hFbvTr
         l2c/7IbE5gJVozBJSDf3iWOoAWIkuAuj9QofodJx5LsstVF4nyjxmwnRGaz/8i7IpMgS
         e7VOGi8vdjffjTwL+oecqcyUHWwg2QjaD9FCa6E+jdp9VQ5vMYFyL9nTvBJv3Ig9Qor5
         u3vA==
X-Gm-Message-State: AOAM5301QVvhgGNgCs9Dx4Ifc7IenYcBQlPlRbO5ZIuuqA5ElWfjO8D9
        DajF5imYAf8ml6tPVvgiy9MvQA==
X-Google-Smtp-Source: ABdhPJwxp63OKH7j6ECzy3xy8yex+lgpwydbsFbhhnhddRB4GZaNKCxYwhknWNDlf5gNtR5pM1NWyw==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr732949pjb.142.1637622953702;
        Mon, 22 Nov 2021 15:15:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w8sm3892503pgf.60.2021.11.22.15.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 15:15:53 -0800 (PST)
Date:   Mon, 22 Nov 2021 23:15:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 21/28] KVM: x86/mmu: Add TDP MMU helper to zap a root
Message-ID: <YZwkpcmAi07fOgbz@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-22-seanjc@google.com>
 <CANgfPd83-1yT=p1bMTRiOqCBq_m5AZuuhzmmyKKau9ODML39oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd83-1yT=p1bMTRiOqCBq_m5AZuuhzmmyKKau9ODML39oA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Add a small wrapper to handle zapping a specific root.  For now, it's
> > little more than syntactic sugar, but in the future it will become a
> > unique flow with rules specific to zapping an unreachable root.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9449cb5baf0b..31fb622249e5 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -79,11 +79,18 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
> >         tdp_mmu_free_sp(sp);
> >  }
> >
> > +static bool tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +                            bool shared)
> > +{
> > +       return zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
> 
> Total aside:
> Remembering the order of these three boolean parameters through all
> these functions drives me nuts.
> It'd be really nice to put them into a neat, reusable struct that tracks:
> MMU lock mode (read / write / none)
> If yielding is okay
> If the TLBs are dirty and need to be flushed
> 
> I don't know when I'll have time to do that refactor, but it would
> make this code so much more sensible.

Heh, I did exactly that, then threw away the code when I realized that I could
break up zap_gfn_range() into three separate helpers and avoid control knob hell
(spoiler alert for later patches in this series).

There are still two booleans (to what ends up being tdp_mmu_zap_leafs()), but none
none of the call sites pass true/false for _both_ params, so the call sites end up
being quite readable.  At that point, using a struct ended up being a net negative,
e.g. kvm_tdp_mmu_unmap_gfn_range() had to marshall from one struct to another.
