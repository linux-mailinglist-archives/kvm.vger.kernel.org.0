Return-Path: <kvm+bounces-29283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31EF49A6804
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5392E1C21FD4
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD931E7C1C;
	Mon, 21 Oct 2024 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itBqERyJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428791F4279
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729513170; cv=none; b=bP+jG0/R8ZIdsUzzH9HTeN+Hzeq+PgFYvtAxVo0fzr5BZfb3s60ehobQXvk2uPMODKOrXcl7gN5L1CJEwtrqCRNPjbuMJSV79Hn88GLujf8oMWCWhbtN4LUUq/f+P9PSg9WfaMEYicwZUCbnOb21MiKj/CxD+YAQPrvoPR0wwwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729513170; c=relaxed/simple;
	bh=85dwOBqgxabEtu7DlXSK3j+X36k6w41TKJHAAtHgg2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QHKSWjXz4YJ542EONvnf2EE2hmuhhR8M+7DVz/t1fp1XRfZGPJ5WqdIrizUgUeO0bHiNFr1SnwdK9i/AWoNPE/oWsu1J2Uo9fUZErF2w6gS6F+n0RQx6d3fzw40CMPpR7sYrFnNPl1Uj7xGDzLewUa4knnsLJjY/pmKoJCih9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itBqERyJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729513167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3SSNANQOGj1r9ayrCBzVvFmFj/ChOB3ieC2hxuoZm3o=;
	b=itBqERyJZx0C2HdogBZrG1iHhbTD+RVGYjGo8WQyOwltnzNBy58AqH6ro8TNzpLRkxKfWp
	Ghvv3brzegyNpke9jO2nji55JSLzY5N46YCYOlXaLUHP98x3wvsr2abHHaXYNmm06pJFJe
	jmt/atFFhosb9d41FV9VbifIoXhVQHI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-DqChSxdnPhi8RfuOnsBB9Q-1; Mon, 21 Oct 2024 08:19:26 -0400
X-MC-Unique: DqChSxdnPhi8RfuOnsBB9Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315d98a75fso29986965e9.2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 05:19:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729513165; x=1730117965;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SSNANQOGj1r9ayrCBzVvFmFj/ChOB3ieC2hxuoZm3o=;
        b=TMdWyEoIyftOLpwJHnXeB9LgvvxVEchcv0wNIUhNmRe+pLPbWTx2v26M19laLYv5ZM
         zWhS5hevjgZoPztsz1mnA3D3ZuuOASbh1AclK+3i6zMjCaS/sI9LHRJrJGYFoageq8UX
         amdh3pG54a3oj1fAx55jyAFPC85UZlmShldb2SFNmVCVUjZQTLk0CqxvyMSjWI8xXvMm
         37NFjNbAWacyDpQz0CLw1trYXGKQslYYpNOL+1dGL9wAFey/KPSm/fPv7LgDFQ0JAfXj
         RzbnOHWwXEP38qqpI6j9BTEBHq3qlbwCrlVM8Wq5gt5Pwh8L0hrDBe8RwSt8fOezD2pp
         X1NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBXY//mnjOxQXDiwE5ozCVBzTAz2/wY3UDu0U1Tl9WQSwPGFA+/lY447Bkvf7CdXWZRKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA3B7xY5aNadleLT1XA/4CKZ2GiTe/ZKV7Lt3rsI8fwMG7iTPY
	PxlY3uBJcbtj7ad6KjlGsjukoByPgz42pVzq9dgmVO68GykcuQ75IwlK8Vgpw03OgjEUw8KP14y
	K427OVmHJX8aZZGzSK4SSoUMXr6ABuB7bfoVzh/rMBO8x1kyABA==
X-Received: by 2002:a05:600c:4e12:b0:431:1d97:2b0a with SMTP id 5b1f17b1804b1-43161641793mr95708085e9.15.1729513164995;
        Mon, 21 Oct 2024 05:19:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHL+4zTIZRaHCwKu0OkK2nf7jN/ima55H0fGeAQpNI8aBlBlaAzYq2yIrtU/CEO+/V54e4DoQ==
X-Received: by 2002:a05:600c:4e12:b0:431:1d97:2b0a with SMTP id 5b1f17b1804b1-43161641793mr95707665e9.15.1729513164570;
        Mon, 21 Oct 2024 05:19:24 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:36d3:2b96:a142:a05b? ([2a09:80c0:192:0:36d3:2b96:a142:a05b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f57fa4fsm56089275e9.16.2024.10.21.05.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 05:19:24 -0700 (PDT)
Message-ID: <213b6a6a-3594-4bc5-ae6d-930bbaf3616d@redhat.com>
Date: Mon, 21 Oct 2024 14:19:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] virtio-mem: s390 support
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-6-david@redhat.com>
 <20241014184824.10447-F-hca@linux.ibm.com>
 <ebce486f-71a0-4196-b52a-a61d0403e384@redhat.com>
 <20241015083750.7641-D-hca@linux.ibm.com>
 <fbee219a-cc88-414b-8f5f-2cb3b4c9f470@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
In-Reply-To: <fbee219a-cc88-414b-8f5f-2cb3b4c9f470@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Am 21.10.24 um 08:33 schrieb Christian Borntraeger:
> 
> 
> Am 15.10.24 um 10:37 schrieb Heiko Carstens:
>> On Mon, Oct 14, 2024 at 09:16:45PM +0200, David Hildenbrand wrote:
>>> On 14.10.24 20:48, Heiko Carstens wrote:
>>>
>>> The cover letter is clearer on that: "One remaining work item is kdump
>>> support for virtio-mem memory. This will be sent out separately once initial
>>> support landed."
>>>
>>> I had a prototype, but need to spend some time to clean it up -- or find
>>> someone to hand it over to clean it up.
>>>
>>> I have to chose wisely what I work on nowadays, and cannot spend that time
>>> if the basic support won't get ACKed.
>>>
>>>
>>> For many production use cases it certainly needs to exist.
>>>
>>> But note that virtio-mem can be used with ZONE_MOVABLE, in which case mostly
>>> only user data (e.g., pagecache,anon) ends up on hotplugged memory, that
>>> would get excluded from makedumpfile in the default configs either way.
>>>
>>> It's not uncommon to let kdump support be added later (e.g., AMD SNP
>>> variants).
>>
>> I'll leave it up to kvm folks to decide if we need kdump support from
>> the beginning or if we are good with the current implementation.
> 
> If David confirms that he has a plan for this, I am fine with a staged approach
> for upstream.

I do have a plan and a even a semi-working prototype that I am currently 
improving. In summary, the virtio-mem driver in kdump mode can report ranges 
with plugged memory to the core so we can include them in the elfcore hdr. That 
is the easy part.

The "challenge" is when the virtio-mem driver is built as a module and gets 
loaded after building/allocating the elfcore hdr (which happens when creating 
/proc/vmcore). We have to defer detecting+adding the ranges to the time 
/proc/vmcore gets opened. Not super complicated, but needs some thought to get 
it done in a clean way / with minimal churn.

-- 
Cheers,

David / dhildenb


