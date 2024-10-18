Return-Path: <kvm+bounces-29147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 985819A379E
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A4731F2563E
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA718C939;
	Fri, 18 Oct 2024 07:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9IGpcd2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8AE18C01D
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237857; cv=none; b=lnIa3iJYtpZXBO6Zyuq0cdFMcRbUo8mOyDyW8DMcXg1hzFqU4UssMYJquAd4NFqETgb0YuaOKjp/mWmqT6ujFylypJnJxzp88ruYRKuOmR3PhOjd96L50KzNAT3BNv0Cmrq/iznPsJCwrEEBO/pgH9EenIftngiQJtFqekw9EdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237857; c=relaxed/simple;
	bh=IWyg8rYth6GF9gle2dn8NkB4boettdMwzDy8yLRiIUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPTe9WBvOiSdNSCTYEX88kV6g5ttlsjl4SUQLVB7XEkaggBDwSp0nOvwNvHrW7e1yybIW06Prci8ukUOZLj4vq4JSPU0RijfKFqdaBhaLNTVhpsppv+ckYzmUYsNxR9Km+ULZckT46RNiVRff+qYMrFjnYRelmlJh114qjq+ANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S9IGpcd2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729237854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fiBOtxNCTMFmvCJm7g5mabgUWliIuWBhC7qyOb4ZSNY=;
	b=S9IGpcd2xx/PhqOj4cNqLkfoN6xRTqMDUPbD8E7Gnq6FiUVb5MC+ZaS6gM2Q/6dfpCYk89
	sS5nEfTL7DOZVr1NSNPHozdSLO9DlSS5Otco/t2P6YGjDNBK9EdBFI02ej+CUYUyC5Ickc
	34j4dy3JM2f2O9P+EOsf1GHIAAjxj50=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-wZUuCP7dP1yC63xHDszf3A-1; Fri, 18 Oct 2024 03:50:52 -0400
X-MC-Unique: wZUuCP7dP1yC63xHDszf3A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43154a0886bso11613605e9.0
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 00:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237851; x=1729842651;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fiBOtxNCTMFmvCJm7g5mabgUWliIuWBhC7qyOb4ZSNY=;
        b=vR9LuXOqmlhZiZvlbsbcsSJV7IReOXN4dfN4Xsr7HnA5sF/zo5f6jdstRgwFHbjmj4
         NtF2UoyqnKW6iShrP1lYS/FLIbH/D8nSLLXXb1OXaVV9DBA5Z31NyQy87DkKXk1w5LQI
         l3b4LHipATdxKRgxY6OB4xYNPiVTGd7LVKizuIyPSwwkYtipmcE0UmWky4q5r1gJyDjY
         R24YQvTkZQRXMlecl8605UZ6S7K3J6ZOIUTztSYK7e80YnPgbjuFWv10LHU5AftkeI5V
         hmw2Vw7Q0zj+N/uHOz66ZImr5PjEdoAJQUDtkl3bgPFR8ochwz+Xtpf6K30NaEqr6S8Y
         tEFg==
X-Forwarded-Encrypted: i=1; AJvYcCVc2rxUD8WieVbIRliJoUyiMLKt4WzWDESsD4wDd6MlOIOQn0tcLW0X8Py9mFHGt83UxLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVEEIao35V/69sWK+HYlMIIiGa8g7I69qaWjlOs/5fu2hIrQiw
	BKlX4/tVmlTJPw1s6K29w630fHKrWDg2fihj0dd2gADlAoGocCwc+kjkELGheP0EiYWZZ7+jIZm
	YcQQoSov90GccD6AV4yiKoTwRPORblJ4EbLKP8s7T9KMuXUgBlw==
