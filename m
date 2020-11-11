Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E9D2AF53E
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgKKPmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 10:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbgKKPmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 10:42:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B850C0613D1;
        Wed, 11 Nov 2020 07:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QDIYgmHBIy32D7QMJNlh1Fjiv1S5HS5loWTZCLGENSc=; b=sVzlTzvFGPcaqnv5C/H2WY6QKi
        /unIroT+1YmBBbvs8x+xexAEOhkNbqZDvS8PxUSO9q/HUDdE0beM8VeroRpSDI8SPMv5NNiQ1NJH/
        lSI33hhfgTSmjUf2/nh5eXMoQ+zbvNz6k4ffHUvIWZV7xYrKCkfE4LtlQL9THAz5F133sQ986c7et
        kSA+KEkgmVYDvSSpYkEAzBIT7KjbPwLNXBr3rWkWD7TNe8CNSbODlZddMvphjrYbREixwvj7vQnyS
        IGKBbLyJhaSLtWGFIBkQholxO3GactuGlBeJt4HU+lA6tgUvbtxJizVX/J2+w/3vVWWTfHulqlRIK
        DUu2UOhw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcsFz-0006Ri-Kf; Wed, 11 Nov 2020 15:41:59 +0000
Date:   Wed, 11 Nov 2020 15:41:59 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201111154159.GA24059@infradead.org>
References: <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08, 2020 at 07:36:34PM +0000, David Woodhouse wrote:
> So it does look like we're going to need a hypercall interface to
> compose an MSI message on behalf of the guest, for IMS to use. In fact
> PCI devices assigned to a guest could use that too, and then we'd only
> need to trap-and-remap any attempt to write a Compatibility Format MSI
> to the device's MSI table, while letting Remappable Format messages get
> written directly.
> 
> We'd also need a way for an OS running on bare metal to *know* that
> it's on bare metal and can just compose MSI messages for itself. Since
> we do expect bare metal to have an IOMMU, perhaps that is just a
> feature flag on the IOMMU?

Have the platform firmware advertise if it needs native or virtualized
IMS handling.  If it advertises neither don't support IMS?
