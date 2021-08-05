Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527563E0EF2
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhHEHNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231154AbhHEHNF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 03:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628147571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n0VxlG+I9DtspBlzYcgwvjsV5zD4hYtPEcF5uDUSb8k=;
        b=WnKShFfOo6rJV5EhQ9lb/uy7ktJQ7UGiYB787gx3g1QbQjDkMN2WZaPNV3i6eIIRfd7lWW
        xpPS6on/6Pslm66W77lCqGMyNUHz/W8xC7Pt8oXhPyihmDUVYm0crXhsdApFNo91BKeQti
        nD3m68uyx3SX8yz1rQkutZ6tX+65Omw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-ACWKzgHUMKCW-O7qionHTA-1; Thu, 05 Aug 2021 03:12:49 -0400
X-MC-Unique: ACWKzgHUMKCW-O7qionHTA-1
Received: by mail-pj1-f70.google.com with SMTP id z17-20020a17090ad791b029017763b6fe71so4449631pju.3
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 00:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=n0VxlG+I9DtspBlzYcgwvjsV5zD4hYtPEcF5uDUSb8k=;
        b=ossc/2L8IUUMNXqDrdp7UJi2Baoy7wOn61zvGqH6gumyYa7ZJSwGOi0b6l8nAhxVJc
         Wb/Ui/a4oWgEZ16Jlpjr3czn5MiRMRkkIpiohlCy8XrA5WUL8s+715Uc8L/ub6HiJpJc
         k/6E0tHkJyMiYer4YAP6A4KbrdeeIFiyVQErt2MBHf77sFa2BUaiNuntLCtRRYHMXau4
         u/U606AtnB0A4k1hCO2PH9IJV9g/SCGeqklrhi8ULcUxoDB33RSk+tMig0/X5q+Ej/el
         c1yKPJTk8vTXIDusjzNDT/n7IDIzEkeZVkB25LfWFJHqzMI0tmg0jJtPLcqlO7TFpnSL
         2eYQ==
X-Gm-Message-State: AOAM533Wxp5tquKelg4lnUZZc/DplZ/VoCzMtpd57zdv96MttFlMUXuG
        hHGm5wyGsBPcn6fqsSZN4s8bsszxRMe0hLq2f2DvNoZ9AJxyuXkEEOqhP1v70Y7/HYtCAczifPF
        IvR1Da0Kq+MVX
X-Received: by 2002:a63:190b:: with SMTP id z11mr654567pgl.320.1628147568774;
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUfHRxG/dXx9YH24cRrMopBNWNIkigiB28PNmXNoiyFNr8yDY8zBJY64Y2tGLqmxO/3wI2WA==
X-Received: by 2002:a63:190b:: with SMTP id z11mr654537pgl.320.1628147568588;
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k8sm5028086pfu.116.2021.08.05.00.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
Subject: Re: [PATCH v10 10/17] virtio: Handle device reset failure in
 register_virtio_device()
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-11-xieyongji@bytedance.com>
 <6bb6c689-e6dd-cfa2-094b-a0ca4258aded@redhat.com>
 <CACycT3v7BHxYY0OFYJRFU41Bz1=_v8iMRwzYKgX6cJM-SiNH+A@mail.gmail.com>
 <fdcb0224-11f9-caf2-a44e-e6406087fd50@redhat.com>
 <CACycT3v0EQVrv_A1K1bKmiYu0q5aFE=t+0yRaWKC7T3_H3oB-Q@mail.gmail.com>
 <bd48ec76-0d5c-2efb-8406-894286b28f6b@redhat.com>
 <CACycT3tUwJXUV24PK7OvzPrHYYeQ5Q3qUW_vbuFMjwig0dBw2g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ae529e8a-67a2-b235-1404-4623d57031d6@redhat.com>
Date:   Thu, 5 Aug 2021 15:12:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tUwJXUV24PK7OvzPrHYYeQ5Q3qUW_vbuFMjwig0dBw2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/8/4 下午5:07, Yongji Xie 写道:
> On Wed, Aug 4, 2021 at 4:54 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/8/4 下午4:50, Yongji Xie 写道:
>>> On Wed, Aug 4, 2021 at 4:32 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/8/3 下午5:38, Yongji Xie 写道:
>>>>> On Tue, Aug 3, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>>>>>> The device reset may fail in virtio-vdpa case now, so add checks to
>>>>>>> its return value and fail the register_virtio_device().
>>>>>> So the reset() would be called by the driver during remove as well, or
>>>>>> is it sufficient to deal only with the reset during probe?
>>>>>>
>>>>> Actually there is no way to handle failure during removal. And it
>>>>> should be safe with the protection of software IOTLB even if the
>>>>> reset() fails.
>>>>>
>>>>> Thanks,
>>>>> Yongji
>>>> If this is true, does it mean we don't even need to care about reset
>>>> failure?
>>>>
>>> But we need to handle the failure in the vhost-vdpa case, isn't it?
>>
>> Yes, but:
>>
>> - This patch is for virtio not for vhost, if we don't care virtio, we
>> can avoid the changes
>> - For vhost, there could be two ways probably:
>>
>> 1) let the set_status to report error
>> 2) require userspace to re-read for status
>>
>> It looks to me you want to go with 1) and I'm not sure whether or not
>> it's too late to go with 2).
>>
> Looks like 2) can't work if reset failure happens in
> vhost_vdpa_release() and vhost_vdpa_open().


Yes, you're right.

Thanks


>
> Thanks,
> Yongji
>

