Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4569BB05AD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 00:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfIKWfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 18:35:23 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33456 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfIKWfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 18:35:22 -0400
Received: by mail-vs1-f68.google.com with SMTP id s18so14914466vsa.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Numd5Fj5V+NqJtDGmIMyehxqSGXlbfOCcCIkYzZMa14=;
        b=lzJGixfwRAzBt3B4LP2dQ9KZnbVZ807OSCXK1th2CBQ8WovcR/4vtTKl1uxQd4lM7f
         t0aTVxvVlv5KRayxT5oGevPJdMjR67HPiMqE+220fj0HF5blnRlNSVMneqVKjL7sE2ui
         jTfkbWiiO1RwOKHfpa2ZQ5D1dSlpMa1WiUauSpbP5PszjeGg83iYFVlaE0vI0gEJI6Tf
         lL75EmE5O405WdpQmLvRtSlO9R3e7yvo0kCipXe2xHwfSy1CkrYeCqR4Kjm6pPQEL9P+
         KBqbA8/wtw2Oemu/5bMgM+T92iVHgyVm+HDrwRMVYOHjhRmHRx2vI34Py4aYuAiWQIYZ
         u7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Numd5Fj5V+NqJtDGmIMyehxqSGXlbfOCcCIkYzZMa14=;
        b=uFSdgnQpkngKSqnCx7XcL/o9UIu/oqbWJgXSGBqleSZ4QcYFcKiLU6c3KG51z+xzLV
         sullsnTbK3iQKCRB3bFUe3FcNLdlzTYL9BJ8Ec76lxgRLOo6reebFEeFVTfc2epwMY+y
         gYf8c1CTqtkgEPtyzISAhbl2U+2qX/j3uoURoVqRy1j6mYjYFaJ/TytS4vFueRhaf7t+
         OeL/hL6fqZwNzPEy9b8pS+mFIFt999X/T4g922KyT05Wy4MMGVRiuTWGauW+QcMc3cjr
         /nEvts4TTk6GOZyspoAheBhfbC9EXIjBAQ/jsBfOD6b5gd5CYRQ8TM61VrfWCngsStNX
         ufXg==
X-Gm-Message-State: APjAAAV/pzvQknRM0TOzAtvC56wsPPBh3otAsXoEKjx1B9eioty7bcN9
        LJNYQ9y7zsJ1NKbY5j6ReyrBD9cp8umLjEmkFL/2
X-Google-Smtp-Source: APXvYqxHUFjCnVQrovLtAoxRtlBJFFRwh6f+2pOsZDHf8SR74FFBmVf1p+BzBEvUYx4IkBy1mmXJYSrnOoPPEr+hMXA=
X-Received: by 2002:a67:ec18:: with SMTP id d24mr18464681vso.80.1568241320438;
 Wed, 11 Sep 2019 15:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
 <20190911190840.GG1045@linux.intel.com>
In-Reply-To: <20190911190840.GG1045@linux.intel.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 11 Sep 2019 17:35:09 -0500
Message-ID: <CAGG=3QXxGVs-s0H2Emw1tYMtcGtQsEHrYnmHztL=vOFanZegMw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: remove memory constraint from "mov" instruction
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 2:08 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 09, 2019 at 02:19:20PM -0700, Bill Wendling wrote:
> > The "mov" instruction to get the error code shouldn't move into a memory
> > location. Don't allow the compiler to make this decision. Instead
> > specify that only a register is appropriate here.
>
> I'd prefer the changelog to say something like:
>
>   Remove a bogus memory contraint as x86 does not have a generic
>   memory-to-memory "mov" instruction.
>
> Saying "shouldn't move into a memory location" makes it sound like there's
> an unwanted side effect when the compiler selects memory, though I suppose
> you could argue that a build error is an unwanted side effect :-).
>
No prob. :-) I'm not familiar with sending these patches via email. Do
I need to regenerate the patch and send via "send-email"? (Similar
question for the "Reviewed-By" comments.)

> Out of curiosity, do any compilers actually generate errors because of
> this, or is it simply dead code?
>
Yeah, clang uses a memory location, probably due to inlining causing
register pressure (that's a guess, I didn't explore it too deeply).

-bw

> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/x86/desc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> > index 5f37cef..451f504 100644
> > --- a/lib/x86/desc.c
> > +++ b/lib/x86/desc.c
> > @@ -263,7 +263,7 @@ unsigned exception_error_code(void)
> >  {
> >      unsigned short error_code;
> >
> > -    asm("mov %%gs:6, %0" : "=rm"(error_code));
> > +    asm("mov %%gs:6, %0" : "=r"(error_code));
> >      return error_code;
> >  }
