Return-Path: <kvm+bounces-47166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4587AABE1F2
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE8E03AEEF0
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBB727FD72;
	Tue, 20 May 2025 17:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2V3gB8Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF591A83FB
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 17:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747762886; cv=none; b=FCi/bCDGCr8mAlg5199sGE4DcRxUu+i+FSric3rbswQNNIdTWQLdpaZleHUSD1KhTz9302wjq0gAiZJRby2ftyPw6ir9mVOyhfRJpPrh/y3hp9SQR4zpN1apMffJOJaknZCufIGBTWDyXdllB8ssS64dpin5AyWh4AQDNejZXQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747762886; c=relaxed/simple;
	bh=37YGEwIZyc38aYygcTWPR7M6+MYC8cK3Os1zr9tPoBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SU/eiDnNHkPWtOQGdigef5H86BShSJ7cf/EcFnJ6vK8FQfAaEVkxXzrBZP3dOU8Z1kwpyruDyJDzzQd8QHns/tgCF64PHiWdVcD8QTniV9LLDpk4CQINWgaeMOHczEi0nCzlBm1NqpCQaHoDC9EEH5cIdkyWhw9CXx8CvoWUzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2V3gB8Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747762883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ysy5nbN//FN9RtI8JoLcFahaJUzYzYV0wTw0kNVJLOQ=;
	b=e2V3gB8QOLI0mIF2//KMTmNAlU/VzAuQ7b6WQqbrsa76AnHzY6ndmMEpVrnbIKUHdRl+4N
	rBaaIZ+eW9h4Uszg2IzdcSomcfaSp0PG9zZ7nUy2sSULCUexRc3FyMbsCWgCwy8bgEA2M2
	mzaJv6VJ4tir6e+g7Kkf7a78JYTzaG0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-4XxIQDSrMry70M92dRkD8Q-1; Tue, 20 May 2025 13:41:21 -0400
X-MC-Unique: 4XxIQDSrMry70M92dRkD8Q-1
X-Mimecast-MFC-AGG-ID: 4XxIQDSrMry70M92dRkD8Q_1747762880
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a3696a0ce6so1376646f8f.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747762880; x=1748367680;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ysy5nbN//FN9RtI8JoLcFahaJUzYzYV0wTw0kNVJLOQ=;
        b=sB7qaMKT1speBmy6WfI1vPwnDEnyrUM9myP7KMMbtKVI1KaZ9I4F4woB42aVhdDyqq
         JW2cgiVmoSGzhmOozqaZ90uUwgO+ezP/wASBzzNNWV3cBsyKBf3B5hv21YMy5HOL0OA1
         x2JOTEP6PnJxdIH6V4vCi/jBCfkfMZcmoqfuUTqnV9YEe7UAx0tximcYk4Zme6SRc0Lx
         XuO1rDpA/bB5oQQy/vVbx9by26SRph8NqgPB+Y83mcsbeXkMqT9YON/ZTJIaZRZWP8ra
         Apq/r/n/h4IL37wKnwTeCCl7AAtOkKWLPXPCKPILziQDxw8wzqnObpWHZ/bAShnP66BL
         O5LQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf0pP9I3KjQiEs0tQ20FZODczKcqWV9zkNDqbTis/XTuhPIpoHdRY6MLjyxD+WlPgGxXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP61ahD+pqUqxKYctfg2MnttpSLvhGZtolFjwJBJcOsV2TBkeI
	5pJnhekZMX9aLgGZsyVMPfJiafwQA+nb8iTcGaPAAHOMyoeTBkj+41sjabZb1TD550LxmzXraxG
	bpCLpBgmotZTFXu7uZDhsmC+/9k1n01jTGRW16nI6ycYFsQ8q3JSftg==
X-Gm-Gg: ASbGncukOtbUWIsyQZKHh9Tmmn3j6L6jHvjJwhWxC5ygaY84WiU6c6CrTYAI1Opyot2
	h9jnbNKeJLPq8HHcmWxz7UuKvniwiGvwEuzXd5MXTfXZVdlhQg0wCTAh1tn3dnvAdMPsYgleI8i
	KpLGQppakibHgkX4zKlm8POaU8tsnS+9yoJ2x3sZ1bmz07l8RBCwWa0Rf9Hoyl/alH9MG2+iUfX
	XI84oVkjIbpvW1LVNi7uu8qGLNmG2rgzOLDptyVk0q8RYBhM0ArOVEzELK2Sp7YZke0H7RSBsyA
	9fw59tL+etdZFBWPsHQ1NtOgwcRkKPhp8j8x2pEbdysCKk1+LYoqo5SqjHVcxJV1AJY9iNJIhG8
	wpHL/e8GI1gd+rQW38Ank/jk+s3OvxJdE+/+u9o8=
X-Received: by 2002:a5d:474b:0:b0:3a0:ac96:bd41 with SMTP id ffacd0b85a97d-3a35c84419bmr14536158f8f.27.1747762880574;
        Tue, 20 May 2025 10:41:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVar67bZRVSD8PpsU3J5LEAXnwScDfWp/oGgnm9nxCe1Kzs6/m3GZ6q4TndPdxjWM7t3oflw==
X-Received: by 2002:a5d:474b:0:b0:3a0:ac96:bd41 with SMTP id ffacd0b85a97d-3a35c84419bmr14536148f8f.27.1747762880240;
        Tue, 20 May 2025 10:41:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:7c00:a95e:ac49:f2ad:ab84? (p200300d82f287c00a95eac49f2adab84.dip0.t-ipconnect.de. [2003:d8:2f28:7c00:a95e:ac49:f2ad:ab84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d0fasm17260164f8f.8.2025.05.20.10.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 10:41:19 -0700 (PDT)
Message-ID: <8bd88c21-4164-4e10-8605-d6a8483d0aeb@redhat.com>
Date: Tue, 20 May 2025 19:41:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
To: Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: lizhe.67@bytedance.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <20250520080719.2862017e.alex.williamson@redhat.com>
 <aCy1AzYFyo4Ma1Z1@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aCy1AzYFyo4Ma1Z1@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 18:59, Peter Xu wrote:
> Hi, Alex,
> 
> On Tue, May 20, 2025 at 08:07:19AM -0600, Alex Williamson wrote:
>> Peter, David, if you wouldn't mind double checking the folio usage
>> here, I'd appreciate it.  The underlying assumption used here is that
>> folios always have physically contiguous pages, so we can increment at
>> the remainder of the folio_nr_pages() rather than iterate each page.
> 
> Yes I think so.  E.g., there's comment above folio definition too:

It has consecutive PFNs, yes (i.e., pfn++). The "struct page" might not 
be consecutive (i.e., page++ does not work for larger folios).

> 
> /**
>   * struct folio - Represents a contiguous set of bytes.
>   * ...
>   * A folio is a physically, virtually and logically contiguous set
>   * of bytes...
>   */
> 
> For 1G, I wonder if in the future vfio can also use memfd_pin_folios()
> internally when possible, e.g. after stumbled on top of a hugetlb folio
> when filling the batch.

Yeah, or have a better GUP interface that gives us folio ranges instead 
of individual pages.

Using memfd directly is obviously better where possible.

-- 
Cheers,

David / dhildenb


