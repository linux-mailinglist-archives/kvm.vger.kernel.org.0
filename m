Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E421273ADC
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 08:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgIVG1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 02:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729445AbgIVG1O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 02:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600756033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7G+bCvhy95HPHxeoyKaN/sNOB4HyNxDqXvDdb+Os9oY=;
        b=CQGa1eoFE7Kp39RsCNs1/Myn5UWyvlV9SoBgoQeQuN6h5AkmG8UvjlSWdq9FnGTyZlKNPN
        VVlzrA20HWvyyLYTqe0rpEZiZfWxuevp+Ts9CpK1sil0wYbqHmZR/D0ZoyLHfKKRj4W3lK
        IG7rfM0n+7//QxBjrHLSV43eVS/sSWY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-DicjLTOvM9m9aV8sWCe-4Q-1; Tue, 22 Sep 2020 02:27:11 -0400
X-MC-Unique: DicjLTOvM9m9aV8sWCe-4Q-1
Received: by mail-wm1-f72.google.com with SMTP id c200so505972wmd.5
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 23:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7G+bCvhy95HPHxeoyKaN/sNOB4HyNxDqXvDdb+Os9oY=;
        b=V83u6VYwN+uqiKes1gTB5smW9WJnFUO22nEg7QiteLfw0J9Dczz74OpX21LbHOfr/4
         I+KxRKYPxhtt8qqvsnBxSGgFcOxWoEYv1vD9GkuTA1zJSSc13TTnRpJFheWKmTO0Ac2F
         Mk7TSR8mSb2RIeEojw2NmMufCRNzP6IGSARHQP2aLMej8EwQscVe/Jp5Ts7JN7E/YW0c
         XG7VP28l77Ix7OgXk7FahbGxFyHO2r8K6cL7G1HDLwLmwQ3XAv5cmRUdwFaaC4suPUKa
         bdoX4lQmH63bQE8fawikZ1jHHEFZdvn481yY7AT7Rn/GKXC6sSwXonVM12TonUxkyh0s
         VkHA==
X-Gm-Message-State: AOAM531NnuYNlhgT4usxZppk/5IO/ZG9Hypzckz+TdLPPpdFg/Ubf+I8
        a8fWKhEPowGbQ1WDH3sa8kl7hD/2yuOQrFqxYcBdIRgyM9kl0oE//LSXXn8xFbxbOdpeBQZahIQ
        A/u7RN3d1ScUM
X-Received: by 2002:adf:fa0c:: with SMTP id m12mr3417792wrr.406.1600756029759;
        Mon, 21 Sep 2020 23:27:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7ORFOE+M4sZ1/hLsOYfDXOsipaSc5O+Pi6m5A0EYwqbK9SJpJMOv6iyB5CnFMJ42wvwz7zg==
X-Received: by 2002:adf:fa0c:: with SMTP id m12mr3417755wrr.406.1600756029493;
        Mon, 21 Sep 2020 23:27:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d153:8d0f:94cf:5114? ([2001:b07:6468:f312:d153:8d0f:94cf:5114])
        by smtp.gmail.com with ESMTPSA id a83sm2892268wmh.48.2020.09.21.23.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 23:27:08 -0700 (PDT)
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     qemu-riscv@nongnu.org, Fam Zheng <fam@euphon.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alberto Garcia <berto@igalia.com>, Jiri Slaby <jslaby@suse.cz>,
        Richard Henderson <rth@twiddle.net>, Peter Lieven <pl@kamp.de>,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Blake <eblake@redhat.com>, Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-block@nongnu.org,
        Stefan Weil <sw@weilnetz.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        John Snow <jsnow@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Liu Yuan <namei.unix@gmail.com>, Paul Durrant <paul@xen.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        xen-devel@lists.xenproject.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        sheepdog@lists.wpkg.org, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, Juan Quintela <quintela@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>
References: <20200921162346.188997-1-stefanha@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8892b73-6cee-9fd3-54b0-289149926041@redhat.com>
Date:   Tue, 22 Sep 2020 08:27:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921162346.188997-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/20 18:23, Stefan Hajnoczi wrote:
> clang's C11 atomic_fetch_*() functions only take a C11 atomic type
> pointer argument. QEMU uses direct types (int, etc) and this causes a
> compiler error when a QEMU code calls these functions in a source file
> that also included <stdatomic.h> via a system header file:
> 
>   $ CC=clang CXX=clang++ ./configure ... && make
>   ../util/async.c:79:17: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned int *' invalid)
> 
> Avoid using atomic_*() names in QEMU's atomic.h since that namespace is
> used by <stdatomic.h>. Prefix QEMU's APIs with qemu_ so that atomic.h
> and <stdatomic.h> can co-exist.
> 
> This patch was generated using:
> 
>   $ git diff | grep -o '\<atomic_[a-z0-9_]\+' | sort -u >/tmp/changed_identifiers
>   $ for identifier in $(</tmp/changed_identifiers64); do \
>        sed -i "s%\<$identifier\>%qemu_$identifier%" $(git grep -l "\<$identifier\>") \
>     done

It's certainly a good idea but it's quite verbose.

What about using atomic__* as the prefix?  It is not very common in QEMU
but there are some cases (and I cannot think of anything better).

Paolo

