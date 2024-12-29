Return-Path: <kvm+bounces-34400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F05C89FDFFE
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 18:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC577161D31
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 17:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB3619340D;
	Sun, 29 Dec 2024 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnKBqdx2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCE5C147;
	Sun, 29 Dec 2024 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735491857; cv=none; b=KQQOqmq3EU1Ge+e+MFZbgfYTSQvYWGEvsnNsmktnLOSz4O6DsQVHQfBz2X5IqDsDDg5sjcFH2LavrUNJNF7N1d1t8gJN/+P5eDZAcEr1MVCeUd6j7b8Xn8bqyzo2X2gnT9phoQhi02DY2RVpTVrZEO0h2PcN38mE/sYHHYqetSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735491857; c=relaxed/simple;
	bh=zUlQwo28UDkn+uy0HtJYLKiZuDOQ8q+VCAacyUSyp9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fkf+alT7FigqRQvQLUZ1jdvPwlj0yAus1VBpJN1L6/CHujqSwbFAMkrtDjv2v7LgLVBcA4SRfd2snYJWoYMXBIYkW10/ormZAS/wIkagnxm4NAsiUGnzHsGG3H+cm2deCT902Uf3703paPnX8oWtlt9ZpsfiZX74L3ftblZ1mPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KnKBqdx2; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so9101635a91.0;
        Sun, 29 Dec 2024 09:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735491856; x=1736096656; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ko1sX/DQdfKvmikz83llEmH8ZwnYb3PAj/37irHgOUE=;
        b=KnKBqdx2jkPfFeUKpLClwz8LAVzK4B9Fj8opeRoUuzbqr6LrRWK2thcp4OUxRiOwNJ
         m6bYYdiJKzZmaXNY+DVkJF15qVaCAAjcHRBcOX+r9BYXQ0sw0m1BOimHeZOwsiwweNVb
         cgcVQpyQP4/Zt4eQ+fEvklbUkC0At4dcGTo6c2sAVRiHCB5jr3rmmzPr6ydAGqKgwh9v
         rP9nzv798Glys/3nfb8SZlv4u9O/5F1hM5XJIEymAhZ8I++ZZ4dN9EsugSBHa9Q4gXvx
         iVhljQd0I1KqbHpKam49EDKKmHR7FcKui1RoSCshK5BlQxE/uL3VYP18KTrUWGkLLn11
         H2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735491856; x=1736096656;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ko1sX/DQdfKvmikz83llEmH8ZwnYb3PAj/37irHgOUE=;
        b=XH1EwvyU8UFdPBWCdYunXy4RTlG0cuMgBi2+GXMUCjcapV4Go9VInJMiX6w/zP7J2I
         qSOrZ2T3+9+RtSqyvzA81yTThdeXIxg8IS/wM18p0ZEhmzJMHUJOxBZ/wt1lDCUdNmo1
         s9P/X4TbCsbo7a22jfYTJEqlUPlr2NYe4C6obAvoyabtQn702DF857fp0bMmEoFbUaMz
         nipZG/v5RSpDnSodklia1TEOkJaW35hkycvX3t8dzp2g0c8emKScHM/G/1CppQQ0gFkJ
         bbruYlrd4tEVrjmaLTTjq1GI94tQwmEAsBpsNrZP9qA06YY3Fz5SUVtc4qU+qKx422e9
         9HNw==
X-Forwarded-Encrypted: i=1; AJvYcCV3KYDTFcE4uh8UKbb8tT7/C3z8bvVSDPkF+p7aH//aPSloOH7UYcExEPlk9k9bLOgEHLVMe9dOvnaaaAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8DER9b1pPADbmFNeLcW2qpgWfCtEY9T4HgjzKCp/16g9N1HFf
	qeScB/oi3XJaaVzaGkPYDPS9xC05sZ2Lx3uN8VV0BqbqPnXHPsI=
X-Gm-Gg: ASbGncs7Ohs2UHwn70USgxDmXBCtnMLQ2kK5c4dq3qVKEh4q4tL5BHkM+5eN87aalDM
	2f53jruBJEYSE5hGyI+OVlwt1aEs3agHbXvQqFQH1RtXNVWR2lGOkEIsQbMqXQQAeJtDg0oxmTu
	zWjJ5OYiU0rISyKrUAGJEEQv6znhOI3SuBv3IcTftIYmqYneGJTIU8RaHXCViRD6FAX3n3MI2HT
	LERpSf2YS+V8J/h+Opy8qdysbHwhR4a9/OaqnN8Xj7vhhb9dZaXzG3l2Gm5VQ==
X-Google-Smtp-Source: AGHT+IGEH+3uB18r/9+6Ynl3bLT6XQKgUxdN6GFyolQQOdtOsQ5v0hJR9RYwvzbbju24/Im2aEZB9Q==
X-Received: by 2002:a17:90b:2d4c:b0:2ee:aed2:c15c with SMTP id 98e67ed59e1d1-2f452ec376amr44362389a91.28.1735491855620;
        Sun, 29 Dec 2024 09:04:15 -0800 (PST)
Received: from [192.168.0.163] ([58.38.120.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed644816sm21026443a91.25.2024.12.29.09.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Dec 2024 09:04:15 -0800 (PST)
Message-ID: <85002952-bae6-4e35-9af7-db28a593d458@gmail.com>
Date: Mon, 30 Dec 2024 01:04:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: update igd matching conditions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241229155140.7434-1-tomitamoeko@gmail.com>
 <20241229092600.00ffa55f.alex.williamson@redhat.com>
Content-Language: en-US
From: Tomita Moeko <tomitamoeko@gmail.com>
In-Reply-To: <20241229092600.00ffa55f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/24 00:26, Alex Williamson wrote:
> On Sun, 29 Dec 2024 23:51:40 +0800
> Tomita Moeko <tomitamoeko@gmail.com> wrote:
> 
>> igd device can either expose as a VGA controller or display controller
>> depending on whether it is configured as the primary display device in
>> BIOS. In both cases, the OpRegion may be present. Also checks if the
>> device is at bdf 00:02.0 to avoid setting up igd-specific regions on
>> Intel discrete GPUs.
>>
>> Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index e727941f589d..051ef4ad3f43 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>>  	if (ret)
>>  		return ret;
>>  
>> -	if (vfio_pci_is_vga(pdev) &&
>> +	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
>>  	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
>> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
>> +	    ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA ||
> 
> The above is vfio_pci_is_vga(pdev), maybe below should have a similar
> helper.

There isn't, shall I create a new helper function? or just keep it as
the match only happens here.
 
>> +	     (pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER) &&
>> +	    pdev == pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(2, 0))) {
> 
> This increments the reference count on the device:
> 
>  * Given a PCI domain, bus, and slot/function number, the desired PCI
>  * device is located in the list of PCI devices. If the device is
>  * found, its reference count is increased and this function returns a
>  * pointer to its data structure.  The caller must decrement the
>  * reference count by calling pci_dev_put().

Sorry I missed that, will fix in v2.

>>  		ret = vfio_pci_igd_init(vdev);
>>  		if (ret && ret != -ENODEV) {
>>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
> 


