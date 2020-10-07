Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6822865F2
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgJGRaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgJGRaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:30:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B81C061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 10:30:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so3238912ior.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQ3RmkMpjXxSLR81pkKdGt+TZH44v4hpamp0wM2Tbvs=;
        b=Se9nw5FgHFtKsm8GMYSImWv2wXIqCCOCv6pqlrWzBIvY0KyFKYLSgBJbdclE74rN0V
         L0OzzCyXjwmzqY5CvOwmW1s23GoVCPICapYUZFiSyQ3VzyBQJpfZ+6B7eKkncs8IsvXR
         slEUoHEbK3sqOXSRrw0ZRR2s39x9H1sNI4Ysl2tET0kOXOHkex1NPPywMNawv3w1f+sB
         c6lulPb33S1fRXiAC5OZMKjd4VOO5Q3jJ7RhTgSz7ELXfAEp8rJq7zc0JWvoRTDpcC0Q
         cTGuo3+wxAiYN9Cg6g/Jn6XY557RX4qkZ2GxwutbY+LCvSQ633tA4zpsHUJpBQTsLVbR
         lMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQ3RmkMpjXxSLR81pkKdGt+TZH44v4hpamp0wM2Tbvs=;
        b=AQcAlAGRwB2ypRGyoLsPW1NFBOw3qP+1GeNJazJpH68bK+LW8vwmHb+rLU9QO/TLQY
         HPSWOL+l4cLY0HhUQqch4GFeD2uSCYw8XiUgRyHohMAY6JPTVoPXePd0hsxbB+NuT/MJ
         Z4lg4xNjy9LjOYwaGPT67vinUu10G+yrjePkU7OwDI95xzwCmIC4Q7im5n5qh4gnN+vV
         cVDxmQUXTsF56gG5/K+y09j72wYrUFFeG6iCwhfgtMA9oTkNKzHC3AizY7B/+prI/nhA
         atmdMSmbPgO7FYWmPJMPxsDZ8ScOYWfClnazWDQExHacNpHvUdI518mzWYtCQDTqvIXY
         j86A==
X-Gm-Message-State: AOAM532tdkp6dogkvHalZa7F+reVOjZ92WDAg+RZStii6bKwcsPAgRaz
        /pRK2DXsrW1xe++hNEDqEC33Ur20cBo6Ki50g+TtUA==
X-Google-Smtp-Source: ABdhPJytlhBgnWm3jW2tGSy64WkRj5mYfdnZRMLgkPXFNiRl5vrEqOTNvUu8Lz/HHEZVJWadIix3VN17uQKF1IQZXao=
X-Received: by 2002:a6b:1646:: with SMTP id 67mr3090555iow.189.1602091821740;
 Wed, 07 Oct 2020 10:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-16-bgardon@google.com>
 <622ffc59-d914-c718-3f2f-952f714ac63c@redhat.com> <CANgfPd_8SpHkCd=NyBKtRFWKkczx4SMxPLRon-kx9Oc6P7b=Ew@mail.gmail.com>
 <7636707a-b622-90a3-e641-18662938f6dd@redhat.com>
In-Reply-To: <7636707a-b622-90a3-e641-18662938f6dd@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 7 Oct 2020 10:30:10 -0700
Message-ID: <CANgfPd_F_EurkfGquC79cEHa=4A2AMfnCAfMHPpAXa-6w4+bsg@mail.gmail.com>
Subject: Re: [PATCH 15/22] kvm: mmu: Support changed pte notifier in tdp MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

On Wed, Oct 7, 2020 at 10:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 07/10/20 18:53, Ben Gardon wrote:
> >> in addition to the previously-mentioned cleanup of always calling
> >> handle_changed_spte instead of special-casing calls to two of the
> >> three functions.  It would be a nice place to add the
> >> trace_kvm_mmu_set_spte tracepoint, too.
> > I'm not sure we can avoid special casing calls to the access tracking
> > and dirty logging handler functions. At least in the past that's
> > created bugs with things being marked dirty or accessed when they
> > shouldn't be. I'll revisit those assumptions. It would certainly be
> > nice to get rid of that complexity.
> >
> > I agree that putting the SPTE assignment and handler functions in a
> > helper function would clean up the code. I'll do that.
>
> Well that's not easy if you have to think of which functions have to be
> called.
>
> I'll take a closer look at the access tracking and dirty logging cases
> to try and understand what those bugs can be.  Apart from that I have my
> suggested changes and I can probably finish testing them and send them
> out tomorrow.

Awesome, thank you. I'll look forward to seeing them. Will you be
applying those changes to the tdp_mmu branch you created as well?

>
> Paolo
>
> > I got some
> > feedback on the RFC I sent last year which led me to open-code a lot
> > more, but I think this is still a good cleanup.
>
