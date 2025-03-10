Return-Path: <kvm+bounces-40650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CCEA59675
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2ACE165ADA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5F622A4C3;
	Mon, 10 Mar 2025 13:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wnc2u0ld"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD622A4C9
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613881; cv=none; b=uQnDF1Tj9xVm0vRvWTU/CO8LdMYACui2Ta1zc87C+IXtS6V47HjXniM3uoicAeCGMMyQvwjuu7LQnJemSTeZ6b2q+TkzW905xjKfSpJTqlLrjWbjti9+c2TLGhigqUOPK/VMcTWpT41cjDOAUq0KmWDHLbCZgwfFW4AZeFLy5o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613881; c=relaxed/simple;
	bh=O5iGlbsXT8XGT9+c1Jgg8tmT+6CCjQRkMC4YKnQjPN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lABW12xEJPf8jY19KxHbLWpCZG+pwdQb62j8G2VdtH1FMqKy+3E0R4COINJ7sUB8yBe89hg3uvi+Fb8613B+O6yvEkpWTYFp0rqD4kZzBQ2djrGWyvYBthokPVvhO2cc2H8XtXfCDBd3ihQuC8e5c4sV0jfI8Fg0ex2y6gR30TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wnc2u0ld; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39130ee05b0so2582540f8f.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741613878; x=1742218678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8KySdQxX1nHvjTTeGWqK8o0qyyUi+8pyjyiDw/OuToM=;
        b=wnc2u0ldACc2xTZbd0MbfCTJ3MDUtIskuhS4fMoigFJcc4/4T7bfnYz3IjUYFnU1Ux
         XSiw6PxngAN12ETZ61RS7P0qXkapBPCpS0cnjwGzlubsOMSess5xlRGTZUFbWSrL/Bdp
         x6u6G9FiuKVRcWrK3KBUtFx1untVPA3LdqhZsK4YlrIlWtdd4Gt57Qyd3G8iuIKWUOuv
         CNfd11A7lxNwakFyDSHkhj8FOGU4mYxhG7oo02XFwl6TJnYXb7fNO2KFO+33QqRDnjl5
         DZKoM4L6G17C4RpMEwBwnBecfptJOjj719uYbUbH55APS38ZogA3OmST4R1IDz8qtKsM
         hc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741613878; x=1742218678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8KySdQxX1nHvjTTeGWqK8o0qyyUi+8pyjyiDw/OuToM=;
        b=e1KAz8JoRicK3Ob8XwPuRt+6B1W/rXyU3E5Ph9O0XUpAgxtTJ9dsrRRvzY1m//Z0e7
         yEDiUI6amGJ3rc9+bjJkrg00hlX3tNAU5WI3v6A707Kj1Ci5MRBclKsimzPEhkJGF0tY
         H5tLyOf8loJPOChnilFWPcdj9ihLNyIXLFkMdflHJIu/zjMfB7KbOYYJwnSlohLZ6CVq
         ShwtsmKgbhp1SErLPvKoedYCu6zefp1arFJdOB9zzuhsf3fInTjAon8LxtNJu+JfreVB
         gF6HqUWLiO2KI8KuJLLJsWzGKWA8Qt8Qp5JbrNECm95vlJwtcqdxQ26OjIicToUl9J7H
         IROQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD9F6eMrY4Brf2I6uWVg9vOGmC8BSXQNkZQ7bFDIxjc5H+Z5bvBskjtEioOWZ2plZyAmU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5/NiH9cdAk6bjkVjfYFptjXp9lWnP5meOkY7ULH81GKR876gS
	LWZt6QyqTSjzU68VdZC2K8SDZ/Jwx+CJRVkgBHEJB9tB1Fxc2rc9QoOncUC/DpY=
X-Gm-Gg: ASbGnctN5ws6KnUjFLUPtuaR/CgauMSbNH08IXhqnAIVfoWEEzPU0B5bPRiqRTIEPIh
	lZLYpUudJj8ZxsY+01EpVNLm2gltgptbWLuGDI6Q3tqjP1xjIDnvPF+zqLZ+diXa5mDVygw6UY5
	+Wc+fr9ojIeq80KqUBG6ILOy1UiocRE/PkLTaYzZaiVc1ZdDC3pXZyB6T68ClC71XU3U9ULAVLr
	b1FZEixuyBhMMHAIZJCguAIitzE1gA59RTzTVj6/drZiflCiI7dEz31mFcEX/NlE/M5Cuq72Y3q
	XtuobE/D+cB5tDZeTZGHI35Lt6fRRO/jdFVRT95atiXIaZy//Dfc6CbaSYGRmUz+jC/tW2ECIQv
	FzD548xoBHYW/
X-Google-Smtp-Source: AGHT+IEi3Zkt+nyRM6pBylfBbjpQZ+nrPau9+qv5tN7Kk8GGNSrRDFA2w3bF2VCAkL483hx7lOZtSA==
X-Received: by 2002:a5d:64ec:0:b0:391:3406:b4e2 with SMTP id ffacd0b85a97d-3913406b7e9mr8435477f8f.49.1741613878158;
        Mon, 10 Mar 2025 06:37:58 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e3099sm15376268f8f.69.2025.03.10.06.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 06:37:57 -0700 (PDT)
Message-ID: <d883d194-3a68-4982-a408-d9ab889fd2c7@linaro.org>
Date: Mon, 10 Mar 2025 14:37:54 +0100
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
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <SJ0PR11MB67449BEA0E3B4A04E603633C92D62@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 05:11, Duan, Zhenzhong wrote:
> Hi Philippe,
> 
>> -----Original Message-----
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
>> using iommufd_builtin()
>>
>> Convert the compile time check on the CONFIG_IOMMUFD definition
>> by a runtime one by calling iommufd_builtin().
>>
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>> hw/vfio/pci.c | 38 ++++++++++++++++++--------------------
>> 1 file changed, 18 insertions(+), 20 deletions(-)


>> static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
>> {
>> @@ -3433,9 +3430,10 @@ static void vfio_pci_dev_class_init(ObjectClass *klass,
>> void *data)
>>
>>      device_class_set_legacy_reset(dc, vfio_pci_reset);
>>      device_class_set_props(dc, vfio_pci_dev_properties);
>> -#ifdef CONFIG_IOMMUFD
>> -    object_class_property_add_str(klass, "fd", NULL, vfio_pci_set_fd);
>> -#endif
>> +    if (iommufd_builtin()) {
>> +        device_class_set_props(dc, vfio_pci_dev_iommufd_properties);
> 
> device_class_set_props() is called twice. Won't it break qdev_print_props() and qdev_prop_walk()?

device_class_set_props() is misnamed, as it doesn't SET an array of
properties, but ADD them (or 'register') to the class.

See device_class_set_props_n() in hw/core/qdev-properties.c.

I'll see to rename the QDev methods for clarity.

Regards,

Phil.

