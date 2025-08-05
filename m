Return-Path: <kvm+bounces-54023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 601EDB1B6C4
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5F9718863B7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC06A279324;
	Tue,  5 Aug 2025 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eTjcjgjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D902777E5;
	Tue,  5 Aug 2025 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404873; cv=none; b=VDxTPGkoJVVyfkug35UTLqYm/s/fScnYbt6uONqiNb0RmU7WAFDE8Xt0m4OhW3+LvvMglowaveQPXKAbhpPoEA73Bahtxo82cASPenqxWx1enUGmNcIjIkGSYlaAxhgqNbX+PErC1nurzBDs6GubidXJVFtK1Kc90Ge/nUvgB/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404873; c=relaxed/simple;
	bh=sgnGJUlVKJPFBRwW0xHy5krBGxDNDIg8z4YcRoTgpZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qb0mjE9dioY/GkUVZ6enIVARVwDuAD8ISFjyx9ENnd91cHwMV0wlvyMo4yq2j3aq9huEjDdLoAjs8Z14ZVi4eLcZcZAAmAdJSATKkniZvy8M+74q6LsaP7mP7jDmyXmxjJr8EM7uCrv4IziuWb73qb4qKMX6GgCWQa3S+oivCtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eTjcjgjV; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-459d7726ee6so16398075e9.2;
        Tue, 05 Aug 2025 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404869; x=1755009669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H+xd2a0eqDbR0whEvw2TqimTj8VyebTrqGrWBXALaro=;
        b=eTjcjgjVTh5vpYKBTnPu2BL/tf3aJJTq18SfDrjr/BkkXG1oCmdhRsMdqTZF4YB3HS
         ZCZN+bLcouONuLvY13Xxf/yH9gAK2XrKevlWZUEhYJnsVYYnjEluGp1CkB1L8zs7mCpr
         osJqe/tFOXcDFIHiSApP6WAS4Mi5ek82FlHaeJRdfvtE7AkSVLsu+0w8mThOqZ4bd1bA
         zbM0DJvGRkmv4bLXwpCtzy1fAxjxtHypklK1l5R7IHu3nKUkIJKKA42gBfBOi3Xzo8IG
         n0O/znsRyWgL4+Td9anCC/IreePyLq5GLDeWNcTdvFN4+JaMR3OKTcrY0CoxKh8jWgOw
         w9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404869; x=1755009669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+xd2a0eqDbR0whEvw2TqimTj8VyebTrqGrWBXALaro=;
        b=QawcuIpJlI6oJBhr9CuL/cydAtkwEQOrCNVUnULn/wCbZ4wnp0z5HUvaCAwCby/BEk
         3SEVZElPa38y0tYPq/CnFFfFphJ7X9DKuY/lg2Wz6Sd9FfEK/IkkpC9K88nlP+lPYrHx
         VUfy/bE+VFg0Pg9UJd1sDvRFVIavwN2de6QhVaLeVBq581klcDapbJF17RT6ELvQLw1P
         WFv3YvsKU8ZZtT4pwYFbrrrhPmers/Hqo0r5Z6Ny+2whTItllU0ZjrowHxFQKwhPnKLm
         jGmFt9yQVxU+kv+xMT+mSrDvL5ojM+2lSoiqCaWAaszFYJjXMZ5JVOEOSF3I7V7Jj0Ds
         JcGA==
X-Forwarded-Encrypted: i=1; AJvYcCUKV34+I3PD9LJb+zEqUV8i9ZBkvHSmgSqCb1yOYBTaYNLqrZnYNHrwH5sVPi7V4sn9XKrfboW0fjhX@vger.kernel.org, AJvYcCVPXNrHd/YOyCxe4M8HbApDg4oOYoPsTUdXDTi36cDhdn7Wn/kuurpupUqcvOSvCwtXVkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6O1tfmJpt6vK/9BHfJ1EN/dVGXnImLdOtSu1P//1xbVEZJJ6+
	jXR6H+TkPqBqkIgx7SGrYBnRUCMnmNmV/Qi5of114d+ABlNnr5A+68yQ
