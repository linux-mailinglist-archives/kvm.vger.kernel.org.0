Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993562B3E95
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 09:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgKPI0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 03:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKPI0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 03:26:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A1C0613CF;
        Mon, 16 Nov 2020 00:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Df+ryKMLeLM6ZPUIVUI425PW1QFD2JY37ueasWT1tM=; b=tIcF381YzRWlS3vyV5D3+AOOPY
        UjVFVpU3pJzQGZgL64alCSS5fvb1ZabCxvl14Q67Uqz68kdFo9Dw0DZ7vwV813JqOS2GKzVom4Bdo
        8aHlR2SryN+v2/PISnP7i7Du4xMO1SS7K2slyKgXyOG+mdfd7rN7TflvQTrzqiX3FQpHW+cSJZp77
        agRSeSP5NVbfKJGtRiFYMOmIOSNusI5NZ5ktpUmqw2V+NEnk6NKchKVPCiFfB5cFfHQD7PpFHeoIm
        NAAFkVYo03/y7EckGRrceEBloQ0emPn/iUP2MX5sElP9Vb/nWmzolnZo3bt10tZoIusFIvPM0e7nU
        nsVERyJg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keZpj-0004Nt-Sb; Mon, 16 Nov 2020 08:25:55 +0000
Date:   Mon, 16 Nov 2020 08:25:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201116082555.GA16303@infradead.org>
References: <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114211837.GB12197@araj-mobl1.jf.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 14, 2020 at 01:18:37PM -0800, Raj, Ashok wrote:
> On Sat, Nov 14, 2020 at 10:34:30AM +0000, Christoph Hellwig wrote:
> > On Thu, Nov 12, 2020 at 11:42:46PM +0100, Thomas Gleixner wrote:
> > > DMI vendor name is pretty good final check when the bit is 0. The
> > > strings I'm aware of are:
> > > 
> > > QEMU, Bochs, KVM, Xen, VMware, VMW, VMware Inc., innotek GmbH, Oracle
> > > Corporation, Parallels, BHYVE, Microsoft Corporation
> > > 
> > > which is not complete but better than nothing ;)
> > 
> > Which is why I really think we need explicit opt-ins for "native"
> > SIOV handling and for paravirtualized SIOV handling, with the kernel
> > not offering support at all without either or a manual override on
> > the command line.
> 
> opt-in by device or kernel? The way we are planning to support this is:

opt-in by the platform.  Not sure if an ACPI interface or something else
would be best.  But basically the kernel needs to be able to query:

Does this platform claim to support IMS, and if yes how.  If there is no
answer we need assume the platform doesn't.
