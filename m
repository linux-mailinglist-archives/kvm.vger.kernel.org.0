Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166312A7B37
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 11:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgKEKBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 05:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKEKBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 05:01:06 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB56CC0613CF;
        Thu,  5 Nov 2020 02:01:04 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id r9so1188632ioo.7;
        Thu, 05 Nov 2020 02:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jS3AjLIwPCzBea4FOzHlbb/BUo9e06PlXidc5fhBDDE=;
        b=HlgXFWTj9dK17aJo0PyuS0+lAp810EmKbUjZngqXK7B2xZQiAE/UijxaVqVhazE160
         3Tgq5eXWEdMdOveC+WkWC2ZvAUDW8BPxEFK/WRJhS45sPRVOuXBnemAUQIXg8OJhlEpN
         3O3O1uB3oOPWRWFKxCBKRLz+kUNB2oK16sX8Xs5sA4dTMNi5F0XV0oVQx4YFWeAXkQxN
         +yb17klsF1hwclTZIOiae76fPHY7UqiLZff0Zw5WtMh7ItK5RBwlzRPWKPSD1Fc4fucc
         avjmNyLSrXbMr8bxy68iHH5HyXrgYXbEAsnATK4eaieEKL3sPfPs6OH6ImXpaBL5gL3u
         GFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jS3AjLIwPCzBea4FOzHlbb/BUo9e06PlXidc5fhBDDE=;
        b=Oeg4Aem11kDkpZZYPnSnu8DbkJA4JtcN0pLmXKd2EPe8zCP1+oMVm1YGortDSsiszi
         c9UjRQ3yn38euRpfGeWYFbLf4Y5u42WCIa8MHfMG8HFjDFtmaYND62vU+9lQYvwiOjUk
         IvALOYQIkxKQZTRMxFBM72BBhKlELc7UAWdWnGQUs8MmtuBsHOfeyj5SqEw5vhcniCGG
         wRP5zYOLWre0EBLfbRJ+ajgSwO4RNp2Q0DseSff9RUue55FjsuY9e3bt9iOL7zaewvBj
         4qxKaoKybDdKvOO/nfCQhcqomhr50bahKzb/IIFOmY6xnH0bQDBXEUdHNol+GU3kjWe0
         X6jg==
X-Gm-Message-State: AOAM530pRoQaAKzz0Wp5I9WqNjnqNqwR+E6S9SgI8/jC3MGbbkJxb2Je
        P9ObupryesyyJkSm75a4qvO3vKCFqtUq3IAYB+s=
X-Google-Smtp-Source: ABdhPJzSvl7of3rqEp/YfqAFs6gLVkZo+PSeZD8oOx7BK1breegFIDyLYuI2KMF4Uy/bqMtM7VnF2SBKI+05PxnbHpk=
X-Received: by 2002:a6b:9089:: with SMTP id s131mr1191374iod.36.1604570464223;
 Thu, 05 Nov 2020 02:01:04 -0800 (PST)
MIME-Version: 1.0
References: <20201101115523.115780-1-mlevitsk@redhat.com> <CAM9Jb+ivbM-_8ht9w2JptoHH-64=J_TvdLvm0Re+KAAuPeeGfg@mail.gmail.com>
 <e177d0497f08173e7991341796aa21c2dd2ba86b.camel@redhat.com>
In-Reply-To: <e177d0497f08173e7991341796aa21c2dd2ba86b.camel@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 5 Nov 2020 11:00:53 +0100
Message-ID: <CAM9Jb+gCoxFXh3oBnZhj8LJ6PoAy0wmQuKHR5p=sqGHyqsUe8A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: use positive error values for msr emulation
 that causes #GP
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > This looks good to me. This should solve "-EPERM" return by "__kvm_set_msr" .
> >
> > A question I have, In the case of "kvm_emulate_rdmsr()",  for "r" we
> > are injecting #GP.
> > Is there any possibility of this check to be hit and still result in #GP?
>
> When I wrote this patch series I assumed that msr reads usually don't have
> side effects so they shouldn't fail, and fixed only the msr write code path
> to deal with negative errors. Now that you put this in this light,
> I do think that you are right and I should have added code for both msr reads and writes
> especially to catch cases in which negative errors are returned by mistake
> like this one (my mistake in this case since my patch series was merged
> after the userspace msrs patch series).
>
> What do you think?
>
> I can prepare a separate patch for this, which should go to the next
> kernel version since this doesn't fix a regression.

Patch on the top should be okay. I think.

Thanks,
Pankaj
