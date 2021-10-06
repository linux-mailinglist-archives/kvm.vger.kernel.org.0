Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7724240F6
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhJFPNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:13:38 -0400
Received: from foss.arm.com ([217.140.110.172]:35778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239000AbhJFPNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:13:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 693586D;
        Wed,  6 Oct 2021 08:11:45 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B89AF3F66F;
        Wed,  6 Oct 2021 08:11:44 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:11:42 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 7/7] vfio/pci: Align MSIX Table and PBA size
 allocation to 64k
Message-ID: <20211006161142.36b5fa41@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-8-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
        <20210913154413.14322-8-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:13 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> When allocating MMIO space for the MSI-X table, kvmtool rounds the
> allocation to the host's page size to make it as easy as possible for the
> guest to map the table to a page, if it wants to (and doesn't do BAR
> reassignment, like the x86 architecture for example). However, the host's
> page size can differ from the guest's, for example, if the host is compiled
> with 4k pages and the guest is using 64k pages.
> 
> To make sure the allocation is always aligned to a guest's page size, round
> it up to the maximum page size, which is 64k. Do the same for the pending
> bit array if it lives in its own BAR.

The idea of that looks alright on the first glance, but isn't needed for
x86, right? So should this be using an arch-specific MAX_PAGE_SIZE instead?

Cheers,
Andre

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  vfio/pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index a6d0408..7e258a4 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -1,3 +1,5 @@
> +#include "linux/sizes.h"
> +
>  #include "kvm/irq.h"
>  #include "kvm/kvm.h"
>  #include "kvm/kvm-cpu.h"
> @@ -929,7 +931,7 @@ static int vfio_pci_create_msix_table(struct kvm
> *kvm, struct vfio_device *vdev) if (!info.size)
>  		return -EINVAL;
>  
> -	map_size = ALIGN(info.size, PAGE_SIZE);
> +	map_size = ALIGN(info.size, SZ_64K);
>  	table->guest_phys_addr = pci_get_mmio_block(map_size);
>  	if (!table->guest_phys_addr) {
>  		pr_err("cannot allocate MMIO space");
> @@ -960,7 +962,7 @@ static int vfio_pci_create_msix_table(struct kvm
> *kvm, struct vfio_device *vdev) if (!info.size)
>  			return -EINVAL;
>  
> -		map_size = ALIGN(info.size, PAGE_SIZE);
> +		map_size = ALIGN(info.size, SZ_64K);
>  		pba->guest_phys_addr = pci_get_mmio_block(map_size);
>  		if (!pba->guest_phys_addr) {
>  			pr_err("cannot allocate MMIO space");

