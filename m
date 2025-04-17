Return-Path: <kvm+bounces-43537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D61DEA914D7
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA803BA6A1
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 07:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7871F63F9;
	Thu, 17 Apr 2025 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AayWlqt3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0990D2153E0
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744874103; cv=none; b=HmGF6qxLFxsm4RLPWtKUiXmJ8QqonIsZxCkkG0os518r3AX4hvV6GitD5ESzabw4rnilCbasT/HR5F1AVIFGkkfAUMYbRvgJpvqO8tXCq+wiOj6c0qQy91kROgfoaqFC6xt+MMneF7H6kzhoFihsLt6CdmdvFn4evYqbOgtSm6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744874103; c=relaxed/simple;
	bh=qKfREfq8cLs0YcBclGpbd1/aUBbAGsvNb2nH0iQaPaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JHQ8NoyvQUecGCM8vTyKmrx09ayybDlm9HcCJ8nVS6D+7kAhyYLSvRiVqGfTQ11WDBTIAFYAqQ0yzhox2ksKIiwCj7UM3pTDWFNzANb/YMI4Ej/h8IYE8naDApIvzWthX4ZNbRd3F5c+SL/79aPH93u3fNFd7TrXJwHr19iLrq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AayWlqt3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744874100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=51dhjsjLR1Xu8v8vrTdI7zY3jGAvHFHPmWKyU7AoQ4c=;
	b=AayWlqt3/nJZlyO+tJIesal+MV1WdBx8x/oVOD80NDo4eO81+oDh7r3U2uGOEU+K9Wcq1y
	4fA82lVcTDTcrNiWqrZ9bhyHDiZzN5+e48b2el4InTCx7totIIRZa4MOqLfqSKbx/9FYjI
	M42Aia8ynIEr+WFU4BhOZZKnjDcYn2k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-8a6dWtvqMTCjdSjr6FVeGQ-1; Thu, 17 Apr 2025 03:14:58 -0400
X-MC-Unique: 8a6dWtvqMTCjdSjr6FVeGQ-1
X-Mimecast-MFC-AGG-ID: 8a6dWtvqMTCjdSjr6FVeGQ_1744874097
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913aaf1e32so251145f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 00:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744874097; x=1745478897;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51dhjsjLR1Xu8v8vrTdI7zY3jGAvHFHPmWKyU7AoQ4c=;
        b=vRIXCrYStxkR+CXPQ6Si9iY6NlXMnUCrdN4Ao8q+2bbfgLQIeiULYXAIArbPkeKKnb
         4BHXNR0326w1Y9XBfyVvw+SmwbqrrmN2YcHS+JtQEIrR6CdGGcMqTd1Z2PaTyeO4pz2D
         Ht4Nqn4fZ8ZvShNZRn0OUxS1fx4Gs6QQWTnaES4eM7HLpFeUqC4Jh9tD0Ywu5+nT2OBm
         01aSxYWgc0rm9s6KXaHMaPuFjVjRX7IGXuqP5FauQBeKxcCHOkxosDqOp4FRWDWVwHmQ
         QVTAMaroGErfSSZHF4wAwxU3AX/+cgDNeyq8noz/KQT4BP/1U9kPnPVeQhOSJYQeeiwe
         1Vbw==
X-Forwarded-Encrypted: i=1; AJvYcCVWr/mDpCjEZtGwEp2HuI1HeceRNRvLN86z6NF5vXpwypARph5bsmYiPtZUZn8yUtoxsB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj1mGQJXnR27J2Q1XOXa6m1IQUyDL4xikPKosi+LaUZNWfH16C
	0gVT7ZFVUeADyIHiIz2C0GR0z1or5R221ws1ixeLvHbqn31ql21QJT6NQzkl4DYrJWFyYTAaW03
	O6gfm8/bpgOJ+lIermyb4+coIsiNNvL64R4SYFnD+QdXrpNJTiK4tH7mPF5wk
