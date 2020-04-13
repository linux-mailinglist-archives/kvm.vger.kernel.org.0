Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA981A61B1
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 05:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgDMDKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Apr 2020 23:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgDMDKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Apr 2020 23:10:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D9C0A3BE0;
        Sun, 12 Apr 2020 20:10:48 -0700 (PDT)
IronPort-SDR: kngcP6d9NdQgTb9DbNEHooMgzAltwAOvLqfwv1ljxf6LqHCRLYlN62nU2c2jobKXkBUCMwhi4U
 mx5cxM3X7suw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 20:10:46 -0700
IronPort-SDR: X4MPwuF9i86nDYyxkd58AVJS6C0MtVzVwtfwzSZA07B1eyXHmQ/3nWj3eREjzKxRZ0o2YeJ2g5
 uneGmWVHiayA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,377,1580803200"; 
   d="scan'208";a="256053141"
Received: from araj-mobl1.jf.intel.com ([10.255.32.166])
  by orsmga006.jf.intel.com with ESMTP; 12 Apr 2020 20:10:44 -0700
Date:   Sun, 12 Apr 2020 20:10:43 -0700
From:   "Raj, Ashok" <ashok.raj@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200413031043.GA18183@araj-mobl1.jf.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
 <20200402165954.48d941ee@w520.home>
 <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
 <20200403112545.6c115ba3@w520.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
 <20200407095801.648b1371@w520.home>
 <20200408040021.GS67127@otc-nc-03>
 <20200408101940.3459943d@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408101940.3459943d@w520.home>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 08, 2020 at 10:19:40AM -0600, Alex Williamson wrote:
> On Tue, 7 Apr 2020 21:00:21 -0700
> "Raj, Ashok" <ashok.raj@intel.com> wrote:
> 
> > Hi Alex
> > 
> > + Bjorn
> 
>  + Don
> 
> > FWIW I can't understand why PCI SIG went different ways with ATS, 
> > where its enumerated on PF and VF. But for PASID and PRI its only
> > in PF. 
> > 
> > I'm checking with our internal SIG reps to followup on that.
> > 
> > On Tue, Apr 07, 2020 at 09:58:01AM -0600, Alex Williamson wrote:
> > > > Is there vendor guarantee that hidden registers will locate at the
> > > > same offset between PF and VF config space?   
> > > 
> > > I'm not sure if the spec really precludes hidden registers, but the
> > > fact that these registers are explicitly outside of the capability
> > > chain implies they're only intended for device specific use, so I'd say
> > > there are no guarantees about anything related to these registers.  
> > 
> > As you had suggested in the other thread, we could consider
> > using the same offset as in PF, but even that's a better guess
> > still not reliable.
> > 
> > The other option is to maybe extend driver ops in the PF to expose
> > where the offsets should be. Sort of adding the quirk in the 
> > implementation. 
> > 
> > I'm not sure how prevalent are PASID and PRI in VF devices. If SIG is resisting 
> > making VF's first class citizen, we might ask them to add some verbiage
> > to suggest leave the same offsets as PF open to help emulation software.
> 
> Even if we know where to expose these capabilities on the VF, it's not
> clear to me how we can actually virtualize the capability itself.  If
> the spec defines, for example, an enable bit as r/w then software that
> interacts with that register expects the bit is settable.  There's no
> protocol for "try to set the bit and re-read it to see if the hardware
> accepted it".  Therefore a capability with a fixed enable bit
> representing the state of the PF, not settable by the VF, is
> disingenuous to the spec.

I think we are all in violent agreement. A lot of times the pci spec gets
defined several years ahead of real products and no one remembers
the justification on why they restricted things the way they did.

Maybe someone early product wasn't quite exposing these features to the VF
and hence the spec is bug compatible :-)

> 
> If what we're trying to do is expose that PASID and PRI are enabled on
> the PF to a VF driver, maybe duplicating the PF capabilities on the VF
> without the ability to control it is not the right approach.  Maybe we

As long as the capability enable is only provided when the PF has enabled
the feature. Then it seems the hardware seems to do the right thing.

Assume we expose PASID/PRI only when PF has enabled it. It will be the
case since the PF driver needs to exist, and IOMMU would have set the 
PASID/PRI/ATS on PF.

If the emulation is purely spoofing the capability. Once vIOMMU driver
enables PASID, the context entries for the VF are completely independent
from the PF context entries. 

vIOMMU would enable PASID, and we just spoof the PASID capability.

If vIOMMU or guest for some reason does disable_pasid(), then the 
vIOMMU driver can disaable PASID on the VF context entries. So the VF
although the capability is blanket enabled on PF, IOMMU gaurantees the
transactions are blocked.


In the interim, it seems like the intent of the virtual capability
can be honored via help from the IOMMU for the controlling aspect.. 

Did i miss anything? 

> need new capabilities exposing these as slave features that cannot be
> controlled?  We could define our own vendor capability for this, but of
> course we have both the where to put it in config space issue, as well
> as the issue of trying to push an ad-hoc standard.  vfio could expose
> these as device features rather than emulating capabilities, but that
> still leaves a big gap between vfio in the hypervisor and the driver in
> the guest VM.  That might still help push the responsibility and policy
> for how to expose it to the VM as a userspace problem though.

I think this is a good long term solution, but if the vIOMMU implenentations
can carry us for the time being, we can probably defer them unless
we are stuck.

> 
> I agree though, I don't know why the SIG would preclude implementing
> per VF control of these features.  Thanks,
> 

Cheers,
Ashok
