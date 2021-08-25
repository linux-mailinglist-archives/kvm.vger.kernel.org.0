Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4523F7E5A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhHYWWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:22:30 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:7777
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbhHYWWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:22:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWs3GpJwNM4extfPYKOPH5YxW2CLPZoDG1t6+UuNqOqtp/EyjBsBHVlj5ZnAMLbOuS8YF7Y0t5mjCOWa+81y4dmuMVw/a6FBRzbK8i6LvANdlsti7GdG+GISZ9tO/Ca+LjK2YHKFJDM2MQhgg7OyJ24iexwkvjeo2Ro7X7WtmLH+jWzkDR1QQcpyNXXEG6DFiYkLsvMEm9RtgF7XFJap6Kvfdd50QdMD7lVBCXKVy1K/MJnOTVQhmejpbFUHivJb++Y3rKijIfc4vT+LOxZ/dBJgHni/liNeTweOBTAVGECb4t/WxS0ZnbxEXUg2EyXRXdr+GanlrgDI/h48NCTTFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LDP+dhM7yh+5WMLOBpPTqCZWhA4v6LKyz09OSFNqWA=;
 b=B92pIW4hQCehxNKg9BnoRN8iQYvaxotV2SNw0GXt6Em3wqbEGmUl2gkPjmMKwaXKfUf7YYtNeqLz3OUDZYMz4b1vmNlh6S8fvzc7ZPYVaPi+n9/zrRsTTYW7OUFv+6Mq/yh6OLp5jtdh4sc8dPSK4107iZ+Xvf8AjXCXoNKGFzpkuAotxOGi7vkrL3DRnRfQAJJdDfGyIvvz66LgYyU7zLy5ZXv+g/jP4oY9pfLrgt4QP6wfjVaHEGQ5Xholw8fxDRnSFeIj4oIFc4ru40FcGarR1F9wkBWeRGnZw+cgUoIurV1pyEE01BDLD6QRNyL7exYK4CzlU4cxp+elDxYpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LDP+dhM7yh+5WMLOBpPTqCZWhA4v6LKyz09OSFNqWA=;
 b=dIqscLn9KFkV669vNDp5xoiGdiTEaGrkZKxFTXTad4ZEC8jT7teXYmxUi1l/93ZR85A1BXcl59B2kZoXbjV50JD1cizx+JCB9Kx1AACrgSdgyLim9hpAkQTzLFUzzf2401FZ6W7GSXQBDuhgIGUo2yXXhfSW/aJUnvlv23mtECk62VuWIUiXAopzvv6x74sODgQax9rUdKO7xeZ2HDcOJ2ZlWC+VTtq58OolpaRHO5oh5jQOYzimeHkaJvQZH5aHNxne0J+BGK2uEy3BetfK3UsdnMXNUWd1PXgkTl/o41yHUhn3fiyqb1qoQM/RV4s8DezrRtsy6XGgcFwTifiyKg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 22:21:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 22:21:37 +0000
