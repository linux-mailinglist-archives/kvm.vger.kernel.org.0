Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C512D70BA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfJOIGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:06:53 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33941 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfJOIGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:06:53 -0400
Received: by mail-vs1-f68.google.com with SMTP id d3so12571556vsr.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=th1h2ZaiO9EGWpk39A1YGFpd9N326wUTesAiG+Z2Qtw=;
        b=IQsqPXDjswmwL9NVpNqYbM4mFOpPHBGRPiaonED3CRaSxyb86sSilBDJ6Aju7R5s2r
         0q7I6FR5eDp27GJ6O7df09SnBkndJhbXAV2YC0oZcXKGFC2AnttYTGI8gYnkkChUndEh
         oQCAHeJiNS0NHG3Xzp0k3q4/+CFiSDsIjugDOfRPfiW9FDmjyYcUFZzjvxkIE7SsR3dH
         V1ja8iuPLYHSMmlPgClH1W9i8e579ikJ+4L2kqL1lR+BAYISX3SKABqgiJIjGVAOghy1
         hzeFmjS82n2f52hiDifEf2FaYyTd/FWgfbw5W/U5s2mQmrF/Zt8d8xy9i2f6aEOHbOxQ
         mICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=th1h2ZaiO9EGWpk39A1YGFpd9N326wUTesAiG+Z2Qtw=;
        b=flnwNzrNMiJUQjCM8qRsQbMm9ps3t6MOqhR4N/qLn8enCC6pjlLbKTHFwR9Gw29B0k
         vz847l4zTAZOFumRah+FwxjVpCseHOPhuobRw4/DjBj8p0zkgqHYlKIUJlmREAZECNtl
         KLsoEaLSm+jW0N+XUka2Mr7BBBAZwMpJQ3V1VCHaNH5tm5bISJJ1vzetadhYJQMWsAtU
         SfHpK+N4fE+JlMwX4EN57m5pxlzYHZCjXQiNibyWWwLjKHrjRN+ubFpEeBm5vI7lbjM1
         2NBQ7poEcX3sOwNXctgTOglwjESwbeSwJPkbaG6Y+pRvGnJjw/w0EVRU0SL2jPWJQua0
         788A==
X-Gm-Message-State: APjAAAVjHh85UkupX5u7xHzgSuxo6uo68Sxg84BwhZTqVZ/cb9Dn98y7
        B7ITLYfTJ82kY3R1EVuOqkPfHVsfNtEkqr5cQHsq
X-Google-Smtp-Source: APXvYqyzS+8xs+rKN3j0IRsePJhUw+dV7xwByqQRCak2N0gQgYgMHV8Qxh3L2RD+tv0Gq+Tld/rp9c3vpqAdx6IsZjg=
X-Received: by 2002:a67:e1d3:: with SMTP id p19mr18961464vsl.212.1571126811801;
 Tue, 15 Oct 2019 01:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191012074454.208377-2-morbo@google.com> <20191013071824.222946-1-morbo@google.com>
 <6656e70c-4866-55e8-108b-9bbb2c6fd081@redhat.com>
In-Reply-To: <6656e70c-4866-55e8-108b-9bbb2c6fd081@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 15 Oct 2019 01:06:40 -0700
Message-ID: <CAGG=3QVzF+Obz4ONuV-GPwz8v-St0VbkbDf2J9S3dS3o09pNzg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/1] x86: use pointer for end of exception table
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 12:41 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 13/10/2019 09.18, Bill Wendling wrote:
> > Two global objects can't have the same address in C. Clang uses this
> > fact to omit the check on the first iteration of the loop in
> > check_exception_table.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/x86/desc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> > index 451f504..cfc449f 100644
> > --- a/lib/x86/desc.c
> > +++ b/lib/x86/desc.c
> > @@ -41,7 +41,7 @@ struct ex_record {
> >      unsigned long handler;
> >  };
> >
> > -extern struct ex_record exception_table_start, exception_table_end;
> > +extern struct ex_record exception_table_start, *exception_table_end;
> >
> >  static const char* exception_mnemonic(int vector)
> >  {
> > @@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
> >               (((regs->rflags >> 16) & 1) << 8);
> >      asm("mov %0, %%gs:4" : : "r"(ex_val));
> >
> > -    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
> > +    for (ex = &exception_table_start; ex != (void*)&exception_table_end; ++ex) {
> >          if (ex->rip == regs->rip) {
> >              regs->rip = ex->handler;
> >              return;
> >
>
> That looks like quite an ugly hack to me - and if clang gets a little
> bit smarter, I'm pretty sure it will optimize this away, too.
>
I agree. I was thinking about this actually and this patch looks like
it'll work. I'll generate a new version of the patches.

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..4002203 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
                (((regs->rflags >> 16) & 1) << 8);
     asm("mov %0, %%gs:4" : : "r"(ex_val));

-    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+    for (ex = &exception_table_start; ex < &exception_table_end; ++ex) {
         if (ex->rip == regs->rip) {
             regs->rip = ex->handler;
             return;


> Could you please check if something like this works, too:
>
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 451f504..0e9779b 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -41,7 +41,8 @@ struct ex_record {
>      unsigned long handler;
>  };
>
> -extern struct ex_record exception_table_start, exception_table_end;
> +extern struct ex_record exception_table_start;
> +extern long exception_table_size;
>
>  static const char* exception_mnemonic(int vector)
>  {
> @@ -108,12 +109,13 @@ static void check_exception_table(struct ex_regs
> *regs)
>  {
>      struct ex_record *ex;
>      unsigned ex_val;
> +    int cnt = exception_table_size / sizeof(struct ex_record);
>
>      ex_val = regs->vector | (regs->error_code << 16) |
>                 (((regs->rflags >> 16) & 1) << 8);
>      asm("mov %0, %%gs:4" : : "r"(ex_val));
>
> -    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
> +    for (ex = &exception_table_start; cnt-- > 0; ++ex) {
>          if (ex->rip == regs->rip) {
>              regs->rip = ex->handler;
>              return;
> diff --git a/x86/flat.lds b/x86/flat.lds
> index a278b56..108fad5 100644
> --- a/x86/flat.lds
> +++ b/x86/flat.lds
> @@ -9,6 +9,7 @@ SECTIONS
>            exception_table_start = .;
>            *(.data.ex)
>           exception_table_end = .;
> +          exception_table_size = exception_table_end -
> exception_table_start;
>           }
>      . = ALIGN(16);
>      .rodata : { *(.rodata) }
>
>  Thomas
