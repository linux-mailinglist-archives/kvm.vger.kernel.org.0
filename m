Return-Path: <kvm+bounces-42754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40035A7C4C8
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E55D189A1E3
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DE820ADC9;
	Fri,  4 Apr 2025 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2vyLG98"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2031EB5E5
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 20:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743797458; cv=none; b=E6Oth1VpGsuXrgHgsFSzDKbn6YQEqtI4l/uuI9h0bOJWA5PasdmmvHNvYfluNQJeaGIb8Ph6yjnscZXQuPbvKRVN3RslUi+cIZUkziy+BUExAJkqi/6/F0dANLoOTqikwaDIk7dpnlgjWH6tke6UVTmWQc1dH9nkgYboTWJIMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743797458; c=relaxed/simple;
	bh=O9IoM6MF5DfctbJZmjTcknWc1/viHq+k+AoK8Q7xTfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cvjPMMpoY8wWdu+/B+9YGBAGrfr2k/2V6LCj5rdUsTGCP1celStG5CgRM6eog7qMULxavbVz5dhAKf/uw3N1e+KFsFyNBYyWs3Hchafgnglw0vIf+sxxpGf389QfyAfMbdmUP3Ome+x2zIfpF7KEWB056YxwyhcQOM7xFrnf0f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2vyLG98; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743797454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bzEqObXhH6946rfoSrhvx58vJYXkn200LzwfFnx8AE8=;
	b=L2vyLG98xfnw/+OWt/bM32YBtXjoApy5Paqsjb+P/yQ6fY6YPgVt6ndQVJHSwsrZVBQooU
	5xJmWc0XwplWQR8j5fCEY2NVRItatLvjsL2Zgyo5yhhxIPuF+MFrW3tKU9U6nQbwJZnnYT
	mot/CLjlxHSUULXMSpOeBF7UU7tCM5Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-C5xDcPpvNPWfGTeMbTn4bw-1; Fri, 04 Apr 2025 16:10:53 -0400
X-MC-Unique: C5xDcPpvNPWfGTeMbTn4bw-1
X-Mimecast-MFC-AGG-ID: C5xDcPpvNPWfGTeMbTn4bw_1743797452
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ce245c5acso28880935e9.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 13:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743797452; x=1744402252;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzEqObXhH6946rfoSrhvx58vJYXkn200LzwfFnx8AE8=;
        b=kOOKrAKbHxtf2kD0cgYzwjXAp+yQRyOPOzcJebx75XrnDXPfZuBC2uMHSbzgWVUtJz
         a1b5KoAh5wGSuS1/8eig9KIZ3hbLjstTmpFTNhO3apt2hBSp5C4dmdp9X9vcSJVAB0zd
         s6XqqiPJtD5pMhHeqaQwl8aP94eupA8kUmKdv2XynAs9XFEBI4sa3DBYe/m5XHwron3z
         rM8ZGx4uTxVO3KaVLstEVpxFaYCyoGC043639e9jwEbpn7FsrYRT4wchF6cYA+4GPDxT
         /8NFyNIefwHItLCmIxZividTjKdvIoXMreyrvEIFR3YlCtwUY1XHTaW9mKEC5iGIXWtH
         xm2w==
X-Forwarded-Encrypted: i=1; AJvYcCXIS0qA+otdRrVEYeDlPoO6F/kiSvc0BcMV3wrOxJ1fe5y5VXxwIDPfS6JmA/VoS0bEyjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBi16b2Qr3T0iYMvGy3rV9RDX0hc+LcxejMHlqRBj4y7R6DPfL
	k5zUi9ti89/IEfypLbYDsHJDM7w1+y3QlKt/xJZv/8D8MOaRVwNZGwiGuT3PCKIFBk7V2oNyZ3j
	mYooZduFOKsCHX/SPRhf6+a7Anhs7njsiqQ/E44L4X2ImpnN1Qg==
X-Gm-Gg: ASbGncvN0uVDuWMkHfLAOVyBcX3qt0XzzXVL2ZUcRu3lE9Kokpze8zW1CPO39I1nHEx
	bT0qogmuaVq6WVn/hmh4capCqN5pkBmRgSZpaijLjXjtdRzzWkj//yfJIIszdsjqRrVBzMl1R1f
	SHwOCHTiCe1V1bvq3uEl0kZpAvvshBeAa9QtcxIUG0GG2LOGD60M8IqglvOUcDioIVYWBki2a1L
	WW8fmuoKqh8zVCnqr+cgg8H/Pst3qScxvu1mUmz3FkQeGD0ebjS4L0Hgrx+um6dnwT9iy2KNSho
	eQ+xz2MKfB5afjtdl7Ltf5+/UyJ1PPixa9UvMnT3cPGodw==
X-Received: by 2002:a05:6000:290c:b0:390:f4f9:8396 with SMTP id ffacd0b85a97d-39d0de26007mr3526702f8f.28.1743797452150;
        Fri, 04 Apr 2025 13:10:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrJZsFNGzLkbs9TanMmyyun2zST6f9PStbRXUiZqlqM7CQ6Oas1wbaOMvKfuXzt1CfePaGVA==
