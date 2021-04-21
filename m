Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F3C367008
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 18:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhDUQZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 12:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbhDUQY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 12:24:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5332C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:24:25 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j12so25051203edy.3
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTswBWBfN86e7L19WzbhIKA4mB0pfAmoRVuTBTzKaOU=;
        b=h8BTSrOnPBxQ5DO5N9ccBBoc0D5RootOdz8t2t5wPhyLHYFqmUU9hEzEfED1WDRB9v
         udwnFeVe+XM9yWJ3Tm2gI1qb5WR5QHqtz+ehLyB2xY+QVK5crMZVX/NR0Mxu87uktPg+
         XnFII1pAKU7KXeQ/BEEau/OReW8TK7/dp7aztN6C/lOskaade0O7WQHMCMVLnKrIhc+i
         dKI1RzBM7RfFGx7jnshPJ0il3Ti0ZIZOWmYV7MpGPzJZdpKg+4eif0SIm+n07SfVECQB
         22GyF8YflWD/sFd9eC8vG7wC7G+rSN4Aq66pK9QSPCFPiDMeo1CQ29+E7XM6zFwRpYnf
         KZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTswBWBfN86e7L19WzbhIKA4mB0pfAmoRVuTBTzKaOU=;
        b=DuUqAWFVIcHmX5wWPceDHhIKcysDtv+FUsPqPIB9SPKNn4LjwaIG9DWlm38XFxm/Df
         te9XUtkN3C/4NYCOqQ2+2v+rie9VGaTACPmrjIJkn9HNsyol11xlIzplO6F3q1alC5aA
         YjeiWkjWZIvVZX0QT8cfwbmCcjkyNpVsjkU5b0PdLD2lLRxmNVxUsnPvYzhNb2tGJdil
         LxH4i5wR+FJPpfiz19n+QinMYgrN9xpqiLSfXV1BLny6/B9+pIN5In8vJNEnBRy13AZ6
         2DmO4cXpE2ofpVvEyjGUPwMBxBtqAWEJ0Fmtrxm9BKsQelsASqeEpHbWPLt03w07HQ5E
         Dkkw==
X-Gm-Message-State: AOAM531blEqyq+U6y1DofbTkccM2rOXDbnS9W0SlOY8cR+8JP4CV9gCc
        UZa/3+ie63ULg98MqaEAlb2m0vlVIrTQVErfkdSfaw==
X-Google-Smtp-Source: ABdhPJxBJv4JIYISO7TrUwENdg3H+Nn09vHjG7y8FMb27J3YjoHLlg2jbBHO8nVcSejPjLhkVGhA3XOU5qdhXXKr54U=
X-Received: by 2002:aa7:c492:: with SMTP id m18mr16875020edq.30.1619022264375;
 Wed, 21 Apr 2021 09:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com> <cunsg3jg2ga.fsf@dme.org>
In-Reply-To: <cunsg3jg2ga.fsf@dme.org>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 21 Apr 2021 09:24:13 -0700
Message-ID: <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +     if (insn_size) {
> > +             run->emulation_failure.ndata = 3;
> > +             run->emulation_failure.flags |=
> > +                     KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> > +             run->emulation_failure.insn_size = insn_size;
> > +             memcpy(run->emulation_failure.insn_bytes,
> > +                    ctxt->fetch.data, sizeof(ctxt->fetch.data));
>
> We're relying on the fact that insn_bytes is at least as large as
> fetch.data, which is fine, but worth an assertion?
>
> "Leaking" irrelevant bytes here also seems bad, but I can't immediately
> see a problem as a result.
>

I don't think this is a problem because the instruction bytes stream
has irrelevant bytes in it anyway.  In the test attached I verify that
it receives an flds instruction in userspace that was emulated in the
guest.  In the stream that comes through insn_size is set to 15 and
the instruction is only 2 bytes long, so the stream has irrelevant
bytes in it as far as this instruction is concerned.

> > +     }
> > +}
> > +
