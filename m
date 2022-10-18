Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69DA6030F8
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJRQqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJRQqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:46:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9522E8C52
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666111564;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZP3yvTEQQM8pWfWWjNvcvdOOz/gh8bcKPbdVAik3fQ=;
        b=SelquGwYOU6J1rZnhrCVg48LK2X+QZy/f5HrimnYJTEAXDrP5Muf3K7hBwCqIqH00WNF7y
        9nefzf0zVFYXmGDwiOIxogtmhY9kOIgyAcQpUeb0YHkjglGfaARUV51qtaLnQfyLEQoiB5
        stoW0jNPB4aQX6B+TlEf5YMxZDzp/pY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-125-o-VsMidLPn-r8WpEWivpVQ-1; Tue, 18 Oct 2022 12:46:03 -0400
X-MC-Unique: o-VsMidLPn-r8WpEWivpVQ-1
Received: by mail-qv1-f71.google.com with SMTP id em2-20020ad44f82000000b004af5338777cso8957677qvb.4
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZP3yvTEQQM8pWfWWjNvcvdOOz/gh8bcKPbdVAik3fQ=;
        b=UUrP8zej90Q3gDtewcay1to0ggz4NcFOMCytmLvJeT6Go8p4rOXydGa8XwdmY2kXM6
         p1wuTOOi3dIW9lDqj7tdfdcwXG1HAKacJq9U+Fib/N5uBGn2nzXp5EiogecMIs/M1pyJ
         eyT3RGx5YeJwZ2Nwq1Yt5+EGs+wYJN/1ekY4OV2Yyy+OtNLvkorD7hiVoSfZj4myE9Dk
         MI7TdhT3LwVBhGad8SjU4Q2pa4UbRMGZvcrunt5izlmbwoXrBA62NI2FZm8ZB1ZfQ8QI
         zxVVdfvcx/tsmX7sOPg80Xy06sViqm3GRjjWC/gz9uwmHxyHHsxK29zD1rVloxC0M5ez
         pPfg==
X-Gm-Message-State: ACrzQf2sQ36fyKj3TvFkMq9U+LiL/Zzg1j4zzsRc5QG78R5XdLbvYwn9
        hL0YsidjV2NFwEmiLL4a9I0RfTEt1z/LC7cPPbYZgiUFxYzprR+Cubtaer/VOk/nAPH1cVqBBVW
        BaNw8LkxHzR7M
X-Received: by 2002:a0c:9122:0:b0:4b1:80fc:c405 with SMTP id q31-20020a0c9122000000b004b180fcc405mr3134938qvq.120.1666111562690;
        Tue, 18 Oct 2022 09:46:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5qRKddE7VWNwmZ5E6Sy6/79Fxdoo5cJ0pbCHMIAhFQSQw6AiGBLAstyLwyrj9w+PYdaDSKhg==
X-Received: by 2002:a0c:9122:0:b0:4b1:80fc:c405 with SMTP id q31-20020a0c9122000000b004b180fcc405mr3134927qvq.120.1666111562513;
        Tue, 18 Oct 2022 09:46:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l13-20020ac8148d000000b0039c72bb51f3sm2185059qtj.86.2022.10.18.09.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 09:46:01 -0700 (PDT)
Message-ID: <12a6fae1-c7c5-c531-fce7-1a57cf6122fa@redhat.com>
Date:   Tue, 18 Oct 2022 18:45:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] vfio: platform: Do not pass return buffer to ACPI _RST
 method
Content-Language: en-US
To:     Rafael Mendonca <rafaelmendsr@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sinan Kaya <okaya@codeaurora.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221018152825.891032-1-rafaelmendsr@gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20221018152825.891032-1-rafaelmendsr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Rafael,
On 10/18/22 17:28, Rafael Mendonca wrote:
> The ACPI _RST method has no return value, there's no need to pass a return
> buffer to acpi_evaluate_object().
>
> Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 55dc4f43c31e..1a0a238ffa35 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
>  				  const char **extra_dbg)
>  {
>  #ifdef CONFIG_ACPI
> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>  	struct device *dev = vdev->device;
>  	acpi_handle handle = ACPI_HANDLE(dev);
>  	acpi_status acpi_ret;
>  
> -	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
> +	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
>  	if (ACPI_FAILURE(acpi_ret)) {
>  		if (extra_dbg)
>  			*extra_dbg = acpi_format_exception(acpi_ret);

