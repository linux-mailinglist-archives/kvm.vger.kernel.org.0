Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D51C739FBF
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 13:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjFVLjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 07:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjFVLjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 07:39:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECE21BFC
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 04:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687433838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7SKEzo0tiPtjA/r8jOe2vPyIc6DKSYtWpFv1BZVSgU=;
        b=Et4xGHTBY5geu4WiDFyWr0DhpLyP73vfB026rF5OrfHiW8qUNFaOFrKwSjwBSDj2aZgIoq
        BGCdl1o84fq5xeBW5HQFzrczWyldj9rC8hlJ+0mWs6HuVT9JzONXw7BlLrq5xjeS9H8+Vl
        Nkr+wO/S6Q8010k1SpogzoXqoGnrcG0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-pR9rNSnFPpCDC1uFfbwwuw-1; Thu, 22 Jun 2023 07:37:17 -0400
X-MC-Unique: pR9rNSnFPpCDC1uFfbwwuw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-988e344bed9so328349566b.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 04:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687433836; x=1690025836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7SKEzo0tiPtjA/r8jOe2vPyIc6DKSYtWpFv1BZVSgU=;
        b=MC3e/A0ed6KsoXBDWWSUTWZlUXuTKj6zfnT9wYW/emE2GPz9QWe8VKegBSMd3g4Kh/
         z+sg7lFqwO7XHbtH6yzPrsbvRcvTwIUIsBhfQ6F9fMBgiUKmEREq/XPdWulIjJTUWyPo
         2U9uluEyBPp5Lcl3xjCSYeujlkmcoHiMNH3DNxAToJppetQY7vphpcDO5PEkCCBhkOba
         /ltqKySqwxfMYkd8mao7P/0rm9/O5n8Pn84moUsX9o9wpAtJ5j+g8n7qOE5XKq+ta7Kq
         EN/Duxj/mtbK7m+BZaA9ahuTnHdj5SD555/TxWn7uS757g1ouqS0G0Rj00xC+2aXivyt
         mnaA==
X-Gm-Message-State: AC+VfDxLa/XzxGNEeXkaeumhy6oEoD5ThlkCLi7zwhZZvWjoXVGvcuVd
        IgwAlvMfm2UzbLLT1fUXj3l2kjiOTas57nH/lKC0fErVG9mhOt77hoZORcAUo1j6BgwlRfzHEu6
        ekVAsunCZnQa75qxbV+89
X-Received: by 2002:a17:907:9810:b0:96f:bcea:df87 with SMTP id ji16-20020a170907981000b0096fbceadf87mr18311949ejc.42.1687433836423;
        Thu, 22 Jun 2023 04:37:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+6ZFEmHAogYeFG0AWvOJXQRz4NqoLSKP89l/++Hp1rS3Ll408wTBVz5tejEgoel33u4yaOA==
X-Received: by 2002:a17:907:9810:b0:96f:bcea:df87 with SMTP id ji16-20020a170907981000b0096fbceadf87mr18311937ejc.42.1687433836129;
        Thu, 22 Jun 2023 04:37:16 -0700 (PDT)
Received: from redhat.com ([2.52.159.126])
        by smtp.gmail.com with ESMTPSA id l11-20020a170906644b00b00988956f244csm4586680ejn.6.2023.06.22.04.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 04:37:15 -0700 (PDT)
Date:   Thu, 22 Jun 2023 07:37:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230622073625-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605110644.151211-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> don't support packed virtqueue well yet, so let's filter the
> VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> 
> This way, even if the device supports it, we don't risk it being
> negotiated, then the VMM is unable to set the vring state properly.
> 
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

OK so for now I dropped this, we have a better fix upstream.

> ---
> 
> Notes:
>     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>     better PACKED support" series [1] and backported in stable branches.
>     
>     We can revert it when we are sure that everything is working with
>     packed virtqueues.
>     
>     Thanks,
>     Stefano
>     
>     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> 
>  drivers/vhost/vdpa.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 8c1aefc865f0..ac2152135b23 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>  
>  	features = ops->get_device_features(vdpa);
>  
> +	/*
> +	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
> +	 * packed virtqueue well yet, so let's filter the feature for now.
> +	 */
> +	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
> +
>  	if (copy_to_user(featurep, &features, sizeof(features)))
>  		return -EFAULT;
>  
> 
> base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
> -- 
> 2.40.1

