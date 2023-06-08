Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55989727A7C
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 10:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbjFHIw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 04:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbjFHIwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 04:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D112D4A
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 01:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686214278;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TX+OC0uZNryJ9UAqfqBeTESfbl65EbT1XN7uZklbEnY=;
        b=TjCHG8Vh42qTTtAtjikdY4V1D4bjFqf6tNlQoMyJ9/Z2uUdGO0fE+1xH0hmNlVcahUDGxM
        +a2/y6/GlhW2KHbhAy7EGkKSH6dvSxwUNiITcPhd+3YIZc/Vd7cZ8FW6EtxAclIbKh1Xa3
        apMQdH2011lvwiNtQCik1/ED1ZH2DnM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-trIGcBQVMsSIQJIk1OE-BA-1; Thu, 08 Jun 2023 04:51:14 -0400
X-MC-Unique: trIGcBQVMsSIQJIk1OE-BA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30c5d31b567so160299f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 01:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686214273; x=1688806273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TX+OC0uZNryJ9UAqfqBeTESfbl65EbT1XN7uZklbEnY=;
        b=S12oHlI5jWcKnpA9umCAki3xxvjeFoxQqZoHbnnsxe8MwEHQAJXD+xgO8tn+zZ+RrE
         Es0g7i7ndSnJexgqS9KN/VKeab00+49C/FhirmGd17omEf4VpBJWk9MwhxypC1O4TjKZ
         R8HXYV/OXMldp8K55d6QFSjWoJosvH3DhFCDZjhdVDZI0Yr8ISwcCyKKDRd46UN50whK
         JcAdPNmswI30NYuE7FGSx4rctxn++ruR1oN9bwnk8w0lm+oWmLdIzg0/poBeeWEBbzPV
         If/49R2qyu1tMLsn2XzjmGJlskVNVjQ+0+7JWe6TX4rwglrGxibR65i/lEaeWM30+iHJ
         vpKw==
X-Gm-Message-State: AC+VfDxVTuNfo2GqzpxVCfzH4hlzywrrdqAcGUYh7jMoUxiKG5taEJGK
        22WuMoXWIEz7cuR8nXmzAs2eRXut1RWRh+pShCWi27hmtY8dcY1MzxQWvUCcsuKDhCn426g7qd8
        gWpdBllXC25LN
X-Received: by 2002:a5d:684e:0:b0:30e:5b63:7487 with SMTP id o14-20020a5d684e000000b0030e5b637487mr3099083wrw.58.1686214273503;
        Thu, 08 Jun 2023 01:51:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ679tRUh5aqEPHnRrBjq1yRpQqorYVphlmjMQMTrTRJN+mdbEkdUdssArQgL5ars3WvBoprAQ==
X-Received: by 2002:a5d:684e:0:b0:30e:5b63:7487 with SMTP id o14-20020a5d684e000000b0030e5b637487mr3099066wrw.58.1686214273178;
        Thu, 08 Jun 2023 01:51:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l11-20020adfe9cb000000b0030ae54e575csm924154wrn.59.2023.06.08.01.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 01:51:12 -0700 (PDT)
Message-ID: <f2bd4708-c14e-ff22-d27e-4ad9897b5de2@redhat.com>
Date:   Thu, 8 Jun 2023 10:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] vfio/platform: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, jgg@nvidia.com, clg@redhat.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-3-alex.williamson@redhat.com>
 <7b4b8592-7857-b437-da06-2a6854fbf36b@redhat.com>
 <20230607130421.4e1b7ced.alex.williamson@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230607130421.4e1b7ced.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Alex,
