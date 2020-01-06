Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5BD131C08
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 00:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAFXFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 18:05:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726735AbgAFXFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 18:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578351909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5FUwndBIrFS376iq6UZxigDCdyXQx4W62Bo2bpWtvvU=;
        b=FgeJbRHr4KbP1RcGEfBU0Onoc8DC6xcK958b28NrJWaUtoQfxphZeLP4IKbk7pGbhPpdhn
        3iKl40p+TfNd9rPG+bF4UiEvya6rmlgWf0sUw/pI6AIc6RIeShgIUjSTqGQOHt/vqy2wxw
        FPNpzYH5BvSxFJkMbeuEb515h3P/JmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-iBhoNrFePfelJiDunoLm6A-1; Mon, 06 Jan 2020 18:05:08 -0500
X-MC-Unique: iBhoNrFePfelJiDunoLm6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 834CB1800D4E;
        Mon,  6 Jan 2020 23:05:06 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 257F65D9D6;
        Mon,  6 Jan 2020 23:05:05 +0000 (UTC)
Date:   Mon, 6 Jan 2020 16:05:05 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: vfio_pci_nvlink2: use mmgrab
Message-ID: <20200106160505.2f962d38@w520.home>
In-Reply-To: <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
        <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 29 Dec 2019 16:42:56 +0100
Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
> helper") and most of the kernel was updated to use it. Update a
> remaining file.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> <smpl>
> @@ expression e; @@
> - atomic_inc(&e->mm_count);
> + mmgrab(e);
> </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/vfio/pci/vfio_pci_nvlink2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index f2983f0f84be..43df10af7f66 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -159,7 +159,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
>  	data->useraddr = vma->vm_start;
>  	data->mm = current->mm;
>  
> -	atomic_inc(&data->mm->mm_count);
> +	mmgrab(data->mm);
>  	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
>  			vma_pages(vma), data->gpu_hpa, &data->mem);
>  
> 

Acked-by: Alex Williamson <alex.williamson@redhat.com>

Thanks!  I'm assuming these will be routed via janitors tree, please
let me know if you intend me to grab these two vfio patches from the
series.  Thanks,

Alex

