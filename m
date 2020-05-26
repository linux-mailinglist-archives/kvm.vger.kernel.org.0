Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639B01E1B89
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgEZGsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgEZGsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:48:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 651BA207D8;
        Tue, 26 May 2020 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590475701;
        bh=KB2ZEvmVzYY93muPmZUfwEbvx2qqohH1HVtTZyR6awQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LO3HdrUXEDbWzDjjfHIa/ja3MnPXUxBXLDUL/htS/xtBbpMoBurXScP6wjQBDWXwX
         WQV4nWS6m0POKAA277sCm1D3HcV1EkaF2cSqu47Q1YtQureNkFS8g/ZKQ4HhqXnnA6
         4FlaFJZz/M/W2AgKpwbRUZRVogqtw1stXAzATJG0=
Date:   Tue, 26 May 2020 08:48:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 04/18] nitro_enclaves: Init PCI device driver
Message-ID: <20200526064819.GC2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-5-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-5-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:13:20AM +0300, Andra Paraschiv wrote:
> The Nitro Enclaves PCI device is used by the kernel driver as a means of
> communication with the hypervisor on the host where the primary VM and
> the enclaves run. It handles requests with regard to enclave lifetime.
> 
> Setup the PCI device driver and add support for MSI-X interrupts.
> 
> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> 
> v2 -> v3
> 
> * Remove the GPL additional wording as SPDX-License-Identifier is already in
> place.
> * Remove the WARN_ON calls.
> * Remove linux/bug include that is not needed.
> * Update static calls sanity checks.
> * Remove "ratelimited" from the logs that are not in the ioctl call paths.
> * Update kzfree() calls to kfree().
> 
> v1 -> v2
> 
> * Add log pattern for NE.
> * Update PCI device setup functions to receive PCI device data structure and
> then get private data from it inside the functions logic.
> * Remove the BUG_ON calls.
> * Add teardown function for MSI-X setup.
> * Update goto labels to match their purpose.
> * Implement TODO for NE PCI device disable state check.
> * Update function name for NE PCI device probe / remove.
> ---
>  drivers/virt/nitro_enclaves/ne_pci_dev.c | 252 +++++++++++++++++++++++
>  1 file changed, 252 insertions(+)
>  create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.c
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> new file mode 100644
> index 000000000000..0b66166787b6
> --- /dev/null
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -0,0 +1,252 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + */
> +
> +/* Nitro Enclaves (NE) PCI device driver. */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/nitro_enclaves.h>
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>
> +
> +#include "ne_misc_dev.h"
> +#include "ne_pci_dev.h"
> +
> +#define DEFAULT_TIMEOUT_MSECS (120000) /* 120 sec */
> +
> +#define NE "nitro_enclaves: "

Why is this needed?  The dev_* functions should give you all the
information that you need to properly describe the driver and device in
question.  No extra "prefixes" should be needed at all.

thanks,

greg k-h
