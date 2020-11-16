Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F190B2B52BF
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 21:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbgKPUha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 15:37:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43564 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbgKPUh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 15:37:29 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605559047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRrA+lIht8my3CpXkl+RcTt9wCOvgs6M6biuxMKPPfs=;
        b=0O3c6wl9A3pt0rj+lllrojVHTJPUY29eP/RkvYTb/qw5Bvpc9Rf6iOVg8Y4ACe4inYzxmS
        if7SzdPkrNEEwDOjbXa/MqDxKMgCbJ1GeqdiNbQzaJ5qTVToOdyqX/PyiybnfnC2Slkp0B
        4HVK2iw//lfjfPQKTEnXytVkdZavWhInHOkWfBvAZY8+ELl/63qqlUV0K06wlfWfQxaMGA
        1L3cqHHku2vVD02S27mvCKKWnpPMJZXfD/dVxm10SP26S7Zr3/NxEwy5aXxQR2F+Gk29Ir
        rcB+TeYiGiV+MmFs+hfMTRbvFesNVLLzlVvr88IYbzRDFS9yYgRZYqFBDEYMNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605559047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRrA+lIht8my3CpXkl+RcTt9wCOvgs6M6biuxMKPPfs=;
        b=Il7WALV5BltLgft7vZnOUvuYTErqq51XvAB5JDAW9qI0X0YIy+wb7KRtriVh56Iwnaknd+
        KLBMSFpxCdAtZ9Aw==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian\, Kevin" <kevin.tian@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Wilk\, Konrad" <konrad.wilk@oracle.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
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
In-Reply-To: <20201116180241.GP917484@nvidia.com>
References: <877dqqmc2h.fsf@nanos.tec.linutronix.de> <20201114103430.GA9810@infradead.org> <20201114211837.GB12197@araj-mobl1.jf.intel.com> <877dqmamjl.fsf@nanos.tec.linutronix.de> <20201115193156.GB14750@araj-mobl1.jf.intel.com> <875z665kz4.fsf@nanos.tec.linutronix.de> <20201116002232.GA2440@araj-mobl1.jf.intel.com> <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com> <20201116154635.GK917484@nvidia.com> <87y2j1xk1a.fsf@nanos.tec.linutronix.de> <20201116180241.GP917484@nvidia.com>
Date:   Mon, 16 Nov 2020 21:37:27 +0100
Message-ID: <87ima5xcl4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16 2020 at 14:02, Jason Gunthorpe wrote:
> On Mon, Nov 16, 2020 at 06:56:33PM +0100, Thomas Gleixner wrote:
>> On Mon, Nov 16 2020 at 11:46, Jason Gunthorpe wrote:
>> 
>> > On Mon, Nov 16, 2020 at 07:31:49AM +0000, Tian, Kevin wrote:
>> >
>> >> > The subdevices require PASID & IOMMU in native, but inside the guest there
>> >> > is no
>> >> > need for IOMMU unless you want to build SVM on top. subdevices work
>> >> > without
>> >> > any vIOMMU or hypercall in the guest. Only because they look like normal
>> >> > PCI devices we could map interrupts to legacy MSIx.
>> >> 
>> >> Guest managed subdevices on PF/VF requires vIOMMU. 
>> >
>> > Why? I've never heard we need vIOMMU for our existing SRIOV flows in
>> > VMs??
>> 
>> Handing PF/VF into the guest does not require it.
>> 
>> But if the PF/VF driver in the guest wants to create and manage the
>> magic mdev subdevices which require PASID support then you surely need
>> it.
>
> 'magic mdevs' are only one reason to use IMS in a guest. On mlx5 we
> might want to use IMS for VPDA devices. mlx5 can spawn a VDPA device
> in a guest, against a 'ADI', without ever requiring an IOMMU to do it.
>
> We don't even need IOMMU in the hypervisor to create the ADI, mlx5 has
> an internal secure IOMMU that can be used instead of the platform
> IOMMU.
>
> Not saying this is a major use case, or a reason not to link things to
> IOMMU detection, but lets be clear that a hard need for IOMMU is a
> another IDXD thing, not general.

Fair enough.

Thanks,

        tglx
