Return-Path: <kvm+bounces-37230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC29A2728E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 869EE1884766
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BC3211A3E;
	Tue,  4 Feb 2025 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQBBbAwG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50320AF77
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738673714; cv=none; b=dQwMM36/wCLURepDXmA0wnLirBZTW3XCqN+ZFb9/H4EV7SXahPyGWZWaioO7w5JHhaStmGEYxGR5at+U5P8/RcnJ//s9xzgVR9c3vUX2KL6Ezj3H9w79W8FIcsjSsKijN2z2YsJo+zXdb+y5kQdLuKx39JtmgLv2pt4zPBNoxdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738673714; c=relaxed/simple;
	bh=zGL9epENRNO7rvIHohYlhRMg7cx1KKq80o7dktun6zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QnR52HHaY5A201BoN32EVGRg6eIbgQerj+yvYaXaG+NDNAKsSyxi6ZuADCduEsOPD7xgiitdFd2HnYOnrLdm7fffKnOLGZhOZEZ9JW1x0Bk+sd5db44TJjXOH1ULj7rEJe6j0pqjMV54e5u3BgWEq2QIchSisuGUXgqry/emig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQBBbAwG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738673711;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twPDg30fIiJNLDt2SiVRKkvqJ/64dc+oeH98LcXpjks=;
	b=gQBBbAwGK3Lrsik53QJyxNdghbg2qd0FnEv4Hc/NKVxC6zGCoTMc/aHJghETMFJenA7kCk
	GSwLku7xc+8fKKKZESb3teec9WPtvqCTSO+CaI3fv5PVRd/7RUhn0P8KZnjcUIqAFEuFks
	xy6v2syZSk9rdaXDlDbeqrciXbDDmvE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-HZHR7WHhOJuMG5k9_5wVLA-1; Tue, 04 Feb 2025 07:55:10 -0500
X-MC-Unique: HZHR7WHhOJuMG5k9_5wVLA-1
X-Mimecast-MFC-AGG-ID: HZHR7WHhOJuMG5k9_5wVLA
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6dd43b16631so63538636d6.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 04:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738673709; x=1739278509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twPDg30fIiJNLDt2SiVRKkvqJ/64dc+oeH98LcXpjks=;
        b=mHafBcH0wCGDSug9SNYEh4mx42pH/k2Y6u+EbyR6Uc9yrbYd9hH6Ab9MWSIQ+nURgt
         ewIiVCQFkz0vOitzSpb/poaZyz88sYHAVI6ngCWzCfNBTJMk7jEt3GA6DT6EANtpZM1L
         c6vlsKPOQVNs5yeo05eapSbaf8umawi/8ZLBEWrUassF3RfaDCV4Ut+r//YW1N9oHPC8
         r6HAL1kVfwiPOKYer5e4x9pAre776PwjVcGQy++g9a73rXqnmM5D1/E3bClPH04Jrp0l
         1d4mVp1qX7urYlt3d9qSLYgpwVZyqWTdzNXZFkeHrygehesWeIKKscadBGPS7j5z2M5G
         HqKg==
X-Forwarded-Encrypted: i=1; AJvYcCVpY9LcdipA7U4DUAiG4+qu8ZtfRGcdsoFhs9zlwHZcOLx+T93EIeFlPKxAz7OO2gToARU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwngNgR+5qB14rvoNPIx06/pNUosQRnyiUOYlQathp6sDaJDjdp
	kHLWyiZ7MSqck//CBmO37rodLgnVtA+7iaWMEi0jg+FNsit5IXBZEyE69jYw3lgP0t8JcxW2fFQ
	6YgGXCoUD4AQCeZEH7ia4K8VrjnsolrhXq3Ni3GNSYz7boSle7Q==
X-Gm-Gg: ASbGncujQep3w5xRpih0741YyP/KUeuxlvWiDbhOqYn4w4A1YyBWPICyssl26wHAhVP
	4JWR7RXD26G968sCLjA9+agGl4r4dM9rCV3LtH05Vln4iWcTYMMjdHnI8NRtYZRzHZ4PobwFBFQ
	Q0MPhimpS4zZxANAaUw+TlIQPEcGYSG84zW3gdZlQi/bVsk5hEzCYqGdddIi6DlIHzIaczDC5HU
	4Z8xCXbeHYkqAIfX57T/9fgeIwQQ+f/dU9pJ+RnrcR3T3QpnfzS2O24HXwlfYRDqBiGnSuPhgYg
	Te2GQ1Qp+Qg7Kmi0jqMg8a2/iGzl/3GxbzDkv4rtHkf42SyW96z+
