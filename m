Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849BD4FF09A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiDMHfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 03:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiDMHfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 03:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940313F3F;
        Wed, 13 Apr 2022 00:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83BB261298;
        Wed, 13 Apr 2022 07:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED4DC385A3;
        Wed, 13 Apr 2022 07:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649835204;
        bh=Eth9R1jVxiIpBjWdOSRBL4N9xcIJCp4d4G7NUjOd5jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1PNsbVhKl0Pz2TNrKSRGuGYsBuUBxpI7hZKwOXR+sDJyP5ZGsA27q05hGoW8YSp0G
         H+TyEs1ZbkLnMymfx9E/9lwZBEgpO6yOsRCNV/8nti/iksdCoHdP6pu358ZAXF8wvo
         a4C3eH+n9TAHDT3N36Rryk51t2CdM/ZqzSbYxRXo=
Date:   Wed, 13 Apr 2022 09:33:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yao Hongbo <yaohongbo@linux.alibaba.com>
Cc:     mst@redhat.com, alikernel-developer@linux.alibaba.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uio/uio_pci_generic: Introduce refcnt on open/release
Message-ID: <YlZ8vZ9RX5i7mWNk@kroah.com>
References: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 03:01:42PM +0800, Yao Hongbo wrote:
> If two userspace programs both open the PCI UIO fd, when one
> of the program exits uncleanly, the other will cause IO hang
> due to bus-mastering disabled.
> 
> It's a common usage for spdk/dpdk to use UIO. So, introduce refcnt
> to avoid such problems.

Why do you have multiple userspace programs opening the same device?
Shouldn't they coordinate?

> 
> Fixes: 865a11f987ab("uio/uio_pci_generic: Disable bus-mastering on release")
> Reported-by: Xiu Yang <yangxiu.yx@alibaba-inc.com>
> Signed-off-by: Yao Hongbo <yaohongbo@linux.alibaba.com>
> ---
> Changes for v2:
> 	Use refcount_t instead of atomic_t to catch overflow/underflows.
> ---
>  drivers/uio/uio_pci_generic.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index e03f9b5..1a5e1fd 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -31,6 +31,7 @@
>  struct uio_pci_generic_dev {
>  	struct uio_info info;
>  	struct pci_dev *pdev;
> +	refcount_t refcnt;
>  };
>  
>  static inline struct uio_pci_generic_dev *
> @@ -39,6 +40,14 @@ struct uio_pci_generic_dev {
>  	return container_of(info, struct uio_pci_generic_dev, info);
>  }
>  
> +static int open(struct uio_info *info, struct inode *inode)
> +{
> +	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> +
> +	refcount_inc(&gdev->refcnt);
> +	return 0;
> +}
> +
>  static int release(struct uio_info *info, struct inode *inode)
>  {
>  	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> @@ -51,7 +60,9 @@ static int release(struct uio_info *info, struct inode *inode)
>  	 * Note that there's a non-zero chance doing this will wedge the device
>  	 * at least until reset.
>  	 */
> -	pci_clear_master(gdev->pdev);
> +	if (refcount_dec_and_test(&gdev->refcnt))
> +		pci_clear_master(gdev->pdev);

The goal here is to flush things when userspace closes the device, as
the comment says.  So don't you want that to happen for when userspace
closes the file handle no matter who opened it?

As this is a functional change, how is userspace going to "know" this
functionality is now changed or not?

And if userspace really wants to open this multiple times, then properly
switch the code to only create the device-specific structures when open
is called.  Otherwise you are sharing structures here that are not
intended to be shared, shouldn't you have your own private one?

this feels odd.

thanks,

greg k-h
