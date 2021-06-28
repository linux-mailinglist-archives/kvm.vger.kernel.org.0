Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9D3B6280
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 16:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhF1OsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 10:48:08 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:32929
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234536AbhF1Oni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 10:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ay9rXKpyh5fG56LkyiUVzCvqT39QQlBMTuTHV45wI7jtH8jfQd6hZBVFq09EERxyfQQbzbrynQbGRo/1R4BwzT0SH3qYIGxPenn8boA6LOHDrqAVY+jAG8jnDRzef4aZlp3to5+qoFx+YnbiLPGWKKvBEmPafN6fODZOX2knlMvsji0EswPEI+hVnqMqGzzddxzejUb0uhh0Obq1EdirL5gQxAhc21BJ4YQVa4tPb3r9PuYEKUYBWcVnGJW8f7lAyoCS6T1XXD8PlJM0DBBoXdKcn1xEHANh3DgzzygsIl40wo55Z1F+raEgwpx6mQ9beAHMeEu0hTUy6BTv3PO9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h+Zjtve4P3scgOfIw/418Rdb7R5UdWO7K+mRjA+R8Q=;
 b=ncG8GynfTS+yNf47+oiUmikAv16PH8F7ZS4tQ6RLpbb01AtcRqAo3wDpK3A4CWIZX7Zx8wZ16XWd4zGHZUnv/jW+OqhMwtaDIGLsNW96LU3c8i/Qe1GVHzPLGEelO3P8fN8wFe/yu5KksHhEoZDuc4Dfb/X84wIWPYEcCPXsGkp9k7UoZ0cDZbx/FV/N4h9VOjnD+XnpU3wzmM3/qBKRyCec2YHpLxpUztYqYOQLFwY7fKzTx1JSetf5uRUKlARYna1KhLgh5Vvj0mnt/1oeNwp5NAN4J2Zadc+PbttEIPk4MzGz2zZqGa8tPQxRmdcjw5cTw2rZ+w7cScvr3xBgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h+Zjtve4P3scgOfIw/418Rdb7R5UdWO7K+mRjA+R8Q=;
 b=WXg9cV29eS4TW/NU6jOD2VOQ+4snHnHude4pW4V2k5LWU0m7nmpyQiCG7X4STAZR8vZK9vtgsLfHULx5/qX8EysSufhj2zfdWSzmU0e8NuOKCeunh69vcdpWEm8BCSgXTsbrpwWflYqe+1G8NIw7JRDLmyKrjTQ4jvujTL1g4QDUzsBjX23FZmPe+aC6ihuDjB8+/Hajar35Q8ThIGcUv4NFnlaO6oP+dKYSVaklOjVOhgatHHU84JSuFyBs0o+aAf/t+TiM68qgsui5HL9yejkShz0gqbhQuyq3GXl/0kWsvdhDRUzAa4HU7NBMC0RyUgp60pTbKHf9NqtDFS+sow==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 14:41:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 14:41:10 +0000
