Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE739B906
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhFDMco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 08:32:44 -0400
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:16289
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229718AbhFDMco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 08:32:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnNH70PkYxRudON7Eq4y1U1alrn0s3DmgQ1uKFb9l5esTM7xron8HW5L+dHHxAIXx9IeCAki9hakCClZvl8aorXfpDo4O53w9ajFw6b1rcZViKa0EQKaebR5JAJ7AzdMKBcTsH9Gnife+3TZ5O3qdvXnrYsbZNs5QxkyR9O1iPnoQXtW/IwjhCUzW51IaLzowvW8GHZyMLOVAmMWpOza1axttVQTGXWY8de80mTWdp1pBM1w3GSsaYXx1L50/XHWyP0/JsBTaTpFas7DDcTI7/sSNx5v5lQFRW9fQsjwCD0ITs80t19BuYX7tl68I1FD85QRWdIIzklFAg9A01Qc1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYSajZxmk9yFAM8T9ccdUxvJf/Y7z3cFztl1+lq51ME=;
 b=h48rknMMkSGNsbRT4h3DE3BWC/mSPpu871T4dnJTCWXT/Cm82lobuAllGdT8bsZiClnHZ2Nosf6S8zDFQDh72Q7CkEcuTWZexO3gtMnjhhfh12qeEVf5TtnIJTzqBKdJlAK+pevCyxzVfSfRqK0q5pwGJNF7wqM9z2KNYolIZvxu+909a36ScL+mnufNoaPNfANR7Ni+bpYL0rxgHAPKZ+TGFguA+C57lACdLNdlErpOwyzjkQrwT6JAneiVFM0JzHqrQ05IFyg/XeUdclknE31DvxTovViGeTXNxXibCwVWPjBfyoHWw9daYROr3UKsaOgy+ek3agW1KIUNufYV8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYSajZxmk9yFAM8T9ccdUxvJf/Y7z3cFztl1+lq51ME=;
 b=IiBmZ+slI2ccS4e/gK2jCHswet22INbnGBGyqXUZovchH2CykibK0uvc8cVPB/R5Rl8X8Wf9Z11M5zWqE/CQlKZBaD9kYCKpSr0x1rHElj4uHo5dlUEmv1LBdgf25/xHTawcX43nozGhEk8XpDfs2YvQ3aJbcgOmFe+3a5vs+QH13Y2EgOepeT7GIWLoEJw80LZHb8bbfC8HX3yfhWOQfFH4wnwN4COz5zVhrRpeOmKr7b7AWNK8xEMaz88H5HGa1PNaaJ+lZ2w0ei5X/Jg1NH6ma1Ser9a25i3H82Z9fS9H/wmetvNZMvAg4tPOy+l6zqd/bm/BLbNoEUCEXCk0aQ==
Authentication-Results: metux.net; dkim=none (message not signed)
 header.d=none;metux.net; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 4 Jun
 2021 12:30:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:30:56 +0000
