Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F59232499
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgG2S1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2S13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 14:27:29 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5172DC061794
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 11:27:29 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s189so18328474iod.2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9e3mG+v7myF4LEXwRfh3GRKcoZXstqdGx+UgF30PeTk=;
        b=pEqPizQOCPoXxgVFJAMQlVBXQR/mU9S7abwBOtX/TTUmKj6GIAh7zjxsCGZoI78c2B
         abztUw38VUU6dlMbXR/H13fUIzfOnofDdyzyIPbE09ScBOtSGgCRaaSTmMYsyIag5kBn
         djcCRSiL/S2nPi8rIEESm9gRFwWH8vgdlA4TtQEIjeFYph5WbfvKkOJG/WiyZ8J4KKfp
         O+rLE+BIGCT0TcyohT+d7pfpMJJeYAbhXgpuJdO/eJDoaVcX8JrFmXxIdAp6q77ZYYyK
         ODM9GXhnmubLbbydE5pQyFlqsimvbLTI0o0ulRFsGtrTfEeItGHfI6mUaZDMs5RYn/1d
         DfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9e3mG+v7myF4LEXwRfh3GRKcoZXstqdGx+UgF30PeTk=;
        b=R7FwY2pgoy3uU9Mq3fUPGlnWltBlRbtn54MhFaIqOoIhI1xJlsDi251I3LoWUkasSM
         eCAV5EQ26tyiC6HZmxL7zX0NU0D67mC8UzWmfN/BZPD/dwkBBPVE8qi86gdIV5BVnyZW
         9W6QUvH1yUBVbw3C+uXsa7g6DR9PIqdn8zSCEgtzDQsn/RnUSGHBeWa81bYoDX97pNK7
         fodpU8B5tZSCjSKjNJHoMmSlLpy484fdfqrLtxA4Ch6ochAgMb+WF4jw0LC1F9zOYFIw
         lvJQPVEvh3WZHrqhy9yGnvjgWdl7HqNcWXzzc/T35DLHJrZrWBIyiH0xFi9q1RsfKmXC
         sZRA==
X-Gm-Message-State: AOAM5333SzhKCQpkcw51v2SzbMtChD/1uOgWBsaEjNewuZSGDCT1eUhf
        jRJl/CfBp5tCtaekt9wztaNn3uHmFY6N/Sbg20AheQ==
X-Google-Smtp-Source: ABdhPJy8Rk93wQKYTA78KmP19sPmrYvz6fCMGk9nxajFL0I+dSD9ntQRJ6q7G1dSmLx0JPVcxZef+wUD8X+WAEE22bE=
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr33069247iof.70.1596047248155;
 Wed, 29 Jul 2020 11:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200728004446.932-1-graf@amazon.com> <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com> <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
 <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com>
In-Reply-To: <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 11:27:16 -0700
Message-ID: <CALMp9eSxWDPcu2=K4NHbx_ZcYjA_jmnoD7gXbUp=cnEbiU0jLA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 2:06 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 28.07.20 19:13, Jim Mattson wrote:

> > This sounds similar to Peter Hornyack's RFC from 5 years ago:
> > https://www.mail-archive.com/kvm@vger.kernel.org/msg124448.html.
>
> Yeah, looks very similar. Do you know the history why it never got
> merged? I couldn't spot a non-RFC version of this on the ML.

I believe Peter got frustrated with all of the pushback he was
getting, and he moved on to other things. While Google still uses that
code, Aaron's new approach should give us equivalent functionality
without having to comment out the MSRs that kvm previously didn't know
about, and which we still want redirected to userspace.

> > It seems unlikely that userspace is going to know what to do with a
> > large number of MSRs. I suspect that a small enumerated list will
> > suffice. In fact, +Aaron Lewis is working on upstreaming a local
> > Google patch set that does just that.
>
> I tend to disagree on that sentiment. One of the motivations behind this
> patch is to populate invalid MSR accesses into user space, to move logic
> like "ignore_msrs"[1] into user space. This is not very useful for the
> cloud use case, but it does come in handy when you want to have VMs that
> can handle unimplemented MSRs in parallel to ones that do not.
>
> So whatever we implement, I would ideally want a mechanism at the end of
> the day that allows me to "trap the rest" into user space.

I do think "the rest" should be explicitly specified, so that
userspace doesn't get surprises when kvm evolves. Maybe this can be
done using the allow-list you refer to later, along with a specified
action for disallowed MSRs: (1) raise #GP, (2) ignore, or (3) exit to
userspace. This actually seems orthogonal to what Aaron is working on,
which is to request that specific MSR accesses exit to userspace. But,
at least the plumbing for {RD,WR}MSR completion when coming back from
userspace can be leveraged by both.
