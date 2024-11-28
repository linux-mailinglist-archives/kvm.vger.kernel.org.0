Return-Path: <kvm+bounces-32742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E249DB735
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81DC4280CF9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 12:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E32719C546;
	Thu, 28 Nov 2024 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6P9uOeE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9E42CCC0
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732795871; cv=none; b=EW5pgHmeu3hlqtouLA0RC6DzU9LPwwfOlORDo8s/Q1N5mbCUknAmt+dVMHJB/mikevQCktBXDvj7AeQ0WaSt0CBRh1YB5Dw12u50fBS54dkM9ZeMW7PMZqYVkeElWO390FF9r9kXkoRYYeAcKlWzYR70TusKsIrKjmU6SA47xOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732795871; c=relaxed/simple;
	bh=AVu/BNLgCFKLSiPgUT81w6qDMOIZUR2UyWinpY/mtec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pt4+YP24o+LFYec8MUmRwh+xF/WLhAeWJT4rI37R6RqBBpKL4qCA69AjBjKGvvEZ2YB3iZSXuHwxqts4/5PRAkBgYTBVOqQmP/mCksiuj/626GpQScYnabTafzilXgTU3sveh/p+PMtuiMtX4jHbVgH1ee9aG3Cokb7INLJgRtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K6P9uOeE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732795869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cdclCeziyhF3t1EMP1xj9jKJCRxwO1h/HitnW2pwBbY=;
	b=K6P9uOeEerTLcoyjisxriR0hijfqEV92eNPllprBRiO+SXP1W0T1KzOI2HzYwyuxNragOG
	1QJ0RafVWQA6mfPBQH5R6YMMHpcm7u80hadS1e16nhhwnrZMQS6eggDTH+7byr/uwd0Y7v
	GUo7D7DiGcEk6QnnTtWIE60oPkgIaPI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-UHK9CXzgNsWJVIbWwwthJA-1; Thu, 28 Nov 2024 07:11:07 -0500
X-MC-Unique: UHK9CXzgNsWJVIbWwwthJA-1
X-Mimecast-MFC-AGG-ID: UHK9CXzgNsWJVIbWwwthJA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-434a876d15cso9807355e9.0
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 04:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732795866; x=1733400666;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cdclCeziyhF3t1EMP1xj9jKJCRxwO1h/HitnW2pwBbY=;
        b=dfJL22mAgYDu2gU/SFyuAe768kjE87Vf24k2Qt59yZvZl5Py1K6I99UQHPHPwbJZDG
         JUnn4zgozVlH2XUnUwA/V5375kuDgD+5HZHaYKOxoCg8wu46kp1d4pjPvI/IeJUwKgSs
         w7OvcBmXBFkbjYE+zRVAKIWOwcMOMT7+i9mGYnatDS+MyrVttKnJry8Cc8SczjRiM4uR
         7kpJU0nVeG56GYWGD+9FxM1K22AE4WtC9b+V2iEKiPh1vFpgLRvZhsjhaZzKH2SBqbB1
         os4T/dfo2PzH+WLAmDrxs+jVvcMDPuDgYWDoqZ1qL/jb0wFAkJjjuvTJfm00YsErLERA
         FCQg==
X-Forwarded-Encrypted: i=1; AJvYcCUikP9EauDvYPQWbI4tTmRkX2vQIWrQjRS1nreuj/MJbPrVxiDX9Y2BkqtOULUT3wDx3GU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXP6U3pm+hDfjok0EbWV97b22gEp6Dkk+0v2wJJULTWh7PJS6o
	KVoH86RL7FRXjdy77SEzV7dvOG838CLBGRpQjvMbJG/63UhxvC0oo/cmQq39lRPK2eD4E5w+uvY
	ncfpO15LP01AysibZUqwA71i+BZaecpN8tHv+bmdS07CQrC/hpQ==
X-Gm-Gg: ASbGncvEdFFVwckmx1biZFgNIlam1IElSre5ewOLTeH4M3hrz0rr8msbAZdxkcyFpsA
	V7IYmJ24h1caHtOwXrJaJEmLajFBqPlH9iYFfkXjwnX51pYGBADN3qSq2x3bXh0y3g59+vySOE4
	OUoXxit2TnQn15Ee2fv/tGnABSsLvPS7dmabJYGpsHKSKnDSQaBY1IUf0+oE+IpfNNclI9B04HW
	801TfZBtHxjYNr1AckolQIDBpgHsgptKWn2Et6YxJR+NJI6GEIzDpnOMmX2yfFz2cbtcv0X0Kw7
	Kb0RHWfOczthMZWGb7qN2zSpmLQ/yd94FR6gOZ5C/R4V/qnb/sv0Tax1+WiifgTYIogPYCMNeOA
	=
