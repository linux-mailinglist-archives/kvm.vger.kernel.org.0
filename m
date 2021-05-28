Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACE83947E8
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 22:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhE1U0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 16:26:54 -0400
Received: from mail-dm3nam07on2059.outbound.protection.outlook.com ([40.107.95.59]:51041
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229482AbhE1U0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 16:26:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZaMp4BpOl4jokQ+7o6gUHnA97gs4XkDqegudtvuQ44G6W8ooYeT+5P+ZTFNK535aaJmqtowhNYLJRwULHU1iXrSq3MO5btDwuI4h6yf1b8bk0R6+YQ6nTxpuYzpGp7H4hnJgWOqYtTQLQtJWOtspU41J5UduPM7xNxKNmQq+ppB5g53N4C89Ey4yCk4snlvw4DMQC5quYlbz0YnkESyIG6/xYleNxRcpllZFSPBnD0FvpAwCQTir+RY70bDMAhRqct3en53fiVKjOMeuactpmfTleht8nYlJvhxCh8x44PIq5oa0pMs4ZMU7ynxdKTSvxbXGY9URqC8gqkgy63hMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zynffwf3glos5iZqJoTP91wZN73gZ/TeXvDCN/FBiQc=;
 b=dLQ0qqdysjVRlYYppaoiIvpcWxDYDdBqt6ZvCWY1Tp4OnJVJPjvdnVVo/kPBoGSmGbfKsRi0oAErn/ALA93AmsJ/0gi3OPpwdDfMjJlSNG3ZGQJhjgPyfA1ElM8Mrr9eT4walH8CqERgZgu0tEo7Bb5rTlrr1s4UX77CyZxlPSAnkvqUMMP8GBvb83lUgaK1NSY4m7kyfn3lGWfGT2Ggt24LcTwKJdPVkpecqdP/heiJ/rTOFOsPYwYMYNrPkqNp0yrAth8UfynMnWS0WatPEzmdOt/PPOEV5EhfW6CYyC9veeyJCet/XDGY1kGWi8Q2PFVfKgWuBtyXkv3PELybqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zynffwf3glos5iZqJoTP91wZN73gZ/TeXvDCN/FBiQc=;
 b=ojYM2DNrN7UFRXikv/G+QVXTXEwDTTLfLydEPmujK3mOMMoXV3iWkDkKO8EJG7wlBP8LaE24wHaosJkqD5xN1iU9PQr8lTfVfKWHGGeKGWPh+GXwp/Z9Pe/lsSejwNn2qoHnuVmx/PJRQlXlgOap6iU3h28zCaPGx3VaSeudnwHa7VJI0kknf3E4mUcnaI4oKsDRAmxOMmtE70194r6WG7fK9Ug2XuQWZaH1apwz3W/j3+Avd8DY9haE3yw6VCxbxnMpMzfoqhsWvENATYRlTjuBe6fOQ9Af/nsdcT5PAR/0AazRFqdTn4YMCVcefazpHPzUqhcQfooJM4NWnAMMzg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 20:25:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 20:25:17 +0000
Date:   Fri, 28 May 2021 17:25:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
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
Message-ID: <20210528202516.GR1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0447.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0447.namprd13.prod.outlook.com (2603:10b6:208:2c3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Fri, 28 May 2021 20:25:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmj2i-00G4EQ-CF; Fri, 28 May 2021 17:25:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3087f1c7-124f-4e3f-c2c7-08d92216b4fc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB512723E5E4714AED048B8AC6C2229@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NI9R/k6AsjjczKYOi7KP6FiqM3D5IzEVqApqXmlqQGhCgy8Y7lb+e4WDevw+hro2gFi2yUwAzjuPxG1l00ReHfPLOjM/XH4HhYevoPaE+10Y1gQPGuOvDn0Zs9wKRkeTlmaakfi/s/Ma4AD4JR8LIZrxKHrSzE/CFC3yOO4byk4QKMBhF8Px1fNqShwCsTbKTLsUw/LOt89Eek9GowV2AsRcTjmVhG9v4m7Dn2DZAE5a0qE0y56AbhLPmtgZ9Z6KXg8UuFU7Yr4jSZ5FNrTXQaPC0uJ9TqmVvSwpC12mujBTiUyOYNloPj+B9cOvLoNY7cat4JmfcUzTZNNhRxyP9QMGPLnd/HxEuweSDA6I9N5fOjKwrvkwZKz0wuPTgBLs9TqeWSenzQ/5wCn2C5rWw7Ukaep8zzOWPowYn+Q9u+wOFOz8gDeQ4dEZpR7Qdu5Dj0eBjdmskjMaVBQ4oCpZ7MgsAnyvCsU2PuxO9J2mBvQ81AXRK9Dqi2I3JRCrEkBKEB+3UokFGxG1IZp+0K5Okd1Oj1LMUX4jHiK6FPQRyAps5tkyH9NMKrSJBCbM4zMax5go2pUs2itTgNj+3qKFxE/pA9TJSFn3Rnn7gSkgCa4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(7416002)(26005)(33656002)(54906003)(5660300002)(2906002)(6916009)(4326008)(8676002)(83380400001)(8936002)(426003)(38100700002)(9786002)(66556008)(9746002)(66476007)(316002)(186003)(66946007)(1076003)(2616005)(36756003)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DOMkVXpy/NsU1Musxzo/no8ruMc3hl723576m8a+LgHg1Yz/JzXNci88s7aO?=
 =?us-ascii?Q?fNlteYsiqZc1J0VwU34X/o5wP20MPymrQMl0mL3anoU9gWwukJc730VrYgfQ?=
 =?us-ascii?Q?JoCWs3NuEVHqRhoGyWxshw+dP/LB8hvqHYh3oSuETDargNJ/l/+q9JO9CmXF?=
 =?us-ascii?Q?5916ksfebYqc8GQwrmlqY7A4aFIj5+RGyDT2iil40SNj8C536ZO1c4MU6a8C?=
 =?us-ascii?Q?Zg2obOWT55Z9N/YI52Ii+HwrKFrnnaTFNtkn3tI/bUE5NOh9RXOkk2axcLK2?=
 =?us-ascii?Q?S8dKsP1g7VmgHPczp/OOY8XIuGZ30L+y/ahV3MvEB5O6XpgAWlLVD87609kz?=
 =?us-ascii?Q?f0YZEwLJ+QDk2j1uQpLmn5XZDJ7PbVYOBlA/x4AYpwVXg8cO7bVU/x/b7Tz9?=
 =?us-ascii?Q?bsqXsSnNJYzkQsbtSY9x0WkvSZxVP7+dKGa1K/ProPi4j0ddAK0ibPFD6a2I?=
 =?us-ascii?Q?owCrQ4vjXiiEIlYUdOdIJvbdVzTBfZEw9+a+IJ2DtlUR7JPR6QtR1lXyv+59?=
 =?us-ascii?Q?n+2tjW8xvDwkdKrMZ/OUO8zX6R0e7r+nbo1/KR0qvcEdia723MSr41IqEflA?=
 =?us-ascii?Q?qPAMO1YaG3e5c6s4EY7AlZwzRhdI1qHg+MQV6lRRMiIpicZgdKt18LN9BCc0?=
 =?us-ascii?Q?70PHxHRXNpZYBjR3HSKTa2amJp+knGDIdQxE405PW59ng4i2k/bHlSog9OLu?=
 =?us-ascii?Q?gmLNeVtmh1Fr++NCgJPVF3h1QlI6ywFrTcDq5s388+a7LVTha06P/jWJtNA7?=
 =?us-ascii?Q?Dtpfswkbsw2upXVZcK3e80AVTuX2yH0Z2uxjFZyQCJldY9kP8lsNINpYaYB1?=
 =?us-ascii?Q?RHaZezyUWcpXFV7KHfa81FtOka0Zp4j6b/eIeYquhVUNy3IawHo+Q3dQhGPl?=
 =?us-ascii?Q?BZsOs4dqLkGos0p1P/8txQMhqtmipB4xJlev8gxsqjJtZvqt75RPzZXowozH?=
 =?us-ascii?Q?YWEBEGFafxMLuOiiaHPjKMl0z4Khq+ckwQkpPFtTf353WZ5ioe7/2xSlCtUa?=
 =?us-ascii?Q?Df7jsC82R+EDFkkd6anWWaQCFBZtAyHHuL6+lOcToDT/f/Nzh3YNV3gLB8Xr?=
 =?us-ascii?Q?HiuDGIBDpB3gywOL7WKvQHNeAxCQ3Z/gOU3pFs47UPYSj9AWmEPbBxuREDG5?=
 =?us-ascii?Q?l2Z+wcgdGWJ56EM7p3gh4NK8wor69OyMqIc08B9JPoU/q038o4noWptaVmhX?=
 =?us-ascii?Q?Ft8/vuaKLf9XuEg0QvV79B97eTIUhqlsWEnnfJyox6SroN8SvgLDw8Gug1uN?=
 =?us-ascii?Q?1HJw3GDQAsoJKL2twU6Vntp9B9ky3W3mVZB9yeadlvQE1TzuMQl3M+I95uqa?=
 =?us-ascii?Q?1+pHxqfwFd8tt5NTxLQKsTnr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3087f1c7-124f-4e3f-c2c7-08d92216b4fc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 20:25:17.2028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIswywOdcfme80uEf+CCFlD0uXGCtblHN9S7EeLdSY+pavfzG6PTBGwzQ7jYWSSt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021 at 10:24:56AM +0800, Jason Wang wrote:
> > IOASID nesting can be implemented in two ways: hardware nesting and
> > software nesting. With hardware support the child and parent I/O page
> > tables are walked consecutively by the IOMMU to form a nested translation.
> > When it's implemented in software, the ioasid driver
> 
> Need to explain what did "ioasid driver" mean.

I think it means "drivers/iommu"

> And if yes, does it allow the device for software specific implementation:
> 
> 1) swiotlb or

I think it is necessary to have a 'software page table' which is
required to do all the mdevs we have today.

> 2) device specific IOASID implementation

