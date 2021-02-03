Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7262B30DBFF
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhBCN4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:56:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10290 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhBCN4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 08:56:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601aab6e0000>; Wed, 03 Feb 2021 05:55:58 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 13:55:56 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 13:55:54 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 3 Feb 2021 13:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxISlYIir9Kk4KVrVe4/WVqYKdkh2IPDpe8/TYS+fYngYDnSAOuAO2LxCakQUrlOIVWMjcqt8DpD4/xVh/IiZ6I/CmXT8XCq9tbyNPEWd82PAgFCVLN5iU5Km7uexd9InTlBvQ3YrkO/Xx2qd8+tMwn7lHPb7hTXZIzqty/I5f/13KOKrD9QQrxaTYTIz3wiV+D22a46y6NxJ79y3ygFuHXyiI/W/36GCNIISfSvhDtdo2jdscqpTRaC51Lmdvmi5/3J0D6JaFXuQjDDMejY3NDuGmWNU9oW73CKw1TGbHT1UgK7WqMNWbOFr3tScySQMWzwY8fIa/iFzy+iwd2Prw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frc9UCUl/7CnzSDXRies9FfMTBqeed6dURjRzqcqaR4=;
 b=oZ1HTNmiZt7XPTP3pZEA/5FKqr+b4S1KeA972QjpjxWbBK8Be8fzGBhrXiNxAVsDffDON8VAcgOKwV/iEME6aQyLVQngi9T7qHUncxBdaCDdZa6t6x4WJOMr1ACQV8dUibEMFG6XAHmcuxS1oLM0Ky4IKefj21jmeREDRgMZ1WtybeT2eNLY8EGYTffR1RyNBl4Do6pa5SmTh+/pan/Re7B2k3JhXVzYCZ+VTRN56RSuy1n11VB52vNdqaf4rwPqWks0OuhNSK5/Mqq0RAooZmYvOF6i1Tcue3pJkpdBTJpX1Iwv87osm321TNFCl5ZcbCBoobV7mosll1ELdYeBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 13:54:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Wed, 3 Feb 2021
 13:54:51 +0000
Date:   Wed, 3 Feb 2021 09:54:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210203135448.GG4247@nvidia.com>
References: <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
 <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
 <20210202143013.06366e9d@omen.home.shazbot.org>
 <20210202230604.GD4247@nvidia.com>
 <20210202165923.53f76901@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202165923.53f76901@omen.home.shazbot.org>
X-ClientProxiedBy: BLAPR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:208:32a::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0095.namprd03.prod.outlook.com (2603:10b6:208:32a::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Wed, 3 Feb 2021 13:54:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l7IcK-0030eD-3z; Wed, 03 Feb 2021 09:54:48 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612360558; bh=Frc9UCUl/7CnzSDXRies9FfMTBqeed6dURjRzqcqaR4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Nw1xVRwLamb1OMicnCde0U/cSBtIMMzQAfw4LuHrKReKvN8EEF8xPhfmjSy+rckkU
         N9JpXLU5twYC4BV3s2U4EVa4s6frt9b++CbyLsx/a+jft8sZc7zN5t3wN6H9tlZhOc
         KNrQq5I151RdzvdrOn2jqcKyCEVa3or83ASQPWB2n1iHUnrgLG7W08tzvZU5hg17OC
         4wqRhSeh/18WDqgC4Q9irB/jdot9+KjqY3tgUe500MknUsLo043TwAKx6O85p69m3e
         uUQTcxLHMyqa0qlatIMOj1Nc1BmOeXcwG/S4EjflnI5jpS7Pu/Vdv6dmbBIGK615R6
         FPb44iwzeXGMw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 04:59:23PM -0700, Alex Williamson wrote:
> On Tue, 2 Feb 2021 19:06:04 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 02, 2021 at 02:30:13PM -0700, Alex Williamson wrote:
> > 
> > > The first set of users already fail this specification though, we can't
> > > base it strictly on device and vendor IDs, we need wildcards, class
> > > codes, revision IDs, etc., just like any other PCI drvier.  We're not
> > > going to maintain a set of specific device IDs for the IGD
> > > extension,  
> > 
> > The Intel GPU driver already has a include/drm/i915_pciids.h that
> > organizes all the PCI match table entries, no reason why VFIO IGD
> > couldn't include that too and use the same match table as the real GPU
> > driver. Same HW right?
> 
> vfio-pci-igd support knows very little about the device, we're
> effectively just exposing a firmware table and some of the host bridge
> config space (read-only).  So the idea that the host kernel needs to
> have updated i915 support in order to expose the device to userspace
> with these extra regions is a bit silly.

It is our standard driver process in Linux, we can use it here in vfio

My point is we don't have to preserve the currently loose matching
semantics and we can have explicit ID lists for these drivers. It is
not a blocker to this direction.

We can argue if it is better/worse, but the rest of the kernel works
just fine on an 'update the ID match table when the HW is vetted'
principle. It is not an important enough reason to reject this
direction.

> I'm not sure I fully follow the mechanics of this.  I'm interpreting
> this as something like a sub-class of drivers where for example
> vfio-pci class drivers would have a vfio-pci: alias prefix rather than
> pci:.  There might be some sysfs attribute for the device that would
> allow the user to write an alias prefix and would that trigger the
> (ex.) pci-core to send remove uevents for the pci: modalias device and
> add uevents for the vfio-pci: modalias device?  Some ordering rules
> would then allow vendor/device modules to precede vfio-pci, which would
> have only a wildcard id table?

Yes, I think you have the general idea

> I need to churn on that for a while, but if driver-core folks are
> interested, maybe it could be a good idea...  Thanks,

My intention is to show there are options here, we are not limited to
just what we have today.

If people are accepting that these device-specific drivers are
required then we need to come to a community consensus to decide what
direction to pursue:

* Do we embrace the driver core and use it to load VFIO modules like a
  normal subsytem (this RFC)

OR 

* Do we make a driver-core like thing inside the VFIO bus drivers and
  have them run their own special driver matching, binding, and loading
  scheme. (May RFC)

Haven't heard a 3rd option yet..

Jason
