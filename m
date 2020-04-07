Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB461A05B9
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 06:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGE03 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 00:26:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:23098 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGE03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 00:26:29 -0400
IronPort-SDR: iEDr9ictuXWomlBNa70u7mhcnHHV8xzSkSv/uTZR0VbVAqb5jAdm1/WEeLL+jqseMe75NnjBZ7
 qeog6tzXBc0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 21:26:28 -0700
IronPort-SDR: orBWKegM95GnrcWNMzdwaxgcZJMkE9E5n9mkOkZhUWI8iUhpBE9Et9ICkjV2361sOwWz0Vf5rj
 DvvMyMFlclPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="397729232"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga004.jf.intel.com with ESMTP; 06 Apr 2020 21:26:28 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 21:26:28 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 21:26:27 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 12:26:24 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Thread-Topic: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Thread-Index: AQHWAEVGCz5QQWvL/U+nYnlD7MiZ7Khl/jEAgACVNICAAJ/EgIAF8c6g
Date:   Tue, 7 Apr 2020 04:26:23 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
        <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
        <20200402165954.48d941ee@w520.home>
        <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
 <20200403112545.6c115ba3@w520.home>
In-Reply-To: <20200403112545.6c115ba3@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 4, 2020 1:26 AM
[...]
> > > > +	if (!pasid_cap.control_reg.paside) {
> > > > +		pr_debug("%s: its PF's PASID capability is not enabled\n",
> > > > +			dev_name(&vdev->pdev->dev));
> > > > +		ret = 0;
> > > > +		goto out;
> > > > +	}
> > >
> > > What happens if the PF's PASID gets disabled while we're using it??
> >
> > This is actually the open I highlighted in cover letter. Per the reply
> > from Baolu, this seems to be an open for bare-metal all the same.
> > https://lkml.org/lkml/2020/3/31/95
> 
> Seems that needs to get sorted out before we can expose this.  Maybe
> some sort of registration with the PF driver that PASID is being used
> by a VF so it cannot be disabled?

I guess we may do vSVA for PF first, and then adding VF vSVA later
given above additional need. It's not necessarily to enable both
in one step.

[...]
> > > > @@ -1604,6 +1901,18 @@ static int vfio_ecap_init(struct
> vfio_pci_device *vdev)
> > > >  	if (!ecaps)
> > > >  		*(u32 *)&vdev->vconfig[PCI_CFG_SPACE_SIZE] = 0;
> > > >
> > > > +#ifdef CONFIG_PCI_ATS
> > > > +	if (pdev->is_virtfn) {
> > > > +		struct pci_dev *physfn = pdev->physfn;
> > > > +
> > > > +		ret = vfio_pci_add_emulated_cap_for_vf(vdev,
> > > > +					physfn, epos_max, prev);
> > > > +		if (ret)
> > > > +			pr_info("%s, failed to add special caps for VF %s\n",
> > > > +				__func__, dev_name(&vdev->pdev->dev));
> > > > +	}
> > > > +#endif
> > >
> > > I can only imagine that we should place the caps at the same location
> > > they exist on the PF, we don't know what hidden registers might be
> > > hiding in config space.

Is there vendor guarantee that hidden registers will locate at the
same offset between PF and VF config space? 

> >
> > but we are not sure whether the same location is available on VF. In
> > this patch, it actually places the emulated cap physically behind the
> > cap which lays farthest (its offset is largest) within VF's config space
> > as the PCIe caps are linked in a chain.
> 
> But, as we've found on Broadcom NICs (iirc), hardware developers have a
> nasty habit of hiding random registers in PCI config space, outside of
> defined capabilities.  I feel like IGD might even do this too, is that
> true?  So I don't think we can guarantee that just because a section of
> config space isn't part of a defined capability that its unused.  It
> only means that it's unused by common code, but it might have device
> specific purposes.  So of the PCIe spec indicates that VFs cannot
> include these capabilities and virtialization software needs to
> emulate them, we need somewhere safe to place them in config space, and
> simply placing them off the end of known capabilities doesn't give me
> any confidence.  Also, hardware has no requirement to make compact use
> of extended config space.  The first capability must be at 0x100, the
> very next capability could consume all the way to the last byte of the
> 4K extended range, and the next link in the chain could be somewhere in
> the middle.  Thanks,
> 

Then what would be a viable option? Vendor nasty habit implies
no standard, thus I don't see how VFIO can find a safe location
by itself. Also curious how those hidden registers are identified
by VFIO and employed with proper r/w policy today. If sort of quirks
are used, then could such quirk way be extended to also carry
the information about vendor specific safe location? When no
such quirk info is provided (the majority case), VFIO then finds
out a free location to carry the new cap.

Thanks
Kevin
