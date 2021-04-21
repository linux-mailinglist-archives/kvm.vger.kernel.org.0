Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D10367303
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbhDUTCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbhDUTCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 15:02:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10E4C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 12:01:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id bx20so49445823edb.12
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 12:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYtDTDh2hHBav8aZMtlsDg0KEXUGVlP5wBa8PxRXFQI=;
        b=WiHF9rNta7/mes4IcpwtDsNmUR3+rt/yHUpaQEUCrZoz8t1lshuysZxMv9HlW79EhR
         Kqd1Hq2R8kIgLl5ThOngnWvNtW+o1gbuLa+6dFaaygvkk33yVTzLrZqLCyMN46gwsrQG
         SkJ1JpMR2n0jYq/fbgo+cQ1uXr9oEPSt7iKTmlxxPW/TFmiXgXesM9kdkABMcLvqj81U
         v4kIpMrkZx5sxUd53S1h1ORd/c3tvHPdncQ2WT0Ab4yEJUa7NzLVGhN3kixTSnJffl9m
         1Z+KobLDSBzQ4jW9zwOLQ88V0mVgTQdahgZXQuJUYbnFjqvltb/O6rGltKMuiSvU6mhi
         4x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYtDTDh2hHBav8aZMtlsDg0KEXUGVlP5wBa8PxRXFQI=;
        b=FZL+x7lwwBqgzHqI9ClsEd+WdAz9vxcWZ090G/vt7WSolSe+wMMDq+sCvo0m3KcjmH
         moLQqc9ZrQXjU9NsKBBOJts9Q0SNt+NdsGuhekdS/DQL7T3/v13MGjmPNjr4qjS0wJtI
         NBSyG153XGoUD86Yti3n4ps0hGdXJYAWhl/K9UrZ82zFS/Xc1ezzHdfXFesYlwLCglEG
         +99Dct/2t9BS6vYWN10OmGzj3n8Z5ewmecN9Ju+CUa735inRX6lbTf8ouoTPju15bkAg
         1//TqZGtoAQ3RHYX7szcZSvcPh78D6WPitfwWZ+MHw2/Egte/RGk3fdKT07ri9p0AQ/m
         dP0g==
X-Gm-Message-State: AOAM5306yRx7unmbPGPwSbrbzomUpLyot1vEkTW6e6Xw7IG4wF3VnpyM
        WqBm0gxkSesu+ZnH0hnL8zR6D3E4UroSJMzImzu9xZEuuww=
X-Google-Smtp-Source: ABdhPJwr/zw32zWbsLj/kOpSqMGC0Riyn+q2spo0INpySGYULeswrAkotC9UyKeDEYQRLK46ELs83OPdAdexTHa72u8=
X-Received: by 2002:aa7:d3da:: with SMTP id o26mr40610308edr.147.1619031692497;
 Wed, 21 Apr 2021 12:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org> <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
In-Reply-To: <cunmttrftrh.fsf@dme.org>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 21 Apr 2021 12:01:21 -0700
Message-ID: <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >
> > I don't think this is a problem because the instruction bytes stream
> > has irrelevant bytes in it anyway.  In the test attached I verify that
> > it receives an flds instruction in userspace that was emulated in the
> > guest.  In the stream that comes through insn_size is set to 15 and
> > the instruction is only 2 bytes long, so the stream has irrelevant
> > bytes in it as far as this instruction is concerned.
>
> As an experiment I added[1] reporting of the exit reason using flag 2. On
> emulation failure (without the instruction bytes flag enabled), one run
> of QEMU reported:
>
> > KVM internal error. Suberror: 1
> > extra data[0]: 2
> > extra data[1]: 4
> > extra data[2]: 0
> > extra data[3]: 31
> > emulation failure
>
> data[1] and data[2] are not indicated as valid, but it seems unfortunate
> that I got (not really random) garbage there.
>
> Admittedly, with only your patches applied ndata will never skip past
> any bytes, as there is only one flag. As soon as I add another, is it my
> job to zero out those unused bytes? Maybe we should be clearing all of
> the payload at the top of prepare_emulation_failure_exit().
>

Clearing the bytes at the top of prepare_emulation_failure_exit()
sounds good to me.  That will keep the data more deterministic.
Though, I will say that I don't think that is required.  If the first
flag isn't set the data shouldn't be read, no?

> Footnotes:
> [1]  https://disaster-area.hh.sledj.net/tmp/dme-581090/
>
> dme.
> --
> Music has magic, it's good clear syncopation.
