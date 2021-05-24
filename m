Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C08738F3D3
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhEXTs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232107AbhEXTs1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 15:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621885619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eSgniuYleIfy2mqxkBpQSaiY72k4S+9CRx4cslFPjKs=;
        b=cBoAKza0SjxvvD8ltJ+TyVw5iKEyoC/I7DxzYmHx1U1o1Yl680jLxu7p7uazIYdxLiNHJq
        qvZeE+ikVRuQLhsHcXr5jvRS60Cni/t8FK9Ja7/0Km6pDF9K7ADPQbNFZTQiWF5Hvrh//Q
        t4fp70m+P0t0DcObyq1Iupho0l7xypo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-kyzoSgi-NX6e45auhMDkyg-1; Mon, 24 May 2021 15:46:56 -0400
X-MC-Unique: kyzoSgi-NX6e45auhMDkyg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C6E5803622;
        Mon, 24 May 2021 19:46:55 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB3595C701;
        Mon, 24 May 2021 19:46:50 +0000 (UTC)
Date:   Mon, 24 May 2021 13:46:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH] vfio/pci: zap_vma_ptes() needs MMU
Message-ID: <20210524134650.01ed417b@x1.home.shazbot.org>
In-Reply-To: <20210515190856.2130-1-rdunlap@infradead.org>
References: <20210515190856.2130-1-rdunlap@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 15 May 2021 12:08:56 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> zap_vma_ptes() is only available when CONFIG_MMU is set/enabled.
> Without CONFIG_MMU, vfio_pci.o has build errors, so make
> VFIO_PCI depend on MMU.
> 
> riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `vfio_pci_mmap_open':
> vfio_pci.c:(.text+0x1ec): undefined reference to `zap_vma_ptes'
> riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `.L0 ':
> vfio_pci.c:(.text+0x165c): undefined reference to `zap_vma_ptes'
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/pci/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20210514.orig/drivers/vfio/pci/Kconfig
> +++ linux-next-20210514/drivers/vfio/pci/Kconfig
> @@ -2,6 +2,7 @@
>  config VFIO_PCI
>  	tristate "VFIO support for PCI devices"
>  	depends on VFIO && PCI && EVENTFD
> +	depends on MMU
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
>  	help


Yes, these !MMU configs are getting annoying and I don't know of any
demand for vfio in them.  I suspect we were ok with !MMU until
11c4cd07ba11 though, that's where we added zap_vma_ptes usage.  I
updated the Fixes: tag but I suspect either case would reach the same
set of stable trees.  Applied to vfio for-linus branch for v5.13.
Thanks!

Alex

