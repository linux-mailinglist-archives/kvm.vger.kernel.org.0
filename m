Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BF033E1ED
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCPXMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:12:40 -0400
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:12416
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229492AbhCPXMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:12:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EC9SRjt+hW17aaR4zlaHiRhyYIex93cP67aM8gd0h0qoWF/P1RU4/0W+1Zr3YBlMfB/FNstaQMBvGORd34YyF1tnl+mthaMlvm/s1faPSUPeODZdQfutc1KnFTXnEjNtnujmCUzKGr00+yxVmIR7wXQlA2mC9dQJKkKhKRwBPWSXAvqrKiRH6VTLbhVsSKSpKnNlSP9x5XAZdrYHYYJscO6/Z1coypetvrQS47G05pVooK2oR3UnCTZi2CI5ZqBH/RfMuSjHhMGNfMhIt2ZZDsJ6xnZgER/7krVb+RRFaObpi+Z7ZpcoOtGEu+C54jdVQyIneXcsXVmbeam1pBp2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8MyGkeIL4/coUaHf0U70P5SavhxV961EpAvMVpiNiQ=;
 b=H2MpeeYNPEBO/eHfrGJyKZM3OjKmqdU3q0ltTEi3ZlSxTxBzh4uHOY1/wn7hSggzy0JxIhncHZZ7awmpDFLYvSZPVsKvX3M9e0679+gb56KbX9zTLuLpQtcGEEeF4SebCHqdFOe3OdUwGAWw70F2KoVUwBcS2uC7NbDm+0jMoJS6avBlsTItBU5NTzE9UCPUzUPkzTUtIARGZffWKhqSZsYOxSIc9HUHha1Q9CWVtKK4+3oK7ObPpecl/jCWXbyZ5y85MwX++TTIA9sZZljQXCsTNauoKSSc5BreUlFTdKocxIE1+3pRuGWpDSvrkFtKxi/SeVH3wpYB/PsPQOhMCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8MyGkeIL4/coUaHf0U70P5SavhxV961EpAvMVpiNiQ=;
 b=IZu43NX3Me3wAOVY9fSk8HCWIa+k/1fsHutJOzGSw0kEmkOgWTpT6t4/BXCIpTMePnvfRjJfx5AwN//mrhBlwuOdUPZsd5VQxfh13Bsu7fqPOOZ37k0lQ4U58Osv3Qb7sNi+5nXuUO97jdqNo1/zMgEPUhXbEryaehQXA+cs9q/KnubatIyM2VhNaGEHwGkPkR5VkpK6MUdpmEW/vNuPngpGQoBxzjE6Y9OeYwl0MhQ21ZwN5DdBZrMomEXjkAIajIwhYeqFJHtDdgPSsp7MaryfkG+BVKPaJw8Vzcvfi0kJRGwgTPUssBefioi0nsG2XO/5oLEEj3Kj0lXr7hLP7g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3115.namprd12.prod.outlook.com (2603:10b6:5:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 23:12:35 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:12:35 +0000
