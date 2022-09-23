Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358F25E78A4
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiIWKrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiIWKr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:47:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEC713072E
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 03:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663930046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr9D2nxa419/6RhWTwJtZgsn+SCyu83SR9F+lYB9nLM=;
        b=bbusqQ+hb0TZWLTq2e/WBmMDdHFiToovxqXvxgRAnzn+hhYF+1eJmbq5h6Mambm56jkYBx
        Oblgwcd3MpT1NSp4aMHuDrJ+Uvn3slmqVtJWpno4HMPt8ql9SMP8buK88aLztfVWkT9Ldc
        3/eHYpIAfFBwm0V0bF7FQAzKDl4zrHc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-0IKzgXwcOhy0xmZ5UXTDsQ-1; Fri, 23 Sep 2022 06:47:25 -0400
X-MC-Unique: 0IKzgXwcOhy0xmZ5UXTDsQ-1
Received: by mail-wm1-f72.google.com with SMTP id 7-20020a05600c020700b003b4ce6e6b12so1690034wmi.0
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 03:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Qr9D2nxa419/6RhWTwJtZgsn+SCyu83SR9F+lYB9nLM=;
        b=RN8p0b3oF+fzv9TjInjvP2+ASxJTtcPh+7ul254qPb7N74E9P66gBvLwMxBB6eszim
         kPvOta7PzQiWzfmbfzT/6iUxbGmiSCvy6DtqwJtRQSHJs6LQDKBLnirByyFlyriEoJlt
         fZwBqB1lBeZx3aDUuFqVWnIbGJkvwh/mo3tiJ2ZW461+WyIQUO0M/K4GQ33Upj3LBtTC
         AN59QCedvOr7kDiWNtO7EPPZCXRczJHf0PAaj96EO6NmIrpc/fUEMAgdkIzbrKRNwLyS
         pX90WLlxiywW8iId2k8jkGOMeDDIbBh6kI2fXzhyE0UwO83iHt8A6myECQsxgpQz3NVU
         bWug==
X-Gm-Message-State: ACrzQf10kPPb/IHCR4UllKi+GjvuUqbggOgAmkuyHzWW3X5LLgu4IC24
        eyVer3ZORGJO3xCz0x4HAo7ItxMrLMNDKH+zG7VqXxawx+CQU5fsMd9JIKVhrn1oaxCovQn6pTO
        Nhzc0Yp7rrlN8
X-Received: by 2002:a5d:5232:0:b0:228:6bb8:e985 with SMTP id i18-20020a5d5232000000b002286bb8e985mr4874226wra.10.1663930044160;
        Fri, 23 Sep 2022 03:47:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7oahzqi6gvqJtWwHv1wGKmPcNFzhCGBqcPBy0fWzvOcNz30QeMRmnORWlgetNmzbkUF81SyA==
X-Received: by 2002:a5d:5232:0:b0:228:6bb8:e985 with SMTP id i18-20020a5d5232000000b002286bb8e985mr4874202wra.10.1663930043939;
        Fri, 23 Sep 2022 03:47:23 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-37.web.vodafone.de. [109.43.179.37])
        by smtp.gmail.com with ESMTPSA id n11-20020adfe34b000000b002252ec781f7sm7166167wrj.8.2022.09.23.03.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 03:47:23 -0700 (PDT)
Message-ID: <282102a6-7406-0a7a-2023-d2b9b6e68e36@redhat.com>
Date:   Fri, 23 Sep 2022 12:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-3-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v8 2/8] s390x/pci: add routine to get host function handle
 from CLP info
In-Reply-To: <20220902172737.170349-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 19.27, Matthew Rosato wrote:
> In order to interface with the underlying host zPCI device, we need
> to know it's function handle.  Add a routine to grab this from the

Nit: s/it's/its/

> vfio CLP capabilities chain.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-vfio.c         | 83 ++++++++++++++++++++++++++------
>   include/hw/s390x/s390-pci-vfio.h |  5 ++
>   2 files changed, 72 insertions(+), 16 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 6f80a47e29..4bf0a7e22d 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -124,6 +124,27 @@ static void s390_pci_read_base(S390PCIBusDevice *pbdev,
>       pbdev->zpci_fn.pft = 0;
>   }
>   
> +static bool get_host_fh(S390PCIBusDevice *pbdev, struct vfio_device_info *info,
> +                        uint32_t *fh)
> +{
> +    struct vfio_info_cap_header *hdr;
> +    struct vfio_device_info_cap_zpci_base *cap;
> +    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);

Nit: two spaces after the "="

> +    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
> +
> +    /* Can only get the host fh with version 2 or greater */
> +    if (hdr == NULL || hdr->version < 2) {
> +        trace_s390_pci_clp_cap(vpci->vbasedev.name,
> +                               VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
> +        return false;
> +    }
> +    cap = (void *) hdr;
> +
> +    *fh = cap->fh;
> +    return true;
> +}
> +
>   static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>                                   struct vfio_device_info *info)
>   {
> @@ -217,25 +238,13 @@ static void s390_pci_read_pfip(S390PCIBusDevice *pbdev,
>       memcpy(pbdev->zpci_fn.pfip, cap->pfip, CLP_PFIP_NR_SEGMENTS);
>   }
>   
> -/*
> - * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
> - * capabilities that contain information about CLP features provided by the
> - * underlying host.
> - * On entry, defaults have already been placed into the guest CLP response
> - * buffers.  On exit, defaults will have been overwritten for any CLP features
> - * found in the capability chain; defaults will remain for any CLP features not
> - * found in the chain.
> - */
> -void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
> +static struct vfio_device_info *get_device_info(S390PCIBusDevice *pbdev,
> +                                                uint32_t argsz)
>   {
> -    g_autofree struct vfio_device_info *info = NULL;
> +    struct vfio_device_info *info = g_malloc0(argsz);
>       VFIOPCIDevice *vfio_pci;
> -    uint32_t argsz;
>       int fd;
>   
> -    argsz = sizeof(*info);
> -    info = g_malloc0(argsz);
> -
>       vfio_pci = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
>       fd = vfio_pci->vbasedev.fd;
>   
> @@ -250,7 +259,8 @@ retry:
>   
>       if (ioctl(fd, VFIO_DEVICE_GET_INFO, info)) {
>           trace_s390_pci_clp_dev_info(vfio_pci->vbasedev.name);
> -        return;
> +        free(info);

Nit: Please use g_free() for things that you've allocated with g_malloc0().

> +        return NULL;
>       }
>   
>       if (info->argsz > argsz) {
> @@ -259,6 +269,47 @@ retry:
>           goto retry;
>       }
>   
> +    return info;
> +}
...

Apart from the nits, the patch looks fine to me.

  Thomas

