Return-Path: <kvm+bounces-36884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C92A2234F
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED2371886A67
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04D21E0DD9;
	Wed, 29 Jan 2025 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cnDv9gis"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2271E19066B
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172790; cv=none; b=mJtKSGJWVDRlDSVhBDP5D7hE4vmzco1TZ5PPfgKiOUe6x7QWPhb+wRagoeFeSUuBpXRWfohlZOtwLnxG+FpjkKRdbp+T67MCvk0j0TcAkuCtTaJ0tVVPkUjRJ4yBAdAm52ujlLezs/zt36FERGuJ3uATbHMc8E1CIkpTXycbpdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172790; c=relaxed/simple;
	bh=GVBVPQXK+YOVlYYHwZtT5FW5o6eoUI4q99NTvpI44+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/P0MMF4GjZYbX87S58KI9PMflQuqHx7TLN8l+rsHrnR7ucOOZCo1Kjvh54sYUeKpJy63HaLO8f6mkkKfb20ma4nqXBpEOcQoka/nfJTrug4af1mqo97kxjy9+QIO2w+thH1JYSY1ij6pzIdGof4EWGbYCRuJ64DGL3F4QnW9rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cnDv9gis; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738172788;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7C39AcP479z7PaOLmWGBMx2cDdXkmF+MZl53H1pFh10=;
	b=cnDv9gis7KChwlEq7tACnjBMcuShun73QtuYhz2ZIBdgSkhPx5nbnM/kdPIG3Xlvoatn4n
	kDbKk2Zd0HtdcwC/CMPdIIAcqVTN832OiaL2S00pN9b+4rxyL+VB/+QmFpaFpbxvxQMShg
	2W9/6wNYCt3bHKNptCh8vfeKdfsM3t4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-L4B5QqTiMzaqdX-3cw1e3Q-1; Wed, 29 Jan 2025 12:46:26 -0500
X-MC-Unique: L4B5QqTiMzaqdX-3cw1e3Q-1
X-Mimecast-MFC-AGG-ID: L4B5QqTiMzaqdX-3cw1e3Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4388eee7073so4865425e9.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172785; x=1738777585;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7C39AcP479z7PaOLmWGBMx2cDdXkmF+MZl53H1pFh10=;
        b=Ew7PoEHYP1DNSQGcQoRc68/td+RVRv/8estjnIE4HyW6YhX6QHziLk6grbGWB6ldCV
         ZMRMFrLQBNdRRlaFpLjSLMdXfvwlrS9fQ/UjPNww1plIkrNR1i+WftVpQTCSIhGMR+iJ
         7yRHJiAYywpfXd+pagWE2FGQqd+v0/ZghsW2SRTuaBysU90PWPHkifGPbyPlM7Ng2Nt1
         lBhOYG9P99avBRTn0cJN4gE/MCdmxvaaEy2O94FGRDGty5gAYAG7wltEViwy/f7mPjhI
         lKyOwDuP79mChe/SMzQwTRuiETXl0JppaTYacfa54lwm+277zHUvgxOdRoXF2F8Y6ZLn
         NpTA==
X-Forwarded-Encrypted: i=1; AJvYcCXJlik5EYX5mqHyMijSezm+pOYOtyMnHJKnR0pD2D6Z3o9zgUUJRwsWpN8vtervQrw9vBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyKvwr3nUOqN9iyv65rxtB6CXMpJKG4dRnnmnyOzna+Jt4V9DK
	b/jQv6dOyvHr+VBACgAR8C+hqMIELwf7N7WXpd/zCCLANayDQcIpnf04zaAMkiYYbd9wIvBUKQ6
	6Id/RpwIo2YbN/sUPpkrlNA1ixILwdn4XLG3s5oWZxmoYHO3YJQ==
