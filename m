Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E93A1A6C6A
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 21:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387872AbgDMTVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 15:21:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57161 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728044AbgDMTVd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 15:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586805690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U0H8keLbK3mVuVJkIOBQFVsta0mAjsJgEGaVcL/0Dlk=;
        b=ClOx7UaXyVV9+GzOv4fXPpkTlesMDwf+ZsGl5L75yJ6OjiOy5zMzKGOW8QQrQ6bxzVVYtH
        KEiBxrBKsZCCgvh5LgArw7zI1i8zPOyHX3QdLQBqQV2ul7xlRpwubrd+eukxCIHqipNKjp
        vvLK2gdlOGwxWLzyLS8pdx/r4eB8nSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-X1wh1-omOiexprTuWWlTEQ-1; Mon, 13 Apr 2020 15:21:25 -0400
X-MC-Unique: X1wh1-omOiexprTuWWlTEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F3951937FC1;
        Mon, 13 Apr 2020 19:21:24 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 151345C64F;
        Mon, 13 Apr 2020 19:21:23 +0000 (UTC)
Date:   Mon, 13 Apr 2020 13:21:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Wu, Hao" <hao.wu@intel.com>, Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200413132122.46825849@w520.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D81A31F@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
        <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
        <20200402165954.48d941ee@w520.home>
        <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
        <20200403112545.6c115ba3@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
        <20200407095801.648b1371@w520.home>
        <20200408040021.GS67127@otc-nc-03>
        <20200408101940.3459943d@w520.home>
        <20200413031043.GA18183@araj-mobl1.jf.intel.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D81A31F@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Apr 2020 08:05:33 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Tian, Kevin
