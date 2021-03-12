Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6276338F47
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhCLN66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:58:58 -0500
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:5472
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbhCLN6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 08:58:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tnt4kRXDHJn0P6JG5lPHL05MTULay8ZFBopLqUoEnHT0xHsqi2qvTu6g8zWU842chfPumXGSRzwCq02RQmxmA/KP06FrNWOZ5AW3U6t8etmIwAMSJ5g+p7Sdk68nvImjVZBfRsLtCOE5smnuAkW2sJUdFCgvy8ULtDKy8dxPg3BbdKTLkmOsTTjhAd4VoLibsWSB4L+k3Yrq/3CGNDksv5xOanrbvZUi+pQv7JR87NzArMqqCv7mNmlQjJpDmw3KZvpMpR9p445SoIvnmaZjANrrhHfDDlGEaDZw4wOCDZwv9puCeis0epWm5Lr9suzOFMI2BxlY7VDrH/EDzM6XyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpDyxKMtFRIGVeJ5Dbi3vyryNl23IFksnRJM8e8vZvE=;
 b=Thm017O56y5Ug24iAC2Fo6GNFZs33tFAf1dyv3XpML2ro0tRbH2Jd6NJV/WH+GEQ8p8x6WrMX0bSXFaQqi3uEvCizUA5X55DWVXMftJhFQK577slZ07MGFOtoOsos4mE69ihGqrLAE04juTAF8Y7uT2a51fAPWn3nVx4uPnjxHxXlhJ0Hfdomjn7T5vUOdk3eoAj3CeEr8yeaGakKsh5VoyikIYg/MlFeMlvqFxTfClOAXAPinFLve5jiL/7JlTyuS/pS9FNwr1OxdiGx/ifjnwrGQNAJd6qgXAkJoL3jufalWA+1uH8PKV0RdsYZFPy7tKfHBc06haIGe6wKe0h/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpDyxKMtFRIGVeJ5Dbi3vyryNl23IFksnRJM8e8vZvE=;
 b=VcflZDvKqRf18fGTqLQE6YGTo/v+wZTzn6/bp5aOGzR1g4EstAwqKFIl0O40QJY4ur75on2w7Nhjz9nvPBqq//eIC5fOtyZf8FRbH5u5ri1M8cEXXuxUy2bvWeV71W6EZBpueqSwfsNWbvHwKzxc25e60JqvTk37vPifhjUJ9RUT1hxGfLy1iOfbDa7YO4kvtxVuTcjF1AMuuXsd93s1eDQhli04KlR4+E5mtxjuWlYG42eN0/ypDLkTmDCP8PrinRFzb2Ye0f366D0RKLBnkLdXZxwYFJ1nHI1/pjpx8YSf1uzZOvRbx23lR2HTOzxhFk8xqMzxaBljS/0SNsfkxw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3595.namprd12.prod.outlook.com (2603:10b6:5:118::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 13:58:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 13:58:51 +0000
