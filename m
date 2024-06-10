Return-Path: <kvm+bounces-19151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CAF90199E
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 05:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0469E1C20E97
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 03:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EBDB658;
	Mon, 10 Jun 2024 03:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNssws17"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5863D0;
	Mon, 10 Jun 2024 03:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717991987; cv=none; b=DzwDaBsYFbxHhgWqfgk6vMXEqxHdY3wzT+DR+5CsOuyv0RWse1uDtZUQ+sw2EOZHo8oF/X1pDzhRNolxaV9SPOfqkXNykY2fz8UjxkogE6UgxLmtRf15pPpW9kaXrjm0Wohai88ecj0GrXOr37SokOKn4QkGRrMrJVSWUjyiH0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717991987; c=relaxed/simple;
	bh=1Ep3bqMKgagRNMgxR68Fs+yZ1djzVtRG2dZd8HeykDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=er+6PlsT/ogGVuO5r2M/0M6k05QFQfM/8Cgs0QeP5qL42IYIrW5jRqqbSFkP1DwW2VPaxL5imbNMrrD88C0jwTkJRzCmhQ4AzkCVUrqVVrlaw1ym5O1lnH/bv/Xxbgxv/E59XLk9W5Hw5s2w2h9f/lHGB4AnkRo0JeKzadT62YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNssws17; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717991985; x=1749527985;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1Ep3bqMKgagRNMgxR68Fs+yZ1djzVtRG2dZd8HeykDY=;
  b=UNssws17gajPeBuhX7+YKih91zZn+m66tzT+aZ633V27P6d7Jr1XmJLQ
   oSTskQ597NZW+YtSveFRLPNGLYIoiHhNTsvXAJwB/AwQgPGc1yQfwSQSl
   XDtpgpmhLwinpcokYQTSgN45Bkde4wab0BURjrOXOxkt6+Br0TqpQV+ho
   33DCtYoG0YlmmGsQ8oF4oTqpgJqSGWYBIIxhPG7CF7jI/iDDkg+cEMfjb
   rA6ZipL2yzMrTpNmVZeQR7Jcc6e2RXtCn8y0yJUlmrQ7i+oqxiIAQUlaf
   QutrkkMURrWGVff9fy8LgTkqtAnHhe7PPQ4Y9YiCJzbexKtd/HcuqYdMF
   g==;
X-CSE-ConnectionGUID: QmkB5prhRjCCmcVSQQapGg==
X-CSE-MsgGUID: CM8fIT18RJapkLTR8K89xQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="14757523"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="14757523"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 20:59:43 -0700
X-CSE-ConnectionGUID: H4c9nHx+SjuVyvctpQeWAA==
X-CSE-MsgGUID: cOz1NOc4QiOB8KRjBsux+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="39012288"
Received: from lkp-server01.sh.intel.com (HELO 8967fbab76b3) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 09 Jun 2024 20:59:36 -0700
Received: from kbuild by 8967fbab76b3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sGWBy-0001q1-0c;
	Mon, 10 Jun 2024 03:59:34 +0000
Date: Mon, 10 Jun 2024 11:58:59 +0800
From: kernel test robot <lkp@intel.com>
To: Fred Griffoul <fgriffo@amazon.co.uk>, griffoul@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, Fred Griffoul <fgriffo@amazon.co.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
Message-ID: <202406101154.iaDyTRwZ-lkp@intel.com>
References: <20240607190955.15376-3-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607190955.15376-3-fgriffo@amazon.co.uk>

Hi Fred,

kernel test robot noticed the following build errors:

[auto build test ERROR on cbb325e77fbe62a06184175aa98c9eb98736c3e8]

url:    https://github.com/intel-lab-lkp/linux/commits/Fred-Griffoul/cgroup-cpuset-export-cpuset_cpus_allowed/20240608-031332
base:   cbb325e77fbe62a06184175aa98c9eb98736c3e8
patch link:    https://lore.kernel.org/r/20240607190955.15376-3-fgriffo%40amazon.co.uk
patch subject: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
config: arm64-randconfig-001-20240610 (https://download.01.org/0day-ci/archive/20240610/202406101154.iaDyTRwZ-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240610/202406101154.iaDyTRwZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406101154.iaDyTRwZ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-imp_iic_wrap.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-ipe.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-mfg.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-mm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-msdc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-scp_adsp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8192-vdec.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8365-apmixedsys.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8365.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8365-apu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8365-mm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/mediatek/clk-mt8365-venc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/meson/a1-peripherals.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sunxi-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/suniv-f1c100s-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun20i-d1-r-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun50i-a64-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun50i-a100-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun50i-h6-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun50i-h6-r-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun50i-h616-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun4i-a10-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun8i-a23-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun8i-a83t-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun8i-h3-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun8i-r40-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun8i-v3s-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun9i-a80-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun9i-a80-de-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/sunxi-ng/sun9i-a80-usb-ccu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/versatile/clk-vexpress-osc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/qcom/clk-qcom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/qcom/gcc-msm8976.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/clk/qcom/videocc-sdm845.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dma/ti/omap-dma.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dma/dmatest.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/soc/imx/soc-imx8m.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/soc/amlogic/meson-clk-measure.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/pmdomain/amlogic/meson-gx-pwrc-vpu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/xen/xenbus/xenbus_probe_frontend.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/xen/xen-pciback/xen-pciback.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/xen/xen-privcmd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/regulator/da9121-regulator.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/regulator/max20411-regulator.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/reset/hisilicon/hi6220_reset.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/omap-rng.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng-vf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/lp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/base/regmap/regmap-slimbus.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/base/regmap/regmap-spmi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/base/regmap/regmap-w1.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/misc/fastrpc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/timberdale.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/vexpress-sysreg.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/rt4831.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/qcom-pm8008.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/device_dax.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/dax_cxl.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cxl/core/cxl_core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cxl/cxl_pci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cxl/cxl_port.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvme/host/nvme-apple.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cdrom/cdrom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/auxdisplay/charlcd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/auxdisplay/hd44780_common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/i2c/busses/i2c-ccgx-ucsi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/i2c/busses/i2c-ali1563.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/i2c/busses/i2c-qup.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/tuners/tda9887.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/rc/rc-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/v4l2-core/v4l2-async.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/v4l2-core/v4l2-fwnode.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/radio/si470x/radio-si470x-common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mmc/core/pwrseq_emmc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mmc/host/renesas_sdhi_core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ufs/host/ufs-qcom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/leds/flash/leds-rt4505.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/firmware/meson/meson_sm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/xilinx/zynqmp-aes-gcm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/intel/keembay/keembay-ocs-hcu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/devfreq/governor_performance.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/devfreq/governor_userspace.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/perf/marvell_cn10k_ddr_pmu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/perf/arm_cspmu/arm_cspmu_module.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/perf/arm_cspmu/nvidia_cspmu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/perf/cxl_pmu.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/interconnect/imx/imx8mm-interconnect.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/interconnect/imx/imx8mq-interconnect.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/interconnect/imx/imx8mp-interconnect.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/parport/parport.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/spmi/spmi-pmic-arb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/greybus/greybus.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/iio/adc/ingenic-adc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/iio/buffer/kfifo_buf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-hub.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-gpio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-scom.o
>> ERROR: modpost: "system_32bit_el0_cpumask" [drivers/vfio/pci/vfio-pci-core.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

