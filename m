Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A853A17A4
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhFIOr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:47:29 -0400
Received: from mail-dm6nam08on2056.outbound.protection.outlook.com ([40.107.102.56]:34273
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231162AbhFIOr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:47:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9uJAxA9IRUCSERxnNYEXhO2TNZqyW2+a9q3wEd00JRvpzWUx0S5w8hBP5o+h2m7meFC3ub3wFfHok9aTrlaM8FwBOiqobVAewwI+AcaAtJZLG7jaUEqEpq7YkmPAqTPI8V/egMHW1mTjd2XW2xW4qgVRjtPbAb0jtKd2P9Kbqjo4vzJAy4cjVFwWsJNvwSWOGOISU9Z/tJrzBFRedJnDHwPL5Bw9L1K09RqSqkbc+9NH3kQQW6AsQSsNCfK7KjqAw40txCXBOak2pZ7Vhn+iyXT8pzVjlqOBh9SrBuxFZ/LvVGuFMoSWIFkzAmarZMaN9W19eY0/jWC/WdriqMA8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Pt6geJ100e+qGBfPGrQ3RZau30+Im5rgBmwNsyhsnI=;
 b=AFOUot7KWAjzzjhHT+R+vd7CvGz5YEc4e5Mhng9i53WN/OTp4OLgM8EAAcjCO2mTFA79sTJuALBF0q9my637wcPs10d0QsRXc9Ig2rZHghPUVhIOU5zTw+N6+KEmgRzqq7tKunU3mvtq8EYQu7ZZaJnNLur8XT/D+cui+MqqbvskdL8MbnJF65xR1vIu80sV4+bpFCuBi0ZLGjSIVbU6hGF7oVhKUyMpTH4OtC6jPYFzK7zDE1mw2faSlxbgiUxhhdiRB88qTbXrJ/AqZBsBMhzwbBBiMhDrrnGAsv3sloAJyP+QdSCVF7e2aiSNh6Je15TZAgQLmEBPQw0RCmtraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Pt6geJ100e+qGBfPGrQ3RZau30+Im5rgBmwNsyhsnI=;
 b=WI175eI/jcqiKCeEwonvx/5BlumNYc9WbNXEKH0IvTzxQwn+F4y17IFOOKlnagus6NiVSW2lLE+USwmguUSod8H8cc8QNHZfrYg1wJVA6mJiNyOFxlQa5Cg1VgkIZiGi2j22Zz//A62aS9xuU6GjxT5ELe+bWSzw65yaILCvJKm7NWVkQwIE6T0NJIu1Iv+8NPqDVPOmLIovUMt2D3Sdv3ZUag3K6wMz5IsTKikXM/dwhO8DwlCUSni04Y+kcxEE1dsVPlXDAs4PkfUhHh0zI0KiC+X4fUHQnBY7iOmNaf/eO8YBJN9vSCAGIuVnzPi2yIuxzl5nxrJPyOhgLLm29g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 14:45:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 14:45:31 +0000
Date:   Wed, 9 Jun 2021 11:45:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
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
Message-ID: <20210609144530.GD1002214@nvidia.com>
References: <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
 <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
 <20210609115445.GX1002214@nvidia.com>
 <20210609083134.396055e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609083134.396055e3.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:208:239::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR08CA0012.namprd08.prod.outlook.com (2603:10b6:208:239::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 14:45:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqzSU-004ePg-HJ; Wed, 09 Jun 2021 11:45:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33ad18be-3a58-418f-6578-08d92b553b29
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5303615E79C26145A813EA1BC2369@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLA8Atl84dQgiE/SWKEuJugG++yFpkcYT3vmQnsqMFWEzwMml8HXoGSb6Stxp0NPyWWYTp0XRBcYKUggQD3gXDw2YWqYh2TzP6oq1U5q/cT3cilHnrTLU1G7hAocPci1b9SXeeLXW+KeoFWvwQCKueCxjvLtETPBYs94XCxF1tWv7PmXdz8/QX36gXejv+krzBApESuKj5/jiVRA2mutLzDKH4lw2IeeCAxN1vBd8/U4z2YBj8iaVFdFHM7Y0H5U/6NuyN+39PgW95PVys99eNkbe2B6pyuHjopJnZwAjhTXfVfUI80D565QgZvp08brKUSz5q5XBdKYZO4IEBqqj9mVFZrgirXxv5bBJggjoCbzmQ3P0wcvGxfq4i41mrK7E7LKlHrdVJMRs1sbkw6qaBJEbshvv3ozuibe9Xcpfx+ObZxw4gKHJW72IJK/xjTeKcUXvXsJ6EX3XSr9D/TceeqnbHjmZJiJSp2iGeGgHkXr3wrLc6dGCGgTe19E/xMId7Gy4GUzChvVhOBUJEKQLJBs8KQg8pQpOYfKlEZJPINWcPG6ELSsxsJvI6KHC1aWVz38LwCFog4dRhxZrNuZAd98f/E+IRExBQBA4UojoFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(4326008)(8676002)(83380400001)(38100700002)(7416002)(54906003)(5660300002)(2616005)(9746002)(9786002)(426003)(498600001)(8936002)(86362001)(26005)(66556008)(66946007)(1076003)(33656002)(186003)(6916009)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XBIvD+cGNY/e/v5s4OsdZcDJ727LzuXX4EPkWrLzbXrum1bgAgvv9FLl6a2T?=
 =?us-ascii?Q?wjnl1KxhVvhOR8XpL7FYijgCyvmxFMTqXgHISFHVDbHZ2PxVBR7ryM3ghsiw?=
 =?us-ascii?Q?7Z6GIXPeSu/CBl2BVXX5I1MEk/f0FNwvoDim5x9PDBTYi60+dkzmmJWuRsLS?=
 =?us-ascii?Q?9pKTpCzJr+yQVj1t3mTJNIGdWQJ2RuDS/0x+qXbqsVcotgSfrcl6ULR84mgU?=
 =?us-ascii?Q?ubKEYT/G2qresGKQonQCn79NHvuHrBaHJhQO2YzglxRVoHEPUY/eetJIwszc?=
 =?us-ascii?Q?3wHXRp5TejK6GH2bB1vwRWb7jUQplN020cMAEhoC5la4YSOWI9qIUYDrsdyI?=
 =?us-ascii?Q?pNBL60DdItt5YypsmKqKyrV0AKjF3VPUZh8eM7oeVlP42GzmTPmCH1gB7+yW?=
 =?us-ascii?Q?4aIXqRvIyN1zvjE/g/I9Y+qeMEfEiZqJK30qjkif06UD/6I+4REIE8epAr/x?=
 =?us-ascii?Q?5HTw672ATaAkJR42tjd5vjvRx1W83sD+ndeEIf/cUkStpa6if9rIUZglHG8p?=
 =?us-ascii?Q?g897SZ55P7YaJZ56YIi7CgJNXibN88VMBZG6ZVzzCZWfA0D6BU0AgyYvR3Im?=
 =?us-ascii?Q?lDWSE2XawkNaB4HFHTJplL6oYIXAbAmLV945INewG2zH+1/or2bkFNLlKqEq?=
 =?us-ascii?Q?EF7w4sKz9W2hF1HHH/HnvjqhRMeq4YtB/I1YaCdtUYfiV/oVjIuope1S7HnM?=
 =?us-ascii?Q?H0FR9vM95GaDm3YgqEQF9kyORj+pE7OPfFVAArpBSWWe4csDlowRKHKJpzl5?=
 =?us-ascii?Q?JBVSTTdxLusJrEJI0aOmMgVowcnbiERdxmjrywzIHIPJ58e5bgDOxG7R7/kh?=
 =?us-ascii?Q?g5wmILwclNR79Y8Z6Ja7tFiICpcyINpdIKXMO8mcNyeeM2yexwhLTs/8m0j3?=
 =?us-ascii?Q?N2dKe9ySBFAKFzDcK/gsRyEp9/n+a8FgO0ZzNMyNyOmgYatKOwhtMRQ2cfhr?=
 =?us-ascii?Q?2lt1ZNnrhU8jE2O6KiCqxtnWiIH81WI+GqJ3v1JJZiDXBPYz5cMlSI3WXmIK?=
 =?us-ascii?Q?YsxVE3Si1lBrjehLMj8mYgNkMGAu9Kt9cmbbejaeunXySu2AEKOhEycOivBY?=
 =?us-ascii?Q?lHSx8QJflyZ5NwLq4KGWwKfXSlcnv7tcleLTnZqB0JirIIlhZSLEEMQ+YqVM?=
 =?us-ascii?Q?B+9qKdBIYk1rmrmyx1oEVfqh5qU3bIeF8XJkXPGl+/HdP74q5M6TtJ1KIZfe?=
 =?us-ascii?Q?zX0Bn78kz3oGlh6uWKj3gfRP2KFHrblEWQEseWzl4kEUPj8urT9Qpu2zv+vi?=
 =?us-ascii?Q?jZSjXDQsS5XvYwzbe9VmMyCo14qg7AMznMhsFxJpjdu9ScHTuYs8IoJ6S8D8?=
 =?us-ascii?Q?es+lMMQ1109p+LGSheTxGY3X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ad18be-3a58-418f-6578-08d92b553b29
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:45:31.6231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPv7dkGOuJP57ADrRcX8jlH/XI+T9FcebDKGR37jwcHw1Af2acAjEEStb2OgZWH+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 08:31:34AM -0600, Alex Williamson wrote:

> If we go back to the wbinvd ioctl mechanism, if I call that ioctl with
> an ioasidfd that contains no devices, then I shouldn't be able to
> generate a wbinvd on the processor, right?  If I add a device,
> especially in a configuration that can generate non-coherent DMA, now
> that ioctl should work.  If I then remove all devices from that ioasid,
> what then is the difference from the initial state.  Should the ioctl
> now work because it worked once in the past?

The ioctl is fine, but telling KVM to enable WBINVD is very similar to
open and then reconfiguring the ioasid_fd is very similar to
chmod. From a security perspective revoke is not strictly required,
IMHO.

> access.  This is no different than starting a shell via sudo (ie. an
> ongoing reference) or having the previous authentication time out, or
> in our case be notified it has expired.

Those are all authentication gates as well, yes sudo has a timer, but
once the timer expires it doesn't forcibly revoke & close all the
existing sudo sessions. It just means you can't create new ones
without authenticating.

> > > That's already more or less meaningless for both KVM and VFIO, since they
> > > are tied to an mm.  
> > 
> > vfio isn't supposed to be tied to a mm.
> 
> vfio does accounting against an mm, why shouldn't it be tied to an mm?

It looks like vfio type 1 is doing it properly, each ranch of of user
VA is stuffed into a struct vfio_dma and that contains a struct task
(which can be a mm_struct these days) that refers to the owning mm.

Looks like a single fd can hold multiple vfio_dma's and I don't see an
enforcment that current is locked to any specific process.

When the accounting is done it is done via the mm obtained through the
vfio_dma struct, not a global FD wide mm.

This appears all fine for something using pin_user_pages(). We don't
expect FDs to become locked to a single process on the first call to
pin_user_pages() that is un-unixy.

kvm is special in this regard.

Jason
