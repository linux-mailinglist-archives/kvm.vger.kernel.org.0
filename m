Return-Path: <kvm+bounces-57816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67533B7D190
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DED17B7175
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 06:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344052BFC8F;
	Wed, 17 Sep 2025 06:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TpeFTEhk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4762021B9FD
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758090127; cv=none; b=htFr03JLx97+YhvVcxzZPlZwPWl9GMrTvgHorLUncVhzsgd1X3OeOWdExCjGwrpohIDP6evm/vFm+g5rZq7PcnGqF5qOdHAY5MhWUYv2A40TL95B6h546vAHWWA5sxXVBulHFerg6CpR6VTrUnlSGePzg7XNyHY4l6yEU/k+FqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758090127; c=relaxed/simple;
	bh=Kjn7elBlJ9GDdMgXC2HuQsesFr1yau8WiLp8/P3iHa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9gdau1MGkKNF6bNtzimlryzgoBdMLPVuNntW77Z0So22cJ96Xi1TYWTyJxcpfIFklduhJTYI14dyYxEXuOjDOxaSs0BD0m1Z0f05JhzA3cPvJsjbI/oYuF5PZ2EoLyjAdtFiYry9mbzf6bbp56qrXYXW7AomMxreLyD3uex8BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TpeFTEhk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758090123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ykBGuqrBMlcXxL95pIhOkq4MfPjBUjAZXEQ/nbR5dCs=;
	b=TpeFTEhkTytsKM+LWmzL5eRFdQrnrVgVakVwLrGHk9C/Dp+OB28OZ42sjl2m0b8ZR2s4/6
	Hb9PZM6KmyiyURsAohrREt5BZWks1IpeqFWl0XkN2BkmFcxnq7nNypPMnl4KRWHM0kMKgN
	Ycf6nne0FzDlZ2L9PbfnWgSkoGMR2q4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-b4nuSARjPa-kdPExXIHYiQ-1; Wed, 17 Sep 2025 02:22:01 -0400
X-MC-Unique: b4nuSARjPa-kdPExXIHYiQ-1
X-Mimecast-MFC-AGG-ID: b4nuSARjPa-kdPExXIHYiQ_1758090121
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece14b9231so14268f8f.0
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 23:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758090121; x=1758694921;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykBGuqrBMlcXxL95pIhOkq4MfPjBUjAZXEQ/nbR5dCs=;
        b=ZpankWe/w7VNGmbcT4PpO8LF5iLw2n9H+7uIWV9jIZysq4S6yvmod5BQbYWNoET2Fv
         /MsAiI52puVN6wujcvzQ/RKQ2NWsh8USySZZVyR+PAatlPptI0ll4dCLzmJpsKHeS+S/
         4GgwZUEZ4QehVcifj00JUgcrf1Z5hPmB+ngGmV03AHI5cW3KzEk4E7BUM+WfkXJqCZFN
         QKHZFGqNfugW+7v6aW9Ln1fmNFI5z8wPKrSnbxiQ68MCgHEwz7zBKwYBnL56HuCL0YJS
         VzIFxKgWAkqzhFyN2jTyZL86mS261n/y5l1Et+rSEhClP/a4+C35/bnbkjoMc6mC+zbM
         Dl6g==
X-Forwarded-Encrypted: i=1; AJvYcCXK7ntNhHPVNAGTh6wCy7YFL+yOzIHlmE/GK7ghAMTNcn6Bmow+wEsE2C8KnkCmKUuhcFA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk1QPAEueNVfRYtm95W2rx5OxYB3FhXA8tC1hNyAPJaOUSxEF/
	dXR/80odTUu8b8iukto+PeLauwcX7xHj/aMG33r9zGbVX2XCAlcYYMftcvftAIcqQfBhIy8LxHd
	6lr7CpGTA2pyS3WAaeq6eTerMV+4uWcu/VpkaT77ViUwTIN47w9bOEQ==
X-Gm-Gg: ASbGncvqJX52n5tXa6oSQs1UR9yWsP1Ghr9IG4kfAU90+BX3FGBV0jV2PHA9HbpSQuP
	CB0uyUab9G7BwfeQVDkdryrtYe91GibSv4S7MIkM+vX9vkNZ5SVKT1ygQ426Pb8RsZ8ye6rLQUC
	WNfCfHRaArf13Iutdcax3t3s5CZOjMVGTx9faeGS8tjbzBmbZeFCWKqdT1IhmvYesuZSwg4kG8e
	/0lDVM9RMxOj5FGwTfzuTHS+yQSXR5DXX7Nu522beR5986YiZIrDW8+OQYPWZIp7qHZWpn40Ajm
	eJ+hGo8soslyDW0A5yXk+3hRb2+R5y8FoiDaYOmiWtmYUbrePoygPafl2frzpXJ961A6KujEJWq
	pZ3w=
X-Received: by 2002:a05:6000:1889:b0:3eb:c276:a340 with SMTP id ffacd0b85a97d-3ecdf9bebc0mr1073619f8f.5.1758090120707;
        Tue, 16 Sep 2025 23:22:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH95sM8zcZA3S/ZThSNtLvc2pETLqqWNVH9/PfGgCarDap7/c7q1p/06ACiud6tmXkUphYpCQ==
X-Received: by 2002:a05:6000:1889:b0:3eb:c276:a340 with SMTP id ffacd0b85a97d-3ecdf9bebc0mr1073598f8f.5.1758090120354;
        Tue, 16 Sep 2025 23:22:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecde05551fsm1861195f8f.23.2025.09.16.23.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 23:21:59 -0700 (PDT)
Message-ID: <f6f59318-c462-404b-bf4f-ae121950be8c@redhat.com>
Date: Wed, 17 Sep 2025 08:21:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
 <07205677-09f0-464b-b31c-0fb5493a1d81@redhat.com>
 <e86caff6-8af0-48c9-9058-c1991e23160f@linux.ibm.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <e86caff6-8af0-48c9-9058-c1991e23160f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Farhan,

> Hi Cedric,
> 
> Thanks for pointing this out. I missed that dev->slot could be NULL and so the per_func_slot check should be done after the check for !dev->slot. I tried this change on top of the patch in an x86_64 VM and was able to boot the VM without the oops.
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 70296d3b1cfc..3631f7faa0cf 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5061,10 +5061,9 @@ static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, bool probe)
> 
>   static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
>   {
> -       if (dev->multifunction && !dev->slot->per_func_slot)
> -               return -ENOTTY;
>          if (dev->subordinate || !dev->slot ||
> -           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
> +           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
> +           (dev->multifunction && !dev->slot->per_func_slot))
>                  return -ENOTTY;
All good.

I have pushed the Linux branch I use for vfio :
  
    https://github.com/legoater/linux/commits/vfio/

These commits have small changes :

     PCI: Allow per function PCI slots
     vfio-pci/zdev: Add a device feature for error information

Thanks,

C.



