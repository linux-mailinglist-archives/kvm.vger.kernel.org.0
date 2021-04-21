Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC5367033
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhDUQc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 12:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbhDUQc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 12:32:28 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8493CC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:31:55 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id e25so13023891oii.2
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wR+xo434x6x3CACDhCX3eGQ/mv+RIRDph2BSLbtfAtI=;
        b=dPL+Fad2Shmb/EM3/dntodG7JwiSMCvxAQXiewVLtqGUSRcwlXqAHGkY8Z+OddO2wH
         vnaIP4f7p+UYhmFXzOivFBKUZ9dLMYinLJ5TQiDQgeDPai/8/KgAzVhFz6KqwAE7/iuM
         yIPrIcp03sRwjDqpfHw8g5EaEHKKwFBYHe8FvnWH0FKjjxrE+gai2oDKn0kXac4PfBvy
         8GxR9WtasGzrpjpoywpLqquqLpWL1Q64ZcZdLJVC498dyTjE4Zpp14LZ0OZROVlYQBgB
         cPf5JauHXjm1y/sqevsxU1LBkTLXzzyazpUxHiNpUYdPHTdWHYkggFSn3DKxeItm60HJ
         +XWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wR+xo434x6x3CACDhCX3eGQ/mv+RIRDph2BSLbtfAtI=;
        b=OpKI9Uw5fZP4AQWDAg0vHB/l1FjmqeN2QA/zWWSqMkfNaDACvLYuO99mP8BdankciT
         CPSVukegAmTwFy+Q31DCIZLnnlAj7hDR2/m6gDjBwDQb65Z9AhqkXIOMKEKd6q4Ihqxa
         RJ0PXBeUguBVTwhblGxEKI8GZjjdoyZ+Jm8xSnxQ36nibcKOjyUmGxwFaJ1u4V7XrULW
         O45eUSlBUnbRa7KKbOi9LAWlbcDhTiLW57vxFlkwebyu/PuPpGWbA2Tnzgp+uMtTGNTh
         zP5zCHgzvm35vosMd9ijKwH72Yvf4OoNzBhYtiRL0ZHJ+juAKP0oj8p1BS3JIaHbaX7g
         rvPA==
X-Gm-Message-State: AOAM532zAcNGJDtxUmCmtLdrZkfs90aih80uqYnrtoSJy1BOoFOnuNCn
        Fmzf5dOH2Qz7XYAMMbDFK27SaifiVw3gXmHNF5JJrw==
X-Google-Smtp-Source: ABdhPJxIll9BQ06NqtElc52n32IhHiXmAS6rEmC+AxNVUCqdNgaqcn+w0CaeiP/22tbqIRWnTUTuOY+ERN7jaETHWBM=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr7275835oia.28.1619022714722;
 Wed, 21 Apr 2021 09:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com> <YH8eyGMC3A9+CKTo@google.com>
In-Reply-To: <YH8eyGMC3A9+CKTo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Apr 2021 09:31:44 -0700
Message-ID: <CALMp9eSCE=OfUcHR9FgPzfNV1zzTZXBHPQfF9d_6p96ZRKj5DA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        David Edmondson <david.edmondson@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 11:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 16, 2021, Aaron Lewis wrote:
...
> > +     vcpu->run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> > +     vcpu->run->emulation_failure.ndata = 0;
> > +     if (kvm->arch.exit_on_emulation_error && insn_size > 0) {
>
> I definitely think this should not be conditioned on exit_on_emulation_error.
>
> No need for "> 0", it's an unsigned value.

Unsigned doesn't imply non-zero. If insn_size is 0, then something is wrong.

...
> > +                     KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> > +             vcpu->run->emulation_failure.insn_size = insn_size;
> > +             memcpy(vcpu->run->emulation_failure.insn_bytes,
> > +                    ctxt->fetch.data, sizeof(ctxt->fetch.data));
>
> Doesn't truly matter, but I think it's less confusing to copy over insn_size
> bytes.

Are you convinced that insn_size is always less than or equal to
sizeof(ctxt->fetch.data)? I'm not. It shouldn't be, of course, but
perhaps we should confirm that before copying insn_size bytes.
