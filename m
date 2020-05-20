Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC11DA657
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 02:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgETATN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 20:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgETATN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 20:19:13 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB4DC061A0E
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:19:13 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f83so1842302qke.13
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n9JZJWROso+hIIbOh+CMhqw39lf86JMdF2gn9eh+UIg=;
        b=cxXI8ZM+8T9le0aatEoMGIohiGVbDAITFaJWkTHxe3g2ofpzbaO9x4T6fnmFbxG/cb
         NdEKIhHtK0tIYKs70+I/ZKc6qSI6ASf5rMn7f5DYCJc7CAGQ3JxhLPErSSzyoNJeqzQK
         qBOBIvPwrg5KEdYmZD1McXOeQFpYaECFemwsbSp8BkxkAAKCu2qu8L92/wAkNwMOLcIW
         Gbfpaq4t25k4uxdiETzWNQP1F3+v4zLWt+U6nNthcU6/k4ervgWeT3IoBERMb1mqAIqm
         dGSMky7SEpb6RbeWy6x7V4FBvZNzEhznlbLKVCug0r8MkL4pCPL637n44PvE5LY1UAlT
         Lm8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n9JZJWROso+hIIbOh+CMhqw39lf86JMdF2gn9eh+UIg=;
        b=JD02dEQURXEeVAoQ4EyZWEQW6TuyMFrI/thtX1MOHZYrIwfsyOnfDAa16KzkRQ5dd/
         ueUf3RVIAonciUeKXGfn78Jz1QG8OvO/0TpfNQIrNtbu0zc2legIKjuAJ6fRVKZvpOYc
         qH8fhQiFrM5EDEXl4iI25QTdZT5h5ox+V6dLeuFySqKQLF3Pi6TSHzwxkJf8Wf7jimaH
         i2IakQ76KXjAmr8D8weA1sj+QuxCHbajC5bVSVSi7mI2IuV9ALiD0ah9JoBpkRXg28Z3
         3KldYDZCuorZOHYf1mf5r3trDsvQO/3XNklVF064p3IIzrlSqwr2RmPddhH27LDZSica
         S8Hg==
X-Gm-Message-State: AOAM533MQ4qCXFhQnUte9XzteUFjaQ6wOznnxF041NdXJLALbd0mMJ0e
        HAYhM0qa4g7kK7rTikzsJNNmWQ==
X-Google-Smtp-Source: ABdhPJykcLtUdmf7WILmMYLNeoLOKQpyRW8G8FAVJII8fSZoCGX0L7PdXcMd+AvHVtJOxkvhP5FhYA==
X-Received: by 2002:a37:8302:: with SMTP id f2mr2093454qkd.220.1589933952324;
        Tue, 19 May 2020 17:19:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id s55sm1154161qtb.92.2020.05.19.17.19.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:19:11 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCRz-0003QX-AW; Tue, 19 May 2020 21:19:11 -0300
Date:   Tue, 19 May 2020 21:19:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 1/2] vfio: Introduce bus driver to IOMMU invalidation
 interface
Message-ID: <20200520001911.GB31189@ziepe.ca>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
 <158947511830.12590.15083888449284990563.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158947511830.12590.15083888449284990563.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 10:51:58AM -0600, Alex Williamson wrote:
> @@ -1450,6 +1467,10 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
>  
>  				zap_vma_ptes(vma, vma->vm_start,
>  					     vma->vm_end - vma->vm_start);
> +				mutex_unlock(&vdev->vma_lock);
> +				up_read(&mm->mmap_sem);
> +				vfio_invalidate_pfnmap_vma(vdev->group, vma);
> +				goto again;

The vma pointer can't leave the read side of the mmap_sem

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 4a4cb7cd86b2..62ba6bd8a486 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -91,6 +91,7 @@ struct vfio_dma {
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> +	struct vm_area_struct	*pfnmap_vma;

This is also confusing, how does it prevent pfnmap_vma from becoming
freed?

Jason
