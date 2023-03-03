Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD66A9884
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 14:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCCNgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 08:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjCCNgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 08:36:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3548E05
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 05:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677850496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gV7MqPvDqj2snihpI0yP/lftz0hNoQVzJTzsQ5ufjU=;
        b=bEObHUnYMKjVy4z2JIb/bebhwMuoM1rQ1RE/ZlTOK42Wbj9yMeCrrjaxVaRsTeVwa162oH
        C2/IUvn+W1vLC0f+Dzwzo0gkqwBLHl/w2sdncrs7FxHlQLY7nPizpHSj1bR1WpmodsmHRO
        ZEYMZQITAtpcP9MxCk6AuHpKpv8H7zc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-6ax1M51AP1S2QgJcHGS-gg-1; Fri, 03 Mar 2023 08:34:55 -0500
X-MC-Unique: 6ax1M51AP1S2QgJcHGS-gg-1
Received: by mail-il1-f200.google.com with SMTP id r13-20020a92c5ad000000b00316ecbf63c9so1323895ilt.13
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 05:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1gV7MqPvDqj2snihpI0yP/lftz0hNoQVzJTzsQ5ufjU=;
        b=pSG7+MR2g5KpaW0jDSp7JaeGMsb97MIbQ54XKzd0XnbamMRCoEKMYl1swZLM0cUQ9q
         Wqlw7Xc+OVlDQa3Ta3us8TeygbJzbKSDPvuY6yJsQDZCPt6OuNLhpbvNHCxIIR+LP7PG
         ja+TGwI2uXm1Xn25yuK2dTl2kclwQlumMGdd7pGS3zebgdd1bWixktvSuOTLod+hyA6s
         /63jAu2Ix8Vf7KzgGsXxQhR0WvmUdN9zLwi3uchqrQ3PHr3gAdq2e8SCK1tBETZX3z3r
         W+RHWEhsuyhkRRHY4lD+01JLYHt886nazCcasjZpje18v2wnDLqfHzCIhPIlLQ9hQ8iI
         HtPA==
X-Gm-Message-State: AO0yUKXjt0IiTwo5SpV21x5udJReupny4978lMTG3VCUan9ZAVovGHF5
        gt7RmG3ROu6+SiXKhupHpnTxN84VLMKDWoyx/1+sgEhi3AMljo20EzhqBfTCwv69Q/1LtnagYHM
        keq+8RpFhVaNO9CAUuw==
X-Received: by 2002:a05:6e02:1aa5:b0:315:3fe4:1d0a with SMTP id l5-20020a056e021aa500b003153fe41d0amr1140598ilv.0.1677850494794;
        Fri, 03 Mar 2023 05:34:54 -0800 (PST)
X-Google-Smtp-Source: AK7set/aaWqTxpui1Bzyvw6VRyfapx86btSs+aULifZj9cbu9AZzKRB1vn00Mu8KyoxPw+WHfk6Wuw==
X-Received: by 2002:a05:6e02:1aa5:b0:315:3fe4:1d0a with SMTP id l5-20020a056e021aa500b003153fe41d0amr1140585ilv.0.1677850494438;
        Fri, 03 Mar 2023 05:34:54 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e15-20020a056638020f00b003afc548c3cdsm701013jaq.166.2023.03.03.05.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 05:34:53 -0800 (PST)
Date:   Fri, 3 Mar 2023 06:34:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Mostafa Saleh <smostafa@google.com>
Cc:     eric.auger@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/platform: Fix reset_required behaviour
Message-ID: <20230303063451.1525d123.alex.williamson@redhat.com>
In-Reply-To: <20230303121151.3489618-1-smostafa@google.com>
References: <20230303121151.3489618-1-smostafa@google.com>
Organization: Red Hat
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

On Fri,  3 Mar 2023 12:11:52 +0000
Mostafa Saleh <smostafa@google.com> wrote:

> vfio_platform_device has a flag reset_required that can be set from
> module_param or vfio driver which indicates that reset is not a
> requirement and it bypasses related checks.
> 
> This was introduced and implemented in vfio_platform_probe_common in
> "b5add544d67 vfio, platform: make reset driver a requirement by default"
> 
> However, vfio_platform_probe_common was removed in
> "ac1237912fb vfio/amba: Use the new device life cycle helpers"
> 
> And new implementation added in vfio_platform_init_common in
> "5f6c7e0831a vfio/platform: Use the new device life cycle helpers"
> 
> which causes an error even if vfio-platform.reset_required=0, as it
> only guards printing and not the return as before.
> 
> This patch fixes this by returning 0 if there is no reset function
> for the device and reset_required=0. This is also consistent with
> checks in vfio_platform_open_device and vfio_platform_close_device.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 1a0a238ffa35..7325ff463cf0 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -650,10 +650,13 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
>  	mutex_init(&vdev->igate);
>  
>  	ret = vfio_platform_get_reset(vdev);
> -	if (ret && vdev->reset_required)
> +	if (ret && vdev->reset_required) {
>  		dev_err(dev, "No reset function found for device %s\n",
>  			vdev->name);
> -	return ret;
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_init_common);
>  

An identical patch has already accepted and merged for v6.3:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=168a9c91fe0a1180959b6394f4566de7080244b6

Thanks,
Alex

