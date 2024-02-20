Return-Path: <kvm+bounces-9152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2CE85B6D7
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2781428A056
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F098560EF7;
	Tue, 20 Feb 2024 09:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IHIAHm2i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8132F5F872
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420187; cv=none; b=iFSu/sYw3RgOY9hqoxxZ6l3S6n5v3Wq5kEe5p36MidwyqEPEWjKaq0CIgLbYQB141tTXqvt5xyJpK4SNF8hUJ6e7ugsQJbho28iUnwd/zOy/b0D+nc6BH/qGbssu12h58DLwwHerUFcipZGDtj70Jjjg/SnPMF62aG7UiqsagYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420187; c=relaxed/simple;
	bh=iBDWGDV0zPhBcBSJ5xAuwrcwqoC42vEH3/Vd0rAbGyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OG7obv6haD4AXx+1A6IKm3rHQiI9LYEQimC2jfBY0rG4gPOD1NsoXyP+V0cQanuzcBAB3i6J83/A+UWNNjpJiRPEwzRvjWX22xAimdpiHVGkxoOfzcUrbFzKqwQDZaS3/tkMmSjF3P/DgYQbDdD3e5oR/WDM08Z+I6snzSK6oVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IHIAHm2i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708420184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6DQPV7gTixXT9lbsSTfg24G8z4KqnnNWdVLghcppC70=;
	b=IHIAHm2imSxu0QbY35ZPsp9ScPNRzSoCQlKieljuRTcwP2sXtpvLtkLrF309te9iiNCCID
	Dq2LXwmkD1u3MFG+4mRFwM2mMQnoMZIM1Y0Mm8iqvUh6XPUXi8mE1LX+Hr10JjIUIjTxxq
	lKtXIheR4aNXorm91Y+THEr9Gg2cO3A=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-GgBkq4fgNsGY6V24-_SMkA-1; Tue, 20 Feb 2024 04:09:42 -0500
X-MC-Unique: GgBkq4fgNsGY6V24-_SMkA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d09fe39949so39650921fa.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 01:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708420181; x=1709024981;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6DQPV7gTixXT9lbsSTfg24G8z4KqnnNWdVLghcppC70=;
        b=vEtZCh8Sv4BIbIgAdF+cPSSUpK2c++w3Eag3PwYyRprI1a8LdOSwTKgv0ky3UcooXv
         udVcOHuT0vSbIBOaLPguWIg47SFhlLRraPhll5EHdt1bP5Ble822h/y9JtxcC1REHnYS
         bjD/T+0snPHMN02NB8PfhpoC0JVVQE/Lz+8FRCXFXJpo1xCtMWBn5nVsL0sX+/zpIMmU
         Ivz/tka7x9UrJPjOSqlUJsAzlp74+iLQbTIUwKcNy/ov8sc9t2ciTNACaaZerqKabqP2
         PpbEMcGnjs86DwtQGUxQiQy5GdxSc7O+YKY1j0M2vf564XIlPVhx2/bm9eaJKL6e/i/+
         FDZw==
X-Forwarded-Encrypted: i=1; AJvYcCXha4/fR/ZcplvU6QNm6Iw7oQPzaTlIfO28lbHAZIpJ8tGfvETbQy0HcJBGRuco272AUeWVQS47tt58WeYbVlwq6rnp
X-Gm-Message-State: AOJu0YwOGzKyr+QvcIPeQeed0sL/kcRpF5WAn0UFETCUcht5zBvnyBcI
	kw4vHOVZ2TadTPoo132h1KWTRlRRxtMak4LvJFLsfRNbS+uOk2gSY2r82VfA2gYPVR0tkHbTFI9
	463r40GJ8nykueWD42/n46iwgSGSqaiiG2dgpmA++pT0BTsQfUQ==
X-Received: by 2002:a2e:a60a:0:b0:2d2:38ff:8b6 with SMTP id v10-20020a2ea60a000000b002d238ff08b6mr3691699ljp.49.1708420180899;
        Tue, 20 Feb 2024 01:09:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHABIk1a0k5EBdoExcCHSujw9chAr43I+gdXVO+4U9ghBJ/k4hE6kUQo6nb46/AZyyWrELCQ==
X-Received: by 2002:a2e:a60a:0:b0:2d2:38ff:8b6 with SMTP id v10-20020a2ea60a000000b002d238ff08b6mr3691658ljp.49.1708420180463;
        Tue, 20 Feb 2024 01:09:40 -0800 (PST)
Received: from ?IPV6:2003:cb:c72a:bc00:9a2d:8a48:ef51:96fb? (p200300cbc72abc009a2d8a48ef5196fb.dip0.t-ipconnect.de. [2003:cb:c72a:bc00:9a2d:8a48:ef51:96fb])
        by smtp.gmail.com with ESMTPSA id bj4-20020a0560001e0400b0033b68556c38sm13191661wrb.70.2024.02.20.01.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 01:09:40 -0800 (PST)
Message-ID: <6ca94bf1-68b4-4a81-8cd0-d86683e0b12c@redhat.com>
Date: Tue, 20 Feb 2024 10:09:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Content-Language: en-US
To: Ankit Agrawal <ankita@nvidia.com>, Zhi Wang <zhiw@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 "surenb@google.com" <surenb@google.com>,
 "stefanha@redhat.com" <stefanha@redhat.com>,
 "brauner@kernel.org" <brauner@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
 <ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "andreyknvl@gmail.com" <andreyknvl@gmail.com>,
 "wangjinchao@xfusion.com" <wangjinchao@xfusion.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "ricarkol@google.com" <ricarkol@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 "rananta@google.com" <rananta@google.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "bhe@redhat.com" <bhe@redhat.com>
Cc: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <ACurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Matt Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.02.24 09:51, Ankit Agrawal wrote:
>>> To safely use VFIO in KVM the platform must guarantee full safety in the
>>> guest where no action taken against a MMIO mapping can trigger an
>>> uncontained failure. We belive that most VFIO PCI platforms support this
>>
>> A nit, let's use passive voice in the patch comment. Also belive is mostly
>> a typo.
> 
> Sure, will do.
> 

s/we expect/the expectation is that/
s/We belive/The assumption is/

If it's just that, likely no need to resend. Maintainers usually can fix 
that up when applying (otherwise, they'll let you know :) ).

-- 
Cheers,

David / dhildenb


