Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F27122C0D3
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgGXIea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:34:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:16108 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgGXIe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:34:29 -0400
IronPort-SDR: T3Zy7lJLcrkhbXrtVyRVAMK/CN2Yr1pyE5B5+slW1dGPQRaRnr/1MDzQbuk78y5LivuE2SznYQ
 UO7Vm9SUvZkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="151966796"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="151966796"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 01:34:28 -0700
IronPort-SDR: w03y+tLCXWfNyJBHuugzrI/MIgPQ5an4GJVW4QN7FLXemkuR1r8FCIM8dz+FHXNy5MyYPhG99j
 /uqIJCREoBYw==
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="463158443"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 01:34:24 -0700
Date:   Fri, 24 Jul 2020 09:34:17 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     herbert@gondor.apana.org.au, cohuck@redhat.com, nhorman@redhat.com,
        vdronov@redhat.com, bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] vfio/pci: Add device denylist
Message-ID: <20200724083417.GA3913@silpixa00400314>
References: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
 <20200723214705.5399-3-giovanni.cabiddu@intel.com>
 <20200723164126.0249b247@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723164126.0249b247@w520.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 04:41:26PM -0600, Alex Williamson wrote:
> On Thu, 23 Jul 2020 22:47:02 +0100
> Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:
> 
> > Add denylist of devices that by default are not probed by vfio-pci.
> > Devices in this list may be susceptible to untrusted application, even
> > if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
> > explicitly disable the denylist.
> > 
> > The denylist can be disabled via the module parameter disable_denylist.
> > 
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 7c0779018b1b..673f53c4798e 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
> >  MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
> >  #endif
> >  
> > +static bool disable_denylist;
> > +module_param(disable_denylist, bool, 0444);
> > +MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist prevents binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
> 
> s/prevents/allows/
> 
> ie. the denylist prevents binding, therefore disabling the denylist
> allows binding
> 
> I can fix this on commit without a new version if you agree.  I also
> see that patch 1/5 didn't change since v2, so I'll transfer Bjorn's
> ack.  If that sounds good I'll queue the first 3 patches in my next
> branch for v5.9.  Thanks,
My bad, apologies! I'm ok also to re-spin adding Bjorn's ack and the fix
above.

Regards,

-- 
Giovanni
