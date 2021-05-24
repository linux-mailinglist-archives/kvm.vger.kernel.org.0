Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B293F38F3D6
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhEXTti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:49:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232693AbhEXTtg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 15:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621885687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfxZbd43HV5BQck0fhkJc4tszzGku44t8kIMaje1IsQ=;
        b=PQozXDmQePLaD9Xd+81L1Kgd8pJbz4Unz77711lu817uq0Jxwe+uGYNcCYYnlYC5BDtWN0
        v4QJ75XyCvAxV2RUl4zNbiBEpB8gpHEoOHd/AWTQBsKwveypntGhZc6TlxIEwB53kOq1m9
        MactYfqwPie1gnvCvn8Wzfh0YN3mz1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-pD1I8wdkO_2yhId0Ep0XBA-1; Mon, 24 May 2021 15:48:03 -0400
X-MC-Unique: pD1I8wdkO_2yhId0Ep0XBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D015180FD65;
        Mon, 24 May 2021 19:48:02 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A6641001281;
        Mon, 24 May 2021 19:48:02 +0000 (UTC)
Date:   Mon, 24 May 2021 13:48:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] vfio/iommu_type1: Use struct_size() for kzalloc()
Message-ID: <20210524134801.406bc4bf@x1.home.shazbot.org>
In-Reply-To: <20210513230155.GA217517@embeddedor>
References: <20210513230155.GA217517@embeddedor>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 May 2021 18:01:55 -0500
"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows
> that, in the worst scenario, could lead to heap overflows.
> 
> This code was detected with the help of Coccinelle and, audited and
> fixed manually.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a0747c35a778..a3e925a41b0d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2795,7 +2795,7 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>  		return 0;
>  	}
>  
> -	size = sizeof(*cap_iovas) + (iovas * sizeof(*cap_iovas->iova_ranges));
> +	size = struct_size(cap_iovas, iova_ranges, iovas);
>  
>  	cap_iovas = kzalloc(size, GFP_KERNEL);
>  	if (!cap_iovas)


Looks good, applied to vfio for-linus branch for v5.13.  Thanks,

Alex

