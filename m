Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D284240EB
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhJFPM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:12:26 -0400
Received: from foss.arm.com ([217.140.110.172]:35550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhJFPMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:12:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 231156D;
        Wed,  6 Oct 2021 08:10:32 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D72D3F66F;
        Wed,  6 Oct 2021 08:10:31 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:10:28 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 3/7] pci: Fix pci_dev_* print macros
Message-ID: <20211006161028.12e0088b@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-4-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
 <20210913154413.14322-4-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:09 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Evaluate the "pci_hdr" argument before attempting to deference a field.
> This fixes cryptic errors like this one, which came about during a
> debugging session:
> 
> vfio/pci.c: In function 'vfio_pci_bar_activate':
> include/kvm/pci.h:18:40: error: invalid type argument of '->' (have 'struct pci_device_header')
>   pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>                                         ^~
> vfio/pci.c:482:3: note: in expansion of macro 'pci_dev_warn'
>    pci_dev_warn(&vdev->pci.hdr, "%s: BAR4\n", __func__);
> 
> This is caused by the operator precedence rules in C, where pointer
> deference via "->" has a higher precedence than taking the address with the
> ampersand symbol. When the macro is substituted, it becomes
> &vdev->pci.hdr->vendor_id and it dereferences vdev->pci.hdr, which is not a
> pointer, instead of dereferencing &vdev->pci.hdr, which is a pointer, and
> quite likely what the author intended.

Indeed! Actually that should not need that many words, parameters in macros
should always be put in parentheses.

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/pci.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> index 0f2d5bb..d6eb398 100644
> --- a/include/kvm/pci.h
> +++ b/include/kvm/pci.h
> @@ -13,15 +13,15 @@
>  #include "kvm/kvm-arch.h"
>  
>  #define pci_dev_err(pci_hdr, fmt, ...) \
> -	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +	pr_err("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
>  #define pci_dev_warn(pci_hdr, fmt, ...) \
> -	pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +	pr_warning("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
>  #define pci_dev_info(pci_hdr, fmt, ...) \
> -	pr_info("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +	pr_info("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
>  #define pci_dev_dbg(pci_hdr, fmt, ...) \
> -	pr_debug("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +	pr_debug("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
>  #define pci_dev_die(pci_hdr, fmt, ...) \
> -	die("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +	die("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
>  
>  /*
>   * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.

