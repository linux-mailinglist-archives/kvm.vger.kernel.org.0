Return-Path: <kvm+bounces-53187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEB4B0ED0F
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBC34189C6AA
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0BE27A92D;
	Wed, 23 Jul 2025 08:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTf4LL9W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21184279DBA
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753258841; cv=none; b=jjIdx+jxYAHauHF5Di4OZWO5i4kg1g7oJcxcjF0ZjiCfvJ8hva+90rIHfoWgv18xd0qSYtMahRTIUgNgT1SqXp+Td5UUG/Fc+kKGQzyg+inYzkarFODa6jjWW+9rZfkmnsyhCmUfdVZbUI6BAG23H54/52cngs5mCG3a5kZgiE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753258841; c=relaxed/simple;
	bh=hsczvWWZZK+zZzVF7FiOuyFbg4D8AetCUGPHyHYX1wY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZrGOVDuUUPrWClU1sMMs3LnVia6MOEHOYue4VpWEoKEeLOfItyByz2bn8FwtxyxIeO1DysUyX1+CKKPIF9nf+BRSNpFqgzYDHWo1QEx/MPbOu/bK9mltivhEvJDJ/cHD4tDNVfEKKZKWLuXBTBHqfqgYx4e1AkkdyBFD3wWYe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTf4LL9W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753258838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ArrbP6ULmISQTAdQsbfYfBJ/dfwnESI5dLXQURXYbWQ=;
	b=hTf4LL9WuZjghB5/TueMl7TcRFPuP0Bo1VEGeOXr+nSF/0ptajOMhndaCSD7FvUrEt4gMz
	2uhdivvLNw68ehk+qTa8r11a6kPJStuWMPeRZoQpKC9jZcZeF72qFBBLpuQfuMZSk9ELOY
	Lxu4VX6K0vEPbbfqbAxvA0UOzID5c3A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-IxvaPOrlOV6JxYgy36OCsg-1; Wed, 23 Jul 2025 04:20:35 -0400
X-MC-Unique: IxvaPOrlOV6JxYgy36OCsg-1
X-Mimecast-MFC-AGG-ID: IxvaPOrlOV6JxYgy36OCsg_1753258835
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso2695551f8f.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 01:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753258834; x=1753863634;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ArrbP6ULmISQTAdQsbfYfBJ/dfwnESI5dLXQURXYbWQ=;
        b=YByqvt0v6mh2CbqAoohu6fSY+UH5N8xLPgCMU7e2O6hVB+q2hhhCnwRo8xAt9DkGKh
         v+bkIOzxXpcGUq/COSJzVx+MUUJuPFdySCRcYZwf8C+GPytBwa88IwmQ4nuKoEWt2WRU
         fxnDeF1AKcKdLHXjXw+Uaj9yS6gcC/2Xu5eJKmXGG9MMsR1Mg/v9vq623U1B99v8+JcT
         8mvSdPS8uIM+UlyGVnJxv+GemOKuKwvoU5vpBPsioS0La674xvKkfGmdpx6WZqPZgAQW
         n5dyS+7NQDfzoouCo71GJ2synBefyDKGD51q1V+SaZKNIzedupwXjZkTUQ4B1OFhrgGK
         zCQg==
X-Forwarded-Encrypted: i=1; AJvYcCXByNDupoD5i7NEka0Key25dgnJ/a2k5zWE1Q6TpBKJ2eVM01iQ30IC5FvV1IbWnoa+7Lg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZX785rHWK4uNdNgcSj/6WHRmgzEssmRgthGspkUl375aJbQmL
	9iYTMxsJxkBCoM7JdaXKu8FHhY0GtbKy92Tg183xZWeCbbMivaIc4FAO2nRQVW6Z+meKxPZXcfH
	I8ayKlX83eVjCjSnfYi1jICDf5wBHN1d8+0Mwd+13tAcFmwUXhqp4aw==
X-Gm-Gg: ASbGncsOY8c/sZhzmKJcQjhoD26APHS/+FdhcyfbA4oofGdEp1XZPcay24g79cMUuKl
	EDuAMPpyZk1mcuaTQBNAtNxaGfX0kCeb8VW2Mhb8AqIz/UFMZyp1CyH9Mpx4fxxdAzEauI0XqHe
	UfYdy2BCwcZaV79ypINvCE0ysKpm/7OA4zM/zaj4KvniwrZcoqqin0+HMO46paC5Ax/qBnmPf9J
	NRYsafwEIJAkt4KuI9jl7xwCwzcPhSUgGB3Ae286sPYb9x8JCkJPPLYyUTzIqP7pM30fAOmxebK
	ouD4u51jjJvPSjvyXzaHDXcfeXjg1Jj53Qgu6AGmrgpRgUdqNkFYFaIKtWOv8KvX6sPVg1lDpB/
	hG++3cd7iOThvjqu/aKj2Tyb2bEMmYvUcQRjFrdmvPQBRRd+Up74PdH7DdGiTAK3kBO4=
X-Received: by 2002:a05:6000:2088:b0:3b5:e6f2:ab4d with SMTP id ffacd0b85a97d-3b768f0784amr1449510f8f.42.1753258834384;
        Wed, 23 Jul 2025 01:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuehv3n5C5mV94SzfgBIwheXZpqlCTL4RcfpQFRxJyOhldB5Jf2Jv2Nn3bHC1HmTGXwVtUSw==
X-Received: by 2002:a05:6000:2088:b0:3b5:e6f2:ab4d with SMTP id ffacd0b85a97d-3b768f0784amr1449465f8f.42.1753258833789;
        Wed, 23 Jul 2025 01:20:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76773a0e3sm2532813f8f.17.2025.07.23.01.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:20:33 -0700 (PDT)
Message-ID: <42146bb2-c017-43dd-aee2-1f1a893d3b17@redhat.com>
Date: Wed, 23 Jul 2025 10:20:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org,
 akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz,
 bfoster@redhat.com, tabba@google.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org,
 hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com,
 rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com,
 amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com,
 ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com,
 pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com,
 suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
 <aH-j8bOXMfOKdpHp@google.com>
 <80a047e2-e0fb-40cd-bb88-cce05ca017ac@redhat.com>
 <aIAZtgtdy5Fw1OOi@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIAZtgtdy5Fw1OOi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.07.25 01:07, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, David Hildenbrand wrote:
>> On 22.07.25 16:45, Sean Christopherson wrote:
>>> On Tue, Jul 22, 2025, David Hildenbrand wrote:
>>>> Just to clarify: this is based on Fuad's stage 1 and should probably still be
>>>> tagged "RFC" until stage-1 is finally upstream.
>>>>
>>>> (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
>>>> still feasible looking at the never-ending review)
>>>
>>> 6.17 is very doable.
>>
>> I like your optimism :)
> 
> I'm not optimistic, just incompetent.

Well, I wouldn't agree with that :)

> I forgot what kernel we're on.  **6.18**
> is very doable, 6.17 not so much.

Yes, probably best to target 6.18 than rushing this into the upcoming MR.

-- 
Cheers,

David / dhildenb


