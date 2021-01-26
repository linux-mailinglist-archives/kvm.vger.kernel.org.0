Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D91A304C49
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbhAZWgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13628 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbhAZRYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:24:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601050340000>; Tue, 26 Jan 2021 09:24:04 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 17:24:01 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 17:23:58 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 17:23:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzZyqCDfIplx6QvVY9cyqCbu9NIiue3ushXQt9sdxMyvqDKr8pDMv8D0vRVCj7PVZ7SxCGvuHViFll49zGI9b7XwuzK1pVkJSzHf85v/dFpcPgCXLNo/JGwjEFRZAXRPiRXXpd3yrOgLU+nxG0kbTt6YXaBYXF85Or7cqwT0ZAsY/GSyyuJiimO72QsI6AckwK0CdIFss++aD02DcnisGHERvNfd56fXZ7zrD/Iepy7HlwYfwzPNPe9GFf0Q9BPpvY6LjhqNMVJPo5wPyLbJvt5sTcm6fxM/H2WsHG+gMx5OtzVlCiy8Wo/cK9sIAQAPFJjCIp7ZNfjOsIawSdfniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5g0pegqcpdUlRveGMYLQQ2W+tvGG8hi7r9v0xewWA0U=;
 b=Ez4cLjM+zWPynQ1dZlGwwoej6ltmGuUd6nyOmgDFAXFQUzQHfD/uZYO7nyt3eqfID8Q/+qG8rHHHl6Jb3frRLHVunGNebMvUsRL4mAQJu9WNe6QKzLbD3TThVrWoC+c8c4riU5QJjY+OdK2OmbhRXQkeFyfPxLz86y6wtUsTJgBOr7Yds5Weqi0b9dKKAPQlE4DcMTqF9U26zjukqsD6lodbn84haUeROcaAvWA4IXuUcpnrsl3s/a7CqNVaVCSW7Y6Qs7DRRVK0yHT5ZCMVIse19DShfqzRNr/p0OKQE27ets6l705EdqtALyv+DRIHAzXFQgu39tjs4n7Gem6wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 26 Jan
 2021 17:23:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:23:56 +0000
Date:   Tue, 26 Jan 2021 13:23:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210126172354.GH4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
 <20210126004522.GD4147@nvidia.com>
 <20210125203429.587c20fd@x1.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210125203429.587c20fd@x1.home.shazbot.org>
X-ClientProxiedBy: MN2PR17CA0036.namprd17.prod.outlook.com
 (2603:10b6:208:15e::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR17CA0036.namprd17.prod.outlook.com (2603:10b6:208:15e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 17:23:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4S4I-0077tE-Oe; Tue, 26 Jan 2021 13:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611681844; bh=5g0pegqcpdUlRveGMYLQQ2W+tvGG8hi7r9v0xewWA0U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=NHRmAGj4QRzRPBhVOHN63QqHjsX/v30i2XaU2XgnJU4qZRbxGkEuAzA3itOq6nKCe
         823oTeaPiNiD7Y3XSeUVvAQX23Pzs9rb1+AbGNvV6j1hCQlFJS8uZ+EOQ8VMigpC2I
         FHF6kLf3F2BjEOBsuu3QaUleg08BUnQZ8+mXq0+WyQ45IsVldZP63nB+S5oVWmasQi
         fvZZtuBTjK9FneDTAyo2FHVX8L7ycE5QF9qL9MdBVTlAQK/SITv8bXBek4Pf6mT0ri
         INJCDNBpor8eVIw5wqrovxSHHUrdWoigIPUEhNJ+43jggDvteBCrgIe4Rw4UxMuzB4
         DnAuOzQCS08Lg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 08:34:29PM -0700, Alex Williamson wrote:

> > someting like this was already tried in May and didn't go anywhere -
> > are you surprised that we are reluctant to commit alot of resources
> > doing a complete job just to have it go nowhere again?
> 
> That's not really what I'm getting from your feedback, indicating
> vfio-pci is essentially done, the mlx stub driver should be enough to
> see the direction, and additional concerns can be handled with TODO
> comments. 

I think we are looking at this RFC in different ways. I see it as
largely "done" showing the general design of few big ideas:

 - new vfio drivers will be creating treating VFIO PCI as a "VFIO bus
   driver" library
 - These new drivers are PCI devices bound via driver core as peers to
   vfio-pci, vs sub drivers of vfio-pci
 - It uses the subsystem -> driver -> library pattern for composing drivers
   instead of the subsystem -> midlayer -> driver pattern mdev/platform use
 - It will have some driver facing API from vfio-pci-core that is
   close to what is shown in the RFC
 - The drivers can "double bind" in the driver core to access the PF
   resources via aux devices from the VF VFIO driver.

The point of a RFC discussion is to try to come to some community
understanding on a general high level direction.

It is not a perfectly polished illustration of things that shouldn't
be contentious or technically hard. There are alot of things that can
be polished here, this illustration has lots of stuff in vfio-pci-core
that really should be in vfio-pci - it will take time and effort to
properly split things up and do a great job here.

> Sorry if this is not construed as actual feedback, I think both
> Connie and I are making an effort to understand this and being
> hampered by lack of a clear api or a vendor driver that's anything
> more than vfio-pci plus an aux bus interface.  Thanks,

I appreciate the effort, and there is a lot to understand here. Most
of this stuff is very new technology and not backed by industry
standards bodies.

I really do think this simplified RFC will help the process - I've
seen the internal prototype and it is a mass of opaque device specific
code. Max's V2 should flesh things out more.

Thanks,
Jason
