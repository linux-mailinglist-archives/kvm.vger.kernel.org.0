Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82490687A54
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjBBKeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 05:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjBBKeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 05:34:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FF75AB65
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 02:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675333987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gzY8WLXPZBGvGs13fwLVzvdB3zWOPAiALRIUHU5zbPE=;
        b=CfB6S1qDWZWlLjAMsCYvZyYVKoeoJFyZgsljldpTzI7HxRUq4KbNVnLrpakBMcCRX7nKez
        0UyMvBwxALff+b4ivie8OR8W5AIrUArp+CVngKaHySZrzS0ER+PIMZYRioh1aGANfZtiWw
        KOin9SN4HzjZb8mpSTQEnv3OfXM92x8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-12-B0RYC10_M8OwpEInZk6tpQ-1; Thu, 02 Feb 2023 05:33:06 -0500
X-MC-Unique: B0RYC10_M8OwpEInZk6tpQ-1
Received: by mail-wm1-f69.google.com with SMTP id bg25-20020a05600c3c9900b003da1f6a7b2dso2607979wmb.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 02:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzY8WLXPZBGvGs13fwLVzvdB3zWOPAiALRIUHU5zbPE=;
        b=itfUe3CIkOs+teimXb0m6w6/OK0gt9/N89coexte4zeh+g1r14tGRb75oKTdoPYUO7
         BpRIbm7pdnfb31iagaUUlKpJ8M/MkiEi/t7Rnf6cK7j9qZIbMPnKha69zjThRcs3PITK
         OsQOfaYACHgvdYqpt9WQadLefLtBq6UfQ2kbsL/eRiQT84ZC0Mf99pldP2ElI2bToFeB
         pOFgHKXxd2Jhl36GUTBIjwAQVmpyqwScTK8kO6bk/kIqLUXvMg8vtH7V6pVqOSTLynl9
         aNEQlsqAAJtHAvvioVUwdmH8klB/HyMujq9zhMRvzeOQ/pjGd+vnI5Gq2qU9HhBM98b1
         UjVA==
X-Gm-Message-State: AO0yUKWIRhn68gkwlUtkgrvNQRObGHVlRhUohC6CIgY9rsAIsqqvDlSC
        pEp3iuTen6JLedrjH1PlRNNvkbj6X+oywyrzFNQESzfs+W//Socgt5Ln44pyeIG3SXuDGabo91Z
        KJjOhzNxBmLx5
X-Received: by 2002:a05:600c:4e4e:b0:3d2:bca5:10a2 with SMTP id e14-20020a05600c4e4e00b003d2bca510a2mr5273853wmq.22.1675333984808;
        Thu, 02 Feb 2023 02:33:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/fHx8aUDAB0froK+lS+HWGLVJXUV/PDw9YBioywtgcQQqxlZhTuxBLUkkhhVkUE0oQ07IROQ==
X-Received: by 2002:a05:600c:4e4e:b0:3d2:bca5:10a2 with SMTP id e14-20020a05600c4e4e00b003d2bca510a2mr5273840wmq.22.1675333984603;
        Thu, 02 Feb 2023 02:33:04 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id p11-20020a1c544b000000b003dc4fd6e624sm4452688wmi.19.2023.02.02.02.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:33:03 -0800 (PST)
Date:   Thu, 2 Feb 2023 05:32:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/7] vringh: fix a typo in comments for vringh_kiov
Message-ID: <20230202053204-mutt-send-email-mst@kernel.org>
References: <20230202090934.549556-1-mie@igel.co.jp>
 <20230202090934.549556-2-mie@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202090934.549556-2-mie@igel.co.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023 at 06:09:28PM +0900, Shunsuke Mie wrote:
> Probably it is a simple copy error from struct vring_iov.
> 
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

Drop the fixes tag pls it's not really relevantfor comments.
But the patch is correct, pls submit separately we can
already apply this.

> ---
>  include/linux/vringh.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 212892cf9822..1991a02c6431 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -92,7 +92,7 @@ struct vringh_iov {
>  };
>  
>  /**
> - * struct vringh_iov - kvec mangler.
> + * struct vringh_kiov - kvec mangler.
>   *
>   * Mangles kvec in place, and restores it.
>   * Remaining data is iov + i, of used - i elements.
> -- 
> 2.25.1

