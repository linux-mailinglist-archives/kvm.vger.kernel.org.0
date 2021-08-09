Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B4F3E41D8
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhHIIvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234008AbhHIIvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628499061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXR+JIzWEYNeD1UnXjRtYb+ykUgRxVjnQJbgR8HpkXE=;
        b=Uq5jtkqbNeTZUqLwcYVXbwK22o3IM5QSl616zVZ6BL0NnVsP4icrkNTx1QQXzDzs8UmMTu
        OYxdgTYM7GRWUNBo+/dfglc7Wbrmn2Ol7NVFTy6NberfBo3VQZG3QMcnxP5ppD5qW9bjQ+
        A2lKoxbXNWkvRCGuDZJfgFNAuLWknhw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-5Ql1yix9NyOlWpXtj3B5Hw-1; Mon, 09 Aug 2021 04:50:59 -0400
X-MC-Unique: 5Ql1yix9NyOlWpXtj3B5Hw-1
Received: by mail-wm1-f70.google.com with SMTP id 17-20020a1c04110000b02902e687e6276dso1317569wme.3
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eXR+JIzWEYNeD1UnXjRtYb+ykUgRxVjnQJbgR8HpkXE=;
        b=hjjbQgIsjYsx63CopMa/GO5pBCUjYkfNzI+q3H6SXmyx4WAJr7b0Saud96nCbw/LcS
         o4A1A8JCM+YRYYxqB7HvgbTSkrf+x7h8YARXX2bajsSwcRu9M779fbFSDY4d5h0c7nb9
         KvLSJ2R1kf9PVRUWLRynWqqRi0LkHqwI/QjQDxfKtRYhsszgWvYCpvxG18K0hcwUt7mV
         vwPC5LivDSLW169swsQpzupH8eiHJ0Xp0jhjLJODcU+hCibFhDo0kWxJ3jUZCxzKLcl8
         Cu3G9k9RO4ES7o3X3MTwgTmIR55GYGQb7dQUd3/8TpyRQ0d2iS17agxC9yZEQeM9l51a
         cUUw==
X-Gm-Message-State: AOAM530caaxkE1Z24a/9oulEyHHUXF/N41Mw07XsF3c4lcoy4wHalfQV
        svf08inWUXHxItFXzgy5II3BOvc9YzgtWAHwN+VJD/HBrgzSFpo/fNHOfz44ZzlsTx5WJkxNjog
        oyrx4XVUr5ery
X-Received: by 2002:a05:600c:1d12:: with SMTP id l18mr15423198wms.88.1628499058627;
        Mon, 09 Aug 2021 01:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn8BfKomzEPX0PtqpbGSxmBgVo/T64uydRSEX/+7aDK1leW+8vEKtx+wRwoAiMKr32K3b/YA==
X-Received: by 2002:a05:600c:1d12:: with SMTP id l18mr15423168wms.88.1628499058304;
        Mon, 09 Aug 2021 01:50:58 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id j4sm16841393wmi.4.2021.08.09.01.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 01:50:57 -0700 (PDT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <86b114ef-41ea-04b6-327c-4a036f784fad@redhat.com>
 <20210806113005.0259d53c@p-imbrenda>
 <ada27c6d-4dc9-04c3-d5b9-566e65359701@redhat.com>
 <20210806154400.2ca55563@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 00/14] KVM: s390: pv: implement lazy destroy