On 6/7/23 21:04, Alex Williamson wrote:
> On Wed, 7 Jun 2023 15:32:07 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
>
>> Hi Alex,
>>
>> On 6/2/23 23:33, Alex Williamson wrote:
>>> Like vfio-pci, there's also a base module here where vfio-amba depends on
>>> vfio-platform, when really it only needs vfio-platform-base.  Create a
>>> sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
>>> Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
>>> shared modules and traversing reset modules.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>  drivers/vfio/Makefile          |  2 +-
>>>  drivers/vfio/platform/Kconfig  | 17 ++++++++++++++---
>>>  drivers/vfio/platform/Makefile |  9 +++------
>>>  3 files changed, 18 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>>> index 151e816b2ff9..8da44aa1ea16 100644
>>> --- a/drivers/vfio/Makefile
>>> +++ b/drivers/vfio/Makefile
>>> @@ -11,6 +11,6 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>>>  obj-$(CONFIG_VFIO_PCI_CORE) += pci/
>>> -obj-$(CONFIG_VFIO_PLATFORM) += platform/
>>> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += platform/
>>>  obj-$(CONFIG_VFIO_MDEV) += mdev/
>>>  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
>>> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
>>> index 331a5920f5ab..6d18faa66a2e 100644
>>> --- a/drivers/vfio/platform/Kconfig
>>> +++ b/drivers/vfio/platform/Kconfig
>>> @@ -1,8 +1,14 @@
>>>  # SPDX-License-Identifier: GPL-2.0-only
>>> +menu "VFIO support for platform devices"
>>> +
>>> +config VFIO_PLATFORM_BASE
>>> +	tristate
>>> +
>>>  config VFIO_PLATFORM
>>> -	tristate "VFIO support for platform devices"
>>> +	tristate "Generic VFIO support for any platform device"
>>>  	depends on ARM || ARM64 || COMPILE_TEST  
>> I wonder if we couldn't put those dependencies at the menu level. I
>> guess this also applies to AMBA. And just leave 'depends on ARM_AMBA ' in
>>
>> config VFIO_AMBA?
> Yup, we could, something like:
>
> menu "VFIO support for platform devices"
> 	depends on ARM || ARM64 || COMPILE_TEST
>
> And we could move VFIO_VIRQFD to VFIO_PLATFORM_BASE
>
> config VFIO_PLATFORM_BASE
> 	tristate
> 	select VFIO_VIRQFD
>
> VFIO_AMBA would then only depend on ARM_AMBA and both would select
> VFIO_PLATFORM_BASE.
>
>>>  	select VFIO_VIRQFD
>>> +	select VFIO_PLATFORM_BASE
>>>  	help
>>>  	  Support for platform devices with VFIO. This is required to make
>>>  	  use of platform devices present on the system using the VFIO
>>> @@ -10,10 +16,11 @@ config VFIO_PLATFORM
>>>  
>>>  	  If you don't know what to do here, say N.
>>>  
>>> -if VFIO_PLATFORM
>>>  config VFIO_AMBA
>>>  	tristate "VFIO support for AMBA devices"
>>>  	depends on ARM_AMBA || COMPILE_TEST
>>> +	select VFIO_VIRQFD
>>> +	select VFIO_PLATFORM_BASE
>>>  	help
>>>  	  Support for ARM AMBA devices with VFIO. This is required to make
>>>  	  use of ARM AMBA devices present on the system using the VFIO
>>> @@ -21,5 +28,9 @@ config VFIO_AMBA
>>>  
>>>  	  If you don't know what to do here, say N.
>>>  
>>> +menu "VFIO platform reset drivers"
>>> +	depends on VFIO_PLATFORM_BASE  
>> I wonder if this shouldn't depend on VFIO_PLATFORM instead?
>> There are no amba reset devices at the moment so why whould be compile
>> them if VFIO_AMBA is set (which is unlikely by the way)?
> I did see that AMBA sets reset_required = false, but at the same time
> the handling of reset modules is in the base driver, so if there were
> an AMBA reset driver, wouldn't it also live in the reset/ directory?
Yes I guess so.
> It seems like we'd therefore want to traverse into reset/Kconfig, but
> maybe if all the current config options in there are non-AMBA we should
> wrap them in 'if VFIO_PLATFORM' (or 'depends on' for each, but the 'if'
> is marginally cleaner).  Thanks,
Yes your v2 makes sense to me.

Eric
>
> Alex
>

