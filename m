Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BF5117DF6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 03:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLJCwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 21:52:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:23954 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfLJCwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 21:52:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 18:52:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,297,1571727600"; 
   d="scan'208";a="244684538"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 09 Dec 2019 18:52:34 -0800
Date:   Mon, 9 Dec 2019 21:44:23 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept
 vfio-pci ops
Message-ID: <20191210024422.GA27331@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <20191205032536.29653-1-yan.y.zhao@intel.com>
 <20191205165519.106bd210@x1.home>
 <20191206075655.GG31791@joy-OptiPlex-7040>
 <20191206142226.2698a2be@x1.home>
 <20191209034225.GK31791@joy-OptiPlex-7040>
 <20191209170339.2cb3d06e@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209170339.2cb3d06e@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > Currently, yes, i40e has build dependency on vfio-pci.
> > > > It's like this, if i40e decides to support SRIOV and compiles in vf
> > > > related code who depends on vfio-pci, it will also have build dependency
> > > > on vfio-pci. isn't it natural?  
> > > 
> > > No, this is not natural.  There are certainly i40e VF use cases that
> > > have no interest in vfio and having dependencies between the two
> > > modules is unacceptable.  I think you probably want to modularize the
> > > i40e vfio support code and then perhaps register a table in vfio-pci
> > > that the vfio-pci code can perform a module request when using a
> > > compatible device.  Just and idea, there might be better options.  I
> > > will not accept a solution that requires unloading the i40e driver in
> > > order to unload the vfio-pci driver.  It's inconvenient with just one
> > > NIC driver, imagine how poorly that scales.
> > >   
> > what about this way:
> > mediate driver registers a module notifier and every time when
> > vfio_pci is loaded, register to vfio_pci its mediate ops?
> > (Just like in below sample code)
> > This way vfio-pci is free to unload and this registering only gives
> > vfio-pci a name of what module to request.
> > After that,
> > in vfio_pci_open(), vfio-pci requests the mediate driver. (or puts
> > the mediate driver when mediate driver does not support mediating the
> > device)
> > in vfio_pci_release(), vfio-pci puts the mediate driver.
> > 
> > static void register_mediate_ops(void)
> > {
> >         int (*func)(struct vfio_pci_mediate_ops *ops) = NULL;
> > 
> >         func = symbol_get(vfio_pci_register_mediate_ops);
> > 
> >         if (func) {
> >                 func(&igd_dt_ops);
> >                 symbol_put(vfio_pci_register_mediate_ops);
> >         }
> > }
> > 
> > static int igd_module_notify(struct notifier_block *self,
> >                               unsigned long val, void *data)
> > {
> >         struct module *mod = data;
> >         int ret = 0;
> > 
> >         switch (val) {
> >         case MODULE_STATE_LIVE:
> >                 if (!strcmp(mod->name, "vfio_pci"))
> >                         register_mediate_ops();
> >                 break;
> >         case MODULE_STATE_GOING:
> >                 break;
> >         default:
> >                 break;
> >         }
> >         return ret;
> > }
> > 
> > static struct notifier_block igd_module_nb = {
> >         .notifier_call = igd_module_notify,
> >         .priority = 0,
> > };
> > 
> > 
> > 
> > static int __init igd_dt_init(void)
> > {
> > 	...
> > 	register_mediate_ops();
> > 	register_module_notifier(&igd_module_nb);
> > 	...
> > 	return 0;
> > }
> 
> 
> No, this is bad.  Please look at MODULE_ALIAS() and request_module() as
> used in the vfio-platform for loading reset driver modules.  I think
> the correct approach is that vfio-pci should perform a request_module()
> based on the device being probed.  Having the mediation provider
> listening for vfio-pci and registering itself regardless of whether we
> intend to use it assumes that we will want to use it and assumes that
> the mediation provider module is already loaded.  We should be able to
> support demand loading of modules that may serve no other purpose than
> providing this mediation.  Thanks,
hi Alex
Thanks for this message.
So is it good to create a separate module as mediation provider driver,
and alias its module name to "vfio-pci-mediate-vid-did".
Then when vfio-pci probes the device, it requests module of that name ?

Thanks
Yan
