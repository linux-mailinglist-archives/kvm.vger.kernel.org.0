Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4D7287C3
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjFHTMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 15:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbjFHTMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 15:12:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0400530D2;
        Thu,  8 Jun 2023 12:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221EC61554;
        Thu,  8 Jun 2023 19:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29690C433D2;
        Thu,  8 Jun 2023 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686251543;
        bh=BjGgyC3wTO33c1Tdxatub3Rc/d6F/CPXBfd8u1gAIrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=T+IHeID0iP9vHKnUCZWCJZGQQf3diXJ9+HZsVX4IN+ITJMvEmanSAYv3Yzh8azF0B
         DwTD2hES7OI5X32J985zgUykL/VJC17J9RWkJQocx9kBsAVQUtN7/9qJ1fWYGoetMd
         eBQKXEF35moYax03HHpcg4x4OoiW4apuLCA/DkwSUiABGP3VEVW+25hBWARBeaZRfn
         BiZiRj0VAURoBIfb2OJNL2jBuXv0ll/9QSOt0PcLm9QxuSuC8Mpy9D+ED/455Mv1+8
         xPYuNx2pM23hBbcf1UJIzRvvqqOOaawENsKWeMQoiXDErRHJ6Na0/r3eSuqIymPzgT
         jsqdCdkGNLeqg==
Date:   Thu, 8 Jun 2023 14:12:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <15330273260@189.cn>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Li Yi <liyi@loongson.cn>,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        loongson-kernel@lists.loongnix.cn, amd-gfx@lists.freedesktop.org,
        linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v3 3/4] PCI/VGA: only deal with VGA class
 devices
Message-ID: <20230608191221.GA1209912@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608114322.604887-4-15330273260@189.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start with verb and capitalize to match ("Deal only with ...")

On Thu, Jun 08, 2023 at 07:43:21PM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> vgaarb only deal with the VGA devcie(pdev->class == 0x0300), so replace the
> pci_get_subsys() function with pci_get_class(). Filter the non pci display
> device out. There no need to process the non display PCI device.

s/non pci/non-PCI/
s/non display/non-display/

This is fine, and I'll merge this, but someday I would like to get rid
of the bus_register_notifier() and call vga_arbiter_add_pci_device()
and vga_arbiter_del_pci_device() directly from the PCI core.

Or if you wanted to do that now, that would be even better :)

Bjorn

> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
> ---
>  drivers/pci/vgaarb.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index 7f0347f4f6fd..b0bf4952a95d 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -756,10 +756,6 @@ static bool vga_arbiter_add_pci_device(struct pci_dev *pdev)
>  	struct pci_dev *bridge;
>  	u16 cmd;
>  
> -	/* Only deal with VGA class devices */
> -	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
> -		return false;
> -
>  	/* Allocate structure */
>  	vgadev = kzalloc(sizeof(struct vga_device), GFP_KERNEL);
>  	if (vgadev == NULL) {
> @@ -1499,7 +1495,9 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	bool notify = false;
>  
> -	vgaarb_dbg(dev, "%s\n", __func__);
> +	/* Only deal with VGA class devices */
> +	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
> +		return 0;
>  
>  	/* For now we're only intereted in devices added and removed. I didn't
>  	 * test this thing here, so someone needs to double check for the
> @@ -1509,6 +1507,8 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>  	else if (action == BUS_NOTIFY_DEL_DEVICE)
>  		notify = vga_arbiter_del_pci_device(pdev);
>  
> +	vgaarb_dbg(dev, "%s: action = %lu\n", __func__, action);
> +
>  	if (notify)
>  		vga_arbiter_notify_clients();
>  	return 0;
> @@ -1533,8 +1533,8 @@ static struct miscdevice vga_arb_device = {
>  
>  static int __init vga_arb_device_init(void)
>  {
> +	struct pci_dev *pdev = NULL;
>  	int rc;
> -	struct pci_dev *pdev;
>  
>  	rc = misc_register(&vga_arb_device);
>  	if (rc < 0)
> @@ -1545,11 +1545,13 @@ static int __init vga_arb_device_init(void)
>  	/* We add all PCI devices satisfying VGA class in the arbiter by
>  	 * default
>  	 */
> -	pdev = NULL;
> -	while ((pdev =
> -		pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> -			       PCI_ANY_ID, pdev)) != NULL)
> +	while (1) {
> +		pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev);
> +		if (!pdev)
> +			break;
> +
>  		vga_arbiter_add_pci_device(pdev);
> +	};
>  
>  	pr_info("loaded\n");
>  	return rc;
> -- 
> 2.25.1
> 
