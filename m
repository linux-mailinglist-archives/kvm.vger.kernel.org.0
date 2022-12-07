Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE83A6463F5
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 23:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiLGWTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 17:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLGWTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 17:19:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B560C61744
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 14:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670451535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcPO5nWIfSaHuHCf7SJiLEUmz6tEg6ejzHZyOaoxES8=;
        b=EBUSFovRvqp8hTz89hWrFeNFxfSz5+j7dqbodabI74yu8OyU9vdOzOAQDXpmZ9TQo7U35j
        cVYB5cWvzj1olOKca70MLYrUamWygjYpXrSeg+zmQHQhQtd3meu9uWti11vpCwaQQRN6HR
        fLvB1zfbXVzekLD8tPF0h/rTyQ1ggp0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-0R9uUAXKN0GLckLi4NTSwQ-1; Wed, 07 Dec 2022 17:18:54 -0500
X-MC-Unique: 0R9uUAXKN0GLckLi4NTSwQ-1
Received: by mail-il1-f198.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so10670223ilh.22
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 14:18:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xcPO5nWIfSaHuHCf7SJiLEUmz6tEg6ejzHZyOaoxES8=;
        b=M3eNWJ52vqVmVb1md6Bu+tc9V+lHhNbIzplMFCzEX08VnME+nhVVY8z6jckHTzCa1r
         BXdSBas4AIGrFNSfzJjuEsmgbtT/qq1PdxvHmNQ+FZfz4mDxmXTmDjb70Zd5LJUPle9R
         cwT1+lYHvsqMHKDg2uFPcSzlrp88NYxWAFuwuBpsGWkwAnyUad+kRnp5VK6Xi1zkMxsa
         qHt/hiJz4uhD03Vpgdd6VoHG3RQS7qL9GuskAE8yFvNd6HaDfYJTwlFpnDM8595RHTjz
         Td8YRfTmiVZGOqueU52LfSd7sSdGcPFHWqe7QXnGw/R93evMrTX6A7Eql4xD+xue3Sdx
         JOxg==
X-Gm-Message-State: ANoB5pkJnoB9Hz0Nj5mRyyxMH5dtgZyH4f2wclCnrLX/mg4e2T28sjHN
        IsdNi0yyq/NPUaTMIV+gF8SFCrB50n3P24yDTpfYT0ypC+J366S+bXyIfHnukyyHzXtCR+zblvk
        atuMTpha28OKu
X-Received: by 2002:a5d:9911:0:b0:6db:1f90:7e62 with SMTP id x17-20020a5d9911000000b006db1f907e62mr33636506iol.107.1670451533326;
        Wed, 07 Dec 2022 14:18:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf44yZRRdAHJFKCQepR4Jo+HtGxmCPKxgdqTksGH8Ba8MGs9iIFhk6pH+RsvcfMriI0DvO3eBQ==
X-Received: by 2002:a5d:9911:0:b0:6db:1f90:7e62 with SMTP id x17-20020a5d9911000000b006db1f907e62mr33636502iol.107.1670451533060;
        Wed, 07 Dec 2022 14:18:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o9-20020a92dac9000000b0030249f369f7sm202098ilq.82.2022.12.07.14.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 14:18:52 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:18:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <kwankhede@nvidia.com>, <kraxel@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] samples: vfio-mdev: Fix missing pci_disable_device() in
 mdpy_fb_probe()
Message-ID: <20221207151850.07d7a5e2.alex.williamson@redhat.com>
In-Reply-To: <20221207072128.30344-1-shangxiaojing@huawei.com>
References: <20221207072128.30344-1-shangxiaojing@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Dec 2022 15:21:28 +0800
Shang XiaoJing <shangxiaojing@huawei.com> wrote:

> Add missing pci_disable_device() in fail path of mdpy_fb_probe().
> 
> Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  samples/vfio-mdev/mdpy-fb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 9ec93d90e8a5..a7b3a30058e5 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -109,7 +109,7 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>  
>  	ret = pci_request_regions(pdev, "mdpy-fb");
>  	if (ret < 0)
> -		return ret;
> +		goto err_disable_dev;
>  
>  	pci_read_config_dword(pdev, MDPY_FORMAT_OFFSET, &format);
>  	pci_read_config_dword(pdev, MDPY_WIDTH_OFFSET,	&width);
> @@ -191,6 +191,9 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>  err_release_regions:
>  	pci_release_regions(pdev);
>  
> +err_disable_dev:
> +	pci_disable_device(pdev);
> +
>  	return ret;
>  }
>  

What about the same in the .remove callback?  Seems that all but the
framebuffer unwind is missing in the remove path.  Thanks,

Alex