Date:   Mon, 28 Jun 2021 11:41:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210628144109.GC4459@nvidia.com>
References: <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
 <BN9PR11MB5433DCBE6DE1EC27CFB9D3738C039@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433DCBE6DE1EC27CFB9D3738C039@BN9PR11MB5433.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:208:19b::47) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR19CA0070.namprd19.prod.outlook.com (2603:10b6:208:19b::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 14:41:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lxsRh-000dW5-90; Mon, 28 Jun 2021 11:41:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0296a37-8e39-4a7d-4c69-08d93a42c569
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336F34748A19B1573958B9FC2039@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGBVpiu49HrsFf+gv4cB6hEkvGw5WZuZQXfgflE6UJX0gUmnij/+gNE8E7wXO4vUBWg8KG7sgxqViSQqKZN5PDHHQtFGxE3rcTdQQOLRF1ruXalGOyeYKmgIaz0XWEZ51OOFF1Sd7fXP8BuZ4ZOE4xgr8mYIhJ2t2JDojKhEGu2X8nx/hg80PL5q2EV3YTysPFEyw7jcAQpszxLX+3O5iPcoO+Mt0Byp/njSiI9nl75JPjUzcHKBYwMvdJ3/78RaJd+hYNWOMO8G4uTpdY14VRcqfOMrJA0fajEfbpzHGRB01peHddlOIBEbGg1KGqyaahlqAJ7TOQHSrYlY6eIsD678r5p0CEC7QFhUk7KwMX4ZM6km8Gw9alPoULCX1Zc0FBlvHTa8ShzsfXVyTFVTO5PcktCqO6TBkg+/JMcxm5UCEDK/lA/0ZgmxcmI+qpebEcXWI+UYZMHN5l07MbFGTrSY0Xx2nzbYVGADM6IqEEqmBvF/XrKYvrUCBvZ7rhqcFXUSAXjijRoHNe5kbC6HXpu4VHqQBu1e4izqFasT5pAgGk5Q3nbjTCg6BrYipchhXcsY44JG98zfbfT0bM+q23fZtD844aPYuweY8AGjndiVuI2GoGTaXDaJh68lflVXAxv5Si3WtVVkB/+I0UWZrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(83380400001)(5660300002)(186003)(9786002)(2616005)(1076003)(9746002)(426003)(2906002)(4326008)(36756003)(38100700002)(26005)(54906003)(66946007)(316002)(86362001)(7416002)(8676002)(6916009)(66476007)(66556008)(8936002)(33656002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVlADGL1oJfH3h4c28VN+ex4dmbMMpcRMWXz/r8rwjNh/6/fXClgIAVPGZPv?=
 =?us-ascii?Q?LXFA4/Mjp3GGIthZxig8WDANkTl86GPoKhjbL3X/qAJ7NEmQW4oWwovSNrAf?=
 =?us-ascii?Q?+8gE+yT49+ZN/1I6XNtbcSCefDB6vko691FOHb1a27PojF/6xiCN4ooQKUiu?=
 =?us-ascii?Q?oMqevQPJiYxRTr7O+Z0ixiKgpTdzjMTJLXq0TkqMIev0REev8Xe8ucGGjdxx?=
 =?us-ascii?Q?KdTGlBrDz7jW/L8Vx6me5lKa7CqCdgqCr5RHBgaY/mOsuLPpv/pdZg2bvCYO?=
 =?us-ascii?Q?aBLLfDbOKqCPuqXNv64zpbuYB2fQNFO4koDlYuW8WQbCVh0j9eyZRG4LL2PX?=
 =?us-ascii?Q?QcyrNfa+FyjVd0rkHLNwv+re0+tICx9h7kEPTUpQ42OY6BdJzhM68tlMC0nd?=
 =?us-ascii?Q?bJOxy+lEOj46vp64cdcWfzmZvqsGCYLnk+RC4aacIfEpO8AVG6nKBy1rsb98?=
 =?us-ascii?Q?REH1NnhicEzoKCd/RawMffmHtrZHSiGI5dMdxVOYvkVV+ylge02yuESYjntK?=
 =?us-ascii?Q?56ggLL3OcU8lg1UlLfzXq5yutjnoIfcgwmVxGZ6OQcmFhXNVg1fBaTpU2m7G?=
 =?us-ascii?Q?7H2e43zy1BlrVFaRc7uq4Ldo8WPb5B5oGJUIGokYq8U01qHf3dlHiNGVzt1z?=
 =?us-ascii?Q?zjzcPiU9NnMccEvxkZKTRn9rY16/vwdP7J9maV7DL0fA5R4PMKZhHCngBNw/?=
 =?us-ascii?Q?W73w+4WBEBd8M/phRmSXM0tDbsG5iz7Xvt1OM9adtk99in3mCxV6fB3MRELH?=
 =?us-ascii?Q?GqrTHXdJgJ68d0cQs4DL5uKNb5zSUcUkY74wVpfnO43Vvj9MXyjP7IHpkt5e?=
 =?us-ascii?Q?cOi0mgRwuIzIOLST85ThqgJc92E6WAeOboj6A1WF1IFtgDQjTCc1iElocxWx?=
 =?us-ascii?Q?+cgDlL9VLjU+unvm28lcMiMzrDpUuk7a7R2jUlqwKnklZRlZw/5wlHcYpd+i?=
 =?us-ascii?Q?etnHOce+Kh6PX9lGSvus7/DJnUcptEVg5B8oUt4dKQHrV0HPKkpBgYlEcZcr?=
 =?us-ascii?Q?Iev5aRPy1TeTtFvnEdRTsidQMCuvOko0uVkP982pU0U9jDOkh3KoLorWFhj2?=
 =?us-ascii?Q?9fR6+IbJAk1fWQc0bvSzSB+OTnT+jkWP3jDz4d5BTll2/nHXMebF8O0+PiX0?=
 =?us-ascii?Q?neX8RSSP7poVKMbcQcPXKaum38IZp2AlMHOdHwpLIu/VebnmGsjTqdUUMfxU?=
 =?us-ascii?Q?pTr1zDmHDD4NF5Ag9s4Pp3GUwXTAjcIK0HuSfrhokxiHcXlGH91lbitAtCWy?=
 =?us-ascii?Q?2IOI0m4B9jtnCIafx+dHO/HHx15aBkITnJ7BJ+ZxRGeLLzvp+jL0zaCJbkkP?=
 =?us-ascii?Q?tIE9G/wosj5foogtf7hL2Kms?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0296a37-8e39-4a7d-4c69-08d93a42c569
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 14:41:10.6579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHJv8vOAb2gRNsBUmqjfLH6f0svrK1mILGs7hveGXxTN9LemaMqBNn+7IjjuXTBP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 02:03:56AM +0000, Tian, Kevin wrote:

> Combining with the last paragraph above, are you actually suggesting 
> that 1:1 group (including mdev) should use a new device-centric vfio 
> uAPI (without group fd) while existing group-centric vfio uAPI is only 
> kept for 1:N group (with slight semantics change in my sketch to match 
> device-centric iommu fd API)?

Yes, this is one approach

Using a VFIO_GROUP_GET_DEVICE_FD_NEW on the group FD is another
option, but locks us into having the group FD.

Which is better possibly depends on some details when going through
the code transformation, though I prefer not to design assuming the
group FD must exist.

> (not via an indirect group ioctl). Then it implies that we may have to allow 
> the user open a device before it is put into a security context, thus the 
> safe guard may have to be enabled on mmap() for 1:1 group. This is a
> different sequence from the existing group-centric model.

Yes, but I think this is fairly minor, it would just start with a
dummy fops and move to operational fops once things are setup enough.

Jason
