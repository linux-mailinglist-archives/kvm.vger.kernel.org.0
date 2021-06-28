Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9567F3B6602
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 17:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhF1PrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhF1PrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 11:47:15 -0400
Received: from forward100p.mail.yandex.net (forward100p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B313FC058225
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 08:09:13 -0700 (PDT)
Received: from iva6-9c4bacd762e0.qloud-c.yandex.net (iva6-9c4bacd762e0.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:9107:0:640:9c4b:acd7])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id 3E26F598135F;
        Mon, 28 Jun 2021 18:09:10 +0300 (MSK)
Received: from iva8-a4a480c9f089.qloud-c.yandex.net (iva8-a4a480c9f089.qloud-c.yandex.net [2a02:6b8:c0c:da5:0:640:a4a4:80c9])
        by iva6-9c4bacd762e0.qloud-c.yandex.net (mxback/Yandex) with ESMTP id p4ykWoUN3a-99H8jxCw;
        Mon, 28 Jun 2021 18:09:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624892950;
        bh=l0Rh8tcepppYFEe73czaOnTLhrMJdSOub8SSmhSAAeM=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=EnFO01OxGt9tLVVj8glcUaAn0GmkmL9qrfRDID/qsusZKXgLymnDF6DDzUzN6ea5n
         p5invqPfNDfogoif0LcWUIJTvIbxGZMgkNwHtwe4XEnG4jf1HdJKyxfaNpIyn7x8Eg
         sLnWTd8NETGbMrS7uf+GTlRAITFmalq0HuaDSClc=
Authentication-Results: iva6-9c4bacd762e0.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva8-a4a480c9f089.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id J7p7pCtrXB-983uFOxN;
        Mon, 28 Jun 2021 18:09:08 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210628124814.1001507-1-stsp2@yandex.ru>
 <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <9a7962d1-7eee-620b-5b30-ffcc123c324c@yandex.ru>
Date:   Mon, 28 Jun 2021 18:09:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 17:29, Maxim Levitsky пишет:
> I used to know that area very very well, and I basically combed
> the whole thing back and forth,
> and I have patch series to decouple injected and
> pending exceptions.

Yes, and also I dislike the fact
that you can't easily distinguish
the exception injected from
user-space, with the PF coming
from the guest itself. They occupy
the same pending/injected fields.
Some refactoring will definitely
not hurt.


> I'll refresh my memory on this and then I'll review your patch.
>
> My gut feeling is that you discovered too that injections of
> exceptions from userspace is kind of broken and only works
> because Qemu doesn't really inject much

Actually I discovered that injecting
_interrupts_ is kinda broken (on Core2),
because they clash with guest's PF.
Maybe if I would be using KVM-supplied
injection APIs, I would avoid the problem.
But I just use KVM_SET_REGS to inject
the interrupt, which perhaps qemu doesn't
do.

