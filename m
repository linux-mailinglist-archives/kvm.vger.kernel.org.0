Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C023C39E9E2
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 01:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhFGXFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 19:05:49 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:39264
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230252AbhFGXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 19:05:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7ZnMs51N2N98hJHXD80+qfzd7HnVbYQ2qypDW8CKusrwv0C0kRrM1cj63ji3jYOiqHSK9eLkbgBKqhpZkC10tp5wSP/HB6KlsNeYsd20iC5bJwAm6YW53198ySgu4bnDbkvQQ1O77IF+ChW8idaNdF6iCH2db+VfcBiQ43G9Sl5mwlP5xY3Xpv5iIdLpK7TbI2X5aUTiPXaPXGwf1hZ8vSDU6u3Xz1OAU4rHBTCh8vJ3FfZKLaKzSLQ++31C+diJaVkApiB9/zGMHJysSYe4WC+geoo57bDoF+0z8VT9pgouYWS6up9bdUHkS5nSCMsynQhSpNUFBSap7mF3btAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hpgkcQyPzpit1Vn16jU3dCoXvYz6ZYgCKckIAUZlpo=;
 b=Cn3sECxpJOtiGjm8cKSvNfv3GHAwWsz9gXQeaIzm4PfjUFwZlCgCzaHH8LeC0O2WtgTRq2TuGYqH34b9FPJBW9XD9BWqCfFf4dBV5qm9LDa+rBHvcpxMSxeGmsGWt5VyyYRfe2FKOu6AME3f7lZ+jwNO3eIUPQ9DP9x12aVU0BDpeXp2SKg35UsOMQJlz9+Wc0cmeXfjjUuMk/Lb8JVs2Jy0wcQZHxlUzIOIaZiaDZ/7alHXeXUm/lCH9jXPF8sEqLZrf2zQhuUVYD0fIAZ7rAO2xopViHRJU/hH41id3GMcCDtZbAaQFLhkW2VBs/kHNOZkad1JS5GT8pPruhNpQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hpgkcQyPzpit1Vn16jU3dCoXvYz6ZYgCKckIAUZlpo=;
 b=LzJm64eavbiYB2i1VuicD+L+YTm2le5wi4S5Po8u5RCeN/J12pCAE0BwQz257GSpJEzvRWD7futJpCIjKbfBZKYqYg+lcb/689FC5ULnTQpWlitvVdF9audDUEW3rvP8kUgxdoW0z2BD6xXEZc/mbjWe+mMOs4FKYnYQYmu6isYHcgKK0wXVNpMmTqN08eyk0KkykYbSgrgTOEV4qlPx3wRdKJITdECXrISMyNnA+PeNUYul4NXcg++5jqCCI4ofHec1WcVsyEEXBduuRQ4yS/DrZBU+khoT5m/e7E47qajMpOTtWvXEuKuonxewnUTICIASnk85sWIu+fM1IM8tog==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 23:03:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 23:03:54 +0000
