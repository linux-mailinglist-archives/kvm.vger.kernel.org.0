Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D44F9B7D7
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 22:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392571AbfHWUqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 16:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388903AbfHWUqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 16:46:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF2F33090FC5;
        Fri, 23 Aug 2019 20:46:00 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F1E05DD61;
        Fri, 23 Aug 2019 20:45:49 +0000 (UTC)
Date:   Fri, 23 Aug 2019 14:45:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     hexin <hexin.op@gmail.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>
Subject: Re: [PATCH v3] vfio_pci: Restore original state on release
Message-ID: <20190823144549.58dce8e7@x1.home>
In-Reply-To: <1566444919-3331-1-git-send-email-hexin15@baidu.com>
References: <1566444919-3331-1-git-send-email-hexin15@baidu.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 23 Aug 2019 20:46:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Aug 2019 11:35:19 +0800
hexin <hexin.op@gmail.com> wrote:

> vfio_pci_enable() saves the device's initial configuration information
> with the intent that it is restored in vfio_pci_disable().  However,
> the commit referenced in Fixes: below replaced the call to
> __pci_reset_function_locked(), which is not wrapped in a state save
> and restore, with pci_try_reset_function(), which overwrites the
> restored device state with the current state before applying it to the
> device.  Reinstate use of __pci_reset_function_locked() to return to
> the desired behavior.
> 
> Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
> Signed-off-by: hexin <hexin15@baidu.com>
> Signed-off-by: Liu Qi <liuqi16@baidu.com>
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> ---

Applied to vfio next branch for v5.4.  Thanks,

Alex

> v2->v3:
> - change commit log 
> v1->v2:
> - add fixes tag
> - add comment to warn 
> 
> [1] https://lore.kernel.org/linux-pci/1565926427-21675-1-git-send-email-hexin15@baidu.com
> [2] https://lore.kernel.org/linux-pci/1566042663-16694-1-git-send-email-hexin15@baidu.com
> 
>  drivers/vfio/pci/vfio_pci.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 703948c..0220616 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -438,11 +438,20 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
>  
>  	/*
> -	 * Try to reset the device.  The success of this is dependent on
> -	 * being able to lock the device, which is not always possible.
> +	 * Try to get the locks ourselves to prevent a deadlock. The
> +	 * success of this is dependent on being able to lock the device,
> +	 * which is not always possible.
> +	 * We can not use the "try" reset interface here, which will
> +	 * overwrite the previously restored configuration information.
>  	 */
> -	if (vdev->reset_works && !pci_try_reset_function(pdev))
> -		vdev->needs_reset = false;
> +	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
> +		if (device_trylock(&pdev->dev)) {
> +			if (!__pci_reset_function_locked(pdev))
> +				vdev->needs_reset = false;
> +			device_unlock(&pdev->dev);
> +		}
> +		pci_cfg_access_unlock(pdev);
> +	}
>  
>  	pci_restore_state(pdev);
>  out:

