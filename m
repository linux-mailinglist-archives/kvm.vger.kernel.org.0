Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17F3655102
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiLWN3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 08:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbiLWN3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 08:29:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E712089
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 05:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671802117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNUnkJqBrm1AuFrEX+JHLPZilbCOMaZVyEFbDJI2g7I=;
        b=hEbGTuyjr7zXLamz+exXDpYQGuvc6G0dwwpv8DEqdS+0wlf6EoBuYJ0fpRM8oGaqrV/1nn
        k9axvxBJj9H/XDNUWeWMbN8Kz5vXT2+cZC9khRwUnb65bvWfxLeCT1EV5MVQdI8/iIpKij
        dEEzlrL736L/x78zi2p4IqCozgH/hic=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-NmAeM7l-OV6RI9Dzvs3QIQ-1; Fri, 23 Dec 2022 08:28:36 -0500
X-MC-Unique: NmAeM7l-OV6RI9Dzvs3QIQ-1
Received: by mail-il1-f197.google.com with SMTP id h24-20020a056e021d9800b0030be8a5dd68so1201303ila.13
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 05:28:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNUnkJqBrm1AuFrEX+JHLPZilbCOMaZVyEFbDJI2g7I=;
        b=fVBqnn+qQMoyGyglVWPG5wTyMAEom0Z96KBPbHc5/Toh5h02aY6G6prEE6kyog/75P
         pEWleORRBgEjSUF33uiEPv9S8bRHq9rKdn4OBOaLjmJSLJOGci8WxV9LuAKGGJKtw8Ci
         gQC0JLa7zZpLyRu2lMLmN2XGD5ZT35RxXWiOnzzw4xmOySnryILTca9k0BCPPFlRD9O9
         MdzlnJR5kzxw6+2eunbEIp34450iTuio1DOvuM9Eop21tv/Ce/lp8XQiKzajBs/DMICo
         wtwHtMP6zXE3Lttf5EymxL+PEZn/G+SjGdTXYGml4Exr3qtcHFpEZ7UVW6JhO+3GyHRu
         ztHw==
X-Gm-Message-State: AFqh2kp67z/NmkJV9kMCGfv0Ks7NHWaWWe7uVveSSO8X0i70Vv8VF9+T
        IXqDmnMZSZwTlLdQwT4HJCVO5JtikwPSP52ogT+2wXt1ZFHSLY2RTC9/Yyca5CVSFocgPmAHJPq
        0Og0Y+Fw01ZUT
X-Received: by 2002:a05:6e02:1bc5:b0:30b:d9ab:2ae0 with SMTP id x5-20020a056e021bc500b0030bd9ab2ae0mr6309654ilv.4.1671802115687;
        Fri, 23 Dec 2022 05:28:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtEC8Ar7qXJYHKn7GA1kf3ebyVYBwAe58xi0ilB+Jc00hf7Y1WK+llLlqeqENm72qHM8LJcgw==
X-Received: by 2002:a05:6e02:1bc5:b0:30b:d9ab:2ae0 with SMTP id x5-20020a056e021bc500b0030bd9ab2ae0mr6309642ilv.4.1671802115435;
        Fri, 23 Dec 2022 05:28:35 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e1-20020a92d741000000b00302a7165d9bsm1033153ilq.53.2022.12.23.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 05:28:34 -0800 (PST)
Date:   Fri, 23 Dec 2022 06:28:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio_iommu_type1: increase the validity check of
 function parameters
Message-ID: <20221223062832.069595f1.alex.williamson@redhat.com>
In-Reply-To: <20221223072418.3728-1-kunyu@nfschina.com>
References: <20221223072418.3728-1-kunyu@nfschina.com>
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

On Fri, 23 Dec 2022 15:24:18 +0800
Li kunyu <kunyu@nfschina.com> wrote:

> Added validity check for count variable, return if count variable does 
> not meet the execution condition (do not execute mutex_lock and 
> mutex_unlock function).
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe98c00..9bdf96d932e4 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -3137,6 +3137,9 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
>  	int ret = 0;
>  	size_t done;
>  
> +	if (count <= 0)
> +		return ret;
> +
>  	mutex_lock(&iommu->lock);
>  	while (count > 0) {
>  		ret = vfio_iommu_type1_dma_rw_chunk(iommu, user_iova, data,

This is only optimizing a case that shouldn't exist, the return value
is the same.  Callers should be smart enough not to call the function
with such values.  As an internal API, we assume reasonable behavior by
the caller.  Thanks,

Alex