Date:   Fri, 4 Jun 2021 09:30:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604123054.GL1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
 <20210602172424.GD1002214@nvidia.com>
 <bd0f485c-5f70-b087-2a5a-d2fe6e16817d@metux.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd0f485c-5f70-b087-2a5a-d2fe6e16817d@metux.net>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:208:d4::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR04CA0031.namprd04.prod.outlook.com (2603:10b6:208:d4::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 12:30:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lp8yU-001dZY-V4; Fri, 04 Jun 2021 09:30:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1fc5c42-f930-4eda-d839-08d9275499a9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51276B4894375BCD663219C9C23B9@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtbkimCqUJBfLYlLA7w397U7k5PDqy8WsG1pbYD2Ho0ExWg6cq8IEZpGN/4ipr/VKc5Iq+3G5UuEzcgrvDRtiAGiaKXR/zFNSTN6IW1k4ammWo2EVw4768OkR8GvJduWQLiATcopAnYF7w1tJi8XWq9Blz+fdsd3daSTN+cIXd2g7JBToNObQhj8YbURGnKVGhV3KRaqlnaMz+a3YMThHiDM7Nf/Z0OZ3wRCVoc1KHmSpp0ZLhr3TKZuPR9LEYhLA1sfrqGcgiDQoUpmApZwkDYcvlNkb0o2qLXJVV543LQ6c09PKbcxY0pLfNWAsZpuy9eSIWyhlK/iLSZfHHMzDZ+T2UYNqgX0EIMAdQPQIjzeZEhTPEsysidTge/4k38wdAzaGzMTfSg5idUo2aWxncZLSDzDBO1MvlNsIbToWegISV8XM46KJQxhG2fHHhy6AfJ2u7PAUcrKFZlyUVvEKTeRsjgRifkLVZiXrv6Ii1p2lLTrgQT1ua6YXfb7LhUU4LxQGQ3LvgQqOsuvNzDMt8t45xYYt+OJy/dm42ADWbRw5PeGPho31sWUP1IjkCO+cB4ALFu4TV7XuhbEfaE6esgdWYwDDN/SG0mse3JAJdI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(316002)(86362001)(53546011)(6916009)(8676002)(9746002)(2906002)(54906003)(4326008)(26005)(2616005)(8936002)(83380400001)(9786002)(186003)(66476007)(426003)(478600001)(38100700002)(5660300002)(66556008)(1076003)(66946007)(36756003)(33656002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CiotAObf5R0NAtZA+d27JGBFyxKWyC9Mjp8sDfA3p6IlpnHB6JD3ak8QW+eL?=
 =?us-ascii?Q?Zd0zZvOebs+I200evyGhBY8tW2TdPIeiiP6L/6yeFfIJKaj5K0fyeKQz1Foe?=
 =?us-ascii?Q?aQA+/SY94R62LHsCK+SbqkUcClQBxKRmqdZCel+pRp5S4ECtMXsQj1BXBxOu?=
 =?us-ascii?Q?ArB9pzUw5q87OcrcxVyHqGnS+OQ+5RA2grvs5CEV6jTvnfYaIRZNf2jO+eb+?=
 =?us-ascii?Q?ybtVBDqg07HBSphGkYbjNvrTJR3BkPt/KBhthwVg2+1wdCEqni02fz5qNuWF?=
 =?us-ascii?Q?jSs9Hf68D+1H2yr8U4NFnEXO5Uur1fKY7IATs2OZuKlP6e1if2nMPMixxoWN?=
 =?us-ascii?Q?+kRb/zpd3ReTfI4kzsDiLrCv25Tc3hnbHV4rhPL6J5zM6LZRVa28/NsUHOgn?=
 =?us-ascii?Q?bHjHCvOtP955EGYMnRHH7cpZ3O9EoPwKDicsI8bQwpUTvSKevPbbAjxiFIut?=
 =?us-ascii?Q?t/JCcjnFkT1obczl73xs9z0EKmPPNhLSmuTRXSDas4lKb0ymDjwtLT10PUqy?=
 =?us-ascii?Q?Wm3ficBXVTqLg6YwqnMCLfhGh/SqHW38y017+sVH7mnjVa+Ffu/gRhhWRncK?=
 =?us-ascii?Q?/1k6hiFuy7P4GfbNessGlchhVIpXz99s9mqYfaS0xuYDx2fhqdrHSJCFAuMY?=
 =?us-ascii?Q?LCcexuT6CR2toVhvLyY/BUdh9qC3YS5ODezXsl5MoerEdd8Mpn4phO67KbMk?=
 =?us-ascii?Q?l76F2Rpe807VD0V4lhlkjBB7+mcVHddJ/YUwN7GzyB8/cEZRVclo599YQ5dF?=
 =?us-ascii?Q?DKZhcclCigGMN9NPDmnZHtNU6DaOGIaRO1MJx5C1m4ETsNor/9J6b+yYFGkf?=
 =?us-ascii?Q?IZ/0oAaKLqDTP7QzXWysdW9fip3QZMX9qN5jIGZr91wJaWziRsnbd13j+szu?=
 =?us-ascii?Q?uz1IqDVLkkaQh07Er1ZkUJtefu2LHc4IpojLbyoNayIn8bcgS0Q6IvEh6E3p?=
 =?us-ascii?Q?jVTytsZV07zxw+uZGLXxqLOuFn04VQYUGjae2kS6TUlZqIxs3XorRS12x3bj?=
 =?us-ascii?Q?Q9m3hm/sK88Uy/EYrld/6mDKv0K/uRaY2GiGmp+98cCXgeOJwbt85OEKF5Z7?=
 =?us-ascii?Q?XSvUTnDL5hCFcMDl90Gm1U0WwjDesj5VCNiyYQ3feXZI+3myE1oGE6nIAymb?=
 =?us-ascii?Q?O2LUHPHVXuh4ipwWLHyLMkW+MTLVb9iqAdAvo3Vl6niunbwGt8GnywmnN99/?=
 =?us-ascii?Q?RUVpwkG1wMAPQzQ6CMfIginb0DtAVjFGBjud1j9iZWe7GNuma7x2Ev7h5izt?=
 =?us-ascii?Q?OwHd6oHuWnsabDtIClFvOyrEccZouh3JgzlIWNjLhebvBG+o/rlIYSjZIFBz?=
 =?us-ascii?Q?kRWDkpNY8eAt3yJJQizcY4BL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fc5c42-f930-4eda-d839-08d9275499a9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 12:30:56.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6ZSBI8yi9RopQFW50TsF/1Q6NOJSb/irKCGszc8lP7zeWiQ9/uSt/faLcdjsRnz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 12:44:28PM +0200, Enrico Weigelt, metux IT consult wrote:
> On 02.06.21 19:24, Jason Gunthorpe wrote:
> 
> Hi,
> 
> >> If I understand this correctly, /dev/ioasid is a kind of "common
> supplier"
> >> to other APIs / devices. Why can't the fd be acquired by the
> >> consumer APIs (eg. kvm, vfio, etc) ?
> >
> > /dev/ioasid would be similar to /dev/vfio, and everything already
> > deals with exposing /dev/vfio and /dev/vfio/N together
> >
> > I don't see it as a problem, just more work.
> 
> One of the problems I'm seeing is in container environments: when
> passing in an vfio device, we now also need to pass in /dev/ioasid,
> thus increasing the complexity in container setup (or orchestration).

Containers already needed to do this today. Container orchestration is
hard.

> And in such scenarios you usually want to pass in one specific device,
> not all of the same class, and usually orchestration shall pick the
> next free one.
> 
> Can we make sure that a process having full access to /dev/ioasid
> while only supposed to have to specific consumer devices, can't do
> any harm (eg. influencing other containers that might use a different
> consumer device) ?

Yes, /dev/ioasid shouldn't do anything unless you have a device to
connect it with. In this way it is probably safe to stuff it into
every container.

> > Having FDs spawn other FDs is pretty ugly, it defeats the "everything
> > is a file" model of UNIX.
> 
> Unfortunately, this is already defeated in many other places :(
> (I'd even claim that ioctls already break it :p)

I think you are reaching a bit :)

> It seems your approach also breaks this, since we now need to open two
> files in order to talk to one device.

It is two devices, thus two files.

Jason
