Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C401D3B6A99
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhF1VxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 17:53:19 -0400
Received: from forward101j.mail.yandex.net ([5.45.198.241]:36724 "EHLO
        forward101j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235935AbhF1VxP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 17:53:15 -0400
Received: from myt5-6c0659e8c6cb.qloud-c.yandex.net (myt5-6c0659e8c6cb.qloud-c.yandex.net [IPv6:2a02:6b8:c12:271e:0:640:6c06:59e8])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 025261BE1D41;
        Tue, 29 Jun 2021 00:50:48 +0300 (MSK)
Received: from myt3-07a4bd8655f2.qloud-c.yandex.net (myt3-07a4bd8655f2.qloud-c.yandex.net [2a02:6b8:c12:693:0:640:7a4:bd86])
        by myt5-6c0659e8c6cb.qloud-c.yandex.net (mxback/Yandex) with ESMTP id NbUEtRdi5e-olHSAk1d;
        Tue, 29 Jun 2021 00:50:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624917047;
        bh=HBkgElTvHwy3r0sGDedALbNp6R6I2TLuuqXtSHE5K8Y=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=shQmlOXRiFycfZGu1697na25HUsCyDcBpiVTyPy8PV0IQdzytIoyBZnZebbWI28tz
         3ET+eI/MPc9jPxWtHC1SacmdRmzhj2irR8NAsrNy6y976fFNiJP3lV/Vu4n9w3l3/2
         wWqymR52jIT1fgtRpQay0nZqPQqDv6UsmD7m1CVE=
Authentication-Results: myt5-6c0659e8c6cb.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt3-07a4bd8655f2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id a9e2JX41iY-ol2OsDBd;
        Tue, 29 Jun 2021 00:50:47 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
 <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <a8f294ca-6b98-1e89-0174-dfa713c9f910@yandex.ru>
Date:   Tue, 29 Jun 2021 00:50:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

29.06.2021 00:47, Jim Mattson пишет:
> On Mon, Jun 21, 2021 at 5:27 PM stsp <stsp2@yandex.ru> wrote:
>> 22.06.2021 01:33, Jim Mattson пишет:
>>> Maybe what you want is run->ready_for_interrupt_injection? And, if
>>> that's not set, try KVM_RUN with run->request_interrupt_window set?
>> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>> {
>>           return kvm_arch_interrupt_allowed(vcpu) &&
>>                   !kvm_cpu_has_interrupt(vcpu) &&
>>                   !kvm_event_needs_reinjection(vcpu) &&
>>                   kvm_cpu_accept_dm_intr(vcpu);
>>
>> }
>>
>>
>> So judging from this snippet,
>> I wouldn't bet on the right indication
>> from run->ready_for_interrupt_injection
> In your case, vcpu->arch.exception.injected is true, so
> kvm_event_needs_reinjection() returns true. Hence,
> kvm_vcpu_ready_for_interrupt_injection() returns false.
>
> Are you seeing that run->ready_for_interrupt_injection is true, or are
> you just speculating?

I have checked everything I said,
BUT: on a kernel 5.11.8.
Was this fixed on 5.12 or what?

