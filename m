Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB13B673E
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhF1RJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhF1RJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 13:09:10 -0400
Received: from forward102o.mail.yandex.net (forward102o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64357C061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 10:06:44 -0700 (PDT)
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id E4DD06680C9B;
        Mon, 28 Jun 2021 20:06:40 +0300 (MSK)
Received: from vla1-76c0d7cee0ec.qloud-c.yandex.net (vla1-76c0d7cee0ec.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:d87:0:640:76c0:d7ce])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id DF56D7080005;
        Mon, 28 Jun 2021 20:06:40 +0300 (MSK)
Received: from vla5-047c0c0d12a6.qloud-c.yandex.net (vla5-047c0c0d12a6.qloud-c.yandex.net [2a02:6b8:c18:3484:0:640:47c:c0d])
        by vla1-76c0d7cee0ec.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 8ApYKXzc0O-6eIewUdU;
        Mon, 28 Jun 2021 20:06:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624900000;
        bh=foSQKaImyhZNzYi/uJp7KwvNksmQafV8QfENdu/n6+U=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=i8SGV93rj4s/nBImQnfgGU98T1zQlZ/4y+F2Yjn9OVAfzYsI+bW/VwMBOxMVtTuDS
         r330GZFdj7Tt+DYfFsjjk6M0Kd+wBxbJ5tMrsL1YUcTfLqAVVcfGDBMi03flCBxr30
         bXWT3/futkndCzLzDGOUbq7n2gBWUyXCs72Qvbso=
Authentication-Results: vla1-76c0d7cee0ec.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-047c0c0d12a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id UqGJz1fFag-6d3GJsjL;
        Mon, 28 Jun 2021 20:06:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <a6a8fe0b-1bd3-6a1a-22bb-bfc493f2a195@yandex.ru>
Date:   Mon, 28 Jun 2021 20:06:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 19:19, Jim Mattson пишет:
> This doesn't work. Kvm has no facilities for converting an injected
> exception back into a pending exception.

What is the purpose of the
cancel_injection then?


>   In particular, if the
> exception has side effects, such as a #PF which sets CR2, those side
> effects have already taken place. Once kvm sets the VM-entry
> interruption-information field, the next VM-entry must deliver that
> exception. You could arrange to back it out, but you would also have
> to back out the changes to CR2 (for #PF) or DR6 (for #DB).
>
> Cancel_injection *should* leave the exception in the 'injected' state,

But it removes it from VMCS, no?
I thought "injected=true" means
"injected to VMCS". What is the
difference between "injected" and
"pending" if both may or may not
mean "already in VMCS"?


> and KVM_SET_REGS *should not* clear an injected exception. (I don't
> think it's right to clear a pending exception either, if that
> exception happens to be a trap, but that's a different discussion).
>
> It seems to me that the crux of the problem here is that
> run->ready_for_interrupt_injection returns true when it should return
> false. That's probably where you should focus your efforts.

I tried that already, and showed
the results to you. :) Alas, you didn't
reply to those.
But why do you suggest the cpu-specific
approach? All other CPUs exit to user-space
only when the exception is _really_ injected,
i.e. CS/EIP points to the IDT handler.
I don't see why it should be non-atomic
just for one CPU. Shouldn't that be atomic
for all CPUs?

