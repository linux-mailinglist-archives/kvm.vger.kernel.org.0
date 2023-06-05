Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984FB72220C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjFEJXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjFEJXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:23:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D642100
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 02:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685956955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omhUqTb7xYQDiZQy1uwi0ZZ5Nu00iwE+U7iltSb539U=;
        b=XZRVMUYJ8jH3Vn8FT3DyH8noV3XaFU57jCCVP1ExyrCbCUuvLwnvbZrNm1qGntHBKJm9x2
        W+f2NNHa0NxAZXwcNhsFcjIr9wFFFGee8D4wTiJdhwNcngNY0ileOhgzhd43JzqbeIQjhJ
        Vb8nakNydiobGpfmJKMRJm0BbtSEX9s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-l8f64IkpO6WeCeOaau3-jw-1; Mon, 05 Jun 2023 05:22:34 -0400
X-MC-Unique: l8f64IkpO6WeCeOaau3-jw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ae56a42cfso2434233f8f.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 02:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685956953; x=1688548953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omhUqTb7xYQDiZQy1uwi0ZZ5Nu00iwE+U7iltSb539U=;
        b=RzHebaC6BbC8Kawiyu0gkb/5aWJcEhIHz6Im4jfxYD+e5IKlDx+G/w/Jgz6VbvX2VE
         wxrsW/B/AIAW0Ie8VUBIxq/NfLOwREu5LpxeCBfIg7n5RXoKCefeXRFYiW7kKesaTssm
         AoZxEIBHk5AB8tEaBpYBNe6Bq2YILJbAMlujBEUia6hq6gUVedpwcVTjzhgW3PrSbpv3
         QX7NO5BZg2AOieLvXaWR1xnGp/9mfqVfvVidqUNsAMxVhADVMJ6JGvMW0AzYm9WmcEV/
         hqbcxMjGFJhaJvjAvlyV1Xi7ZUDoEy22rZ6iJomOTei3/R7cIhhfRPCWQaPFtlQ5C2kb
         n0SA==
X-Gm-Message-State: AC+VfDypl4XCqrcwisRUaogttfTp6Jv98BGqvwxFLpSJY7LAC5y4Sfud
        8xwnil1LzdITjlrEYhdj1Qf/N9HPg/CK2TwdfC2wTL4oHHXbZ/qwho0lTqzTJVn+WUoyXifs9bC
        D/+stLaUOdZCfWb7PmFAp
X-Received: by 2002:a05:6000:11c3:b0:30a:3498:a360 with SMTP id i3-20020a05600011c300b0030a3498a360mr4999475wrx.24.1685956952878;
        Mon, 05 Jun 2023 02:22:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Wsq6oNUCYUKBl/iyJBWx/rbc0n0wbJCLOeJg+SlkxdFjfNz49dt4vGjV54oOeNQGgoxIrEA==
X-Received: by 2002:a05:6000:11c3:b0:30a:3498:a360 with SMTP id i3-20020a05600011c300b0030a3498a360mr4999469wrx.24.1685956952701;
        Mon, 05 Jun 2023 02:22:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id a7-20020adffb87000000b002ca864b807csm9231073wrr.0.2023.06.05.02.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:22:32 -0700 (PDT)
Message-ID: <ef251c8e-3795-7d18-5444-00ff96fceb87@redhat.com>
Date:   Mon, 5 Jun 2023 11:22:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] vfio/fsl: Create Kconfig sub-menu
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, diana.craciun@oss.nxp.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-4-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230602213315.2521442-4-alex.williamson@redhat.com>
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

On 6/2/23 23:33, Alex Williamson wrote:
> For consistency with pci and platform, push the vfio-fsl-mc option into a
> sub-menu.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.

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
>   config VFIO_FSL_MC
>   	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>   	depends on FSL_MC_BUS
> @@ -8,3 +10,5 @@ config VFIO_FSL_MC
>   	  fsl-mc bus devices using the VFIO framework.
>   
>   	  If you don't know what to do here, say N.
> +
> +endmenu

