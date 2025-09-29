Return-Path: <kvm+bounces-58963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2607BBA8805
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D550A3A100D
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D7C2773DE;
	Mon, 29 Sep 2025 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVhsSCxu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A3D1E1DE5
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136521; cv=none; b=gmEZsgsMDh8KH1TNxy81qUnNeaPVcPSMJ1I1eg3QcwUlCkil35znr8mSz4oSlfo82dDRsGHAcY2ns6n+z5kmzah0SpxnNr7A3xLljj/spivGHg70t5u3EFR/iGu8ZN8/LcqH6WDNur0eRar5EimFC1Rxc8giu3kXTAnB9nkeYFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136521; c=relaxed/simple;
	bh=CXgWCmSK5bofhg065+iC+3B9kKopae9BTQYZqgKPRmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CGwPTiimba/QIe6jv0vFcgi0L2itvOqzOwIKQ77JMDGahXCIPauPbeev6nsroQq1AL3LOIu6sTBupt3ivu+InHin664buzHOczq9awD1Dtl9Dmx70zksD+CiAZojtfZWFn1VBC6VvkmpDjwmKG6rxwpOnfw1sDShU3DxwugZjQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVhsSCxu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759136519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MjGXQB1dHuxd76x8A3VktK3UCtS7wGBVGFS8i3EWENY=;
	b=DVhsSCxu9pTy4lVGK3NU1UCN8rDMc5k0V8MUFnvyu/qnqYyoqQkULECHh7x2mmY1P8v2NP
	Bky1oPXNuSQkiVtie9VG/Auu7GWOkXLBseGmw9xVJr0ejk+7ZVlYvOvFHDbPaV3f8CO5qq
	TphT+J85Ux8YXuyLXc3RlZ5JhaWBFCU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-x2LsDaqIMq6Rw70THRM1bQ-1; Mon, 29 Sep 2025 05:01:57 -0400
X-MC-Unique: x2LsDaqIMq6Rw70THRM1bQ-1
X-Mimecast-MFC-AGG-ID: x2LsDaqIMq6Rw70THRM1bQ_1759136516
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e32eb4798so21317135e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759136516; x=1759741316;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjGXQB1dHuxd76x8A3VktK3UCtS7wGBVGFS8i3EWENY=;
        b=D5kDH7gpUNDWu7yO0d4cZAD3RYapcifWnrqRAbYBGndyHE8Gnq+oCcEnjHkNBAN64N
         +UkZl2gurXwxIpg3LrM+0S1dZqnOSX6Zqv9Ff//XhZr1EBfeuAfzenRG7S5Y0BLpjJ85
         hnPx7ZyKwedZYLtcOauPj7oc0L2zMpdLkxwjGUCuPBblYaffWwwduNg1HpIfyMSVo6XD
         CDx72oYPjm/tLRbNeMZVmemdwU/ayXqqeKpqmH6PZvPcYcAg5+aGd6YOjtBS2gtEdcS1
         PBMLmpJ5tyRTeXIRnURvi3JYX1Ka5Ne/FlPpzPrBCLbLIDhZJU7boLo7adN/NVCd07Dw
         OLKA==
X-Forwarded-Encrypted: i=1; AJvYcCUTylbLExdvehOHgL42FUTyLse5Rbo6r6RrrBxHRaqx6SQYNbBYjPwSoPzYcYvqILTLYBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8gEXP4OLeLaQQnteYZyuF6NSESLGMY+29Ro5hv7RmK7KwPgic
	hVxReq8j4/iT+JZse+Aof5oVNv75qGhMBWOvjnFGXgzWi6nspCvzs/4XBmCZiHYvpmQ/8x8GsyK
	kilg99QLovFm3wHDYAoaMPNDtK5IIwfYUW4N+J9UYgqEp3zyZ4IWpA3vMfussgA==