Date:   Mon, 7 Jun 2021 20:03:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210607230353.GR1002214@nvidia.com>
References: <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <20210604230108.GB1002214@nvidia.com>
 <20210607094148.7e2341fc.alex.williamson@redhat.com>
 <20210607181858.GM1002214@nvidia.com>
 <20210607125946.056aafa2.alex.williamson@redhat.com>
 <20210607190802.GO1002214@nvidia.com>
 <20210607134128.58c2ea31.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607134128.58c2ea31.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:208:178::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR19CA0022.namprd19.prod.outlook.com (2603:10b6:208:178::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 23:03:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqOHh-003Tpm-Do; Mon, 07 Jun 2021 20:03:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 773b89f9-5ec9-40f2-6bec-08d92a0885d0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53015C6E2B6168D17811BB1CC2389@BL1PR12MB5301.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vvXnUeHsW/HbWIIMFAQRCozWz0YhPHicqzL2vZe7/dZCQJKjbaZOWN46fM4bKv+ObPtDjerzANjHZU9Q8801k4X/N5xiqKwVjbVCDezZPTg3u03/60vnnyAI9MhFwOCK18R6idbGbeotLVFKu2nZiW7CBIT+JYW0OY1U4JC+0tPFMF1BETxPu/SkJ3bhw0V1XOETNVCf+SdPPcKouwkl0PLIadRQcw7sPoDPCzcZdYDlTFpKzyQUebrwMoyaubfxR1Zdbteqy+UDdLp1020X6eE+ia+G9y0KJq9xxuS+bGjHXnyQUYx+aYbAjrVvdT7cil2jykSfKzNBri+MDjE9WPGsglHlsWiXKTHLwsj0l8xUpNH/FTB4MoavehHAOzPpt6tXD2sGIyWMzboXnxOjssrYfjNz0CwX0vCr8Ec8nYeSwIUVHh2R6/nepuYXBo78lJ0gsVySJH/VuU0E7VMzTNdZcyWLZrUPeHRGszTknBRWP+D1XmliI3p9REUa+4WmAko0a/CtZPADbc/sm1bB5DCMZ8fjCAFCak8FgSLEOdu2d9mMccuq6GaLd19YSrMnuzvc7fla2VXBwz8KAjGbGK/ZzhZB4Ee4l7cKeySkprXTeGau2VLJSQ9p0o7+vjYlKkNJYZxhKh9BAZnoH+CPZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(66476007)(7416002)(26005)(186003)(316002)(86362001)(36756003)(2616005)(38100700002)(9786002)(9746002)(2906002)(33656002)(66946007)(54906003)(66556008)(478600001)(8676002)(8936002)(6916009)(1076003)(4326008)(426003)(5660300002)(10944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o1PSgWAuSS89QWHJc7GTXbTDDhW4E+682alOgmdjpNhqXlGNyD+D1ZAHlIk5?=
 =?us-ascii?Q?Qhq1iXJCbGiem1ESuiXiNv7gg5gBV+L+yU7qHdSPtlEUWjmYTTD7NXZl5KRO?=
 =?us-ascii?Q?OG5v9e5+AfouxqjoD2q6Bitc/eW/T+3K0sOVafhTk76lxJVmd4TROUcH7/ay?=
 =?us-ascii?Q?8tRp2Ws6CM1lMmkxVTd562gvBE1zxarPILwyR4msTHBrrxF/vIpX6LuidWjT?=
 =?us-ascii?Q?mKI3liyZSQJsaP6YMDk21TlaGF6/rMFK/UimNYastzxH+lBxC8deyPDFw8pc?=
 =?us-ascii?Q?I3mQhsBgOhslvYDJ6o+IlDpryjb25764Dsk1ajVSehs0ZwFfqBNS5ZTy9IH3?=
 =?us-ascii?Q?NNFprT+pxmR9pE2D2VlVZ4bf89hYDlJuLT/sagQHsy9Sd2M1X/Twvi4XOnmW?=
 =?us-ascii?Q?y9NoAYeq02owleEdBcUfQ1GKeK+RK5jRzA846iFTsvaBPHJxFt1PymFvIF4C?=
 =?us-ascii?Q?0Y+oimuCrZmrLrP4WHGcAdYOAx6xrjsESHbNiWNaLQZJjifFxg4dP9Whua7Z?=
 =?us-ascii?Q?hwh5IYgGLt77ZKeUtt/l48EJuBZjukRKpjq59yDG6/Z3WDv5a15vjsL9uCJI?=
 =?us-ascii?Q?KTUPkeJyseej+rEcMXfk5lvoWGNATwfII/zD4vseTy3+9DBimrgAtNFfFGwg?=
 =?us-ascii?Q?DH2IgnqLjV3cXVm0LN8S+drDKJBmB842V8MdiYxGQB4aOSH/4uCErcM9SBU5?=
 =?us-ascii?Q?go1rVzZxte/vccmKrvTbDKLrW4ncaurdCJFWtuKTNF0WJLvy100II+Z0tL4Z?=
 =?us-ascii?Q?rNnoacKzY0zIvzIHxA0HRc9ZK5R9BSxo2fgi/K/GjhPw0ioUu4EMqflYzidH?=
 =?us-ascii?Q?bZ8LkK4XvFFGMUCkeRVAtzryUKTE6rcrgCn5FqjYNGvu+RuMssr3vfXq8PtW?=
 =?us-ascii?Q?TyPMN5SpKlOgwaN5zI63th23jnvUQgKBM+WpZN8rInkVOH3A7P73yjfiUsjD?=
 =?us-ascii?Q?goLNKRztMi19zhoQpXY06CqCkYVV0d0tCyoOTUcFUPVNt1avCTlrIsyy54sA?=
 =?us-ascii?Q?2zEjhOYy+dvSvnaLkLVF08yNwPTMPHoQaG5bJsOI3kAYP7ff8/bcIJlWjSvD?=
 =?us-ascii?Q?sodzS4/lXO5zVL+R7GXSjtlzE56wY3EKnThGco9L0EbwXBShXeeVpj/iKxjq?=
 =?us-ascii?Q?2SV5aHrWyQVcJTQDVktXHa5DCteu15oiDL3oFgSp5mxyfQlArNHeb8jwjtIL?=
 =?us-ascii?Q?EsgW+SHNc3osVH/E0dAKELI2fO4bv2/L6pLEp4wsaV3sLDxWKy0xyqZZ1ODi?=
 =?us-ascii?Q?gGJYrkwyWQx0fG53ztNK5jeRXwflOkYqQoKrkjMkcIDK1gJVjCAZSyVvDau4?=
 =?us-ascii?Q?ZaTWi2+K540NDki6Y9Qz5h5U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773b89f9-5ec9-40f2-6bec-08d92a0885d0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 23:03:54.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTew+G0RI2A0KrhodFCYNAXvDYoREyhYSdUzFPx/HowmeeDwKaF3jOJi3ExHLxHy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 01:41:28PM -0600, Alex Williamson wrote:

> > Compatibility is important, but when I look in the kernel code I see
> > very few places that call wbinvd(). Basically all DRM for something
> > relavent to qemu.
> > 
> > That tells me that the vast majority of PCI devices do not generate
> > no-snoop traffic.
> 
> Unfortunately, even just looking at devices across a couple laptops
> most devices do support and have NoSnoop+ set by default.  

Yes, mine too, but that doesn't mean the device is issuing nosnoop
transactions, it just means the OS is allowing it to do so if it wants.

As I said, without driver support the feature cannot be used, and
there is no driver support in Linux outside DRM, unless it is
hidden.. Certainly I've never run into it..

Even mlx5 is setting the nosnoop bit, but I have a fairly high
confidence that we don't set the TLP bit for anything Linux does.

> It's not safe for QEMU to make an assumption that only GPUs will
> actually make use of it.

Not 100% safe, but if you know you are running Linux OS in the VM you
can look at the drivers the devices need and make a determination.

> Yes, QEMU can reject a hot-unplug event, but then QEMU retains the
> privilege that the device grants it.  Releasing the device and
> retaining the privileged gained by it seems wrong.  Thanks,

It is not completely ideal, but it is such a simplification, and I
can't really see a drawback..

Jason
