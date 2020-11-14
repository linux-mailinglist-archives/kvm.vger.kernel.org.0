Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7E2B2CBC
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgKNKex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Nov 2020 05:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgKNKex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Nov 2020 05:34:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF967C0613D1;
        Sat, 14 Nov 2020 02:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0hO+ohxPFig28LmimZnxfVLjXY8uLImJhPLPYl8JZZY=; b=qAPdnN4Bzx0J7JHwtNQo0kHxh7
        HOdDpzofAB76DNnzWgvY7n/d8g7L5+lKP4FwdEXj7NhLFlvT2SQp5lvemvza+5dUAJKvdYr1QfNv5
        NEv66wT1SaGmu4/B6RWYHYtlWF6VjQl7nwAyRADph6/UdKsMfXnqsHMwuRNRiLZoezFpvyzRsV3p6
        mP31cBOoMKlgT+nexv3m6pd9m07av3/4tGXODiXU9f5fr/BOKZWzVE0JDpRr35AQ1oPy3elmqLP1v
        nnbL3lbrOOLwQgASpraNn5mDxoap10740ElNRuCQknqK0oE2h1m1uMYkcZOfRIc0fmOqVZOUGXBT5
        n+G0qhjw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdst4-0002gd-Di; Sat, 14 Nov 2020 10:34:30 +0000
Date:   Sat, 14 Nov 2020 10:34:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20201114103430.GA9810@infradead.org>
References: <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dqqmc2h.fsf@nanos.tec.linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12, 2020 at 11:42:46PM +0100, Thomas Gleixner wrote:
> DMI vendor name is pretty good final check when the bit is 0. The
> strings I'm aware of are:
> 
> QEMU, Bochs, KVM, Xen, VMware, VMW, VMware Inc., innotek GmbH, Oracle
> Corporation, Parallels, BHYVE, Microsoft Corporation
> 
> which is not complete but better than nothing ;)

Which is why I really think we need explicit opt-ins for "native"
SIOV handling and for paravirtualized SIOV handling, with the kernel
not offering support at all without either or a manual override on
the command line.
