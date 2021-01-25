Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8A302C3A
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731803AbhAYUHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 15:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbhAYUGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 15:06:49 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A751C061573
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 12:06:08 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id y187so690108wmd.3
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 12:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DSO+jSXnFCkYOVOHIbcm1gc95lAyaYUYSWQBIoSrkCg=;
        b=blnU0e42NbZ83ireS0YzhUW3EoHpL8dZNCN1SG9xi2/QblHvIyQBNQ4FXyK30ZGmTQ
         Vj4hiS5X/PmJcS/z7dwVF5eU6RRxsmjLObZOm3EsVmyqPPyZtvih3Ko16wMytmRRoQ6v
         XqsnkVSobDQWh0F7kBvbmgXl439JKgGqqmUHLu2whNAoK0/P0O+cgwuwP8VMo8AVPg9Z
         0wlALSGPsRJKAwcUlLJ666s9FuKMDA+8qW9b44FsgF6cqwieIZQ+zIxuJZpweqLAC9/n
         LPMYbnzsNcobGRomeXmYaK6CofMFeDAVqYvxCugT3nFuVOHQMAM5881Sw10qP3oklyrJ
         Pc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DSO+jSXnFCkYOVOHIbcm1gc95lAyaYUYSWQBIoSrkCg=;
        b=hCvluKBtcSzflvKs53a2cNFCocZhA+eGD5QZPLlrOpezRfbm6qPybyiX+BEwMLhOah
         JI9idOI0evp5DfOO76iNEXoTrQhIDlRigUsY4zqWUm4kP+Un+x6Qpxn4dArCP7PTrzhX
         9JDZNk7Avx3QOqhvK0GsXwzE6IanPYYRG7QXR19qf5ReuLRDi3JcwPpJ+x4uWGslvzlJ
         mOlMxH72TVnUOkb65c3HnTrzBVhGggWfmS1ERpR8Lg9Q7uMmEycaW4U1tIT6YSHKl2eK
         55+QX69hnybEKfajm+m2pbqRhXgT8mf/DlZydWO217EoRDl1nOxV33YApQzrnRuo1/WB
         rFlQ==
X-Gm-Message-State: AOAM530FJiS90uv/7Snw7I9eJYzgdWNtk4yE87kGVPVT4fXa4YEAgGHV
        XWs8E+Kdlv7eY/i7tusPp2+3zubCbsI=
X-Google-Smtp-Source: ABdhPJw+EhxPZiu39faIob4cXmopR0VGkSf7Hufv3J+8bjyp7sAnvu1ILITvkL1nWeAGNe2g4TbDeg==
X-Received: by 2002:a1c:2783:: with SMTP id n125mr1623587wmn.74.1611605167058;
        Mon, 25 Jan 2021 12:06:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:20b9:2450:6471:c6e0? (p200300ea8f06550020b924506471c6e0.dip0.t-ipconnect.de. [2003:ea:8f06:5500:20b9:2450:6471:c6e0])
        by smtp.googlemail.com with ESMTPSA id v126sm396523wma.22.2021.01.25.12.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 12:06:06 -0800 (PST)
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
References: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
 <20210125191147.5f876923.cohuck@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] vfio/pci: Fix handling of pci use accessor return codes
Message-ID: <1b4b36a2-edfd-bde1-a265-cb9b0272bd55@gmail.com>
Date:   Mon, 25 Jan 2021 21:06:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125191147.5f876923.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.01.2021 19:11, Cornelia Huck wrote:
> On Sun, 24 Jan 2021 16:35:41 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> The pci user accessors return negative errno's on error.
>>
>> Fixes: f572a960a15e ("vfio/pci: Intel IGD host and LCP bridge config space access")
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_igd.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
>> index 53d97f459..e66dfb017 100644
>> --- a/drivers/vfio/pci/vfio_pci_igd.c
>> +++ b/drivers/vfio/pci/vfio_pci_igd.c
>> @@ -127,7 +127,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
>>  
>>  		ret = pci_user_read_config_byte(pdev, pos, &val);
>>  		if (ret)
>> -			return pcibios_err_to_errno(ret);
>> +			return ret;
> 
> This is actually not strictly needed, as pcibios_err_to_errno() already
> keeps errors <= 0 unchanged, so more a cleanup than a fix?
> 
I agree. Although I'd argue that the author of the original commit missed
the fact the the user accessors return errno's, and the code just works
by chance, because of the "good will" of pcibios_err_to_errno().
So up to you whether it's worth it to apply this change also to stable.

> Anyway,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
>>  
>>  		if (copy_to_user(buf + count - size, &val, 1))
>>  			return -EFAULT;
> 

