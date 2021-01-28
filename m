Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC7306B64
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 04:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhA1DJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 22:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhA1DJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 22:09:04 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D4C06174A
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 19:08:24 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u4so3413785pjn.4
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 19:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OCdNhPJmC7cEUrAyAfKOn/wAW4PdZZrXFG/4tQQjPQ4=;
        b=P0Pd/oygpSt0zWxZCgkQGjNJxdKVF4iYlO0Ejjn+1jmy7UK7n1XhmLRo8SRQzQY45P
         AXa+UvkRIah/fiznL3X4ctGvEcvS/5o0+wc/chu8WnLomKzr5wGQJz2ZxQt1eTD43xIH
         Q/0VFiFYAtcUzAV6YRnyip21HoWMGsvQiOMLUqT4xpcKGkarV3NJIi+cyLjMi90mrTjR
         ylpt5eE54Brihm2k9p1yMc/5/DJtS8nJlxO0dkdLDk5fVy0o+gSehIjHTN6uoyk5TPII
         Dyy5AtOC0KNkkLxJCpyLZ6HHd5LUVAmqQ8cAbS/kgiD41mPUSk/I2OlNu2TWP48/AxpU
         fFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OCdNhPJmC7cEUrAyAfKOn/wAW4PdZZrXFG/4tQQjPQ4=;
        b=QcwpRG1P5DEoe8S56OIt6vwIrmW7w6bK9Lvl9HvJJE3pN8NWKC88w3XX3Sv4mXYy/h
         57em+1/NQw/YmLrKV4+TVks97TSfGA9YJGb8bcCOILUpBj/QpWk5VWu/p0fMcghFqLcc
         T+oCMMo9qWLx13qrcUwYFxb4Qik0oYRedczSJSsgB94481zC6DKjXBx0q04UImEx8ULC
         XLXhgAQI39uX8pfHrTry0t3VD/vucf3sRmICcjI9OHp0/p3uyX1sLxaspqsFpcWtnhwC
         Mmy4KnFcDS3aO65Vf3XFqk9jPdLgXsRc+Hw1BM7aNRuWJYnHMjBHLN6hcQs+LhYITx5S
         pcEg==
X-Gm-Message-State: AOAM530zWYgwh53mseXeRG2cNtVIn63lkBXugLtdCGBx9qpMgrRfEmca
        JdqucXrM14M53FClO1Q/bzgkkA==
X-Google-Smtp-Source: ABdhPJxKR7pCfxkcWkrPDHtoewg+dp+t9SIM2saaxXm86W9VBkJRdcBlBOukcAb5b9tgGsj7UoeFZA==
X-Received: by 2002:a17:902:59c1:b029:df:fd49:f08d with SMTP id d1-20020a17090259c1b02900dffd49f08dmr14313148plj.76.1611803302240;
        Wed, 27 Jan 2021 19:08:22 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b26sm3821272pfo.202.2021.01.27.19.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:08:21 -0800 (PST)
Subject: Re: [RFC v3 01/11] eventfd: track eventfd_signal() recursion depth
 separately in different cases
To:     Jason Wang <jasowang@redhat.com>,
        Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-2-xieyongji@bytedance.com>
 <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com>
 <CACycT3sN0+dg-NubAK+N-DWf3UDXwWh=RyRX-qC9fwdg3QaLWA@mail.gmail.com>
 <6a5f0186-c2e3-4603-9826-50d5c68a3fda@redhat.com>
 <CACycT3sqDgccOfNcY_FNcHDqJ2DeMbigdFuHYm9DxWWMjkL7CQ@mail.gmail.com>
 <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4e482f00-163a-f957-4665-141502cf4dff@kernel.dk>
Date:   Wed, 27 Jan 2021 20:08:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/21 8:04 PM, Jason Wang wrote:
> 
> On 2021/1/27 下午5:11, Yongji Xie wrote:
>> On Wed, Jan 27, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>> On 2021/1/20 下午2:52, Yongji Xie wrote:
>>>> On Wed, Jan 20, 2021 at 12:24 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>> On 2021/1/19 下午12:59, Xie Yongji wrote:
>>>>>> Now we have a global percpu counter to limit the recursion depth
>>>>>> of eventfd_signal(). This can avoid deadlock or stack overflow.
>>>>>> But in stack overflow case, it should be OK to increase the
>>>>>> recursion depth if needed. So we add a percpu counter in eventfd_ctx
>>>>>> to limit the recursion depth for deadlock case. Then it could be
>>>>>> fine to increase the global percpu counter later.
>>>>> I wonder whether or not it's worth to introduce percpu for each eventfd.
>>>>>
>>>>> How about simply check if eventfd_signal_count() is greater than 2?
>>>>>
>>>> It can't avoid deadlock in this way.
>>>
>>> I may miss something but the count is to avoid recursive eventfd call.
>>> So for VDUSE what we suffers is e.g the interrupt injection path:
>>>
>>> userspace write IRQFD -> vq->cb() -> another IRQFD.
>>>
>>> It looks like increasing EVENTFD_WAKEUP_DEPTH should be sufficient?
>>>
>> Actually I mean the deadlock described in commit f0b493e ("io_uring:
>> prevent potential eventfd recursion on poll"). It can break this bug
>> fix if we just increase EVENTFD_WAKEUP_DEPTH.
> 
> 
> Ok, so can wait do something similar in that commit? (using async stuffs 
> like wq).

io_uring should be fine in current kernels, but aio would still be
affected by this. But just in terms of recursion, bumping it one more
should probably still be fine.

-- 
Jens Axboe

