Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0842D305C55
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313907AbhAZWtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbhAZVHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 16:07:54 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B1BC061574
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 13:07:14 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n2so36613196iom.7
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 13:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXltbeb08aCLv/IaAmMXa5/LJl/de149+mTZ0cnXywo=;
        b=DsTWBbWHcrIG9y6GeohkpNGVKY+cFZ1VjRR4+ukLSPPSSIvvVs1zd4QvHjD4UN0lWH
         nD4q16OAQLiKH9et9QRK4zu/uv1tLgOBIrBJfFub+OHPmmlnZmvSiWDdZawBPgNDpSIM
         TsLGIAideJ0EZE5LST9CPrMpOkrWtN2QkxcEqXTeREBTyrsSDZxz+847TOiGQWfds03b
         MY1+sDF/Jgaojxj1VxlNtoKcdLEoNdF80VSuwJ9aUBmq1aEhtLXUuAYHdmiTcWUxLc3M
         htpO1EYRPZz85zGWO1mQ2jYL9fsRPBLJXVtucvbSzlQocRqSApgRghjEtJkvca4rWSFM
         0Yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXltbeb08aCLv/IaAmMXa5/LJl/de149+mTZ0cnXywo=;
        b=Al5ezDPbWzlebVYl9gR+DqdQfHRGxNIbpM+RD0bV8z5ei5eLrQwkGtHeA8PlTg4N4R
         xLT0x69bEXG99pumKnAjebrEM9jsSNz/O2LZt5WD9jbB2KuyIbwnwqgmmYNKqyIxYHUb
         zMEUAr8o0VJInR2G929TR51eVHPMjVNfSxU9cL8HGOGHuSa8OPVjWKW9ZwR1i/c6sM/5
         gD8ZSSu/INQ0zYWFRYkXEdgdb7ot2t51ki5AvGha32dR9JwDJzc9dvkTID2+0WwXqwMl
         Z2/dnnIKobsD1AvPTVOx1FAomTsEzYt5dVjfU5XNgcXw4Q5iBh1wvVtUP5Dp9WN2jE/G
         BETQ==
X-Gm-Message-State: AOAM533ski2GxYK4VifnHDfpI2xOcnMFNGbH/pSYHEs70u/YUAmHsneI
        N2rfIvw8ErQ6O2MhXXdtL2oVUYUKZA43QpF7//sYng==
X-Google-Smtp-Source: ABdhPJzdqrymF1yVhInjyCzYnkPoM9IF6RHa4r+wjRngK3JafTpx6MY+C8nP6uxewMUQmitEdGAyvgQs1DUk4YUYgD8=
X-Received: by 2002:a92:cbce:: with SMTP id s14mr1159461ilq.306.1611695233297;
 Tue, 26 Jan 2021 13:07:13 -0800 (PST)
MIME-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com> <20210112181041.356734-20-bgardon@google.com>
 <14147680-740d-6e7f-e00d-aa7698fd2ba6@redhat.com>
In-Reply-To: <14147680-740d-6e7f-e00d-aa7698fd2ba6@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 26 Jan 2021 13:07:01 -0800
Message-ID: <CANgfPd9ok+QUxgp2E_adj+BGRhhrDoFoFndb7+fXiGBggXd2qg@mail.gmail.com>
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
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

On Tue, Jan 26, 2021 at 5:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/01/21 19:10, Ben Gardon wrote:
> > +      *  May be acquired under the MMU lock in read mode or non-overlapping
> > +      *  with the MMU lock.
> > +      */
> > +     spinlock_t tdp_mmu_pages_lock;
>
> Is this correct?  My understanding is that:
>
> - you can take tdp_mmu_pages_lock from a shared MMU lock critical section
>
> - you don't need to take tdp_mmu_pages_lock from an exclusive MMU lock
> critical section, because you can't be concurrent with a shared critical
> section
>
> - but then, you can't take tdp_mmu_pages_lock outside the MMU lock,
> because you could have
>
>     write_lock(mmu_lock)
>                                       spin_lock(tdp_mmu_pages_lock)
>     do tdp_mmu_pages_lock stuff  !!!  do tdp_mmu_pages_lock stuff
>     write_unlock(mmu_lock)
>                                       spin_unlock(tdp_mmu_pages_lock)
>

You're absolutely right, that would cause a problem. I'll amend the
comment to specify that the lock should only be held under the mmu
lock in read mode.

> Paolo
>
