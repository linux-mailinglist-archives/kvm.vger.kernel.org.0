Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE60904A3
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfHPPYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 11:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfHPPYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 11:24:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76173300CB2B;
        Fri, 16 Aug 2019 15:24:17 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A30BA3786;
        Fri, 16 Aug 2019 15:24:16 +0000 (UTC)
Date:   Fri, 16 Aug 2019 09:24:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     hexin <hexin.op@gmail.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>
Subject: Re: [PATCH] vfio_pci: Replace pci_try_reset_function() with
 __pci_reset_function_locked() to ensure that the pci device configuration
 space is restored to its original state
Message-ID: <20190816092415.1b05aa0a@x1.home>
In-Reply-To: <1565926427-21675-1-git-send-email-hexin15@baidu.com>
References: <1565926427-21675-1-git-send-email-hexin15@baidu.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 16 Aug 2019 15:24:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Aug 2019 11:33:47 +0800
hexin <hexin.op@gmail.com> wrote:

> In vfio_pci_enable(), save the device's initial configuration information
> and then restore the configuration in vfio_pci_disable(). However, the
> execution result is not the same. Since the pci_try_reset_function()
> function saves the current state before resetting, the configuration
> information restored by pci_load_and_free_saved_state() will be
> overwritten. The __pci_reset_function_locked() function can be used
> to prevent the configuration space from being overwritten.
> 
> Signed-off-by: hexin <hexin15@baidu.com>
> Signed-off-by: Liu Qi <liuqi16@baidu.com>
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 703948c..3c93492 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -441,8 +441,14 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  	 * Try to reset the device.  The success of this is dependent on
>  	 * being able to lock the device, which is not always possible.
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

This used to work, I think what happened is that we initially called
__pci_reset_function() to avoid the saved state getting overwritten,
then commit d24cdbfd28b7 ("vfio-pci: Avoid deadlock on remove") added
the trylock support to avoid deadlock, then commit 890ed578df82
("vfio-pci: Use pci "try" reset interface") assumed the trylock was the
reason for the unusual calling convention and simply replaced it with
pci_try_reset_function().  So, I think we need two things.  First, a
fixes tag:

Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")

Second, a comment to warn us against performing a similar cleanup again
in the future.  Thanks,

Alex
