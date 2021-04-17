Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C963B363032
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhDQNLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:11:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235087AbhDQNLq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618665080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ea9ZS/ujqV/UqrWzcxyrISfo7DzpHiETd5sLVIqOMK4=;
        b=DyMY4KzMtAuSnmscRgUGX4aOi4VFUh4TO8Vn61VS7v97ZiD2FXe7otaR9S5uxS7wXzM9lA
        k7jFSzXIHoYhWAYyZKQJmwlHX1RxAYMYMdGaX18T5lJIoaqa8k3XwKHDr1fCO9gi3VtJiQ
        pqSn+kKYGPrnHj2Ag2jInsAYxxiVmbM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-2jJIwCZCNmmY6y-5P79hKw-1; Sat, 17 Apr 2021 09:11:18 -0400
X-MC-Unique: 2jJIwCZCNmmY6y-5P79hKw-1
Received: by mail-ed1-f72.google.com with SMTP id bm19-20020a0564020b13b02903789d6e74b5so8580546edb.21
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ea9ZS/ujqV/UqrWzcxyrISfo7DzpHiETd5sLVIqOMK4=;
        b=r++G44SZKaVH3d/m6mBj49zsbX/E08Y8xxx6i3zlJOQ7lUa7NH/FlqGslWW5++2YP/
         /OHETbZoIl/cXEE1uSq1fPP/lfoZnJ/VsRffH83cqsYL21acU3gDf+NBqpJEQcPr8oag
         bk3fIyjj65Kg9j86sv0t+BKJVNqDRniyw/81msvhYsZ68ASv+q3BG+GmvtSyesSydJ3n
         x1rbsibZ+NtPGKnhhQ3ZdbKRLuRcZ+cm0iuXZ1piD5FyPhcDSwGRD9TTiHK4ionPwft/
         XdF9hvM8qxjJWSK11L9YSJXQ21VdtEWdQBUdQ9pj8febp0IpCmgabIAedxRlvI81u5Pg
         Ti8Q==
X-Gm-Message-State: AOAM533Qta+sLk+kfSI++W4ydUR7Locu8FajtEfOdhjm+hJxEeEeC7HE
        8DDyG0M17ZQ4u2fSuZRt5rVsVoOZAyMFY6ZnRJ6IDGYDPi8USJjiQsTESa+sxrool9v+yFMYOAB
        Z7LKQLq3Km9uZ
X-Received: by 2002:a17:906:747:: with SMTP id z7mr13373168ejb.192.1618665077195;
        Sat, 17 Apr 2021 06:11:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwapFnRNlqIf5QRLiyv3IpVASga4nItuEE7TyxPVXQJNLwTdqMdhPrJlWoHy1tBU1aSwsc7A==
X-Received: by 2002:a17:906:747:: with SMTP id z7mr13373148ejb.192.1618665077000;
        Sat, 17 Apr 2021 06:11:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id kj24sm6375414ejc.49.2021.04.17.06.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:11:16 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: Fixes and a cleanup for coalesced MMIO
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hao Sun <sunhao.th@gmail.com>
References: <20210412222050.876100-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <159d0b9c-c50b-3829-0212-acb30d6c1ae0@redhat.com>
Date:   Sat, 17 Apr 2021 15:11:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210412222050.876100-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/21 00:20, Sean Christopherson wrote:
> Fix two bugs that are exposed if unregistered a device on an I/O bus fails
> due to OOM.  Tack on opportunistic cleanup in the related code.
>   
> Sean Christopherson (3):
>    KVM: Destroy I/O bus devices on unregister failure _after_ sync'ing
>      SRCU
>    KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
>    KVM: Add proper lockdep assertion in I/O bus unregister
> 
>   include/linux/kvm_host.h  |  4 ++--
>   virt/kvm/coalesced_mmio.c | 19 +++++++++++++++++--
>   virt/kvm/kvm_main.c       | 26 ++++++++++++++++----------
>   3 files changed, 35 insertions(+), 14 deletions(-)
> 

Queued, thanks.

Paolo

