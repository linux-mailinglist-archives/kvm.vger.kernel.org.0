Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93341759EA1
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjGSTck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjGSTci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 15:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2366D199A;
        Wed, 19 Jul 2023 12:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA37D617F4;
        Wed, 19 Jul 2023 19:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C165BC433C8;
        Wed, 19 Jul 2023 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689795156;
        bh=5B2uDA9tsswf97AKzHjJwVKSaC/eQwz3Ft+8HwN2cMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=sKPn8HunIyLND9JEMu4ESWhCtE81F+Kc4q9T+MsHvJe5fiVAGpbXuDRp/BYXpZpLS
         W6t2CpoThhFjaBKMq9V/vJ4xDtEDO/+QJLKs4qmGj74udh8yjbH1CzdstTCReicUZ8
         a+GuNCN4+RignvXbuNN79PYXWUJifJtjcjTBO9iPpuJst49Rh/J1yePIbEk1m6saDf
         mz8tkyzl0u4mUpS4M6IUgiyI4u7WnVW2a2CTTQ6PLdK70OCT8nqJw53A7dhVhXa36m
         HFuvV439o4y7M4ZqbsSopjve8dD2ar20mZs0A1OecssekbzYQInKUphXz5EvXRa7wO
         tCq85pkSsXacQ==
Date:   Wed, 19 Jul 2023 14:32:33 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
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
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v3 4/9] PCI/VGA: Improve the default VGA device selection
Message-ID: <20230719193233.GA511659@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711164310.791756-5-sui.jingfeng@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc linux-pci (please cc in the future since the bulk of this patch
is in drivers/pci/)]

On Wed, Jul 12, 2023 at 12:43:05AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> Currently, the strategy of selecting the default boot on a multiple video
> card coexistence system is not perfect. Potential problems are:
> 
> 1) This function is a no-op on non-x86 architectures.

Which function in particular is a no-op for non-x86?

> 2) It does not take the PCI Bar may get relocated into consideration.
> 3) It is not effective for the PCI device without a dedicated VRAM Bar.
> 4) It is device-agnostic, thus it has to waste the effort to iterate all
>    of the PCI Bar to find the VRAM aperture.
> 5) It has invented lots of methods to determine which one is the default
>    boot device, but this is still a policy because it doesn't give the
>    user a choice to override.

I don't think we need a list of *potential* problems.  We need an
example of the specific problem this will solve, i.e., what currently
does not work?

The drm/ast and maybe drm/loongson patches are the only ones that use
the new callback, so I assume there are real problems with those
drivers.

CONFIG_DRM_AST is a tristate.  We're talking about identifying the
boot-time console device.  So if CONFIG_DRM_AST=m, I guess we don't
get the benefit of the new callback unless the module gets loaded?

> Also honor the comment: "Clients have *TWO* callback mechanisms they
> can use"

This refers to the existing vga_client_register() function comment:

   * vga_client_register - register or unregister a VGA arbitration client
   * @pdev: pci device of the VGA client
   * @set_decode: vga decode change callback
   *
   * Clients have two callback mechanisms they can use.
   *
   * @set_decode callback: If a client can disable its GPU VGA resource, it
   * will get a callback from this to set the encode/decode state.

and the fact that struct vga_device currently only contains *one*
callback function pointer:

  unsigned int (*set_decode)(struct pci_dev *pdev, bool decode);

Adding the .is_primary_gpu() callback does mean there will now be two
callbacks, as the comment says, but I think it's just confusing to
mention this in the commit log, so I would just remove it.

> @@ -1509,13 +1543,24 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>  	 * cases of hotplugable vga cards.
>  	 */
>  
> -	if (action == BUS_NOTIFY_ADD_DEVICE)
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
>  		notify = vga_arbiter_add_pci_device(pdev);
> -	else if (action == BUS_NOTIFY_DEL_DEVICE)
> +		if (notify)
> +			vga_arbiter_notify_clients();
> +		break;
> +	case BUS_NOTIFY_DEL_DEVICE:
>  		notify = vga_arbiter_del_pci_device(pdev);
> +		if (notify)
> +			vga_arbiter_notify_clients();
> +		break;
> +	case BUS_NOTIFY_BOUND_DRIVER:
> +		vga_arbiter_do_arbitration(pdev);
> +		break;
> +	default:
> +		break;
> +	}

Changing from if/else to switch makes the patch bigger than necessary
for no real benefit and obscures what is really changing.

Bjorn
