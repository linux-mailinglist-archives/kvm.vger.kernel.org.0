Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D2F2AAA3F
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 10:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgKHJR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 04:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726206AbgKHJRy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 8 Nov 2020 04:17:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604827073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+SyHTLXvA92ERGNZfFFmss47jMa+rGIK1ltcexiZx8=;
        b=MTTrWfgLA3OvU+vI+OICrKFS5VcoHNr1YDdL3OiqW3maxXW6DxpHAYudUG8+UoQOs1o1xt
        o0txZdKCdWw2+X1CjdKjV+/zGF2BU1jR7i41qkVyffqEk0WOujD/My3RRT+TLWnCFh3PBp
        RtKyAVbmfz+17u4bW3lkXvSOnAgBHp8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-BcsC9C7dNFaNrphtVUd1SQ-1; Sun, 08 Nov 2020 04:17:51 -0500
X-MC-Unique: BcsC9C7dNFaNrphtVUd1SQ-1
Received: by mail-wm1-f69.google.com with SMTP id k128so382597wme.7
        for <kvm@vger.kernel.org>; Sun, 08 Nov 2020 01:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u+SyHTLXvA92ERGNZfFFmss47jMa+rGIK1ltcexiZx8=;
        b=gLrhZhnzkaEc+cJmryqPDa5rUquYBLHkaZMEH4Jh5aEdrgyqFC2ZMYime5z3f5qjIZ
         Ry5A93El4ru/z+Nb0PGDiF3x7Sx0/5xJqfMcvekJEroL3K4vMo4j5Geu50U0XQj2xJQ6
         /S240/vbEHhjmhCdAKzn2F9+cGTe4oQSqem+MqwMlLXrmWEAmkRXd5LzzcJRq7iCTjdd
         G8ZTcKleoQk35YPZojWocyIvGKGfRngcTMTmNzsMBabKZikxgWFXJ62ksmZ+CB/ety/P
         WfYFcKJC9FS/7nK0QssWBo/7HjbdewJmUgjtzYdhAK8yXKA3cCTkDKgfvISNblYrMbUj
         aqKg==
X-Gm-Message-State: AOAM530k4G9168+IDVkViM6hLa6bTCvxfe7TddS2GoSPE8Ptfb4mr/0z
        yisLF6kfpK5n2ac3cbZyofzDZq+V/RwVntQGePIo+UR4a4Sf/EjGefFd7kxvp7Ob2bQtwjrp+GH
        e+R/Ouipgu4+B
X-Received: by 2002:adf:97dd:: with SMTP id t29mr12224609wrb.185.1604827070534;
        Sun, 08 Nov 2020 01:17:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy08lVb2EwMSaKb1c4rkEPpz4MxNziRJKopK1G2CeEdBzdBA7Q3j2i80FOCbZqEHTSG3V8yXQ==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr12224595wrb.185.1604827070386;
        Sun, 08 Nov 2020 01:17:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id y4sm8747871wmj.2.2020.11.08.01.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 01:17:49 -0800 (PST)
Subject: Re: [PATCH 2/3] vfio/virqfd: Drain events from eventfd in
 virqfd_wakeup()
To:     Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1faa5405-3640-f4ad-5cd9-89a9e5e834e9@redhat.com>
 <20201027135523.646811-1-dwmw2@infradead.org>
 <20201027135523.646811-3-dwmw2@infradead.org>
 <20201106162956.5821c536@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f45eeeba-2060-45cc-b5f5-140c3a83afd0@redhat.com>
Date:   Sun, 8 Nov 2020 10:17:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106162956.5821c536@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/20 00:29, Alex Williamson wrote:
>> From: David Woodhouse<dwmw@amazon.co.uk>
>>
>> Don't allow the events to accumulate in the eventfd counter, drain them
>> as they are handled.
>>
>> Signed-off-by: David Woodhouse<dwmw@amazon.co.uk>
>> ---
> Acked-by: Alex Williamson<alex.williamson@redhat.com>
> 
> Paolo, I assume you'll add this to your queue.  Thanks,
> 
> Alex
> 

Yes, thanks.

Paolo

