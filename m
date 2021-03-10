Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C5333CCC
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCJMnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 07:43:32 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:37344
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231867AbhCJMnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 07:43:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osm+zLu6h8h/XrbGXbVOVjlQsHrYmyAlMwr2Kd7vnW1dFka57K3bltbRpTTKAGKMEHJ9pb7RYX4jAqQx/09vLwwENglTkzrCuB3vHrTu7q0D/l6/93xcq4ddK+JAvcgqGl3aTp7iIZ3DKp5u30d6OLdA44c785O/uQ7FAOib2QfuVi/7BjHQQ/1wstts3tqWdViZ9IALr01qUJzNV3N9A4tb8rVgIfvNbrQX/yKdkpadzcg2rK12pYO2q4+2aORgJUwOdeTZqVNqcqYTX0A9CBb0uP9l9/bIyTgZ7DH1NGaz8KdKphI/VJsCIsnidXXe81K33sk7+BO5uhDCUZwnig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZCpkQEW6BGyYSrNLPE39JQZt3XpJO6na60EwWjW4AQ=;
 b=BnbJ5XQKe1fZ6cOYKUbvvYz1oD3IZ+syFJBuiF461qj/CsQoKFHDRyVFgwxwgdwn0LKcgToDXfkW2iffTfMJGS4JRYi/51qhFMjT4PM+ak3nztwU7pKCPbKLR3v6dCay0tF/c1tXsHSYmbP9Ar1fzwoelBRNC9xCadHjCviNv2rxtXaMM8cx15UfuwqCxO5GOnZXlrjNJO8vjyMLEb3U3rirs0RU4nnHbZvww6WD4W5SD/yqokyZydnTeRv5rvMscCaE+oKgdQcfYyftAsy3UwcuEeuPH57JzUcJIarib8CJMicd3cPgTyLEXyqeQlMhbUys/OHqGSJIs2mJpwWMYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZCpkQEW6BGyYSrNLPE39JQZt3XpJO6na60EwWjW4AQ=;
 b=DkOtMuNBZ4iDBwPKFZifIkMQfmxgvpzqOybz+abXB9U9GBUMinTegsZfUwQzp7oz+Z63TF49XLqwbkX3f1wfUlxwaAEeh6k9MfO0ynnFpIA0KHJXCdizGJYaaFPZY/oKwRcVDvTwAW72Z5FIbwqja7T+tWPNqoUyV5s5w4q6Q5NRNgrC3tu0E0sTQ83NYoUw4/OtvyHClxQ7YmhKCTng1NFAiD53pAi/PbfyXzIM7HDrXdufDJWBVyRUQxNZMFgyCHSti+vac/SFdJ/UBzkqjfRi8Agb6CRgcRItzXDAxjZ9pAe4ZSJyz7tKOoXO9oH+1+pWr/uPizmHOmdIJtVj0g==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1546.namprd12.prod.outlook.com (2603:10b6:4:8::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.27; Wed, 10 Mar 2021 12:43:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 12:43:08 +0000
Date:   Wed, 10 Mar 2021 08:43:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 04/10] vfio/fsl-mc: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210310124306.GU2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <4-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <20210310073001.GD2659@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310073001.GD2659@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:208:23b::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0019.namprd11.prod.outlook.com (2603:10b6:208:23b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 12:43:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJyB8-00Ahxq-Q4; Wed, 10 Mar 2021 08:43:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6588555c-d590-47f1-31ea-08d8e3c20e7c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1546:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1546FB57BE3384AD28602FE5C2919@DM5PR12MB1546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YEzArzsD/8aBpXrphNKPWbI3OOIyU2//qACMESYVOFtgCrZvoTMG7qolQBEEFDr1PXT+PH5pLlqaYNIOy7eHspi/LZjSLoljBl4rqvlj5EPW21y54Fpsq2iJTvfzjb8hxluhKgtcAi1x5Yd66I2/KZGv4l5oCoNMGaM9+GUc2lsGA5C6//oLa4Fw5qaAVMIkhmRzcX0p5T8HPtdO8IUydNRgWDacQ48SkyE+6us0mpIMc04mPnmRX6gW1dIJv3MgMIrTjgSyQtA2YaiTcgCaAM4wwsozV+shqS/3HjdWCjrWsxxIX1LsDhL4+qCu8No4v/X/4FdhhtT8s50EvlNPJ6IxXKxIoi4dZMjvhdZKwEq5s87LrCRr/H5RRc9GWn1BpNhAky+3O8n41gpkjcD0izNM2p3WWSKqE3hvtR39R0BXuZQknQXVfFYW8of5Vv+HQGSMiA2et66qYp/lmQ4gksTE2E3PRHGXZdTNYfk/k0nyAf2guKzurIoPphR2lrU37ZOWjJsyhZ3y3dhng3MeSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(6916009)(107886003)(86362001)(33656002)(2616005)(8936002)(478600001)(8676002)(26005)(5660300002)(9786002)(9746002)(54906003)(4326008)(316002)(2906002)(36756003)(83380400001)(66556008)(66946007)(66476007)(4744005)(186003)(426003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jlgI6+tSu1wNhavZIgwhvpMvnnDqurHwejg1Y0agleNM0QMp25fHTJC2mceL?=
 =?us-ascii?Q?rzZoiDAIXUwK+LJuOrfpaAy5cZkOhVXkQjrtC73pxkfK7UnhaUioDMwPYqCz?=
 =?us-ascii?Q?wx63d/upyrY8/+RagQ/MXv/bIQkRixihG8AznYjvxiy4ImyYq1mDZk/4PXcn?=
 =?us-ascii?Q?HwDdcB3LfPbprJKBEoftNPTTHS1GJ/iNhzEX/Em1R6ldvs0qjuXHJoT8YdgK?=
 =?us-ascii?Q?n/voBTUCekxibthgQdE0Z+fsYY8wYgFx3z1axJgipgQC0opB0+q0M2ThEWQZ?=
 =?us-ascii?Q?NhCUQ8RYuD/pH43CBq3glnxOoBvRgzQNxY4isMdukyHKteqULVY7m71nXMXi?=
 =?us-ascii?Q?jP1GNULwdAGd8eakW0PAhvBWDuGNlQsf9WrlUqZjrimo/hXnsqmFEMJmIOkg?=
 =?us-ascii?Q?TKbQIX9H1AGIHhCpuLoUpk81ClM4l+0C2ZAqO3qc9S7KRq1ZzWsylzkUf2q/?=
 =?us-ascii?Q?yJqHdLp4MqbbOmZstFhREGllM3m83QgS2WPlkFI72YcIvgFqeh5BhIZ08/fE?=
 =?us-ascii?Q?c+PtnW2yg8qH+U7ci8G/rF5qGjcWeS7NX8RmSGJNsZTYRHesl5TD/HcpOuBs?=
 =?us-ascii?Q?QMFWJWIfc5IHsBGQtE4d2PjQAqyFWDDc4XNkAET6K3zmBiLwCGjDwI6++Yq7?=
 =?us-ascii?Q?DQQ3j24qMTEpqmB/HYv4o9JtNDzkqLBylzz6jj+Kwc8+WlIFxcSRyCG0Ljrj?=
 =?us-ascii?Q?K9vGqG+dh4MsI6B/qTgIeC5k64b4GWIX72bAlV8XWNtgm+Ggr0BvMD9VlyNK?=
 =?us-ascii?Q?wK1UbNIl+w+HmueFcg4ks49MZFly76CB/XRYNd8WkdL4sa73g+Q4V9889RZd?=
 =?us-ascii?Q?h5ZEmywZE0a9yRZ3lt+N5Cf51/tq1neZcLLoiuggU2ljQmW6PzsjitZ2bOnf?=
 =?us-ascii?Q?N51D1yZDxRYCi45e/BaH7KijSzm+FAbQVysFb+RQkbqxsVexlXB8KbdLzzxW?=
 =?us-ascii?Q?xIK5hOCOd6X7JpKEDPM9/wFZthxxv69zxou7Q4DVcbqzFH/leDUCpal/q2KK?=
 =?us-ascii?Q?YQDtpA2tnyncXxcr3JkVXxWv4H8bV6HSDfvEy6pjdkHfoRI2OwKlrmOmU6Wt?=
 =?us-ascii?Q?EfchwaUDtK4bd3frPy5fO1Ad039XAz753kjxhkg1UXIZg/4pm7Un/xODvFNM?=
 =?us-ascii?Q?28s3/6vqx0YVwcYCPx9+PcJaDzEGQx64HR/makAze60NZugWKQwQPBTOEH8e?=
 =?us-ascii?Q?uuf1e1taSqlZQjaYdZMBRzWvHvPU83XaFfv9peHHlaFz4EyveF5TS6BGUGT9?=
 =?us-ascii?Q?X4Nhxl9lz78i5u0lcpiXplVnSzyHaVGQ06FATtqubDdDskBgi9jo/vaSvdpf?=
 =?us-ascii?Q?5kIadGtwNJ2ehEc5V3gKBwXAVFzRLh8xI47wNwRCWEdyoA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6588555c-d590-47f1-31ea-08d8e3c20e7c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 12:43:08.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSRceUrJQyM7PyysHlgawVtmopgFds1EOPD9xWdMT6mKkuJWUEDun3zDhylPITq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1546
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:30:01AM +0100, Christoph Hellwig wrote:
> > +	ret = vfio_register_group_dev(&vdev->vdev);
> >  	if (ret) {
> >  		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
> > -		goto out_group_put;
> > +		goto out_kfree;
> >  	}
> > +	dev_set_drvdata(dev, vdev);
> >  
> > +	/*
> > +	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
> > +	 * immediately return the device to userspace, but we haven't finished
> > +	 * setting it up yet.
> > +	 */
> 
> This should be trivial to fix.  Can you throw in a patch to move the
> vfio_register_group_dev later?

Hmm.. Yes I don't see an obvious reason why this couldn't be trivially
re-ordered.

I was hoping someone familiar with FSL would see this comment and say
if it is OK or not :)

I added a note to my list to make a followup in one of the later
cleaning series.

Jason
