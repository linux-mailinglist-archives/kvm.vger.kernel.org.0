Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003B03F8499
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240984AbhHZJeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbhHZJeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:34:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644B9C061757;
        Thu, 26 Aug 2021 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pYzd5Vps9XQU2laawLxMl3QmWSCsFICPo2ltcPfeFHo=; b=MrVFzWEtb85263Tc99OQc4+jHO
        JdgOYSs3xQcfyDt0VW5L/yMKl2JUCZBXZM6eOu5WanIGPsLo41VAQyJ+/iXRWKDLgTKr6XwlLQX+2
        vGxjWLaNbsSZbQgUea7Kt/XwaP+IBLk/ZkZ3EvA1O7KrGIpiUWy8qktSv1GNME0POpmOHDjBgFAJ/
        BTakQa4P5ZB+61X3+4afEASPzCJ487dKBwFPw1cWvdqIUiCMmvRd9wn/EkgTWRuP/Mv4vWupK89ve
        ZZbsBD3+iCt6jXw3Wolu3dCkeSr9L0/XEfV4AupYLoJncmHUDZrdjddqV+9jjlkV6AR5naZsgQm7+
        l5x+E0+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBjh-00D9f7-E9; Thu, 26 Aug 2021 09:32:01 +0000
Date:   Thu, 26 Aug 2021 10:31:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH V4 06/13] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
Message-ID: <YSdfhVK2LYBfMWiT@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-7-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-7-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:32PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Split the vfio_pci driver into two logical parts, the 'struct
> pci_driver' (vfio_pci.c) which implements "Generic VFIO support for any
> PCI device" and a library of code (vfio_pci_core.c) that helps
> implementing a struct vfio_device on top of a PCI device.
> 
> vfio_pci.ko continues to present the same interface under sysfs and this
> change should have no functional impact.
> 
> Following patches will turn vfio_pci and vfio_pci_core into a separate
> module.
> 
> This is a preparation for allowing another module to provide the
> pci_driver and allow that module to customize how VFIO is setup, inject
> its own operations, and easily extend vendor specific functionality.
> 
> At this point the vfio_pci_core still contains a lot of vfio_pci
> functionality mixed into it. Following patches will move more of the large
> scale items out, but another cleanup series will be needed to get
> everything.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/Makefile        |   2 +-
>  drivers/vfio/pci/vfio_pci.c      | 223 +++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 271 +++++++------------------------
>  drivers/vfio/pci/vfio_pci_core.h |  23 +++
>  4 files changed, 304 insertions(+), 215 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci.c
> 
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 66a40488e967..8aa517b4b671 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  
> -vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
> +vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o

Please avoid the overly long line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