Message-ID: <8f1502a4-8ee3-f70f-ca04-4a13d44368fb@redhat.com>
Date:   Mon, 9 Aug 2021 10:50:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806154400.2ca55563@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.08.21 15:44, Claudio Imbrenda wrote:
> On Fri, 6 Aug 2021 13:30:21 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
> [...]
> 
>>>>> When the system runs out of memory, if a guest has terminated and
>>>>> its memory is being cleaned asynchronously, the OOM killer will
>>>>> wait a little and then see if memory has been freed. This has the
>>>>> practical effect of slowing down memory allocations when the
>>>>> system is out of memory to give the cleanup thread time to
>>>>> cleanup and free memory, and avoid an actual OOM situation.
>>>>
>>>> ... and this sound like the kind of arch MM hacks that will bite us
>>>> in the long run. Of course, I might be wrong, but already doing
>>>> excessive GFP_ATOMIC allocations or messing with the OOM killer
>>>> that
>>>
>>> they are GFP_ATOMIC but they should not put too much weight on the
>>> memory and can also fail without consequences, I used:
>>>
>>> GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN
>>>
>>> also notice that after every page allocation a page gets freed, so
>>> this is only temporary.
>>
>> Correct me if I'm wrong: you're allocating unmovable pages for
>> tracking (e.g., ZONE_DMA, ZONE_NORMAL) from atomic reserves and will
>> free a movable process page, correct? Or which page will you be
>> freeing?
> 
> we are transforming ALL moveable pages belonging to userspace into
> unmoveable pages. every ~500 pages one page gets actually
> allocated (unmoveable), and another (moveable) one gets freed.
> 
>>>
>>> I would not call it "messing with the OOM killer", I'm using the
>>> same interface used by virtio-baloon
>>
>> Right, and for virtio-balloon it's actually a workaround to restore
>> the original behavior of a rarely used feature: deflate-on-oom.
>> Commit da10329cb057 ("virtio-balloon: switch back to OOM handler for
>> VIRTIO_BALLOON_F_DEFLATE_ON_OOM") tried to document why we switched
>> back from a shrinker to VIRTIO_BALLOON_F_DEFLATE_ON_OOM:
>>
>> "The name "deflate on OOM" makes it pretty clear when deflation should
>>    happen - after other approaches to reclaim memory failed, not while
>>    reclaiming. This allows to minimize the footprint of a guest -
>> memory will only be taken out of the balloon when really needed."
>>
>> Note some subtle differences:
>>
>> a) IIRC, before running into the OOM killer, will try reclaiming
>>      anything  else. This is what we want for deflate-on-oom, it might
>> not be what you want for your feature (e.g., flushing other
>> processes/VMs to disk/swap instead of waiting for a single process to
>> stop).
> 
> we are already reclaiming the memory of the dead secure guest.
> 
>> b) Migration of movable balloon inflated pages continues working
>> because we are dealing with non-lru page migration.
>>
>> Will page reclaim, page migration, compaction, ... of these movable
>> LRU pages still continue working while they are sitting around
>> waiting to be cleaned up? I can see that we're grabbing an extra
>> reference when we put them onto the list, that might be a problem:
>> for example, we can most certainly not swap out these pages or write
>> them back to disk on memory pressure.
> 
> this is true. on the other hand, swapping a moveable page would be even
> slower, because those pages would need to be exported and not destroyed.
> 
>>>    
>>>> way for a pure (shutdown) optimization is an alarm signal. Of
>>>> course, I might be wrong.
>>>>
>>>> You should at least CC linux-mm. I'll do that right now and also CC
>>>> Michal. He might have time to have a quick glimpse at patch #11 and
>>>> #13.
>>>>
>>>> https://lkml.kernel.org/r/20210804154046.88552-12-imbrenda@linux.ibm.com
>>>> https://lkml.kernel.org/r/20210804154046.88552-14-imbrenda@linux.ibm.com
>>>>
>>>> IMHO, we should proceed with patch 1-10, as they solve a really
>>>> important problem ("slow reboots") in a nice way, whereby patch 11
>>>> handles a case that can be worked around comparatively easily by
>>>> management tools -- my 2 cents.
>>>
>>> how would management tools work around the issue that a shutdown can
>>> take very long?
>>
>> The traditional approach is to wait starting a new VM on another
>> hypervisor instead until memory has been freed up, or start it on
>> another hypervisor. That raises the question about the target use
>> case.
>>
>> What I don't get is that we have to pay the price for freeing up that
>> memory. Why isn't it sufficient to keep the process running and let
>> ordinary MM do it's thing?
> 
> what price?
> 
> you mean let mm do the slowest possible thing when tearing down a dead
> guest?
> 
> without this, the dying guest would still take up all the memory. and
> swapping it would not be any faster (it would be slower, in fact). the
> system would OOM anyway.
> 
>> Maybe you should clearly spell out what the target use case for the
>> fast shutdown (fast quitting of the process?) is?. I assume it is,
>> starting a new VM / process / whatsoever on the same host
>> immediately, and then
>>
>> a) Eventually slowing down other processes due heavy reclaim.
> 
> for each dying guest, only one CPU is used by the reclaim; depending on
> the total load of the system, this might not even be noticeable
> 
>> b) Slowing down the new process because you have to pay the price of
>> cleaning up memory.
> 
> do you prefer to OOM because the dying guest will need ages to clean up
> its memory?
> 
>> I think I am missing why we need the lazy destroy at all when killing
>> a process. Couldn't you instead teach the OOM killer "hey, we're
>> currently quitting a heavy process that is just *very* slow to free
>> up memory, please wait for that before starting shooting around" ?
> 
> isn't this ^ exactly what the OOM notifier does?
> 
> 
> another note here:
> 
> when the process quits, the mm starts the tear down. at this point, the
> mm has no idea that this is a dying KVM guest, so the best it can do is
> exporting (which is significantly slower than destroy page)
> 
> kvm comes into play long after the mm is gone, and at this point it
> can't do anything anymore. the memory is already gone (very slowly).
> 
> if I kill -9 qemu (or if qemu segfaults), KVM will never notice until
> the mm is gone.
> 

Summarizing what we discussed offline:

1. We should optimize for proper shutdowns first, this is the most 
important use case. We should look into letting QEMU tear down the KVM 
secure context such that we can just let MM teardown do its thing -> 
destroy instead of export secure pages. If no kernel changes are 
required to get that implemented, even better.

2. If we want to optimize "there is a big process dying horribly slow, 
please OOM killer please wait a bit instead of starting killing other 
processes", we might want to do that in a more generic way (if not 
already in place, no expert).

3. If we really want to go down the path of optimizing "kill -9" and 
friends to e.g., take 40min instead of 20min on a huge VM (who cares? 
especially, the OOM handler will struggle already if memory is getting 
freed that slowly, no matter if 40 or 20 minutes), we should look into 
being able to release the relevant KVM secure context before tearing 
down MM. We should avoid any arch specific hacks.

-- 
Thanks,

David / dhildenb

