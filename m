Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047241B6FE8
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 10:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDXIlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 04:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgDXIlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 04:41:10 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F2220728;
        Fri, 24 Apr 2020 08:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587717669;
        bh=oZe8ljfxPGxN1bDhlz9zeRGuvpzrhShXdGSjTaCbdcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nx1BPylMgb/sh/adC2mC0DATtR2+IDk+9KVESKE1cX27VP2maygL7IDwNfoK/t2ff
         fje776J+Zitqo16kU6UeXA60Wtckmd0UsQOw9dEWlfLYpC25EXnxDAFfQ0xMmg6hwh
         jCTngLq1HY029jEgkvyDf8U4W8Ekk3zjiQ3bqKjw=
Date:   Fri, 24 Apr 2020 09:41:05 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH kvmtool v4 1/5] virtio-mmio: Assign IRQ line directly
 before registering device
Message-ID: <20200424084104.GB20801@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200423173844.24220-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423173844.24220-2-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 06:38:40PM +0100, Andre Przywara wrote:
> At the moment the IRQ line for a virtio-mmio device is assigned in the
> generic device__register() routine in devices.c, by calling back into
> virtio-mmio.c. This does not only sound slightly convoluted, but also
> breaks when we try to register an MMIO device that is not a virtio-mmio
> device. In this case container_of will return a bogus pointer (as it
> assumes a struct virtio_mmio), and the IRQ allocation routine will
> corrupt some data in the device_header (for instance the first byte
> of the "data" pointer).
> 
> Simply assign the IRQ directly in virtio_mmio_init(), before calling
> device__register(). This avoids the problem and looks actually much more
> straightforward.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  devices.c                 |  4 ----
>  include/kvm/virtio-mmio.h |  1 -
>  virtio/mmio.c             | 10 ++--------
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/devices.c b/devices.c
> index a7c666a7..2c8b2665 100644
> --- a/devices.c
> +++ b/devices.c
> @@ -1,7 +1,6 @@
>  #include "kvm/devices.h"
>  #include "kvm/kvm.h"
>  #include "kvm/pci.h"
> -#include "kvm/virtio-mmio.h"
>  
>  #include <linux/err.h>
>  #include <linux/rbtree.h>
> @@ -33,9 +32,6 @@ int device__register(struct device_header *dev)
>  	case DEVICE_BUS_PCI:
>  		pci__assign_irq(dev);
>  		break;
> -	case DEVICE_BUS_MMIO:
> -		virtio_mmio_assign_irq(dev);
> -		break;

Hmm, but then it's a bit ugly to handle these differently to PCI. How
difficult is it to add a new bus type instead? e.g. stick the virtio mmio
devices on DEVICE_BUS_VIRTIO_MMIO and then add the non-virtio MMIO devices
to DEVICE_BUS_MMIO?

Will
