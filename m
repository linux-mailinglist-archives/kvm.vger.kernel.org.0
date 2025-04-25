Return-Path: <kvm+bounces-44307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70689A9C907
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63F647B4F2F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55996248889;
	Fri, 25 Apr 2025 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5yMonIL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C324BD04
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745584527; cv=none; b=FeDXoqc5fM6lMN1zpPKJGfZh7ihk13BdjSaUczZtzBNghXX8X6T8UAoaX4AVYlqoRlIzffnY6FueMqbpWyGQ/4y6DIiJdu9ZOeA6peleZy0buYSIgZfJltUY/UidTZID/EyZUYOG+Gvgi14wJK71E8to/wHtGB1ACfrKwU6cjjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745584527; c=relaxed/simple;
	bh=bl1BNBML5e/z8SbX0ipYAkBKlaepjtxPsMEYlC3+WhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZOrrMSGJK5/QYsxu6czNTEQdYo03DqDSWqFlrDhoLjug6pA0AN1RJI6ANjrlgdbS6xnCZlz/3GX2nSZJi0XGZZPY5V7idL17D+Lh8fOkm6EdQTJdKlgfGlX2G+t/dvR9sHd3OE6MU/B55ZhKIZ5xRZ9bWGxsof63CbeSpL2B5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5yMonIL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745584524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oCSYk21fTvbCfROTPzWI57OHSkghy+8C+pEVm/cbo1E=;
	b=g5yMonILxvLNR9R2INPJZFNUleW6MlIaaPHcI/9DwJOz+Fh30yTeyTmntj2md6w+ZoFEft
	xCWp+r3SdUPa6X/U0quZmi+8pjrvl8P24jOI+X0QwLXxmPqr36FOzsYjB0JXJiE90y4pt+
	ZA0Rp1mm1IcIRotOXLCEro6mIPMxNNg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-FCSdyijMPfSYxIJOum2uxw-1; Fri, 25 Apr 2025 08:35:22 -0400
X-MC-Unique: FCSdyijMPfSYxIJOum2uxw-1
X-Mimecast-MFC-AGG-ID: FCSdyijMPfSYxIJOum2uxw_1745584521
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39135d31ca4so832736f8f.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745584521; x=1746189321;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oCSYk21fTvbCfROTPzWI57OHSkghy+8C+pEVm/cbo1E=;
        b=KPMclZ4nRJR2UcAiQAFWVePWBrJWHIawdcw1Mdg0o5231Stz5jJoFKOfYk+rT+hWXv
         XjSx+fzjWBhtJeplhRG65IaxR+BK1WEvXOvMWbOv5TbFFqsElfvnu4CTbrEg+aLvkZ/P
         vNPe2XJLYiNyvG/liTF/BenuUn4Wjmk8LU1GMa9OaOXPIB3BIL+vlqg07FNCetyepawJ
         Xkh33sRGgHefjDyTVRr/SghT9/eFRHIOjJYOZV/PMuzV8mK9rbZT051bcz9S6exG2o1y
         8jA3LLzZt4ZFKC38NGCEzzBhj1Sl+Y02letQ/3dGM4ghOZ+GwRGX01i3MH910pNO3i1C
         YE+g==
X-Forwarded-Encrypted: i=1; AJvYcCUjZ8VlgMRrrwV8M/zWsgVpGSvSTKHgX6Hf1yBJlYvGwhL7Jpsdnu4HCo1ExGMdzqtJyuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPRfa/HZA5NFVGWwmrp+2zMZBbbLRzYPTKatI1CoUq+Mc3ciej
	FRJIpwso5OAlFFQY7TVIpCK8dIe+bjaHcQJ5K6Bzbw0xf2CtPLlNc5WIxb1DEr+vGu3FcF4YLh2
	AwfDYQBJXIMVkj7K4+qknd2SVDTWW1u9gZwdzG8UMmptm8dF7wA==