X-Received: by 2002:a05:600c:3592:b0:431:586e:7e7 with SMTP id 5b1f17b1804b1-43161634f28mr9752805e9.1.1729237851133;
        Fri, 18 Oct 2024 00:50:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEupPpvNMDHtMfaFPMq3ZQBPO4U1Pfe/C/Hylkp0d9xmyO65Fx30HzchvYa6qX1bU+Dwtp9Kw==
X-Received: by 2002:a05:600c:3592:b0:431:586e:7e7 with SMTP id 5b1f17b1804b1-43161634f28mr9752345e9.1.1729237850657;
        Fri, 18 Oct 2024 00:50:50 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:2400:68a3:92e0:906f:b69d? (p200300cbc707240068a392e0906fb69d.dip0.t-ipconnect.de. [2003:cb:c707:2400:68a3:92e0:906f:b69d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316067dbedsm19713015e9.7.2024.10.18.00.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 00:50:50 -0700 (PDT)
Message-ID: <257d5578-f256-49cf-affe-6255ff224ed0@redhat.com>
Date: Fri, 18 Oct 2024 09:50:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
To: Patrick Roy <roypat@amazon.co.uk>, Jason Gunthorpe <jgg@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, tabba@google.com,
 quic_eberman@quicinc.com, rientjes@google.com, fvdl@google.com,
 jthoughton@google.com, seanjc@google.com, pbonzini@redhat.com,
 zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com,
 isaku.yamahata@intel.com, muchun.song@linux.dev, erdemaktas@google.com,
 vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
 willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
 bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
 rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
 haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
 maciej.wieczor-retman@intel.com, pgonda@google.com, oliver.upton@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com>
 <ZxAfET87vwVwuUfJ@x1n> <20241016225157.GQ3559746@nvidia.com>
 <ZxBRC-v9w7xS0xgk@x1n> <20241016235424.GU3559746@nvidia.com>
 <ZxEmFY1FcrRtylJW@x1n> <20241017164713.GF3559746@nvidia.com>
 <ZxFD3kYfKY0b-qFz@x1n> <20241017171010.GK3559746@nvidia.com>
 <ZxFhTtEs2Mz7Dj-O@x1n> <20241017191829.GA3559746@nvidia.com>
 <2686a5ae-e1e5-48d6-ae4b-31face5284ca@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <2686a5ae-e1e5-48d6-ae4b-31face5284ca@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.10.24 09:15, Patrick Roy wrote:
> 
> 
> On Thu, 2024-10-17 at 20:18 +0100, Jason Gunthorpe wrote:
>> On Thu, Oct 17, 2024 at 03:11:10PM -0400, Peter Xu wrote:
>>> On Thu, Oct 17, 2024 at 02:10:10PM -0300, Jason Gunthorpe wrote:
>>>>> If so, maybe that's a non-issue for non-CoCo, where the VM object /
>>>>> gmemfd object (when created) can have a flag marking that it's
>>>>> always shared and can never be converted to private for any page
>>>>> within.
>>>>
>>>> What is non-CoCo? Does it include the private/shared concept?
>>>
>>> I used that to represent the possible gmemfd use cases outside confidential
>>> computing.
>>>
>>> So the private/shared things should still be around as fundamental property
>>> of gmemfd, but it should be always shared and no convertion needed for the
>>> whole lifecycle of the gmemfd when marked !CoCo.
>>
>> But what does private mean in this context?
>>
>> Is it just like a bit of additional hypervisor security that the page
>> is not mapped anyplace except the KVM stage 2 and the hypervisor can
>> cause it to become mapped/shared at any time? But the guest has no
>> idea about this?
>>
>> Jason
> 
> Yes, this is pretty much exactly what I'm after when I say "non-CoCo".

It's likely not what Peter meant, though.

I think there are three scenarios:

(a) Secure CoCo VMs: private is protected by HW
(b) Semi-secured non-CoCo VMs: private is removed from the directmap
(c) Non-CoCo VMs: only shared memory

Does that match what you have in mind? Are there other cases?

-- 
Cheers,

David / dhildenb


