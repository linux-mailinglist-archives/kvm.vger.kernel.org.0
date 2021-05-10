Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F7379434
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhEJQj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbhEJQjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:39:07 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268E6C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:38:02 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z24so15392197ioj.7
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gZ7cDY5D7ED7oV3zufRsM/2xrQZyC5C3tmx4hUtNL90=;
        b=RjMaIpp5YIRqTnldyLdlV3fxRBx2tRhXYAgDzcbGJOa7RFPgiR4+I34uS2mWSTyhF3
         NRZg3TGeLwGW3bJZeucXGxLobGWJpKprli+RnTvfD1GxIij0PUNB0S8EP6dIvL9pwXZ3
         u1P4cBawO5UY/BdlfLpeECy0p7chC49SZcXfrwP4iIjJZpkPpRsDtAgSVmiPaP+b6Z7c
         eiBk6guFB+u2avFI9OkGHmy3daxI28f2LZTxJs4y1y3O4QBVGD7b5Xrd8usCfPoo4du5
         RCIAGcZRg9FKvkGv0q6Jz1DNC8KWcLTMHFaDQItWQ0yRwt3caqgR9SlRBBmJxo9YWEt2
         pjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gZ7cDY5D7ED7oV3zufRsM/2xrQZyC5C3tmx4hUtNL90=;
        b=hmv3Xen3QcQbdkjvVGetK0KV9jw039WHwpCt3KHpZ79vORzQ84kT2vJELQYzGhkwki
         jM6CXdM6DepawN8kK2RoMlebxHA3wmdO0WRah6F5GQQfwyEtAJW7Fw8G02dHRhr7nJsU
         Ro820coI+9Pi17zV2iOXHkNKI8GaHBXRRM0YvcJp77jczui2py4+1iRAF1llC4XNfBNw
         B65iiNgVSBHgf7ebEXKYHnO0V6D4xmOaPtQguWBX9PzotdnLHritsf7e7pd9ZUVWybhT
         KuH3Q7Vx9M9GK4aCjV/hQsEjIMYyyMLjuFNuyY/p7cqU/385/vGzMvk9behBt1gTVRFN
         Yngg==
X-Gm-Message-State: AOAM533thfI7sLmWXTb4/dCGnLDodU1eoaGJtjAcB5kH3ZV3hS+dDkZp
        NTbZ1Zewk0Njgg6/Gd2GAJSxWkE4IjaxKSBg21FmOMANFPQ=
X-Google-Smtp-Source: ABdhPJwvuScosFSOqHr0oFwxJKgaY1y/wslBGIeJJgGCiIWeFcVXzmPzZMqnqfIoJZgGxEiFv2vdMk5DFf4xhzpaMvU=
X-Received: by 2002:a6b:b2c8:: with SMTP id b191mr2257093iof.19.1620664681447;
 Mon, 10 May 2021 09:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com> <20210506184241.618958-6-bgardon@google.com>
 <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
 <a12eaa7e-f422-d8f4-e024-492aa038a398@redhat.com> <CANgfPd8BNtsSwujZnk9GAfP8Xmjy7B3yHdTOnh45wbmNU_yOQw@mail.gmail.com>
 <03e66630-b967-b91c-b74e-6944bdcaf2d7@redhat.com>
In-Reply-To: <03e66630-b967-b91c-b74e-6944bdcaf2d7@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 10 May 2021 09:37:51 -0700
Message-ID: <CANgfPd_uM+jXD=2m-EK-Vsz4UtB0hd-EFAA-m-y74fZf18rOpQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap allocation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 9:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/05/21 18:14, Ben Gardon wrote:
> >> Possibly stupid (or at least lazy) question: why can't it be a "normal"
> >> static inline function?
> > That was my initial approach (hence the leftover inline) but I got
> > some warnings about a forward declaration of struct kvm because
> > arch/x86/include/asm/kvm_host.h doesn't include virt/kvm/kvm_host.h.
> > Maybe there's a way to fix that, but I didn't want to mess with it.
> >
>
> Let's just use the field directly.

That works for me too. I moved to the wrapper because adding the
smp_load_acquire and a comment explaining why we were doing that
looked bloated and I thought it would be easier to document in one
place, but it's not that much bloat, and having the subtleties
documented directly in the function is probably clearer for readers
anyway.

>
> Paolo
>
