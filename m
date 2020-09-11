Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0BC266560
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgIKRAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:00:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:29787 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgIKRAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:00:33 -0400
IronPort-SDR: xeIfXwOKJ55+S2qfKX6U1GBoK5yYcz1Rf1t0alMD7Mi4IQvWp0uhfsVeg85XOYlvtpv1WRgtW4
 Jpj3FzMyiw2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="146534444"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="146534444"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 10:00:32 -0700
IronPort-SDR: fv+8VPKXryTTqgxLsKuvHI/MEWiTXWPSgzWL0s+XUpDB1I05IjHj1/n5XnRhn/5TiuAjVdvYN2
 t/tYy52AIQlg==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="450048714"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 10:00:32 -0700
Date:   Fri, 11 Sep 2020 10:00:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200911170031.GD4344@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
 <20200904160008.GA2206@sjchrist-ice>
 <874koanfsc.fsf@vitty.brq.redhat.com>
 <20200907072829-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907072829-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 07:32:23AM -0400, Michael S. Tsirkin wrote:
> On Mon, Sep 07, 2020 at 10:37:39AM +0200, Vitaly Kuznetsov wrote:
> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > 
> > > On Fri, Sep 04, 2020 at 09:29:05AM +0200, Gerd Hoffmann wrote:
> > >>   Hi,
> > >> 
> > >> > Unless I'm mistaken, microvm doesn't even support PCI, does it?
> > >> 
> > >> Correct, no pci support right now.
> > >> 
> > >> We could probably wire up ecam (arm/virt style) for pcie support, once
> > >> the acpi support for mictovm finally landed (we need acpi for that
> > >> because otherwise the kernel wouldn't find the pcie bus).
> > >> 
> > >> Question is whenever there is a good reason to do so.  Why would someone
> > >> prefer microvm with pcie support over q35?
> > >> 
> > >> > If all of the above is true, this can be handled by adding "pci=lastbus=0"
> > >> > as a guest kernel param to override its scanning of buses.  And couldn't
> > >> > that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> > >> > to the end user?
> > >> 
> > >> microvm_fix_kernel_cmdline() is a hack, not a solution.
> > >> 
> > >> Beside that I doubt this has much of an effect on microvm because
> > >> it doesn't support pcie in the first place.
> > >
> > > I am so confused.  Vitaly, can you clarify exactly what QEMU VM type this
> > > series is intended to help?  If this is for microvm, then why is the guest
> > > doing PCI scanning in the first place?  If it's for q35, why is the
> > > justification for microvm-like workloads?
> > 
> > I'm not exactly sure about the plans for particular machine types, the
> > intention was to use this for pcie in QEMU in general so whatever
> > machine type uses pcie will benefit. 
> > 
> > Now, it seems that we have a more sophisticated landscape. The
> > optimization will only make sense to speed up boot so all 'traditional'
> > VM types with 'traditional' firmware are out of
> > question. 'Container-like' VMs seem to avoid PCI for now, I'm not sure
> > if it's because they're in early stages of their development, because
> > they can get away without PCI or, actually, because of slowness at boot
> > (which we're trying to tackle with this feature). I'd definitely like to
> > hear more what people think about this.
> 
> I suspect microvms will need pci eventually. I would much rather KVM
> had an exit-less discovery mechanism in place by then because
> learning from history if it doesn't they will do some kind of
> hack on the kernel command line, and everyone will be stuck
> supporting that for years ...

Is it not an option for the VMM to "accurately" enumerate the number of buses?
E.g. if the VMM has devices on only bus 0, then enumerate that there is one
bus so that the guest doesn't try and probe devices that can't possibly exist.
Or is that completely non-sensical and/or violate PCIe spec?
