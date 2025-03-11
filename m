Return-Path: <kvm+bounces-40744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF86A5B9A6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F97F1893D3A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75B0221733;
	Tue, 11 Mar 2025 07:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F0Wwv1/a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329011F09AC
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741677661; cv=none; b=O07uT3zEbCTlIyOguPN++ttAgBAwU9PVGzJNwPBjSSyfPsE8m177eRybOTFBjIalr+rfyrrvLT1Kx6RXbJoOHmjldN9ru9mQcl30Q1SeihPtjXuXqV32UQuOnpdj+UQpZ8Y+ypZ8uc4cwtkhtuqNQk1uj18WIkRJHrJTVBuXRA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741677661; c=relaxed/simple;
	bh=2XDjW/lT5/K7/lHVG5SWmgyTF9YNNA4f0KbCLcs/BJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjoo4eCmPFYALfaDNiNl6QxsO0zDOrxT7z61LB5DStYGh1PM/n7i7Z04aFHqZ+W6Do4yrfxc0/RLjyGBu1OYztG+uyymqWORQ7s5boFtThzz7LGrem93JYbVTYCEOK32HIlEI6aZ2u4g21NHtK6ZH3P9MFrnNMtcFXXSriAlmVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F0Wwv1/a; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso20407875e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741677657; x=1742282457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4MRcosGk5JGw79qKqLYfP0CenMmA/FvXV8RIFTg3nM=;
        b=F0Wwv1/aNYx88/hPetW+9ezSH65/uTheZwnlX5HzRHqeOzOpEc96nEf+u3nTqLj1k/
         ewG5Mh2V0Q3ccgbq1Qr4CEhB4QV41zg+6fqNRLi7aXD4Tk3tiaP0YHaXl/QeOVHeUIwy
         VpzCYB6vxGeWOTYe1OIbmDxjaUncP77Qt3MyehbBCnFk6EiQG3VkTLmVQ6tlRhMKc0YH
         2HTCCCtpHYknxxFIejVaIiIocDrCwxu/+uIAT+q262aGb7tlOIRjHAo0ZzyI9ocYocXY
         qDOsYVwpZFRKs2RRG6gKjxBYKCPlZx64uHQZo77qxSBWGDN1gCrnYFwVO1nrosI9dwLX
         0PaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741677657; x=1742282457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4MRcosGk5JGw79qKqLYfP0CenMmA/FvXV8RIFTg3nM=;
        b=d1Afo5aoESPL9DQ1CoA3n5q1Jv6DEUSGK5+qTbm2Z56BOdo3GT/Ppa7Sz3ixdWEcXA
         AxuE7Va9x/oHCH1Fr4PdR50pvEyNMDy5003YQYcYIrpR4VZPZUUyhL6PeLdt1YF3xpni
         d+jFybWBYzZvNuAbFwFS74EzgZjmARQIxJpzAy50+cIMfQr/OT1+y0SBtgyRKuxIPPcL
         bs3Y6O/xv5pBqo8HRUnFWnCg4YqAg5r9GUq7Q73UQl8rJPAgv5OhaMs9LRUvcJAswPLs
         MkRJTGILDjnlIjiz/GBOTSElT36GOzo3J4z5VxSY/LR63v1y4yWK9BLa8eNfdZWl0qev
         cpUg==
X-Forwarded-Encrypted: i=1; AJvYcCX2HV8F+Pb6NW8HHCzeqPQjrujNtZHkz6TUUu/wPuSomGppCOQu3lfRodXiPnjceWhidYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLMpCYCDNFss4am43RrG0eDiT7MESKDLTpLmk/0o8qCOk9GVwr
	DVFxrJVaoHsfXb4APVHQZpo7HcEzuDACeNGKMkefgtLuFbLJdtY/iVjE90ScQe4=
