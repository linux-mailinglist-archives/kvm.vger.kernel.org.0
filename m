Return-Path: <kvm+bounces-26117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C59FC971AEF
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C3CC1F25428
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B951BA27A;
	Mon,  9 Sep 2024 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBry5JQv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2121B9B5F
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725888289; cv=none; b=evwKUpL2oU+tDnyaK9oIiMO24E74IV9Ismezg07ogYeW6W13wqjRMSCPAGrXzeVdh9G5UFKrDMvIwWImAn0LHEvRBgVkPuL+xNp50PD9IE1rJlzfiir3wl8cr0Apqv/8r/lOFQ0naYqaedMg3jVfPFGRbNPS4my1RGJstMv6KYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725888289; c=relaxed/simple;
	bh=aycUlN9RGtut06nhV6g6SMP5Z8jpjITcj8790qdzFvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MtW7oVzWg2zT3Q5YJQom4MzoofKCg/F2P+eM1gjJznmSEko/2KwX0gaEVa9zVHiizuyhP4fMrp4v4reNuiLJ0BSlAmAEKDQVHvsYOGT/QtxQWbbs9ZA1jFHNAG2airFDji+70a0yUvClq6iHdZ0Aq+S3TkxwAdrI3YTFhTH5vog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBry5JQv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725888286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PJp6zde+o4+GuZZoS3lJrZtass9VDmatcifcWI992vs=;
	b=RBry5JQvGqJztIFf4rFRN1TTQlYfSpHbnv4QvaIIyU0mKWE8IZ9WBnwrVmzeoObcid2DO+
	cHVL7Ek2aSAWE/kETt9UXXJnZSDUnFbYlWm5Ej9VFM58cXytaI9VIR9bfD/EYT4y3FhbwG
	nYoDa00dnk5yDPjRX6KQqpldAsvNFgs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-3Q5AbCV9ORyixIbhSjzy0g-1; Mon, 09 Sep 2024 09:24:44 -0400
X-MC-Unique: 3Q5AbCV9ORyixIbhSjzy0g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb2c9027dso10975025e9.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725888283; x=1726493083;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJp6zde+o4+GuZZoS3lJrZtass9VDmatcifcWI992vs=;
        b=dDzP8eafQt5zi6Pj16yQ3ElMYPQbfinQQX50lV1a2/EiRLAiDN+3ZTOjaiO45wfcUj
         fLudkQe+Tba5t0aIsvT5DDIqSQo3ZMXGI3zxbW4LvBQFjJRLWslfLzUHHEbF6zMYYsRa
         9EVKpuDRI1a6PXiaILzSZflH8vruroPMiS0fLZRqXOHEExn4jSWQpXavi5N6MgvAkx5m
         ARnf4c+ZNYEKSSg/dwwmNXX2PUGv5Ui0y9Z2MLE9fmeKmANAmmpm6nS0L6LzIE2ksQDf
         e8oaSN+EpSpsMEengtWK73wKWmO8akloyo3YcQlnLlgI5y3hpEjCxo9lPRj/KJ1k58Gb
         rj2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUod1YYebDPOpRGNUYV3A18PV17ti0EgEEC80r45FvWTghwlkIsRWk199wxugS6Q5GcfTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXf+ZCuNLJLPGQbM2QMiXn6tMy+PLOBQU2JeX5b/6m/POZwAI+
	wJsFVGzcoNN97HDuL/WtBKbRFQCKsbRhAY3CbJU2/YuX2ldofbZ760de1mBd21QIadeLt1tXofS
	TF7hFG197wd83s84eFoIys3YolYFXL7CBOh/ZWnmByVJDr7vQMQ==
X-Received: by 2002:a05:600c:470c:b0:42c:b52b:4335 with SMTP id 5b1f17b1804b1-42cb52b4671mr36819665e9.10.1725888283464;
        Mon, 09 Sep 2024 06:24:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7wPSiSQaKkIioo/IjBCYves7XYbxdDqrPjlqHWw+mhwaLjI1mnzfbJTf9KmISlVSpPIMo/A==
X-Received: by 2002:a05:600c:470c:b0:42c:b52b:4335 with SMTP id 5b1f17b1804b1-42cb52b4671mr36819415e9.10.1725888282948;
        Mon, 09 Sep 2024 06:24:42 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956653f9sm6041288f8f.31.2024.09.09.06.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 06:24:42 -0700 (PDT)
Message-ID: <c1d420ba-13de-48dd-abee-473988172d07@redhat.com>
Date: Mon, 9 Sep 2024 15:24:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support
 self-snoop
