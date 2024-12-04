Return-Path: <kvm+bounces-33053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B820C9E4580
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94638B325E9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3A520E012;
	Wed,  4 Dec 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyqM2vSJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A72C20E00F
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331877; cv=none; b=VDTpRvTY1B7rqIsrv0/XltnZ5ghyI28k2fEK9AKHrIdP1JilOBPtY8B6OF6HFHCr4ejJzfUpa/Bb5Ais2z0nS36xIm9UBkMpMmENYPbUr4bj9u/PND3yiuli8hSH/aXCCnxpcwDiVdESqxy/yIV/j6AAjTIpXQGIjytqiBLpoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331877; c=relaxed/simple;
	bh=cv3El7T28v/zi9+ganUHlJwMSbXxNzLTkxvW75b2bpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=arkNxIp98j6WrCDHEoUiDiMsIgo3qiweJUAiooF6kTGmUdIxyHUM4A+MTKLRkZcG/4qPpS2RwidYrX9CyW6RW9ni2/7fAeDJvC7xtDC45YSrcTeZtfFl1PmMJvtYrRFfvjmcAXTuNZDBL72TUGyuG7m3Cx7avXG7bfYXZ6kc+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyqM2vSJ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa5500f7a75so1076881666b.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 09:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733331873; x=1733936673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lG0oMrKAvG25zDUzCjduuloOvGAhvlug3OuALlmU8G8=;
        b=TyqM2vSJPz7Z1ZJcjcuNIP4P5p8cpKspnsbcXhpXpylDiSisg6VLOlLPdlyV0teWzj
         uO9UFBJHLD/htNUIQ7kx5c4PF9NAiutXYaHkzL84kKwQsDbSpy7r3hmAAPpoYmqQ4ZSg
         iABfkxknatHaDVnC3LzIpYnngHErH7qGgR24C/vS4Wmk1duuWbP5sbobGqjz+fkPOemd
         f6wgvup/9g4fQevAdKJQEt1+UDAOCR45GGF05p+oCS64iXtSkAHVWdLJfRj1sKu7Vuwz
         1fhGJOXrhFwiVkE12vDoTxDJvqnghrK9YVDJHWLwtSgjWUjhl0pOPp5+V515oZknvzTY
         Z/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331873; x=1733936673;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lG0oMrKAvG25zDUzCjduuloOvGAhvlug3OuALlmU8G8=;
        b=nnfQLD3HEqHERvDEFTnVwOZ/7F8iQoWL0gPHyjYAovn7+lfclc73BzbixRJ6LjVVMP
         YODEZG8DjGXL9A26ihY0Cp5MIDRGy5pBtC+NFAtL0mKhvsKCe+W3RPZ8+6lJa8Ds2nF5
         NyTSth1wo6pPvqIJWtDh/i6PA5FHX1IIf3xh2PVnk+78m6LWK/9T4RQQnyq2GH9GUXuP
         /obCdUfsMlrcP3gtXj+/zM53ZNfQh19cO015cdeiG/id2HHh053NZfbig7YYtyXcMqrx
         HP+Bryj7nZn2hGRFwd8UKSDzZF9qd+QVaJA/tSkPw09dSwbjtsSVB7n7XGC8vWlkK6YE
         4P7A==
X-Forwarded-Encrypted: i=1; AJvYcCU3oa6eStaCeDmWxXiWx8PDAB5a05TdMyvS9FxUH6N2SWOC2Qt/MByUIhtQkmxrygucCjo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx676wyInEPwM+75wd9gz/CIp457OhkND8Ntq9Se6viyvk0SRy1
	FUL7PWToy/p8QSBaA8CsUFrd7Kaequv0aBiZrwaPu7J2ftkfL9jg
