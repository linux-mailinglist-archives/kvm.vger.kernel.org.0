Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA036DE15
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 19:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhD1RU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 13:20:57 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:2400
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239409AbhD1RU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 13:20:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx+KVxbRU14ymPm6exlwzZbdeITkMRxaHggsRke+X/5iFDkC5lbQyXpYiKogBJn2n6TEjhc4sR8AIFCe3j47JY4R1qA+FZ3TOfUO4pF3O+6EmhWukgk8wpd7Suoi8Lw3l+OrYCEsTjwkbD8XSfnY8l6GY4ZlJJ5PuOgHeijA30I1cj5BnMZG7zCsMOutaLGLQ9cc/F4/h64ZqGT5u+HBKahMPjD+MtPwH6DO60tJ6zsA+lmazo9vTQRqIte1fKVUdRu3p5jLQcGaakJd/aFBUac3egUXSJH3+F94q+MIfyC9TiisoGdqhYMb7RRg9LpcnLZiwflDKP2cKcVyHkdw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jSpzMpbREvtnvpTigMdEiuJGcQeI4H+LI55tTzgpPU=;
 b=kZxzB0QU9bHXfBc3TV1mYFYNUEVgmCOltIreNxqPyoCMnpr/PIx8t4RjHk1i4RQTflBr52NdCv9+i6WbkuozwDNzL7HNczufUwmR+XjOd+Ue7OSX9+9fgNkQ+oOMQsf6i3N8pTJJAHww8UTwANzO/wIie9Q/Y+URoBCfk1ucSMRtzzBXNMvq8eWsxqxhJMVQA3nUlgqliwSnFz+iEq13SaRimGbjT4DMHi7dSuLooYYn0byZ3oI8WiQaXyoAA8MDxyrwrQBCKNDFPCeFJeCKEbSgqb9W1mYhs0DZtw77cZbK65dI1od2bqzSwwhfB3C50CUiCJNESyl2G3MMckQfHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jSpzMpbREvtnvpTigMdEiuJGcQeI4H+LI55tTzgpPU=;
 b=dVM+1RxC76JObY1tsc0iCMhPw3XGcL4JohNig9mTjqTJGvfsnUTUEBUc3Yp5BcLpm+wV0irEK5DHcKJkrr7bzYOnV904UaNO8O/NnIbgvB1NfmoQmZMj0qv6Y4PomD2Nk3KwPgrSFMCf8U4kdKPcAbFQZ9whi4fxZ5p/D48ABN3WugrbANJx6KATc8y6vo9QUaM5aPbn+3+UntHarI/4o3oKxMy8ev7Uu9sXcpJXkhJIPzCHZltP75YL4vusCmfYw4hVYi0Ay1/9/CwkgowqhCxpnASdb04VbPlfmkfOscNV66hM18bP/AGAA6sGJDOAQOpaum6wsJHshF2SrT8I5g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1514.namprd12.prod.outlook.com (2603:10b6:4:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.22; Wed, 28 Apr 2021 17:20:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 17:20:09 +0000
Date:   Wed, 28 Apr 2021 14:20:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210428172008.GV1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428190949.4360afb7.cohuck@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:610:4e::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR02CA0018.namprd02.prod.outlook.com (2603:10b6:610:4e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 17:20:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbnr6-00E4uV-6B; Wed, 28 Apr 2021 14:20:08 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3db2377-3c2c-46f0-430d-08d90a69dff4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1514399E56175D16D137A7C2C2409@DM5PR12MB1514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A6x2Qt8ouJ11/NBypgz0iyXRBb8jOXZYYAdHzQs5bp8L5tbiiAo34UWWxuewMxEQk/5OHZvVa07PofolVzsZ/weqEtGlLqAAV0dbxJrwgdW8KYqN+Ijb9M6r4ECjq188PdFSBI0Df9wYXPnFHZc+ZkKcRMJIzmhFye6/QPI0JWvdOz6wYV33IKIWv3bSJfgSvW7C3eSwnei2b6hL9EYYLAWmg+TaR1jVb78WvwsGKR+meX91fmqKfQiL2PhexcAYfvsT14BxHKajk7RrbFiReKO9scMTIHDKfSo4eLzBpfuKclf6CS8qlf0BWQyhNTJ+04dmJs0MMCz3FyBFUmgSEtZpwpywmhctqmDVbHjEnEZicuXzUqyvEcuTsWA6VMz17BFqONBPnzTz2NeD5VgNSJyilIsBIKdiilRLFMQopyCH71LYtdAfuMWYUjnS1VgURSIMXjmMBHfChfDOhPlQKJyg8D4ENZykq0mrq0DuYskTLviK1disHYxfd1yo7W1raAsP3m1nOaHeR4skXUHpdH/6acbdgO0Ui6plqw5HBnYJ1HICvdCwFHCouy6HNafw0Ds5LLhg+HuziC2DFdAFszjU/IqYQ9I8n1lrIMGk+NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(86362001)(33656002)(6916009)(54906003)(36756003)(2616005)(7416002)(316002)(66556008)(8676002)(83380400001)(426003)(66476007)(186003)(8936002)(2906002)(26005)(1076003)(107886003)(478600001)(5660300002)(38100700002)(9786002)(4326008)(9746002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gg07LOIdIEbFMAWtZT6Akuw/gQMcuDjMS71mhJlfoVach8tE6IxCii0XHspi?=
 =?us-ascii?Q?4XfZH/vOzMNZYISJ4Opno3IiAb8G+icQDh5I8wGAPot292Sc090xelByfgxg?=
 =?us-ascii?Q?4ZVIBWPTZeJbFZ+628CbFJv1pbgSRofXZIGgwvr1EereSb2dOVW/84S7j28T?=
 =?us-ascii?Q?oBGarln3HeiIKip1n0GNdU8KcFmQV1F3t1e3reBxMW9uMWatnckEv+mb2mu7?=
 =?us-ascii?Q?A749y1OFFMpV1v1g/Fsikd874w7CMpW0G4JBkHUwbLmdqmgQoEveWR4iZtIF?=
 =?us-ascii?Q?6VDQv+ucwWqhtN0Nu3JIXINTlfNf8ixgulZr4rLZcfbnrsPndwAQb+JShoFh?=
 =?us-ascii?Q?0Y6AXKOseXnW9g02eGBILVnsWrm+T24f7SPa6GVGar2/DZJUueIdUqXme4os?=
 =?us-ascii?Q?b8FDUlxT89D5vXfhQZjBQXHThRFo2qFi4WpnaccRxHos406kFSosz6ZVjVv1?=
 =?us-ascii?Q?Cgltd8s3s7j3qx/u1SE2p+0h3GHH158UsuS0LljRJLlRfmeOmy84vUc2KHRL?=
 =?us-ascii?Q?OZXVu0YmGWjpzQHo8UbY+nUWEnqXDT5bn6g74kWX5Uqs7T5VYTN1/Hvlu4fA?=
 =?us-ascii?Q?usfCv+Z1l/fA1IVmZFm/7npKN6xVHebtnja0pKDtc/TK7Ofhm6oW69F57lUv?=
 =?us-ascii?Q?Uc44Kvp9K1JubFXjdDYuUeezUJV07y9847NAKZhMeqrI6vDhynWvU3+hjhNH?=
 =?us-ascii?Q?YqJPQz19m3Uyq+3ngQhDTDcsx/zbXn76L3mM2Llm5e/R0Gy5gG1ckV9an/Hr?=
 =?us-ascii?Q?PiwPePosnvkwmi0/Mrhb+yQYxK7oDXRAXIe6blK5wkRStuQHl26fbaeQZHUN?=
 =?us-ascii?Q?5kxTbeSwpGNl/7SE13pjpPqfmVpZ4ed5xiqOMeh84bv9OSM9RPnBhKT9TzZl?=
 =?us-ascii?Q?jHtXD+vlPi/ebT8+R0gHTNeW2MfEtocs3o0EtCZnpt1ReNW09sTOAhwwcHfX?=
 =?us-ascii?Q?dpF8Ltkipsg4LbVN9k2UdaN/xJFybkBvOu74p/e3TpPx1hnCiSXqdwFYJUXW?=
 =?us-ascii?Q?7+d5uGVmu8Uu052MnVZkIKf1396nembxmNUp5EoD91ANrJH+11LuTGrpcIc3?=
 =?us-ascii?Q?ru5ecBrx2x652Z9V824Xe8+HGF8780OnbWuTRzbC/JmcnFIvow7oHl13iohO?=
 =?us-ascii?Q?AH4VnToxUlLHC1mvp89jLqTE3O7pChMYsuCyVYJnoflPP2TKM6rUQB7cecFz?=
 =?us-ascii?Q?2kDJSJK9JYTgv2xRqjkbNKNxwn/kAQ6e/6npjy40d3qKwhbew/klah57joA5?=
 =?us-ascii?Q?0DN9I1pYQbf6v/tsB62PrXhfcUT3tXQpP7XEQKxSBK0T0y9AhX4wbBg5Ymdm?=
 =?us-ascii?Q?o3+cY+iuzlyTd1caHWd+6T1K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3db2377-3c2c-46f0-430d-08d90a69dff4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 17:20:09.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sS4sNKX9UQBd+Jym3mEIhG74rwLcFMB31huLyASvQjHYoxOJOSwyelzdpInsxCU2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1514
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 07:09:49PM +0200, Cornelia Huck wrote:
> On Mon, 26 Apr 2021 17:00:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This is more complicated because vfio_ccw is sharing the vfio_device
> > between both the mdev_device and its vfio_device and the css_driver.
> > 
> > The mdev is a singleton, and the reason for this sharing appears to be to
> > allow the extra css_driver function callbacks to be delivered to the
> > vfio_device.
> > 
> > This keeps things as they were, with the css_driver allocating the
> > singleton, not the mdev_driver, this is pretty confusing. I'm also
> > uncertain how the lifetime model for the mdev works in the css_driver
> > callbacks.
> > 
> > At this point embed the vfio_device in the vfio_ccw_private and
> > instantiate it as a vfio_device when the mdev probes. The drvdata of both
> > the css_device and the mdev_device point at the private, and container_of
> > is used to get it back from the vfio_device.
> 
> I've been staring at this for some time, and I'm not sure whether this
> is a good approach.
> 
> We allow at most one mdev per subchannel (slicing it up does not make
> sense), so we can be sure that there's a 1:1 relationship between mdev
> and parent device, and we can track it via a single pointer.

This seems like one of these cases where using the mdev GUID API was not a
great fit. The ccs_driver should have just directly created a
vfio_device and not gone into the mdev guid lifecycle world.

> The vfio_ccw_private driver data is allocated during probe (same as for
> other css_drivers.) Embedding a vfio_device here means that we have a
> structure tied into it that is operating with different lifetime rules.
> 
> What about creating a second structure instead that can embed the
> vfio_device, is allocated during mdev probing, and is linked up with
> the vfio_ccw_private structure? That would follow the pattern of other
> drivers more closely.

IIRC we still end up with pointers crossing between the two
structs. If you can't convince yourself that is correct (and I could
not) then it is already buggy today.

It is as I said to Eric, either there is no concurrency when there is
no mdev and everything is correct today, or there is concurrency and
it seems buggy today too.

The right answer it to move the allocations out of the css_driver
probe and put them only in the mdev driver probe because they can only
make sense when the mdev driver is instantiated. Then everything is
clear and very understandable how it should work.

I almost did this, but couldn't figure out how the lifetime of the
ccs_driver callbacks are working relative to the lifetime of the mdev
device since they also reach into these structs. Maybe they can't be
called for some css related reason?

Jason