X-Gm-Gg: ASbGncvboP5SuX04d+JtERZZAD0++2HcatsZaIwy+pKZ4JCqAB8qDyZcMGgRfq51E0T
	bTfScQqCGJ78aYZ1SjIqbfLwt+o5aYnpkzxwDZxKQHMIzRBAz7K2VEHTwnKuYHsYtu53nw84cwr
	RBwUwqfwrGe2iZ2IY+Yiv/axe+BP0qacF1Kmj2LXhurnGZwRBcDO3/53XD0JeHEm6ppHN1z5F6b
	Em+DBbe99KkfM2+4RTEe+pu0U9og2tSRUROvr3x9aXdm+OUmbVK3FWXC4qTY7ARkn0rj3bd4Xv0
	XOdH9zGy/eaN9X0nxecOn/gSc0STZJG+YsW1uFFyAQ==
X-Received: by 2002:a05:6000:4313:b0:391:386d:5971 with SMTP id ffacd0b85a97d-3a06d66d21cmr5292593f8f.14.1745584521274;
        Fri, 25 Apr 2025 05:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF35EBNlLy12KC3xCfWWQicrt19aNwkw/jItNvq1tEUmbDBEF5INyWJtfJlOJfNi6XEu53FLw==
X-Received: by 2002:a05:6000:4313:b0:391:386d:5971 with SMTP id ffacd0b85a97d-3a06d66d21cmr5292568f8f.14.1745584520824;
        Fri, 25 Apr 2025 05:35:20 -0700 (PDT)
Received: from [192.168.3.141] (p4ff23df8.dip0.t-ipconnect.de. [79.242.61.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a536a02csm23854305e9.27.2025.04.25.05.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 05:35:20 -0700 (PDT)
Message-ID: <39ae9a9e-9108-464f-9e2e-03e16976607a@redhat.com>
Date: Fri, 25 Apr 2025 14:35:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-3-chenyi.qiang@intel.com>
 <d4b44d77-3522-42bd-b02f-fe2e9be65857@amd.com>
 <7436cdd9-513c-483a-a994-8602142c7551@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <7436cdd9-513c-483a-a994-8602142c7551@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

                               RamDiscardManager *rdm);>>>      /**
>>>     * memory_region_find: translate an address/size relative to a
>>> diff --git a/system/memory.c b/system/memory.c
>>> index b17b5538ff..62d6b410f0 100644
>>> --- a/system/memory.c
>>> +++ b/system/memory.c
>>> @@ -2115,12 +2115,16 @@ RamDiscardManager
>>> *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>>>        return mr->rdm;
>>>    }
>>>    -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>>> -                                           RamDiscardManager *rdm)
>>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>>> +                                          RamDiscardManager *rdm)
>>>    {
>>>        g_assert(memory_region_is_ram(mr));
>>> -    g_assert(!rdm || !mr->rdm);
>>> +    if (mr->rdm && rdm) {
>>> +        return -EBUSY;
>>> +    }
>>> +
>>>        mr->rdm = rdm;
>>> +    return 0;
>>
>> This is a change which can potentially break something, or currently
>> there is no way to trigger -EBUSY? Thanks,
> 
> Before this series, virtio-mem is the only user to
> set_ram_discard_manager(), there's no way to trigger -EBUSY. With this
> series, guest_memfd-backed RAMBlocks become the second user. It can be
> triggered if we try to use virtio-mem in confidential VMs.

Right. I have plans on looking into using virtio-mem for confidential 
VMs, so far it's not compatible.

One challenge will be resolving how to deal with two sources of information.

Assume virtio-mem says "memory is now plugged", we would have to check 
with guest_memfd if it is also in the "shared" state. If not, no need to 
notify anybody.

Similarly, if guest_memfd says "memory is now shared", we would have to 
check with guest_memfd if it is in the "plugged" state.


I don't know yet how exactly the solution would look like.

Possibly, we have a list of such "populate/discard" information sources, 
and a real "manager" on top, that gets notified by these sources.

That real "manager" would then collect information from other sources to 
make a decision whether to propagate the populate / shared notification.

-- 
Cheers,

David / dhildenb


