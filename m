Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51B426A27A
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgIOJoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:44:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgIOJoP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 05:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600163053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lbu0S0cU/fsoJ+GJyj5DcLjuEJa0U3NyiPwssHnVX5Q=;
        b=MjOfwcCow00rUxLyBzocmXQDf+5S+tYyc80cbaJc2yiN6/oZWaf+5l7nYo6n00qEWsPC8D
        +Kc20QPUWj71Kpl75oJ2UM1Rq8GFieL7Wrft5m2wnAnAxI0gGTwBweAx9ceRvEwjwG8SWq
        u3sxavn7uxfPj5OhOYWtZWseptFws6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-OpyvX78FNlm8c7F0Zm2C2Q-1; Tue, 15 Sep 2020 05:44:12 -0400
X-MC-Unique: OpyvX78FNlm8c7F0Zm2C2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D996218B9ECB;
        Tue, 15 Sep 2020 09:44:10 +0000 (UTC)
Received: from gondolin (ovpn-113-4.ams2.redhat.com [10.36.113.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C667E60BE5;
        Tue, 15 Sep 2020 09:44:03 +0000 (UTC)
Date:   Tue, 15 Sep 2020 11:44:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio iommu: Add dma available capability
Message-ID: <20200915114401.4db5e009.cohuck@redhat.com>
In-Reply-To: <1600122331-12181-2-git-send-email-mjrosato@linux.ibm.com>
References: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
        <1600122331-12181-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Sep 2020 18:25:31 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
> added the ability to limit the number of memory backed DMA mappings.
> However on s390x, when lazy mapping is in use, we use a very large
> number of concurrent mappings.  Let's provide the current allowable
> number of DMA mappings to userspace via the IOMMU info chain so that
> userspace can take appropriate mitigation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>  include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>  2 files changed, 33 insertions(+)

(...)

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..a8cc4a5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
>  	__u64	max_dirty_bitmap_size;		/* in bytes */
>  };
>  
> +/*
> + * The DMA available capability allows to report the current number of
> + * simultaneously outstanding DMA mappings that are allowed.
> + *
> + * The structures below define version 1 of this capability.

"The structure below defines..." ?

> + *
> + * max: specifies the maximum number of outstanding DMA mappings allowed.

I think you forgot to tweak that one:

"avail: specifies the current number of outstanding DMA mappings allowed."

?

> + */
> +#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
> +
> +struct vfio_iommu_type1_info_dma_avail {
> +	struct	vfio_info_cap_header header;
> +	__u32	avail;
> +};
> +
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