X-Received: by 2002:a05:600c:63c5:b0:434:9d3c:31ec with SMTP id 5b1f17b1804b1-434afc1d3f8mr25041495e9.10.1732795866605;
        Thu, 28 Nov 2024 04:11:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFyXt9hljscSkPwsXGuKmVh0n7P6VgShBwAl49rkLvCMhh9odc+371Cg2jnWtIr4THHAsVJkg==
X-Received: by 2002:a05:600c:63c5:b0:434:9d3c:31ec with SMTP id 5b1f17b1804b1-434afc1d3f8mr25041175e9.10.1732795866233;
        Thu, 28 Nov 2024 04:11:06 -0800 (PST)
Received: from ?IPV6:2003:cb:c714:1600:f3b:67cc:3b88:620e? (p200300cbc71416000f3b67cc3b88620e.dip0.t-ipconnect.de. [2003:cb:c714:1600:f3b:67cc:3b88:620e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0dbe4e6sm20159125e9.14.2024.11.28.04.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 04:11:05 -0800 (PST)
Message-ID: <86aef751-c2f8-4b9d-b7fc-ad9059c82858@redhat.com>
Date: Thu, 28 Nov 2024 13:11:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
To: kalyazin@amazon.com, pbonzini@redhat.com, corbet@lwn.net,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jthoughton@google.com, brijesh.singh@amd.com, michael.roth@amd.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
 nsaenz@amazon.es, xmarcalx@amazon.com,
 Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <08aeaf6e-dc89-413a-86a6-b9772c9b2faf@amazon.com>
 <01b0a528-bec0-41d7-80f6-8afe213bd56b@redhat.com>
 <efe6acf5-8e08-46cd-88e4-ad85d3af2688@redhat.com>
 <55b6b3ec-eaa8-494b-9bc7-741fe0c3bc63@amazon.com>
 <9286da7a-9923-4a3b-a769-590e8824fa10@redhat.com>
 <f55d56d7-0ab9-495f-96bf-9bf642a9762d@redhat.com>
 <03a12598-74aa-4202-a79a-668b45dbcc47@amazon.com>
 <74cbda4a-7820-45a9-a1b2-139da9dae593@redhat.com>
 <8ac0e3e6-5af3-4841-b3ba-ab0458ab355b@amazon.com>
 <b8589fbd-733d-42ae-a6a7-8683c77a4817@amazon.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b8589fbd-733d-42ae-a6a7-8683c77a4817@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.11.24 17:04, Nikita Kalyazin wrote:
> 
> 
> On 21/11/2024 16:46, Nikita Kalyazin wrote:
>>
>>
>> On 20/11/2024 18:29, David Hildenbrand wrote:
>>   > Any clue how your new ioctl will interact with the WIP to have shared
>>   > memory as part of guest_memfd? For example, could it be reasonable to
>>   > "populate" the shared memory first (via VMA) and then convert that
>>   > "allocated+filled" memory to private?
>>
>> Patrick and I synced internally on this.  What may actually work for
>> guest_memfd population is the following.
>>
>> Non-CoCo use case:
>>    - fallocate syscall to fill the page cache, no page content
>> initialisation (like it is now)
>>    - pwrite syscall to initialise the content + mark up-to-date (mark
>> prepared), no specific preparation logic is required
>>
>> The pwrite will have "once" semantics until a subsequent
>> fallocate(FALLOC_FL_PUNCH_HOLE), ie the next pwrite call will "see" the
>> page is already prepared and return EIO/ENOSPC or something.
> 
> I prototyped that to see if it was possible (and it was).  Actually the
> write syscall can also do the allocation part, so no prior fallocate
> would be required. 

Right

> The only thing is there is a cap on how much IO can
> be done in a single call (MAX_RW_COUNT) [1], but it doesn't look like a
> significant problem.  Does it sound like an acceptable solution?

Does sound quite clean to me. Of course, one thing to figure out is how 
to enable this only for that special type of VM type, but that should be 
possible to be resolved.

-- 
Cheers,

David / dhildenb


