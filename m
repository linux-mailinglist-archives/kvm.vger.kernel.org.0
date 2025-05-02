Return-Path: <kvm+bounces-45197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E360AA6ADA
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D184A16F95E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 06:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0CE265623;
	Fri,  2 May 2025 06:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c9LkJLmo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41041C8629
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 06:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168302; cv=none; b=h3QVfYBD0VR2qfIk7eWwynH7nvoigFoHrg/Xs1uiPFB6O/WSRVL5/uEG/ji/5tsaMKOWqaoG9CxvvT04nDF9se/FFFwN/+VBlQOTMg7Ylk4SeLzB/Tsi2KOiBglMl5HFQ3Z/8HLJTeSK2BJ9DyTkK1TSlpcA7nB0wOhsLPJjQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168302; c=relaxed/simple;
	bh=ftI638hKBNgg3g3jV/MmYoitoAu8daGeJvqD1hgvbLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JkGOtzCpLSQuHsTgfUZS5soUoyY9KeQY7K7tAXQPzwhPjuvcTxAKIdUdBEIqnDfzXK0a36rb/yHlIziYmBAZOj/U6WnUyvvmDYdAzdDbLY1A2X8C6ZdJT0oZiChwf6Mhwt6lxu35E2edkdebpsh1u7vjlKJLIIDcTiQfmkqO5d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c9LkJLmo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746168299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pKCmDpTJ4WVlMS7YDLhQuB3yJR81LkbOgXdTVmdiHhA=;
	b=c9LkJLmoyMrxqLrumuwpA8Ow3oziSdqpqSGFkQCxMukkAHL4uvL7QwdVT/y/gwxfTOOBd7
	5A5Q9e51pFEeu31fSeNsR30KQXHcYyhfYb8uWyJ/n9BXUsys+V4NpDSDBPdj1VI0Xp3eVC
	6UNDMWg3uSVPJg8nWpDVaw2pCMserzE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-eNx-qBMgPE6DZBtNDuFWrw-1; Fri, 02 May 2025 02:44:58 -0400
X-MC-Unique: eNx-qBMgPE6DZBtNDuFWrw-1
X-Mimecast-MFC-AGG-ID: eNx-qBMgPE6DZBtNDuFWrw_1746168297
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c30f26e31so841853f8f.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 23:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746168297; x=1746773097;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pKCmDpTJ4WVlMS7YDLhQuB3yJR81LkbOgXdTVmdiHhA=;
        b=U5rl8ItqYpxqf92cpT/sZcKZ20JbjT7Nes4JAZ1ik9fdJJabWeVkmrB/CK86oOWljc
         8V1XFP3irne9YKfWFwJqzTildfMNBIWqizBcNin84OWSmnr4OAwdLO4Vo1h/qv0Str7g
         gMLIDd39Vu6AM3A2qqOzv8ZqW2+ld1czLvSUmw4HhWdWs7Pdo7ANYXsbEQYzKUsly5Pt
         y/zZ03Q3EZI4COEkgTNaJ0w1giN+ndx6/UNQCQxmLAMLp5JaBqwPlu2KHiQ2qCJOPTgk
         Vc2agz7gxSVcM9QWDj/IfPdPdVV3BKGbd7E+GDzx5vPL1wYF/OH0jRT85kne13nLTmr6
         4YmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe8BmwQjbSGB40ryKyEzg/weTn6X4A4RaJ2kRq+BcyrjxG4kWUoht7VfeZuvo1lMGcu7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaMxisBEEiQtNIb0Q8rhRRgCvD4c2fJjqxERg1yB4HpwquEr1c
	1KPPNh5kjniLJOb1TYJoVikfj8tSseExvnsKlI+WnKFtsDxwhuiWJIQAyJXQaxwXMjQeCt/mf73
	OxgE6Inig4m6y193M/VhHFUjtiz5/6Uq3sA4tRv6PPzOcscIApA==
X-Gm-Gg: ASbGncveUJV4OnLSPdewSL8kebkq8c5FAN3wBvPajONETmNl0aEolp+xY26rCi72g3O
	prCKVKrXDVC06pyAgcf+RMSsgqF2dootaJVEU1YcIPocVTxIhnXmeEFNqqXRFew8rcX7cFA27iN
	CMOm8m4I12qg6L8MLxlWu+DdbrYs9ek4R2ogcXyt6x9voals4gf6N0s0Y1sxTRGXnR89t3rTqpw
	zfzXpl4FqdczjwaO0LR2ujSGvmb3aKIp4hA6Uk7REdGxBE9GrQxlRuhLnjPWDZKuitFs6TN2NXp
	dTVmGdvlyUhi6a6M2o8tcp5LMVwI4ldoEx9+44y5ms9kJYhF3ytv3CFLnPSICHjpkfLpWAbA5H9
	Nn5S7iZfsioOZF+qfRcBz8PXNicsMCTK2M6mHC5M=
X-Received: by 2002:a05:6000:2585:b0:390:e1e0:1300 with SMTP id ffacd0b85a97d-3a099addbe5mr879493f8f.33.1746168297279;
        Thu, 01 May 2025 23:44:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYkjHJPoTbYUuL3XuwZQ8WpGAioiqU9FtDeqcHoQrYX71WEo+ASp/7gmLpQSMx5lSYrEtEoA==
X-Received: by 2002:a05:6000:2585:b0:390:e1e0:1300 with SMTP id ffacd0b85a97d-3a099addbe5mr879468f8f.33.1746168296878;
        Thu, 01 May 2025 23:44:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c713:d600:afc5:4312:176f:3fb0? (p200300cbc713d600afc54312176f3fb0.dip0.t-ipconnect.de. [2003:cb:c713:d600:afc5:4312:176f:3fb0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae3bc0sm1266521f8f.35.2025.05.01.23.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 23:44:56 -0700 (PDT)
Message-ID: <b6355951-5f9d-4ca9-850f-79e767d8caa2@redhat.com>
Date: Fri, 2 May 2025 08:44:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/13] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Ira Weiny <ira.weiny@intel.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-3-tabba@google.com>
 <6813b9167661b_2614f12944e@iweiny-mobl.notmuch>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6813b9167661b_2614f12944e@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.05.25 20:10, Ira Weiny wrote:
> Fuad Tabba wrote:
>> The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
>> guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
>> clearer.
> 
> I'm curious what generic means in this name?

That an architecture wants to use the generic version and not provide 
it's own alternative implementation.

We frequently use that term in this context, see GENERIC_IOREMAP as one 
example.

-- 
Cheers,

David / dhildenb