X-Gm-Gg: ASbGnctXb4+eb21snVQoO0VJ3DrBka9zrDd/fwyAbGZHjixM3hZBBc02133jUgbXnCS
	0a8z6W9b3YBTnfFn2cCOV1BnzUt14Nej2Kh4+R87ykVZOZFWDJR+MGjRqqSAq5IhvZJ+wUyVg8+
	I8EIeVVFn+9pn7blXAhby8HWjtyUvKzf1Ht++q0L2CppYR3O1Oh3FHVbkRYv2Txg/jZt6xWk+lK
	BU8a6MWcFbIa2XtqjaneJxuevtvYe3DFIjao8gRevq5MUZMF0NwkAWdiEvO5rZGrLfmyJWZFJ5k
	LtklPrQ3FjkKnqfrSfvjJeg4t12hUSTbqSozh7jWvepeOFsBQxgrepJ9Ga0o3jPiMV4ErI30DbB
	eiE369vAol/O5Jmij0TvNOoQ=
X-Google-Smtp-Source: AGHT+IE33NbAzCSykM60RwAZcUfXCXv25nI93SsQFLsQX/Peru1MjtR010FE94Sh2y0PIickba5sYQ==
X-Received: by 2002:a05:600c:1c9d:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-43c549dcc0amr142489625e9.0.1741677657327;
        Tue, 11 Mar 2025 00:20:57 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d059354e2sm7678345e9.0.2025.03.11.00.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 00:20:56 -0700 (PDT)
Message-ID: <456ee79a-04e9-4b8d-8b04-843f97a55ee2@linaro.org>
Date: Tue, 11 Mar 2025 08:20:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin()
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-16-philmd@linaro.org>
 <SJ0PR11MB67449BEA0E3B4A04E603633C92D62@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <d883d194-3a68-4982-a408-d9ab889fd2c7@linaro.org>
 <SJ0PR11MB674427BA969DCC35B1FACBAF92D12@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <SJ0PR11MB674427BA969DCC35B1FACBAF92D12@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/3/25 02:54, Duan, Zhenzhong wrote:
> 
> 
>> -----Original Message-----
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: Re: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
>> using iommufd_builtin()
>>
>> On 10/3/25 05:11, Duan, Zhenzhong wrote:
>>> Hi Philippe,
>>>
>>>> -----Original Message-----
>>>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> Subject: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
>>>> using iommufd_builtin()
>>>>
>>>> Convert the compile time check on the CONFIG_IOMMUFD definition
>>>> by a runtime one by calling iommufd_builtin().
>>>>
>>>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> ---
>>>> hw/vfio/pci.c | 38 ++++++++++++++++++--------------------
>>>> 1 file changed, 18 insertions(+), 20 deletions(-)
>>
>>
>>>> static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
>>>> {
>>>> @@ -3433,9 +3430,10 @@ static void vfio_pci_dev_class_init(ObjectClass
>> *klass,
>>>> void *data)
>>>>
>>>>       device_class_set_legacy_reset(dc, vfio_pci_reset);
>>>>       device_class_set_props(dc, vfio_pci_dev_properties);
>>>> -#ifdef CONFIG_IOMMUFD
>>>> -    object_class_property_add_str(klass, "fd", NULL, vfio_pci_set_fd);
>>>> -#endif
>>>> +    if (iommufd_builtin()) {
>>>> +        device_class_set_props(dc, vfio_pci_dev_iommufd_properties);
>>>
>>> device_class_set_props() is called twice. Won't it break qdev_print_props() and
>> qdev_prop_walk()?
>>
>> device_class_set_props() is misnamed, as it doesn't SET an array of
>> properties, but ADD them (or 'register') to the class.
>>
>> See device_class_set_props_n() in hw/core/qdev-properties.c.
> 
> But it set dc->props_ and dc->props_count_, first to vfio_pci_dev_properties
> and then vfio_pci_dev_iommufd_properties, this will make qdev_prop_walk()
> find only iommufd property and miss others. Do I misunderstand?

You are right! And I thought I was understanding what this code does...

