Return-Path: <kvm+bounces-54994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BCEB2C787
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F6E36868E8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6AA527D780;
	Tue, 19 Aug 2025 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpOxiB8X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB602765EA
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755615054; cv=none; b=NoKEDUpvVbu68p66bDrkX2jkJ9bB3ueG8ZiChymnPjma6LAefYkL8fCNeI+6Pf2qWzHHU0wUc5gRFCOgp8nq6F2J9Z1REl62Q2LN/FMv1+YnQJ5N+yLuGz+QDSPuOqhcUA/PXDz2xUkbfQY1B5Q6VlI/paSr5HgtfbusiNRVUUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755615054; c=relaxed/simple;
	bh=3hgpWvB6M/Qlt7LeRCt5AZv2UMEpK7Tc8UH4bMsTtD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6kSaZzjc+3BxlJG7DZW7UhpPfO1UxLC9+R0UFQ9knLDORINdgTJ601gIhTu3j7tGX2wDALkRA7/poTw2/vBiazeHcFb5i4KZ1R8St1rnDiJAHL8ZXkhxepH4zek8fPXi7+pmnchmZ3NeJeWNLca71ZzvCYK4s7HtSiqjxpdbyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpOxiB8X; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88432e29adcso134150339f.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 07:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755615051; x=1756219851; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nkL6Lf4qeGh6IQDwzhT4JmkS6k1uC7gHiNcx7NhA+2E=;
        b=SpOxiB8XlJ75PVHxL0PmecFYjNaCERKUMBF6zTTqhn0UetJQYR9/iMCN9rId0nB52/
         r31EhTSuydqd7mLN7G7QfxqYD6FD7dQ0RIvE9LTBjJQq+5BvN4ME9RAs3scpBLdntsua
         TalPlSfhs/mYxIFYJoXk3h+NW+HgSbzD49PKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755615051; x=1756219851;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nkL6Lf4qeGh6IQDwzhT4JmkS6k1uC7gHiNcx7NhA+2E=;
        b=K5KH5oNDX4/FNbb6RYpx0vYyiTI738zMv9/k+okLoNqEoSk4+bk3PqfsMPBhdczyQa
         EaBhLUP7NrZXJlQngAfZyPbRxFvAyq8wynqdtLHTnpZ9ieAIWVII4WZl41McEjGmozKz
         KCmbjvLkos83YlCnlZTjS2uD79uZd1SSsDiMYr92x6+vZ5KmqLne0Hq7BSqy2xCU80v9
         ZueQyLH3AGrWy779m1H7kyVZi9c3DGq2vXE556rxl06KDON1B6w0wto80Sh71rtmd034
         i8TnwRGf3DpUGVRunlqBanDyz7LGiy/4CkAMXno5zbLzeOMyV9Tl4CVFj0+GlxzPiECE
         y+4w==
X-Forwarded-Encrypted: i=1; AJvYcCVU0Rhgv94f/mt6P7HpV6OO5gOd/XkHYOSzLrQzBSCa9CZ3uEtm1HiFUL/+W2RW3ORj+08=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJu2L1p7/2l2wTobfUWCWFw+ZIwdpFf6pwQJYZ0GA272L1sH4R
	bpCXhg6eRR61pWkw/sVO4Gkb2dxeuKtkbZYXOfydGjW+rr1wSRS5XIgyMlYYMA0IeZQ=
X-Gm-Gg: ASbGncvIx7VBBdf7odb7PRSF5DU3+X4jlXkab57kf24BLwLfW6f/hgihe0thShrnTRQ
	I/7MkEeLMkWCxHrWi2Et+WvyEyNISIJ3u7XmZEtvUCd7ff+/dmVdCOi3GBHCWQF0UsOKNg3eDjf
	d/yb2fGycFVOLsGdIJeUVoG/PFCsRFiAOAstZqWJggExbjBu2FyVlxqYjiy0bCKt4PUKV0wuKcw
	PD3zuMRWXNGxUwkKMZVovQHZxQWNCenSYU9cmJvkTN3sHYCzULv4r9vD3kkv9XQ+6/I6E94MCLe
	kp8W0GH3F8FMI1wXaKFJpBsiBH87qgf4ALfmT4fvNYNYVZAgFLKoeC9NGsBuDtmuVIR5/tjmQcv
	Zyq/JNDeSuikUYbQsHVwzNaX5IwQFQ2Z/sVY=
X-Google-Smtp-Source: AGHT+IETI7shiHyC6m4ISrsGLlHmRRKz937/t+lqa+3tqujW/NZcAWXuRerlQlDR/Icc+aM597Y4UQ==
X-Received: by 2002:a05:6602:1601:b0:881:7c22:2d18 with SMTP id ca18e2360f4ac-88467ecf74fmr468337539f.8.1755615050613;
        Tue, 19 Aug 2025 07:50:50 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f9c3329sm404935039f.19.2025.08.19.07.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:50:50 -0700 (PDT)
