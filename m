Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B613FF4C3
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhIBUTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhIBUTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:19:04 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1902C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 13:18:05 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f18so6951117lfk.12
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 13:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kzEtkuBtgfdvovJGx2vNeyWTM6t8k4a79v7QJawW9b8=;
        b=czGzwIMYk81Mo1UJ4KLBEMDUAJvz72+tHL59F2iqeJk960mlsaXhCo6R022M2B07In
         duNGe9KfQKyTsvzzYDEE/6gpDpJScLS3A22Ghj96PHMr8rHTCQBBGbl41GBkkuIH0/bC
         aIpH1wwpwOHtICD6ACln6eiZiMIz45skiZ40YUinZUOhCBApaFAZJOCiHd1r4WWJm/o1
         7QsFY/sTTBnpybIyL0Xz0VGaPF9lVWBtEoOwLm+P8CNil6/2RGI8w24dBMv7qFwq3jAM
         lz/+xaiQHFvLPsxv2B3l2NkKzpM66+Qt5K1VslIIIf23xOqBi9Y4kM+tJsi1OjA6+ES4
         +RLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kzEtkuBtgfdvovJGx2vNeyWTM6t8k4a79v7QJawW9b8=;
        b=AIaJZBrbGJrtNez1gthe7ZX7CNBWwY89yT+0vsdEGj/LJ9ywd0piAwEKcmcwctGO8a
         vJRrDu5a6rRvDCVeBiEaU9ZhZGqSmCVaum54bhMD0J4Qd0bJPJVWYIthecUsBGa1Jrwt
         arXPxY++erScNb2dkho/xJTYwDXdhXVfHDRfd4TaoHsuNg5acnMtUBFO9zjSMKTsCIHQ
         0ePPZu+7HJrCoTNXsFMzthfSDquPUvbvohN1hHX6xN7VhuB7SAldcPsc3vQ66/gosGhP
         sXqKxkWwBrKJEmd0aMZ3xJnznyEhZh0bf+gE8hT7mrhBu40Qk5Yqhe2t9AUcq9BNef2g
         Cc9g==
X-Gm-Message-State: AOAM531h592oTfSigQ/3uf/IYF3isZapOxP2y8O507lU+a+CQQbvAZ0I
        hDw8uqOB1sOuopELCDGZPpbimk5ZUdnfiEGcN7xfKg==
X-Google-Smtp-Source: ABdhPJzwP18p+J/0zyaKhKGt7l6t2j60BMaCA6xIyB2Wj57888oDOG4H3w28g6Q09+bAJl5bJu0e7lkzr6X+zUIG2KE=
X-Received: by 2002:ac2:43b6:: with SMTP id t22mr4052lfl.0.1630613883673; Thu,
 02 Sep 2021 13:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-2-rananta@google.com>
 <YS/vTVPi7Iam+ZXX@google.com> <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
In-Reply-To: <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 2 Sep 2021 13:17:49 -0700
Message-ID: <CAOQ_QsgQongwOuj2FCTB-iRsscMYV2myN5Czae2B_vmasMOvnA@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel support
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 1, 2021 at 3:43 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Wed, Sep 1, 2021 at 2:23 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> > > Define the readl() and writel() functions for the guests to
> > > access (4-byte) the MMIO region.
> > >
> > > The routines, and their dependents, are inspired from the kernel's
> > > arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
> > >  1 file changed, 44 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index c0273aefa63d..3cbaf5c1e26b 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
> > >       val;                                                              \
> > >  })
> > >
> > > -#define isb()        asm volatile("isb" : : : "memory")
> > > +#define isb()                asm volatile("isb" : : : "memory")
> >
> > Is this a stray diff?
> >
> Oh no, that's intentional. Just trying to align with others below.

You are of course right, I read the diff wrong and didn't think it was
correctly aligned.

Thanks,
Oliver
