Return-Path: <kvm+bounces-29106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8C59A2B7F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A0601F27D30
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F451E0093;
	Thu, 17 Oct 2024 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlK0B10J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1BE1E0085
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729187715; cv=none; b=gdBgEAOxUGenL50sweufzfhT359yZgrmP0tLX6UKKSV8aCB7oUhJWQGET9wXOtMuKpPDSbt5iOwoZ7uVEYyGRoifwIHLieN4YVW9u3o5qusyjiBizV9z4Mb45smLp/b7RMP7eKKW6ZNIrzRXNfO14je/Mh7xXvNIv84yYVYNPW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729187715; c=relaxed/simple;
	bh=mMcsp/iMlAmoBKZKBMJoWh4WxLSeWmI4w7731hcUnKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BRoOHkYUmJEShWtSf0+kNM2U38qybNIEh+mGMA8ByZvymiOlVGMoKEcyHy+iR241tOSDp2E8E5trH91psRGB7c3cXEUEbzaom2Edgy6oPa4IGRtgo74JmZ53xo8ugwjsNKdYINHO1P03YCtgotWKUy8f9fGuRJjWVNJXirDdRzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlK0B10J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729187713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DTYljF8POalugMXuFvWjkYZLAf4we1kA3NrQt2GmKV4=;
	b=WlK0B10JbbQ578yMMIQmLnKiF4bBTm6pnIbJxTiEhPlWVivkSoblPDnydnQjF2o4Jbl/dN
	bH4MsRHVNj/HQrn4+DNjH/6fMCURiiqFmfgk6mZyxlzj4XduwqPUZzAFt9QuEtCWYC1X01
	QMnn/dYCigtM6ZjEtAC3q7KnA8WsVY4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-xzjubjvVNlWKxK5UGypLUw-1; Thu, 17 Oct 2024 13:55:12 -0400
X-MC-Unique: xzjubjvVNlWKxK5UGypLUw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4315dd8fe7fso6517055e9.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 10:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729187711; x=1729792511;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DTYljF8POalugMXuFvWjkYZLAf4we1kA3NrQt2GmKV4=;
        b=eU4sr/bgG7twS6pIW7EOAqs5XF8Y8/6Jb2OnKVThJYD6wbunjQHDk8kotDep553wGM
         jtIgTLFQbupBOo2LZuE2/DDTDuusipDF6h8NFSXgDqK74N5+7Q5tRVaYgHA3MnN2mg+L
         fzW1bFnisyqSBFEJKSCQWCAKQquGDADZqT7ia+v5v1dUwpoUpCgMq/WdWeV5UoPL0Czg
         +UzIpLqGt5sSQaeYMDREZcafy3YuCbxIDq9FcJ4Z52eI+55Ttl7JW+wK5EI8LvNM5j2Z
         PhB9AhP93Zi1d9PTNsH8suC3SvD2G+xKCZ4p3MaE6PFcGK+FhGIsucK5Z+BIZFfvBt9B
         D/3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqjhbnd1BY4P+gfHUr1bf855woT44L95PVO1nK0s7vB/FgZbcHaRR+9xnTjRFoHSLsm6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxehOLYhwORfmC9RBMT1gAT4TxZvvkOHdXQTzLbTyKB81MJXeoa
	YgYwz2su+pEFuhDvF1tWYyav++uoSTJnAu24qEgXg9jiPNlQrGPHdG3GrFtEBq/vVis/0HgtT2g
	N3etdh/ruDG8ZAl9yluKIu2tjICieSylZf+LmLAS+VEgpqxqTjg==
X-Received: by 2002:a05:600c:3b8e:b0:431:24c3:dbaa with SMTP id 5b1f17b1804b1-431255cea47mr208053755e9.2.1729187710673;
        Thu, 17 Oct 2024 10:55:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHnxbUQfWueTkDkaivXXE1yKf5gKXrsNzTMq1SSj058gURZUSa2g/DuU7vFomh7hQIpIbadg==
