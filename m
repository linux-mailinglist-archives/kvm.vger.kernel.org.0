Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2103B3443
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFXRC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 13:02:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:41012 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXRC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 13:02:58 -0400
IronPort-SDR: 2qg1F7AqXMLaduBvZ9EDqAEMEP2Qgny62S8tBcP3pzyPF6zC27tytp69JNMYReZaUkgk/2hKZY
 T4bLPDkx2TbQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="207552777"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="207552777"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 10:00:29 -0700
IronPort-SDR: vNQhrnzkoU+nttCQvWuDFgP9ciM245PNH7OvUhhQTYmvsowoak6ujOAO5lfoBE9tW8J0Oxyve5
 yWYxPI3kP4zw==
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="407097549"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 10:00:27 -0700
Date:   Thu, 24 Jun 2021 10:03:16 -0700
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Virtualizing MSI-X on IMS via VFIO
Message-ID: <20210624100316.1c1c4c6f@jacob-builder>
In-Reply-To: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
        <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
        <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
        <87bl7wczkp.ffs@nanos.tec.linutronix.de>
        <MWHPR11MB1886BB017C6C53A8061DDEE28C089@MWHPR11MB1886.namprd11.prod.outlook.com>
        <87tuloawm0.ffs@nanos.tec.linutronix.de>
        <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On Wed, 23 Jun 2021 19:41:24 -0700, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > > 1)  Fix the lost interrupt issue in existing MSI virtualization flow;
> > >  
> >
> > That _cannot_ be fixed without a hypercall. See my reply to Alex.  
> 
> The lost interrupt issue was caused due to resizing based on stale
> impression of vector exhaustion.

Is it possible to mitigate the lost interrupt by always injecting an IRQ
after unmask? Either in VFIO layer, or let QEMU do that after the second
VFIO_DEVICE_SET_IRQS in step 4.b of your original email.

After all, spurious interrupts should be tolerated and unmasking MSI-x
should be rare. I am not suggesting this as an alternative to the real fix,
just a stop gap.

Thanks,

Jacob
