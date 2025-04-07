Return-Path: <kvm+bounces-42841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E2EA7DEBF
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A76C73B0DEA
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9D62550D4;
	Mon,  7 Apr 2025 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5aMXL2N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8085680
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744031615; cv=none; b=j6D7jqmaPNfg0xh2ffMqU4nvTgHyqABN9bx+Ime2u2Wbs2/nP60Y6X4C7zFDjivBJMue5YUWPx0QVW+0YHPHlGjJrlISbmQi2ovym5q07/j4/+tTiUJP6hA0U+Dmo7d0SpbWb0asZg0c/1d9672WXabEn28bvJx5xym+srtXoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744031615; c=relaxed/simple;
	bh=iTIUibsvqrbIvBfbLO6yvxipiQgw/mcWSIkoRC1IQ4Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Le2jV6dctOIiSOb3kUDe/fd7Jgf6XXwx40/sOBK+eRmjSn6wy4nlLRN8GZ91JeBoZyyQQ3/avUcyTMdy9YPLgL2izOGbwRuWP5QtpZB95jpClZdMiOYyaALmsCNzywMULEnli4sIvTd60rzIlJiW/zuucoPfKsvmi5Ti8Jq3aPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T5aMXL2N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744031613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m51074bO33/w5i/HWCytDEggQdmKPpoPEiX7c7uBltY=;
	b=T5aMXL2Nxs/wmx9WZQSedbUB/kufgu2RiWyj2wFdFNU5n6e6x1295Pxb1heN/g/pFv1FGV
	57xng+koGLxwfZzDZZ1glibhSTYR3IP2VbbPvbVPXTfKEZ5s0ipUqPk9ByLeaxSzcJkO57
	w4re8ULwg0Y4em/Y+USHvfxuUEAE8AY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-XeBnDEjfNfmg03kYyHELIQ-1; Mon, 07 Apr 2025 09:13:32 -0400
X-MC-Unique: XeBnDEjfNfmg03kYyHELIQ-1
X-Mimecast-MFC-AGG-ID: XeBnDEjfNfmg03kYyHELIQ_1744031611
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913d8d7c3eso2356221f8f.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 06:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744031611; x=1744636411;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m51074bO33/w5i/HWCytDEggQdmKPpoPEiX7c7uBltY=;
        b=rCC77sWt3JzNRtkr8jM/WJ7yLTOdgYDW96G+hm4PMPuVCMbZgdb93CeU2dMWu6wj31
         NRgLaVGUCYCXgdhhhhHiqr+5zXaZT3AN6PiV8RM8b00SfuTbLGdBX0cZv4mYSj+02IIU
         huqnfi4lI9O+CWwuh32/3d7H9YozI1Cwx2oMzuLYM7UNWPMT0reI8fdaNq7EVePfgjPB
         3WCWPDOl6DRghE6PnMexEaqon9BocC5Yr8R96fcp2icdVSa5m0vCstl0089UvuIhFgsb
         4TiDXOW8dQXVm+4dQ7jpgZwwkUQw/vVbSI5CVk6luNH/Z8iokBc64TbR9oqIfamnaYV4
         LXFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQNfSAcfOJulRfasQBMxj47OkBR3QM3pvJ78Hrw8BTvjRYpvakdBJDoa4GCysM9eJHS9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsztmoAcPdZTccge6tSCE90gTAFRdQ2i58z8lSZAlT2g/jmrW5
	Gv4iN789bHDQsQBiI7RSRJMc3UPPQeu/Ua8yseQfDrH1L77WMEa+FEza8KXKM5psapGx2i8NeDy
	EsD1sFOpMZ5+ZjY5hHXcxCDWaqRvEHIOktT0kqwnFHUyQ79XjCw==
X-Gm-Gg: ASbGncs1qYA3kqdXcGwzasBv7TuaN3kSO6FpZRaxCwhKF25Mih8sznxalm7AtsnPVlk
	8aYm3w5mZdbpaCj3H9onTBIa1/qa9OWlV1X0HwfxRsEbmAeIAejNym/32n2SrOdsohyKvBELtjo
	z9qU8Bzfjm76iECuPdB/J72M7BcsAmC7zdPGs8YeSe1pngrDqZuqA5Ft8du1WJZbOlnto1WLEVn
	UNIRMJLtbdmVNSg7SeaC4KjHytEB1lpvQyO9VIlHNLWDcRariPMd2s4dc9PT2MT6N7Gd/dQGmyY
	DH1VwXRcbCqznI6f/jIq0fFRLj39JPs9OkJLrcQ480qRcGcVvVVzNkB3AG/7agJQk9zu1+/dIJE
	lU9u3RW42UX8g8yeSJfknkmDVJE8nd3H0z69TxcdrtfI=
X-Received: by 2002:a05:6000:178c:b0:391:45e9:face with SMTP id ffacd0b85a97d-39d14662fc6mr10986563f8f.54.1744031610689;
        Mon, 07 Apr 2025 06:13:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCGG2hYSNhURy95k0GMmsGkFNkyW86gLfpLuE4AA8o/qBIso1h35Rid8w+7CgRrN4toqtuKQ==
