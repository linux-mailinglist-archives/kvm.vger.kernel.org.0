Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A543039EEDA
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhFHGqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHGqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:46:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE91361027;
        Tue,  8 Jun 2021 06:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623134666;
        bh=/nC6nYxeTF0nbhiA9iAx0FL5CA4WFk+m7nTx4iY0juY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8OUVeWN2qfc5qMTjvvpWdJqhOzpm0zZQkbVnAVNKTe9XJMIBjP5wAOQr3vHjXN0C
         n6HmBTFf3ZTaHL2zG+rlBN9omuhWDEJPjhE25x4ty2hXqZTa9/G2Box6HBV5xQ8wmv
         QTwYTxAPqXgKbWPd/lMCyJ3pK+25y9q9kzVFUK/0=
Date:   Tue, 8 Jun 2021 08:44:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <YL8RxPEMCDTXnPDg@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:43PM -0300, Jason Gunthorpe wrote:
> Once a driver has been matched and probe() returns with -EPROBE_DEFER the
> device is added to a deferred list and will be retried later.
> 
> At this point __device_attach_driver() should stop trying other drivers as
> we have "matched" this driver and already scheduled another probe to
> happen later.
> 
> Return the -EPROBE_DEFER from really_probe() instead of squashing it to
> zero. This is similar to the code at the top of the function which
> directly returns -EPROBE_DEFER.
> 
> It is not really a bug as, AFAIK, we don't actually have cases where
> multiple drivers can bind.

We _do_ have devices that multiple drivers can bind to.  Are you sure
you did not just break them?

Why are you needing to change this?  What is it helping?  What problem
is this solving?

thanks,

greg k-h
