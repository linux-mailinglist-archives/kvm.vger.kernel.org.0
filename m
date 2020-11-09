Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74082AC352
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbgKISKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 13:10:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:20845 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbgKISKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 13:10:44 -0500
IronPort-SDR: jliq5B+3ehTwhREM/Mn/PpRYCDSFMOkdT49LbDCg0u0rM7x5CblXbqcMaXwXKf09g0OThMdGy+
 qRJ+LiXI+NPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="166337354"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="166337354"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 10:10:41 -0800
IronPort-SDR: tuCvzS3iY3cpdxhXWsvyXZgcwAFdYuomVJ3Zu2pC/uILoxhmsT+axEq93WFuPDPjeW0G5GEjd+
 BZOWkmWRC4Cw==
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="327354691"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 10:10:41 -0800
Date:   Mon, 9 Nov 2020 10:10:39 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201109181039.GA15472@otc-nc-03>
References: <draft-875z6ekcj5.fsf@nanos.tec.linutronix.de>
 <87y2jaipwu.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2jaipwu.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 03:08:17PM +0100, Thomas Gleixner wrote:
> On Mon, Nov 09 2020 at 12:14, Thomas Gleixner wrote:
> > On Sun, Nov 08 2020 at 15:58, Ashok Raj wrote:
> >> On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
> >> But for SIOV devices there is no PASID filtering at the remap level since
> >> interrupt messages don't carry PASID in the TLP.
> >
> > Why do we need PASID for VMM integrity?
> >
> > If the device sends a message then the remap unit will see the requester
> > ID of the device and if the message it sends is not 
> 
> That made me look at patch 4/17 which adds DEVMSI support to the
> remap code:
> 
> > +       case X86_IRQ_ALLOC_TYPE_DEV_MSI:
> > +              irte_prepare_msg(msg, index, sub_handle);
> >                break;
> 
> It does not setup any requester-id filter in IRTE. How is that supposed
> to be correct?
> 

Its missing a set_msi_sid() equivalent for the DEV_MSI type.
