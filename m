Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FAF2ECCB1
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbhAGJ0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbhAGJ0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1F523333;
        Thu,  7 Jan 2021 09:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610011571;
        bh=ocDJtJI92hSvv87v7zQC5Co/Ose6YDdrm8p+0C/IJM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=occebe3eK+e1I/sfF7TfkDnyJGw2ryKuMp0ceub2byakk7nH/HjmoAp+UElWSsYCS
         cC43gUGZsNzUaZHxFDTICBjFwVAyor8kL1cMK+X9ydUo+q20IgQfHACYEZ+NWghYix
         ri4n2vcUlFbE51FYukpL+SHHLjw0UkX6USgqipxQ=
Date:   Thu, 7 Jan 2021 10:27:31 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5p2O5o23?= <jie6.li@samsung.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?6rmA6rK97IKw?= <ks0204.kim@samsung.com>,
        =?utf-8?B?5L2V5YW0?= <xing84.he@samsung.com>,
        =?utf-8?B?5ZCV6auY6aOe?= <gaofei.lv@samsung.com>
Subject: Re: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq
 equals to IRQ_NOTCONNECTED
Message-ID: <X/bUA2li9RyoFN7P@kroah.com>
References: <CGME20210107075037epcms5p2b53d8edb70df2ad0f75613ecbbcf9456@epcms5p2>
 <20210107075037epcms5p2b53d8edb70df2ad0f75613ecbbcf9456@epcms5p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210107075037epcms5p2b53d8edb70df2ad0f75613ecbbcf9456@epcms5p2>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 03:50:37PM +0800, 李捷 wrote:
> From 0fbcd7e386898d829d3000d094358a91e626ee4a Mon Sep 17 00:00:00 2001
> From: Jie Li <jie6.li@samsung.com>
> Date: Mon, 7 Dec 2020 08:05:07 +0800
> Subject: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq equals to
>  IRQ_NOTCONNECTED
> 
> Some devices use 255 as default value of Interrupt Line register, and this
> maybe causes pdev->irq is set as IRQ_NOTCONNECTED in some scenarios. For
> example, NVMe controller connects to Intel Volume Management Device (VMD).
> In this situation, IRQ_NOTCONNECTED means INTx line is not connected, not
> fault. If bind uio_pci_generic to these devices, uio frame will return
> -ENOTCONN through request_irq.
> 
> This patch allows binding uio_pci_generic to device with dev->irq of
> IRQ_NOTCONNECTED.
> 
> Signed-off-by: Jie Li <jie6.li@samsung.com>
> Acked-by: Kyungsan Kim <ks0204.kim@samsung.com>
> ---
>  drivers/uio/uio_pci_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index b8e44d16279f..c7d681fef198 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -92,7 +92,7 @@ static int probe(struct pci_dev *pdev,
>         gdev->info.version = DRIVER_VERSION;
>         gdev->info.release = release;
>         gdev->pdev = pdev;
> -       if (pdev->irq) {
> +       if (pdev->irq && (pdev->irq != IRQ_NOTCONNECTED)) {
>                 gdev->info.irq = pdev->irq;
>                 gdev->info.irq_flags = IRQF_SHARED;
>                 gdev->info.handler = irqhandler;
> --
> 2.17.1
> 
> 
>  
> 
> [cid]
> 
> *
> 


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch was attached, please place it inline so that it can be
  applied directly from the email message itself.

- Your email was sent in html format, which is rejected by the kernel
  mailing lists and make it impossible for anyone to find in the
  archives.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
