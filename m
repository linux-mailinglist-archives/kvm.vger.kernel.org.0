Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966603AC014
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 02:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhFRA11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 20:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbhFRA10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 20:27:26 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209B2C06175F
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 17:25:17 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso7965821otu.10
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 17:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfOxy6B9936aDr3FkxCQBFdYz6SUIfbRHNLIvfYjoy8=;
        b=nJM4kjVHo2pgFfFtO4EXrsUY7f1ptG1r+askYt8B9fLkJ0t5FtpfVarXxb0G4RvNbm
         3IUVG4Tffdah3RRkw5pNSysZ9wc5VptbdR/s0lzR3B+pAXpSEH/Kqpd+1mF0Lbn2BVv0
         d+4mAdo5uNNXZfFkcxkDWBG//jldV55Z3BKWj15ievJreu4qz84JVzZCuQhjafgbR2Mn
         2JBkPsriy8GCg4IMaOqHIt44+9RZosuAoGT3aRQNgQYPrZWge8ef5RuxT3rLFQjYJFKI
         daPILzWMOKtNrcPI8wN36kS9erz9Zg3U6YSPF2+rGyxYwRXQ1OW1H58DXT1Ewz9S3c28
         YYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfOxy6B9936aDr3FkxCQBFdYz6SUIfbRHNLIvfYjoy8=;
        b=GX44bDTc4Ul3k5KV1vPWvznkOWFXT+Hpo5d41JEWSS3p122CFtS5JnopSDhtQIehxL
         UZSjo3n+SU1uey+fA8HSMpvlpKQQ2I+Hwd4DceTQ88y7Tcgh7BU+OJia6qqUvJDkI00h
         e+sBenZBujaeUv/DKqEtTLUcSnz0dXrcmAsqeJwn0AV+OBRo/7sUd8dGrTT73G/tOJ2P
         AtE8ZjFQAl07o3AxrBR7dq3TbvppY9x4POpuhOGmCEbHEiO7rYuB4PMhaxLrf2NHQSmy
         PqzKV1aDaBZ+w0/4RaKjfj48E9h/1wpBhO65P3+7cVTWDryFsDFMfjuMAdDkjLL2GY7z
         MqHA==
X-Gm-Message-State: AOAM531h3xAdlkVIc25oz7AA4l8gSUB4ZPBW7zLZ3orG4y5a2NLyURxF
        6Y6OQ2L2pyxKhppNGNO3lKa3/mBAp0tE3n1trQgMNRKEE/w=
X-Google-Smtp-Source: ABdhPJzYkGMvEZViIH8DW46yytaNROBnd9a+z5yzIU+tvHWWy8wR2jgjKANsJhzAKGFBPycbV+OETmP0PxaH0wXzFqc=
X-Received: by 2002:a05:6830:2011:: with SMTP id e17mr6825485otp.295.1623975916039;
 Thu, 17 Jun 2021 17:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com> <20200603101131.2107303-1-efremov@linux.com>
In-Reply-To: <20200603101131.2107303-1-efremov@linux.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 17 Jun 2021 17:25:04 -0700
Message-ID: <CALMp9eSFkRrWLjegJ5OC7kZ4oWtZypKRDjXFQD5=tFX4YLpUgw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Use vmemdup_user()
To:     Denis Efremov <efremov@linux.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, joe@perches.com,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 3, 2020 at 3:10 AM Denis Efremov <efremov@linux.com> wrote:
>
> Replace opencoded alloc and copy with vmemdup_user().
>
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> Looks like these are the only places in KVM that are suitable for
> vmemdup_user().
>
>  arch/x86/kvm/cpuid.c | 17 +++++++----------
>  virt/kvm/kvm_main.c  | 19 ++++++++-----------
>  2 files changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..27438a2bdb62 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -182,17 +182,14 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>         r = -E2BIG;
>         if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
>                 goto out;
> -       r = -ENOMEM;
>         if (cpuid->nent) {
> -               cpuid_entries =
> -                       vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
> -                                          cpuid->nent));
> -               if (!cpuid_entries)
> -                       goto out;
> -               r = -EFAULT;
> -               if (copy_from_user(cpuid_entries, entries,
> -                                  cpuid->nent * sizeof(struct kvm_cpuid_entry)))
> +               cpuid_entries = vmemdup_user(entries,
> +                                            array_size(sizeof(struct kvm_cpuid_entry),
> +                                                       cpuid->nent));

Does this break memcg accounting? I ask, because I'm really not sure.
