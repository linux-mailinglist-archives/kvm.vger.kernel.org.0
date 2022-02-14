Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4F4B522B
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiBNNwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:52:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiBNNwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:52:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 222012BE5
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644846751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ki/wER03qd3meQZcT6gUT0hSky9pIx6Rl1y6xrUzyac=;
        b=aEuGQNRy0W9Nq/6XDoxBGi77P3nqm5un14+eHiaBvHU8VCqDfyhN3uL7dndXVy0SZBtV30
        h8BpLSHtNNoUeJ/DWkljqDi5lOVdqEOzR+jjtwl1L0ze1prOFwNN8Wr092BUs2ojSCfBxA
        zSUD/Ijp0FiGtkEc3l4q8XPzz7OLoUc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-A0jT0exeNjaHjFgVH5ukBA-1; Mon, 14 Feb 2022 08:52:30 -0500
X-MC-Unique: A0jT0exeNjaHjFgVH5ukBA-1
Received: by mail-ed1-f70.google.com with SMTP id f6-20020a0564021e8600b0040f662b99ffso10274838edf.7
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ki/wER03qd3meQZcT6gUT0hSky9pIx6Rl1y6xrUzyac=;
        b=eABdh8HVqu8semwy0O1pdoKJ/uRDYZW2aRn9EkMTIOUP4juVbZ789zTfNlm9H+cLWm
         rHlJpvMW3xMf29w+cnBEpXkAZFEUzOPXgXWA/xM77GJmTc/CbvcZLMLLJoKqfhJOpCSM
         MFMhDSyAoDzIa4QFOUbDcFgZSk7ihlX8bW5hTUeBqJOc50cOsVkpNQsVKOidjqeyhnoH
         YveXZlJifAy0UfvrAyj9dPs9OyWSn5TOITC9APKiaQHP2f6MMU0lzKbRP1sGhgAUiZOb
         FqYjCns21l/cfObWv1inKmVJv7Dc2hvSW38fbtiTvEq8h6HqfMilBloLNTDscBlmVZSx
         RQGw==
X-Gm-Message-State: AOAM532tbrpcQBBrkxfXFki6xc8pZPV2sE9dqTIXP3Ou2n/ltbrMBRa5
        u/s0QZ6jepdaiE7UPi0ph2qQL4WhekQt3y/Wk8RIqKlqKSImw+vArf6TK7C7+WMasCgZuZ1UnB9
        dY+M8xv+5HelA
X-Received: by 2002:a17:906:5356:: with SMTP id j22mr1994080ejo.602.1644846748818;
        Mon, 14 Feb 2022 05:52:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyc9kXMgnWVii6NbBlW2fSTXeIAgQPicCpxOldzqSk6bNVhjUOBmkEChueprSuDmDlx0HrTHg==
X-Received: by 2002:a17:906:5356:: with SMTP id j22mr1994064ejo.602.1644846748559;
        Mon, 14 Feb 2022 05:52:28 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id p25sm2967590ejn.33.2022.02.14.05.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 05:52:28 -0800 (PST)
Date:   Mon, 14 Feb 2022 14:52:26 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220214135226.joxzj2tgg244wl6n@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214120506.30617-1-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 12:05:06PM +0000, Alexandru Elisei wrote:
> The "linux,initrd-start" and "linux,initrd-end" properties encode the start
> and end address of the initrd. The size of the address is encoded in the
> root node #address-cells property and can be 1 cell (32 bits) or 2 cells
> (64 bits). Add support for parsing a 64 bit address.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/devicetree.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 409d18bedbba..7cf64309a912 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
>  int dt_get_initrd(const char **initrd, u32 *size)
>  {
>  	const struct fdt_property *prop;
> -	const char *start, *end;
> +	u64 start, end;
>  	int node, len;
>  	u32 *data;
>  
> @@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
>  	if (!prop)
>  		return len;
>  	data = (u32 *)prop->data;
> -	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
> +	start = fdt32_to_cpu(*data);
> +	if (len == 8) {
> +		data++;
> +		start = (start << 32) | fdt32_to_cpu(*data);
> +	}
>  
>  	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
>  	if (!prop) {
> @@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
>  		return len;
>  	}
>  	data = (u32 *)prop->data;
> -	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
> +	end = fdt32_to_cpu(*data);
> +	if (len == 8) {
> +		data++;
> +		end = (end << 32) | fdt32_to_cpu(*data);
> +	}
>  
> -	*initrd = start;
> -	*size = (unsigned long)end - (unsigned long)start;
> +	*initrd = (char *)start;
> +	*size = end - start;
>  
>  	return 0;
>  }
> -- 
> 2.35.1
>

I added this patch on

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 7cf64309a912..fa8399a7513d 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -305,6 +305,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
        data = (u32 *)prop->data;
        start = fdt32_to_cpu(*data);
        if (len == 8) {
+               assert(sizeof(long) == 8);
                data++;
                start = (start << 32) | fdt32_to_cpu(*data);
        }
@@ -321,7 +322,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
                end = (end << 32) | fdt32_to_cpu(*data);
        }
 
-       *initrd = (char *)start;
+       *initrd = (char *)(unsigned long)start;
        *size = end - start;
 
        return 0;


To fix compilation on 32-bit arm.


And now merged through misc/queue.

Thanks,
drew

