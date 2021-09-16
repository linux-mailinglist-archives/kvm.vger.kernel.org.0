Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA0C40E98A
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244588AbhIPSIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351742AbhIPSGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:06:47 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC69C0470C6
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:37:43 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b15so2408096lfe.7
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOxWGGtlVyMbTfM6G8xYYhVEDVm9+qZYl+Ir+68DI1g=;
        b=CvP9yFxBTeLCLVZHXSfn173BZRnImSYw14KkDWmrlEOJweA+Gt2eojGTK8akjYK0av
         xD1LvC9YhRkI3htAaJ7IQORSnMm2Xe5JcQziXaU2LHF4+c3Ns1kwOWMdWqqVGCdg7OT/
         vYRAKHlgSWuKi2P8z4KHUpSgh+rwB2ElS7m2OPmal966NxYLqxd1oucwR85OjKCm/5Na
         BVLSlHp2wTOz0VO1uNQeI9PpggRXUOJTQT4qrYawxDTBJ3iE2kCYaHHuaF+og80tvnCG
         eBkXP4Q60YB437AdcKupHhcRv/jPhh1DRboaIP7tJFvccMKPTfGxHJNy/Eqcoh9ySm6D
         uSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOxWGGtlVyMbTfM6G8xYYhVEDVm9+qZYl+Ir+68DI1g=;
        b=0UXqXrxs2lF+JrgRt+8rVKAC7mD0xz6B4mREeimuW65TwoppDcb4dcsSjjxtteTFtW
         vDzdvpORPGxibP6dAUuPnN/HLePvJKcuwiqqw9wDeWY9ZwJmt1aagIOkVUgJjpSPjKVb
         i/F6bIOEbwM03npJLsuQXYdJqmxZG9xeBWGt5M+IYOP/0RivFpASJNbm1oi2Nl4GFsFO
         FGg7zjw7Gidd4Wj+nGBlj4+RixNEBx7z9HuFR7YlrMviwrulQilZc6CNtLfqPnWa8LVN
         PpQJC/Fvo0f3O7Gaq2b4X+wDCKeFvXyyBE48tCdfwY8STETASiKq0+Jh1F9jcrVPsTq2
         jtJg==
X-Gm-Message-State: AOAM532gFosZI3gWRfsU6bze765ktvCPkY8sqwY3qARTUcVkU6I2dh6J
        CZiC/FUbNiNrrpiYsDYCe0l9sr4A0vP3MK4OmSUk43BOsjn3ig==
X-Google-Smtp-Source: ABdhPJwl2ywCE1UvQngIBRBCw46zueBmLpowrcOLd9UhT8UEqM8jm6iUmC070E0uvbIvo9u2/IjxNlhRY9yqj+dRA1M=
X-Received: by 2002:a2e:e1a:: with SMTP id 26mr1334623ljo.331.1631810261466;
 Thu, 16 Sep 2021 09:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com> <20210915213034.1613552-4-dmatlack@google.com>
 <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com> <20210916084922.x33twpy74auxojrk@gator.home>
In-Reply-To: <20210916084922.x33twpy74auxojrk@gator.home>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 16 Sep 2021 09:37:15 -0700
Message-ID: <CALzav=cNk_bJDiBwjgQU+vJ8YGMM2ZSxuE0Hq0DnBi-n5aLD=Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
To:     Andrew Jones <drjones@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 1:49 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 15, 2021 at 02:55:03PM -0700, Ben Gardon wrote:
> > On Wed, Sep 15, 2021 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > The calculation to get the per-slot dirty bitmap was incorrect leading
> > > to a buffer overrun. Fix it by dividing the number of pages by
> > > BITS_PER_LONG, since each element of the bitmap is a long and there is
> > > one bit per page.
> > >
> > > Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > I was a little confused initially because we're allocating only one
> > dirty bitmap in userspace even when we have multiple slots, but that's
> > not a problem.
>
> It's also confusing to me. Wouldn't it be better to create a bitmap per
> slot? I think the new constraint that host mem must be a multiple of 64
> is unfortunate.

I don't think think the multiple-of-64 (256K) constraint will matter
much in practice. But it wouldn't be very complicated to switch to a
bitmap per slot, and would prevent further confusion.

I'll switch it over in v2.

>
> Thanks,
> drew
>