Message-ID: <771b7ff1-3497-4d80-8f43-a1aaf28a3999@linuxfoundation.org>
Date: Tue, 19 Aug 2025 08:50:48 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/33] vfio: Introduce selftests for VFIO
To: Alex Williamson <alex.williamson@redhat.com>,
 David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Aaron Lewis <aaronlewis@google.com>,
 Adhemerval Zanella <adhemerval.zanella@linaro.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Andrew Jones <ajones@ventanamicro.com>, Ard Biesheuvel <ardb@kernel.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 dmaengine@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 James Houghton <jthoughton@google.com>,
 Joel Granados <joel.granados@kernel.org>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 "Pratik R. Sampat" <prsampat@amd.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 Vipin Sharma <vipinsh@google.com>, Wei Yang <richard.weiyang@gmail.com>,
 "Yury Norov [NVIDIA]" <yury.norov@gmail.com>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250620232031.2705638-1-dmatlack@google.com>
 <CALzav=dVYqS8oQNbygVjgA69EQMBBP4CyzydyUoAjnN2mb_yUQ@mail.gmail.com>
 <20250728102737.5b51e9da.alex.williamson@redhat.com>
 <20250729222635.GU36037@nvidia.com>
 <CALzav=d0vPMw26f-vzCJnjRFL+Uc6sObihqJ0jnJRpi-SxtSSw@mail.gmail.com>
 <CALzav=fdT+NJDO+jWyty+tKqxqum4RVkHZmUocz4MDQkPgG4Bg@mail.gmail.com>
 <20250818133721.32b660e3.alex.williamson@redhat.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250818133721.32b660e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/18/25 13:37, Alex Williamson wrote:
> On Mon, 18 Aug 2025 11:59:39 -0700
> David Matlack <dmatlack@google.com> wrote:
> 
>> On Thu, Jul 31, 2025 at 1:55 PM David Matlack <dmatlack@google.com> wrote:
>>>
>>> On Tue, Jul 29, 2025 at 3:26 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>
>>>> On Mon, Jul 28, 2025 at 10:27:37AM -0600, Alex Williamson wrote:
>>>>> On Fri, 25 Jul 2025 09:47:48 -0700
>>>>> David Matlack <dmatlack@google.com> wrote:
>>>>>> I also was curious about your thoughts on maintenance of VFIO
>>>>>> selftests, since I don't think we discussed that in the RFC. I am
>>>>>> happy to help maintain VFIO selftests in whatever way makes the most
>>>>>> sense. For now I added tools/testing/selftests/vfio under the
>>>>>> top-level VFIO section in MAINTAINERS (so you would be the maintainer)
>>>>>> and then also added a separate section for VFIO selftests with myself
>>>>>> as a Reviewer (see PATCH 01). Reviewer felt like a better choice than
>>>>>> Maintainer for myself since I am new to VFIO upstream (I've primarily
>>>>>> worked on KVM in the past).
>>>>>
>>>>> Hi David,
>>>>>
>>>>> There's a lot of potential here and I'd like to see it proceed.
>>>>
>>>> +1 too, I really lack time at the moment to do much with this but I'm
>>>> half inclined to suggest Alex should say it should be merged in 6
>>>> weeks (to motivate any reviewing) and we can continue to work on it
>>>> in-tree.
>>>>
>>>> As they are self tests I think there is alot more value in having the
>>>> tests than having perfect tests.
>>>
>>> They have been quite useful already within Google. Internally we have
>>> something almost identical to the RFC and have been using that for
>>> testing our 6.6-based kernel continuously since March. Already they
>>> have caught one (self-inflicted) regression where 1GiB HugeTLB pages
>>> started getting mapped with 2MiB mappings in the IOMMU, and have been
>>> very helpful with new development (e.g. Aaron's work, and Live Update
>>> support).
>>>
>>> So I agree, it's probably net positive to merge early and then iterate
>>> in-tree. Especially since these are only tests and not e.g.
>>> load-bearing kernel code (although I still want to hold a high bar for
>>> the selftests code).
>>>
>>> The only patches to hold off merging would be 31-33, since those
>>> should probably go through the KVM tree? And of course we need Acks
>>> for the drivers/dma/{ioat,idxd} changes, but the changes there are
>>> pretty minor.
>>
>> Alex, how would you like to proceed?
> 
> I think we need an ack from Shuah for the overall inclusion in
> tools/testing/selftests/

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

Glad to see these test in the kselftest suite.

> 
> AFAICT the tools include files don't seem to have any central
> authority, so maybe we just need to chase those ioat/idxd acks, along
> with Shuah's and we can get this rolling and follow-up with the latter
> KVM patches once the base is merged.  Thanks,
> 

thanks,
-- Shuah



