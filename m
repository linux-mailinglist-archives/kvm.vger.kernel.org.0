Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8A682979
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjAaJu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjAaJuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:50:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987215B9D
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675158566;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jfaQ85a1dAVfhNsu1a2URYhGm3l71cfWadA+896tDVg=;
        b=KEqLK5k5ndaUjbI6mtHa80BfWnAj7V9PgOIdkCjN7vx+N94E5ekiyxwd8igB0ywJ8EDaiF
        RsMO8BYf+qdwJqvw+YNJnHpXSndIelNbwrND7UATsvb/y3+Y0BnYfDswRI4ml6zKZ1gBJm
        dPBCU0+8XJZGeK7Sid3bV6wLV8ZTJKQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-XGBR4uT5P3Cz89vpTxsSYg-1; Tue, 31 Jan 2023 04:49:25 -0500
X-MC-Unique: XGBR4uT5P3Cz89vpTxsSYg-1
Received: by mail-qk1-f200.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso8829941qko.11
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:49:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfaQ85a1dAVfhNsu1a2URYhGm3l71cfWadA+896tDVg=;
        b=pz7eoh1MkT+Z91nj+GenDYv68Sh2J8P4kAcBArlVAVnl2gP6FJMMz7rJtSrE2QJwcs
         xFSC8VuhmG57MmIqL2zpHVuy1AQoH0Oo7UyulZ47M5C2IRQqP6bSAUOVSOxMliMUfoBw
         4NuceqilnzxxEGnXpwwGqfTTmGPZetnHAyI2OW7f8NroB77j3aHw71FATyZscagy/sEi
         Jnl36ahHZU/ukqO6n+ixRDo1gAnDQKtIwXUQVvzn4f9fIREfUjUP367hA730dFo5UG32
         YBhKqCbg86hBENeF3/JRaU4nSq+7AyyO6fjvDAaSYThEGRqtzWpFdWHTJDu330Sj1LNi
         /9yw==
X-Gm-Message-State: AO0yUKUGWXUnPOj0Or3KTKIvB/+uVJidunIGhtbEG1HeumUHQM/1OlOH
        J/Zq1AofQlx7geofzQnBoMiJ8ljnf3sZ9sRl0j+ZNg3f8Ok9smgyf7bUfhtXDqEmawG5rju02Oo
        Qpq1faLqoZnsI
X-Received: by 2002:a0c:ea4c:0:b0:537:6a5d:4899 with SMTP id u12-20020a0cea4c000000b005376a5d4899mr30409077qvp.29.1675158564084;
        Tue, 31 Jan 2023 01:49:24 -0800 (PST)
X-Google-Smtp-Source: AK7set/SUd7wTQ5Au07UhYfX1m0HbSmQEcQjHvhILDcjUglU5votIYONG/eo7Ch8QW4jq+sJkQeRgQ==
X-Received: by 2002:a0c:ea4c:0:b0:537:6a5d:4899 with SMTP id u12-20020a0cea4c000000b005376a5d4899mr30409060qvp.29.1675158563856;
        Tue, 31 Jan 2023 01:49:23 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j7-20020a37b907000000b00706c1fc62desm9643587qkf.112.2023.01.31.01.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 01:49:22 -0800 (PST)
Message-ID: <c946d31d-3696-510b-17b9-9ac9b361b7bf@redhat.com>
Date:   Tue, 31 Jan 2023 10:49:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2] vfio: platform: ignore missing reset if disabled at
 module init
Content-Language: en-US
To:     Tomasz Duszynski <tduszynski@marvell.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     jerinj@marvell.com
References: <20230131083349.2027189-1-tduszynski@marvell.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230131083349.2027189-1-tduszynski@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tomasz,

On 1/31/23 09:33, Tomasz Duszynski wrote:
> If reset requirement was relaxed via module parameter errors caused by
> missing reset should not be propagated down to the vfio core.
> Otherwise initialization will fail.
>
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Fixes: 5f6c7e0831a1 ("vfio/platform: Use the new device life cycle helpers")
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
> v2:
> - return directly instead of using ternary to do that
>
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
> --
> 2.34.1
>

