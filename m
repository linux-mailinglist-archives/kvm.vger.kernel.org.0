Return-Path: <kvm+bounces-34558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A431A015B2
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 17:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230D73A2A63
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 16:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF231CBE87;
	Sat,  4 Jan 2025 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wiz8RAWR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794147E105;
	Sat,  4 Jan 2025 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736006978; cv=none; b=C0DkgSvAsiU25SVUMehLkrbxmh/iWpeTnUqPl1kEsBsjPKWe5V5Wic+Ebh/PLKkVsObfr9SDt2qgeVV8wigq0vSRZ65upJtoT1IyP2U1Gwygg/lIZu0dFhT6G4xQOlYawZzJ/fgwYqgMI9vbE0aRFTu/xzJzW+qmsoG2MIUPiqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736006978; c=relaxed/simple;
	bh=qm+2f5dLYhjmuzeGdRkcNb9ur7HDx9UEZ1JTL7Nm0nM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qtjv2O+7rXNwZfpjCw2AQa6BhkXl/gteT+PSDOeERFS9TKqIl7gGJeBXAfaXSkqCmFp3BiUXk8YekciZ8KO/uRpmG3GVNHtS2CLTN91F2lNIW9b3a/zkJY4H/TxWeub2P4fsb6zJxbGAowNGptq0UP5M4Q9wcKYqPcxcPt9AHE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wiz8RAWR; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-216634dd574so122288805ad.2;
        Sat, 04 Jan 2025 08:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736006976; x=1736611776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IiasTFv+3QwOoYd+VowJl7+2vMF8wVn3O99tcE5rB0g=;
        b=Wiz8RAWRnWW1rMpPJtFV2CkRzz7i4bga5EIRFmWcjzuw1TH89Yt8aysIBOdWWCTGvR
         Y43PI4Df0xNqpG7xeQH8hWDNTxjX1HcJW+dRIW+sdBvAimlvfm30mA3hfwYxh64qQfri
         F7jfvGfKkVKx8ITblg6IM2Pbkab2Tzhwn9hxJ9w/4Mql72WWgmRtroeKioagRokrHsgQ
         5QWr+Ht1kTo05X5XtVkhwEdtmxHqrwSNYdeUEfgZEDKjWrJ26X0jDrg2ipGhvPb83wcS
         KQeWrLyelV8HoAlnypIdhNQf6B9SlvjSFYqf78wtsPRyOVdMLl3IAFexBsQk3Sb/gcu5
         HDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736006976; x=1736611776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IiasTFv+3QwOoYd+VowJl7+2vMF8wVn3O99tcE5rB0g=;
        b=L4g35PMF4MigWB5j+kiiDr/+wJscxT6XZyqMfpGyJKJwU+Os3XO0QDF04B/WZ60lfY
         QdZ+xBrmbXCAenz9ZP0fSN9NjG093u+wGrUhMPPO0cpF/XhHQLKPo75IzqikTPtzRKfR
         BOvAPJx0DG6aByMWj37ERpJ5j2j7v3QWDA1iFCAeeUUbeAWsOI7IaECaE+5Vb6YO3XBw
         5nQWQj3XnrzHDLD8gPLgDX/Wr3cdQM35NoYPbJ1rXklfVY/ySjLJPNLbebI2TECQEfB+
         bKzlWVu8Ji/VpyAc1yf2WuccjAFauueIvcgjUyJUJRqQTa/a0vop8/nYV0m780v+6LNu
         X/ww==
X-Forwarded-Encrypted: i=1; AJvYcCVFpDSisxHA5cKS8f0fNRsM15VqftdT+NksTlJckSw9cHfD6Ofo8BNTLeAqNyecRcP1CLWG02pQrA3C95Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAgFy9mBrtqlZiF5r8CeMaoR5311l7957+FVSlYzfpCB0xrSDc
	g3ZsYa8BQheK6fRredJFhnN8WInbQjuR6hO2M/7j4t95YiZYZM3CH/NfTmx3ujji
