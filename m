Return-Path: <kvm+bounces-7484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 330DD84297F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57A241C22898
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 16:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C751292DF;
	Tue, 30 Jan 2024 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FYexxznC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42733128391
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706632591; cv=none; b=YoVl4stSlSSiL2P7Dm6fpBr2SAFIKqC/phYmJ0YbTU0j8Cc9YlPZFoIAav+Y/RHlHlaSJwWuKJA2DPaLHj9h3cDUApTvK1jYLm0m2qW92+Ohr80oezB23MvZWDKb8xslaXf8tx/HwNW1VPWKFEUbfgFSP3eyUGzG9FIKp7OtNXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706632591; c=relaxed/simple;
	bh=NyAFEG3jjquojKvDEjnB8WqEC2E/nWK7KwvTxbNqhZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCr8s9ceXWdxVafOnF3ZiP3KrCPe9H6RnCux1ELUGOh4c828Db4Uq05qv/YSfuMpR6752xVjGVfQlgI4txlf7bhZLjGOr+2GbuatZ8uaqaEY49jN+4y8bI7+WpzC9S8mRIa1TUfY54lAFuuq2bf1u7cm8rq66oSMaQ3NoWo641E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FYexxznC; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706632589; x=1738168589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NyAFEG3jjquojKvDEjnB8WqEC2E/nWK7KwvTxbNqhZo=;
  b=FYexxznCUJJRrY91EhLoigu2zG7lliXM8Brwes7nQXJquvDS24e1Haob
   wiG9Z0W9R/qXloXYWxh2WqANdfFX93gZEyvd4edqhcnIBWFKF5CmVuUec
   /qRW65Edn0siko1Ds53oRj273iAKFPemJgVv5C4Jo+NaNWGE7jK+Ttjcv
   Rb91lZX7vJ4IbaeTEoWYHbk191cSUDvLaRKKpYSNbekS7k0nKWFtWu5T2
   FBXd879eOVdCDzh4gVi9rPhzVk9ljmnL3UX7KZmNQ3rtcV4196HWHXFfX
   Bzmf0LGFGPg6ubMZut5LVGAKRqkLuACRL6o5akmSLq832OmQTb0xh9h7D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="400474533"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="400474533"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 08:35:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="36550287"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa001.jf.intel.com with ESMTP; 30 Jan 2024 08:35:20 -0800
Date: Wed, 31 Jan 2024 00:48:49 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Barrat <fbarrat@linux.ibm.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>, mzamazal@redhat.com,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 01/29] bulk: Access existing variables initialized to
 &S->F when available
Message-ID: <Zbkocf5XDOCsXWp6@intel.com>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240129164514.73104-2-philmd@linaro.org>

On Mon, Jan 29, 2024 at 05:44:43PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Mon, 29 Jan 2024 17:44:43 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v3 01/29] bulk: Access existing variables initialized to
>  &S->F when available
> X-Mailer: git-send-email 2.41.0
> 
> When a variable is initialized to &struct->field, use it
> in place. Rationale: while this makes the code more concise,
> this also helps static analyzers.
> 
> Mechanical change using the following Coccinelle spatch script:
> 
>  @@
>  type S, F;
>  identifier s, m, v;
>  @@
>       S *s;
>       ...
>       F *v = &s->m;
>       <+...
>  -    &s->m
>  +    v
>       ...+>
> 
> Inspired-by: Zhao Liu <zhao1.liu@intel.com>

Thanks!

> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  hw/display/ati.c              |  2 +-
>  hw/misc/macio/pmu.c           |  2 +-
>  hw/misc/pvpanic-pci.c         |  2 +-
>  hw/pci-bridge/cxl_root_port.c |  2 +-
>  hw/ppc/pnv.c                  | 20 ++++++++++----------
>  hw/virtio/vhost-user-gpio.c   |  8 ++++----
>  hw/virtio/vhost-user-scmi.c   |  6 +++---
>  hw/virtio/virtio-pci.c        |  2 +-
>  hw/xen/xen_pt.c               |  6 +++---
>  migration/multifd-zlib.c      |  2 +-
>  target/arm/cpu.c              |  4 ++--
>  target/arm/kvm.c              |  2 +-
>  target/arm/machine.c          |  6 +++---
>  target/i386/hvf/x86hvf.c      |  2 +-
>  target/m68k/helper.c          |  2 +-
>  target/ppc/kvm.c              |  8 ++++----
>  target/riscv/cpu_helper.c     |  2 +-
>  17 files changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/hw/display/ati.c b/hw/display/ati.c
> index 569b8f6165..8d2501bd82 100644
> --- a/hw/display/ati.c
> +++ b/hw/display/ati.c
> @@ -991,7 +991,7 @@ static void ati_vga_realize(PCIDevice *dev, Error **errp)
>      }
>      vga_init(vga, OBJECT(s), pci_address_space(dev),
>               pci_address_space_io(dev), true);
> -    vga->con = graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, &s->vga);
> +    vga->con = graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, vga);
>      if (s->cursor_guest_mode) {
>          vga->cursor_invalidate = ati_cursor_invalidate;
>          vga->cursor_draw_line = ati_cursor_draw_line;
> diff --git a/hw/misc/macio/pmu.c b/hw/misc/macio/pmu.c
> index e9a90da88f..7fe1c4e517 100644
> --- a/hw/misc/macio/pmu.c
> +++ b/hw/misc/macio/pmu.c
> @@ -737,7 +737,7 @@ static void pmu_realize(DeviceState *dev, Error **errp)
>      timer_mod(s->one_sec_timer, s->one_sec_target);
>  
>      if (s->has_adb) {
> -        qbus_init(&s->adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,
> +        qbus_init(adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,
>                    dev, "adb.0");
>          adb_register_autopoll_callback(adb_bus, pmu_adb_poll, s);
>      }

I just have the similar comment as BALATON here.

But I feel like it's not easy to cover this case by script, and further
manual cleanup for "sizeof(s->adb_bus)" is okay.

Others are also okay for me.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> diff --git a/hw/misc/pvpanic-pci.c b/hw/misc/pvpanic-pci.c
> index c01e4ce864..83be95d0d2 100644
> --- a/hw/misc/pvpanic-pci.c
> +++ b/hw/misc/pvpanic-pci.c
> @@ -48,7 +48,7 @@ static void pvpanic_pci_realizefn(PCIDevice *dev, Error **errp)
>      PVPanicPCIState *s = PVPANIC_PCI_DEVICE(dev);
>      PVPanicState *ps = &s->pvpanic;
>  
> -    pvpanic_setup_io(&s->pvpanic, DEVICE(s), 2);
> +    pvpanic_setup_io(ps, DEVICE(s), 2);
>  
>      pci_register_bar(dev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &ps->mr);
>  }
> diff --git a/hw/pci-bridge/cxl_root_port.c b/hw/pci-bridge/cxl_root_port.c
> index 8f97697631..2cf2f7bf5f 100644
> --- a/hw/pci-bridge/cxl_root_port.c
> +++ b/hw/pci-bridge/cxl_root_port.c
> @@ -175,7 +175,7 @@ static void cxl_rp_realize(DeviceState *dev, Error **errp)
>  
>      cxl_cstate->dvsec_offset = CXL_ROOT_PORT_DVSEC_OFFSET;
>      cxl_cstate->pdev = pci_dev;
> -    build_dvsecs(&crp->cxl_cstate);
> +    build_dvsecs(cxl_cstate);
>  
>      cxl_component_register_block_init(OBJECT(pci_dev), cxl_cstate,
>                                        TYPE_CXL_ROOT_PORT);
> diff --git a/hw/ppc/pnv.c b/hw/ppc/pnv.c
> index 0297871bdd..202a569e27 100644
> --- a/hw/ppc/pnv.c
> +++ b/hw/ppc/pnv.c
> @@ -1257,11 +1257,11 @@ static void pnv_chip_power8_realize(DeviceState *dev, Error **errp)
>      }
>  
>      /* Processor Service Interface (PSI) Host Bridge */
> -    object_property_set_int(OBJECT(&chip8->psi), "bar", PNV_PSIHB_BASE(chip),
> +    object_property_set_int(OBJECT(psi8), "bar", PNV_PSIHB_BASE(chip),
>                              &error_fatal);
> -    object_property_set_link(OBJECT(&chip8->psi), ICS_PROP_XICS,
> +    object_property_set_link(OBJECT(psi8), ICS_PROP_XICS,
>                               OBJECT(chip8->xics), &error_abort);
> -    if (!qdev_realize(DEVICE(&chip8->psi), NULL, errp)) {
> +    if (!qdev_realize(DEVICE(psi8), NULL, errp)) {
>          return;
>      }
>      pnv_xscom_add_subregion(chip, PNV_XSCOM_PSIHB_BASE,
> @@ -1292,7 +1292,7 @@ static void pnv_chip_power8_realize(DeviceState *dev, Error **errp)
>      }
>      pnv_xscom_add_subregion(chip, PNV_XSCOM_OCC_BASE, &chip8->occ.xscom_regs);
>      qdev_connect_gpio_out(DEVICE(&chip8->occ), 0,
> -                          qdev_get_gpio_in(DEVICE(&chip8->psi), PSIHB_IRQ_OCC));
> +                          qdev_get_gpio_in(DEVICE(psi8), PSIHB_IRQ_OCC));
>  
>      /* OCC SRAM model */
>      memory_region_add_subregion(get_system_memory(), PNV_OCC_SENSOR_BASE(chip),
> @@ -1543,12 +1543,12 @@ static void pnv_chip_power9_realize(DeviceState *dev, Error **errp)
>                              &chip9->xive.xscom_regs);
>  
>      /* Processor Service Interface (PSI) Host Bridge */
> -    object_property_set_int(OBJECT(&chip9->psi), "bar", PNV9_PSIHB_BASE(chip),
> +    object_property_set_int(OBJECT(psi9), "bar", PNV9_PSIHB_BASE(chip),
>                              &error_fatal);
>      /* This is the only device with 4k ESB pages */
> -    object_property_set_int(OBJECT(&chip9->psi), "shift", XIVE_ESB_4K,
> +    object_property_set_int(OBJECT(psi9), "shift", XIVE_ESB_4K,
>                              &error_fatal);
> -    if (!qdev_realize(DEVICE(&chip9->psi), NULL, errp)) {
> +    if (!qdev_realize(DEVICE(psi9), NULL, errp)) {
>          return;
>      }
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_PSIHB_BASE,
> @@ -1571,7 +1571,7 @@ static void pnv_chip_power9_realize(DeviceState *dev, Error **errp)
>      }
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_OCC_BASE, &chip9->occ.xscom_regs);
>      qdev_connect_gpio_out(DEVICE(&chip9->occ), 0, qdev_get_gpio_in(
> -                              DEVICE(&chip9->psi), PSIHB9_IRQ_OCC));
> +                              DEVICE(psi9), PSIHB9_IRQ_OCC));
>  
>      /* OCC SRAM model */
>      memory_region_add_subregion(get_system_memory(), PNV9_OCC_SENSOR_BASE(chip),
> @@ -1586,7 +1586,7 @@ static void pnv_chip_power9_realize(DeviceState *dev, Error **errp)
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_SBE_MBOX_BASE,
>                              &chip9->sbe.xscom_mbox_regs);
>      qdev_connect_gpio_out(DEVICE(&chip9->sbe), 0, qdev_get_gpio_in(
> -                              DEVICE(&chip9->psi), PSIHB9_IRQ_PSU));
> +                              DEVICE(psi9), PSIHB9_IRQ_PSU));
>  
>      /* HOMER */
>      object_property_set_link(OBJECT(&chip9->homer), "chip", OBJECT(chip),
> @@ -1627,7 +1627,7 @@ static void pnv_chip_power9_realize(DeviceState *dev, Error **errp)
>                                          PNV9_XSCOM_I2CM_SIZE,
>                                  &chip9->i2c[i].xscom_regs);
>          qdev_connect_gpio_out(DEVICE(&chip9->i2c[i]), 0,
> -                              qdev_get_gpio_in(DEVICE(&chip9->psi),
> +                              qdev_get_gpio_in(DEVICE(psi9),
>                                                 PSIHB9_IRQ_SBE_I2C));
>      }
>  }
> diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
> index a83437a5da..6d4e9200ff 100644
> --- a/hw/virtio/vhost-user-gpio.c
> +++ b/hw/virtio/vhost-user-gpio.c
> @@ -79,9 +79,9 @@ static int vu_gpio_start(VirtIODevice *vdev)
>       * set needed for the vhost configuration. The backend may also
>       * apply backend_features when the feature set is sent.
>       */
> -    vhost_ack_features(&gpio->vhost_dev, feature_bits, vdev->guest_features);
> +    vhost_ack_features(vhost_dev, feature_bits, vdev->guest_features);
>  
> -    ret = vhost_dev_start(&gpio->vhost_dev, vdev, false);
> +    ret = vhost_dev_start(vhost_dev, vdev, false);
>      if (ret < 0) {
>          error_report("Error starting vhost-user-gpio: %d", ret);
>          goto err_guest_notifiers;
> @@ -94,7 +94,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>       * enabling/disabling irqfd.
>       */
>      for (i = 0; i < gpio->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&gpio->vhost_dev, vdev, i, false);
> +        vhost_virtqueue_mask(vhost_dev, vdev, i, false);
>      }
>  
>      /*
> @@ -114,7 +114,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>  err_guest_notifiers:
>      k->set_guest_notifiers(qbus->parent, gpio->vhost_dev.nvqs, false);
>  err_host_notifiers:
> -    vhost_dev_disable_notifiers(&gpio->vhost_dev, vdev);
> +    vhost_dev_disable_notifiers(vhost_dev, vdev);
>  
>      return ret;
>  }
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index 918bb7dcf7..300847e672 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -56,9 +56,9 @@ static int vu_scmi_start(VirtIODevice *vdev)
>          goto err_host_notifiers;
>      }
>  
> -    vhost_ack_features(&scmi->vhost_dev, feature_bits, vdev->guest_features);
> +    vhost_ack_features(vhost_dev, feature_bits, vdev->guest_features);
>  
> -    ret = vhost_dev_start(&scmi->vhost_dev, vdev, true);
> +    ret = vhost_dev_start(vhost_dev, vdev, true);
>      if (ret < 0) {
>          error_report("Error starting vhost-user-scmi: %d", ret);
>          goto err_guest_notifiers;
> @@ -71,7 +71,7 @@ static int vu_scmi_start(VirtIODevice *vdev)
>       * enabling/disabling irqfd.
>       */
>      for (i = 0; i < scmi->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&scmi->vhost_dev, vdev, i, false);
> +        vhost_virtqueue_mask(vhost_dev, vdev, i, false);
>      }
>      return 0;
>  
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index 1a7039fb0c..cb6940fc0e 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -1929,7 +1929,7 @@ static void virtio_pci_device_plugged(DeviceState *d, Error **errp)
>      bool modern_pio = proxy->flags & VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY;
>      uint8_t *config;
>      uint32_t size;
> -    VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
> +    VirtIODevice *vdev = virtio_bus_get_device(bus);
>  
>      /*
>       * Virtio capabilities present without
> diff --git a/hw/xen/xen_pt.c b/hw/xen/xen_pt.c
> index 36e6f93c37..10ddf6bc91 100644
> --- a/hw/xen/xen_pt.c
> +++ b/hw/xen/xen_pt.c
> @@ -710,7 +710,7 @@ static void xen_pt_destroy(PCIDevice *d) {
>      uint8_t intx;
>      int rc;
>  
> -    if (machine_irq && !xen_host_pci_device_closed(&s->real_device)) {
> +    if (machine_irq && !xen_host_pci_device_closed(host_dev)) {
>          intx = xen_pt_pci_intx(s);
>          rc = xc_domain_unbind_pt_irq(xen_xc, xen_domid, machine_irq,
>                                       PT_IRQ_TYPE_PCI,
> @@ -759,8 +759,8 @@ static void xen_pt_destroy(PCIDevice *d) {
>          memory_listener_unregister(&s->io_listener);
>          s->listener_set = false;
>      }
> -    if (!xen_host_pci_device_closed(&s->real_device)) {
> -        xen_host_pci_device_put(&s->real_device);
> +    if (!xen_host_pci_device_closed(host_dev)) {
> +        xen_host_pci_device_put(host_dev);
>      }
>  }
>  /* init */
> diff --git a/migration/multifd-zlib.c b/migration/multifd-zlib.c
> index 37ce48621e..237ee49928 100644
> --- a/migration/multifd-zlib.c
> +++ b/migration/multifd-zlib.c
> @@ -75,7 +75,7 @@ static int zlib_send_setup(MultiFDSendParams *p, Error **errp)
>  err_free_zbuff:
>      g_free(z->zbuff);
>  err_deflate_end:
> -    deflateEnd(&z->zs);
> +    deflateEnd(zs);
>  err_free_z:
>      g_free(z);
>      error_setg(errp, "multifd %u: %s", p->id, err_msg);
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index b60e103046..60ab8f3242 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -2087,7 +2087,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>       * We rely on no XScale CPU having VFP so we can use the same bits in the
>       * TB flags field for VECSTRIDE and XSCALE_CPAR.
>       */
> -    assert(arm_feature(&cpu->env, ARM_FEATURE_AARCH64) ||
> +    assert(arm_feature(env, ARM_FEATURE_AARCH64) ||
>             !cpu_isar_feature(aa32_vfp_simd, cpu) ||
>             !arm_feature(env, ARM_FEATURE_XSCALE));
>  
> @@ -2129,7 +2129,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>      }
>  
>      if (cpu->cfgend) {
> -        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
> +        if (arm_feature(env, ARM_FEATURE_V7)) {
>              cpu->reset_sctlr |= SCTLR_EE;
>          } else {
>              cpu->reset_sctlr |= SCTLR_B;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 81813030a5..ab85d628a8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1888,7 +1888,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> -    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
> +    if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
>      }
>      if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index 9d7dbaea54..b2b39b2475 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -773,7 +773,7 @@ static int cpu_pre_load(void *opaque)
>      env->irq_line_state = UINT32_MAX;
>  
>      if (!kvm_enabled()) {
> -        pmu_op_start(&cpu->env);
> +        pmu_op_start(env);
>      }
>  
>      return 0;
> @@ -871,11 +871,11 @@ static int cpu_post_load(void *opaque, int version_id)
>      }
>  
>      if (!kvm_enabled()) {
> -        pmu_op_finish(&cpu->env);
> +        pmu_op_finish(env);
>      }
>  
>      if (tcg_enabled()) {
> -        arm_rebuild_hflags(&cpu->env);
> +        arm_rebuild_hflags(env);
>      }
>  
>      return 0;
> diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
> index 3b1ef5f49a..be2c46246e 100644
> --- a/target/i386/hvf/x86hvf.c
> +++ b/target/i386/hvf/x86hvf.c
> @@ -408,7 +408,7 @@ bool hvf_inject_interrupts(CPUState *cs)
>      if (!(env->hflags & HF_INHIBIT_IRQ_MASK) &&
>          (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
>          (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
> -        int line = cpu_get_pic_interrupt(&x86cpu->env);
> +        int line = cpu_get_pic_interrupt(env);
>          cs->interrupt_request &= ~CPU_INTERRUPT_HARD;
>          if (line >= 0) {
>              wvmcs(cs->accel->fd, VMCS_ENTRY_INTR_INFO, line |
> diff --git a/target/m68k/helper.c b/target/m68k/helper.c
> index 14508dfa11..a812f328a1 100644
> --- a/target/m68k/helper.c
> +++ b/target/m68k/helper.c
> @@ -972,7 +972,7 @@ bool m68k_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
>          access_type |= ACCESS_SUPER;
>      }
>  
> -    ret = get_physical_address(&cpu->env, &physical, &prot,
> +    ret = get_physical_address(env, &physical, &prot,
>                                 address, access_type, &page_size);
>      if (likely(ret == 0)) {
>          tlb_set_page(cs, address & TARGET_PAGE_MASK,
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 26fa9d0575..b95a0b4928 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -635,8 +635,8 @@ static int kvm_put_fp(CPUState *cs)
>  
>          for (i = 0; i < 32; i++) {
>              uint64_t vsr[2];
> -            uint64_t *fpr = cpu_fpr_ptr(&cpu->env, i);
> -            uint64_t *vsrl = cpu_vsrl_ptr(&cpu->env, i);
> +            uint64_t *fpr = cpu_fpr_ptr(env, i);
> +            uint64_t *vsrl = cpu_vsrl_ptr(env, i);
>  
>  #if HOST_BIG_ENDIAN
>              vsr[0] = float64_val(*fpr);
> @@ -704,8 +704,8 @@ static int kvm_get_fp(CPUState *cs)
>  
>          for (i = 0; i < 32; i++) {
>              uint64_t vsr[2];
> -            uint64_t *fpr = cpu_fpr_ptr(&cpu->env, i);
> -            uint64_t *vsrl = cpu_vsrl_ptr(&cpu->env, i);
> +            uint64_t *fpr = cpu_fpr_ptr(env, i);
> +            uint64_t *vsrl = cpu_vsrl_ptr(env, i);
>  
>              reg.addr = (uintptr_t) &vsr;
>              reg.id = vsx ? KVM_REG_PPC_VSR(i) : KVM_REG_PPC_FPR(i);
> diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
> index c7cc7eb423..791435d628 100644
> --- a/target/riscv/cpu_helper.c
> +++ b/target/riscv/cpu_helper.c
> @@ -1200,7 +1200,7 @@ hwaddr riscv_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
>      CPURISCVState *env = &cpu->env;
>      hwaddr phys_addr;
>      int prot;
> -    int mmu_idx = cpu_mmu_index(&cpu->env, false);
> +    int mmu_idx = cpu_mmu_index(env, false);
>  
>      if (get_physical_address(env, &phys_addr, &prot, addr, NULL, 0, mmu_idx,
>                               true, env->virt_enabled, true)) {
> -- 
> 2.41.0
> 
> 

