Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C2A21BB4E
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgGJQtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:49:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34005 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727826AbgGJQtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594399777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RWQVFvxzHaI3cpGgJR2RIec5xz3c/DX2/Rl3zeUvHvs=;
        b=ioyZOd/2zRxfhrCq66NPVidazHeDQt91oqT7FLMIEX/uNe1iD4bRkblz2JdyxsJA5/ou8V
        UHBg/afQQ6BmthxYx77mU5ozaNcO8M4jTD7n4Bc3e8OUUGjw+3HyJWJKKMnORr4JoeUYod
        pgT9SydeZO9OFQKz8IPYfVhx4oFD1qo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-ngaQxcwZMFWvv8ztEZnGTA-1; Fri, 10 Jul 2020 12:49:35 -0400
X-MC-Unique: ngaQxcwZMFWvv8ztEZnGTA-1
Received: by mail-wr1-f71.google.com with SMTP id 89so6552971wrr.15
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RWQVFvxzHaI3cpGgJR2RIec5xz3c/DX2/Rl3zeUvHvs=;
        b=OugmwfOEcasM3oyuyqwf6sNjkcRwAM4D2mJJ4jFphCUu/Pm5MhLbSu2DOzBRviv+b0
         JGWadyr5DNKxt0hBx8Vjw2ugL4JX/2icP7CwGkMdo09TRdntvKzW4tNcVPGyy9mCSTtn
         RoV8v3ewGpm9ONxtP3ktvPCAqiCZEfeotIx1B2a2ol+WIU6uO8wQu5T5INxnQ9M8H9d2
         8Q3PrjITD1aDGeeap8puN0xkqihUAKAVQXdG0YG06Jruq4H3kD+FrqMWWn9Ih/wUb1HZ
         dbhiDxQ7NbjZCxM+Woh2kWqwtVN0Ubl4fjhd39rTrHdLvgskbH62dHv/gf/LZBTjw1Ft
         2mJg==
X-Gm-Message-State: AOAM531a+5OX0m5mG7kCeyNBeDS30NJcIB+aov71Ivc+2k5ECTHXMF+p
        ULl9ICMXv7DBd0revLAKKfUpY/GNuF/it8Vm06eRvaYPkjkDVXHAadjPBQytXMiCZoSHbNeXkIT
        70l7oaUtJPD+U
X-Received: by 2002:a05:600c:218f:: with SMTP id e15mr5804734wme.187.1594399774646;
        Fri, 10 Jul 2020 09:49:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjo6cziBz4llXoygguBXC0MmjK/n5HwnK7mOi14NIUnh3IbVLS5JnI830gbTxvPqvRGFQvhw==
X-Received: by 2002:a05:600c:218f:: with SMTP id e15mr5804708wme.187.1594399774384;
        Fri, 10 Jul 2020 09:49:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id d28sm10364646wrc.50.2020.07.10.09.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 09:49:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net> <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
 <20200709191307.GH780932@habkost.net>
 <79aa7955-6bc1-d8b2-fed0-48a0990d9dea@redhat.com>
 <20200710160219.GQ780932@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <654ac020-5f6b-9d71-a84f-9c435f5aa0cf@redhat.com>
Date:   Fri, 10 Jul 2020 18:49:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710160219.GQ780932@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 18:02, Eduardo Habkost wrote:
> On Fri, Jul 10, 2020 at 09:22:42AM +0200, Paolo Bonzini wrote:
>> On 09/07/20 21:13, Eduardo Habkost wrote:
>>>> Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
>>>> mode, so that the hypervisor can validate the high bits in the PDPTEs?
>>> If the fix has additional overhead, is the additional overhead
>>> bad enough to warrant making it optional?  Most existing
>>> GUEST_MAXPHYADDR < HOST_MAXPHYADDR guests already work today
>>> without the fix.
>>
>> The problematic case is when host maxphyaddr is 52.  That case wouldn't
>> work at all without the fix.
> 
> What can QEMU do to do differentiate "can't work at all without
> the fix" from "not the best idea, but will probably work"?

Blocking guest_maxphyaddr < host_maxphyaddr if maxphyaddr==52 would be a
good start.  However it would block the default configuration on IceLake
processors (which is why Mohammed looked at this thing in the first place).

Paolo

