Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4A288935
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbgJIMtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 08:49:55 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:14601 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbgJIMtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 08:49:55 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f805c6f0000>; Fri, 09 Oct 2020 20:49:51 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 12:49:50 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 12:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7diu487o4NS5vI3SUm5wcLHKgt9Nf1939f/oZDOHIrbMWxqA+ujmLHrVUQYxTK3wNT0yQ5epKgiK74bzT0G7rryNtak2ALJHmAVf39l+H77GFhIViUVp2JqE4cAbtgM16OP0I0cfsSFSQSVQU4cDarNMWA2SQUcsZIx1S4n2Sfh1lylfxjnxfhYo9+2Hpx4oC70vv2yyfU53YkR/qjxRBWVJBmh4NIw8Uu4hI4FziqUYsb1Mmnf5rzwz3o1zDGl+cBXk0sVegGQfUx9ScPdO7q5R9Lwh3loSfhOqLwnZVv2dDQQzvA0opHB9MMsl9exhdKMfQXA5IIeM15e5CvGFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFf5wttAAu/bh22Qy7sIBXTqiiUXLqNG6QHXAMs2jfI=;
 b=DUNkbw/QTbnuj7mzRbXG/cULqRBRR2gJTxrdyLvJSOmrA16hI0LTWWcOy3mi8LR495pl5iBHfCSEzXt0FAgILpO0GAiUaoiUXe3lbv0HSot5T9H8biqnmB0OvOAh0DYKpZmoylosC5Satp25eeWDFaTyF4oCmwRSmClVs0TU4YsnRiMmR+GQNMFJt+PWW35ADLrzIiqmwljnrKmKXL2m+6bbeHDWm2UQMRTMBSTxFymY0RwCHJQkjY6y0E+2T5xwxxj7YFqQK773pNrYM6QVGmIqe5KxA8TLuifQBVsAH4pRd0faPfHAxtZDU0ohnSvtz4gbQq897H/ov4Yy/3kRNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 12:49:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3455.026; Fri, 9 Oct 2020
 12:49:47 +0000
Date:   Fri, 9 Oct 2020 09:49:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201009124945.GJ4734@nvidia.com>
References: <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03> <20201009115737.GI4734@nvidia.com>
 <20201009124307.GA63643@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201009124307.GA63643@otc-nc-03>
X-ClientProxiedBy: BL1PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:208:257::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0039.namprd13.prod.outlook.com (2603:10b6:208:257::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Fri, 9 Oct 2020 12:49:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kQrqD-001y7o-Nn; Fri, 09 Oct 2020 09:49:45 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602247791; bh=UFf5wttAAu/bh22Qy7sIBXTqiiUXLqNG6QHXAMs2jfI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=nR0re7SpwIipdipfSnKwKbNWsBWC1Dp8k6Mv7C4EdhErzCtbOU+cTLcX1wIw9D0O6
         dgt7nLoGbmzkyu/btkw5nfCMatr1L9YOlXibymdG5/4osYO6eKA99EoposSfOgCG4x
         109PP5W8yjAwfwGo5arGqfizzAmt0TTmO5zVCTo9EeJ/fafrBS59cDPKjsxB/2EkAD
         EwlK3RpGYlZEoTzgIC4jszzMlCJRG8ijxlm/zYNdNm3ReZr2w3yu3hlR1PCTbaGMjZ
         mEKaMqvoaSot2f/OZIVaQOtFCmsIhmWy1Zmrsm4AbOpNtp22MLaBq6zXtkT6aEJd0y
         ktYa2wPDwh8FA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 05:43:07AM -0700, Raj, Ashok wrote:
> On Fri, Oct 09, 2020 at 08:57:37AM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:
> > 
> > > Not randomly put there Jason :-).. There is a good reason for it. 
> > 
> > Sure the PASID value being associated with the IRQ make sense, but
> > combining that register with the interrupt mask is just a compltely
> > random thing to do.
> 
> Hummm... Not sure what you are complaining.. but in any case giving
> hardware a more efficient way to store interrupt entries breaking any
> boundaries that maybe implied by the spec is why IMS was defined.

I'm saying this PASID stuff is just some HW detail of IDXD and nothing
that the core irqchip code should concern itself with

Jason
