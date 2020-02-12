Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADB015B19D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 21:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgBLUOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 15:14:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35235 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgBLUOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 15:14:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so3851237ljb.2
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 12:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8rkEvPmm2/3C3lqf62Iz0nM0CBnRzi7Rqch1cLEjuM=;
        b=DIFb93kbDLtTa42QN6IXEtChk6umapMJ93xcDqr95+Q8R9OVe5IsvX0GevzZb1PsCM
         WE5xAAhHVLd9OCuY2Pdtbw+SavI/FqeOMfT3g+Z5+bXNfxRoE+RmSgtRaCSpF3+56bzw
         YbGGsgFqZHixlW2pRb2BlE5TqyH310/yLeE8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8rkEvPmm2/3C3lqf62Iz0nM0CBnRzi7Rqch1cLEjuM=;
        b=GTAkNjY6twMClGzYaGZc4YROUdo1EpsBUOi5LKvalxl/IzYlAjNDMHzeYvQndY6cex
         LaVr2G+l1FrUmBJbovApqRB2Km4aEN9Udjz4LTTUOoBs3WkrDPLKoek0IJSgcgsgKgFt
         ORmCXuQkTyDjKBG+LVMw68aMjRivbbqRA5hx82l/d+3bqkg0q+1Ym/kYcmwYKvL78eLK
         F3LviXTEx4EbFKT/+N36/C/z2CNmlwrI2bktCWficXcXKKQjAXqt5Ooi4w6l3x/1qfBQ
         kONG/5ziQYxusqFZriedQ4UxVednDMzCs1QQ7RhfLPf3JRsXnFC/j2W2+ziIJjD/RobT
         o1/w==
X-Gm-Message-State: APjAAAUbV90Xlyi8kVj+jjCXGvz0xjcXlEiqWeilpH7PG6hPldcO5JSs
        YfeYs0Xh5Aj0ycoPKcnA891TPiDW5zg=
X-Google-Smtp-Source: APXvYqyWnl6X8f8ySUNty0gSKb5Gg4J+pGcA8YM2XIuKdpsnrutFbuwqJiruMTwVO/bkZ+PFxntgzw==
X-Received: by 2002:a2e:9052:: with SMTP id n18mr8673048ljg.251.1581538448065;
        Wed, 12 Feb 2020 12:14:08 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id w29sm115061ljd.99.2020.02.12.12.14.06
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 12:14:07 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id y19so2515869lfl.9
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 12:14:06 -0800 (PST)
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr7688870lfo.10.1581538446050;
 Wed, 12 Feb 2020 12:14:06 -0800 (PST)
MIME-Version: 1.0
References: <20200212164714.7733-1-pbonzini@redhat.com> <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
 <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com> <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
 <23585515-73a9-596e-21f1-cbbcc9d7e7f9@redhat.com>
In-Reply-To: <23585515-73a9-596e-21f1-cbbcc9d7e7f9@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Feb 2020 12:13:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjv2V==7jGwg2OkyX4F6Cdtt4qCpdGF56rOi-kVtjGCZQ@mail.gmail.com>
Message-ID: <CAHk-=wjv2V==7jGwg2OkyX4F6Cdtt4qCpdGF56rOi-kVtjGCZQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 12:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> I know, but still I consider it.  There is no reason why the "build
> test" should be anything more than "make && echo yes i am build-tested".

It damn well should check for warnings.

And if you can't bother eye-balling it or scripting it, then simply use

   make KCFLAGS=-Werror

but sadly I can't enforce that in general for all kernel builds simply
because some people use compilers that cause new warnings (compiler
updates etc commonly result in them, for example).

So I can't add -Werror in general, but developers can certainly use it
trivially.

No grep or other scripting required (although the above may cause
problems for that one sample file that does cause warnings - I didn't
check).

              Linus