X-Gm-Gg: ASbGncuP73ulWLVRzJxh+PQZ8a3JOWuCdbjr3FYlGIywlwQo6t6gy1ecgBnEHgWDprd
	BZadOBYPuwNqae3Fv9egRo+0kyxN4k2tYkoZNQHmST4J+4ft0PdnWHiS/5rrDg0bqQcr0vEjbmQ
	4f93kwCh5Dwz+8vhY+eBYucgwflptL4nOW0lN6+g9vbwU/ppGP8JsRU3bYiUhJKcTXqWzWW//0z
	H287ui1LquyMFmhDKrAxkrjMu/XHgdFDJA/6mkXm7Ro/kWxa4SpOolFlm2W/f9+cZIXUkeeyxAv
	HmmyVTAgBbUWh55pxOrpFzdwBKrGL9F+4cvyk4mWDWGQtfdhiwP2UinG2ZjVVkgqa3yhPTh7c5L
	AyH5LxqeWCyoDP3hXUHQADRAMxEgfmPEGNqBx/00q3KfFnj9Igogs2PILcYm/to8YAHtubmpjGQ
	muqeR2LXU6+TXM1NWTfvFtbzH5vqxvMMewtJdqUDA+
X-Google-Smtp-Source: AGHT+IHvIjGHMJgZMlvbuLWImAEUDwhazDk3L40EIHxWJUmFdZGc2fOUxfMf8D9qX8KyVo9aYJdwfQ==
X-Received: by 2002:a05:600c:354e:b0:456:fdd:6030 with SMTP id 5b1f17b1804b1-458b6b307f4mr111648985e9.19.1754404869317;
        Tue, 05 Aug 2025 07:41:09 -0700 (PDT)
Received: from [26.26.26.1] (ec2-52-29-20-83.eu-central-1.compute.amazonaws.com. [52.29.20.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac574sm19459910f8f.5.2025.08.05.07.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:41:08 -0700 (PDT)
Message-ID: <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
Date: Tue, 5 Aug 2025 22:41:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250805123555.GI184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/5/2025 8:35 PM, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 11:43:29AM +0800, Ethan Zhao wrote:
>>
>>
>> On 8/2/2025 11:18 PM, Jason Gunthorpe wrote:
>>> On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
>>>>
>>>>
>>>> On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
>>>>> The series patches have extensive descriptions as to the problem and
>>>>> solution, but in short the ACS flags are not analyzed according to the
>>>>> spec to form the iommu_groups that VFIO is expecting for security.
>>>>>
>>>>> ACS is an egress control only. For a path the ACS flags on each hop only
>>>>> effect what other devices the TLP is allowed to reach. It does not prevent
>>>>> other devices from reaching into this path.
>>>
>>>> Perhaps I was a little confused here, the egress control vector on the
>>>
>>> Linux does not support egress control vector. Enabling that is a
>>> different project and we would indeed need to introduce different
>>> logic.
>> My understanding, iommu has no logic yet to handle the egress control
>> vector configuration case,
> 
> We don't support it at all. If some FW leaves it configured then it
> will work at the PCI level but Linux has no awarness of what it is
> doing.
> 
> Arguably Linux should disable it on boot, but we don't..
linux tool like setpci could access PCIe configuration raw data, so
does to the ACS control bits. that is boring.>
>> The static groups were created according to
>> FW DRDB tables,
> 
> ?? iommu_groups have nothing to do with FW tables.
Sorry, typo, ACPI drhd table.

Thanks,
Ethan>
>> also not the case handled by notifiers for Hot-plug events
>> (BUS_NOTIFY_ADD_DEVICE etc).
> 
> This is handled.
> 
> Jason


