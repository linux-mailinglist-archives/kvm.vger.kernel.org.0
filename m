Return-Path: <kvm+bounces-52835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF75B099CD
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D37781C437BE
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B216D1B4257;
	Fri, 18 Jul 2025 02:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIhBC2Tw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF71A2C27
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 02:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752805909; cv=none; b=R9FFyeMjROFeTdpjP5kgBpvGdzZIetrHrri+0GH6hVfvWV2xPwy1cG6Q/IMrHKCEp9hkKimAg1vWY/tmkfhOuG65JIBPC5FenhAsIbJAAVfORVyJFr/OIulQr24SIaI8yrKCzDbR464ir/Ql8OqmUpbkR787DwWxxW/a6j/QhP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752805909; c=relaxed/simple;
	bh=GKHMgIQjLp7KXkce3TSNrNDc4cs1kxoWV9ktElkfly4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1cAgSECgZzCqi4BwiyWSuw32AQRkpL3o7N4ofC9ZNldHb3YCh/262E/PwgHx05J1V2PqGTmKQ1ZeEkVtQhM3EuLYPWDk1UjtmYmM+LWapfpWkhQ27qLBeu2xPeMYapl0g09TVOsPC6TpQOCxsJVfAJw4xXHNKJcIAF45G+aQfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIhBC2Tw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752805907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaZLU4GKhmRux2+I10jXp65n20V7jWRI51gsD8E69t4=;
	b=IIhBC2TwE9NEpiz/EUaWv0haXUZ7vPC42a6GZVylvqnn84jKu4zrqz7xxvfrvy2KX6UIaw
	LaHiMT+e5gSSnLKn6QRAM7gkoGZ+aWtzat6aWTOjpfq04qJhzzBX0i4ILAtgHtzJGaP/fP
	LgAHdfNM4IvmHy2euzpnEAK95IZwk5s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-wp5F8llUMxCphrP7nDAeSg-1; Thu, 17 Jul 2025 22:31:45 -0400
X-MC-Unique: wp5F8llUMxCphrP7nDAeSg-1
X-Mimecast-MFC-AGG-ID: wp5F8llUMxCphrP7nDAeSg_1752805905
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7da0850c9e5so248571485a.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 19:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752805905; x=1753410705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaZLU4GKhmRux2+I10jXp65n20V7jWRI51gsD8E69t4=;
        b=STFvoGf3pGsj+00+OwUKkOY4MZtIkuc8jSr+3vvQGCMSGJ+mSExuDPn0aK8fyd4y72
         vkrZ70+jw9VMXPnUS93jRcdhtCoxsQbhuSWbQI02rvDmYg3+yxH6A85iXRYGBGFI7AOu
         sGYzWYKsGidtwVndgpUUEkQfpYCU/lzmfR/jv/845IghTNYSbNuHYm/GXB4UiZgxHNKN
         gabjGuYy6iWgCUbH94+gtfoZB+4u5iainBKbF0AYQ1IYwC58VGCzKp3cNKcNDlarpbah
         lTD8aR6JdTyTZ0alFyuK1Z9pCZXRj430ChoXV3RRMOv37pTMEQXBX1+de1DCih81pP8v
         EVOg==
X-Forwarded-Encrypted: i=1; AJvYcCXyOttGw0BVhLrrmUob4LzlOrmh7HLpQoqwqT5LIZATCzOzBHDtVlWSwzQPgC88Yrkiutk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN8EDDlfvylmtjEA8H9CyhshiG9Jq2XXF4iFXKQ6k8v2HiobKP
	tfK7H+Xa6xMOjo0H5etZGwtLQfibARjIu8ddw2A3dnf/384Fwi4a/i+FM7VpfoptHzPpUfpAtJe
	LGVuiBG6h4NhznUKTbo+RB2iXA6pBdcT0q13gWwDzH/B3uUF0f5E/sw==
