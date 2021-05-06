Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FDC375585
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhEFOWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbhEFOWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 10:22:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDCEC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 07:21:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s6so6355738edu.10
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 07:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t9MSfhz8wMF3tZG8WRBgyPgiyyJAnX7W/qxJ671xWoM=;
        b=LJH5mMZ20Y3AoXxKlQcHTIOe3bl+a98UGZvriU2PurXQoR5ybz77ph2NiTazegoXLA
         nyjkA5pok7/z3aJB+S+2O2Lpu3nT4+7HOMAP1PBnN/zrVpNrWJFGWIFZrgkqxNBIZZAr
         mb6f4pMlcxCn4JFlmIGUsm0tsXHkC2HDUXAbutYq2TleB5X993GacMW6+hRPUtb1g+11
         FvtE/BILoHZZ4Z1NaxYqCzj7QtzEa/n3YTzyiwVee6IOY6Lx+2CEvnnGiDG0wqAZH6Uq
         qSW52Q5SXdF9q0450wEzc1C93p1irlfG8GjcE69D4v5iuQy+xo6XtrdI9C+u392tFvaS
         IgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t9MSfhz8wMF3tZG8WRBgyPgiyyJAnX7W/qxJ671xWoM=;
        b=mfeXYzNRKxRbdxM41Je4OPBfEFrWf6bl65ukVtDzOXGHEy6eVgj1jNLoxLYOb1JK0r
         M70rosDQLwLaGIPlk0Lez7RmZODevR1QGshKPdAWdN6IIbyVwGtCzGBspLG94TbCV0Nx
         a3leEXt1cti5iuzurd3uKd0j9Pqr0yrot60jNm/HqcKMPEzLjD0tQZG4xMKui7P9axPH
         uKeY1CR2oSbcbQL07vaEg0koDJBqqQyS0y7sYyZkJY9a6QsjBuY6ByMMMv0rXcx6k23a
         ElEACKzcc396woJwkSDUbCkYEBAXjl42P6YfgkjRr/g6yyrn+W/dgbaz2i0EOGSNbJxw
         D3sg==
X-Gm-Message-State: AOAM533Xhct62HYU3k4d+jhbQmBfPu4Hzl1yKQx0HMJw1tRImLMLJ3PO
        tzLYbvtA1kzAlyX2H+Yanf2hhKB1XCK6mK6kj6NL3fBwrgBMsw==
X-Google-Smtp-Source: ABdhPJxEQwnMoy7/2nuHnosZZdus1Q7o1rbwnC4Wcg8eh66gIgE6jve/dRr62bTKsnfjoStgWL/uN3drhQuQsko3WUo=
X-Received: by 2002:a05:6402:1d8f:: with SMTP id dk15mr2695462edb.146.1620310905518;
 Thu, 06 May 2021 07:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210506133758.1749233-1-philmd@redhat.com> <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
In-Reply-To: <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 6 May 2021 15:20:37 +0100
Message-ID: <CAFEAcA9VL_h8DdVwWWmOxs=mNWj-DEHQu-U4L6vb_H4cGMZpPA@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Warner Losh <imp@bsdimp.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 May 2021 at 15:17, Warner Losh <imp@bsdimp.com> wrote:
>
>
>
> On Thu, May 6, 2021, 7:38 AM Philippe Mathieu-Daud=C3=A9 <philmd@redhat.c=
om> wrote:
>>
>> The ALLOCA(3) man-page mentions its "use is discouraged".
>>
>> Replace it by a g_new() call.
>>
>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
>> ---
>>  bsd-user/syscall.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/bsd-user/syscall.c b/bsd-user/syscall.c
>> index 4abff796c76..dbee0385ceb 100644
>> --- a/bsd-user/syscall.c
>> +++ b/bsd-user/syscall.c
>> @@ -355,9 +355,8 @@ abi_long do_freebsd_syscall(void *cpu_env, int num, =
abi_long arg1,
>>      case TARGET_FREEBSD_NR_writev:
>>          {
>>              int count =3D arg3;
>> -            struct iovec *vec;
>> +            g_autofree struct iovec *vec =3D g_new(struct iovec, count)=
;
>
>
> Where is this freed?

g_autofree, so it gets freed when it goes out of scope.
https://developer.gnome.org/glib/stable/glib-Miscellaneous-Macros.html#g-au=
tofree

> Also, alloca just moves a stack pointer, where malloc has complex interac=
tions. Are you sure that's a safe change here?

alloca()ing something with size determined by the guest is
definitely not safe :-) malloc as part of "handle this syscall"
is pretty common, at least in linux-user.

thanks
-- PMM