"drivers/iommu" is pluggable, so I guess it can exist? I've never seen
it done before though

If we'd want this to drive an on-device translation table is an
interesting question. I don't have an answer

> > I/O page tables routed through PASID are installed in a per-RID PASID
> > table structure.
> 
> I'm not sure this is true for all archs.

It must be true. For security reasons access to a PASID must be
limited by RID.

RID_A assigned to guest A should not be able to access a PASID being
used by RID_B in guest B. Only a per-RID restriction can accomplish
this.

> I would like to know the reason for such indirection.
> 
> It looks to me the ioasid fd is sufficient for performing any operations.
> 
> Such allocation only work if as ioas fd can have multiple ioasid which seems
> not the case you describe here.

It is the case, read the examples section. One had 3 interrelated
IOASID objects inside the same FD.
 
> > 5.3. IOASID nesting (software)
> > +++++++++++++++++++++++++
> > 
> > Same usage scenario as 5.2, with software-based IOASID nesting
> > available. In this mode it is the kernel instead of user to create the
> > shadow mapping.
> > 
> > The flow before guest boots is same as 5.2, except one point. Because
> > giova_ioasid is nested on gpa_ioasid, locked accounting is only
> > conducted for gpa_ioasid. So it's not necessary to pre-register virtual
> > memory.
> > 
> > To save space we only list the steps after boots (i.e. both dev1/dev2
> > have been attached to gpa_ioasid before guest boots):
> > 
> > 	/* After boots */
> > 	/* Make GIOVA space nested on GPA space */
> > 	giova_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> > 
> > 	/* Attach dev2 to the new address space (child)
> > 	  * Note dev2 is still attached to gpa_ioasid (parent)
> > 	  */
> > 	at_data = { .ioasid = giova_ioasid};
> > 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 
> For vDPA, we need something similar. And in the future, vDPA may allow
> multiple ioasid to be attached to a single device. It should work with the
> current design.

What do you imagine multiple IOASID's being used for in VDPA?

Jason
