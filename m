Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C02037559B
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhEFO1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234002AbhEFO1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620311167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4iuE6eCW+gTRiFvl6fzIAuVjIl3+LmZF9xYYjhbaPYk=;
        b=BsbqGT44wZbzUDkCH3+KhXxXu+WNRUQERCcRg2SJyfn0aAoAhMIJmPACMx4ExtMCG7Py/c
        pZO+//Q4oAptcPEIV/4u5o5MWRpDXtK1tbriMuYZjmaqUO+UXf+kC7N4NbGDy1ebx0mVyB
        bQEpEGRtT7vkMbaiaItcWzxMfUlqGKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-VUj96t0uOsKt2Yn_3ajXeQ-1; Thu, 06 May 2021 10:25:57 -0400
X-MC-Unique: VUj96t0uOsKt2Yn_3ajXeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4465818BA281;
        Thu,  6 May 2021 14:25:56 +0000 (UTC)
Received: from [10.3.113.56] (ovpn-113-56.phx2.redhat.com [10.3.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E70A95D6D7;
        Thu,  6 May 2021 14:25:51 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Warner Losh <imp@bsdimp.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     kvm@vger.kernel.org, Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <39f12704-af5c-2e4f-d872-a860d9a870d7@redhat.com>
Date:   Thu, 6 May 2021 09:25:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 9:16 AM, Warner Losh wrote:
> On Thu, May 6, 2021, 7:38 AM Philippe Mathieu-Daudé <philmd@redhat.com>
> wrote:
> 
>> The ALLOCA(3) man-page mentions its "use is discouraged".
>>
>> Replace it by a g_new() call.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  bsd-user/syscall.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/bsd-user/syscall.c b/bsd-user/syscall.c
>> index 4abff796c76..dbee0385ceb 100644
>> --- a/bsd-user/syscall.c
>> +++ b/bsd-user/syscall.c
>> @@ -355,9 +355,8 @@ abi_long do_freebsd_syscall(void *cpu_env, int num,
>> abi_long arg1,
>>      case TARGET_FREEBSD_NR_writev:
>>          {
>>              int count = arg3;
>> -            struct iovec *vec;
>> +            g_autofree struct iovec *vec = g_new(struct iovec, count);
>>
> 
> Where is this freed? Also, alloca just moves a stack pointer, where malloc
> has complex interactions. Are you sure that's a safe change here?

It's freed any time the g_autofree variable goes out of scope (that's
what the g_autofree macro is for).  Yes, the change is safe, although
you are right that switching to malloc is going to be a bit more
heavyweight than what alloca used.  What's more, it adds safety: if
count was under user control, a user could pass a value that could cause
alloca to allocate more than 4k and accidentally mess up stack guard
pages, while malloc() uses the heap and therefore cannot cause stack bugs.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

