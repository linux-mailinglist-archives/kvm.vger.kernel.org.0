Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C01366B1B
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhDUMsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 08:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhDUMsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 08:48:36 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F249FC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 05:48:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g17so48524950edm.6
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 05:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcPkUIt0PkftFCICXgb4XtPqcTz8VbzzU1h3ykCjrpE=;
        b=v38ShpeA7NUXjP5mVFnvv+10VvJkXyvv/Ql03FN0YLX6JCvURgY2gav3jRXA3A6hFe
         7kBXLNa2h64vIJn0rKxAoGFM4s2r18HBtOMrvq+Y4gNiSBB5w1L2y6UDfb7yd5V3q+oF
         FYbqceyxljjJFgbRmanDbotlKRA8szIN12+A+cN1HgHaI6r3LsFxn6M/ThSPPY6CO5cG
         yVEUGPlvnMiHf6c4fFgr0jgjyHjeD9SVDdmH/teQTTyvfRS3lJ0vOhQLc8J64Hu3P2I6
         TkUPtiJZtFxbwPDsuBxKjBMarawXVE0lULAv/atj6EooBleBRIpCHboCQLNASqlwYkCK
         fFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcPkUIt0PkftFCICXgb4XtPqcTz8VbzzU1h3ykCjrpE=;
        b=BtzqFtNXR5mD0L6S3l+AgWVgMkyS9dvxk8Z9EKHYYoGj0UalMOCF5P+HhEuTYepvFJ
         VO0BCL9QQhFBzLrqWAEXAIn5d8rOjds3FrGSMIKPicv/CEls13wEw9+ny5ifpZ1NhwAS
         GU3ggj37zBYVnKcv/RxpmWRyCyPkQplgeZBO7fgGduCCiDeq+JOQyRXv2OVE6YDxFBXe
         YYdDbdJ/MfCEPXyjDxD9rXmKP4BBmoK8EFCAZdnC8DRDV0KkeQAnBJ1JGuDi75zlYZdG
         WahYIKCqPXUc78Zu4T9Sa4UWvRNldy/3eNsEC3KBAIs8Ncdwxn0BM8jHuwJcSQkJULn2
         Bk2g==
X-Gm-Message-State: AOAM5312pxPCPvBRMPZ42cNZRAbivaVBu1Aq8oENI++V+kUw90Nc13Ck
        jdOpHUXTa8HU3XsyC/WTZtazrwEFfCng71HEixtPEw==
X-Google-Smtp-Source: ABdhPJwjG3DXxXLtBd8bGOXX7HGj2oIY7+NvvTJKvkF0+WPtld6E58rpZW7JyktxzOkGoLg1oU8t2cZb0yjEqcco7ec=
X-Received: by 2002:aa7:c492:: with SMTP id m18mr15643534edq.30.1619009281597;
 Wed, 21 Apr 2021 05:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <YH8eyGMC3A9+CKTo@google.com> <m2sg3kt4jc.fsf@dme.org>
In-Reply-To: <m2sg3kt4jc.fsf@dme.org>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 21 Apr 2021 05:47:50 -0700
Message-ID: <CAAAPnDEV8UvY_DVSL16EEdNyVxo75H9aB=0uTrzY2gJKXuHmFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> The other motivation is that KVM can opportunistically start dumping extra info
>> for old VMMs, though this patch does not do that; feedback imminent. :-)
>
> It's nothing more than that the interface ends up feeling a little
> strange. With several flags added and some of the earlier flags unused,
> ndata ends up indicating the largest extent of the flag-indicated data,
> but the earlier elements of the structure are unused. Hence the question
> about how many flags we anticipate using simultaneously.
>
> (I'm not really arguing that we should be packing the stuff in and
> having to decode it, as that is also unpleasant.)

It's hard to say how many flags will be used, but I suspect it will be
a small set (I mentioned previously a possibility of 2 more), so I
like Sean's suggestion to keep it simple and just use the flags to
indicate which fields are used, instead of trying to pack everything
in tightly.

On Wed, Apr 21, 2021 at 1:39 AM David Edmondson <dme@dme.org> wrote:
>
> On Tuesday, 2021-04-20 at 18:34:48 UTC, Sean Christopherson wrote:
>
> > On Fri, Apr 16, 2021, Aaron Lewis wrote:
> >> +                    KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> >> +            vcpu->run->emulation_failure.insn_size = insn_size;
> >> +            memcpy(vcpu->run->emulation_failure.insn_bytes,
> >> +                   ctxt->fetch.data, sizeof(ctxt->fetch.data));
> >
> > Doesn't truly matter, but I think it's less confusing to copy over insn_size
> > bytes.
>
> And zero out the rest?
>

I left the memcpy alone as this seems like a more concervative / safer
approach.  I've had and have seen too many memcpy fails that my
preference is to be conservative here.  I could add a comment to
clarify any confusion that this may bring by not using insn_size if
that will help.


Cheers,
Aaron
