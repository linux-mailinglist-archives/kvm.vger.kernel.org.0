Return-Path: <kvm+bounces-51902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48114AFE3FA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5D31891733
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87022284686;
	Wed,  9 Jul 2025 09:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKU1KqTH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB2B27C84B;
	Wed,  9 Jul 2025 09:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752052870; cv=none; b=lW26HuT3C6whr8+L9gJXIuZjMNRQGXpDGDf7OWdaY9YCdkdm7muYuivDErRyrvbcJgZS8GbExvOLN6BcqXB7VWzIGHnhgz9mOxLgI46b+VF6qDMG9bscBcdNLsbcWytNdB+VZsvHfkQFX/bkgHLw8BnohE/8DUgfHGG6/1vgPC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752052870; c=relaxed/simple;
	bh=z3x2Gt1rt8xqTtqo9CeUFY3qwCPecBK5Nelp2o0HyOg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=H7cpn5lOx3oWdWa1xnavY5BhGGqDQfNOK6y5S/+sRiURBH6G45WhnD9OKG623Qtqb9N9scrHvdp4MMb3kc9BuuYDus28APBs01p9hTsnANnq+cjMwT8HIWjObqOBfUJRIBphkhD9H2W5CmUCtWVGp9TAtiJXIqSZcID9uAK89ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKU1KqTH; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752052869; x=1783588869;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=z3x2Gt1rt8xqTtqo9CeUFY3qwCPecBK5Nelp2o0HyOg=;
  b=aKU1KqTHLpk/LCkQ2gt4yfBdALjqL1JLlAE0C+FiW9hEillThSUwuLEF
   2ZJXywMSE+C+KYdEKLNcRxrYFEpkEU3JnuIFp1AZiDNvJVoLxVk3qBugR
   8IBAOkXJld3VZ7DlgmHgTGK6vQAJa81lVcT+kDuOprzTA4qOU8f3Uajny
   SYgg/jiX1hv2aoHe8zo+VeCMlgkDcrf+LR1t1K2Jz9D4YK/tYmvl7lfVY
   3w7iNHn5YgcLAceI5UvOoanJzXx0Mnwe/6RXkmMflHgXBduyajK66L2sM
   sYnj8biKr0oUhYF3emMMSnXEZz5lIRDOnpoOmiCcpyotuPS39SLh37p7j
   g==;
X-CSE-ConnectionGUID: wQUBUx2ZS5SKuNl/nFBkmA==
X-CSE-MsgGUID: LShm/L3wRrSETS1Qgfc5YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="76853898"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="76853898"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 02:21:09 -0700
X-CSE-ConnectionGUID: sw36Ee8kSUeQoStCO4NcvQ==
X-CSE-MsgGUID: hW/y84lhQlyCmjDEid+m6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161374562"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 Jul 2025 02:21:07 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uZQzB-0003Ld-17;
	Wed, 09 Jul 2025 09:21:05 +0000
Date: Wed, 9 Jul 2025 17:20:10 +0800
From: kernel test robot <lkp@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [mst-vhost:vhost 4/8] include/linux/pci.h:2738:14: warning: implicit
 declaration of function 'pci_device_is_present'; did you mean
 'pci_dev_present'?
Message-ID: <202507091726.qKSmDnk7-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   97d5f469f45a2312a124376fd6fa368ef8419dff
commit: b7468115b6045e555aa8a8f2fa327c1c073fc6df [4/8] pci: report surprise removal event
config: x86_64-buildonly-randconfig-004-20250709 (https://download.01.org/0day-ci/archive/20250709/202507091726.qKSmDnk7-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250709/202507091726.qKSmDnk7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507091726.qKSmDnk7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/firmware/efi/libstub/pci.c:10:
   include/linux/pci.h: In function 'pci_set_disconnect_work':
>> include/linux/pci.h:2738:14: warning: implicit declaration of function 'pci_device_is_present'; did you mean 'pci_dev_present'? [-Wimplicit-function-declaration]
    2738 |         if (!pci_device_is_present(pdev))
         |              ^~~~~~~~~~~~~~~~~~~~~
         |              pci_dev_present


vim +2738 include/linux/pci.h

  2722	
  2723	/*
  2724	 * Caller must initialize @pdev->disconnect_work before invoking this.
  2725	 * The work function must run and check pci_test_and_clear_disconnect_enable.
  2726	 * Note that device can go away right after this call.
  2727	 */
  2728	static inline void pci_set_disconnect_work(struct pci_dev *pdev)
  2729	{
  2730		/* Make sure WQ has been initialized already */
  2731		smp_wmb();
  2732	
  2733		WRITE_ONCE(pdev->disconnect_work_enable, 0x1);
  2734	
  2735		/* check the device did not go away meanwhile. */
  2736		mb();
  2737	
> 2738		if (!pci_device_is_present(pdev))
  2739			schedule_work(&pdev->disconnect_work);
  2740	}
  2741	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

