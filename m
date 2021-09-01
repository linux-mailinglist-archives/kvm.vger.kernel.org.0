Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026D43FDEA1
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 17:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbhIAP2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 11:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343525AbhIAP17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 11:27:59 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF17C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 08:27:02 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h29so3725666ila.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 08:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P4hWmiVCsoalS+MUxb6yp9qen+G/lJg4S4KtX6kUkIg=;
        b=bAVSIYQ+ja4RwQISg4uNNKJLNh45xtISDhVk9AR2uD9C8rzMnOwI7smTNyDDsjvVhp
         5lv/E6d/3OL3YUt7CYKIdA9UQOJTPCcGJC0rIsN3eAu9DGf2SzQkphQ9T5JuIkySfLPX
         8cOOZ3V4znimIUsO1BfrNI4Ctub7u3AviThY62yo8rYSfzQk3MYasYAdXaWcBS9Uu2W/
         fiTsLtF+iv8UIKeRRfZKzT4XaDuWDlrIQbs7dE+RI0oRYQoAPqdRmzarG9xvclxdYpCZ
         1YfnL+2c2MGnyUgjN33eQkWFnfrMgbyKqLp5piKS0lFyRs3ODqVW2i8bVKSCB0052vbM
         JB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P4hWmiVCsoalS+MUxb6yp9qen+G/lJg4S4KtX6kUkIg=;
        b=PNYOtRR2q3s+IRL+NjzXAqi+Hae/ndMAnERqwOoTZyXiDxu2O2BVNmKK7gS+Hl0Lws
         HnFoy94MJMg+XbU4P0BtjioQz+9oLC9cAYGESqMRR4dGBJLCLbEMcZMIBS93b7j6E0Lu
         hEDDpadW2fv6atWQk+hEsTx2RkTxxD4D2sAceBYp9oArxBYDcbRQVkjGxtqvwn2Opzg/
         EtJawuifjDohv781qBKbM+JSom5gCWeI1DXc3Dx1gcpyGdJoVKch71AGUQJ+O+zRa20A
         Olc4tge2tBVkIbTzq0qkRZ8qyP68MslvZrqWZBxm2NgdsUxmf7pnK6oRtxPHth4Ac8RZ
         IzPA==
X-Gm-Message-State: AOAM533oKMnGYcseCEKJ7TE0+4N3fv/RpMchZxqUtkVLo5rpyNTO/bdu
        US4ZwVnPtonETsASly6SzR2iZg==
X-Google-Smtp-Source: ABdhPJzu7OecURDkdeuTRcdqGYhldWEarwW4nuDTPdc7m9jAK9+iiAPcpIvGYEtV9JmBvvSla+EqVA==
X-Received: by 2002:a92:c5cf:: with SMTP id s15mr80745ilt.62.1630510021791;
        Wed, 01 Sep 2021 08:27:01 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c5sm175541ilr.54.2021.09.01.08.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 08:27:01 -0700 (PDT)
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     hch@infradead.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <20210901102623-mutt-send-email-mst@kernel.org>
 <89d6dc30-a876-b1b0-4ff4-605415113611@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a648daf-dd93-0c16-58d6-e4a59334bf0b@kernel.dk>
Date:   Wed, 1 Sep 2021 09:27:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89d6dc30-a876-b1b0-4ff4-605415113611@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/21 8:58 AM, Max Gurtovoy wrote:
> 
> On 9/1/2021 5:50 PM, Michael S. Tsirkin wrote:
>> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>>> has lots of deep queues, preallocation for the sg list can consume
>>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>>> can be 64 or 128 and each queue's depth might be 128. This means the
>>> resulting preallocation for the data SGLs is big.
>>>
>>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>>> This is the approach used by NVMe drivers so it should be reasonable for
>>> virtio block as well. Runtime SGL allocation has always been the case
>>> for the legacy I/O path so this is nothing new.
>>>
>>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>>> support SG_CHAIN, use only runtime allocation for the SGL.
>>>
>>> Re-organize the setup of the IO request to fit the new sg chain
>>> mechanism.
>>>
>>> No performance degradation was seen (fio libaio engine with 16 jobs and
>>> 128 iodepth):
>>>
>>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>>> --------     ---------------------------------    ----------------------------------
>>> 512B          318K/316K                                    329K/325K
>>>
>>> 4KB           323K/321K                                    353K/349K
>>>
>>> 16KB          199K/208K                                    250K/275K
>>>
>>> 128KB         36K/36.1K                                    39.2K/41.7K
>>>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
>> Could you use something to give confidence intervals maybe?
>> As it is it looks like a 1-2% regression for 512B and 4KB.
> 
> 1%-2% is not a regression. It's a device/env/test variance.
> 
> This is just one test results. I run it many times and got difference by 
> +/- 2%-3% in each run for each sides.
> 
> Even if I run same driver without changes I get 2%-3% difference between 
> runs.
> 
> If you have a perf test suite for virtio-blk it will be great if you can 
> run it, or maybe Feng Li has.

You're adding an allocation to the hot path, and a free to the
completion hot path. It's not unreasonable to expect that there could be
performance implications associated with that. Which would be
particularly evident with 1 segment requests, as the results would seem
to indicate as well.

Probably needs better testing. A profile of a peak run before and after
and a diff of the two might also be interesting.

The common idiom for situations like this is to have an inline part that
holds 1-2 segments, and then only punt to alloc if you need more than
that. As the number of segments grows, the cost per request matters
less.

-- 
Jens Axboe

