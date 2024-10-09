Return-Path: <kvm+bounces-28243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A90996CC1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 014B01F21ADE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2520719994B;
	Wed,  9 Oct 2024 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="PrW6gATx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824D71991D7
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728481957; cv=none; b=flIdwiOk1fW0drod/xcuHaKi/HP4ek9TPAlJtGzPAz0tcMsFrOi/ZXxbGl3BIaNz/Dlh2+GY5B7S9z2c2gVKJSEZANKpjM8sVX5otvaa9OhWh0HnXLpAKH4VDkSW4l4avv/HO2CFlSlhHkbPwKhcHymFZPfIsGU0OnmxEJoA/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728481957; c=relaxed/simple;
	bh=Kof5Yodg6TBaoa9v2GsFAXmZLlexak4T4ZwsrVsSJJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2DcFK0WStHCfCCdpdj8vp1EoO2u3zF7rkaBia5fDEwyhwyZwUTHYYecNexGfAwmVYGiCf0+edUDdRgl1F6Wtjg6dNwyfDhPVoBEqZxNQ8MT2cCDbCgzPxPOcqVchnbYzCVs4QKwqi4+o9v4Si3CdK/+L9MOXxfLO6R5mRsVJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=PrW6gATx; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c8af23a4fcso8379207a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 06:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1728481953; x=1729086753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Kof5Yodg6TBaoa9v2GsFAXmZLlexak4T4ZwsrVsSJJA=;
        b=PrW6gATxWP3OoTNd3E6HM4uEKIUBnUI/r4yW4tTxql6o/M4fHYP5fzeA0sWmr6eWG7
         RgaImqmkndSjdXFZBU0F/tX5uSU9oZ+co/avPw6a0Iq1BgdhMlZksXQBIUfKNcHX0XI4
         MEj89GFxe1bRxMhdIleWgoAi8orospov8sFs4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728481953; x=1729086753;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kof5Yodg6TBaoa9v2GsFAXmZLlexak4T4ZwsrVsSJJA=;
        b=LVYMjX7PFj9XeP0/Ns8tOQ41FWYsPtCPSt4bMRzMPqNMqT9Xxg+KFNBeShjE+GCR8W
         36rTQzjUccelSv0AezaJvE3dDB/1P/jxUlFJTO1hhdWurstar8lAisUNan7//gz+mhRh
         7NQkpSOhJgkzfp3/eqDss2UNnw3X0vYNVhAo9PIf2+n/0nBibIcVTX4jYyH4ZkYNLLFP
         PQ2Il0ezFI/cdzQI6LawSL//Gvf/cJysdlC5Ij+Y+dEn+53OK06TIZMdVM2EK8wO/6DI
         DoGEcwQdQAVRywDqZaX5EK13brKOKKFeoz40wozCe3cpmNbB8k9zbXkHFHLMzY1Ug9V8
         0pIA==
X-Forwarded-Encrypted: i=1; AJvYcCUkEsKqsev2WleEysGJKKktWkwFa2qgWtBuJ791fAS3rA87eF3Qcu0nSW8rlFnXqqb4YbE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrc1mr97rJxH854HNwX/yv5R6bt0hN+zcYUROYngnBRp1IrOpM
	RoWq2inqvgd0ghzvG3XQGw6YlYkqDMy3nbn/Yy2QlAVoHHJ5wmmlYBh4ZJkqrWY=
X-Google-Smtp-Source: AGHT+IEVZgQja/pq0KJhq7VaRjn+rVNTXUMFEKVAbK6fh4PeIkrIqp1GR26w0Uq8ecU3H8Rfn+TsfA==
X-Received: by 2002:a05:6402:26c3:b0:5c0:ab6f:652a with SMTP id 4fb4d7f45d1cf-5c91d53e920mr1661784a12.3.1728481952620;
        Wed, 09 Oct 2024 06:52:32 -0700 (PDT)
Received: from [10.125.226.166] ([185.25.67.249])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05eccf0sm5480050a12.64.2024.10.09.06.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 06:52:32 -0700 (PDT)
Message-ID: <e0fa3af9-503c-4569-86e0-571a0218c35b@citrix.com>
Date: Wed, 9 Oct 2024 14:52:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 30/39] KVM: guest_memfd: Handle folio preparation for
 guest_memfd mmap