X-Received: by 2002:a05:600c:3b8e:b0:431:24c3:dbaa with SMTP id 5b1f17b1804b1-431255cea47mr208053525e9.2.1729187710262;
        Thu, 17 Oct 2024 10:55:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7600:62cc:24c1:9dbe:a2f5? (p200300cbc705760062cc24c19dbea2f5.dip0.t-ipconnect.de. [2003:cb:c705:7600:62cc:24c1:9dbe:a2f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431606940e9sm2562995e9.19.2024.10.17.10.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 10:55:09 -0700 (PDT)
Message-ID: <9cee402b-eea0-4a66-870b-d2bc7a137c9f@redhat.com>
Date: Thu, 17 Oct 2024 19:55:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, Ackerley Tng <ackerleytng@google.com>,
 tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
 rientjes@google.com, fvdl@google.com, jthoughton@google.com,
 seanjc@google.com, pbonzini@redhat.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, isaku.yamahata@intel.com,
 muchun.song@linux.dev, erdemaktas@google.com, vannapurve@google.com,
 qperret@google.com, jhubbard@nvidia.com, willy@infradead.org,
 shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com,
 kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org,
 richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com,
 ajones@ventanamicro.com, vkuznets@redhat.com,
 maciej.wieczor-retman@intel.com, pgonda@google.com, oliver.upton@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <Zw7f3YrzqnH-iWwf@x1n>
 <diqz1q0hndb3.fsf@ackerleytng-ctop.c.googlers.com>
 <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com> <ZxAfET87vwVwuUfJ@x1n>
 <20241016225157.GQ3559746@nvidia.com> <ZxBRC-v9w7xS0xgk@x1n>
 <20241016235424.GU3559746@nvidia.com> <ZxEmFY1FcrRtylJW@x1n>
 <20241017164713.GF3559746@nvidia.com>
 <a63f0f7a-e367-4f0e-8d8e-ca7b632712df@redhat.com>
 <20241017171639.GN3559746@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241017171639.GN3559746@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 19:16, Jason Gunthorpe wrote:
> On Thu, Oct 17, 2024 at 07:11:46PM +0200, David Hildenbrand wrote:
>> On 17.10.24 18:47, Jason Gunthorpe wrote:
>>> On Thu, Oct 17, 2024 at 10:58:29AM -0400, Peter Xu wrote:
>>>
>>>> My question was more torwards whether gmemfd could still expose the
>>>> possibility to be used in VA forms to other modules that may not support
>>>> fd+offsets yet.
>>>
>>> I keep hearing they don't want to support page pinning on a guestmemfd
>>> mapping, so VA based paths could not work.
>>
>> For shared pages it absolutely must work. That's what I keep hearing :)
> 
> Oh that's confusing. I assume non longterm pins desired on shared
> pages though??

For user space to driver I/O to shared pages GUP is often required 
(e.g., O_DIRECT), as was raised at LPC in a session IIRC (someone 
brought up a use case that involved vhost-user and friends).

Of course, for the guest_memfd use cases where we want to remove also 
shared pages from the directmap, it's not possible, but let's put that 
aside (I recall there was a brief discussion at LPC about that: it's 
tricky for shared memory for exactly this reason -- I/O).

longterm pins would have to be used with care, and it's under user-space 
control, and user-space must be aware of the implications: for example, 
registering shared pages as fixed buffers for liburing is possible, but 
when a conversion to private is requested it must unregister these buffers.

(in VFIO terms, a prior unmap operation would be required)

Of course, a conversion to private will not work as long as the pages 
are pinned, and this is under user space control.

If the guest attempts to perform such a conversion while pages will be 
pinned, there will likely be a notification to user space (we touched on 
that today in the upstream call) that something is blocking the 
conversion of that page, and user space has to fix that up and retry.

It's not expected to matter much in practice, but it can be triggered 
and there must be a way to handle it: if a guest triggers a 
shared->private conversion while there is still I/O going on the page, 
something is messed up, and the conversion will be delayed until the I/O 
is done and the page can be converted.

There are still quite some things to be clarified, but this is my 
understanding so far.

-- 
Cheers,

David / dhildenb