X-Gm-Gg: ASbGncv9WMc7MI0h6isQud6KWrJjhK3uGXS7YbUL2cdF5XQgmGsZ2wDbFOVFVHhm23H
	nQnZUorOMaKzgSPGeL6nMxJeb5Wj0uf7So0x8zSjxDUkqwULkFzYEMrXmHd3fahWBleGoTmAb1o
	Z2Mok/8gJLmNm5ei5gLimrjvaxTNXaemoVse9oiyZqTz9tqg84Cd46UPWRgtCTxusx5iRHkh4LB
	9d7olb9dCImy1sH9zhLoj2glWiIeBlAyfwlw98pElgHLKryszIPX/QnBX5omwDw+k3GDrdmrivG
	ULjgzyGzHaHVZgZU45NyJEPd25k7jaLKBnSsSmwOa90Ro2NAjxXckckrW57Zk8V/1r5DsaS4pMv
	IwGzAWzZZUFteQKSkJHlaoBDDLSnFGduT4PXKOr4=
X-Google-Smtp-Source: AGHT+IGl5U9iiIdV3EfDXf+VSOFfE/OfAMe49MsFpxXa1zRPeBNkWrcnlzDxMFuhIjs4gR4Hj+y/mA==
X-Received: by 2002:a17:907:6195:b0:a9e:b2da:b4a3 with SMTP id a640c23a62f3a-aa5f7f006f7mr494812866b.42.1733331873296;
        Wed, 04 Dec 2024 09:04:33 -0800 (PST)
Received: from ?IPV6:2a02:3100:b3a6:dc00:4df6:7a00:cfe0:a99? (dynamic-2a02-3100-b3a6-dc00-4df6-7a00-cfe0-0a99.310.pool.telefonica.de. [2a02:3100:b3a6:dc00:4df6:7a00:cfe0:a99])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5996ddbfbsm754514166b.51.2024.12.04.09.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 09:04:32 -0800 (PST)
Message-ID: <169a836b-2cab-40a1-8c92-4ee4c979dd3b@gmail.com>
Date: Wed, 4 Dec 2024 18:04:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] driver core: class: add class_pseudo_register
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <b8122113-5863-4057-81b5-73f86c9fde4d@gmail.com>
 <2024120435-deserving-elf-c1e1@gregkh>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <2024120435-deserving-elf-c1e1@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04.12.2024 10:33, Greg Kroah-Hartman wrote:
> On Tue, Dec 03, 2024 at 09:10:05PM +0100, Heiner Kallweit wrote:
>> In preparation of removing class_compat support, add a helper for
>> creating a pseudo class in sysfs. This way we can keep class_kset
>> private to driver core. This helper will be used by vfio/mdev,
>> replacing the call to class_compat_create().
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/base/class.c         | 14 ++++++++++++++
>>  include/linux/device/class.h |  1 +
>>  2 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/base/class.c b/drivers/base/class.c
>> index 582b5a02a..f812236e2 100644
>> --- a/drivers/base/class.c
>> +++ b/drivers/base/class.c
>> @@ -578,6 +578,20 @@ struct class_compat *class_compat_register(const char *name)
>>  }
>>  EXPORT_SYMBOL_GPL(class_compat_register);
>>  
>> +/**
>> + * class_pseudo_register - create a pseudo class entry in sysfs
>> + * @name: the name of the child
>> + *
>> + * Helper for creating a pseudo class in sysfs, keeps class_kset private
>> + *
>> + * Returns: the created kobject
>> + */
>> +struct kobject *class_pseudo_register(const char *name)
>> +{
>> +	return kobject_create_and_add(name, &class_kset->kobj);
>> +}
>> +EXPORT_SYMBOL_GPL(class_pseudo_register);
> 
> I see the goal here, but let's not continue on and create fake kobjects
> in places where there should NOT be any kobjects.  Also, you might get
> in trouble when removing this kobject as it thinks it is a 'struct
> class' but yet it isn't, right?  Did you test that?
> 

It's removed using kobject_put(), same as what class_compat_unregister() does.
I only compile-tested the changes.

> thanks,
> 
> greg k-h