X-Received: by 2002:a05:6000:290c:b0:390:f4f9:8396 with SMTP id ffacd0b85a97d-39d0de26007mr3526649f8f.28.1743797451647;
        Fri, 04 Apr 2025 13:10:51 -0700 (PDT)
Received: from [192.168.3.141] (p4ff23dc9.dip0.t-ipconnect.de. [79.242.61.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec1795243sm58278365e9.32.2025.04.04.13.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 13:10:47 -0700 (PDT)
Message-ID: <894eb67c-a9e4-4ae4-af32-51d8a71ddfc4@redhat.com>
Date: Fri, 4 Apr 2025 22:10:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] KVM: Restricted mapping of guest_memfd at the host
 and arm64 support
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Fuad Tabba
 <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250328153133.3504118-1-tabba@google.com>
 <egk7ltxtgzngmet3dzygvcskvvo34wu333na4dsstvkcezwcjh@6klyi5bjwkwa>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <egk7ltxtgzngmet3dzygvcskvvo34wu333na4dsstvkcezwcjh@6klyi5bjwkwa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.04.25 20:05, Liam R. Howlett wrote:
> * Fuad Tabba <tabba@google.com> [250328 11:32]:
>> This series adds restricted mmap() support to guest_memfd, as well as
>> support for guest_memfd on arm64. Please see v3 for the context [1].
> 
> As I'm sure you are aware, we have issues getting people to review
> patches.  The lower the barrier to entry, the better for everyone.
> 
> Sorry if I go too much into detail about the process, I am not sure
> where you are starting from.  The linux-mm maintainer (Andrew, aka
> akpm), usually takes this cover letter and puts it on patch 1 so that
> the git history captures all the details necessary for the entire patch
> set to make sense.  What you have done here is made a lot of work for
> the maintainer.  I'm not sure what information below is or is not
> captured in the v3 context.
> 
> But then again, maybe are are not going through linux-mm for upstream?

[replying to some bits]

As all patches and this subject is "KVM:" I would assume this goes 
through the kvm tree once ready.

[...]

> 
> So this means I need 6.14-rc7 + patches from march 18th to review your
> series?
> 
> Oh my, and I just responded to another patch set built off this patch
> set?  So we have 3 in-flight patches that I need for the last patch set?
> What is going on with guest_memfd that everything needs to be in-flight
> at once?

Yeah, we're still all trying to connect the pieces to make it all fly 
together. Looks like we're getting there.

> 
> I was actually thinking that maybe it would be better to split *this*
> set into 2 logical parts: 1. mmap() support and 2. guest_memfd arm64
> support.  But now I have so many lore emails opened in my browser trying
> to figure this out that I don't want any more.
> 
> There's also "mm: Consolidate freeing of typed folios on final
> folio_put()" and I don't know where it fits.

That will likely be moved into a different patch set after some 
discussions we had yesterday.

> 
> Is this because the upstream path differs?  It's very difficult to
> follow what's going on.
> 
>>
>> The state diagram that uses the new states in this patch series,
>> and how they would interact with sharing/unsharing in pKVM [4].
> 
> This cover letter is very difficult to follow.  Where do the main
> changes since v6 end?  I was going to suggest bullets, but v3 has
> bullets and is more clear already.  I'd much prefer if it remained line
> v3, any reason you changed?
> 
> I am not sure what upstream repository you are working with, but
> if you are sending this for the mm stream, please base your work on
> mm-new and AT LEAST wait until the patches are in mm-new, but ideally
> wait for mm-unstable and mm-stable for wider test coverage.  This might
> vary based on your upstream path though.
> 
> I did respond to one of the other patch set that's based off this one
> that the lockdep issue in patch 3 makes testing a concern.  Considering
> there are patches on patches, I don't think you are going to get a whole
> lot of people reviewing or testing it until it falls over once it hits
> linux-next.

I think for now it's mostly KVM + guest_memfd people reviewing this. 
linux-mm is only CCed for awareness (clearly MM related stuff).

> 
> The number of patches in-flight, the ordering, and the base is so
> confusing.  Are you sure none of these should be RFC?  The flood of
> changes pretty much guarantees things will be missed, more work will be
> created, and people (like me) will get frustrated.

Yeah, I think everything basing the work on this series should be RFC or 
clearly tagged as based on this work differently.

> It looks like a small team across companies are collaborating on this,
> and that's awesome.  I think you need to change how you are doing things
> and let the rest of us in on the code earlier. 

I think the approach taken to share the different pieces early makes 
sense, it just has to be clearer what the dependencies are and what is 
actually the first thing that should go in so people can focus review on 
that.

> Otherwise you will be
> forced to rebase on changed patch series every time something is
> accepted upstream. 

I don't think that's a problem, the work built on top of this are mostly 
shared for early review/feedback -- whereby I agree that tagging them 
differently makes a lot of sense.

-- 
Cheers,

David / dhildenb


