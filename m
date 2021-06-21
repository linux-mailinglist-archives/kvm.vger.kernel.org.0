Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FA3AE1A9
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 04:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFUChA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Jun 2021 22:37:00 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:36710 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhFUCg7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Jun 2021 22:36:59 -0400
Received: from iva7-79032ba5307a.qloud-c.yandex.net (iva7-79032ba5307a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:320d:0:640:7903:2ba5])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id E26CC18C0FEF;
        Mon, 21 Jun 2021 05:34:39 +0300 (MSK)
Received: from iva1-bc1861525829.qloud-c.yandex.net (iva1-bc1861525829.qloud-c.yandex.net [2a02:6b8:c0c:a0e:0:640:bc18:6152])
        by iva7-79032ba5307a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id F2jYrq5fAh-YdH8DML9;
        Mon, 21 Jun 2021 05:34:39 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624242879;
        bh=pT6P/8MC3FNUnXtk3+JCj1lFH28EHx2XdUqmXwWjTUA=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=uOZ+gVM/HI9fxXoiZui5DZD8Yp7m6s1GBJYMkuemNwSpSCulGX8MFzEo670vWU8jZ
         ErvskQB6tC4sDfIT7pEml3vJm87rlohBtjSyjC/odd+xzUlpgqxIxHRrZKcnO1jFIy
         BZNpcfXkSkJjqqniip/WOxFALkG9YZHNJ6uI8kaI=
Authentication-Results: iva7-79032ba5307a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva1-bc1861525829.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id sCni5vBt0M-Yd34ph0S;
        Mon, 21 Jun 2021 05:34:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
Date:   Mon, 21 Jun 2021 05:34:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.06.2021 00:07, Jim Mattson пишет:
> I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:
OK, so this indeed have solved
the biggest part of the problem,
thanks again.

Now back to the original problem,
where I was getting a page fault
on some CPUs sometimes.
I digged a bit more.
It seems I am getting a race of
this kind: exception in guest happens
at the same time when the host's
SIGALRM arrives. KVM returns to
host with the exception somehow
"pending", but its still on ring3, not
switched to the ring0 handler.

Then from host I inject the interrupt
(which is what SIGALRM asks for),
and when I enter the guest, it throws
the pending exception instead of
executing the interrupt handler.
I suspect the bug is again on my side,
but I am not sure how to handle that
kind of race. I suppose I need to look
at some interruptibility state to find
out that the interrupt cannot be injected
at that time. But I can't find if KVM
exports the interruptibility state, other
than guest's IF/VIF flag, which is not
enough in this case.
Also I am a bit puzzled why I can't
see such race on an I7 CPU even
after disabling the unrestricted_guest.

Any ideas? :)
