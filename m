Return-Path: <kvm+bounces-42629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 170DAA7BA52
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5A73B6F9C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D3B1ACEA5;
	Fri,  4 Apr 2025 10:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bAbBN5YO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA80B2E62C7
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743760872; cv=none; b=E4OhsXLRIGOeH6Cy5K7Jccd5xGG92cA8/IgtRjfNtl6srJr7H5xB9pHCKEVBJUql8vP9WHiQ+Ewl3b0rwtV4u1jtnlzR6Ma9QlS2e1S+p/0QSZ7EOkKx3dRUN10GGYuxbgAUS5I/pXfyWgbbXU0swXueRLdUPoAGfDmwlOqZGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743760872; c=relaxed/simple;
	bh=QmUDUM55vLT0DayUEsba5JbgkzgXg382aWG+kNxQGrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaTMx6xf02lQI4mcYHe3IyaQP+WigONkFhIe4QECpznhUpo0qfxlPex4TciCRM//bKNmlLaw94qiToy8urAEGELrOoR8iCuydgAfR1CkOUI4qrM6p+OPZ+ysJTjr1XExICUrY6TPYh7NGtzwd4PUXAXlOJ+NZmlShqT8KJaK0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bAbBN5YO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743760868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jdjD8nNlZJ/VQ3nJOvJ9Bm6sUbIwUoYlGR93J0fu2S0=;
	b=bAbBN5YOU6GQVon0byJtPvSx619pnM1I9LNrby2JlmJQ8csdSTNxR3MBXLv/PcPK9RZjKr
	n9aI81ryOcnSKmthXrrGOsF5VKueui2+MYAIn+2fEoysza/4sLZEir/J2gM/xzmmcoStIN
	xcD1mxTwsV9GZK6slnuNzMgfnzr4vnc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-6E81cgb5OgC7LBgwUP__Pg-1; Fri, 04 Apr 2025 06:01:00 -0400
X-MC-Unique: 6E81cgb5OgC7LBgwUP__Pg-1
X-Mimecast-MFC-AGG-ID: 6E81cgb5OgC7LBgwUP__Pg_1743760859
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43bc97e6360so10716175e9.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743760859; x=1744365659;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jdjD8nNlZJ/VQ3nJOvJ9Bm6sUbIwUoYlGR93J0fu2S0=;
        b=GmbfEPlfA54AGrDcOxYplAN8xTO0TUXijDOFHNYlXTc10vgiz6/jO/M6Zx5ivUSgnx
         3MXtmktViuw28rT3SWHlOyRgLIM+4ls5+BvX+ifs0JwU+PfEvZ2sLXbKOpD6hWsImywW
         bT3xNREtSs2IdxPjQCa+ubyBx5DdEfzH598T89qDUIaRPE0a9Xl4FB1XEZX3ec7ZwPpV
         w8biaaCrE6C3OcvJFZ+r8mYEuSczxz51wRmjHiO8Fb7zGlALWyKLp0EvWcoHKHFyu3qI
         45w0U2mfEbd4kqL1VOjexOOMnKwgfld60YfF5eqq/JWxnVHLa9IkbUNcKEOvjc+Lc0XE
         tieg==
X-Forwarded-Encrypted: i=1; AJvYcCUfCIbX7rEPKtkrmCThdYEset2Y0yh4TyFFs/BeEqumKm0qwiBNi9Z5KWwiYB3pqZ2k+Bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMLOnTaFkbFQ2kjig+qP/UI2BYPMQ4dc9fiiPH4oPWl6PgX/1W
	OOzvd0TTrUGVgLyx0SpPs76mEN0LNGS4uPTV7SRJAwdeGej2aTaIaiCht5I54Kr36IEOkxSi3kI
	MZXx4MNVv7jWKz8fWUpqV29LRo8oRq2pWZe2KIJSpQAxoca2hpw==
