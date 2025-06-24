Return-Path: <kvm+bounces-50475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94385AE6176
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCB747B41D4
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731DC27BF85;
	Tue, 24 Jun 2025 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MN1DRUV6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663927C17E
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750758706; cv=none; b=l4zZhzBTRvdqkO5N8Bz4UaPIbagiFH/UMa1foI0AG4BltKAJGDqewx1hHf+mFjtaT1UOTj3+TqxB9dNHL+JKUkW4Drghq2Qu8qtDT5znHQMdFyf0CqJr9zOaT3Gn1eWwCG1ASfYtiPvoUauf9ekw5ie792nFyJwYA6fItDS5vR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750758706; c=relaxed/simple;
	bh=WP2hA6Cn/tr9qy0uD1DIf//dih5bHXWMeXJ5c/7fnk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1zjpt743UYTvLgH8dBPkozmIdfwUsO/rzXWZauiuyI4vrDfD8LhE4PW+D6bZxzQTcihSZgDDSY5HRSrVhv8WxWF7rhUCjKLnfdEpHxAdCxk2TZQIZ1jIDGJVBsEIKIwG7Nogu8IxhzUnVrkgux2dkOnNbhQmgu7RV3F95/U7ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MN1DRUV6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750758703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o1Xn7exViJ5XiCzBolqdsBU4hG+gJ473jKEJ6tSqefU=;
	b=MN1DRUV6itL3HUMUL2aEEJaG/xue/6DBouwxWcWQtXX7eKRi4jWduuxe2vAK+sIqXqXf74
	AMaQOARJiGCZzsYu22AN37OAQHHDEKkovuN5c3yghVdg8xRrnVSLH3OTDo1htjCLfiC7OI
	7rRXxOhPmbbRfjsD2cfS8s59JMlpDE4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-Qup_gwCdPW6g8VgHX4fftA-1; Tue, 24 Jun 2025 05:51:38 -0400
X-MC-Unique: Qup_gwCdPW6g8VgHX4fftA-1
X-Mimecast-MFC-AGG-ID: Qup_gwCdPW6g8VgHX4fftA_1750758697
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so137174f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 02:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750758697; x=1751363497;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o1Xn7exViJ5XiCzBolqdsBU4hG+gJ473jKEJ6tSqefU=;
        b=FHtx3m4n5p3bbjNBgQUhh8ZwEjkBIhkyqjYqr00kZ21M/E/rkDG0W1+GNCrn5ebO+/
         tV8VB14oZ5dDzLXCUdCvIJVt/r6UY1R/0zaTu25dXbBtt8FVJCvX14o6sx5rgDNQmYJh
         e3LKXulazaN+FABgQIczS7iHK9+6y/gG5ceeiiYHR+5rdEQnx15jApfgvIsUYd0twC6+
         QtA+Zx1ng5DY4WhpVcxLtl7RWkVEqLLroltX89aK9oeebErQVMHdUhLSZvzJa0YGyL1Q
         +p0/TanYhCjr685pXPVsYheVGkaxUBVgPb8uC8aQFWLSa0n7aUujPp2zRbLFP6i3tjga
         JvVA==
X-Forwarded-Encrypted: i=1; AJvYcCUBWMnsdZL2QrTQ6CNEytqGori1Mr4vFtEqUgPRcHB1Fq90SKME6AagT6lbMb4Mqgmu/go=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZDwUC8X4vVVYNSsA18GO5ly6HarGeYJsTzy6L33nHHOMEwOsp
	Sn9QnMaOXNW/EIqx4sTe97gMvB/k80D1AOR+shq0KbylEWPZFOC6JLwqk7z2SOdhQEhEyZ93ii/
	//LvpkwLvbIfr0x2MuSAPBnFVOOAog9HW3MctllQ3HNy0l+TgJuJiqNKyuBM6uDZU