X-Gm-Gg: ASbGncu7eFM759ojpiCkWmS4T9EFd4ekKYhwreUYUC6Rj3GEYVsURTe6z+ULPD9eG+T
	UHjYE1vCQwu9yiq1bC08VjK//rZBsboD3xKd8pneDBWsd/nB2puuuAWrLMNqg1k8X0mxkZbq2KU
	b27tJefxkDQ9Ifp0B25ki0D5Ywyoal1TXcZ2qV8+6iH//ozDfzL1kkHeJ7LY6h8Mtyj3t0GBLwD
	7+hiqg47ue3xUY6i7MA4RW7sRygoSZ/eAIpBYQ9o1Yol/ANO1BKQnJ8qLxcaw==
X-Google-Smtp-Source: AGHT+IGaBPXRmCg2ZqGpWdfiLW4ewlVS148Dpms/02/GM0fFZks218NOlHV5ocglWdMPW6m+2NkNtQ==
X-Received: by 2002:a17:902:cccf:b0:215:9d58:6f35 with SMTP id d9443c01a7336-219e6e8bb1dmr908318695ad.1.1736006975869;
        Sat, 04 Jan 2025 08:09:35 -0800 (PST)
Received: from [192.168.0.163] ([58.38.120.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96eb8esm262348375ad.64.2025.01.04.08.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 08:09:35 -0800 (PST)
Message-ID: <69970c12-3ceb-4109-a5ed-ce2546faaaff@gmail.com>
Date: Sun, 5 Jan 2025 00:09:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: update igd matching conditions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241230161054.3674-2-tomitamoeko@gmail.com>
 <20250103104427.55f1c73b.alex.williamson@redhat.com>
Content-Language: en-US
From: Tomita Moeko <tomitamoeko@gmail.com>
In-Reply-To: <20250103104427.55f1c73b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/4/25 01:44, Alex Williamson wrote:
> On Tue, 31 Dec 2024 00:10:54 +0800
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
>> Changelog:
>> v2:
>> Fix misuse of pci_get_domain_bus_and_slot(), now only compares bdf
>> without touching device reference count.
>> Link: https://lore.kernel.org/all/20241229155140.7434-1-tomitamoeko@gmail.com/
>>
>>  drivers/vfio/pci/vfio_pci.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index e727941f589d..906a1db46d15 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>>  	if (ret)
>>  		return ret;
>>  
>> -	if (vfio_pci_is_vga(pdev) &&
>> -	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
>> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
>> +	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
>> +	    (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
>> +	    (((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) ||
>> +	     ((pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER)) &&
>> +	    (pci_dev_id(pdev) == PCI_DEVID(0, PCI_DEVFN(2, 0)))) {
> 
> Sorry I wasn't available to reply on previous thread before v2 was
> posted, but given that we have vfio_pci_is_vga() we should use it
> rather than duplicate the contents.  I think that suggests we should
> create a similar helper for display_other.  Alternatively we should
> maybe consider if it's sufficient to use just the base class.

I think using the base class is okay here. AFAIK intel doesn't has
any devices reported as XGA or 3D controller.

> The DEVID of course does not include the domain, which make it a rather
> suspect check already.  What do the discrete cards report at 0xfc in
> config space?  If it's zero or -1 or points to something that we can't
> memremap() or points to contents that doesn't include the opregion
> signature, then we'll already exit out of vfio_pci_igd_init().  Is
> there actually a case that we're actually configuring IGD specific
> regions for a discrete card?  Thanks,
>
> Alex

Checking (pci_domain_nr(pdev->bus) == 0) seems okay. I tried on a
discrate Arc A770, there is 0 at 0xFC, so vfio_pci_igd_init() returns
with -NODEV and the device is skipped. Shall I remove the BDF check?
It seems to be unnecessary, my intention is to ensure it is really an
igd since it can only be at 0000:00:02.0.
 
>>  		ret = vfio_pci_igd_init(vdev);
>>  		if (ret && ret != -ENODEV) {
>>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
> 


