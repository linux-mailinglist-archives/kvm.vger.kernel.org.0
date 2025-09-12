Return-Path: <kvm+bounces-57397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AFBDB54FB8
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3265F3AD1A6
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266D83043BE;
	Fri, 12 Sep 2025 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdoUUoCZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21D63009F0
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 13:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757684189; cv=none; b=Bh/9+iOqnk7ZKXLmBGuH8hZaZyOMpXBVkQpY6sYx5skrbDPLqX//dwa56lVpFtFeNipWkjNkmcY+9/VXb+w03KmHnt6VtfuHalNWr+Y/PCPnfcHtvmiVhFvvaB2ZgYcOLTWXvyIJ/g+JVxK32Oqgcz1hn7Lbb0XMtsgDZhX4FJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757684189; c=relaxed/simple;
	bh=t9IrEKU78LnKLsHKxdMDundR46ahi8bvNgSaH4WLBT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PSk2M8b1OLZvuMvjuVxFFax3eB7eyORzjhbRBMrnoobgMh4NgZ1ggJI9c/+FZ93Lrz0jeTRLwzbNq48bcezeN0zVHlZUyKIV1XdJRtsaPJ7Hz5Y09BywZaIrRhGgykxMkyihxFLTems482+2tnkIKivCB4SmdU6ujeB4oaLx2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GdoUUoCZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757684186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c1q+KGAAfVttCgY48bVWecGNxQdsIbBlAjKhfUHOaks=;
	b=GdoUUoCZZynqE3IpYws6VixVNOmYPBf9+eenH+RgXbu6UuvjLSGYqxEm9HEpX7UD9eMHRP
	zC/WK5bumGUL/ZkdvGPlTCmqFvXsC1PoKLlEWpMZCRxuVqj4qjl28CtbbaadbG2Wk0syvQ
	5bP3V8QzuqaSRGncieq9IjLTHM+ta+U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-zNiuaVgbPUS3LLqfWtXC_Q-1; Fri, 12 Sep 2025 09:36:25 -0400
X-MC-Unique: zNiuaVgbPUS3LLqfWtXC_Q-1
X-Mimecast-MFC-AGG-ID: zNiuaVgbPUS3LLqfWtXC_Q_1757684184
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dde353979so11078855e9.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 06:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757684184; x=1758288984;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1q+KGAAfVttCgY48bVWecGNxQdsIbBlAjKhfUHOaks=;
        b=BttsIJdKRjTSY8t1LOyjJP6Uh3/leqJb4DgLCdjGrs+Dt2sQW973aRUiQzthQIP/V0
         ajH2mon7n5a7X2HE6XfScvKTmtT6YohDlUtjWYM18s/J/Ml4t7+32g6uNKKJLLWJXU1/
         ZtKTILJo7B1uGddVrYwa/agN0S4FaAu5RrCk4DT49nPkvEG1BxyCqj22UaxjLx6WI+rR
         IWz9QmfqA+pqZ3yxHKQ4SY+Vi+8AIC1HFNd3ezwbjSGgg9E/b4vNu40bNzlW/Xo3e9Fi
         hBU+x5lsgXqoZHLg+DvgQZsy09iEoq0CfdQ/CcYtnF+OtvjE14ZBwUn/lJ0exNTnKsNB
         MLxA==
X-Forwarded-Encrypted: i=1; AJvYcCU5TazRhU5Z89/N/H+/nWvNDjFSLiFqOKrqb66kYK4TUTrlzJqZxbXvKjGbzNa0sQHlCDI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVpwVJnVj1x1wrC1LcN3B+TAWwWqanGgUs3OogEdi60eXb9Mlm
	7GA8bbDa7/A1xxJ1i6MuQlmk9fEvf58ohfZ3KspRBTqac2yThY8hxKwUL6o3mN1fARf4zVJZOo3
	OO/nUaaLsJB+QfR03eZuNn247pad4+gUtIf078wbzv7K9aZxtKdtdmw==