X-Gm-Gg: ASbGncu+Bs/cT/vDyWadD1Zm3m5ZeaKMHFOyTMIJQUJ68Sap6Btd48at+assMAggZv1
	wdnxaljBDeqDEeAovHGW8WS0iBHccSd9FwtbI6GMj+PC4cO87wDHmWa8OqWCKdtc7RKiyD9GzHN
	ktFVJgFkEr7xj2N3628m822o1e61+WPkOy/0ZdUTuHH896k8de28ej4aGygApPr7rV6NDBvjI0s
	kZ7lSmG4ciILRliVviUgVaxpESTtWimQ77pybfP4WI1Ah0iVc9vLemGBKfPOfwOaG4znaxiRd7b
	hVIgT5/PxtdssovTCew9lF3tUKZAsRR1mzgIO4e/wAyJHZ9v2Dv+wto=
X-Received: by 2002:a05:6000:1acd:b0:3a0:aed9:e34 with SMTP id ffacd0b85a97d-3a6d12e6b31mr13999536f8f.48.1750758697032;
        Tue, 24 Jun 2025 02:51:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3kTOSeFqpR5aeqK4j2CQjXi3VDWGhNL8iC3p74SD6K+B2vgC1W40oOG8TRKJx50jXj/ToqA==
X-Received: by 2002:a05:6000:1acd:b0:3a0:aed9:e34 with SMTP id ffacd0b85a97d-3a6d12e6b31mr13999500f8f.48.1750758696583;
        Tue, 24 Jun 2025 02:51:36 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f22c7sm1504482f8f.53.2025.06.24.02.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 02:51:35 -0700 (PDT)
Message-ID: <5dafefe3-78ec-44a4-a784-9b2333a71364@redhat.com>
Date: Tue, 24 Jun 2025 11:51:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/5] Enable shared device assignment
To: Peter Xu <peterx@redhat.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Zhao Liu <zhao1.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
 Gao Chao <chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>,
 Li Xiaoyao <xiaoyao.li@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Alex Williamson <alex.williamson@redhat.com>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
 <aFM2hFgjiBm3nML6@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aFM2hFgjiBm3nML6@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 23:58, Peter Xu wrote:
> Hi, Chenyi,
> 
> On Thu, Jun 12, 2025 at 04:27:41PM +0800, Chenyi Qiang wrote:
>> Relationship with in-place conversion
>> -------------------------------------
>> In-place page conversion is the ongoing work to allow mmap() of
>> guest_memfd to userspace so that both private and shared memory can use
>> the same physical memory as the backend. This new design eliminates the
>> need to discard pages during shared/private conversions. When it is
>> ready, shared device assignment needs be adjusted to achieve an
>> unmap-before-conversion-to-private and map-after-conversion-to-shared
>> sequence to be compatible with the change.
> 
> Is it intentional to be prepared for this?
> 
> The question more or less come from the read of patch 5, where I see a
> bunch of very similar code versus virtio-mem, like:
> 
>          ram_block_attributes_for_each_populated_section
>          ram_block_attributes_for_each_discarded_section
>          ram_block_attributes_rdm_register_listener
>          ram_block_attributes_rdm_unregister_listener
> 
> Fundamentally, IIUC it's because of the similar structure of bitmap used,
> and the listeners.  IOW, I wonder if it's possible to move the shared
> elements into RamDisgardManager for:
> 
>      unsigned bitmap_size;
>      unsigned long *bitmap;
>      QLIST_HEAD(, RamDiscardListener) rdl_list;
> 
> But if we know it'll be a tri-state some day, maybe that means it won't
> apply anymore.

We discussed some of that in one of the revisions, and it's not clear 
yet how virtio-mem will interact in confidential VMs with that (we will 
have to have both active at the same time). I shared some ideas, but 
they are all stuff for the future.

So how the bitmap(s) will look like in the future and how multiple 
RamDiscardManagers will interact remains to be seen.

-- 
Cheers,

David / dhildenb