Date:   Fri, 12 Mar 2021 09:58:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 05/10] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210312135849.GW2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <BN6PR11MB4068CC82B20352BF15A9C75EC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068CC82B20352BF15A9C75EC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0225.namprd13.prod.outlook.com (2603:10b6:208:2bf::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Fri, 12 Mar 2021 13:58:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKiJV-00Bupe-8M; Fri, 12 Mar 2021 09:58:49 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f83f1e2a-9795-47b0-111d-08d8e55ef72d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3595:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3595742D3F9BFF7386C2A162C26F9@DM6PR12MB3595.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quSFZ/zcSAL3h9elUId+s8DadhiBNJi7ZxevTlYqGUAgr45+DypQU1yv/g08q0QeiO2SR72om/CH73+Q9JITvDldzL2X137oL02UJrjXAXVpdTIFBekQTnfr7QAjQgumSwk7LpjpiM2FtEyb2pVMpDRF0UYr4ST+vd5ZLk8UeQSM7u/d3+RKok1lVc8LFSPIBM0fHYIma+m8kaLec3vaK+VjZLCj9VAz716+K1m7KllxMhb1YMT/Urmhm0zfpPVJN9SdCFSl2A+6+HqE3mi2C/Sjp8IHXspD1YJH24GAByyCjZwwYZPBis8MQ2TTmifi7D65bRQkt6EUgW/a3KNKnQn3/dGEIFmzd70w5Tm7YFFyfn0aN8lo+yeZLDpiXaWpCeiMiyi8xBZ/1HVQc/cPNpA7HVZtT6D5w+P4HvnexmVKOMX3y03GeY9PfsyxyYpixxTLYZELHd8/nrCFL/bCBTMY097D7Fj9m9i380dTjWUs7Ox+AcW7RirEq9VNS21gNHZK06xEZmuNzJrqUbKRYY4PImA59jkhiWmPXN3cwFhueSnaybE6VW2piYGhPV/s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(316002)(8936002)(66476007)(9746002)(36756003)(426003)(4326008)(54906003)(478600001)(9786002)(66556008)(86362001)(8676002)(1076003)(107886003)(5660300002)(33656002)(4744005)(66946007)(2616005)(2906002)(186003)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+IxQy4BegX9dCA4OLfp7iv+FQYgVuwgQmFZJDzTAiuq6wTju1f6J2CsS5/H9?=
 =?us-ascii?Q?fjrhlrNAVFVLJXkQXD62liq30VbxtQ+uDq7ggdBOzQOxXO1EUGR8tiiCKJAe?=
 =?us-ascii?Q?4dHSlPJYnchmI8/p/NVeh+40CFao18Ems6ZsLHtIIpwfVisLplbubDjEnSeE?=
 =?us-ascii?Q?r3UxrFBhr8FyO0Aujee4IjS1gGJbObsfL5JUbBFgtfIOhAeymAtY3sUn0PId?=
 =?us-ascii?Q?rT6NdYnh2flyTo3QxegGi6nl9vEamtxgWaV18y4pkSUy5PX0P1sLRVWvifbu?=
 =?us-ascii?Q?HJ/CoJzJwcQqFrlPKhSxiJSnlP1xKoXtsJ0o3lwZAVgC7kDOULuhP9AuJYtI?=
 =?us-ascii?Q?r8l33laqIfKOrNnPr6Zxx8/pA/3mZd/yJeJQQ2teLUI0hiQHLwQODuhTb+8n?=
 =?us-ascii?Q?j3ddEb+bgth/DARobP6Kmkc9yI/RNJ39Nv/j1Ji2xA9LbA4TVDCjgfysWvOM?=
 =?us-ascii?Q?3HM3R3XyzfZl6rUYFWTHYyKt+Z4ZVDg8eeC9JD8azeEbm4bWBNtsZK66Rj5s?=
 =?us-ascii?Q?66z2au5/h06QIiqOMVQPnnNxYTUBhAnLWBHmC6/oy3UVvyqZq7ZotAzbr7nh?=
 =?us-ascii?Q?Q8zuyA23WeBxI2UHDQgHsaWdfpj35zLYbn7avMDNab+sc7ggaTNCaJJrVYXn?=
 =?us-ascii?Q?1+fQqW2H8gUDSSXg+WGYQFQ72fYH/S4YwwDgQTabXshvolP8ne80nPKi6Fdj?=
 =?us-ascii?Q?0C8pgHq25vS96rISDfP1IdgoAwX1NuZpnM3DZkuqfsB+3UMuwL9A8OnaffcX?=
 =?us-ascii?Q?3zywwuKq09JOLteKKdS0PBoye6ATSv1xTu8gwq9RabvUiBLXzR8A/IcAwWFD?=
 =?us-ascii?Q?P4bgGnah6nRvFYXs3NgkuxDZ75ZLkCcKKrK8ErdsXEBAGLrdAJ/tPxjC28wP?=
 =?us-ascii?Q?QZFqGCkbf5vLTgfR4vbAw8g89srNSUHNTXP6thPR3e91FVpSA20lWI/qsz+3?=
 =?us-ascii?Q?ktnrzXjWdBi4l8lE3/bYioeqkciwaVKMc44kO9xMvfWkbu6BbJVyS1A2s0qj?=
 =?us-ascii?Q?FNk+xsStCOm5nQZ1ZmczDXO5o5V24VJArAyaWutsLbuJYnK0l3aIKQZ8D7/s?=
 =?us-ascii?Q?FUgOipV8LWsiNp1BuycsVkXKvFmerVVJI9DSQ4dqv4qyU/FpJOYcCx3MsFlm?=
 =?us-ascii?Q?fUUJB8DJhT88iIYDmgfGr45PmyvPV79sfgDWaT3B0YxelsneGcfcNYCFY91T?=
 =?us-ascii?Q?qRuldTqwt8yjFfgDS3ye9jhvwqUP0TIeTsDx0uplT7S+ix0ZW600zFI0kGcq?=
 =?us-ascii?Q?o25fYyFm+DC/dO9nS9hTf0AB6G7Tmde4paL1STW8t2PLP2MxsFYqDmGg90lN?=
 =?us-ascii?Q?NNPICp1QzDtQrG4f47jHnmVlBZoNvZRjw/09K94qqaJFqw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f83f1e2a-9795-47b0-111d-08d8e55ef72d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 13:58:51.1546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdCCqrPPxeyovdnhC4LyZ4qDEitwl3m+Xyq34j2ZgFa8Sp2+0cSC2GK5nyEaB5u3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3595
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 12:53:18PM +0000, Liu, Yi L wrote:

> But I have a question on the FIXME comment here. I checked the code below.
> Even after vfio_register_group_dev(), userspace is not able to get DEVICE_FD
> until the group has been added to a container. 

The race here is between VFIO_GROUP_GET_DEVICE_FD and bind

Userspace would have already done VFIO_GROUP_SET_CONTAINER before it
does the VFIO_GROUP_GET_DEVICE_FD.

Jason
