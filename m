Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8303470A630
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjETHmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 May 2023 03:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjETHml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 May 2023 03:42:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B51A5
        for <kvm@vger.kernel.org>; Sat, 20 May 2023 00:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684568511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0AguDfj6JP2qnVVf1ZTLGQH6Es2HVgXZKNmzU3nM3g=;
        b=PZti+F83cztvMI1fURyVUN9mrHoGj9xRHnEKI7YvJcCKumUKB74DJdgmRsgkkqS3x9+9mi
        c1DenXj/UMWxyEKkZ0VWGzuxYoA6X1ppf2TTgs3sKjDkyKdi29KbRwu4xT4t8AK7rVPcaz
        UlnPYG6Gw8vy1HhN9eUWTrSr66w3xnc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-uUEN5emcOkCG34VfflMQ2w-1; Sat, 20 May 2023 03:41:49 -0400
X-MC-Unique: uUEN5emcOkCG34VfflMQ2w-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-534107e73cfso2344809a12.1
        for <kvm@vger.kernel.org>; Sat, 20 May 2023 00:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684568508; x=1687160508;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0AguDfj6JP2qnVVf1ZTLGQH6Es2HVgXZKNmzU3nM3g=;
        b=cN76oM5QCguK9tPGOmuGzc1CMRCqnKX1RadtxTiCeDhup37jCrP48xH8jPmt4kyiFc
         3gzCxKwj9uVPOYmNcGEHlYJApdpLl4J6nBzPLZuxe3Pke97FrJD7EtIjQGn0kA+ADeyS
         j4/7AiEviunhSGj8t0UxbngzCYg5SZz4BKWU0vp26rCJxGJFO8lMeI+Ov9Hy+JLjjigX
         PPWE0K+RRSwlZdCIs2faoO2BfNb9+e+ZKp2VAWdfDRBwscSM/rJxAGUK2uHoQMXIhxz5
         JRSGkupcWxQvCkroCeMZ+WWLRQfpxQgzDrpvUml//LIxh8I16WpUmCAo+fPMq3bt8Jzx
         femg==
X-Gm-Message-State: AC+VfDzXcNc7RkQ+n6GAlyVCgbuxGw2d2vi6+NWHUwVIlvMOsMmKtO73
        cXwPRfRnhDKunnxSeQMS5YARrGjdBytH/MvF7sbUkx8H/OsSLS7hc+lyReynRAgXYVCmoNiE6RE
        Hghi4l3ej3g/G
X-Received: by 2002:a05:6a20:3d83:b0:104:beb4:da38 with SMTP id s3-20020a056a203d8300b00104beb4da38mr4804461pzi.35.1684568508557;
        Sat, 20 May 2023 00:41:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6eXTRhEhp3x78rhFMpORaXutxEGfsp/UfsShsbpXjJZiG21s3ATningAfFDQyDpwJnRCAT3A==
X-Received: by 2002:a05:6a20:3d83:b0:104:beb4:da38 with SMTP id s3-20020a056a203d8300b00104beb4da38mr4804442pzi.35.1684568508246;
        Sat, 20 May 2023 00:41:48 -0700 (PDT)
Received: from [10.72.12.17] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79213000000b00639eae8816asm722737pfo.130.2023.05.20.00.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 May 2023 00:41:47 -0700 (PDT)
From:   Yanghang Luy <yanghliu@redhat.com>
X-Google-Original-From: Yanghang Luy <yanghliu@gapps.redhat.com>
Message-ID: <ce2e4e15-d4a5-fb48-1b2f-4f70c623b1b3@gapps.redhat.com>
Date:   Sat, 20 May 2023 15:41:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] vfio/pci: demote hiding ecap messages to debug level
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, Bo Liu <liubo03@inspur.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        kvm@vger.kernel.org
References: <20230504131654.24922-1-oleksandr@natalenko.name>
In-Reply-To: <20230504131654.24922-1-oleksandr@natalenko.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: YangHang Liu <yanghliu@redhat.com>

On 5/4/2023 9:16 PM, Oleksandr Natalenko wrote:
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