X-Gm-Gg: ASbGncv5WXio5ONfyeRHI0urBCcMeMWXTOm60jfd0Q94LParYUrVt11C3z0YhV8y/HZ
	CNywfh4GOA2IBMnafmI3Oe2d7F6PZ2vti1rn3GHBlZ579TFeaK5x+9wTGUM56Pyh3fGyNrwdAbj
	1lPNdJLxaI/Xas+k5K0vQmiRv4Wk+3mVSkyGSBoiAeILNM516J+6DNwzgSX1hpahLOS7Q72rQ8y
	c61X+ox7c37XDIHXdlz8fgfgkkmBufxNBoxw3gSglHSpx21OmSNQwMkNvXLh8aT2ps1uh52uUDp
	P95RgEQTp35F0jAzGeP/xYGJye0FgaZ1WwHefWk6sVGp3PnWCzYAT5svB89KgelNKAeRoOOsHdB
	vcm/0KCeSf1DTF4acHO1P6FU5eaQNFvc5+BzK15VJ03U=
X-Received: by 2002:a05:600c:1382:b0:43c:f8fc:f69a with SMTP id 5b1f17b1804b1-43ecf8231a8mr22533775e9.4.1743760859294;
        Fri, 04 Apr 2025 03:00:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGifz3HIGWQgKUammrvfPkPZxVrPSFShnbthNQnbAXFOUWVRfHdSi2jwRp3iKKOg8pUTCfB1w==
