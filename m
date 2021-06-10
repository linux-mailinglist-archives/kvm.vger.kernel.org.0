Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24E13A229C
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 05:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFJDQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 23:16:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhFJDQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 23:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623294785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AaHF8TleW9y2yJFtUkdVSK3jH8Hx5NwN6hAUVAUFzZY=;
        b=HafUCfxIZRhMpbyiKxaQGp+nzGk+XR6MEeQPAJv12rXxm7/Cw0k2zGPBVitqht5qdx1Sy5
        b7i/CWD7O3GXrPVPAU9QNQmtr2/BiIxn8bxZ6gICWiULPxeQrW38F2FYIXfxQBmJS9t9Ol
        1X1OMbmYGg2B1dOPf4DxmgUoPrAnG/o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-qNmeUHEhNfCj7SYaD2KcOw-1; Wed, 09 Jun 2021 23:13:04 -0400
X-MC-Unique: qNmeUHEhNfCj7SYaD2KcOw-1
Received: by mail-pf1-f199.google.com with SMTP id b63-20020a6234420000b02902eef086465dso401903pfa.5
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 20:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AaHF8TleW9y2yJFtUkdVSK3jH8Hx5NwN6hAUVAUFzZY=;
        b=kHsJHsJ+BOaUzc9rIuLQu0+EE16renP4u9T5lfCKI+fmQnTHrZxHapVfnYUwbP/fFg
         mSk9umLtXSbynJZX4ezhjEqi6bGBlT25pc7TbvYHnPfZjgwZEzlTB1lFFt9yfXnGu6cd
         GpkMRiJpC3mTuUI9g+WTt9in0l0oXBInluCh2InwuPZBroZ83GtzuD7rI28g/izfonI7
         Qzx29WzyRr93Z2E94a/K/dEpdNMBPKyhXBf/AQjKtqqmgU7l17okVEG/qNcQYeNOU/GS
         BxkO0kWtwZNKGKLForJ2J7O6VspfN5x2YFhkOYzgt8uyX2yw+i1XP4/DEvIGK84MvdQR
         ZTXQ==
X-Gm-Message-State: AOAM530g+0n+ZJ/pPeOYngoNPaxkB1vh4+men8V90eDgLUQfGSrrSGHD
        /o7MMV8GdaSGRFY+ZqItLjff37BgnDjXcD7BZ+1ixXGl6+PTikIzpJflGIwGB8/+J3tP+E82A6j
        vHVGnPoNMURYb
X-Received: by 2002:a05:6a00:ac9:b029:2de:a06d:a52f with SMTP id c9-20020a056a000ac9b02902dea06da52fmr921566pfl.4.1623294783018;
        Wed, 09 Jun 2021 20:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/pAIMyn/a062PTQnxMgMFen4R6oZntNzUJIuTOG/VZwhA+MB6v0irLu8mJOnFgruZrZj5dw==
X-Received: by 2002:a05:6a00:ac9:b029:2de:a06d:a52f with SMTP id c9-20020a056a000ac9b02902dea06da52fmr921554pfl.4.1623294782797;
        Wed, 09 Jun 2021 20:13:02 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o16sm767460pfu.75.2021.06.09.20.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:13:02 -0700 (PDT)
Subject: Re: [PATCH 0/7] Do not read from descriptor ring
To:     Andy Lutomirski <luto@kernel.org>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com
References: <20210604055350.58753-1-jasowang@redhat.com>
 <1c079daa-f73d-cb1a-15ef-d8f57f9813b8@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <633377e3-98d2-2917-3111-2c9c08b5da4f@redhat.com>
Date:   Thu, 10 Jun 2021 11:12:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1c079daa-f73d-cb1a-15ef-d8f57f9813b8@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/9 上午12:24, Andy Lutomirski 写道:
> On 6/3/21 10:53 PM, Jason Wang wrote:
>> Hi:
>>
>> The virtio driver should not trust the device. This beame more urgent
>> for the case of encrtpyed VM or VDUSE[1]. In both cases, technology
>> like swiotlb/IOMMU is used to prevent the poking/mangling of memory
>> from the device. But this is not sufficient since current virtio
>> driver may trust what is stored in the descriptor table (coherent
>> mapping) for performing the DMA operations like unmap and bounce so
>> the device may choose to utilize the behaviour of swiotlb to perform
>> attacks[2].
> Based on a quick skim, this looks entirely reasonable to me.
>
> (I'm not a virtio maintainer or expert.  I got my hands very dirty with
> virtio once dealing with the DMA mess, but that's about it.)
>
> --Andy


Good to know that :)

Thanks

