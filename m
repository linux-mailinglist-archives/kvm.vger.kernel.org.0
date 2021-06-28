Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC583B6AF1
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhF1W0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:26:22 -0400
Received: from forward103j.mail.yandex.net ([5.45.198.246]:45822 "EHLO
        forward103j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232124AbhF1W0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 18:26:21 -0400
Received: from iva7-16e50705448a.qloud-c.yandex.net (iva7-16e50705448a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:3227:0:640:16e5:705])
        by forward103j.mail.yandex.net (Yandex) with ESMTP id 580736740B8B;
        Tue, 29 Jun 2021 01:23:53 +0300 (MSK)
Received: from iva5-057a0d1fbbd8.qloud-c.yandex.net (iva5-057a0d1fbbd8.qloud-c.yandex.net [2a02:6b8:c0c:7f1c:0:640:57a:d1f])
        by iva7-16e50705448a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 0xhHNlZsXL-NqHOkNEW;
        Tue, 29 Jun 2021 01:23:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624919033;
        bh=/JE+xin0Q4mL7/srUoKJdaK6WXqQ90sps5PQ37jdG4Y=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=oLiKiGzOu5NXgjvL6/m8Gm4TJYX+49Q/2AWlQoQlGYT5M9s3AUP3EcZLHB3tFo7fm
         OThsa++AX4wO96ge2NhDS/OlbB+dpMsRzj9VqSy9Y8O51OL5uC72OEtc9a2K1ScZmx
         gxyvfyYSDBlMbF+1Y2pn7+B+FBlR9hHQnRz8htwo=
Authentication-Results: iva7-16e50705448a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva5-057a0d1fbbd8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id BuwzH9MfKP-Np2KaIQH;
        Tue, 29 Jun 2021 01:23:52 +0300
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
Message-ID: <de0a87e6-6e2a-bb0c-d3ef-3a70347d59c0@yandex.ru>
Date:   Tue, 29 Jun 2021 01:23:50 +0300
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
> It seems to me that the crux of the problem here is that
> run->ready_for_interrupt_injection returns true when it should return
> false. That's probably where you should focus your efforts.

OK, it was occasionally found that
it actually worked that way in the
past. This patch:
https://www.lkml.org/lkml/2020/12/1/324
from Paolo removes the
!kvm_event_needs_reinjection(vcpu)
check.

Paolo, maybe you can comment?


> This isn't CPU-specific. Even when using EPT, you can potentially end
> up in this state after an EPT violation during IDT vectoring.

Well, in that case you will at
least return the proper status
about the EPT violation.
But for EINTR this is definitely
going to be CPU-specific.
And a rather nasty one: running
a ring3 guest with CPL=0 and IF
always set, and having to check
for ready_to_injection upon EINTR
on just one CPU, is very unexpected.

So I won't be claiming that Paolo's
patch is incorrect. Maybe someone
can think of the way to just not
get such scenario on EINTR?

