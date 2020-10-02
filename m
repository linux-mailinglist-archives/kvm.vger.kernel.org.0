Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6650A281B76
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJBTVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 15:21:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:3336 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBTVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 15:21:21 -0400
IronPort-SDR: lJnbzwL2YIai6zOk7d+2Lz8htZMw4rjrO8FI3rwJfVZbf95XWGEaxb673bUiFyUf8sSjS6QZtA
 vH3GeA+3lcrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="224672944"
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="224672944"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:21:19 -0700
IronPort-SDR: +10UPm6pc0i2Lg70cAbiEOioaXg1TvU3P2t9atU5+dg/Ny4/IQGqJ8k0hXww4jBau5RZWNGKqs
 jw+RKrUdmf8A==
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="313604902"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:21:19 -0700
Date:   Fri, 2 Oct 2020 12:21:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Quentin Grolleau <quentin.grolleau@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Qemu crash when trying to boot a VM with 4 NVME in PCI
 passthrough with KVM internal error. Suberror: 1
Message-ID: <20201002192113.GC24460@linux.intel.com>
References: <CA+BWSia-x86d3+C_zm+B0ZJEJWSne+Q95Z+cy02XHkr+pOtQGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+BWSia-x86d3+C_zm+B0ZJEJWSne+Q95Z+cy02XHkr+pOtQGQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 02:09:09PM +0200, Quentin Grolleau wrote:
> Hello,
> 
> 
> I wanted to know where i can file a bug about "KVM internal error. Suberror: 1"
> 
> Is it on Qemu side, Kernel side or Kvm one ?

The error itself doesn't assign blame to any one component, KVM is simply
stating that it failed instruction emulation.  Emulation can fail for a
number of reasons, in this case it fails because the guest code stream is
garbage.  But, _why_ the guest code stream is garbage is unknown.

> More details :
> 
> 
> I having problems getting VM to run with QEMU 4.0 and 4 NVME in PCI passthrough
> When I create a VM, it quickly goes into a paused state and never
> seems to start working.
> 
> Log shows emulation failure :
> 
> KVM internal error. Suberror: 1
> emulation failure
> EAX=00000086 EBX=000041d8 ECX=00000001 EDX=00008e68
> ESI=00000f01 EDI=00000000 EBP=0000004f ESP=00008e4e
> EIP=00000000 EFL=00210093 [--S-A-C] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =9000 00090000 0000ffff 00009300
> CS =bffc 000bffc0 0000ffff 00009f00

I believe 0xb0000 - 0xbffff is used for expansion/option ROMs.

> SS =9000 00090000 0000ffff 00009300
> DS =9000 00090000 0000ffff 00009300
> FS =9000 00090000 0000ffff 00009300
> GS =9000 00090000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00008160 00000028
> IDT=     00000000 000003ff
> CR0=00000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> Code=<20> 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07
> 20 07 20 07 20 07

This is the direct cause of emulation failure, the guest code stream is
junk.  That could be due to guest BIOS jumping to the wrong location, QEMU
not correctly setting up guest memory, incorrect configuration of memory,
etc...

Given the above EIP=0 and a CS:EIP pointing at expansion memory, my best
guest is that the guest BIOS jumped into an option ROM and gets garbage.

One thought would be to disable option ROMs for all devices by overriding
each device's romfile to be null, e.g.

  -device virtio-net-pci,netdev=hostnet0,id=net0,mac=fa:16:3e:55:8e:0d,bus=pci.0,addr=0x3,romfile=

That's not necessarily a solution, but it might help get a better idea of
what's going wrong.  Note, not all devices support "romfile", my super
sophisticated method for disabling option ROMs has been to add "romfile="
for every device and then remove the ones QEMU complains about :-)

Further debug/insight in this area is well beyond my area of expertise.