Date:   Tue, 16 Mar 2021 20:12:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Message-ID: <20210316231233.GD3799225@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <20210316132559.6e6bc79a.cohuck@redhat.com>
 <20210316151306.3829ef82@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316151306.3829ef82@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:91::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0009.namprd05.prod.outlook.com (2603:10b6:208:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Tue, 16 Mar 2021 23:12:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMIrZ-00FwqI-Fh; Tue, 16 Mar 2021 20:12:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0506b3b0-7c71-4e27-ba66-08d8e8d0fbd3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB311544F39257962FD446712AC26B9@DM6PR12MB3115.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qj4K/kWMn33hhgCmkXdOmhopyusiWl277O7oznME73cYxA9vteFY+E6gMp+jJ0Nm7LJfrSv35For52AE0q7InnrX8nbiJJiOVHfYcO5PKHRd5agVulHMYXN91WJW/UU966OeEW9g6srbR4wx7J+xWkeS/LpH+Gem4Zn2ZP2rUc+4IuiUqlSHoXC9vbLXL4o0coYr9D36XPqB2Y2TRl5c8YmP8qkzPQxfYmBTWBYTtfR6oCTkY9mA/TORkKA7uGO6hqU8jb/q418LxbrO3ha4fXZCqvEG6EbvkaFI2x41nddWloQiMJWHZPBfczj9ZV0h8TqnYot45DRn+VmCakRs5OMUS2D3ASTMPVRs0hoFAu6M9WeEDfyAj4XgAok3cNzUEz6dJr4Hi69wqMIPybq4LoGmOePxzH9aPmiAksU95KaHfzFFB+7ocOGtNXupSnanVC64cx0nOeWHuTaaD1+qjAOohCh1uT+sk8VM61yY7dBSTCwO8cv2POQoMib0M7THwfH7A8sDclUUTp1+dv4iiK9Mptmfl1gA7aiLxQ0OPtS5QcVRSCg+F6SqXNYFd0W+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(186003)(86362001)(6916009)(9746002)(2616005)(5660300002)(4326008)(8936002)(66946007)(7416002)(33656002)(66556008)(26005)(2906002)(426003)(8676002)(1076003)(478600001)(9786002)(316002)(66476007)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?27qGJ3YUirVQPU3O7H/jqC25PLvSYyYygal78cuGFy5rCJW32+u4WNnKbRUi?=
 =?us-ascii?Q?0m3Y3RHSnZpP5/f5i2DSi4FxkkkI/JL/l/rE/KMreVq09vn6x2nOCj1A66rr?=
 =?us-ascii?Q?iKW2sIaV+h8JhTPUdzRm5X7tlw+xU8i6vB8ga7z9h7GblKQMK9giZocHu9a3?=
 =?us-ascii?Q?DzZO3oPy5ZKdMUVyWZ2yUlJAILrdSAlaN/YxFsNbnfbpoJR1v/9u/W8rOeGd?=
 =?us-ascii?Q?D9djZRYjht3RE9SPWck7sJyQkDocsPesgIgXhKQzFmhtiims9tBmvG1RXE3L?=
 =?us-ascii?Q?VcsNmjTlphivX2T0xBJyqwJc63sVfsm83yK5XKH7bpBkSS/v39zMWHV5thcA?=
 =?us-ascii?Q?DPH4L1k2AD8KmcmgHgTRbuUIda7eWHEDpzgyaeQAR6sBRq5WHddRCmD09o3U?=
 =?us-ascii?Q?7Uax3nHPdFHB2ovGY9ru+FNhBafh/kK9Zujt34fhVeGslxZPbbN0wByyQG32?=
 =?us-ascii?Q?l9xUiHgSZrG8f4AboHrX7WlXDvNYFxNUj40V2D0pPDUfbGuDIJj+fgJNkIuk?=
 =?us-ascii?Q?mzMhPDU8PwsrHDtAecaACNH0Gf5UvkYxPAj6NsFVw9OxTYYckfAG3pa+suKP?=
 =?us-ascii?Q?3DxSfpqyD/1zkETj/svQSkz8EjlX70YynAVks5YjG1qHAVcrOJ3dy30P7LqL?=
 =?us-ascii?Q?w2qKDHzJtwc41JegRpHfO6Oe0Wi3YLv0If3BCjQ+6JoIpdRiWle0+mpJRb87?=
 =?us-ascii?Q?+hZ8Jvg3oi8hmgcoMUiILaGmqGSIZS4Z4AJ2oHf327ZLEt93LW3HuaPLQHYn?=
 =?us-ascii?Q?BVRqmU4J11AebmFatJqafESaSB3mLATCPFFWbT0Tm21ua8E2HfhxHHPe/JFc?=
 =?us-ascii?Q?ls8Z3YVJqRv69orvTJB6eY8rpdwZhwLHWDUYOdXnY8ppRVk+mS0aSr8WD23Z?=
 =?us-ascii?Q?RoiMQMY2zNo2IegYEoozsnHb8xghnpHqMb6awpFGUe/LOghvmkS7cGwjGXOa?=
 =?us-ascii?Q?kKX2C+q7+Xh5x9E44q9HBMX0qbIfXNsst2D5v3GOhMrexjnqTUySgO3Yvufa?=
 =?us-ascii?Q?6a7N7UrS8h42D9qzwCHGTiv7lYXbfslZ84/ug2n3sSdgOPpDOQDk1wAp08r+?=
 =?us-ascii?Q?/2W4FlyXkZgQtPdpMgS2nLh5kdsw2cVZKwfFkHkbqPudBdF0rNkPxHaKgr4m?=
 =?us-ascii?Q?9ub7Mqno4653Gu/bwFJ9bkAA0QGXcpzAUGg2/QqD8bwTOYgQviamm0bzFrqX?=
 =?us-ascii?Q?Ms/yqT5Gf76E7DNfIMxkKdAEOwl5gDe4DnkdzCIVwzm2GQP70mUmWg6CtRQL?=
 =?us-ascii?Q?nVUstvKyGPozah0Sz8ZtiGct/QjZNbjoz2ZS6npUNq84VAlhn8iTw6ppQn+p?=
 =?us-ascii?Q?NM8i/hOA2nf63GEpg//dJBPow4Zz3oxfbCiUKR6Et+E/5A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0506b3b0-7c71-4e27-ba66-08d8e8d0fbd3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:12:35.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGOipJjh0ZUdp9nxCxRSGhYAA6bBrEse2v3K29UL1S0RaObinIVWvtGFtPSf8V2u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:13:06PM -0600, Alex Williamson wrote:

> > > +	void vfio_init_group_dev(struct vfio_device *device,
> > > +				struct device *dev,
> > > +				const struct vfio_device_ops *ops,
> > > +				void *device_data);
> > > +	int vfio_register_group_dev(struct vfio_device *device);
> > > +	void vfio_unregister_group_dev(struct vfio_device *device);
> > > +
> > > +The driver should embed the vfio_device in its own structure and call
> > > +vfio_init_group_dev() to pre-configure it before going to registration.  
> > 
> > s/it/that structure/ (I guess?)
> 
> Seems less clear actually, is the object of "that structure" the
> "vfio_device" or "its own structure".  Phrasing somewhat suggests the
> latter.  s/it/the vfio_device structure/ seems excessively verbose.  I
> think "it" is probably sufficient here.  Thanks,

Right, it says directly above that vfio_init_group_dev() accepts a
vfio_device so I doubt anyone will be confused for long on what "it"
refers to.

I got the other language fixes thanks

Jason
