Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A04F52AE9B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiEQXbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 19:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiEQXbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 19:31:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173B61144F;
        Tue, 17 May 2022 16:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652830272; x=1684366272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZvWg2m8AU3kkk/4wo0jJSvqlfvdU8fxfo2bGmpnIOOs=;
  b=QROGc7KTrV1vbgKltw5Dxr39xMUMC1SHQZDTfnsgg+Gjk4szrdzUwDVr
   fTAsF7rgBBqGdmRhncl3cEfuNxXDM4ty2dKcvOKu+q8eO06dv4loQwBV5
   Dec0SKGIGoRaTRhoo5JMO6gWqnEiZSxByEb3lzHCAA/UgJjZyktlqTy87
   qnhsBeIzuedOmkjA1yRxKI4FogDiL40BmI4OXOuJ6JMDm4awgfdTRKJw0
   m9sp3JFeSzL7mqxVcv8hJS62mw7doJ640z5wJrb214QF5r8UA7cr2JiS+
   NRiCepcalzzY7ThM8NmXxgumZhU0ooILJG6B/pGVzB8Ita0TscEeDpQgG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357791692"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357791692"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 16:31:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="897930650"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 17 May 2022 16:31:08 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nr6eh-0001ZM-Rp;
        Tue, 17 May 2022 23:31:07 +0000
Date:   Wed, 18 May 2022 07:30:40 +0800
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
Subject: Re: [PATCH v4 1/4] vfio/pci: Invalidate mmaps and block the access
 in D3hot power state
Message-ID: <202205180721.m3Z4ar57-lkp@intel.com>
References: <20220517100219.15146-2-abhsahu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517100219.15146-2-abhsahu@nvidia.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Abhishek,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Sahu/vfio-pci-power-management-changes/20220517-180527
base:   https://github.com/awilliam/linux-vfio.git next
config: x86_64-randconfig-s021-20220516 (https://download.01.org/0day-ci/archive/20220518/202205180721.m3Z4ar57-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/2c439fb0dc917fb8bcf3cf432c8d73d51cfb16b0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Abhishek-Sahu/vfio-pci-power-management-changes/20220517-180527
        git checkout 2c439fb0dc917fb8bcf3cf432c8d73d51cfb16b0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/vfio/pci/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/vfio/pci/vfio_pci_config.c:411:20: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_config.c:411:38: sparse: sparse: restricted pci_power_t degrades to integer

vim +411 drivers/vfio/pci/vfio_pci_config.c

   397	
   398	/* Caller should hold memory_lock semaphore */
   399	bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
   400	{
   401		struct pci_dev *pdev = vdev->pdev;
   402		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
   403	
   404		/*
   405		 * Memory region cannot be accessed if device power state is D3.
   406		 *
   407		 * SR-IOV VF memory enable is handled by the MSE bit in the
   408		 * PF SR-IOV capability, there's therefore no need to trigger
   409		 * faults based on the virtual value.
   410		 */
 > 411		return pdev->current_state < PCI_D3hot &&
   412		       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
   413	}
   414	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
