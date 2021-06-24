Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243403B3530
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFXSH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXSH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 14:07:27 -0400
Received: from forward106p.mail.yandex.net (forward106p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D366C061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:05:08 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward106p.mail.yandex.net (Yandex) with ESMTP id 9920E1C800B3;
        Thu, 24 Jun 2021 21:05:04 +0300 (MSK)
Received: from vla1-bf865e4901fb.qloud-c.yandex.net (vla1-bf865e4901fb.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:c86:0:640:bf86:5e49])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 9523561E0004;
        Thu, 24 Jun 2021 21:05:04 +0300 (MSK)
Received: from vla5-047c0c0d12a6.qloud-c.yandex.net (vla5-047c0c0d12a6.qloud-c.yandex.net [2a02:6b8:c18:3484:0:640:47c:c0d])
        by vla1-bf865e4901fb.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 6ICJnJv1Rr-54IiosOA;
        Thu, 24 Jun 2021 21:05:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624557904;
        bh=gN3iWpbgFnqIALtsKUoiEgMa3KaKp76JEDGf37e2r54=;
        h=In-Reply-To:To:Subject:From:Message-ID:Cc:Date:References;
        b=neRP2FmcBIaEWds+InXvAV68qO43hkvWuDHLjK/+WQlkWE8Le37aNaVVne6Li0JoU
         FoDoeANe7o61xNr6e5ZlrrfEB7o97kRaZ7ELtbyrh+SJqHzIuBttkqzfCJxkqQSaxI
         SB8Jx7OH1DT2406E6zUDISO3jVqfMVV43wTFHdds=
Authentication-Results: vla1-bf865e4901fb.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-047c0c0d12a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id m8RId1vfZi-544mdgth;
        Thu, 24 Jun 2021 21:05:04 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   stsp <stsp2@yandex.ru>
Subject: exception vs SIGALRM race on core2 CPUs (with qemu-based test-case
 this time!)
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
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
 <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
 <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
Message-ID: <064bbd96-1a17-8929-6961-4f41f44fe884@yandex.ru>
Date:   Thu, 24 Jun 2021 21:05:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

24.06.2021 03:25, stsp пишет:
> What does this test-case do?
> It provokes the PF by writing to
> the NULL pointer. The PF handler
> checks if PF is coming from the
> right place, or from the nearby
> IRQ8 timer handler. If PF is coming
> from the very first instruction of
> the timer handler, then we got
> that nasty SIGALRM race and
> KVM exited to user-space with
> the pending PF exception.
>
> How to replicate the buggy setup? 
Since I don't think anyone wanted
to install dosemu2, I now created
the qemu-based reproducer.
Unfortunately, even with qemu
you still need the real core2 CPU
to reproduce.
At least I don't know how to enable
the emulated VTx under qemu, but
maybe someone else knows.

So you need a disk image that I
uploaded here:

https://www.filemail.com/d/fvkwgqgcmrhsxmk 
<https://www.filemail.com/d/fvkwgqgcmrhsxmk>

And you can run it like so:

|qemu-system-x86_64 -hda disk.img -enable-kvm \ -cpu host -bios 
/usr/share/OVMF/OVMF_CODE.fd \ -device intel-hda -device hda-duplex -m 
2G The result on a core2 CPU will be like here: 
https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867838848 
"Race DETECTED" means that the test-case detected the page-fault coming 
from an interrupt handler, when it shouldn't. |

