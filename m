Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7A67021
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfGLNch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:32:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37359 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfGLNch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:32:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so8059699qto.4;
        Fri, 12 Jul 2019 06:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JM+xRcXXQLHHmgjag8FydAcUh6ZsxVdozmIdMl6zvCI=;
        b=ncDNJL1/AGOalU51T9+OUXd8y8ehu2STjZFIR99KAuQJ/2u5eCIPMxkt4/Ob3+EWqD
         h9qSk0tgr3NnUBe2FQbRQyfpacqCP+04lzv5u1GbAxkjWii4vfM7miFXTQkIy3cRfQwZ
         9ST0APRWF/SHopBGj94U/dLObasW1I6uPNIwks5j7hgZ7NeiGBmSIfg3r/PVIYnNnnKU
         4RjI9O/5Lx7yrP+8qzXSqE5mCF1FFvFfauk2XMgTfwPAGY4iHdzcxaNW/X80+aRzlK+t
         aHBhqDslQ1IWxA1bBRUFkr/wewMXfB74n4k3LKjQMip/05i07gVkWq+2bvUc8g0Xnate
         koPA==
X-Gm-Message-State: APjAAAV2jpBMqmWM9VSzTEVp62rFfq+6r7a6X/qTSPqLRHGHk20W1TRT
        Aix9tq24UesuZfkuOVQTpgjHggbaPKpeNfLucM0=
X-Google-Smtp-Source: APXvYqxPlWEtSy66dRXVvO7HauhbJcXyER6iLjOtwvkxNYeOK4Mml77zTqyKp0u2GSa8CP2zC1aC9rWC10ZbojqT1zk=
X-Received: by 2002:ac8:f99:: with SMTP id b25mr929340qtk.142.1562938356233;
 Fri, 12 Jul 2019 06:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190712091239.716978-1-arnd@arndb.de> <20190712120249.GA27820@rkaganb.sw.ru>
 <CAK8P3a3+QSRQkitXiDFLYvyYvOS+Q4sXb=xA_XPeX2O2zQ5kgw@mail.gmail.com> <b7da5e91-f23c-9f5d-2c61-07e7fc7af9b1@redhat.com>
In-Reply-To: <b7da5e91-f23c-9f5d-2c61-07e7fc7af9b1@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 12 Jul 2019 15:32:19 +0200
Message-ID: <CAK8P3a1yiEBt0MgXJPKdnEMiTL6yUWsiT7Upi-kJAtqKJ5VDqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Roman Kagan <rkagan@virtuozzo.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 3:14 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/07/19 15:02, Arnd Bergmann wrote:
> > I think what happens here is that clang does not treat the return
> > code of track the return code of is_64_bit_mode() as a constant
> > expression, and therefore assumes that the if() condition
> > may or may not be true, for the purpose of determining whether
> > the variable is used without an inialization. This would hold even
> > if it later eliminates the code leading up to the if() in an optimization
> > stage. IS_ENABLED(CONFIG_X86_64) however is a constant
> > expression, so with the patch, it understands this.
> >
> > In contrast, gcc seems to perform all the inlining first, and
> > then see if some variable is used uninitialized in the final code.
> > This gives additional information to the compiler, but makes the
> > outcome less predictable since it depends on optimization flags
> > and architecture specific behavior.
> >
> > Both approaches have their own sets of false positive and false
> > negative warnings.
>
> True, on the other hand constant returns are not really rocket science. :)
>
> Maybe change is_long_mode to a macro if !CONFIG_X86_64?  That would be
> better if clang likes it.

I had to also get rid of the temporary variable to make it work.
Sending v2 now.

      Arnd
