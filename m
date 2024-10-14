Return-Path: <kvm+bounces-28720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F3999C5D4
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F5532855FC
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 09:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0D7155CB0;
	Mon, 14 Oct 2024 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fr52SD4Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F51155303
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 09:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898476; cv=none; b=htjXPFCaT1WcGPxMclHo+Wam9MwtYc0lP1BXXk2UEK0xwvtIiPyiqzEUKyeQal+Z55Vj6YuescEgg45Rbn9wFufHeaNWGk6Jt8/4TxK9pO/ELn5HTyaiDJ5926oeswCm6DQLJTeDc1nL4CZFnbxZVRZk/g6amha8peLzhi06nek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898476; c=relaxed/simple;
	bh=MzIkKBP6kTupistwX07xdMrJP7TLu6YBP3QM5gE7UWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdftNeO/tM/bXGm72MnVDowMnVPGpyTtPTJrAcJzFwSKwv4NJjkEtIoeP3l/NZ/B4KKbRe5XYWRCait8lxRw/1hENykB8mrzc/mYyLAlFvjn1vi1cNmHAUGj8+MZfibdXhWJtp5FdBmhct3UaRJMJgpkgH4EFe5AOSgArm2PJ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fr52SD4Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728898474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9pjXZCdVLkiltwg5DWQH/O4Om3DKCIGFAYS2woLtTEE=;
	b=fr52SD4ZjTjjUz/Y57iJlgiAWfzRAiltf1TGn3FxVqv2MFQeBGP2rlVR1x4bDaizreYbll
	gvdqRsv5YDi6kUY5EVppc0IFT9a9kbN91CYdIxnezzn6R8XC0aI24PK6iHr2D8PJx2/Vsk
	MIAwc/S1Znj9ZT69L3+qG9XoaKxu0pQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-fT3-sNPMMJiOpZpDTSJ7kg-1; Mon, 14 Oct 2024 05:34:32 -0400
X-MC-Unique: fT3-sNPMMJiOpZpDTSJ7kg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-536800baa8aso4795991e87.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 02:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728898471; x=1729503271;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pjXZCdVLkiltwg5DWQH/O4Om3DKCIGFAYS2woLtTEE=;
        b=Y2myZljrgYelX68PunF+nn1qfXaVmHGi1mq9Xc0FaO728vrC8PD906sB17yOS/vqTO
         CGbsD9gUULjsoLo5MGMKOp5RAELCnNQLKmP/yMVr/zLzhWdqEQJPnUb4sTQQHB+N+hIw
         +8iTUZiVB8LRxDRG6Fn5UtCylR1PPXInCX1w/m0DazwS8pA6/VY82kgYJ9OtWHa/Pnbr
         d4qLtmmmOY+VLdBQk6vFG3poo5Hrzt8P8Bed3DfOvNzONWRlvucX9OGXdtgs/f8dlg+w
         DXCRzH0bMSeBpctL4BA2o1i7azJ88WgEf1E0GBUJbFsnVyUYcyG+JtRoOJQctCbcWQP9
         OrgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUliA4agK4sWEp+fxA1NWxj3saw7ew7cZ7mqAyyC/eSF0uRIhaabV1t+hAYh4s2yF6p4YM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAZYWxIwWMKxzVagZGlE92zL4D81D019/gvKgYvEbEmURmucqg
	dllP+y4lRMMf7Y99ANDQKdTUJNh+XfFA9J2jxDY2BiGhvrRgUj3iKMOUv3U3/lCoZg4ZF1jRtQw
	eMSUoABCNCPVvw41S8OmapAi/Fep43hWIX1E1sMtqaZLY/WJCVg==
X-Received: by 2002:a05:6512:3b93:b0:539:983b:ea75 with SMTP id 2adb3069b0e04-539da5ae6b3mr4704799e87.57.1728898471129;
        Mon, 14 Oct 2024 02:34:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNLNg3W02/w9MPbHsdhMdxIxOSDuRscebq5wpEwTK+RvCOclGTnCB6wl2OViFmzYrbHeRmyA==
X-Received: by 2002:a05:6512:3b93:b0:539:983b:ea75 with SMTP id 2adb3069b0e04-539da5ae6b3mr4704773e87.57.1728898470612;
        Mon, 14 Oct 2024 02:34:30 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431182d78b4sm115939835e9.10.2024.10.14.02.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 02:34:30 -0700 (PDT)
Message-ID: <ddab4fa2-c850-4ba2-b707-1dfd962d59da@redhat.com>
Date: Mon, 14 Oct 2024 11:34:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: Vlastimil Babka <vbabka@suse.cz>, Ackerley Tng <ackerleytng@google.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
References: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com>
 <0f47fad8-50ef-425b-8954-38c26cc0a054@suse.cz>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <0f47fad8-50ef-425b-8954-38c26cc0a054@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.24 11:05, Vlastimil Babka wrote:
> On 10/10/24 19:14, Ackerley Tng wrote:
>> David Hildenbrand <david@redhat.com> writes:
>>
>>> Ahoihoi,
>>>
>>> while talking to a bunch of folks at LPC about guest_memfd, it was
>>> raised that there isn't really a place for people to discuss the
>>> development of guest_memfd on a regular basis.
>>>
>>> There is a KVM upstream call, but guest_memfd is on its way of not being
>>> guest_memfd specific ("library") and there is the bi-weekly MM alignment
>>> call, but we're not going to hijack that meeting completely + a lot of
>>> guest_memfd stuff doesn't need all the MM experts ;)
>>>
>>> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
>>> development of guest_memfd, in particular:
>>>
>>> (1) Organize development: (do we need 3 different implementation
>>>       of mmap() support ? ;) )
>>> (2) Discuss current progress and challenges
>>> (3) Cover future ideas and directions
>>> (4) Whatever else makes sense
>>>
>>> Topic-wise it's relatively clear: guest_memfd extensions were one of the
>>> hot topics at LPC ;)
>>>
>>> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
>>> starting Thursday next week (2024-10-17).
> 
> works for me!
> 
>>
>> This time works for me as well, thank you!
>>
>>>
>>> We would be using Google Meet.
>>
>> Thanks too! Shall we use http://meet.google.com/wxp-wtju-jzw ?
> 
> So is it going to be this one?

I'll follow up with a proper invitation mail today or tomorrow.

> 
>>
>> And here's a calendar event if you'd like notifications:
>> https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NDJvYjBha3FlMWpxdHFzMGNpNnQzZDk5cjBfMjAyNDEwMTdUMTYwMDAwWiBhY2tlcmxleXRuZ0Bnb29nbGUuY29t&tmsrc=ackerleytng%40google.com&scp=ALL
> 
> gcal says it cannot find such event?

Calender needs to be public. Let me give it a try and include it in the 
mail I'll send out (then, I can also modify/cancel the event etc. ).

-- 
Cheers,

David / dhildenb


