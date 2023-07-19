Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76E75A010
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 22:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjGSUnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 16:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGSUnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 16:43:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1909E;
        Wed, 19 Jul 2023 13:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699A46182F;
        Wed, 19 Jul 2023 20:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A388C433C8;
        Wed, 19 Jul 2023 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689799396;
        bh=Tyjuk2o5/6zWPoP1zMw3/ypWfYVhxYWg4rjX3S4aZtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FiAa9y/2tv71wEXdSyAGzNYhBUxM+hvhiaqxmMnzXpP8UcpFHg9j/QVPzqJ1auM37
         lbHnkX0NYfz7AI9yHQjtRu9TYLXdBTGLfLBfe6m5AW1ZMZ1Db0D8YHv0o/kXURCPBg
         6o2jg6IJRGYIgt179i38xPkXzaLIsMgsxFnK0fpi91ooT8kKWcS8B/1ovFntmhRFU0
         Q8BPuImDwnSqp/UoGGhqBPPlkEWcYQ8KgeRMf3mdhJTJhj6Do9nbOMZCXofTjkWIFw
         Snq6WsZ6LAoKSxoq4zjBx4b7UYqEw6ID5xRozHH9G3pl2v8PjgHJhBEsxoAdXceHil
         xp9Aiqzk429pA==
Date:   Wed, 19 Jul 2023 15:43:14 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v3 3/9] PCI/VGA: Switch to
 aperture_contain_firmware_fb_nonreloc()
Message-ID: <20230719204314.GA512532@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711164310.791756-4-sui.jingfeng@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc linux-pci; I don't apply or ack PCI patches unless they appear there]

On Wed, Jul 12, 2023 at 12:43:04AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> The observation behind this is that we should avoid accessing the global
> screen_info directly. Call the aperture_contain_firmware_fb_nonreloc()
> function to implement the detection of whether an aperture contains the
> firmware FB.

Because it's better to access the global screen_info from
aperture_contain_firmware_fb_nonreloc()?  The reasoning here is not
super clear to me.

> This patch helps to decouple the determination from the implementation.
> Or, in other words, we intend to make the determination opaque to the
> caller. The determination may choose to be arch-dependent or
> arch-independent. But vgaarb, as a consumer of the determination,
> shouldn't care how the does determination is implemented.

"how the determination ..."  (drop the "does")

Are you saying that aperture_contain_firmware_fb_nonreloc() might be
arch-dependent?  Are there multiple callers?  Or does this just move
code from one place to a more appropriate place?

> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
> ---
>  drivers/pci/vgaarb.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index bf96e085751d..953daf731b2c 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -14,6 +14,7 @@
>  #define vgaarb_info(dev, fmt, arg...)	dev_info(dev, "vgaarb: " fmt, ##arg)
>  #define vgaarb_err(dev, fmt, arg...)	dev_err(dev, "vgaarb: " fmt, ##arg)
>  
> +#include <linux/aperture.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
> @@ -26,7 +27,6 @@
>  #include <linux/poll.h>
>  #include <linux/miscdevice.h>
>  #include <linux/slab.h>
> -#include <linux/screen_info.h>
>  #include <linux/vt.h>
>  #include <linux/console.h>
>  #include <linux/acpi.h>
> @@ -558,20 +558,11 @@ void vga_put(struct pci_dev *pdev, unsigned int rsrc)
>  }
>  EXPORT_SYMBOL(vga_put);
>  
> +/* Select the device owning the boot framebuffer if there is one */
>  static bool vga_is_firmware_default(struct pci_dev *pdev)
>  {
>  #if defined(CONFIG_X86) || defined(CONFIG_IA64)
> -	u64 base = screen_info.lfb_base;
> -	u64 size = screen_info.lfb_size;
>  	struct resource *r;
> -	u64 limit;
> -
> -	/* Select the device owning the boot framebuffer if there is one */
> -
> -	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> -		base |= (u64)screen_info.ext_lfb_base << 32;
> -
> -	limit = base + size;
>  
>  	/* Does firmware framebuffer belong to us? */
>  	pci_dev_for_each_resource(pdev, r) {
> @@ -581,10 +572,8 @@ static bool vga_is_firmware_default(struct pci_dev *pdev)
>  		if (!r->start || !r->end)
>  			continue;
>  
> -		if (base < r->start || limit >= r->end)
> -			continue;
> -
> -		return true;
> +		if (aperture_contain_firmware_fb_nonreloc(r->start, r->end))
> +			return true;
>  	}
>  #endif
>  	return false;
> -- 
> 2.25.1
> 