To: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
References: <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com> <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com> <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com> <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
 <ZthPzFnEsjvwDcH+@yzhao56-desk.sh.intel.com> <Ztj-IiEwL3hlRug2@google.com>
 <Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com>
 <Zt6H21nzCjr6wipM@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zt6H21nzCjr6wipM@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 07:30, Yan Zhao wrote:
> On Thu, Sep 05, 2024 at 05:43:17PM +0800, Yan Zhao wrote:
>> On Wed, Sep 04, 2024 at 05:41:06PM -0700, Sean Christopherson wrote:
>>> On Wed, Sep 04, 2024, Yan Zhao wrote:
>>>> On Wed, Sep 04, 2024 at 10:28:02AM +0800, Yan Zhao wrote:
>>>>> On Tue, Sep 03, 2024 at 06:20:27PM +0200, Vitaly Kuznetsov wrote:
>>>>>> Sean Christopherson <seanjc@google.com> writes:
>>>>>>
>>>>>>> On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
>>>>>>>> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
>>>>>>>> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
>>>>>>>> Silver 4410Y".
>>>>>>>
>>>>>>> Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
>>>>>>> on another hardware issue?
>>>>>>
>>>>>> Very possible, as according to Yan Zhao this doesn't reproduce on at
>>>>>> least "Coffee Lake-S". Let me try to grab some random hardware around
>>>>>> and I'll be back with my observations.
>>>>>
>>>>> Update some new findings from my side:
>>>>>
>>>>> BAR 0 of bochs VGA (fb_map) is used for frame buffer, covering phys range
>>>>> from 0xfd000000 to 0xfe000000.
>>>>>
>>>>> On "Sapphire Rapids XCC":
>>>>>
>>>>> 1. If KVM forces this fb_map range to be WC+IPAT, installer/gdm can launch
>>>>>     correctly.
>>>>>     i.e.
>>>>>     if (gfn >= 0xfd000 && gfn < 0xfe000) {
>>>>>     	return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>>>>>     }
>>>>>     return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
>>>>>
>>>>> 2. If KVM forces this fb_map range to be UC+IPAT, installer failes to show / gdm
>>>>>     restarts endlessly. (though on Coffee Lake-S, installer/gdm can launch
>>>>>     correctly in this case).
>>>>>
>>>>> 3. On starting GDM, ttm_kmap_iter_linear_io_init() in guest is called to set
>>>>>     this fb_map range as WC, with
>>>>>     iosys_map_set_vaddr_iomem(&iter_io->dmap, ioremap_wc(mem->bus.offset, mem->size));
>>>>>
>>>>>     However, during bochs_pci_probe()-->bochs_load()-->bochs_hw_init(), pfns for
>>>>>     this fb_map has been reserved as uc- by ioremap().
>>>>>     Then, the ioremap_wc() during starting GDM will only map guest PAT with UC-.
>>>>>
>>>>>     So, with KVM setting WB (no IPAT) to this fb_map range, the effective
>>>>>     memory type is UC- and installer/gdm restarts endlessly.
>>>>>
>>>>> 4. If KVM sets WB (no IPAT) to this fb_map range, and changes guest bochs driver
>>>>>     to call ioremap_wc() instead in bochs_hw_init(), gdm can launch correctly.
>>>>>     (didn't verify the installer's case as I can't update the driver in that case).
>>>>>
>>>>>     The reason is that the ioremap_wc() called during starting GDM will no longer
>>>>>     meet conflict and can map guest PAT as WC.
>>>
>>> Huh.  The upside of this is that it sounds like there's nothing broken with WC
>>> or self-snoop.
>> Considering a different perspective, the fb_map range is used as frame buffer
>> (vram), with the guest writing to this range and the host reading from it.
>> If the issue were related to self-snooping, we would expect the VNC window to
>> display distorted data. However, the observed behavior is that the GDM window
>> shows up correctly for a sec and restarts over and over.
>>
>> So, do you think we can simply fix this issue by calling ioremap_wc() for the
>> frame buffer/vram range in bochs driver, as is commonly done in other gpu
>> drivers?
>>
>> --- a/drivers/gpu/drm/tiny/bochs.c
>> +++ b/drivers/gpu/drm/tiny/bochs.c
>> @@ -261,7 +261,9 @@ static int bochs_hw_init(struct drm_device *dev)
>>          if (pci_request_region(pdev, 0, "bochs-drm") != 0)
>>                  DRM_WARN("Cannot request framebuffer, boot fb still active?\n");
>>
>> -       bochs->fb_map = ioremap(addr, size);
>> +       bochs->fb_map = ioremap_wc(addr, size);
>>          if (bochs->fb_map == NULL) {
>>                  DRM_ERROR("Cannot map framebuffer\n");
>>                  return -ENOMEM;

While this is a fix for future kernels, it doesn't change the result for 
VMs already in existence.

I don't think there's an alternative to putting this behind a quirk.

Paolo


