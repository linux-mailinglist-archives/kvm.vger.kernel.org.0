Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA67278BF
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjFHH03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbjFHH02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EB71BEB
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686209130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQgryE09vT80Eu7xZQdbepp/P91F23fI9IC3Yf7nVhc=;
        b=GiIgmSt7IqvBavj4doJoYfC9/lMdkzNMuUlqeaaeDXcWJIlvgtfvQTkg8eTTUTaeex5LQB
        ZBoLscaXdx7X+fcRsy/qyjOaC83Ku82FYdx8msqEb5psd3lKDROwGwvK7hsLw25d3w5Mcv
        a/ShCmlglNq5rQuAZNAChTn8k7G5AT4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-_ZEbN7kEPhqn_Hpv2g2Feg-1; Thu, 08 Jun 2023 03:25:29 -0400
X-MC-Unique: _ZEbN7kEPhqn_Hpv2g2Feg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30c5d31b567so123355f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686209128; x=1688801128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQgryE09vT80Eu7xZQdbepp/P91F23fI9IC3Yf7nVhc=;
        b=A55tWqJMe3hyqqp5GEvyCl5vwVN12fXt+ud68J1nR3J3jslk34n6ceYb/u8jzDXuyL
         IvuRmMQQM6DzFLU1XzngzvqyBdudLL7uIC+ox16WYiXHb8xP6DHYT5zsU54CxMAbtfhy
         8wjDqk/gwSVTSp0alaM55hitUvKWHmkRq5OGgnPEcWtZ+S0CiuiYRXIry0/azkDoCbd7
         efZMgw/6xk/rBwLOJ8LIqwS+itQJPoxVnIeB3fb1R103g8IEYCDeRP4hcoFu/tM60gWc
         ZZiUqJ4dPDxUKLIKDaFo8TMj+X+pARyCMwcWhVrvGr/H7SE9H5AdUJFBNGPd+BpFitLD
         MLVQ==
X-Gm-Message-State: AC+VfDzdamreZSr2Spz3NckdIsbYEY/5ClQP5NhmdbrqHBhZC/cx9OST
        MRj43eP8uN9lG7WUVxLHqVe4/qVbyZJ8vRswHDzOUIiDxelm+YCQNU732IjIDXZxBZFbid6pkz4
        9AR0/GrUY0Onq
X-Received: by 2002:adf:f1d2:0:b0:309:5029:b071 with SMTP id z18-20020adff1d2000000b003095029b071mr6213263wro.45.1686209127961;
        Thu, 08 Jun 2023 00:25:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6jFEKwWuY/s6j9vUnOjxVzBS7STTB0OPeOfjZw6cGPbIqejnT+Vq8uMy5eXRAgZHhqzNkyEQ==
X-Received: by 2002:adf:f1d2:0:b0:309:5029:b071 with SMTP id z18-20020adff1d2000000b003095029b071mr6213247wro.45.1686209127696;
        Thu, 08 Jun 2023 00:25:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:9e2:9000:9283:b79f:cbb3:327a? ([2a01:e0a:9e2:9000:9283:b79f:cbb3:327a])
        by smtp.gmail.com with ESMTPSA id t18-20020adfeb92000000b003093a412310sm640202wrn.92.2023.06.08.00.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 00:25:27 -0700 (PDT)
Message-ID: <d1722794-c0d3-1f7f-4195-334608165ff9@redhat.com>
Date:   Thu, 8 Jun 2023 09:25:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/3] vfio/fsl: Create Kconfig sub-menu
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, eric.auger@redhat.com, diana.craciun@oss.nxp.com
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
 <20230607230918.3157757-4-alex.williamson@redhat.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230607230918.3157757-4-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/23 01:09, Alex Williamson wrote:
> For consistency with pci and platform, push the vfio-fsl-mc option into a
> sub-menu.
> 
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/vfio/fsl-mc/Kconfig | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
> index 597d338c5c8a..d2757a1114aa 100644
> --- a/drivers/vfio/fsl-mc/Kconfig
> +++ b/drivers/vfio/fsl-mc/Kconfig
> @@ -1,3 +1,5 @@
> +menu "VFIO support for FSL_MC bus devices"
> +

The menu entry can be empty on arches not supporting the FSL-MC bus.
I think this needs an extra :

	depends on ARM64 || COMPILE_TEST

Thanks,

C.


>   config VFIO_FSL_MC
>   	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>   	depends on FSL_MC_BUS
> @@ -8,3 +10,5 @@ config VFIO_FSL_MC
>   	  fsl-mc bus devices using the VFIO framework.
>   
>   	  If you don't know what to do here, say N.
> +
> +endmenu

