Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D653DAA0A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhG2RYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhG2RYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:24:46 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E13C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:24:41 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f18so12388253lfu.10
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWUclsCNuoKzRHN0VVtJJdT/B8wW6gEtVuB7tyt8rLQ=;
        b=h49SkWwhYpGGEq0HAv2YJOkyCtnIxNxZboW8ndPd9G+k3fjW0fMRjdxDOJDRU757L8
         N6Q4ZWXMh03f4TyH8G43QlVHUE0jqig5r2iK6Kfs6EycfoqfOThKQWFsmIWjLMi2d7ML
         5EFjn6xctGpsWXUKsYGIk3KQr6+yw9IyK0hNxMEk8tpt6uH3kdg+zazOSHYrw8jovmq1
         rtN/6IDFLcxuDYYDJ/OnoVFt932gnYWZt7jGVHp0QxcDUD22/tAU6+yE7ggOf74SZc/0
         V7G6Yx5byQkoqN6EoI917XaWmvnti26/3YpCqjiX9Ky3EEd6ptVDHumyH1aXPXu8IiVL
         hUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWUclsCNuoKzRHN0VVtJJdT/B8wW6gEtVuB7tyt8rLQ=;
        b=ttqIVURMD5yi2237JUAlPmuoK7u7ME1tssoENC+EM0gNz72MP0n6EgFwxXGU16PG8D
         3v3I+dWR0Tg42j4uIJBq+2jdZesskPBJaTfSLI6ytt5O1cg14eIAT75Iw+bVGPQhRRyn
         6BSUyRPBPX5zE9nyX6p5OLM88keh42hFBEQundWWM1NXl7aDFHkhR97MsICGiBdEDkG/
         THI/ezvCzhFEc8GXmLoY1lwqGxdcLJBvoLD5sDzJlaP8wP3KBE4TWvibxx10x8pKKq04
         zjhIyLO+6w7SJNo6cn/1YheYlO0x1nwO1NNNiABgVAgd691stXBM5YwCvLdGE1SkImQZ
         j6tg==
X-Gm-Message-State: AOAM531fTClREYMamIOaMaK02RxKrvXgjWd349Cij+ZqwTSlPQo5SQqs
        bKUsummQEavjbyv1ZaFT6Hx1f4DJJGMH/Vi3fvrlPUnGiCY=
X-Google-Smtp-Source: ABdhPJwJL70ofECEVuWUT9zJxNjPniu49uTz5Ht01kB1ctgoxTVytaCkkJvJwj+hTICZp8j2nVdJyfNONqGO97OzU4w=
X-Received: by 2002:a05:6512:3ca5:: with SMTP id h37mr4714416lfv.46.1627579479513;
 Thu, 29 Jul 2021 10:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618914692.git.isaku.yamahata@intel.com>
 <YK65V++S2Kt1OLTu@google.com> <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
 <20210610220056.GA642297@private.email.ne.jp> <CALzav=d2m+HffSLu5e3gz0cYk=MZ2uc1a3K+vP8VRVvLRiwd9g@mail.gmail.com>
 <92ffcffb-74c1-1876-fe86-a47553a2aa5b@redhat.com>
In-Reply-To: <92ffcffb-74c1-1876-fe86-a47553a2aa5b@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 29 Jul 2021 10:24:13 -0700
Message-ID: <CALzav=eSrEGt9Xn99YtmHnWE1hm7ExZ4o_wjn_Rc0ZokLpizeQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/21 18:48, David Matlack wrote:
> > On Thu, Jun 10, 2021 at 3:05 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> >>
> >> Thanks for feedback. Let me respin it.
> >
> > Hi Isaku,
> >
> > I'm working on a series to plumb the memslot backing the faulting gfn
> > through the page fault handling stack to avoid redundant lookups. This
> > would be much cleaner to implement on top of your struct
> > kvm_page_fault series than the existing code.
> >
> > Are you still planning to send another version of this series? Or if
> > you have decided to drop it or go in a different direction?
>
> I can work on this and post updated patches next week.

Sounds good. For the record I'm also looking at adding an per-vCPU LRU
slot, which *may* obviate the need to pass around the slot. (Isaku's
series is still a nice cleanup regardless.)

>
> Paolo
>
