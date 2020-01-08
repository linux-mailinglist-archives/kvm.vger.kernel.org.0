Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2B134062
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgAHLZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 06:25:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:10668 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgAHLZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 06:25:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 03:25:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,409,1571727600"; 
   d="scan'208";a="215923892"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 08 Jan 2020 03:25:00 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ip9SN-0000oC-TA; Wed, 08 Jan 2020 19:24:59 +0800
Date:   Wed, 8 Jan 2020 19:24:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kbuild-all@lists.01.org, alex.williamson@redhat.com,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 07/12] vfio_pci: shrink vfio_pci.c
Message-ID: <202001081944.Ax1eyQdP%lkp@intel.com>
References: <1578398509-26453-8-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578398509-26453-8-git-send-email-yi.l.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.5-rc5]
[also build test WARNING on next-20200106]
[cannot apply to vfio/next]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Liu-Yi-L/vfio_pci-wrap-pci-device-as-a-mediated-device/20200108-020930
base:    c79f46a282390e0f5b306007bf7b11a46d529538
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/vfio/pci/vfio_pci_common.c:201:25: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:201:43: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:201:56: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:201:65: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:206:25: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:206:44: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:206:57: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:206:66: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:214:39: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_common.c:214:58: sparse: sparse: restricted pci_power_t degrades to integer

vim +201 drivers/vfio/pci/vfio_pci_common.c

8db581db521ec0 Liu Yi L 2020-01-07  186  
8db581db521ec0 Liu Yi L 2020-01-07  187  /*
8db581db521ec0 Liu Yi L 2020-01-07  188   * pci_set_power_state() wrapper handling devices which perform a soft reset on
8db581db521ec0 Liu Yi L 2020-01-07  189   * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
8db581db521ec0 Liu Yi L 2020-01-07  190   * restore when returned to D0.  Saved separately from pci_saved_state for use
8db581db521ec0 Liu Yi L 2020-01-07  191   * by PM capability emulation and separately from pci_dev internal saved state
8db581db521ec0 Liu Yi L 2020-01-07  192   * to avoid it being overwritten and consumed around other resets.
8db581db521ec0 Liu Yi L 2020-01-07  193   */
8db581db521ec0 Liu Yi L 2020-01-07  194  int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
8db581db521ec0 Liu Yi L 2020-01-07  195  {
8db581db521ec0 Liu Yi L 2020-01-07  196  	struct pci_dev *pdev = vdev->pdev;
8db581db521ec0 Liu Yi L 2020-01-07  197  	bool needs_restore = false, needs_save = false;
8db581db521ec0 Liu Yi L 2020-01-07  198  	int ret;
8db581db521ec0 Liu Yi L 2020-01-07  199  
8db581db521ec0 Liu Yi L 2020-01-07  200  	if (vdev->needs_pm_restore) {
8db581db521ec0 Liu Yi L 2020-01-07 @201  		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
8db581db521ec0 Liu Yi L 2020-01-07  202  			pci_save_state(pdev);
8db581db521ec0 Liu Yi L 2020-01-07  203  			needs_save = true;
8db581db521ec0 Liu Yi L 2020-01-07  204  		}
8db581db521ec0 Liu Yi L 2020-01-07  205  
8db581db521ec0 Liu Yi L 2020-01-07  206  		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
8db581db521ec0 Liu Yi L 2020-01-07  207  			needs_restore = true;
8db581db521ec0 Liu Yi L 2020-01-07  208  	}
8db581db521ec0 Liu Yi L 2020-01-07  209  
8db581db521ec0 Liu Yi L 2020-01-07  210  	ret = pci_set_power_state(pdev, state);
8db581db521ec0 Liu Yi L 2020-01-07  211  
8db581db521ec0 Liu Yi L 2020-01-07  212  	if (!ret) {
8db581db521ec0 Liu Yi L 2020-01-07  213  		/* D3 might be unsupported via quirk, skip unless in D3 */
8db581db521ec0 Liu Yi L 2020-01-07  214  		if (needs_save && pdev->current_state >= PCI_D3hot) {
8db581db521ec0 Liu Yi L 2020-01-07  215  			vdev->pm_save = pci_store_saved_state(pdev);
8db581db521ec0 Liu Yi L 2020-01-07  216  		} else if (needs_restore) {
8db581db521ec0 Liu Yi L 2020-01-07  217  			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
8db581db521ec0 Liu Yi L 2020-01-07  218  			pci_restore_state(pdev);
8db581db521ec0 Liu Yi L 2020-01-07  219  		}
8db581db521ec0 Liu Yi L 2020-01-07  220  	}
8db581db521ec0 Liu Yi L 2020-01-07  221  
8db581db521ec0 Liu Yi L 2020-01-07  222  	return ret;
8db581db521ec0 Liu Yi L 2020-01-07  223  }
8db581db521ec0 Liu Yi L 2020-01-07  224  

:::::: The code at line 201 was first introduced by commit
:::::: 8db581db521ec047e12946a9c933f085c4d680ba vfio_pci: duplicate vfio_pci.c

:::::: TO: Liu Yi L <yi.l.liu@intel.com>
:::::: CC: 0day robot <lkp@intel.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
