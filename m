Return-Path: <kvm+bounces-33340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 949599EA132
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 22:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6290928160A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 21:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6D319C56D;
	Mon,  9 Dec 2024 21:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JI+WoS3O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77EC49652
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 21:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733779511; cv=none; b=LBBoY1YIHQy+84chvnK5XkSemNsglcHiWCxnPiMYODe1g3w5wVVodFVtmc/s5QJqpK8m/nFRbDB7Uu6TMGgcsUNyZ4ICV6kMgM4LET72UTol6+se7Krtt27/mEf/lIyyeQqq5/ps8XidI9deb3FJB2EumyHiv267c8krWNEtaAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733779511; c=relaxed/simple;
	bh=zt3j15meuhU9z0Hqt8gwimJ5K5pg++QpLP15kw6acrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGievbAMarpyGozRuhdEvUNKnqvNbUI99lCxOGINwOLIu3sg3oa3lk4y06WsJmfNhOv5oLJIDlpqpVRCivEuRF+9VtG+hzHGK6wFKr/YlmTBBNs4kqb3VOqbL/JlGPk8ienBSp3BiHfqoujcnKPUON16sBSTXO9FDX4FUrUHeaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JI+WoS3O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733779507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j96UWfCWU3VnvpcsGtLXmdB5SzrLEIh69S7WhK/JWdw=;
	b=JI+WoS3OBrigyU0+loQRPcfUuq0RMKrVk31bT2EpSvMWS3Ms2o8JlNz2uuS+5kxW/xdDDr
	tKHWzusHixmwG6ePxyxv8SzBRGkKoVHUxQ3b4dj2uRYAyBZTLuW58Q2Nc+d7SIh4anUg4r
	GnxD8y2TyR8pP9a2I7pPAG+BGYBWZ+E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-rvl6k1iVMmGGNAP-oCD_Fg-1; Mon, 09 Dec 2024 16:25:06 -0500
X-MC-Unique: rvl6k1iVMmGGNAP-oCD_Fg-1
X-Mimecast-MFC-AGG-ID: rvl6k1iVMmGGNAP-oCD_Fg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434f15b4b6fso11669195e9.0
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 13:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733779505; x=1734384305;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j96UWfCWU3VnvpcsGtLXmdB5SzrLEIh69S7WhK/JWdw=;
        b=Mcw0td2GNDOygSxiyyR7gjh/ApPWtaEWQtBaXdulCfrSSpAU+V8Mkxt80NKnmQ40/8
         3Tyd+8YcgtAyNNM1ZIOOy/8rl4XJIwa6Os++INYXsroq2VdxY3pEt6y51fR55sYYalvr
         hZhL/0e4B1rK9uST7ea1QDJPco/WufBd+KB7dV/GfG6lmV0UnisPe0V7EABqaHv6625d
         yA6Y0dB23pknm7mMcrVJA7KlPQViAn9lgwDXwKgqStLJwpSMIuP4i86lUtbWOhtdzXLv
         le6w/mdX22HamD+1AcnOplHxkZNWv9CjJGrCJ2Yuh3bqXLV+SEYDGbGXdeck/w8DgJR/
         O2Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVD85EXBAdh5KLxYojfvNe4mBrrTepEdKp3Am8mboHhpzUZio3NPHgCmN5QXc5rKV7r7tE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdSihZcMoiH7XX/BVSFpwdJz3XBZ5P6wAR2Tss/kpFYHOVGoDX
	BFz8v6NsjaCLLk/tgmGCzwYO05RSg7OPJJehQMTeY9vaWNdwgDkvZi2ignuFfiK2woizxGmStCq
	d0Ut3S6y1RpRo2+Pjh1pz+TumTki2hht7Adh15aYtt24f/5b6Ug==
X-Gm-Gg: ASbGnct1ETn9fHxgwHxsKWtng+JfQskaOqY/gVufcDGPk+UkaGav0uIOYGZ4JTIfEmF
	J4aXNlMfcJYUFEThLQ0/7cSiHJJEUCSJnVq0T321onbcxiqntTn3hDCvnS0VuSNI5y8bwpONB9U
	9Zz0L4xn5cSHp2ac77NJ84+ijgZrlTZJb7L21WsJgzIMlnb107174ZQIdot0Vdb+9uYarQbmR0b
	sG55PQL5cJ/TSZza/EoMJWC3Ks8/k3r04niBdBeiJZejZnB0ZI4uyDe062fHS2hDyUHXXEjTtPF
	xYUw2AnCdBZawr2vWmaPLXf+pdWxpWKmTdFJSTRyjf2F88OOgteTUAu6mAUxsB3CRuZ8IGWHsAg
	MgAkOzQ==
X-Received: by 2002:a05:600c:3b95:b0:434:9f81:76d5 with SMTP id 5b1f17b1804b1-434fffd049fmr16474305e9.22.1733779505482;
        Mon, 09 Dec 2024 13:25:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsJ5vUkNjuH6KMQ2ioBSBfjp4gZ50qKr8en1g+0WGIvk0YGj3Lb0lFq1enwvnvBRgI8cfHzg==
