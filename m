Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DB86CD055
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjC2Csl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjC2Csl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:48:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F6110C9;
        Tue, 28 Mar 2023 19:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680058120; x=1711594120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zWVM1XKe1VFK47f/RGqAXZAGN/Fc8fiPwEhDoVnF3HA=;
  b=gnKGSIYRqfTsF/rIW590ss9BG7VgmU3YP2JbW+CH7AixvpFVoBQscdwn
   pb8M16CN8xcJduCirsi9uptdrVnwNOHoiY6tvlhVNZbrqB2lEHx8vq0pA
   n9MqBWv2P1RCt/KCspNWQwEaBbIpQqb3/MckWnALnOTGIPKZ3Gm16Iq9Z
   b4PnDvOlxoBmUazXeceRSOTe4Sn2fEIrPzJhJm8SXB2e9Au9iMOqlGFf8
   htxcVgoW4PBwLw7WSu+0jVazVcpYpeLmg9KMRnk7TY8zkvuJolyftk233
   YYq7mzMZeXJ5kJdBbHZIJug5AwyQoc2LMwVGH3dMohM7V9QftfBc0MrBP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="343170001"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="343170001"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:48:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="686650715"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="686650715"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 28 Mar 2023 19:48:32 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phLrT-000J7L-2O;
        Wed, 29 Mar 2023 02:48:31 +0000
Date:   Wed, 29 Mar 2023 10:48:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Reinette Chatre <reinette.chatre@intel.com>, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, tglx@linutronix.de,
        darwi@linutronix.de, kvm@vger.kernel.org, dave.jiang@intel.com,
        jing2.liu@intel.com, ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Message-ID: <202303291000.PWFqGCxH-lkp@intel.com>
References: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reinette,

I love your patch! Yet something to improve:

