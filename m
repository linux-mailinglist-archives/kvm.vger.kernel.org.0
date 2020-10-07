Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCE02867A2
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgJGSqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgJGSqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 14:46:37 -0400
Received: from localhost (170.sub-72-107-125.myvzw.com [72.107.125.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302572173E;
        Wed,  7 Oct 2020 18:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602096396;
        bh=ku8/7a2SrweIxThK5zG5QJDipURplqu8mO6h2koIIVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=yGYWT03mT20e+akOD8V3aUmT+NyGjr7bgLmgu9ySTSASz+Md94zSiKtM93/z0+0sL
         I3c3vVZGcJsLXlm+ZoUqyLsz8Cd5moqzmTGlgBtkwCaTbh8SP5WyTjiZ42UF86RDsd
         vY1hTupOSF5ue42FE0IOxR9jnpK4Wp1Jv+Hagbrk=
Date:   Wed, 7 Oct 2020 13:46:34 -0500
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
Subject: Re: [PATCH 09/13] PCI: obey iomem restrictions for procfs mmap
Message-ID: <20201007184634.GA3259641@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007164426.1812530-10-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 06:44:22PM +0200, Daniel Vetter wrote:
> There's three ways to access pci bars from userspace: /dev/mem, sysfs
> files, and the old proc interface. Two check against
> iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> this starts to matter, since we don't want random userspace having
> access to pci bars while a driver is loaded and using it.
> 
> Fix this.

Please mention *how* you're fixing this.  I know you can sort of
deduce it from the first paragraph, but it's easy to save readers the
trouble.

s/pci/PCI/
s/bars/BARs/
Capitalize subject to match other patches.

> References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/proc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index d35186b01d98..3a2f90beb4cb 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -274,6 +274,11 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
>  		else
>  			return -EINVAL;
>  	}
> +
> +	if (dev->resource[i].flags & IORESOURCE_MEM &&
> +	    iomem_is_exclusive(dev->resource[i].start))
> +		return -EINVAL;
> +
>  	ret = pci_mmap_page_range(dev, i, vma,
>  				  fpriv->mmap_state, write_combine);
>  	if (ret < 0)
> -- 
> 2.28.0
> 