X-Received: by 2002:a05:6214:1c0b:b0:6d9:2e46:dc35 with SMTP id 6a1803df08f44-6e243bf84c3mr422214626d6.25.1738673709617;
        Tue, 04 Feb 2025 04:55:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1a38N2TZdISEECvq/s7iOToAmmfm3GmVQAMYB+u0Kmi1Pw+6Ta7PfZF01eEC876vzaXAEXA==
X-Received: by 2002:a05:6214:1c0b:b0:6d9:2e46:dc35 with SMTP id 6a1803df08f44-6e243bf84c3mr422214216d6.25.1738673709310;
        Tue, 04 Feb 2025 04:55:09 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e254814029sm61998046d6.29.2025.02.04.04.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 04:55:08 -0800 (PST)
Message-ID: <cb087202-3a64-428c-bba2-196a3612e5ff@redhat.com>
Date: Tue, 4 Feb 2025 13:55:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 00/13] iommu: Add MSI mapping support with nested
 SMMU
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Nicolin Chen <nicolinc@nvidia.com>, "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "maz@kernel.org"
 <maz@kernel.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "shuah@kernel.org" <shuah@kernel.org>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 "yebin (H)" <yebin10@huawei.com>,
 "apatel@ventanamicro.com" <apatel@ventanamicro.com>,
 "shivamurthy.shastri@linutronix.de" <shivamurthy.shastri@linutronix.de>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "anna-maria@linutronix.de" <anna-maria@linutronix.de>,
 "yury.norov@gmail.com" <yury.norov@gmail.com>,
 "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "mdf@kernel.org" <mdf@kernel.org>, "mshavit@google.com"
 <mshavit@google.com>, "smostafa@google.com" <smostafa@google.com>,
 "ddutile@redhat.com" <ddutile@redhat.com>
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <4946ea266bdc4b1e8796dee1b228bd8f@huawei.com>
 <20250123132432.GJ5556@nvidia.com>
 <de6b9dc1-dedd-4a3d-9db7-cb4b8e281697@redhat.com>
 <20250129150454.GH5556@nvidia.com>
 <8e4c21b5-3b79-4f0b-b920-59b825c2fb81@redhat.com>
 <20250129201307.GJ5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129201307.GJ5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,


On 1/29/25 9:13 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 06:46:20PM +0100, Eric Auger wrote:
>>>>> This missing peice is cleaning up the ITS mapping to allow for
>>>>> multiple ITS pages. I've imagined that kvm would someone give iommufd
>>>>> a FD that holds the specific ITS pages instead of the
>>>>> IOMMU_OPTION_SW_MSI_START/SIZE flow.
>>>> That's what I don't get: at the moment you only pass the gIOVA. With
>>>> technique 2, how can you build the nested mapping, ie.
>>>>
>>>>          S1           S2
>>>> gIOVA    ->    gDB    ->    hDB
>>>>
>>>> without passing the full gIOVA/gDB S1 mapping to the host?
>>> The nested S2 mapping is already setup before the VM boots:
>>>
>>>  - The VMM puts the ITS page (hDB) into the S2 at a fixed address (gDB)
>> Ah OK. Your gDB has nothing to do with the actual S1 guest gDB,
>> right?
> I'm not totally sure what you mean by gDB? The above diagram suggests
> it is the ITS page address in the S2? Ie the guest physical address of
> the ITS.
Yes this is what I meant, ie. the guest ITS doorbell GPA
>
> Within the VM, when it goes to call iommu_dma_prepare_msi(), it will
> provide the gDB adress as the phys_addr_t msi_addr.
>
> This happens because the GIC driver will have been informed of the ITS
> page at the gDB address, and it will use
> iommu_dma_prepare_msi(). Exactly the same as bare metal.

understood this is the standard MSI binding scheme.
>
>> It is computed in iommufd_sw_msi_get_map() from the sw_msi_start pool.
>> Is that correct?
> Yes, for a single ITS page it will reliably be put at sw_msi_start.
> Since the VMM can provide sw_msi_start through the OPTION, the VMM can
> place the ITS page where it wants and then program the ACPI to tell
> the VM to call iommu_dma_prepare_msi(). (don't use this flow, it
> doesn't work for multi ITS, for testing only)
OK so you need to set host sw_msi_start to the guest doorbell GPA which
is currently set, in qemu, at
GITS_TRANSLATER 0x08080000 + 0x10000

In my original integration, I passed pairs of S1 gIOVA/gDB used by the
guest and this gDB was directly reused for mapping hDB.

I think I get it now.

Eric
>
>> https://lore.kernel.org/all/20210411111228.14386-9-eric.auger@redhat.com/
>> I was passing both the gIOVA and the "true" gDB Eric
> If I understand this right, it still had the hypervisor dynamically
> setting up the S2, here it is pre-set and static?
>
> Jason
>