X-Received: by 2002:a05:600c:3b95:b0:434:9f81:76d5 with SMTP id 5b1f17b1804b1-434fffd049fmr16474165e9.22.1733779505136;
        Mon, 09 Dec 2024 13:25:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c71b:2c00:7bfb:29fe:9e6f:2e65? (p200300cbc71b2c007bfb29fe9e6f2e65.dip0.t-ipconnect.de. [2003:cb:c71b:2c00:7bfb:29fe:9e6f:2e65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386219096adsm14438726f8f.85.2024.12.09.13.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 13:25:04 -0800 (PST)
Message-ID: <4825dc70-bca4-437f-a406-df0936aada85@redhat.com>
Date: Mon, 9 Dec 2024 22:25:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
 <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
 <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
 <753a033c-7341-4a3a-8546-c31a50d35aff@redhat.com>
 <31693f78-dbef-4465-9c8e-a68a25cb4af2@oracle.com>
 <fcf373b2-cb33-4764-a2bc-c95a0d76710b@redhat.com>
 <c5789e2c-e4e1-4203-8b0a-d7aba461497d@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <c5789e2c-e4e1-4203-8b0a-d7aba461497d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06.12.24 19:26, William Roche wrote:
> On 12/3/24 16:00, David Hildenbrand wrote:
>> On 03.12.24 15:39, William Roche wrote:
>>> [...]
>>> Our new Qemu code is testing first the fallocate+MADV_DONTNEED procedure
>>> for standard sized pages (in ram_block_discard_range()) and only folds
>>> back to the mmap() use if it fails. So maybe my proposal to implement:
>>>
>>> +                    /*
>>> +                     * Fold back to using mmap(), but it should not
>>> repair a
>>> +                     * shared file memory region. In this case we fail.
>>> +                     */
>>> +                    if (block->fd >= 0 && qemu_ram_is_shared(block)) {
>>> +                        error_report("Shared memory poison recovery
>>> failure addr: "
>>> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>>> +                                     length, addr);
>>> +                        exit(1);
>>> +                    }
>>>
>>> Could be the right choice.
>>
>> Right. But then, what about a mmap(MAP_PRIVATE, shmem), where the
>> pagecache page is poisoned and needs an explicit fallocate? :)
>>
>> It's all tricky. I wonder if we should just say "if it's backed by a
>> file, and we cannot discard, then mmap() can't fix it reliably".
>>
>> if (block->fd >= 0) {
>>       ...
>> }
>>
>> After all, we don't even expect the fallocate/MADV_DONTNEED to ever
>> fail :) So I was also wondering if we could get rid of the
>> mmap(MAP_FIXED) completely ... but who knows what older Linux kernels do.
> 

Hi,

> I agree that we expect the ram_block_discard_range() function to be
> working on recent kernels, and to do what's necessary to reuse the
> poisoned memory area.
> 
> The case where older kernels could be a problem is where fallocate()
> would not work on a given file

In that case we cannot possibly handle it correctly in all with 
mmap(MAP_FIXED), especially not with shmem/hugetlb :/

So failing is correct.

, or madvice(MADV_DONTNEED or MADV_REMOVE)
> would not work on standard sized pages. 

I assume both can be expected to work in any reasonable Linux setup 
today (-hugetlb) :)

> As ram_block_discard_range()
> currently avoids using madvise on huge pages.

Right, because support might not be around for hugetlb.

> 
> In this case, the generic/minimal way to make the memory usable again
> (in all cases) would be to:
> - fallocate/PUNCH_HOLE the given file (if any)
> - and remap the area
> even if it's not _mandatory_ in all cases.
> 
> Would you like me to add an fallocate(PUNCH_HOLE) call in the helper
> function qemu_ram_remap_mmap() when a file descriptor is provided
> (before remapping the area) ?
 > > This way, we don't need to know if ram_block_discard_range() failed on
> the fallocate() or the madvise(); in the worst case scenario, we would
> PUNCH twice. If fallocate fails or mmap fails, we exit.
> I haven't seen a problem punching a file twice - do you see any problem ?

Hm. I'd like to avoid another fallocate(). It would really only make 
sense if we expect fallocate() to work but madvise() to fail; and I 
don't think that's our expectation.

virtio-balloon has been using ram_block_discard_range() forever, and so 
far nobody really ever reported any of the errors from the function to 
the best of my knowledge ...


> 
> Do you find this possibility acceptable ? Or should I just go for the
> immediate failure when ram_block_discard_range() fails on a case with a
> file descriptor as you suggest ?
> 
> Please let me know if you find any problem with this approach, as it
> could help to have this poison recovery scenario to work on more kernels.

I'd say, let's keep it simple. Try ram_block_discard_range() if that 
fails (a) and we have a file, bail out, (b) we don't have a file, do the 
remap().

If we ever run into issues with that approach, we can investigate why it 
fails and what to do about it (e.g., fallocate).

My best guess it that the whole remap part can be avoided completely.

-- 
Cheers,

David / dhildenb


