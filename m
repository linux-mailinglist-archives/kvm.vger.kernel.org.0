Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13C288BDA
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 16:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388851AbgJIOwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 10:52:51 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:13547 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIOwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 10:52:51 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8079400000>; Fri, 09 Oct 2020 22:52:48 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 14:52:41 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 14:52:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvFoK1KgZln5hhpwY9a85WWCxf8va+5W+/2L7NDEZYehgs0tNI+UEcUyCFsMndeB3wvHeCa3YHpYzrcZBTPBmCH+LVgQdqWN2Ep/RH9jqlEgxMrNGYZEZLlXlHnqBL37WeK3pGQBQIgbJokAr9ikjXRL1XC6mUEpGen8K2l5DVMbFwWqxj2awgWKEhZ2OeehPP5VYkUPGHlo3mZYIe1WaHaWOp+KppgsoAThsptDFsBMzet5wB6zRfHgAI4erw3zaHbXMr5YLsWXEDQdDD2ngdEN0Vepw0ADosCW21fAVdoEGRb5esEU0NYed+PNhM2ACTdWMLPdaSiln2imAOZfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnpAeApxxNj2hniuJBvUTAL+HiLa9mGExzfYDNXIGa0=;
 b=Ji5h8O6AQBm0VJr7SDFGEQH0YGiFYeLmLxqCOT194WDSrHOnIlyAKVjAZIicW2EBSVAqxyTMIOwzXJn5ZpMY8m7HB0WbnxBMUQeknzskRWAxyQ8ya+LlgLwsMGaLN/NAGFbs/XNG3HcuM0SiBSDdTsqeh884vRpBACpjzrcqIqfzOa63o+mEGbKsk6FHqv/UrL9upwTGTzHM9ZcJXuSaGj2teys5RKbq9xJXoASMqhbdvi5EMAyQIuJ6nTNKXJWza+Jx5PEoTCz2GNQ1KB8ffXU00BcbG52RKJNQQcjAYlMUoMkzzzcQ3NFAphHs28hQiuVQs9DVSY8yu37TJp0whA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 9 Oct 2020 14:52:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3455.026; Fri, 9 Oct 2020
 14:52:38 +0000
Date:   Fri, 9 Oct 2020 11:52:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>, <rafael@kernel.org>,
        <netanelg@mellanox.com>, <shahafs@mellanox.com>,
        <yan.y.zhao@linux.intel.com>, <pbonzini@redhat.com>,
        <samuel.ortiz@intel.com>, <mona.hossain@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201009145236.GM4734@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
 <87v9fjtq5w.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87v9fjtq5w.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: MN2PR01CA0031.prod.exchangelabs.com (2603:10b6:208:10c::44)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR01CA0031.prod.exchangelabs.com (2603:10b6:208:10c::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Fri, 9 Oct 2020 14:52:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kQtl6-0020AB-7c; Fri, 09 Oct 2020 11:52:36 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602255168; bh=wnpAeApxxNj2hniuJBvUTAL+HiLa9mGExzfYDNXIGa0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=Ee4CYhqf3P646+h/KmQ5xLsg1LDf1ysTabhJ7gNKQsPxDTUIlhsg6IfxheeOsr8Jl
         pJa0ftm1QdnXBtaO2esw5AC3tnhk7XpBuoXJpi+SsP+dg6aKi6p9y3BsLbhMPgy26U
         /34qEYqHHTSFXcSS1LamIwMZrTCcqp9f2icLsYA8nEJkf33HAvq52tyihrGb50AmsW
         yGKxyiOe0U0dt3nshFOAkvuphana//G6eYSKhbwJzEuJlL6ze6Pcl2fMwPCscpXJ8k
         R9mrcr/JesEW7Qg9ba5N28bpAIrOefyLoC69bzdtNQwZr4WCOASjdi0CpUJHZWuims
         5PW7lEI0XoipQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 04:44:27PM +0200, Thomas Gleixner wrote:
> > This is really not that different from what I was describing for queue
> > contexts - the queue context needs to be assigned to the irq # before
> > it can be used in the irq chip other wise there is no idea where to
> > write the msg to. Just like pasid here.
> 
> Not really. In the IDXD case the storage is known when the host device
> and the irq domain is initialized which is not the case for your variant
> and it neither needs to send a magic command to the device to update the
> data.

I mean, needing the PASID vs needing the memory address before the IRQ
can be use are basically the same issue. Data needs to be attached to
the IRQ before it can be programmed.. In this case programming with
the wrong PASID could lead to a security issue.

> All the IDXD driver has to do is:
> 
>    auxval = ims_ctrl_pasid_aux(pasid, enabled);
>    irq_set_auxdata(irqnr, IMS_AUXDATA_CONTROL_WORD, auxval);
> 
> I agree that irq_set_auxdata() is not the most elegant thing, but the
> alternative solutions I looked at are just worse.

It seems reasonable, but quite an obfuscated way to tell a driver they
need to hold irq_get_desc_buslock() when touching data shared with the
irqchip ops.. Not that I have a better suggestion

Jason
