Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888F7510026
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351488AbiDZORP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 10:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347711AbiDZORO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 10:17:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E945218E3B;
        Tue, 26 Apr 2022 07:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828E2617A1;
        Tue, 26 Apr 2022 14:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3670C385AA;
        Tue, 26 Apr 2022 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650982445;
        bh=vIR/I/WOOXwUWDTjzFU2wGyQYvRoYeEp7ly2vdSZ6O4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=sx18sAHN6xtgoLtYNmnTs1Rj6iwG7aHsyGqrxqCC8/AL+ICJeYvXbJxSP7wc194FU
         rjh5rVpDJ2wl+mqqCoTNsVP6vEubQelHsJA3uNEm711NWLCjUYXJ4oIJJK1iH80Ddx
         ZxeyANsNGnIOtnu12u+kdjdS7KZuIQflZhUNt5L2H5PJD2OYgQO5P9At0vJSnrMBCS
         GOvFuUXoHl+NxXKs6g/jlTeeHbZ9zoxIUFdjMRFlJUYZN+fAfB8n5kWrcfv5jXfZ3o
         7gAmRnr/8bKFANdFtm3TQoKc+3rZjQ52ESo9kECxpAZ73nT3yet5U6draFHvyNGQWp
         k7/OqCpxHc4IA==
Date:   Tue, 26 Apr 2022 09:14:03 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>, kbuild-all@lists.01.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 1/8] vfio/pci: Invalidate mmaps and block the access
 in D3hot power state
Message-ID: <20220426141403.GA1723756@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204260928.TsUAxMD3-lkp@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 09:42:45AM +0800, kernel test robot wrote:
> ...

> sparse warnings: (new ones prefixed by >>)
> >> drivers/vfio/pci/vfio_pci_config.c:703:13: sparse: sparse: restricted pci_power_t degrades to integer
>    drivers/vfio/pci/vfio_pci_config.c:703:22: sparse: sparse: restricted pci_power_t degrades to integer

I dunno what Alex thinks, but we have several of these warnings in
drivers/pci/.  I'd like to get rid of them, but we haven't figured out
a good way yet.  So this might be something we just live with for now.

> vim +703 drivers/vfio/pci/vfio_pci_config.c
> 
>    694	
>    695	/*
>    696	 * It takes all the required locks to protect the access of power related
>    697	 * variables and then invokes vfio_pci_set_power_state().
>    698	 */
>    699	static void
>    700	vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
>    701				      pci_power_t state)
>    702	{
>  > 703		if (state >= PCI_D3hot)
>    704			vfio_pci_zap_and_down_write_memory_lock(vdev);
>    705		else
>    706			down_write(&vdev->memory_lock);
>    707	
>    708		vfio_pci_set_power_state(vdev, state);
>    709		up_write(&vdev->memory_lock);
>    710	}
>    711	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
