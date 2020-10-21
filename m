Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F23294D07
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442617AbgJUMue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 08:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442621AbgJUMud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 08:50:33 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A82C0613CE
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 05:50:32 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id s1so965988qvm.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 05:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VkhhJyafoy36fds4PnCfWF9LNV9fC1i6gyayD/bdTsE=;
        b=Bjric0h8k3E5nVSnyA3y8syn5qJbzN5IRzuOHR0d7uEDz69w1rKEdQtJjX2klnSD2f
         HQcTpKD5D3V7kWLlToHxrM8UOfbUsM4NGMyxmaL4cJNWPBOlwy7SSVlgAu3fXQNgW/tm
         E/Z154bHNIDfOdfpW4c0/FAD/DUsAoEBg7tdzOhHMjGwZ1srI5ZzmyHw1kqTbOA20Zsr
         6FkTvbFUFtQy26Mpkg7JM8b/jc3WZ4zNCmcMh6GqroRxUEuzzQjwRRq/1rm+GvI0lwIa
         yqkLIFnQ0gQqj71OpMsdVbj1j0y2lESP0Xm+nHN0pfprmhEnmw6kFUQw4XnnGYDmJyHR
         D1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VkhhJyafoy36fds4PnCfWF9LNV9fC1i6gyayD/bdTsE=;
        b=udMEfykBMM1dH+A61urnTFvaYN80TEN5fjivlMBZ6eECFJiaOJnNDB1A08T9u+KAzs
         5d6T1Vd6KB4OFpc1RD4f8wp78Gd39NH9qfLecFQKnEI2spSJ8SwvrcnNCGMDp7Mk+Phl
         AUq9QYp5IFe7faKnwItzAlZ735/I1MGNL0jINQW/al5+Bg1Fdj3mGUsAdg3oie6sG2h7
         rKaM+z7fGBlOgRj7J6IelROlwOmQiQHNpSmXDO4ou6jstJKDyxKwV7DJ5u5H6gziAEGt
         0kIpucN+xOzV1RYbZLFIny75aaTKpVRpX/CfvKsPrZum5jhKyYM238XCGVJvxnfLDmxC
         v3rA==
X-Gm-Message-State: AOAM532jc2GbtbTcuUF72x8g3ItBqiT86qfW9voBB7cwlqQnknZz8Bbu
        1C5WW5+O4zXxNo+Ro7dFjfLTQA==
X-Google-Smtp-Source: ABdhPJylgNYamo6kqGCWkyezTruGMIXv95IBuM/bFST1jOCSfo3IMWIRoN2J3LwPyBiAPIKaTroxlw==
X-Received: by 2002:ad4:52c6:: with SMTP id p6mr2781869qvs.38.1603284631882;
        Wed, 21 Oct 2020 05:50:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id r11sm1016060qtw.47.2020.10.21.05.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 05:50:31 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kVDZW-003UAg-0q; Wed, 21 Oct 2020 09:50:30 -0300
Date:   Wed, 21 Oct 2020 09:50:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.com>
Subject: Re: [PATCH v3 12/16] PCI: Obey iomem restrictions for procfs mmap
Message-ID: <20201021125030.GK36674@ziepe.ca>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
 <20201021085655.1192025-13-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201021085655.1192025-13-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 10:56:51AM +0200, Daniel Vetter wrote:
> There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
> files, and the old proc interface. Two check against
> iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> this starts to matter, since we don't want random userspace having
> access to PCI BARs while a driver is loaded and using it.
> 
> Fix this by adding the same iomem_is_exclusive() check we already have
> on the sysfs side in pci_mmap_resource().
> 
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
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.com>

Maybe not for fixing in this series, but this access to
IORESOURCE_BUSY doesn't have any locking.

The write side holds the resource_lock at least..

>  	ret = pci_mmap_page_range(dev, i, vma,
>  				  fpriv->mmap_state, write_combine);

At this point the vma isn't linked into the address space, so doesn't
this happen?

     CPU 0                                  CPU1
 mmap_region()
   vma = vm_area_alloc
   proc_bus_pci_mmap
    iomem_is_exclusive
    pci_mmap_page_range
                                            revoke_devmem
                                             unmap_mapping_range()
     // vma is not linked to the address space here,
     // unmap doesn't find it
  vma_link() 
  !!! The VMA gets mapped with the revoked PTEs

I couldn't find anything that prevents it at least, no mmap_sem on the
unmap side, just the i_mmap_lock

Not seeing how address space and pre-populating during mmap work
together? Did I miss locking someplace?

Not something to be fixed for this series, this is clearly an
improvement, but seems like another problem to tackle?

Jason
