Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C68A48EAE4
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiANNid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:38:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241309AbiANNic (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642167512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YhO8ftDsk4+jW9Ti1jjOdqgLJ1dfN2h8UN/qErYWEn4=;
        b=Ry8hiHlKKBix2amcS81F1JR6UVcJbFT28/t5lOMo665F3WJvsoPA0VhY09fWG5nwC6lcX7
        q5TQqeJRauNWdDaHozt8Eq2mHIDTFy6xQoyhKQS1tXjGhCwYbQSFcHiyXY8bg1ACvJfdzY
        iVoYy9yoD99C13n4bm/rq47Ygepmw18=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-7xthMk4pNUmEF-Laa_Sp8A-1; Fri, 14 Jan 2022 08:38:30 -0500
X-MC-Unique: 7xthMk4pNUmEF-Laa_Sp8A-1
Received: by mail-pj1-f71.google.com with SMTP id a22-20020a17090abe1600b001b39929b5fdso9107531pjs.0
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 05:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YhO8ftDsk4+jW9Ti1jjOdqgLJ1dfN2h8UN/qErYWEn4=;
        b=Or+/9XmezZqkbkzVtP7PKft9Vo5Pl0mgN7G1s2nnEmxPsVYOgA3Yo1Y44I7IODP4vy
         Khs99hNz6DstW9bWGXwt4eJ1JXDfXKmWimWFbK1eVZ/7QvfnKWejO0d208RR+FNrX497
         9+D03VnT4JmsbFXZ5HpFTwiyJRpVytJx9efqFrmLYDFc/jcQmx9iTlBBnyhDoxsHnHmw
         C6TwlxwFz+t1ABTFGyV3twYeZCruAE1G53WjFJFA3X9dvR78fCZFxfqT0F9573pXUrvf
         S/zpu+L3cVnxkxRS9yx3SWhMPCywM/VRuW0vEk3MrjtDxWJL1NyQaaOHJaMvQOQz1vDW
         YMNA==
X-Gm-Message-State: AOAM531TeKb0KgzTYksykLWFZK1rhuE4k3L0r08nEhDK28pR/wFjVwVK
        JWoe0/ymDx5jZhZ/gaS4FxEVtpCk+nQznouhwZsJhPoCiILZIvIJmcYSeb8z6S/wRRwHpotVM5U
        Vogkn+BIO8tT9
X-Received: by 2002:a17:902:a502:b0:149:c5a5:5329 with SMTP id s2-20020a170902a50200b00149c5a55329mr9559619plq.164.1642167509352;
        Fri, 14 Jan 2022 05:38:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxILsnBPX9TsvIa9qO8Uq+U+Jo4SOThql41KRmDC+m0uXyl0MuvIPYYRITKGIUaFyG3qpSUrA==
X-Received: by 2002:a17:902:a502:b0:149:c5a5:5329 with SMTP id s2-20020a170902a50200b00149c5a55329mr9559603plq.164.1642167509120;
        Fri, 14 Jan 2022 05:38:29 -0800 (PST)
Received: from steredhat (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id g7sm5820333pfu.61.2022.01.14.05.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:38:28 -0800 (PST)
Date:   Fri, 14 Jan 2022 14:38:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220114133816.7niyaqygvdveddmi@steredhat>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <20220114074454-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220114074454-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 07:45:35AM -0500, Michael S. Tsirkin wrote:
>On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
>> In vhost_enable_notify() we enable the notifications and we read
>> the avail index to check if new buffers have become available in
>> the meantime.
>>
>> We are not caching the avail index, so when the device will call
>> vhost_get_vq_desc(), it will find the old value in the cache and
>> it will read the avail index again.
>>
>> It would be better to refresh the cache every time we read avail
>> index, so let's change vhost_enable_notify() caching the value in
>> `avail_idx` and compare it with `last_avail_idx` to check if there
>> are new buffers available.
>>
>> Anyway, we don't expect a significant performance boost because
>> the above path is not very common, indeed vhost_enable_notify()
>> is often called with unlikely(), expecting that avail index has
>> not been updated.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>... and can in theory even hurt due to an extra memory write.
>So ... performance test restults pls?

Right, could be.

I'll run some perf test with vsock, about net, do you have a test suite 
or common step to follow to test it?

Thanks,
Stefano

