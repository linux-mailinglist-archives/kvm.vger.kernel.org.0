Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553E137564B
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhEFPNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:13:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234888AbhEFPNp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 11:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620313967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8tYDSNcv5UzQ/xcUbWrMkGssUcVC3SKIEN1tpM5zmc=;
        b=Ea60mf/LHAJnEyGt6t9tcNI5vF1FqVUril65awj6bVyHhLjvGVukPmyF5E03x9IB8dqfMo
        EP6qUTVEVBAA+8GySOTGz+CQ6EewNd8UFh57HNqeNJkESPAOWu9xqFtj4bHZ7wHHkfA4kC
        /QK22ctB+7bhd1MEJRFoVrFDw1VEoyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-BrEZIubMPOmG5Z_twMd7xw-1; Thu, 06 May 2021 11:12:43 -0400
X-MC-Unique: BrEZIubMPOmG5Z_twMd7xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A3DF107ACC7;
        Thu,  6 May 2021 15:12:42 +0000 (UTC)
Received: from [10.3.113.56] (ovpn-113-56.phx2.redhat.com [10.3.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA1315D9E3;
        Thu,  6 May 2021 15:12:27 +0000 (UTC)
To:     Warner Losh <imp@bsdimp.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
 <39f12704-af5c-2e4f-d872-a860d9a870d7@redhat.com>
 <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
Message-ID: <7a96d45e-2bdc-f699-96f7-3fbf607cb06b@redhat.com>
Date:   Thu, 6 May 2021 10:12:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 9:55 AM, Warner Losh wrote:

>>> Where is this freed? Also, alloca just moves a stack pointer, where
>> malloc
>>> has complex interactions. Are you sure that's a safe change here?
>>
>> It's freed any time the g_autofree variable goes out of scope (that's
>> what the g_autofree macro is for).  Yes, the change is safe, although
>> you are right that switching to malloc is going to be a bit more
>> heavyweight than what alloca used.  What's more, it adds safety: if
>> count was under user control, a user could pass a value that could cause
>> alloca to allocate more than 4k and accidentally mess up stack guard
>> pages, while malloc() uses the heap and therefore cannot cause stack bugs.
>>
> 
> I'm not sure I understand that argument, since we're not compiling bsd-user
> with the stack-smash-protection stuff enabled, so there's no guard pages
> involved. The stack can grow quite large and the unmapped page at
> the end of the stack would catch any overflows. Since these allocations
> are on the top of the stack, they won't overflow into any other frames
> and subsequent calls are made with them already in place.

With alloca() on user-controlled size, the user can set up the size to
be larger than the unmapped guard page, at which point you CANNOT catch
the stack overflow because the alloca can skip the guard page and wrap
into other valid memory.  Compiling with stack-smash-protection stuff
enabled will catch such a bad alloca(); but the issue at hand here is
not when stack-smash-protection is enabled, but the more common case
when it is disabled (at which point the only protection you have is the
guard page, but improper use of alloca() can bypass the guard page).
Not all alloca() arguments are under user control, but it is easier as a
matter of policy to blindly avoid alloca() than it is to audit which
calls have safe sizes and therefore will not risk user control bypassing
stack guards.

> 
> malloc, on the other hand, involves taking out a number of mutexes
> and similar things to obtain the memory, which may not necessarily
> be safe in all the contexts system calls can be called from. System
> calls are, typically, async safe and can be called from signal handlers.
> alloca() is async safe, while malloc() is not. So changing the calls
> from alloca to malloc makes calls to system calls in signal handlers
> unsafe and potentially introducing buggy behavior as a result.

Correct, use of malloc() is not safe within signal handlers. But these
calls are not within signal handlers - or am _I_ missing something?  Is
the point of *-user code to emulate syscalls that are reachable from
code installed in a signal handler, at which point introducing an
async-unsafe call to malloc in our emulation is indeed putting the
application at risk of a malloc deadlock?

Ultimately, we're trading one maintenance headache (determining which
alloca() size calls might be under user control) for another
(determining that malloca() calls are not in a signal context), but the
latter is far more common such that we can use existing tooling to make
that conversion safely (both in the fact that the compiler has flags to
warn about alloca() usage, and in the fact that Coverity is good at
flagging improper uses of malloc() such as within a function reachable
from something installed in a signal handler).  But I'm not familiar
enough with the bsd/linux-user code to know if your point about having
to use only async-safe functionalities is a valid limitation on our
emulation.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

