Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED77305CD3
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313708AbhAZWlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391379AbhAZRsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:48:11 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F7BC061756
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:47:31 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n2so35318257iom.7
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Jb9X0v8oDi5jLxmgmGC2E5NlSIbY7TNgKuxfpCf/uc=;
        b=OhJAMRhycmvWsvv9Di2tFzT/cyfx9Gh/4DIgaeknl37vIAYVpII2mnv98Di93RqHR9
         5gg8o7LU6qVUyDJ3eqZzRbEuk3EWoaAMjjrDTVPfc4BODlINgVG5eLjmpatxGUQmmEfZ
         bsw6ZVvhRTrqecIDI6k4tJ2vlM56DwErt7FOAIV5PSn2wk4K8ncccos2nqCOqUeV3uBp
         TjGm3xisSvoLxP0djDj0d3GwJmNrIBZq1v86uz8mMiW1e6nuTPukaWdMdeHFE1fR4D5b
         ev7/KbfWQVIF9TJ3I5YZ6ky9b6wd0Jmt4Kt6GMkTjtDnJKw6sCIBZmJub4nxoTTU3TYW
         5skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Jb9X0v8oDi5jLxmgmGC2E5NlSIbY7TNgKuxfpCf/uc=;
        b=SRd9wdI3AM1ZLRjnx9gzXpOJnihvnvipIRL2ATaQGfhykNVeJTTzl10VpsuQibBQrl
         XTU2ZF8IokKLLo3QM9Bsc62fQY8Papyp/rcoR0g8iAhi40DKhkSubJbh4UqOVl28ibSd
         i66NhKbP1lvFWjUAEGqihcm1q3bIsl0N7exGfWUkRaBdCmv048VvIs6S/6V1ITy35Bf0
         uK7/2SajUpUFXHTfVxHpPQKtic+r8+2irpzTHwGSTs77EXrYwlt9RvhIprwPYIqmjTzT
         q4MDwogn7CktmH0cY0KqRHMDVrFbi3blzgA34TTUSoqhBtqq1xfZNuos/jK2W/uic7BF
         2O6g==
X-Gm-Message-State: AOAM532xpP93Oh4+qYIrdIqoz4R/Tv3GN5Q8yEY1kG9vsnEpzrWZBmBG
        IxrWYmMhzm85LX4QTkLlCOP1K+g66cW//wtYeBiu1A==
X-Google-Smtp-Source: ABdhPJz8kAyEdI+ULZJUiM3kcZbSU41YHoWAd12KengC2L6zKHuBdKF5ZaD5DLVbsmvNJqSfung1Rsd+s83OM2Fkx2k=
X-Received: by 2002:a92:cbce:: with SMTP id s14mr450259ilq.306.1611683250954;
 Tue, 26 Jan 2021 09:47:30 -0800 (PST)
MIME-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com> <20210112181041.356734-16-bgardon@google.com>
 <YAjIddUuw/SZ+7ut@google.com> <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
In-Reply-To: <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 26 Jan 2021 09:47:19 -0800
Message-ID: <CANgfPd_WvXP=mOnxFR8BY=WnbR5Gn8RpK7aR_mOrdDiCh4VEeQ@mail.gmail.com>
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
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

On Tue, Jan 26, 2021 at 6:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/01/21 01:19, Sean Christopherson wrote:
> > What if we simply make the common mmu_lock a union? The rwlock_t is
> > probably a bit bigger, but that's a few bytes for an entire VM. And
> > maybe this would entice/inspire other architectures to move to a similar
> > MMU model.
>
> Looking more at this, there is a problem in that MMU notifier functions
> take the MMU lock.
>
> Yes, qrwlock the size is a bit larger than qspinlock.  However, the fast
> path of qrwlocks is small, and if the slow paths are tiny compared to
> the mmu_lock critical sections that are so big as to require
> cond_resched.  So I would consider just changing all architectures to an
> rwlock.

I like the idea of putting the MMU lock union directly in struct KVM
and will make that change in the next version of this series. In my
testing, I found that wholesale replacing the spin lock with an rwlock
had a noticeable negative performance impact on the legacy / shadow
MMU. Enough that it motivated me to implement this more complex union
scheme. While the difference was pronounced in the dirty log perf test
microbenchmark, it's an open question as to whether it would matter in
practice.

>
> Paolo
>
