Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE3F39EFCF
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 09:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFHHj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 03:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhFHHjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 03:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F49E6127A;
        Tue,  8 Jun 2021 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623137882;
        bh=XZ8iSH8M+3GOJRVvEHJh8BDZ1zck8tiBAvw/IlyKZEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ys1bUVZAIeECORzOm8JTce2TIoZoOFHZkuuFxV3IJQHax9CjJbXEDQyPRyrTYahh8
         AjJdmFpuTGwoj6vOQOBUXveTeT0fw8gHxI4pWxseoETODOByNoRErLmobiyHMrNjP/
         53NwWC3F++a18CG30HvmdyClZ8n0fV7JWIy3xkUA=
Date:   Tue, 8 Jun 2021 09:37:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 04/10] driver core: Don't return EPROBE_DEFER to
 userspace during sysfs bind
Message-ID: <YL8eV9mhSNxY+1uX@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <4-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:46PM -0300, Jason Gunthorpe wrote:
> EPROBE_DEFER is an internal kernel error code and it should not be leaked
> to userspace via the bind_store() sysfs. Userspace doesn't have this
> constant and cannot understand it.
> 
> Further, it doesn't really make sense to have userspace trigger a deferred
> probe via bind_store(), which could eventually succeed, while
> simultaneously returning an error back.
> 
> Resolve this by preventing EPROBE_DEFER from triggering a deferred probe
> and simply relay the whole situation back to userspace as a normal -EAGAIN
> code.
> 
> Put this in the device_driver_attach() so the EPROBE_DEFER remains
> contained to dd.c and the probe() implementations.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/base/dd.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 7fb58e6219b255..edda7aad43a3f7 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -516,12 +516,17 @@ static DEVICE_ATTR_RO(state_synced);
>  enum {
>  	/* Set on output if the -ERR has come from a probe() function */
>  	PROBEF_DRV_FAILED = 1 << 0,
> +	/*
> +	 * Set on input to call driver_deferred_probe_add() if -EPROBE_DEFER
> +	 * is returned
> +	 */
> +	PROBEF_SCHEDULE_DEFER = 1 << 1,

I don't understand what "PROBEF" means.  Not good for something that I
am going to be forced to maintain...

Again, "flags" are horrible, but if you do have them, then they should
at least be understandable.

Please try to do this without random flag values.

thanks,

greg k-h