> > Sent: Monday, April 13, 2020 3:55 PM
> >   
> > > From: Raj, Ashok <ashok.raj@linux.intel.com>
> > > Sent: Monday, April 13, 2020 11:11 AM
> > >
> > > On Wed, Apr 08, 2020 at 10:19:40AM -0600, Alex Williamson wrote:  
> > > > On Tue, 7 Apr 2020 21:00:21 -0700
> > > > "Raj, Ashok" <ashok.raj@intel.com> wrote:
> > > >  
> > > > > Hi Alex
> > > > >
> > > > > + Bjorn  
> > > >
> > > >  + Don
> > > >  
> > > > > FWIW I can't understand why PCI SIG went different ways with ATS,
> > > > > where its enumerated on PF and VF. But for PASID and PRI its only
> > > > > in PF.
> > > > >
> > > > > I'm checking with our internal SIG reps to followup on that.
> > > > >
> > > > > On Tue, Apr 07, 2020 at 09:58:01AM -0600, Alex Williamson wrote:  
> > > > > > > Is there vendor guarantee that hidden registers will locate at the
> > > > > > > same offset between PF and VF config space?  
> > > > > >
> > > > > > I'm not sure if the spec really precludes hidden registers, but the
> > > > > > fact that these registers are explicitly outside of the capability
> > > > > > chain implies they're only intended for device specific use, so I'd say
> > > > > > there are no guarantees about anything related to these registers.  
> > > > >
> > > > > As you had suggested in the other thread, we could consider
> > > > > using the same offset as in PF, but even that's a better guess
> > > > > still not reliable.
> > > > >
> > > > > The other option is to maybe extend driver ops in the PF to expose
> > > > > where the offsets should be. Sort of adding the quirk in the
> > > > > implementation.
> > > > >
> > > > > I'm not sure how prevalent are PASID and PRI in VF devices. If SIG is  
> > > resisting  
> > > > > making VF's first class citizen, we might ask them to add some verbiage
> > > > > to suggest leave the same offsets as PF open to help emulation software.  
> > > >
> > > > Even if we know where to expose these capabilities on the VF, it's not
> > > > clear to me how we can actually virtualize the capability itself.  If
> > > > the spec defines, for example, an enable bit as r/w then software that
> > > > interacts with that register expects the bit is settable.  There's no
> > > > protocol for "try to set the bit and re-read it to see if the hardware
> > > > accepted it".  Therefore a capability with a fixed enable bit
> > > > representing the state of the PF, not settable by the VF, is
> > > > disingenuous to the spec.  
> > >
> > > I think we are all in violent agreement. A lot of times the pci spec gets
> > > defined several years ahead of real products and no one remembers
> > > the justification on why they restricted things the way they did.
> > >
> > > Maybe someone early product wasn't quite exposing these features to the
> > > VF
> > > and hence the spec is bug compatible :-)
> > >  
> > > >
> > > > If what we're trying to do is expose that PASID and PRI are enabled on
> > > > the PF to a VF driver, maybe duplicating the PF capabilities on the VF
> > > > without the ability to control it is not the right approach.  Maybe we  
> > >
> > > As long as the capability enable is only provided when the PF has enabled
> > > the feature. Then it seems the hardware seems to do the right thing.
> > >
> > > Assume we expose PASID/PRI only when PF has enabled it. It will be the
> > > case since the PF driver needs to exist, and IOMMU would have set the
> > > PASID/PRI/ATS on PF.
> > >
> > > If the emulation is purely spoofing the capability. Once vIOMMU driver
> > > enables PASID, the context entries for the VF are completely independent
> > > from the PF context entries.
> > >
> > > vIOMMU would enable PASID, and we just spoof the PASID capability.
> > >
> > > If vIOMMU or guest for some reason does disable_pasid(), then the
> > > vIOMMU driver can disaable PASID on the VF context entries. So the VF
> > > although the capability is blanket enabled on PF, IOMMU gaurantees the
> > > transactions are blocked.
> > >
> > >
> > > In the interim, it seems like the intent of the virtual capability
> > > can be honored via help from the IOMMU for the controlling aspect..
> > >
> > > Did i miss anything?  
> > 
> > Above works for emulating the enable bit (under the assumption that
> > PF driver won't disable pasid when vf is assigned). However, there are
> > also "Execute permission enable" and "Privileged mode enable" bits in
> > PASID control registers. I don't know how those bits could be cleanly
> > emulated when the guest writes a value different from PF's...  
> 
> sent too quick. the IOMMU also includes control bits for allowing/
> blocking execute requests and supervisor requests. We can rely on 
> IOMMU to block those requests to emulate the disabled cases of
> all three control bits in the pasid cap.


So if the emulation of the PASID capability takes into account the
IOMMU configuration to back that emulation, shouldn't we do that
emulation in the hypervisor, ie. QEMU, rather than the kernel vfio
layer?  Thanks,

Alex 

> > Similar problem also exists when talking about PRI emulation, e.g.
> > to enable PRI the software usually waits until the 'stopped' bit
> > is set (indicating all previously issued requests have completed). How
> > to emulate this bit accurately when one guest toggles the enable bit
> > while the PF and other VFs are actively issuing page requests through
> > the shared page request interface? from pcie spec I didn't find a way
> > to catch when all previously-issued requests from a specific VF have
> > completed. Can a conservative big-enough timeout value help here?
> > I don't know... similar puzzle also exists for emulating the 'reset'
> > control bit which is supposed to clear the pending request state for
> > the whole page request interface.
> > 
> > I feel the main problem in pcie spec is that, while they invent SR-IOV
> > to address I/O virtualization requirement (where strict isolation is
> > required), they blurred the boundary by leaving some shared resource
> > cross PF and VFs which imply sort of cooperation between PF and VF
> > drivers. On bare metal such cooperation is easy to build, by enabling/
> > disabling a capability en mass, by using the same set of setting, etc.
> > However it doesn't consider the virtualization case where a VF is
> > assigned to the guest which considers the VF as a standard PCI/PCIe
> > endpoint thus such cooperation is missing. A vendor capability could
> > help fix the gap here but making it adopted by major guest OSes will
> > take time. But honestly speaking I don't know other good alternative
> > now... :/
> >   
> > >  
> > > > need new capabilities exposing these as slave features that cannot be
> > > > controlled?  We could define our own vendor capability for this, but of
> > > > course we have both the where to put it in config space issue, as well
> > > > as the issue of trying to push an ad-hoc standard.  vfio could expose
> > > > these as device features rather than emulating capabilities, but that
> > > > still leaves a big gap between vfio in the hypervisor and the driver in
> > > > the guest VM.  That might still help push the responsibility and policy
> > > > for how to expose it to the VM as a userspace problem though.  
> > >
> > > I think this is a good long term solution, but if the vIOMMU implenentations
> > > can carry us for the time being, we can probably defer them unless
> > > we are stuck.
> > >  
> > > >
> > > > I agree though, I don't know why the SIG would preclude implementing
> > > > per VF control of these features.  Thanks,
> > > >  
> > >
> > > Cheers,
> > > Ashok  
> > 
> > Thanks
> > Kevin  
> 

