Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DF23ED66
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHGMiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgHGMiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:38:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB552086A;
        Fri,  7 Aug 2020 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596803898;
        bh=fEDd6WVXFZL6y21ZUytHI7qe5dgGRL3OroGXMuAeFv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sq+hm/QJyvxkysE8pjDRAg919/6DIkLyvz20wceT31jYDFyd5r5A0K8HjXkJSj8F/
         /LHosTTh2/2dm+eb45g3bsrgrQmmm+R8P80VXgaxN/hklSZ5w8qgspx17oL+wSrXRz
         DAP7zrm068q5ItWhpO45xqkF5I3Iytxlro9j/gEM=
Date:   Fri, 7 Aug 2020 14:38:31 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Dey, Megha" <megha.dey@intel.com>, Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200807123831.GA645281@kroah.com>
References: <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
 <20200807120650.GR16789@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807120650.GR16789@nvidia.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 09:06:50AM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2020 at 10:21:11PM +0200, Thomas Gleixner wrote:
> 
> > Optionally? Please tell the hardware folks to make this mandatory. We
> > have enough pain with non maskable MSI interrupts already so introducing
> > yet another non maskable interrupt trainwreck is not an option.
> 
> Can you elaborate on the flows where Linux will need to trigger
> masking?
> 
> I expect that masking will be available in our NIC HW too - but it
> will require a spin loop if masking has to be done in an atomic
> context.
> 
> > It's more than a decade now that I tell HW people not to repeat the
> > non-maskable MSI failure, but obviously they still think that
> > non-maskable interrupts are a brilliant idea. I know that HW folks
> > believe that everything they omit can be fixed in software, but they
> > have to finally understand that this particular issue _cannot_ be fixed
> > at all.
> 
> Sure, the CPU should always be able to shut off an interrupt!
> 
> Maybe explaining the goals would help understand the HW perspective.
> 
> Today HW can process > 100k queues of work at once. Interrupt delivery
> works by having a MSI index in each queue's metadata and the interrupt
> indirects through a MSI-X table on-chip which has the
> addr/data/mask/etc.
> 
> What IMS proposes is that the interrupt data can move into the queue
> meta data (which is not required to be on-chip), eg along side the
> producer/consumer pointers, and the central MSI-X table is not
> needed. This is necessary because the PCI spec has very harsh design
> requirements for a MSI-X table that make scaling it prohibitive.
> 
> So an IRQ can be silenced by deleting or stopping the queue(s)
> triggering it. It can be masked by including masking in the queue
> metadata. We can detect pending by checking the producer/consumer
> values.
> 
> However synchronizing all the HW and all the state is now more
> complicated than just writing a mask bit via MMIO to an on-die memory.

Because doing all of the work that used to be done in HW in software is
so much faster and scalable?  Feels really wrong to me :(

Do you all have a pointer to the spec for this newly proposed stuff
anywhere to try to figure out how the HW wants this to all work?

thanks,

greg k-h