X-Received: by 2002:a05:600c:1382:b0:43c:f8fc:f69a with SMTP id 5b1f17b1804b1-43ecf8231a8mr22533275e9.4.1743760858803;
        Fri, 04 Apr 2025 03:00:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7900:8752:fae3:f9c9:a07e? (p200300cbc71b79008752fae3f9c9a07e.dip0.t-ipconnect.de. [2003:cb:c71b:7900:8752:fae3:f9c9:a07e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec1795630sm46181045e9.29.2025.04.04.03.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 03:00:56 -0700 (PDT)
Message-ID: <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
Date: Fri, 4 Apr 2025 12:00:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: Halil Pasic <pasic@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
 <20250403161836.7fe9fea5.pasic@linux.ibm.com>
 <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
 <20250404063619.0fa60a41.pasic@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250404063619.0fa60a41.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.04.25 06:36, Halil Pasic wrote:
> On Thu, 3 Apr 2025 16:28:31 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>>> Sorry I have to have a look at that discussion. Maybe it will answer
>>> some my questions.
>>
>> Yes, I think so.
>>
>>>    
>>>> Let's fix it without affecting existing setups for now by properly
>>>> ignoring the non-existing queues, so the indicator bits will match
>>>> the queue indexes.
>>>
>>> Just one question. My understanding is that the crux is that Linux
>>> and QEMU (or the driver and the device) disagree at which index
>>> reporting_vq is actually sitting. Is that right?
>>
>> I thought I made it clear: this is only about the airq indicator bit.
>> That's where both disagree.
>>
>> Not the actual queue index (see above).
> 
> I did some more research including having a look at that discussion. Let
> me try to sum up how did we end up here.

Let me add some more details after digging as well:

> 
> Before commit a229989d975e ("virtio: don't allocate vqs when names[i] =
> NULL") the kernel behavior used to be in spec, but QEMU and possibly
> other hypervisor were out of spec and things did not work.

It all started with VIRTIO_BALLOON_F_FREE_PAGE_HINT. Before that,
we only had the single optional VIRTIO_BALLOON_F_STATS_VQ queue at the very
end. So there was no possibility for holes "in-between".

In the Linux driver, we created the stats queue only if the feature bit
VIRTIO_BALLOON_F_STATS_VQ was actually around:

	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
	err = virtio_find_vqs(vb->vdev, nvqs, vqs, callbacks, names, NULL);

That changed with VIRTIO_BALLOON_F_FREE_PAGE_HINT, because we would
unconditionally create 4 queues. QEMU always supported the first 3 queues
unconditionally, but old QEMU did obviously not support the (new)
VIRTIO_BALLOON_F_FREE_PAGE_HINT queue.

390x didn't particularly like getting queried for non-existing
queues. [1] So the fix was not for a hypervisor that was out of spec, but
because quering non-existing queues didn't work.

The fix implied that if VIRTIO_BALLOON_F_STATS_VQ is missing, suddenly the queue
index of VIRTIO_BALLOON_F_FREE_PAGE_HINT changed as well.

Again, as QEMU always implemented the 3 first queues unconditionally, this was
not a problem.

[1] https://lore.kernel.org/all/c6746307-fae5-7652-af8d-19f560fc31d9@de.ibm.com/#t

> 
> Possibly because of the complexity of fixing the hypervisor(s) commit
> a229989d975e ("virtio: don't allocate vqs when names[i] = NULL") opted
> for changing the guest side so that it does not fit the spec but fits
> the hypervisor(s). It unfortunately also broke notifiers (for the with
> holes) scenario for virtio-ccw only.

Yes, it broke the notifiers.

But note that everything was in spec at that point, because we only documented
"free_page_vq == 3" in the spec *2 years later*, in 2020:

commit 38448268eba0c105200d131c3f7f660129a4d673
Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date:   Tue Aug 25 07:45:02 2020 -0700

     content: Document balloon feature free page hints
     
     Free page hints allow the balloon driver to provide information on what
     pages are not currently in use so that we can avoid the cost of copying
     them in migration scenarios. Add a feature description for free page hints
     describing basic functioning and requirements.
     
At that point, what we documented in the spec *did not match reality* in
Linux. QEMU was fully compatible, because VIRTIO_BALLOON_F_STATS_VQ is
unconditionally set.


QEMU and Linux kept using that queue index assignment model, and the spec
was wrong (out of sync?) at that point. The spec got more wrong with

commit d917d4a8d552c003e046b0e3b1b529d98f7e695b
Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date:   Tue Aug 25 07:45:17 2020 -0700

     content: Document balloon feature free page reporting
     
     Free page reporting is a feature that allows the guest to proactively
     report unused pages to the host. By making use of this feature is is
     possible to reduce the overall memory footprint of the guest in cases where
     some significant portion of the memory is idle. Add documentation for the
     free page reporting feature describing the functionality and requirements.

Where we documented VIRTIO_BALLOON_F_REPORTING after the changes were added to
QEMU+Linux implementation, so the spec did not reflect reality.

I'll note also cloud-hypervisor [2] today follows that model.

In particular, it *only* supports VIRTIO_BALLOON_F_REPORTING, turning
the queue index of VIRTIO_BALLOON_F_REPORTING into *2* instead of documented
in the spec to be *4*.

So in reality, we can see VIRTIO_BALLOON_F_REPORTING to be either 2/3/4, depending
on the availability of the other two features/queues.

[2] https://github.com/cloud-hypervisor/cloud-hypervisor/blob/main/virtio-devices/src/balloon.rs


> 
> Now we had another look at this, and have concluded that fixing the
> hypervisor(s) and fixing the kernel, and making sure that the fixed
> kernel can tolerate the old broken hypervisor(s) is way to complicated
> if possible at all. So we decided to give the spec a reality check and
> fix the notifier bit assignment for virtio-ccw which is broken beyond
> doubt if we accept that the correct virtqueue index is the one that the
> hypervisor(s) use and not the one that the spec says they should use.

In case of virtio-balloon, it's unfortunate that it went that way, but the
spec simply did not / does not reflect reality when it was added to the spec.

> 
> With the spec fixed, the whole notion of "holes" will be something that
> does not make sense any more. With that the merit of the kernel interface
> virtio_find_vqs() supporting "holes" is quite questionable. Now we need
> it because the drivers within the Linux kernel still think of the queues
> in terms of the current spec, i.e. they try to have the "holes" as
> mandated by the spec, and the duty of making it work with the broken
> device implementations falls to the transports.
> 

Right, the "holes" only exist in the input array.

> Under the assumption that the spec is indeed going to be fixed:
> 
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Thanks!

-- 
Cheers,

David / dhildenb


