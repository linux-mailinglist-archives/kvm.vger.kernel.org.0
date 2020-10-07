Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E051C286789
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgJGSlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgJGSle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 14:41:34 -0400
Received: from localhost (170.sub-72-107-125.myvzw.com [72.107.125.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5DE2168B;
        Wed,  7 Oct 2020 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602096093;
        bh=jybj9lxB9HDSUiFTDfX0tbqIYHCI2WD8V2Srcj/Y2q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=fvTSDoaSFaR5f+GW+1VfPgc/eLGyZstXFPM0Pbbd72KBA+ecoTEtBddTdYZhtlYj3
         bsFSSKkvJi72PjhGp9tmM7ZEtUUSjRP9PU6yME2u3FWvCct89TVsvj/po3TnsMWfeR
         J1+3vx2h0ip+tE/J1MK3LQud3yRzf+O7RxgCuZrk=
Date:   Wed, 7 Oct 2020 13:41:31 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/13] PCI: revoke mappings like devmem
Message-ID: <20201007184131.GA3259154@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007164426.1812530-11-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capitalize subject, like other patches in this series and previous
drivers/pci history.

On Wed, Oct 07, 2020 at 06:44:23PM +0200, Daniel Vetter wrote:
> Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
> the region") /dev/kmem zaps ptes when the kernel requests exclusive
> acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
> the default for all driver uses.
> 
> Except there's two more ways to access pci bars: sysfs and proc mmap
> support. Let's plug that hole.

s/pci/PCI/ in commit logs and comments.

> For revoke_devmem() to work we need to link our vma into the same
> address_space, with consistent vma->vm_pgoff. ->pgoff is already
> adjusted, because that's how (io_)remap_pfn_range works, but for the
> mapping we need to adjust vma->vm_file->f_mapping. Usually that's done
> at ->open time, but that's a bit tricky here with all the entry points
> and arch code. So instead create a fake file and adjust vma->vm_file.
> 
> Note this only works for ARCH_GENERIC_PCI_MMAP_RESOURCE. But that
> seems to be a subset of architectures support STRICT_DEVMEM, so we
> should be good.
> 
> The only difference in access checks left is that sysfs pci mmap does
> not check for CAP_RAWIO. But I think that makes some sense compared to
> /dev/mem and proc, where one file gives you access to everything and
> no ownership applies.

> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -810,6 +810,7 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>  }
>  
>  static struct inode *devmem_inode;
> +static struct vfsmount *devmem_vfs_mount;
>  
>  #ifdef CONFIG_IO_STRICT_DEVMEM
>  void revoke_devmem(struct resource *res)
> @@ -843,6 +844,20 @@ void revoke_devmem(struct resource *res)
>  
>  	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1);
>  }
> +
> +struct file *devmem_getfile(void)
> +{
> +	struct file *file;
> +
> +	file = alloc_file_pseudo(devmem_inode, devmem_vfs_mount, "devmem",
> +				 O_RDWR, &kmem_fops);
> +	if (IS_ERR(file))
> +		return NULL;
> +
> +	file->f_mapping = devmem_indoe->i_mapping;

"devmem_indoe"?  Obviously not compiled, I guess?

> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -304,8 +304,10 @@ struct resource *request_free_mem_region(struct resource *base,
>  
>  #ifdef CONFIG_IO_STRICT_DEVMEM
>  void revoke_devmem(struct resource *res);
> +struct file *devm_getfile(void);
>  #else
>  static inline void revoke_devmem(struct resource *res) { };
> +static inline struct file *devmem_getfile(void) { return NULL; };

I guess these names are supposed to match?

>  #endif
>  
>  #endif /* __ASSEMBLY__ */
> -- 
> 2.28.0
> 
