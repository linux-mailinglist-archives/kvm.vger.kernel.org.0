Return-Path: <kvm+bounces-43346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68092A89CC2
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FF7E1885D96
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78299293B62;
	Tue, 15 Apr 2025 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CuF3JQhw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA7628E614
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744717360; cv=none; b=KcF0sFihYNpk23q57KjLQPZsuS0HfN5NsqJrwCEH+q6NgjZV0PGn9/lP9Tw7WUv5GSnOUIn4KJT/715Pr/XiY3rVnu5Y9G8sM4XtHCcvmIT15oBerMMa0dEyX29IIh4s6bWYwWp30M7071ETncUxSFSRb+4L0fdkjWIAW7ArMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744717360; c=relaxed/simple;
	bh=kGHt4Afde1omI4nmqg2jcNzajV+HMy/TkkjZtuU0bQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t03YrnHU041+rvc33zLLAVeaJ+rKd6k5GJuJTwvrXBnhpwljZY+Cr2p14VW6rCOsKKT4wIh+l6QKEiaPx9Rrz4bK2GcgP2Zqfk8+oOMkRHhaQuayOENA2AGFujxnwrKsQbIC1siEiHSs7kSWbEFzzoHTsBCVo9KBzgGIBt6CxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CuF3JQhw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744717357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=21sufny1Dz2xylrlxmH87I6QNpgSN7tCAQpjobld9eE=;
	b=CuF3JQhwMvIZo5BuobeuzPoS3NUudthjsSwytSvv7xNHR22X6ga0/n/+9UJTVa2CMFQByT
	iWgWfdaGt2Zs1k0wmWKZC0Y4ZcV19+/jbM0KzbgpTt4hBlBYvbdjWM4wwse7MWExeIX7BU
	72FDlOXpB492oMu0VYg08Xj0THj8j2Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-q2cU-62PO5uWfbvyf8geMA-1; Tue, 15 Apr 2025 07:42:36 -0400
X-MC-Unique: q2cU-62PO5uWfbvyf8geMA-1
X-Mimecast-MFC-AGG-ID: q2cU-62PO5uWfbvyf8geMA_1744717355
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39131f2bbe5so2056094f8f.3
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 04:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744717355; x=1745322155;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21sufny1Dz2xylrlxmH87I6QNpgSN7tCAQpjobld9eE=;
        b=R1MeJ/+jbRQJq11PSZM+YIQoKDPIevikWOIiG7j+qo3FvjqCh++UREirfxPNP7EgbA
         NvG/CkVnWJnTZRMK4l0oLQBGVLuaESK5oI0jqFcelWI/WJu3vaEn/YxyDEOOWpQbbZud
         bb4IkqoyxW5K5xdTUQOy1MI7MiPOMEYhzXMulq6mKisCPvdp8n6UpurfjeO1hNMmGa8m
         trJbQgv7soq0K7YIlhXZYQiA7s8uX0otj7/sUNKEEpbJCEmM0WsAC+L1ydG0ff3bbv8l
         X7Gletrw6cXmckZqMItmjCYYCvhOTC67C7zTmpv7pb0TnbMTGPxouopdKrB8aV5VRI9r
         FZ8w==
X-Forwarded-Encrypted: i=1; AJvYcCVSqbRpH3WwUtMAg077kXK2lG+jnntI+vidl34DWbJTZDHva+xTZvmHFRXOqVOQO6yEDCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCa3fC8LutevKnJE5UIuaI+SlNN/dUaQ3NrtEBazZmnP7SmYgG
	rffbRd5zLSi2fgkg0EnPqZajWH7qDfXRf7w7UhTvVEbjWE8t0r/ULVUP9VsMq9nNqjvEgVYTRjC
	Q70IHF0zlfgsxg+o1UCKKPxaLFdwKjTIYV9q01/BRFSXA0AHnQQ==
X-Gm-Gg: ASbGncuq/yNy7kES86Q9ROLG8qbDyveJvtD3Xc0g4DA0m1wp0boyk/DXHsEXoN/SsI/
	deAqMVtPJ+itVDQTn+ekYL2lzwuE2hfW4qFeYOsuCHNzOrUbXvCMBeaNHJ063DRJ5EJd/kBUWJ3
	ed/BilqSMdpMVI4UR3oH8p5ZQomijip1De/i5yI3U+oXpAkS8M/34slIGAMOdr+bXeQX49k2DGS
	RYJ6lmBJRgYR0Ehs45GSnQBDx9G/H0L4vwSB8dADWvVd1j31c57zRZhV4f88HbAZmaX1QSLPk1o
	O42UbYaZSC+2zw/o
X-Received: by 2002:a05:6000:430b:b0:39c:c64e:cf58 with SMTP id ffacd0b85a97d-39eaaed2d29mr12784966f8f.55.1744717355472;
        Tue, 15 Apr 2025 04:42:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOEK9OlZm2HlwrtOSS4aaebl8dVeZW7yEvXuCXhTSQfqaHyUlXVO19zQoEuFcqOOz4aNSlrw==
X-Received: by 2002:a05:6000:430b:b0:39c:c64e:cf58 with SMTP id ffacd0b85a97d-39eaaed2d29mr12784946f8f.55.1744717355136;
        Tue, 15 Apr 2025 04:42:35 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.109.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43f2338db88sm208832245e9.6.2025.04.15.04.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 04:42:34 -0700 (PDT)
Message-ID: <1b29eed0-fafc-427b-bd70-5dd087f2c0dd@redhat.com>
Date: Tue, 15 Apr 2025 13:42:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sean Christopherson <seanjc@google.com>,
 Sairaj Kodilkar <sarunkod@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack
 <dmatlack@google.com>, Naveen N Rao <naveen.rao@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com> <Z_ki0uZ9Rp3Fkrh1@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z_ki0uZ9Rp3Fkrh1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/25 16:10, Sean Christopherson wrote:
> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>> WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
>>> enabled, as KVM shouldn't try to enable posting when they're unsupported,
>>> and the IOMMU driver darn well should only advertise posting support when
>>> AMD_IOMMU_GUEST_IR_VAPIC() is true.
>>>
>>> Note, KVM consumes is_guest_mode only on success.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    drivers/iommu/amd/iommu.c | 13 +++----------
>>>    1 file changed, 3 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index b3a01b7757ee..4f69a37cf143 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>>>    	if (!dev_data || !dev_data->use_vapic)
>>>    		return -EINVAL;
>>> +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
>>> +		return -EINVAL;
>>> +
>>
>> Hi Sean,
>> 'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
>> interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
>> Hence you can remove this additional check.
> 
> Hmm, or move it above?  KVM should never call amd_ir_set_vcpu_affinity() if
> IRQ posting is unsupported, and that would make this consistent with the end
> behavior of amd_iommu_update_ga() and amd_iommu_{de,}activate_guest_mode().
> 
> 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
> 		return -EINVAL;
> 
> 	if (ir_data->iommu == NULL)
> 		return -EINVAL;
> 
> 	dev_data = search_dev_data(ir_data->iommu, irte_info->devid);
> 
> 	/* Note:
> 	 * This device has never been set up for guest mode.
> 	 * we should not modify the IRTE
> 	 */
> 	if (!dev_data || !dev_data->use_vapic)
> 		return -EINVAL;
> 
> I'd like to keep the WARN so that someone will notice if KVM screws up.

Makes sense, avic_pi_update_irte() returns way before it has the 
occasion to call irq_set_vcpu_affinity().

Paolo