X-Received: by 2002:a05:6000:178c:b0:391:45e9:face with SMTP id ffacd0b85a97d-39d14662fc6mr10986518f8f.54.1744031610266;
        Mon, 07 Apr 2025 06:13:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a7064sm12332222f8f.34.2025.04.07.06.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 06:13:29 -0700 (PDT)
Message-ID: <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
Date: Mon, 7 Apr 2025 15:13:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
From: David Hildenbrand <david@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
 Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>,
 Daniel Verkamp <dverkamp@chromium.org>
References: <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 11:13, David Hildenbrand wrote:
> On 07.04.25 11:11, David Hildenbrand wrote:
>> On 07.04.25 10:58, Michael S. Tsirkin wrote:
>>> On Mon, Apr 07, 2025 at 10:54:00AM +0200, David Hildenbrand wrote:
>>>> On 07.04.25 10:49, Michael S. Tsirkin wrote:
>>>>> On Mon, Apr 07, 2025 at 10:44:21AM +0200, David Hildenbrand wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>> Whoever adds new feat_X *must be aware* about all previous features,
>>>>>>>> otherwise we'd be reusing feature bits and everything falls to pieces.
>>>>>>>
>>>>>>>
>>>>>>> The knowledge is supposed be limited to which feature bit to use.
>>>>>>
>>>>>> I think we also have to know which virtqueue bits can be used, right?
>>>>>>
>>>>>
>>>>> what are virtqueue bits? vq number?
>>>>
>>>> Yes, sorry.
>>>
>>> I got confused myself, it's vq index actually now, we made the spec
>>> consistent with that terminology. used to be number/index
>>> interchangeably.
>>>
>>>> Assume cross-vm as an example. It would make use of virtqueue indexes 5+6
>>>> with their VIRTIO_BALLOON_F_WS_REPORTING.
>>>
>>>
>>> crossvm guys really should have reserved the feature bit even if they
>>> did not bother specifying it. Let's reserve it now at least?
>>
>> Along with the virtqueue indices, right?
>>
>> Note that there was
>>
>> https://lists.gnu.org/archive/html/qemu-devel/2023-05/msg02503.html
>>
>> and
>>
>> https://groups.oasis-open.org/communities/community-home/digestviewer/viewthread?GroupId=3973&MessageKey=afb07613-f56c-4d40-8981-2fad1c723998&CommunityKey=2f26be99-3aa1-48f6-93a5-018dce262226&hlmlt=VT
>>
>> But it only was RFC, and as the QEMU implementation didn't materialize,
>> nobody seemed to care ...
> 
> Heh, but that one said:
> 
> +\item[ VIRTIO_BALLOON_F_WS_REPORTING(6) ] The device has support for
> Working Set
> 
> Which does not seem to reflect reality ...
> 

I dug a bit more into cross-vm, because that one seems to be the only
one out there that does not behave like everybody else I found (maybe good,
maybe bad :) ).


1) There was temporarily even another feature (VIRTIO_BALLOON_F_EVENTS_VQ)
and another queue.

It got removed from cross-vm in:

commit 9ba634b82b55ba762dc8724676b2cf9419460145
Author: Daniel Verkamp <dverkamp@chromium.org>
Date:   Thu Jul 11 11:29:52 2024 -0700

     devices: virtio-balloon: remove event queue support
     
     VIRTIO_BALLOON_F_EVENTS_VQ was part of a proposed virtio spec change.
     
     It is not currently supported by upstream Linux, so removing this should
     have no effect except for guest kernels that had CHROMIUM patches
     applied.
     
     The virtqueue indexes for the ws-related queues are decremented to fill
     the hole left by the removal of the event VQ; these are non-standard as
     well, so they do not have virtqueue indexes assigned in the virtio spec,
     but the proposed spec extension did actually use vq indexes 5 and 6.
     
     BUG=b:214864326


2) cross-vm is aware of the upstream Linux driver

They thought your fix would go upstream; it didn't.

commit a2fa119e759d0238a42ff15a9aff0dfd122afebd
Author: Daniel Verkamp <dverkamp@chromium.org>
Date:   Wed Jul 10 16:16:28 2024 -0700

     devices: virtio-balloon: warn about queue index mismatches
     
     The Linux kernel virtio-balloon driver spec non-compliance related to
     queue numbering is being fixed; add some diagnostics to our device that
     help to check if everything is working as expected.
     
     <https://lore.kernel.org/virtualization/CACGkMEsg0+vpav1Fo8JF1isq4Ef8t4_CFN1scyztDO8bXzRLBQ@mail.gmail.com/T/>
     
     Additionally, replace the num_expected_queues() function with per-queue
     checking to avoid the need for the duplicate feature checks and queue
     count calculation; each pop_queue() call will be checked using the `?`
     operator and return a more useful error message if a particular queue is
     missing.
     
     BUG=None
     TEST=crosvm run --balloon-page-reporting ...


IIRC, in that commit they switched to the "spec" behavior.

That's when they started hard-coding the queue indexes.

CCing Daniel. All Linux versions should be incompatible with cross-vmm regarding free page reporting.
How is that handled?

-- 
Cheers,

David / dhildenb


