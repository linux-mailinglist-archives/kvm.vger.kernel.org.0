Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFEA55D7A2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiF1IT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244105AbiF1ITD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C96482DAB4
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656404275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ANCIygcKkNb0sxE6zYRICe30C7lk84k3shbREy4O7w=;
        b=RuaQzVUODHDQX5MNVXRJrnfm1s6unBKMrtbAO8yxh++yO8ZTUZcVZYKURrIVUval+74dfq
        Au/XT25UptyA+fAr/7OBtnWgD981yBPsp/VbAM7npSL6+uvSLrO4G+9xkTMbT6V/YCDU+f
        OHSteYq7OSE9Xi/vZgSW1xi8bDCiSgA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-qCu0jKULMfmE6tRgknBLRg-1; Tue, 28 Jun 2022 04:17:54 -0400
X-MC-Unique: qCu0jKULMfmE6tRgknBLRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DD2F1C00AC5;
        Tue, 28 Jun 2022 08:17:54 +0000 (UTC)
Received: from localhost (unknown [10.39.193.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F3229D54;
        Tue, 28 Jun 2022 08:17:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Schspa Shi <schspa@gmail.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhaohui.shi@horizon.ai, Schspa Shi <schspa@gmail.com>
Subject: Re: [PATCH] vfio: Fix double free for caps->buf
In-Reply-To: <20220628050711.74945-1-schspa@gmail.com>
Organization: Red Hat GmbH
References: <20220628050711.74945-1-schspa@gmail.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 28 Jun 2022 10:17:52 +0200
Message-ID: <8735fpcibz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28 2022, Schspa Shi <schspa@gmail.com> wrote:

> There is a double free, if vfio_iommu_dma_avail_build_caps
> calls failed.
>
> The following call path will call vfio_info_cap_add multiple times
>
> vfio_iommu_type1_get_info
> 	if (!ret)
> 		ret = vfio_iommu_dma_avail_build_caps(iommu, &caps);
>
> 	if (!ret)
> 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
>
> If krealloc failed on vfio_info_cap_add, there will be a double free.

But it will only call it several times if the last call didn't fail,
won't it?

>
> Signed-off-by: Schspa Shi <schspa@gmail.com>
> ---
>  drivers/vfio/vfio.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..a0fb93866f61 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1812,6 +1812,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
> +		caps->buf = NULL;

We could add this as some kind of hardening, I guess. Current callers
all seem to deal with failure correctly.

>  		caps->size = 0;
>  		return ERR_PTR(-ENOMEM);
>  	}

