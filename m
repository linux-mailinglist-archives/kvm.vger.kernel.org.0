Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068BF3B6729
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhF1RDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:03:02 -0400
Received: from forward102p.mail.yandex.net ([77.88.28.102]:56606 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231892AbhF1RDB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 13:03:01 -0400
Received: from myt6-b15a496b05fb.qloud-c.yandex.net (myt6-b15a496b05fb.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2228:0:640:b15a:496b])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 3233954C0E91;
        Mon, 28 Jun 2021 20:00:34 +0300 (MSK)
Received: from myt5-89cdf5c4a3a5.qloud-c.yandex.net (myt5-89cdf5c4a3a5.qloud-c.yandex.net [2a02:6b8:c12:289b:0:640:89cd:f5c4])
        by myt6-b15a496b05fb.qloud-c.yandex.net (mxback/Yandex) with ESMTP id kA6UJqYyZr-0XImnYOH;
        Mon, 28 Jun 2021 20:00:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624899634;
        bh=M0DnGd73+rR7taODQKoTgVf9+ImVBLjQ8MTC3NOALTY=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=VBhYHlr8L1/o6TY9OzSD4/72Z9H0eSuVjc8sbSMdWSW+3MwJJshmlPJCXREoAZkV6
         IYL/nOW1X3EpcHLML9XxiYh4i/LEBw44uXMBdeLXTTNX3RMXgaX1g/0cKkdBVluike
         ehsOuCBxCfu6ManQR+alJNiOz04enI451m8c5Rbc=
Authentication-Results: myt6-b15a496b05fb.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-89cdf5c4a3a5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TxGWe6wNjS-0X30BiGr;
        Mon, 28 Jun 2021 20:00:33 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210628124814.1001507-1-stsp2@yandex.ru>
 <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <9a7962d1-7eee-620b-5b30-ffcc123c324c@yandex.ru>
 <CALMp9eQyhPO_Dpg8J0ZQ7jEnobAT5ydngB+x9OnFRyBU030E6w@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <921c5c59-f8cf-8204-8ff9-b82d3ea6f95f@yandex.ru>
Date:   Mon, 28 Jun 2021 20:00:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQyhPO_Dpg8J0ZQ7jEnobAT5ydngB+x9OnFRyBU030E6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 19:50, Jim Mattson пишет:
> I don't know how you can inject an interrupt with KVM_SET_REGS, but I
> suspect that you're doing something wrong. :-)
>
>   If I wanted to inject an interrupt from userspace, I would use
> KVM_SET_LAPIC (assuming that the local APIC is active) to set the
> appropriate bit in IRRV. Before you can deliver an interrupt, you have
> to check the local APIC anyway, to see whether or not your interrupt
> would be blocked by PPR.

I do not use any of the emulated
HW in KVM. PIC is in user-space,
and no apic. This is a very simple
hypervisor for running the ring3
code only.
So to inject an interrupt, I create
a stack frame and set eflags/cs/eip
to the needed values, and that's all.
Just as people did in a pre-KVM era. :)