Date:   Wed, 25 Aug 2021 19:21:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use vfio_register_group_dev()
Message-ID: <20210825222136.GM1721383@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
 <20210824143001.37d01a77.alex.williamson@redhat.com>
 <20210825004226.GC1721383@nvidia.com>
 <20210825141341.59b0efb4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825141341.59b0efb4.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0273.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0273.namprd13.prod.outlook.com (2603:10b6:208:2bc::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.9 via Frontend Transport; Wed, 25 Aug 2021 22:21:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mJ1H6-0057G5-2h; Wed, 25 Aug 2021 19:21:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0049721-4b7d-4505-5f9c-08d96816b40c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5205A3C3CA4CBB160C2E0C69C2C69@BL1PR12MB5205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sOjk9yKuw8qKZQK+IS7vtIzvKsQ5dVyYfnTWEPZnZJLnEvWhXP+kMIryF0p7B9tWfd3SaxBEF84rKV6PEe++J+qtLhyEs/GS7VeSvKTXGQ/mTyeqjQ6CExxgGds82pCydwwmfIGNzqRqD0GKjgMNt9Gxaa3K+Kyi1nA2anKzlgji6iqN0wNms3sET1M/9FGyIXZAbsmNZsZHOeUc5ZKYCPfLaSkDFTtPb0NZWRdB5ak3C+ZSxhS7vhkbrucH841MJ2yaLx+nrfhTwQ/EFX7qypj6khRNdp6wA64JDZh3dEPVcgjBs4ikWFK8FT915gMhTR8D1uuFlAt1q62SRUjmVIorF0bJgfw7u3isdvmEfu3KagQEUUe/0314rxdJmArafCUYWCn24sviC1gSJ/WcbIlR3AaQNO0HMIj9XE7aSEtx+puyCPV2hVCxFizshslejOGfsYJ96LZ2a8rvD6Z3e9wT4VJBHqN2623GNr7mYk29Y3tpv+sfW4kXGc4ZhnEVYN3k5/cYQIqDQ6PelnGDqQHphnGiJYI1Jqzc/wmMEiRt7ZK6hW5y7qh/qrjac2zi0mdUpiZVCi3IHhbY5me8+vQkTN5dRTyIcMmd7ZFLREw870b1NHVALNuawKkG4MXTJ8cMlBbqtPzwbdphpOJJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(38100700002)(36756003)(186003)(33656002)(8936002)(426003)(26005)(1076003)(9746002)(66556008)(8676002)(66476007)(9786002)(66946007)(54906003)(5660300002)(7416002)(2616005)(86362001)(2906002)(83380400001)(6916009)(316002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4GzFVf3GlGEZmmyiknhQiSDM3QNsn/gTmDAjjWpQCJWNDMrVCy/SByNEF0y?=
 =?us-ascii?Q?ous4zC4OwuivS0ayVwvlMA0INBXkM2fz031fY22YxsyLmwf4Bt9AsNq4zaVy?=
 =?us-ascii?Q?DQxllUm9bQz566JDbSfBLohc5qaLA3dLqXoYS9CHiMh+SSBblzphaNSXAYPV?=
 =?us-ascii?Q?Bq6uM57W7sVQzsVymVqNvuFg3NZI6eXNElQOnqiEEOII8C9vBqGsWMAZRVEs?=
 =?us-ascii?Q?BGAuV+17mFa+p9dV71nR2qy8cOTxI3SVjBDrlpF+F/up5iZ/eOrziLzLSpZk?=
 =?us-ascii?Q?ktNh2aRXqJsgVqY0s2CqDOwmJbwtOWfYm0nKfMwzOcW3eUH3W3I6iVgAUsfT?=
 =?us-ascii?Q?zy2AEVClhwnWh5YCIGeyD9cuiVv8YOWUfxxfeI/0r9z7gTRpj3f35fL0bYQ5?=
 =?us-ascii?Q?RIv36vBaMuY1nP3WF0CBcy6edGuJ7FrjNYIGhcyn/Bq8vQ/SH/6tQVLGOmqU?=
 =?us-ascii?Q?DL6XHxsqkad+ZzJ21dGKDd91XMtWh1owJjyQnqwiQojcQTsEg7muXAfsoos4?=
 =?us-ascii?Q?7pGIGXvyShdNwAVGf4spKcKTP892QWK9AJsl/XInSyV591xpCdbc7jWpwHN0?=
 =?us-ascii?Q?5uEENbwjmXNhC9GLFIjO8OgCVc/0C4j1rOpYiuau2guD/LVrMWI79DCQLE27?=
 =?us-ascii?Q?ElohJbgkvnu/h94dM5gtzOeYc76+fnO678I4NLUX6mRlOEgL7C/lW1c+w3Cl?=
 =?us-ascii?Q?nQ5x7Kt5PRSM6M8HX5BmegRbbaN3XAFqlwzSlJ4B390UMjdFJyYGX/UnOTMU?=
 =?us-ascii?Q?013ZoqPuydgRY/a2ksNK4Yb2tQkTDRyYEcS+QKExP6ybpbQth0L7jbd757nu?=
 =?us-ascii?Q?xHR0rcZqoxt/Akk6VxZBB9SLROHySl9XiNVPUUBVp4VaXVKym/W/5koXv6mV?=
 =?us-ascii?Q?X5z4jpnv50FpevfkR2aAULPoO4VOBM/tJzeMUCPPu1G0R87YsrbhUGeD6O9+?=
 =?us-ascii?Q?YBaZTmiy/IXArfzZOKe/N1mgFW6a7PCOuUzbJ2k8sOHo/1hZJ3LYR94zDu16?=
 =?us-ascii?Q?2aCNJWHe+/Fk3re9g1rk3dG6wsi0QpUI70WytoyYeCTjW6g4KZG1Wy9/0WRM?=
 =?us-ascii?Q?mzMgo5qAGWT+HOINL219WskFXESy9o1eRnAjTOUf8obTX5uAUbNMShJKXdG4?=
 =?us-ascii?Q?bwZAjImGVmFNJnLCuMu1WHG6ItdLC7gu9PJN+3ERIbD47BB/B5ERKlZs4Wx3?=
 =?us-ascii?Q?P62zYS+tDhKS+YUBhehh+LKssqSa1HUm4gXP9eq6c9b5j0mRZcq8VTIln+Gh?=
 =?us-ascii?Q?AwuQMDW0Qx9a8DuMwgCMe4dh+pQAfrfBfZj/9Ss79U/RTGoxUpCiS6WPi4Xv?=
 =?us-ascii?Q?Tqn66lAa8ohFMaQWcVMeuV4L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0049721-4b7d-4505-5f9c-08d96816b40c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 22:21:37.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+WQR7NFD6LFtIuzop9pfHSdS7DEVVB1sRWXpxhXD9Auf5bgtGjy567vK/HRxF87
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 02:13:41PM -0600, Alex Williamson wrote:
> On Tue, 24 Aug 2021 21:42:26 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Aug 24, 2021 at 02:30:01PM -0600, Alex Williamson wrote:
> > > On Mon, 23 Aug 2021 11:42:04 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > This is straightforward conversion, the ap_matrix_mdev is actually serving
> > > > as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> > > > simple container_of() or a dev_get_drvdata() for sysfs paths.
> > > > 
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > > Cc: kvm@vger.kernel.org
> > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > >  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
> > > >  drivers/s390/crypto/vfio_ap_private.h |   2 +
> > > >  2 files changed, 91 insertions(+), 66 deletions(-)  
> > > 
> > > Jason & Tony,
> > > 
> > > Would one of you please rebase on the other's series?  The merge
> > > conflict between this and 20210823212047.1476436-1-akrowiak@linux.ibm.com
> > > is more than I'd like to bury into a merge commit and I can't test beyond
> > > a cross compile.  Thanks,  
> > 
> > Tony, as you have the Hw to test it is probably best if you do it, all
> > I can do is the same as Alex.
> 
> Maybe we can do it this way, it seems easier to port Jason's single
> patch on top of Tony's series than vice versa.  The below is my attempt
> at that.  If Jason and Tony can give this a thumbs up, I'll run with it.

It matches what I got when I did the same rebase

Jason