[auto build test ERROR on 197b6b60ae7bc51dd0814953c562833143b292aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Reinette-Chatre/vfio-pci-Consolidate-irq-cleanup-on-MSI-MSI-X-disable/20230329-055735
base:   197b6b60ae7bc51dd0814953c562833143b292aa
patch link:    https://lore.kernel.org/r/419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre%40intel.com
patch subject: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
config: i386-randconfig-a001-20230327 (https://download.01.org/0day-ci/archive/20230329/202303291000.PWFqGCxH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/420198d6ba9227a0ef81a2192ca35019fa6439cf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Reinette-Chatre/vfio-pci-Consolidate-irq-cleanup-on-MSI-MSI-X-disable/20230329-055735
        git checkout 420198d6ba9227a0ef81a2192ca35019fa6439cf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/pci/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303291000.PWFqGCxH-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vfio/pci/vfio_pci_intrs.c: In function 'vfio_msi_set_vector_signal':
>> drivers/vfio/pci/vfio_pci_intrs.c:427:21: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]
     427 |         if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
         |                     ^~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/pci_msix_can_alloc_dyn +427 drivers/vfio/pci/vfio_pci_intrs.c

   413	
   414	static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
   415					      unsigned int vector, int fd, bool msix)
   416	{
   417		struct pci_dev *pdev = vdev->pdev;
   418		struct vfio_pci_irq_ctx *ctx;
   419		struct msi_map msix_map = {};
   420		bool allow_dyn_alloc = false;
   421		struct eventfd_ctx *trigger;
   422		bool new_ctx = false;
   423		int irq, ret;
   424		u16 cmd;
   425	
   426		/* Only MSI-X allows dynamic allocation. */
 > 427		if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
   428			allow_dyn_alloc = true;
   429	
   430		ctx = vfio_irq_ctx_get(vdev, vector);
   431		if (!ctx && !allow_dyn_alloc)
   432			return -EINVAL;
   433	
   434		irq = pci_irq_vector(pdev, vector);
   435		/* Context and interrupt are always allocated together. */
   436		WARN_ON((ctx && irq == -EINVAL) || (!ctx && irq != -EINVAL));
   437	
   438		if (ctx && ctx->trigger) {
   439			irq_bypass_unregister_producer(&ctx->producer);
   440	
   441			cmd = vfio_pci_memory_lock_and_enable(vdev);
   442			free_irq(irq, ctx->trigger);
   443			if (allow_dyn_alloc) {
   444				msix_map.index = vector;
   445				msix_map.virq = irq;
   446				pci_msix_free_irq(pdev, msix_map);
   447				irq = -EINVAL;
   448			}
   449			vfio_pci_memory_unlock_and_restore(vdev, cmd);
   450			kfree(ctx->name);
   451			eventfd_ctx_put(ctx->trigger);
   452			ctx->trigger = NULL;
   453			if (allow_dyn_alloc) {
   454				vfio_irq_ctx_free(vdev, ctx, vector);
   455				ctx = NULL;
   456			}
   457		}
   458	
   459		if (fd < 0)
   460			return 0;
   461	
   462		if (!ctx) {
   463			ctx = vfio_irq_ctx_alloc_single(vdev, vector);
   464			if (!ctx)
   465				return -ENOMEM;
   466			new_ctx = true;
   467		}
   468	
   469		ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
   470				      msix ? "x" : "", vector, pci_name(pdev));
   471		if (!ctx->name) {
   472			ret = -ENOMEM;
   473			goto out_free_ctx;
   474		}
   475	
   476		trigger = eventfd_ctx_fdget(fd);
   477		if (IS_ERR(trigger)) {
   478			ret = PTR_ERR(trigger);
   479			goto out_free_name;
   480		}
   481	
   482		cmd = vfio_pci_memory_lock_and_enable(vdev);
   483		if (msix) {
   484			if (irq == -EINVAL) {
   485				msix_map = pci_msix_alloc_irq_at(pdev, vector, NULL);
   486				if (msix_map.index < 0) {
   487					vfio_pci_memory_unlock_and_restore(vdev, cmd);
   488					ret = msix_map.index;
   489					goto out_put_eventfd_ctx;
   490				}
   491				irq = msix_map.virq;
   492			} else {
   493				/*
   494				 * The MSIx vector table resides in device memory which
   495				 * may be cleared via backdoor resets. We don't allow
   496				 * direct access to the vector table so even if a
   497				 * userspace driver attempts to save/restore around
   498				 * such a reset it would be unsuccessful. To avoid
   499				 * this, restore the cached value of the message prior
   500				 * to enabling.
   501				 */
   502				struct msi_msg msg;
   503	
   504				get_cached_msi_msg(irq, &msg);
   505				pci_write_msi_msg(irq, &msg);
   506			}
   507		}
   508	
   509		ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
   510		if (ret)
   511			goto out_free_irq_locked;
   512	
   513		vfio_pci_memory_unlock_and_restore(vdev, cmd);
   514	
   515		ctx->producer.token = trigger;
   516		ctx->producer.irq = irq;
   517		ret = irq_bypass_register_producer(&ctx->producer);
   518		if (unlikely(ret)) {
   519			dev_info(&pdev->dev,
   520			"irq bypass producer (token %p) registration fails: %d\n",
   521			ctx->producer.token, ret);
   522	
   523			ctx->producer.token = NULL;
   524		}
   525		ctx->trigger = trigger;
   526	
   527		return 0;
   528	
   529	out_free_irq_locked:
   530		if (allow_dyn_alloc && new_ctx) {
   531			msix_map.index = vector;
   532			msix_map.virq = irq;
   533			pci_msix_free_irq(pdev, msix_map);
   534		}
   535		vfio_pci_memory_unlock_and_restore(vdev, cmd);
   536	out_put_eventfd_ctx:
   537		eventfd_ctx_put(trigger);
   538	out_free_name:
   539		kfree(ctx->name);
   540		ctx->name = NULL;
   541	out_free_ctx:
   542		if (allow_dyn_alloc && new_ctx)
   543			vfio_irq_ctx_free(vdev, ctx, vector);
   544		return ret;
   545	}
   546	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
