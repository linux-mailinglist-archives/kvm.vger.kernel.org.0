Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B9F3680F1
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhDVM6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhDVM6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 08:58:12 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D76C06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 05:57:37 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso31397233oto.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 05:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ezbyxMjnS0Pt5pud/YOTbNzuU2n/uOfALXyv+OqY+Cg=;
        b=QWoDLpbG0g3l15+ErJfKLfHrqQWMpUi68R59ObgOvHw0PZMrQvVtnhpx2bOnvEzW8x
         dO5GdELVimIeYJU6NWWmfzP5awg40i1suNbJ4hHTu6w3fAu/x5mGfKGjGvjgdeUlzIEB
         HH8Fqyw2YQFx9QFte+Xu0UXkWxepA3pJHaHL/sm1uc04YT5mZCU+88hb9XTowobPIxdl
         qd4A6oI2lt87vNuqX5LWM3A16lj7v8YqBQ07qzo65FkGPUw8rF5VKlUrWt4MC3XmtTdx
         PAhXO2GwjvRAW09OR8RzQ/es3yGfUhInY8wpp5lAJG8nXNKR+FJ1CcMf2Q0aHrvdebHY
         OmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ezbyxMjnS0Pt5pud/YOTbNzuU2n/uOfALXyv+OqY+Cg=;
        b=YrDckCPX5Qbi3okOVyivReWkOeaVZKEf5BpJTLa3ZJbJgUG64+Aip0rZDaHfbnKlUx
         ZUOuzrZunkGiwe/TNGMYpajEHZhyVbtfgljpVCfR5zWgNEspqtSaR56CtNjP/WEbqMpd
         HdWz3e0bauxmfE/kQ6QeG5h4W+bfs59GP2wkVQ3hIa+QpowrnuSHfMQ/To/bCshA0/ny
         67P2q9YOPdnEnRF0rJ687PMXtsBwLNKkkM82ULE0+xqQynBRgKABPzmfyeip5tTRf8lY
         tC3ynySBEyU9abmk55uju9mKiyUeBupgyn36uSqrO1X2Ns9+pYA/c2qLBmmOKNSeSoXX
         30FA==
X-Gm-Message-State: AOAM530OtC2fNgw699DUeI/XC8r9y7dJz9cIxIAQq4QaKjStyv2F6JOL
        Y1cEmfAJIHRcM0PnRk1WZ2nqQLAIJ/uT1kw49JCEc+BBDX18Cw==
X-Google-Smtp-Source: ABdhPJyLyRP0HUEZtq0HRs9deoqaBhrkVAg4FEQxqZsh0gC8bcrBw1vt+/mZUAmXRavK8Wuz29ham5RM3bTDPpwm//k=
X-Received: by 2002:a9d:342:: with SMTP id 60mr2688981otv.295.1619096255346;
 Thu, 22 Apr 2021 05:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
In-Reply-To: <20210421122833.3881993-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 22 Apr 2021 12:57:24 +0000
Message-ID: <CALMp9eSu9k57KvGCO6aDEFgkV-Vxrnr1j7CbiLYbtKYG1uwMZQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 5:28 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

The instruction bytes are a good start, but in many cases, they aren't
sufficient context to decode the next instruction. Should we eagerly
provide that information in this exit, or should we just let userspace
gather it via subsequent ioctls if necessary?
