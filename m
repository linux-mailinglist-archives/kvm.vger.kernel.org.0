Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1354BDF368
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfJUQnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 12:43:35 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:35267 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbfJUQnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 12:43:35 -0400
Received: by mail-il1-f193.google.com with SMTP id p8so2929837ilp.2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 09:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZDOrPjmqSrWWmDNeMsYiaU9DThTpaLcyfeJYUbA7aI=;
        b=teafmx6c+dcQ6z/nojJotclc/U31GiqRyYGsqAlQwuDFNG4gC3qur/CZreL7tiG+fI
         gqrNB1aBGjfdyy7CJOEk8OtC5zVMT2knI1/eXEb0wEANBcSSuHVnK76ocW4KtQ+tam32
         3wi+Wags0pUpX7eBEWEUzvSaKog5MXSCEEgtoESiz9H4diLl0I6YuzWVLjTlatZ/wUh/
         ayKFrdCt+NGvbLwFpqBmBh3YGQlixTuvIw1h+ESzUJ8EPFK/CvO5gw8DNtWgle8vwmoY
         CzoCKRa3oIdnU4q2TV5qDyRu11MNKyz24pJtyjzkj7W/TCuW0p+xNxzS2WNRx89Z469n
         lmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZDOrPjmqSrWWmDNeMsYiaU9DThTpaLcyfeJYUbA7aI=;
        b=ASf0IhPyyYBLGK7l9SfAZ+1by3WJHDTNhEXPbNura4FDAEQUsh8/8S5cFgdg3sOJdG
         qsa1Bc4T0dzYiSWrbG9gfzk0FssxXlxFVtf9l2w50wJebkAG+wRsdDQ63SmQEg4LZbl1
         wIm9IddxL/OXO4iWIHa8k00oW9bmOiZyROo9nAFnnCEGb5tKUMdhdZ4QvLnXpaQVbAaK
         C0CB8f7C4A4CsFA+46w6SA60yhiaCglziiLIUFTQC4uDBAlQpxk2fS22ECQv8zEGJ10b
         13JFFq47+zkuMQGdBBpJuOjp42gP9A+VyqkAcnbf/0FEqANnzw4faokmJCMNUFlVT2ul
         hL7Q==
X-Gm-Message-State: APjAAAVVz03I5IHHowtKp18I4vdlOhb3oxXJ4zO1j2+gszhLmqt2oXLf
        aRxfQE0ktCLlkpUFwpl++/uZMYnQ8FzSXNUkmdtivA==
X-Google-Smtp-Source: APXvYqzf9aiYscKmehyRa9OWyiidFWDrnAPBilZ+zPXPOE4HbqyVIhBVA5oqF4DAihlhjodSGxLETEDoZnnfyTzf1Us=
X-Received: by 2002:a92:c8cb:: with SMTP id c11mr25936288ilq.119.1571676212655;
 Mon, 21 Oct 2019 09:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191017012502.186146-1-morbo@google.com>
 <20191017012502.186146-3-morbo@google.com> <f40c1573-4cfe-4f51-c92c-4a22ba8f6287@redhat.com>
In-Reply-To: <f40c1573-4cfe-4f51-c92c-4a22ba8f6287@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Oct 2019 09:43:21 -0700
Message-ID: <CALMp9eR4gmSX+bwz5wZdqjmp4z8KUHQXLJqWSkLy96OofYHJSg@mail.gmail.com>
Subject: Re: [kvm-unit-tests v2 PATCH 2/2] x86: realmode: fix esp in call test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        alexandru.elisei@arm.com, thuth@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 8:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/10/19 03:25, Bill Wendling wrote:
> > diff --git a/x86/realmode.c b/x86/realmode.c
> > index 41b8592..f318910 100644
> > --- a/x86/realmode.c
> > +++ b/x86/realmode.c
> > @@ -520,7 +520,7 @@ static void test_call(void)
> >       u32 addr;
> >
> >       inregs = (struct regs){ 0 };
> > -     inregs.esp = (u32)esp;
> > +     inregs.esp = (u32)(esp+16);
>
> Applied with
>
> +       inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];
>
> Paolo

Would you mind doing the same for test_long_jmp?
