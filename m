Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2BD6F6E9A
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjEDPGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjEDPGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236E210D8
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683212748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9SIzfOyT/36LPUiUVaXy7e6tRKfNiByyzcagojCb80=;
        b=VaISnwWMc9kKjiwN33z+12GxcydRYqm49vgRpcRxje3Nu1QwY/y+ZZy/LGmxWxVPXKvzz4
        KWnXQwnbbIEB+gtBlYMFQdrPfE4Hm9+bf5P8TJVbOxTXS/YMM4yB2O0bYXVn2zFRXEaBJ7
        t6ndeLi6aTI/33jSjOZNnFr+rZVfDuw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-ba82iEltNZ2I9BAP_2OpiQ-1; Thu, 04 May 2023 11:05:47 -0400
X-MC-Unique: ba82iEltNZ2I9BAP_2OpiQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-5ef626ad00fso8260936d6.3
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 08:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683212746; x=1685804746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9SIzfOyT/36LPUiUVaXy7e6tRKfNiByyzcagojCb80=;
        b=dm6UvR8jz+ISEImBOrrGtRAj5ar6dhqYAogozCtXhpVr5uh4PFHaGB9h+tYHOW718z
         o3O7amPqI9AwxLM345FFQAitLOssF5/FAnfFFuU4rEfqmoFUSAiOyKTUF4Y7LKLanIrE
         Qj36r9V9upwA0VaCQWmyYwkUSnREXklfnY+GExzvTuR8YxrHECu7gHvXZk2bdc69zRCW
         1h8jnlHsR/j/iVaSFyAiEEpzwyyTWhnDulzK19RVWeMPqf5H5Hz3O8JSKCzWIyKWfKku
         SNYBOr6BMXN6j+I2iJqdUT6kr1VuxlEcn6OmxVxG8oWLnghamo1hTFSoS+dcuB8dv9ni
         DKcg==
X-Gm-Message-State: AC+VfDyISk/GZgAywKHVKp9orwIeqHETlrRW8Ru0rHvBYHWxeHlOgB8e
        aS6ctpZxo2tigX1zH6c6quwFfW0xF/ZiyufVkJP/NxwX7rfbX2grKrK7x5Jq11VNyVTAsR3ccI9
        Nr/MAggREls0r
X-Received: by 2002:a05:6214:625:b0:61b:5bcd:db57 with SMTP id a5-20020a056214062500b0061b5bcddb57mr14789682qvx.48.1683212746700;
        Thu, 04 May 2023 08:05:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ojJH3+qlpvL2ycgU482FJ67VO+1fJXqXVmFYjHvv90cAsNY46tRE4C0IiONAFYmsDYhANVA==
X-Received: by 2002:a05:6214:625:b0:61b:5bcd:db57 with SMTP id a5-20020a056214062500b0061b5bcddb57mr14789645qvx.48.1683212746351;
        Thu, 04 May 2023 08:05:46 -0700 (PDT)
Received: from ?IPV6:2a01:cb19:853d:fa00:c28a:3e3d:34f3:3891? ([2a01:cb19:853d:fa00:c28a:3e3d:34f3:3891])
        by smtp.gmail.com with ESMTPSA id m18-20020a0cbf12000000b0060f5a75b750sm8507842qvi.99.2023.05.04.08.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 08:05:45 -0700 (PDT)
Message-ID: <2b6567ca-3e0e-02ea-0f5e-f7121c8d4b2c@redhat.com>
Date:   Thu, 4 May 2023 17:05:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] vfio/pci: demote hiding ecap messages to debug level
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, Bo Liu <liubo03@inspur.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        kvm@vger.kernel.org
References: <20230504131654.24922-1-oleksandr@natalenko.name>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230504131654.24922-1-oleksandr@natalenko.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/23 15:16, Oleksandr Natalenko wrote:
> Seeing a burst of messages like this:
> 
>      vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
>      vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
>      vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
>      vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
>      vfio-pci 0000:98:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
>      vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
>      vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
>      vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
>      vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
>      vfio-pci 0000:b1:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
> 
> is of little to no value for an ordinary user.
> 
> Hence, use pci_dbg() instead of pci_info().
> 
> Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>


Acked-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.

> ---
>   drivers/vfio/pci/vfio_pci_config.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 948cdd464f4e..dd8dda14e701 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1643,7 +1643,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>   		}
>   
>   		if (!len) {
> -			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
> +			pci_dbg(pdev, "%s: hiding ecap %#x@%#x\n",
>   				 __func__, ecap, epos);
>   
>   			/* If not the first in the chain, we can skip over it */

