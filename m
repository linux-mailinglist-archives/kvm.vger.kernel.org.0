Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D13A6D3F
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhFNRe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 13:34:59 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:60944 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhFNRe7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 13:34:59 -0400
X-Greylist: delayed 153818 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 13:34:58 EDT
Received: from sas1-934f36a1872d.qloud-c.yandex.net (sas1-934f36a1872d.qloud-c.yandex.net [IPv6:2a02:6b8:c14:492:0:640:934f:36a1])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 52F62B20236;
        Mon, 14 Jun 2021 20:32:54 +0300 (MSK)
Received: from sas2-e7f6fb703652.qloud-c.yandex.net (sas2-e7f6fb703652.qloud-c.yandex.net [2a02:6b8:c14:4fa6:0:640:e7f6:fb70])
        by sas1-934f36a1872d.qloud-c.yandex.net (mxback/Yandex) with ESMTP id qSr9ps8flI-WsI4R7Mm;
        Mon, 14 Jun 2021 20:32:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1623691974;
        bh=gKax/7yFW+n4qLtEkltgr/65J+eqokYz3P+0zs3qglc=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=CrHAm6H6dWFQEwwrd/31C94zKyTzpR8AC9v7OdHExUBb9JvMX2zaqut7q+qCvbYB0
         MWE8FuLgQDTbQvTXebtO9dE057x7wNOaOtrDWHZbZOOh0TZpRXpusJBRB8ska8+Mb4
         N0/8Eqzuh2epeVZcFrzTghLsgrACNCRuyaBNc+Co=
Authentication-Results: sas1-934f36a1872d.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas2-e7f6fb703652.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id apm47wmcip-WrPuFTDE;
        Mon, 14 Jun 2021 20:32:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
Date:   Mon, 14 Jun 2021 20:32:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMeMov42fihXptQm@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

14.06.2021 20:06, Sean Christopherson пишет:
> On Sun, Jun 13, 2021, stsp wrote:
>> Hi kvm developers.
>>
>> I am having the strange problem that can only be reproduced on a core2duo CPU
>> but not AMD FX or Intel Core I7.
>>
>> My code has 2 ways of setting the guest registers: one is the guest's ring0
>> stub that just pops all regs from stack and does iret to ring3.  That works
>> fine.  But sometimes I use KVM_SET_SREGS and resume the VM directly to ring3.
>> That randomly results in either a good run or invalid guest state return, or
>> a page fault in guest.
> Hmm, a core2duo failure is more than likely due to lack of unrestricted guest.
> You verify this by loading kvm_intel on the Core i7 with unrestricted_guest=0.

Wow, excellent shot!
Indeed, the problem then starts
reproducing also there!
So at least I now have a problematic
setup myself, rather than needing
to ask for ssh from everyone involved. :)

What does this mean to us, though?
That its completely unrelated to any
memory synchronization?


>> I tried to analyze when either of the above happens exactly, and I have a
>> very strong suspection that the problem is in a way I update LDT. LDT is
>> shared between guest and host with KVM_SET_USER_MEMORY_REGION, and I modify
>> it on host.  So it seems like if I just allocated the new LDT entry, there is
>> a risk of invalid guest state, as if the guest's LDT still doesn't have it.
>> If I modified some LDT entry, there can be a page fault in guest, as if the
>> entry is still old.
> IIUC, you are updating the LDT itself, e.g. an FS/GS descriptor in the LDT, as
> opposed to updating the LDT descriptor in the GDT?

I am updating the LDT itself,
not modifying its descriptor
in gdt. And with the same
KVM_SET_SREGS call I also
update the segregs to the new
values, if needed.


> Either way, do you also update all relevant segments via KVM_SET_SREGS after
> modifying memory?

Yes, if this is needed.
Sometimes its not needed, and
when not - it seems page fault is
more likely. If I also update segregs -
then invalid guest state.
But these are just the statistical
guesses so far.


>     Best guess is that KVM doesn't detect that the VM has state
> that needs to be emulated, or that KVM's internal register state and what's in
> memory are not consistent.

Hope you know what parts are
emulated w/o unrestricted guest,
in which case we can advance. :)


> Anyways, I highly doubt this is a memory synchronization issue, a corner case
> related to lack of unrestricted guest is much more likely.

Just to be sure I tried the CD bit
in CR0 to rule out the caching
issues, and that changes nothing.
So...
What to do next?

