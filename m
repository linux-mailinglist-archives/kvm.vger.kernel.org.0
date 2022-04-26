Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15950EE2E
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 03:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiDZBqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 21:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiDZBqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 21:46:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B002FE6E;
        Mon, 25 Apr 2022 18:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650937388; x=1682473388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h1DOHh199Ek3ohAqaxadH0XXy0OL3jyfkqE6n7YsM84=;
  b=YDyL0wf65IbpkctvDdWAV2bTJIdqeq8qFrzk/j5J9QbH5htorbqhozNk
   6i2hr231NrNAzjfsqS0tGWpBeahon/JwGuu8AYt6OcG5/V7IlVGKsFv9S
   lashJdiUtV2OBNFOWdS62cVdDGuXvt6yZglgrRSrRP99UInop8e0EKspo
   sMRBbQXCFNByzs6K1M6oU8uRfHSI+D6ku+6XrXulHezVtd+7/doC6J/RQ
   ieTD0iAx1qbGeolfzOuGAVF2OzczcOeD7f/3vb8jzhENTyPJXte+Bx/O5
   +Oq/ot/Dsnti0GLqfd0n7rUk+EqafUSmKsdGZ+hK2Vj31N3hAkZ0i0vXO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="328357709"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="328357709"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 18:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="649951610"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Apr 2022 18:43:03 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njAEH-000378-9O;
        Tue, 26 Apr 2022 01:43:01 +0000
Date:   Tue, 26 Apr 2022 09:42:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     kbuild-all@lists.01.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: Re: [PATCH v3 1/8] vfio/pci: Invalidate mmaps and block the access
 in D3hot power state
Message-ID: <202204260928.TsUAxMD3-lkp@intel.com>
References: <20220425092615.10133-2-abhsahu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425092615.10133-2-abhsahu@nvidia.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Abhishek,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.18-rc4]
[also build test WARNING on next-20220422]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Sahu/vfio-pci-power-management-changes/20220425-173224
base:    af2d861d4cd2a4da5137f795ee3509e6f944a25b
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220426/202204260928.TsUAxMD3-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/1d48b86a17606c483f200c1734085ab415dbfc3c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Abhishek-Sahu/vfio-pci-power-management-changes/20220425-173224
        git checkout 1d48b86a17606c483f200c1734085ab415dbfc3c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/vfio/pci/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/vfio/pci/vfio_pci_config.c:703:13: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_config.c:703:22: sparse: sparse: restricted pci_power_t degrades to integer

vim +703 drivers/vfio/pci/vfio_pci_config.c

   694	
   695	/*
   696	 * It takes all the required locks to protect the access of power related
   697	 * variables and then invokes vfio_pci_set_power_state().
   698	 */
   699	static void
   700	vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
   701				      pci_power_t state)
   702	{
 > 703		if (state >= PCI_D3hot)
   704			vfio_pci_zap_and_down_write_memory_lock(vdev);
   705		else
   706			down_write(&vdev->memory_lock);
   707	
   708		vfio_pci_set_power_state(vdev, state);
   709		up_write(&vdev->memory_lock);
   710	}
   711	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
