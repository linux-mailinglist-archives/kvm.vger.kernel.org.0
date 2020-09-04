Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA7E25D123
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 08:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgIDGMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 02:12:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:15430 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgIDGMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 02:12:14 -0400
IronPort-SDR: YWadKn+mRDZCVNMdar7MUp/YUSmhcgGazm8oHbPtDGq7RLgXQD97SdbeAvgOT/e1s1WIovbWxy
 YMk3kqvKOHSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145399307"
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="145399307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 23:12:13 -0700
IronPort-SDR: OOATKXc/XT/AbssXZA5Jj0wtpKYOUiVFE61V5usIkegJOi6PRkSv03x0u5QW/GoihdankrkHzQ
 2nOXnFIt0eZw==
X-IronPort-AV: E=Sophos;i="5.76,388,1592895600"; 
   d="scan'208";a="298297293"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 23:12:13 -0700
Date:   Thu, 3 Sep 2020 23:12:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200904061210.GA22435@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dtcpn9z.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 02, 2020 at 10:59:20AM +0200, Vitaly Kuznetsov wrote:
> Peter Xu <peterx@redhat.com> writes:
> > My whole point was more about trying to understand the problem behind.
> > Providing a fast path for reading pci holes seems to be reasonable as is,
> > however it's just that I'm confused on why there're so many reads on the pci
> > holes after all.  Another important question is I'm wondering how this series
> > will finally help the use case of microvm.  I'm not sure I get the whole point
> > of it, but... if microvm is the major use case of this, it would be good to
> > provide some quick numbers on those if possible.
> >
> > For example, IIUC microvm uses qboot (as a better alternative than seabios) for
> > fast boot, and qboot has:
> >
> > https://github.com/bonzini/qboot/blob/master/pci.c#L20
> >
> > I'm kind of curious whether qboot will still be used when this series is used
> > with microvm VMs?  Since those are still at least PIO based.
> 
> I'm afraid there is no 'grand plan' for everything at this moment :-(
> For traditional VMs 0.04 sec per boot is negligible and definitely not
> worth adding a feature, memory requirements are also very
> different. When it comes to microvm-style usage things change.
> 
> '8193' PCI hole accesses I mention in the PATCH0 blurb are just from
> Linux as I was doing direct kernel boot, we can't get better than that
> (if PCI is in the game of course). Firmware (qboot, seabios,...) can
> only add more. I *think* the plan is to eventually switch them all to
> MMCFG, at least for KVM guests, by default but we need something to put
> to the advertisement. 

I see a similar ~8k PCI hole reads with a -kernel boot w/ OVMF.  All but 60
of those are from pcibios_fixup_peer_bridges(), and all are from the kernel.
My understanding is that pcibios_fixup_peer_bridges() is useful if and only
if there multiple root buses.  And AFAICT, when running under QEMU, the only
way for there to be multiple buses in is if there is an explicit bridge
created ("pxb" or "pxb-pcie").  Based on the cover letter from those[*], the
main reason for creating a bridge is to handle pinned CPUs on a NUMA system
with pass-through devices.  That use case seems highly unlikely to cross
paths with micro VMs, i.e. micro VMs will only ever have a single bus.
Unless I'm mistaken, microvm doesn't even support PCI, does it?

If all of the above is true, this can be handled by adding "pci=lastbus=0"
as a guest kernel param to override its scanning of buses.  And couldn't
that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
to the end user?

[*] https://www.redhat.com/archives/libvir-list/2016-March/msg01213.html
