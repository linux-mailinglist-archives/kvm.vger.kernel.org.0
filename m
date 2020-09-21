Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA244272072
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgIUKVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 06:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgIUKVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 06:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600683708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXLSRgJ1NwJlygVsKMNwZZ5/k5tFxWzlJPyhSnYKIn0=;
        b=JSJowxAK8PmBmbtZUFwNIOjNcy+BxiaG+DjfBIqVhrx2ypuil4aWBBAc8WMoHPIhQS6rty
        6z+QDekTFtkQr2Mf+/3Gnhmz05Kur7HJhi4gqORQmP/yuvpiOCQWfLqIPQvcvaLn/wSVFe
        ELqQkHm/ZyLDZ13M/+5rncGEA0YVbzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-1nOGtU6IOIqAV3FA_Qw7cw-1; Mon, 21 Sep 2020 06:21:44 -0400
X-MC-Unique: 1nOGtU6IOIqAV3FA_Qw7cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEE77107464F;
        Mon, 21 Sep 2020 10:21:42 +0000 (UTC)
Received: from gondolin (ovpn-112-187.ams2.redhat.com [10.36.112.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E42310013D0;
        Mon, 21 Sep 2020 10:21:37 +0000 (UTC)
Date:   Mon, 21 Sep 2020 12:21:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Don't regenerate vconfig for all BARs
 if !bardirty
Message-ID: <20200921122134.5c7794f3.cohuck@redhat.com>
In-Reply-To: <20200921045116.258-2-yuzenghui@huawei.com>
References: <20200921045116.258-1-yuzenghui@huawei.com>
        <20200921045116.258-2-yuzenghui@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Sep 2020 12:51:16 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Now we regenerate vconfig for all the BARs via vfio_bar_fixup(), every time
> any offset of any of them are read. Though BARs aren't re-read regularly,
> the regeneration can be avoid if no BARs had been written since they were

s/avoid/avoided/

> last read, in which case the vdev->bardirty is false.

s/the//

> 
> Let's predicate the vfio_bar_fixup() on the bardirty so that it can return
> immediately if !bardirty.

Maybe

"Let's return immediately in vfio_bar_fixup() if bardirty is false." ?

> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> * From v1:
>   - Per Alex's suggestion, let vfio_bar_fixup() test vdev->bardirty to
>     avoid doing work if bardirty is false, instead of removing it entirely.
>   - Rewrite the commit message.
> 
>  drivers/vfio/pci/vfio_pci_config.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843feddce..5e02ba07e8e8 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -467,6 +467,9 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>  	__le32 *vbar;
>  	u64 mask;
> 
> +	if (!vdev->bardirty)

Finally, bardirty can actually affect something :)

> +		return;
> +
>  	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>  
>  	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

