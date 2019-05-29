Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADB2E59E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfE2Ty7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 15:54:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2Ty7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 15:54:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E228DC004BEE;
        Wed, 29 May 2019 19:54:58 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A27E05C5DF;
        Wed, 29 May 2019 19:54:57 +0000 (UTC)
Date:   Wed, 29 May 2019 13:54:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Thomas Meyer" <thomas@m3y3r.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re:
Message-ID: <20190529135456.5a2e3973@x1.home>
In-Reply-To: <E1hUrZM-0007qA-Q8@sslproxy01.your-server.de>
References: <E1hUrZM-0007qA-Q8@sslproxy01.your-server.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 29 May 2019 19:54:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 13:44:04 +0200
"Thomas Meyer" <thomas@m3y3r.de> wrote:

> From thomas@m3y3r.de Sun May 26 00:13:26 2019
> Subject: [PATCH] vfio-pci/nvlink2: Use vma_pages function instead of explicit
>  computation
> To: alex.williamson@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
> Content-Type: text/plain; charset="UTF-8"
> Mime-Version: 1.0
> Content-Transfer-Encoding: 8bit
> X-Patch: Cocci
> X-Mailer: DiffSplit
> Message-ID: <1558822461341-1674464153-1-diffsplit-thomas@m3y3r.de>
> References: <1558822461331-726613767-0-diffsplit-thomas@m3y3r.de>
> In-Reply-To: <1558822461331-726613767-0-diffsplit-thomas@m3y3r.de>
> X-Serial-No: 1
> 
> Use vma_pages function on vma object instead of explicit computation.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -161,7 +161,7 @@ static int vfio_pci_nvgpu_mmap(struct vf
>  
>  	atomic_inc(&data->mm->mm_count);
>  	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
> -			(vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
> +			vma_pages(vma),
>  			data->gpu_hpa, &data->mem);
>  
>  	trace_vfio_pci_nvgpu_mmap(vdev->pdev, data->gpu_hpa, data->useraddr,

Besides the formatting of this patch, there's already a pending patch
with this same change:

https://lkml.org/lkml/2019/5/16/658

I think the original must have bounced from lkml due the encoding, but
I'll use that one since it came first, is slightly cleaner in wrapping
the line following the change, and already has Alexey's R-b.  Thanks,

Alex
