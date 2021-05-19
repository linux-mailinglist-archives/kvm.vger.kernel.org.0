Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE28388F1E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353707AbhESNax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:30:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353700AbhESNaw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 09:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621430972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Utix8t6spaKb207Zj7UyYQmhE/BXGv3+F72MAkz+g6c=;
        b=Ky/yzhgso1H+eOGamHupsO5oIuOp5PkM73OZARHbhAet5XUt5m5SS7NgXF/9neC/4f/SOO
        nXXRL/h7JXwzsGeKFMzYC52lbbegXxZtoI5VcZ0naXdfi4MeevtzyCSaVZGmDEyIthKukW
        MKqugPI9SXNsHeZIskXrwz2HPcI8VVg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-pDuMJ2Q_NIqqSyhW_VUYWQ-1; Wed, 19 May 2021 09:29:28 -0400
X-MC-Unique: pDuMJ2Q_NIqqSyhW_VUYWQ-1
Received: by mail-wr1-f69.google.com with SMTP id x10-20020adfc18a0000b029010d83c83f2aso7151994wre.8
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 06:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Utix8t6spaKb207Zj7UyYQmhE/BXGv3+F72MAkz+g6c=;
        b=gjiD5FarWpq8nzFpBsJjCJoOe1a/hpyk3lBOkbOxIxxfp1RtSIOx1sa/QZBNNGJEPr
         rtnbEdwbabPfmX8VJWLbV1ec+0LGgYL3ZSbNPbBdqvGkpQTEwQL3BOTgTlZIWhWCxvsS
         UbKu9VC9cyOQwIAfoCcVHGEUzgJZNsYIK880bPbj3EbE1hYrxDWzL5QkwOKNEIKm0MJQ
         AZm5JZPjqjUTOIDXZ7ET2rV8jfujFiVxi4ateZs5gJZNLS3xewpi6KBLrClTh+evwxwQ
         7TD4ffZ1btcsrlmFS76VnWPB65zQQVH3At9FF5ak4JBRZnYjwsUy99+hRdMjACUm1GD2
         U9YA==
X-Gm-Message-State: AOAM530uHH1LUWiaircRD+v4g4vlN71Qgeeb6ba7Yjh+MthPJKl4y4w1
        RkqgcDSelv0n8b4FJF634RUxok2oxYqbywd2jOZAe8Y9d79Zf8PakI6tPVq6tprOR9pnXq5rUUc
        gHF5NxjTuOZfR
X-Received: by 2002:a5d:4946:: with SMTP id r6mr7406502wrs.123.1621430967435;
        Wed, 19 May 2021 06:29:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5mZQHnE/EnIv4pnudlM+/lE7mYzi7oQJa6EidXFKUYAuQiAiWM9tIETxbilaUxzeh7C/zPA==
X-Received: by 2002:a5d:4946:: with SMTP id r6mr7406476wrs.123.1621430967215;
        Wed, 19 May 2021 06:29:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l18sm25469067wrt.97.2021.05.19.06.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 06:29:26 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anup Patel <anup@brainfault.org>, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <YKSa48cejI1Lax+/@kroah.com>
 <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
 <YKSgcn5gxE/4u2bT@kroah.com> <YKTsyyVYsHVMQC+G@kroah.com>
 <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
 <YKUDWgZVj82/KiKw@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <daa30135-8757-8d33-a92e-8db4207168ff@redhat.com>
Date:   Wed, 19 May 2021 15:29:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKUDWgZVj82/KiKw@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 14:23, Greg Kroah-Hartman wrote:
>> - the code could be removed if there's no progress on either changing the
>> RISC-V acceptance policy or ratifying the spec
> 
> I really do not understand the issue here, why can this just not be
> merged normally?

Because the RISC-V people only want to merge code for "frozen" or 
"ratified" processor extensions, and the RISC-V foundation is dragging 
their feet in ratifying the hypervisor extension.

It's totally a self-inflicted pain on part of the RISC-V maintainers; 
see Documentation/riscv/patch-acceptance.rst:

   We'll only accept patches for new modules or extensions if the
   specifications for those modules or extensions are listed as being
   "Frozen" or "Ratified" by the RISC-V Foundation.  (Developers may, of
   course, maintain their own Linux kernel trees that contain code for
   any draft extensions that they wish.)

(Link: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/riscv/patch-acceptance.rst)

> All staging drivers need a TODO list that shows what needs to be done in
> order to get it out of staging.  All I can tell so far is that the riscv
> maintainers do not want to take this for "unknown reasons" so let's dump
> it over here for now where we don't have to see it.
> 
> And that's not good for developers or users, so perhaps the riscv rules
> are not very good?

I agree wholeheartedly.

I have heard contrasting opinions on conflict of interest where the 
employers of the maintainers benefit from slowing down the integration 
of code in Linus's tree.  I find these allegations believable, but even 
if that weren't the case, the policy is (to put it kindly) showing its 
limits.

>> Of course there should have been a TODO file explaining the situation. But
>> if you think this is not the right place, I totally understand; if my
>> opinion had any weight in this, I would just place it in arch/riscv/kvm.
>>
>> The RISC-V acceptance policy as is just doesn't work, and the fact that
>> people are trying to work around it is proving it.  There are many ways to
>> improve it:
> 
> What is this magical acceptance policy that is preventing working code
> from being merged?  And why is it suddenly the rest of the kernel
> developer's problems because of this?

It is my problem because I am trying to help Anup merging some perfectly 
good KVM code; when a new KVM port comes up, I coordinate merging the 
first arch/*/kvm bits with the arch/ maintainers and from that point on 
that directory becomes "mine" (or my submaintainers').

Paolo