X-Gm-Gg: ASbGncvoZAwhuOEpbHjW65lHJyYzWKqmjzpBHoOi0MTXXNOqiFH6l+iN6MzncL3/EdL
	3tvMM/bvMIQVW7F+B1L3C6c53UKIPtk7PLvuzpUl1hEMVCFUlyRQRJZNrq8InAPck4pqtH14YJ6
	9NhQnH4Rg+yUD9GqBcB1u2eIFj/00NREZC3mAfjQcUVn2/wKEKp/si+7/VHpuHhhpFGWiWZ8rBW
	LUGz429yFTvuIJLRaaf6ygy78E0lFhMAdgJtMoGEWRcRgp04VfltIc5mvjTdAcyEofkOGM0YPy1
	RdSRAot3o8++CfUazZWpBP09IwrhIFEjugRI8zxkc/vX/30JLc8G52Sdt6Y1dSD1hCYghsuoFhS
	VrCldXjY3lM+w4jayzVjAlEGNvDRg7RkHtN5lxe1lnJeqO8gvbbA9y0MDN/7J7EbaWg==
X-Received: by 2002:a05:600c:c04b:20b0:46e:4cd3:7d54 with SMTP id 5b1f17b1804b1-46e4cd3808cmr35899165e9.18.1759136515845;
        Mon, 29 Sep 2025 02:01:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBbjcCVPhXVC4zY3lb87QTQrZiXmS2qntkistmHl4dTiI3URIXZQB+/Tn7CFF5wXhkypAuLw==
X-Received: by 2002:a05:600c:c04b:20b0:46e:4cd3:7d54 with SMTP id 5b1f17b1804b1-46e4cd3808cmr35898835e9.18.1759136515430;
        Mon, 29 Sep 2025 02:01:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac5basm243988785e9.7.2025.09.29.02.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 02:01:54 -0700 (PDT)
Message-ID: <92c6e142-5911-4e0c-ac13-af251e048215@redhat.com>
Date: Mon, 29 Sep 2025 11:01:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-2-seanjc@google.com>
 <7ce29e23-aea9-4d4d-b686-3b7a752e0276@redhat.com>
 <CA+EHjTzO_tkOD1C--qqk1eotwf+-2DSDUqk=szzPTN7mHJLQ_g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EHjTzO_tkOD1C--qqk1eotwf+-2DSDUqk=szzPTN7mHJLQ_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29.09.25 10:57, Fuad Tabba wrote:
> Hi David.
> 
> On Mon, 29 Sept 2025 at 09:38, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 26.09.25 18:31, Sean Christopherson wrote:
>>> Add a guest_memfd flag to allow userspace to state that the underlying
>>> memory should be configured to be shared by default, and reject user page
>>> faults if the guest_memfd instance's memory isn't shared by default.
>>> Because KVM doesn't yet support in-place private<=>shared conversions, all
>>> guest_memfd memory effectively follows the default state.
>>
>> I recall we discussed exactly that in the past (e.g., on April 17) in the call:
>>
>> "Current plan:
>>    * guest_memfd creation flag to specify “all memory starts as shared”
>>      * Compatible with the old behavior where all memory started as private
>>      * Initially, only these can be mmap (no in-place conversion)
>> "
>>
>>>
>>> Alternatively, KVM could deduce the default state based on MMAP, which for
>>> all intents and purposes is what KVM currently does.  However, implicitly
>>> deriving the default state based on MMAP will result in a messy ABI when
>>> support for in-place conversions is added.
>>
>> I don't recall the details, but I faintly remember that we discussed later that with
>> mmap support, the default will be shared for now, and that no other flag would be
>> required for the time being.
>>
>> We could always add a "DEFAULT_PRIVATE" flag when we realize that we would have
>> to change the default later.
> 
> I remember discussing this. For many confidential computing usecases,
> e.g., pKVM and TDX, it would make more sense for the default case to
> be private, since it's the more common state, and the initial state.
> It also makes sense since sharing is usually triggered by the guest.
> Ensuring that the initial state is private reduces the changes of the
> VMM forgetting to convert the memory to being private later on,
> potentially exposing all guest memory from the get go.
> 
> I think it makes sense to clarify things now. Especially since with
> memory attributes, the default attribute is
> KVM_MEMORY_ATTRIBUTE_SHARED, which adds even more confusion.

Makes sense to me then, thanks.

-- 
Cheers

David / dhildenb