To: "Manwaring, Derek" <derekmn@amazon.com>, seanjc@google.com,
 dave.hansen@linux.intel.com
Cc: ackerleytng@google.com, ajones@ventanamicro.com, anup@brainfault.org,
 bfoster@redhat.com, brauner@kernel.org, david@redhat.com,
 erdemaktas@google.com, fan.du@intel.com, fvdl@google.com,
 haibo1.xu@intel.com, isaku.yamahata@intel.com, jgg@nvidia.com,
 jgowans@amazon.com, jhubbard@nvidia.com, jthoughton@google.com,
 jun.miao@intel.com, kalyazin@amazon.co.uk, kent.overstreet@linux.dev,
 kvm@vger.kernel.org, linux-fsdevel@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 maciej.wieczor-retman@intel.com, mike.kravetz@oracle.com,
 muchun.song@linux.dev, oliver.upton@linux.dev, pbonzini@redhat.com,
 peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com,
 quic_eberman@quicinc.com, richard.weiyang@gmail.com, rientjes@google.com,
 roypat@amazon.co.uk, rppt@kernel.org, shuah@kernel.org, tabba@google.com,
 vannapurve@google.com, vkuznets@redhat.com, willy@infradead.org,
 zhiquan1.li@intel.com, graf@amazon.de, mlipp@amazon.at, canellac@amazon.at
References: <ZwWOfXd9becAm4lH@google.com>
 <ac337485-f8ab-45a4-b223-eb846e21c762@amazon.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <ac337485-f8ab-45a4-b223-eb846e21c762@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/10/2024 4:51 am, Manwaring, Derek wrote:
> On 2024-10-08 at 19:56+0000 Sean Christopherson wrote:
>> Another (slightly crazy) approach would be use protection keys to provide the
>> security properties that you want, while giving KVM (and userspace) a quick-and-easy
>> override to access guest memory.
>>
>>   1. mmap() guest_memfd into userpace with RW protections
>>   2. Configure PKRU to make guest_memfd memory inaccessible by default
>>   3. Swizzle PKRU on-demand when intentionally accessing guest memory
>>
>> It's essentially the same idea as SMAP+STAC/CLAC, just applied to guest memory
>> instead of to usersepace memory.
>>
>> The benefit of the PKRU approach is that there are no PTE modifications, and thus
>> no TLB flushes, and only the CPU that is access guest memory gains temporary
>> access.  The big downside is that it would be limited to modern hardware, but
>> that might be acceptable, especially if it simplifies KVM's implementation.
> Yeah this might be worth it if it simplifies significantly. Jenkins et
> al. showed MPK worked for stopping in-process Spectre V1 [1]. While
> future hardware bugs are always possible, the host kernel would still
> offer better protection overall since discovery of additional Spectre
> approaches and gadgets in the kernel is more likely (I think it's a
> bigger surface area than hardware-specific MPK transient execution
> issues).
>
> Patrick, we talked about this a couple weeks ago and ended up focusing
> on within-userspace protection, but I see keys can also be used to stop
> kernel access like Andrew's project he mentioned during Dave's MPK
> session at LPC [2]. Andrew, could you share that here?

This was in reference to PKS specifically (so Sapphire Rapids and
later), and also for Xen but the technique is general.

Allocate one supervisor key for the directmap (and other ranges wanting
protecting), and configure MSR_PKS[key]=AD by default.

Protection Keys were identified as being safe as a defence against
Meltdown.  At the time, only PKRU existed, and PKS was expected to have
been less overhead than KPTI on Skylake, which was even more frustrating
for those of us who'd begged for a supervisor form at the time.  What's
done is done.


The changes needed in main code would be accessors for directmap
pointers, because there needs to temporary AD-disable.  This would take
the form of 2x WRMSR, as opposed to a STAC/CLAC pair.

An area of concern is the overhead of the WRMSRs.  MSR_PKS is defined as
not-architecturally-serialising, but like STAC/CLAC probably comes with
model-dependent dispatch-serialising properties to prevent memory
accesses executing speculatively under the wrong protection key.

Also, for this strategy to be effective, you need to PKEY-tag all
aliases of the memory.

~Andrew

