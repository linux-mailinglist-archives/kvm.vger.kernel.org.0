Return-Path: <kvm+bounces-28620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3528699A2FB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E66C4284A7F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AE72141B9;
	Fri, 11 Oct 2024 11:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7i5ex9U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E488017D2
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 11:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728647428; cv=none; b=tIz3eki7pvWyih2x/CZtHf/RJS7knUWWiJw71siehKZvdWFTIF/cKJquqmn5A1Wi57HsBurx0Y2iIswIlALbzRT2ZbyhvWeuDyW4gK3xJ0xaz2q95eAvEm/euXVda645VgVBQ8YseiVEoINudukXhcbXqNz9jrZ8DimGz0kN1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728647428; c=relaxed/simple;
	bh=jXs+tvR3T2sfOgdDDPX36Uyoc+EueEgHAlfYIY6b4SM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VdKReU/8Tw0Emma02PuX8myoQVPgp9YWZaTPiJUqqhuMjZaKZofF53nlzv8E2qYbhoRsNE8XYAGZD+LtPpPY9eu8oUzIeoagct/atEPaTn258jAVbglAgJMI7H6XZeI8B+7jU/eszz8+wnBQy7txaJQp6Jzu3K6TmdOPzdtf4Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7i5ex9U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728647424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VNd+olTinR+Az5xuvHMtnLJBrIEidKth6Y7xvIaq0Bs=;
	b=I7i5ex9UoyOQXUEjYpyaw4cPAi+oSTns+Rnare2VMxporhsQX2jYHlZ663mYUlrTu32LBV
	youRB4P+/bmz9C9ALOL9Qbt4RsWFSQL9tE2i82xmL/Vfn6FSQKPsHP16/L+Q7c9c3ZUvuU
	ZunQxq2jMT/gkAnGDfyVUAgIXnZQaIM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-dhbbBEBKO_GUsQ4AihU-Sw-1; Fri, 11 Oct 2024 07:50:23 -0400
X-MC-Unique: dhbbBEBKO_GUsQ4AihU-Sw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4311db0f3f1so4881045e9.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 04:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728647422; x=1729252222;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNd+olTinR+Az5xuvHMtnLJBrIEidKth6Y7xvIaq0Bs=;
        b=HFYvbId741JyTBnEWm7D2/K7nMgJVzRnZIKTseYwb1BkKiLcBpRlffqfTAEDwBhPOb
         a9eMaspJgdEbn7pQ1BmN/f8iXkIOmPdClMb2HB+PiVlctEDqEl6LOLFR1/ouTFSIrzN9
         3FgV9NxqXEJbqNCfmA4t8v/KW9ig9ZTlL8VvAUD674AOBCfKU/lFbWTr4c87MHs47E2M
         4+f0M2U2Bh9LS/8hTGTXMi8qzJSPY/UDTxNi+aEa7YnbOp1YvxtVUzM48upx2laN1LEw
         2GCGGK1TWIyJOHZqd4qnjjW6i0BgCieHFw/Ur7EFcLq5Lvvkk5e8ds+qY8hxHwoP78v/
         sURQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVNdGhB/mlgirY/uBLOGikVXc4ukrqxpptkN/Sj83SwqceiopeuY48/i/U1AiuAKZr/8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9V7Y02eye9SRPDHCygkPbHrdNBxfNVMvuJf2YZOTUCLzBynYe
	ozwGK+TFuBeNJTQlEpHowR6FLLqg7Krt6Fj3aExJva2gfIW+c4gOa5H6/u0Zwz6FOizC8KUmJrW
	dp/nJp1jxmUfEeDxWC6+9ZH99ewoeQREuZiqxFLPVb2BuqwJpdA==
X-Received: by 2002:a05:600c:228c:b0:42f:80f4:ab2b with SMTP id 5b1f17b1804b1-4311dee6f58mr19373145e9.19.1728647421798;
        Fri, 11 Oct 2024 04:50:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEe4zP3dgdckIA1FJoIn+Owc99lvaOABl3u8J5ZHWT75MQxBB4REz4MYW0kPlh2glfJYYK9FA==
X-Received: by 2002:a05:600c:228c:b0:42f:80f4:ab2b with SMTP id 5b1f17b1804b1-4311dee6f58mr19372935e9.19.1728647421395;
        Fri, 11 Oct 2024 04:50:21 -0700 (PDT)
Received: from ?IPV6:2003:cb:c749:9100:c078:eec6:f2f4:dd3b? (p200300cbc7499100c078eec6f2f4dd3b.dip0.t-ipconnect.de. [2003:cb:c749:9100:c078:eec6:f2f4:dd3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43017466e4fsm67432015e9.0.2024.10.11.04.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 04:50:21 -0700 (PDT)
Message-ID: <d54f9b64-fc9f-4b63-8212-7d59e5d5a54d@redhat.com>
Date: Fri, 11 Oct 2024 13:50:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: Ackerley Tng <ackerleytng@google.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
References: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.10.24 19:14, Ackerley Tng wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> Ahoihoi,
>>
>> while talking to a bunch of folks at LPC about guest_memfd, it was
>> raised that there isn't really a place for people to discuss the
>> development of guest_memfd on a regular basis.
>>
>> There is a KVM upstream call, but guest_memfd is on its way of not being
>> guest_memfd specific ("library") and there is the bi-weekly MM alignment
>> call, but we're not going to hijack that meeting completely + a lot of
>> guest_memfd stuff doesn't need all the MM experts ;)
>>
>> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
>> development of guest_memfd, in particular:
>>
>> (1) Organize development: (do we need 3 different implementation
>>       of mmap() support ? ;) )
>> (2) Discuss current progress and challenges
>> (3) Cover future ideas and directions
>> (4) Whatever else makes sense
>>
>> Topic-wise it's relatively clear: guest_memfd extensions were one of the
>> hot topics at LPC ;)
>>
>> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
>> starting Thursday next week (2024-10-17).
> 
> This time works for me as well, thank you!
> 
>>
>> We would be using Google Meet.
> 
> Thanks too! Shall we use http://meet.google.com/wxp-wtju-jzw ?

I assume that room cannot be joined when you are not around (e.g., using 
it right now makes me "Ask to join"). Can that be changed?

Otherwise, I think I can provide a room (Red Hat is using Google 
Mail/Meet etc.)

Thanks!

-- 
Cheers,

David / dhildenb