X-Gm-Gg: ASbGncsi3ytSjMVeEDaUlDGbEAvma4T5gktIjSj6RjFGJQygyLcVYIGqtkKvp29qHs6
	MX/ZQvN1oLlaDUopDM15KFLB2FfX5AtFm2PTVHcD536ABvoq8XM+NeaHKLZDo7pTwLNCqQInKgY
	0roiOUpGl9ppDL0TUHFl5DkxPstYG4srv+7cb25JVCLMkdMnV2mupq12ELcNMDbHbKf1+9VCj9s
	rNEXAxJEITHAz+6zf8b3HcsC+hDvkCKMEuMnLPl91y9dL3tu7JJzGDws9qX7HJ+tm+jHnUk42tv
	rdFAVP/LlJszANk+BZMi7ZoLa9+7tL7qykMFhdea
X-Received: by 2002:a05:620a:6007:b0:7d4:3bcc:85bf with SMTP id af79cd13be357-7e342a5eda7mr1167332185a.12.1752805904766;
        Thu, 17 Jul 2025 19:31:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ7WNmhYxeTKTnJvjyZYFdY4Uy7qNdAA+omyn3onwql37C/+HhiaajQ3N5wll13LWDMCOCqQ==
X-Received: by 2002:a05:620a:6007:b0:7d4:3bcc:85bf with SMTP id af79cd13be357-7e342a5eda7mr1167330085a.12.1752805904357;
        Thu, 17 Jul 2025 19:31:44 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e356c9155csm34859285a.95.2025.07.17.19.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 19:31:43 -0700 (PDT)
Message-ID: <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
Date: Thu, 17 Jul 2025 22:31:42 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250717202744.GA2250220@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/17/25 4:27 PM, Jason Gunthorpe wrote:
> On Thu, Jul 17, 2025 at 03:25:35PM -0400, Donald Dutile wrote:
>>> What does a multi-function root port with different ACS flags even
>>> mean and how should we treat it? I had in mind that the first root
>>> port is the TA and immediately goes the IOMMU.
>>>
>> I'm looking for clarification what you are asking...
>>
>> when you say 'multi-function root port', do you mean an RP that is a function
>> in a MFD in an RC ?  other?  A more explicit (complex?) example be given to
>> clarify?
> 
> A PCIE Root port with a downstream bus that is part of a MFD.
> 
> Maybe like this imaginary thing:
> 
> 00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
> 00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
> 00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
> 00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
> 00:1f.5 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #17 (rev f1)
> 
>> IMO, the rule of MFD in an RC applies here, and that means the per-function ACS rules
>> for an MFD apply -- well, that's how I read section 6.12 (PCIe 7.0.-1.0-PUB).
>> This may mean checking ACS P2P Egress Control.  Table 6-11 may help wrt Egress control bits & RPs & Fcns.
> 
> The spec says "I donno"
> 
>   Implementation of ACS in RCiEPs is permitted but not required. It is
>   explicitly permitted that, within a single Root Complex, some RCiEPs
>   implement ACS and some do not. It is strongly recommended that Root
>   Complex implementations ensure that all accesses originating from
>   RCiEPs (PFs, VFs, and SDIs) without ACS support are first subjected to
>   processing by the Translation Agent (TA) in the Root Complex before
> 
> "strongly recommended" is not "required".
> 
A bridge (00:1f.5) is not an EndPt(RCiEP). Thus the above doesn't apply to it.
[A PF, VF or SDI can be a RCiEP -- 00:1f.3, 00:1f.2 ]

>> If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
>> the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
>> it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.
> 
> Where did you see this? Linux has never worked this way, we have
> extensive ACS quirks specifically because we've assumed no ACS cap
> means P2P is possible and not controllable.
> 
e.g., Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function Devices
  ...
  ACS P2P Request Redirect: must be implemented by Functions that support peer-to-peer traffic with other Functions.
                            ^^^^

It's been noted/stated/admitted that MFDs have not followed the ACS rules, and thus the quirks may/are needed.

Linux default code should not be opposite of the spec, i.e., if no ACS, then P2P is possible, thus all fcns are part of an IOMMU group.
The spec states that ACS support must be provided if p2p traffic with other functions is supported.


> Jason
> 


