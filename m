Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531172AACEC
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgKHSr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 13:47:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46766 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHSr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 13:47:28 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604861245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nMdXIUQv1z/k426DEU72kKVysg01VGeaOzxRSP/qal0=;
        b=b7feI/arY6CD5lf2I2p9k9GYW2RmTPAoRdJQkbAm6r7TKkjzpFzE+xaONp46pHZ/tK0fJs
        AdxzWx7zw5I0i5JixuhXo9C20d+Inv5jKzQS/3w4amjq5PgLqdN4tEO4T+mtX5JOnMdXqT
        cDjH00m3RBs0jMGpb3yacvi/U2Puad9I+xDRce373sLt4gUx1FSopWszyF2dsNBgZoyCG6
        QZmNAG5Ma8jizaZhqDiIBazCJ58wDIsV6mgj5RPltRHI6uO/zp0JTsVxfI32pQ3mOpE9zE
        q+c0BzFlqPZ4EbrXjre2FfQLFlu1+izB7rTyrlQLfslk6RuGrHdfLs2NjiKvXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604861245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nMdXIUQv1z/k426DEU72kKVysg01VGeaOzxRSP/qal0=;
        b=xmlsUO/bFuyHJXkS8LZm4PGsWh6dMSwpfWr59WoCCOCb3doADnFgaD7IVW3V4IK54m7idk
        f4K4IlVCgg5N/MCA==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     "Raj\, Ashok" <ashok.raj@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201107001207.GA2620339@nvidia.com>
References: <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com>
Date:   Sun, 08 Nov 2020 19:47:24 +0100
Message-ID: <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06 2020 at 20:12, Jason Gunthorpe wrote:
> All IMS device drivers will work correctly. No VMM device emulation is
> ever needed to translate addr/data pairs.
>
> Earlier in this thread Kevin said hyper-v is already working this way,
> even for MSI/MSI-X. To me this says it is fundamentally a KVM platform
> problem and it should not be solved by PCI capability flags.

I mostly agree but want to add a few clarifications about the
terminology and the boundaries because I think there is where lot of the
confusion comes from.

Let me go back to the basic structure both at the hardware and at the
software level.

The basic structure is:

  [CPU] -- [Bridge] -- Bus -- [Device]

This applies to all kind of buses where the bridge directly translates
into the CPUs address space. Now let's look at the boundaries:

                |
                |
  [CPU] -- [Bri | dge] -- Bus -- [Device]
                |   
                |

The boundary is in the middle of the bridge because the CPU side of the
bridge is obviously CPU and therefore architecture specific. The Bus
side of the bridge is architecture agnostic.

Now let's add an IOMMU:

  [CPU] -- [IOMMU] -- [Bridge] -- Bus -- [Device]

and in theory the boundary moves now to:

               |
               |
  [CPU] -- [IO | MMU] -- [Bridge] -- Bus -- [Device]
               |
               |

because with an IOMMU the bridge could become CPU and architecture
agnostic. In reality this is not the case as the bridge is still the
same thing.

Now let's look at MSI. As established above, the Bus and the Device are
CPU and architecture agnostic and the Device merily uses a composed
message which is stored at some place accessible to the device to send
that message when it raises an interrupt. So where is this message
composed?

The basic case:

                   |
                   |
  [CPU]    -- [Bri | dge] -- Bus -- [Device]
                   |
  Alloc +           
  Compose                   Store     Use

The Bridge is irrelevant here as it just is involved in the
transport. Nevertheless the Bridge is only transport in the view of the
interrupt subsystem.

The IOMMU case:

               |
               |
  [CPU] -- [IO | MMU] -- [Bridge] -- Bus -- [Device]
               |
            Alloc +
  Alloc     Compose                 Store     Use


That's exactly reflected in hierarchical irq domains:

                       |
                       |
  [CPU]        -- [Bri | dge] --    Bus    -- [Device]
                       |   
  Alloc +           
  Compose                         Store        Use

  Vectordomain                   Busdomain

and:

                     |
                     |
  [CPU]       -- [IO | MMU]  -- [Bridge] --    Bus    -- [Device]
                     |
                  Alloc +   
  Alloc           Compose                    Store       Use

  Vectordomain   Remapdomain                Busdomain


Now if we look at the virtualization scenario and device hand through
then the structure in the guest view is not any different from the basic
case. This works with PCI-MSI[X] and the IDXD IMS variant because the
hypervisor can trap the access to the storage and translate the message:

                   |
                   |
  [CPU]    -- [Bri | dge] -- Bus -- [Device]
                   |
  Alloc +
  Compose                   Store     Use
                             |
                             | Trap
                             v
                             Hypervisor translates and stores

But obviously with an IMS storage location which is software controlled
by the guest side driver (the case Jason is interested in) the above
cannot work for obvious reasons.

That means the guest needs a way to ask the hypervisor for a proper
translation, i.e. a hypercall. Now where to do that? Looking at the
above remapping case it's pretty obvious:


                     |
                     |
  [CPU]       -- [VI | RT]  -- [Bridge] --    Bus    -- [Device]
                     |
  Alloc          "Compose"                   Store         Use

  Vectordomain   HCALLdomain                Busdomain
                 |        ^
                 |        |
                 v        | 
            Hypervisor    
               Alloc + Compose

Why? Because it reflects the boundaries and leaves the busdomain part
agnostic as it should be. And it works for _all_ variants of Busdomains.

Now the question which I can't answer is whether this can work correctly
in terms of isolation. If the IMS storage is in guest memory (queue
storage) then the guest driver can obviously write random crap into it
which the device will happily send. (For MSI and IDXD style IMS it
still can trap the store).

Is the IOMMU/Interrupt remapping unit able to catch such messages which
go outside the space to which the guest is allowed to signal to? If yes,
problem solved. If no, then IMS storage in guest memory can't ever work.

Coming back to this:

> In the end pci_subdevice_msi_create_irq_domain() is a platform
> function. Either it should work completely on every device with no
> device-specific emulation required in the VMM, or it should not work
> at all and return -EOPNOTSUPP.

The subdevice domain is a 'Busdomain' according to the structure
above. It does not and should never have any clue about the underlying
system. It's in the agnostic part and always works. It simply does not
care what's underneath. So it won't return -EOPNOTSUPP.

What it has to do is to transport the IMS in queue memory requirement to
the underlying parent domain.

So in case that the HCALL domain is missing, the Vector domain needs
return an error code on domain creation. If the HCALL domain is there
then the domain creation works and in case of actual interrupt
allocation the hypercall either returns a valid composed message or an
appropriate error code.

But there's a catch:

This only works when the guest OS actually knows that it runs in a
VM. If the guest can't figure that out, i.e. via CPUID, this cannot be
solved because from the guest OS view that's the same as running on bare
metal. Obviously on bare metal the Vector domain can and must handle
this.

So this needs some thought.

Thanks,

        tglx