X-Gm-Gg: ASbGncvD63xpGYFARIEuJywLtQZF/879szcmQrSp/au6TfVfENHKPWjI1K3YUV7SyP3
	6jGJGKYA+28h7M/cb6elbYLzmq+7R63rer5pQBIvx5lgzuP1TktCHu0QJG51KCWT6sBYnkViwpk
	udjUk6NbZWXeGBt0AP3c8H549NOhcN4mQhn/ltpA5V9reQO/dnjPBt9KbgGHRl4luX7pxSjgl7Z
	U95psVF3q9uwVpOhM/q1J/4TpkVsm2ogI9sGD05CmUGotl9eXuqJKH3cwwAD9KSp/2zvIwUbI0P
	YyHvLDI7N+i0lpVjVIt4IIK26cTd8jRqwYVun7rXHKKdya/BdgvXSM7urziyVm7c+vsPS88SABZ
	GzbmIlW+aJhjZCTpnVx6WwusniW3fw1j0yKXkvmgG5WlFl8ylpsuZmM/v+wAUi9zy0Ho=
X-Received: by 2002:a05:600c:6c94:b0:45b:9afe:ad48 with SMTP id 5b1f17b1804b1-45f211d57e3mr30671215e9.16.1757684184235;
        Fri, 12 Sep 2025 06:36:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3C7qbPdEaHDu5BvlzuZaVRkx6nsTgwqOonYfi1PulO3k0njjhXYjiDSVgBgoJliI1MGMrzg==
X-Received: by 2002:a05:600c:6c94:b0:45b:9afe:ad48 with SMTP id 5b1f17b1804b1-45f211d57e3mr30670335e9.16.1757684182982;
        Fri, 12 Sep 2025 06:36:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01512379sm65835905e9.0.2025.09.12.06.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:36:22 -0700 (PDT)
Message-ID: <8e55ba3a-e7ae-422a-9c79-11aa0e17eae9@redhat.com>
Date: Fri, 12 Sep 2025 15:36:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] KVM: guest_memfd: add generic population via write
To: kalyazin@amazon.com, James Houghton <jthoughton@google.com>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "shuah@kernel.org" <shuah@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "Roy, Patrick" <roypat@amazon.co.uk>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20250902111951.58315-1-kalyazin@amazon.com>
 <20250902111951.58315-2-kalyazin@amazon.com>
 <CADrL8HV8+dh4xPv6Da5CR+CwGJwg5uHyNmiVmHhWFJSwy8ChRw@mail.gmail.com>
 <87d562a1-89fe-42a8-aa53-c052acf4c564@amazon.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87d562a1-89fe-42a8-aa53-c052acf4c564@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11.09.25 12:15, Nikita Kalyazin wrote:
> 
> 
> On 10/09/2025 22:23, James Houghton wrote:
>> On Tue, Sep 2, 2025 at 4:20 AM Kalyazin, Nikita <kalyazin@amazon.co.uk> wrote:
>>>
>>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Hi Nikita,
> 
> Hi James,
> 
> Thanks for the review!
> 
> 
>>>
>>> write syscall populates guest_memfd with user-supplied data in a generic
>>> way, ie no vendor-specific preparation is performed.  This is supposed
>>> to be used in non-CoCo setups where guest memory is not
>>> hardware-encrypted.
>>
>> What's meant to happen if we do use this for CoCo VMs? I would expect
>> write() to fail, but I don't see why it would (seems like we need/want
>> a check that we aren't write()ing to private memory).
> 
> I am not so sure that write() should fail even in CoCo VMs if we access
> not-yet-prepared pages.  My understanding was that the CoCoisation of
> the memory occurs during "preparation".  But I may be wrong here.

But how do you handle that a page is actually inaccessible and should 
not be touched?

IOW, with CXL you could crash the host.

There is likely some state check missing, or it should be restricted to 
VM types.

Do we know how this would interact with the direct-map removal?

-- 
Cheers

David / dhildenb


