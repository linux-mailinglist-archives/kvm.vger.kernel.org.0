Return-Path: <kvm+bounces-36007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB83A16D2B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CD50161DB3
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A9D1E9B01;
	Mon, 20 Jan 2025 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GCfgkzV8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3118C1E98EB
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737378713; cv=none; b=izETmChup+dmUGluKo5qttZ9q53oGvcqULvMzAS6a+zy/Ty7wP02OFy2HYuI74qU46A2blx0BzaNoJYyMBc6ObB0VvR9UCaH8N+TSyUJdcePBKUdCuUZgu9SKgzKGRscFXplYm+RsHVWCBmv7XkW+bN1BOQz01pB8/EG2NWAlMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737378713; c=relaxed/simple;
	bh=LmCQHZL+l8E73lvYNAgpECdYZ3nWy2SQsRnO0fF+4Zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrjtDFP7a67iOesV8Rnxinw02A2iQnGsC+Qzdbi5WSpHL9AgzRPbwt6j1NeX8Yd4N2WHpO0BygoatahSUrs382TjAoWS9zdJmrAxOkbomMaL4Cmb6IiLONMLV1exNomQhcPqcORvhI+QT3A5N2/Ah34m/Mw7oTBfNc2uRll29FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GCfgkzV8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737378710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EkId6Dizwe8M3u3G4j0v237niZnElc9Bfl2LfYJG038=;
	b=GCfgkzV8tKtrnBZ6yqOfWhT04LVIq4dAXXnYKcNrYn0FkKIxzAL1xPWZs5uimYEmyGLxAs
	tg/xc4hZbl1iOAMpZbh+z2mnPXkobz1NPeIhjtKZ+xSCvit2Y7WF2frGgxQYlq+a5+bHbz
	iT/yV7pCVO1E4NvPiATJM5VFHGFjdJk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-ztKsGvB7MFqmLMWiVlVVFQ-1; Mon, 20 Jan 2025 08:11:48 -0500
X-MC-Unique: ztKsGvB7MFqmLMWiVlVVFQ-1
X-Mimecast-MFC-AGG-ID: ztKsGvB7MFqmLMWiVlVVFQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436248d1240so21650855e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 05:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737378707; x=1737983507;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EkId6Dizwe8M3u3G4j0v237niZnElc9Bfl2LfYJG038=;
        b=HxXbwCwj4bKWnwg+ul5+biZEB22lAsqCQRt03BT8RG2jJ8kMxPCPk0iMLChKpMOX98
         lP5JWjrbSVVJkHjDwg1YSrVZkEs2PHKoOhnQqQy4bJgnoWcqepl98cG7Kfyq293PoeeK
         ngk6plEyzCpdgpBFCBmVN00IlNpYVuVVrdnns5yPBZcMqWUngJrfHNJxUvxuD7St1wnc
         FAQqhstSJgHwK2b6ddg/i+14omoqfuoxKJkRxbAhHE6UcYiuXaVIV/5JdutHbeOEdL5w
         NM2xvRBF7/w9GtcvUIuXKOOq7c8woRPtxiYwq3JHmt/YTPirC2woJnLx0EdlILC3GH4K
         t1/w==
X-Forwarded-Encrypted: i=1; AJvYcCUQU43M7VohiEVwTZy21Mj7B4AM5wx8NZruFgDm4BoDIQdZKHW56mvouM+JnCAb29TsM5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJpgh+5VzegJSw1EBOokhEg7czLg3izrvLrA2SczsbNFxGN3vX
	nYKF2cYzNIgbfUxIgRjnMOpsm3B3NplhdyL1sq74g04hVwWfQ4t8mttevRBJ0KJkexXsQUzDRtq
	GoQL2+Gfc5o6HgPbhAoqgAtFRaV4JeL77ejYsY0dqJvxOgPtoSg==
X-Gm-Gg: ASbGnctTK6b/N6UhT3Vq+m1w6mhAB6kwB4FipIxwAch9DumN/6uBRlNG2FB8+ZE7p8y
	nJpPagaTqIa7yUnZK7yaRtciHwRdeNV+V/9149Kbb0aGcuPFT9gdQZ2CujFZYIC++I9mbrLu37T
	AnBaIWOc70fulBhxawYHMZJsnI5b5fPLt9QiF0llad4odlZX6BlHJ51IVYJ/RRY0Pfeqhlmg+zb
	copj3GEITlgHHLrMk8+/nb+r7gcdkksI4tQAOFj/IQiGONyzB/QEOhwprQC/uYjlp7im7/toM7S
	6kMBAq1NxreBorO1uOqSL3HkFexKMBce0Bb5C0NdByD2UzTt7WfCLhQGNF0hLPloLxHzRuaa8K9
	rF0OhpWl1s0VgVXWlt0fKAw==
X-Received: by 2002:a05:600c:1987:b0:434:a7b6:10e9 with SMTP id 5b1f17b1804b1-438913e2fa9mr127155335e9.17.1737378707444;
        Mon, 20 Jan 2025 05:11:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3Xz8y5mY8TSR1+MfxFJnV8s6JaJjUYaM2lwOv7ebxUnqn7z/oeFplN4qqcdvcqgxndq945Q==
X-Received: by 2002:a05:600c:1987:b0:434:a7b6:10e9 with SMTP id 5b1f17b1804b1-438913e2fa9mr127155045e9.17.1737378707088;
        Mon, 20 Jan 2025 05:11:47 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74c4f85sm201595085e9.18.2025.01.20.05.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 05:11:46 -0800 (PST)
Message-ID: <e1141052-1dec-435b-8635-a41881fedd4c@redhat.com>
Date: Mon, 20 Jan 2025 14:11:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] RAMBlock: make guest_memfd require coordinate discard
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-7-chenyi.qiang@intel.com>
 <3e23b5b0-963c-4ca1-a26b-dd5f247a3a60@redhat.com>
 <b01003cd-c3d1-4e78-b442-a8d0ff19fb04@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b01003cd-c3d1-4e78-b442-a8d0ff19fb04@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.01.25 02:38, Chenyi Qiang wrote:
> 
> 
> On 1/13/2025 6:56 PM, David Hildenbrand wrote:
>> On 13.12.24 08:08, Chenyi Qiang wrote:
>>> As guest_memfd is now managed by guest_memfd_manager with
>>> RamDiscardManager, only block uncoordinated discard.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>>    system/physmem.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index 532182a6dd..585090b063 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block,
>>> Error **errp)
>>>            assert(kvm_enabled());
>>>            assert(new_block->guest_memfd < 0);
>>>    -        ret = ram_block_discard_require(true);
>>> +        ret = ram_block_coordinated_discard_require(true);
>>>            if (ret < 0) {
>>>                error_setg_errno(errp, -ret,
>>>                                 "cannot set up private guest memory:
>>> discard currently blocked");
>>
>> Would that also unlock virtio-mem by accident?
> 
> Hum, that's true. At present, the rdm in MR can only point to one
> instance, thus if we unlock virtio-mem and try to use it with
> guest_memfd, it would trigger assert in
> memory_region_set_ram_discard_manager().
> 
> Maybe we need to add some explicit check in virtio-mem to exclude it
> with guest_memfd at present?

Likely we should make memory_region_set_ram_discard_manager() fail if 
there is already something, and handle it in the callers?

In case of virtio-mem, we'd have to undo what we did and fail realize().

In case of CC, we'd have to bail out in a different way.


Then, I think if we see new_block->guest_memfd here, that we can assume 
that any coordinated discard corresponds to only the guest_memfd one, 
not to anything else?

-- 
Cheers,

David / dhildenb


