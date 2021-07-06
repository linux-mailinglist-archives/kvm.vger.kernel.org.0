Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353B33BD499
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbhGFMOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:35 -0400
Received: from forward102j.mail.yandex.net ([5.45.198.243]:59255 "EHLO
        forward102j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238498AbhGFMJH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:09:07 -0400
Received: from myt5-1892386aa303.qloud-c.yandex.net (myt5-1892386aa303.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4323:0:640:1892:386a])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 4F0D0F20AFF;
        Tue,  6 Jul 2021 15:06:27 +0300 (MSK)
Received: from myt5-89cdf5c4a3a5.qloud-c.yandex.net (myt5-89cdf5c4a3a5.qloud-c.yandex.net [2a02:6b8:c12:289b:0:640:89cd:f5c4])
        by myt5-1892386aa303.qloud-c.yandex.net (mxback/Yandex) with ESMTP id cftkzOqST2-6QIuZM7g;
        Tue, 06 Jul 2021 15:06:27 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625573187;
        bh=bWhW4xbIU0foB+1vY5bZzoaCcvH8gAkkGUUfpILN4pE=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=YbVpnhkTvQ5sORCFIdUCAfL83J1JRJnCfrDMsLYC6Kpyijia27B9f2afXp0a/AkWm
         N01vqh90lpSMzHyCM4sbe5NFSApQwatP4VEBAPIwk6LcOAaCwImlMlBkAGFGR4jICP
         HKpf//egMNwAz9FDSgz0X8kF+saXhij/4f8J7sys=
Authentication-Results: myt5-1892386aa303.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-89cdf5c4a3a5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 0JWzyvF38O-6PPKs9vn;
        Tue, 06 Jul 2021 15:06:25 +0300
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
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
Date:   Tue, 6 Jul 2021 15:06:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

06.07.2021 14:49, Maxim Levitsky пишет:
> Now about the KVM's userspace API where this is exposed:
>   
> I see now too that KVM_SET_REGS clears the pending exception.
> This is new to me and it is IMHO *wrong* thing to do.
> However I bet that someone somewhere depends on this,
> since this behavior is very old.

What alternative would you suggest?
Check for ready_for_interrupt_injection
and never call KVM_SET_REGS if it indicates
"not ready"?
But what if someone calls it nevertheless?
Perhaps return an error from KVM_SET_REGS
if exception is pending? Also KVM_SET_SREGS
needs some treatment here too, as it can
also be called when an exception is pending,
leading to problems.


> This doesn't affect qemu since when it does KVM_SET_REGS,
> it also does KVM_SET_VCPU_EVENTS afterward, and that
> restores either pending or injected exception state.
> (that state is first read with KVM_GET_VCPU_EVENTS ioctl).
>   
> Also note just for reference that KVM_SET_SREGS has ability
> to set a pending interrupt, something that is also redundant
> since KVM_SET_VCPU_EVENTS does this.
> I recently added KVM_SET_SREGS2 ioctl which now lacks this
> ability.
>
> KVM_SET_VCPU_EVENTS/KVM_GET_VCPU_EVENTS allows to read/write
> state of both pending and injected exception and on top of that
> allows to read/write the exception payload of a pending exception.
>
> You should consider using it to preserve/modify the exception state,
> although the later isn't recommended (qemu does this in few places,
> but it is a bit buggy, especially in regard to nested guests).
I need neither to preserve nor modify
the exception state. All I need is to safely
call KVM_SET_REGS/KVM_SET_SREGS, but
that appears unsafe when exception is
pending.

Please take a look into this commit:
https://www.lkml.org/lkml/2020/12/1/324

It was suggested that the removal
of "!kvm_event_needs_reinjection(vcpu)"
condition from kvm_vcpu_ready_for_interrupt_injection()
is what introduced the problem, as
right now ready_for_interrupt_injection
doesn't account for pending exception.
I already added the check to my
user-space code, and now it works
reliably on some very old kernels
prior to the aforementioned patch.
So should we treat that as a regressions,
or any other proposal?