X-Gm-Gg: ASbGncs4DqLt5LwXw6IaXGDO2xQt3mG7jUSmBO19RF1bvt7kRhxTYLu9UD7pwob5YNp
	1wcq7yJwHcwQvN+fSYvw5nSDqL/ja4rUaYr2apdKi3FlzUCN9kEbGEMRRqUPAzTSecBNtrL6dR8
	YMXmyMPidUe88/JynBDxyN/ir0tXMvECCmomzDw6VbFdHa3XiB6tg77skxDWdRbuZ9+Q5Rs7vz4
	xnhkD8v+RWRBs4L8wQ6Z8iwUXy1+BUsc37JWnZ4ZspNEAi87Q5LGoC+vGAL6XN1pn4jdoOVPcbX
	Z/M3xKkwZpaAaPhyQK4u994siUz56kLH+kMeuBj23gB56J0+xyvxSdgH6WQs+cpyKoj7nyNb8h4
	IPBzkComGu7p9ery3sawrDaxlVbPOkRmkeBPRGnw=
X-Received: by 2002:a5d:588d:0:b0:391:47d8:de25 with SMTP id ffacd0b85a97d-39ee5b8b992mr3863344f8f.41.1744874097235;
        Thu, 17 Apr 2025 00:14:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/eQTys4+DfbYoPnzh2pEwpGmYVx0ykrkqQmgHQPSTakOo4T0T0bnb+BxnUPUGlE6+rVqnWQ==
X-Received: by 2002:a5d:588d:0:b0:391:47d8:de25 with SMTP id ffacd0b85a97d-39ee5b8b992mr3863318f8f.41.1744874096760;
        Thu, 17 Apr 2025 00:14:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:2700:abf9:4eac:588c:adab? (p200300cbc7062700abf94eac588cadab.dip0.t-ipconnect.de. [2003:cb:c706:2700:abf9:4eac:588c:adab])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4405b53ef95sm42347205e9.36.2025.04.17.00.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 00:14:56 -0700 (PDT)
Message-ID: <3e1f2046-0018-43c2-b2c6-2c8265dbbf5f@redhat.com>
Date: Thu, 17 Apr 2025 09:14:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-04-17
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
 <a185919f-1567-47bd-946f-0a66486404db@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <a185919f-1567-47bd-946f-0a66486404db@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.04.25 04:46, Chenyi Qiang wrote:
> 
> 
> On 4/16/2025 7:58 PM, David Hildenbrand wrote:
>> Hi everybody,
>>
>> our next guest_memfd upstream call is scheduled for Thursday,
>> 2025-04-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
>>
>> We'll be using the following Google meet:
>> http://meet.google.com/wxp-wtju-jzw
>>
>> The meeting notes can be found at [1], where we also link recordings and
>> collect current guest_memfd upstream proposals. If you want an google
>> calendar invitation that also covers all future meetings, just write me
>> a mail.
>>
>>
>> If nothing else comes up, let's talk about the next steps to get basic
>> mmap support [2] ready for upstream, to prepare for actual in-place
>> conversion, direct-map removal and much more.
>>
>> In particular, let's talk about what "basic mmap support" is, and what
>> we can use it for without actual in-place conversion: IIUC "only shared
>> memory in guest_memfd" use cases and some cases of software-protected
>> VMs can use it.
>>
>> Also, let's talk about the relationship/expectations between guest_memfd
>> and the user (mmap) address when it comes to KVM memory slots that have
>> a guest_memfd that supports "shared" memory.
>>
>>
>> To put something to discuss onto the agenda, reply to this mail or add
>> them to the "Topics/questions for next meeting(s)" section in the
>> meeting notes as a comment.
>>
>> [1]
>> https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-
>> cxTxOrAosPOk/edit?usp=sharing
>> [2] https://lore.kernel.org/all/20250318161823.4005529-1-
>> tabba@google.com/T/#u
>>
> 
> Hi David,
> 

Hi,

> If we have time, I'd like to discuss about my v4 posting of shared
> device assignment support
> (https://lore.kernel.org/qemu-devel/20250407074939.18657-1-chenyi.qiang@intel.com/)
> which introduces a new abstract parent class of RamDiscardManager, and a
> new priority listener to apply to in-place conversion. Hope to get some
> suggestion or confirmation if I'm in the correct direction.

yes we can discuss that (and it's on my todo list as well to review). I 
suspect that it's mostly review that's missing at that point, and that 
it is conceptually ok.

Interestingly, I might be looking into virtio-mem support for 
confidential VMs at some point; I'll have to figure out how to allow for 
more states then :)

-- 
Cheers,

David / dhildenb


