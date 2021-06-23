Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF5D3B23FD
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFWXlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFWXlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:41:15 -0400
Received: from forward104j.mail.yandex.net (forward104j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05604C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:38:57 -0700 (PDT)
Received: from iva7-b2551a6f14a8.qloud-c.yandex.net (iva7-b2551a6f14a8.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f9c:0:640:b255:1a6f])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 9A9934A0894;
        Thu, 24 Jun 2021 02:38:53 +0300 (MSK)
Received: from iva6-2d18925256a6.qloud-c.yandex.net (iva6-2d18925256a6.qloud-c.yandex.net [2a02:6b8:c0c:7594:0:640:2d18:9252])
        by iva7-b2551a6f14a8.qloud-c.yandex.net (mxback/Yandex) with ESMTP id CIfYsZugXS-crIut3Lk;
        Thu, 24 Jun 2021 02:38:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624491533;
        bh=IReq3R+CjsyQE/26Ea+ZL9oagtb03a6Zh3l4vFRN7zg=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=n4oHsg6njuJRRb9ZaYgoAqE1ERYRuZTmFgTZKSanStp+lxbgMeelwwTLFhv1RTnDC
         3/ou4U2qwB44ilzVbeyyqvcMP0ebuOsPHNHTnt/287JC6aqdgRRAHawPPIMhHlRofS
         lIfuZSH3MzzuLPmzwx7DStZNEHE/riPKMv3CYmCQ=
Authentication-Results: iva7-b2551a6f14a8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva6-2d18925256a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id FeCG6Sak8j-crjGTqZk;
        Thu, 24 Jun 2021 02:38:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: exception vs SIGALRM race (with test-case now!)
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
Date:   Thu, 24 Jun 2021 02:38:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

22.06.2021 01:33, Jim Mattson пишет:
> I'm guessing that your core2duo doesn't have a VMX preemption timer,
> and this has some subtle effect on how the alarm interrupts VMX
> non-root operation. On the i7, try setting the module parameter
> preemption_timer to 0.

Hi again.

I wrote a reliable test-case to
check your suggestion.
Unfortunately, no luck on I7,
even with

---

$ cat /sys/module/kvm_intel/parameters/preemption_timer
N

$ cat /sys/module/kvm_intel/parameters/unrestricted_guest
N

---


But the Core2 owners reproduce
the problem immediately using my
test-case:
https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867221736

The test-case:
https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867215291

The source of it:
https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867215913

Now the question is: can anyone
from that list please replicate our
setup and reproduce the problem
on Core2 CPU, and then fix it?
I myself do not have such CPU, so
I probably can't do that on my own.