X-Gm-Gg: ASbGnctbZIs/e7cd+NL3k3uW6svbkdKoIwcNkehFbLnYnnG9aOuEvJI6BxVk3vj69F4
	QlCZqW6tNvhd6Hws896NUIk5O1YmbydtiudmV7kn4ktIn2f1NbTMFS0vL51/66oJLWkTZyENaub
	FDqCNL1i5Ej7A2qNjPda0kKtYTRn/6Z+jvr6n+T+WmDj1zrbQhJ46+dt6WeXgZ37GJ8iKM8xTe2
	wCJsWTWjkR+7Hv5gMmoligBFzTixDTqPI1c+pLykmtbb5aRwiy8zn0K7V088YmeQUgxRYc4y2Ml
	Nj9TFSsf4uOEUn1OCqnGDE0+Fw2QcEKWtoOI4piGVX0y9PMC13i2
X-Received: by 2002:a05:600c:6555:b0:436:fdac:26eb with SMTP id 5b1f17b1804b1-438e15e7fdamr1934675e9.7.1738172785106;
        Wed, 29 Jan 2025 09:46:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQmQmuNWdwXKR1WA8YUMR0neWSl2UDPcJoTIpWOkS9ogRoZv55tiuXIIRNpwuKJUpW+TAzXQ==
X-Received: by 2002:a05:600c:6555:b0:436:fdac:26eb with SMTP id 5b1f17b1804b1-438e15e7fdamr1934415e9.7.1738172784724;
        Wed, 29 Jan 2025 09:46:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc13151sm30025435e9.1.2025.01.29.09.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:46:22 -0800 (PST)
Message-ID: <8e4c21b5-3b79-4f0b-b920-59b825c2fb81@redhat.com>
Date: Wed, 29 Jan 2025 18:46:20 +0100
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
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129150454.GH5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 1/29/25 4:04 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 03:54:48PM +0100, Eric Auger wrote:
>>>> or you are just mentioning it here because
>>>> it is still possible to make use of that. I think from previous discussions the
>>>> argument was to adopt a more dedicated MSI pass-through model which I
>>>> think is  approach-2 here.  
>>> The basic flow of the pass through model is shown in the last two
>>> patches, it is not fully complete but is testable. It assumes a single
>>> ITS page. The VM would use IOMMU_OPTION_SW_MSI_START/SIZE to put the
>>> ITS page at the correct S2 location and then describe it in the ACPI
>>> as an ITS page not a RMR.
>> This is a nice to have feature but not mandated in the first place,
>> is it?
> Not mandated. It just sort of happens because of the design. IMHO
> nothing should use it because there is no way for userspace to
> discover how many ITS pages there may be.
>
>>> This missing peice is cleaning up the ITS mapping to allow for
>>> multiple ITS pages. I've imagined that kvm would someone give iommufd
>>> a FD that holds the specific ITS pages instead of the
>>> IOMMU_OPTION_SW_MSI_START/SIZE flow.
>> That's what I don't get: at the moment you only pass the gIOVA. With
>> technique 2, how can you build the nested mapping, ie.
>>
>>          S1           S2
>> gIOVA    ->    gDB    ->    hDB
>>
>> without passing the full gIOVA/gDB S1 mapping to the host?
> The nested S2 mapping is already setup before the VM boots:
>
>  - The VMM puts the ITS page (hDB) into the S2 at a fixed address (gDB)
Ah OK. Your gDB has nothing to do with the actual S1 guest gDB, right?
It is computed in iommufd_sw_msi_get_map() from the sw_msi_start pool.
Is that correct? In
https://lore.kernel.org/all/20210411111228.14386-9-eric.auger@redhat.com/
I was passing both the gIOVA and the "true" gDB Eric
>  - The ACPI tells the VM that the GIC has an ITS page at the S2's
>    address (hDB)
>  - The VM sets up its S1 with a gIOVA that points to the S2's ITS 
>    page (gDB). The S2 already has gDB -> hDB.
>  - The VMM traps the gIOVA write to the MSI-X table. Both the S1 and
>    S2 are populated at this moment.
>
> If you have multiple ITS pages then the ACPI has to tell the guest GIC
> about them, what their gDB address is, and what devices use which ITS.
>
> Jason
>


