Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53037CE2CC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjJRQdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjJRQdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 12:33:39 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BEEAB
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 09:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLBvA6iIQ3LZC3+qxDayJHx1yqZQzFUTAGE9ZikYuQaiR2+POFKX63G57iwQa2s4kRVxNVjiQJ8lFjmfS5cL0fwKF/tpF0LyQjBMFi4s9g4KQUxxpPOZLQRTL2gdhLv+3FHIURN4D8jHfI+Q7525RSxJHc7zxzxDY7dGkkR0FK8XaJc8Q4ip9JvSG0scCtEwv8Cl/X2CTNj6pwTarxbjbvlCPAG4VaBtj6ktfer4CxvZlaayhSL2yWx1hL/qb8sB780ZNUOc+hF3/XzrejdKsqZj7KoCV7H6vu3Y8eHcOdsszCbQmxStgqRsegyzSMAI6ShNwg7OQWX8E48tVpKwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7Ern1ipaoOJMcfbspXbc21PIzrrtzc+cbQkR1UWjx0=;
 b=he+fZbiwcyyRbyMHnMjzy6J5pQYtexu7RodJp2SSxzBh96NjwH2WbvajqTfot8Q2kw9fwd3kqTjARXWbar4gE5jVLtVP/wpqpLyT36EDowTysorD3xCRLs+LddLhMs8PdPOH7r1fGSnxHYeTkU09ScRC+l8FMJNMzHWepiw+H7EKCoxIid8BUCHdrsLrkABeFJO8CERyKiojoze0LXd/JApnDm48fg7kFMjyD6249fSHlFms1/X2XNHccqEoxztEg0vvBe3p0uMTvzi53ClHlHGYAm2qfKODtRFk/qZyGPhZrwZiTmwvJ3Tu849l15TbaUj74ttVmKl5Hdq7jiNRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7Ern1ipaoOJMcfbspXbc21PIzrrtzc+cbQkR1UWjx0=;
 b=msscj6394WUbiRjJ/1I2/w59XNPJC+8rJie7ccc5b/ScQtp2WKOxmcD4V7hmlgcdBFHfeRwcGlgNY8PIOx7Sbyk+cYw2z+OQzu3VclR8bmrfVjWtvLLL8mOVJgjehiChyOyn7sfoQ+om8ePA8wJpB/wI6pn55Th/vlfXkoEisMZr/2yzt3ARQteikE6XVyidNoHBoGD0c72FylXnshJVt4MBSLgoGOPCVAep8rV274JwmMMZSoWuFE6rEYgypA3utSB4EdqEAsKCgXQbZSR8av0oKXtVQFI3MrpJxj5aWkwbMC8AX9v0hnSlpYH2joUPNa8SGWH/vx3EC0rjFytT3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 16:33:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 16:33:35 +0000
Date:   Wed, 18 Oct 2023 13:33:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231018163333.GZ3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231017142448.08673cdc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017142448.08673cdc.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0033.prod.exchangelabs.com (2603:10b6:208:10c::46)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 013a2a38-1b2c-4d03-65cc-08dbcff7f934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sb1KBQMvIrYg5jZNl5lGgfEhOQ7EgCgIK/yVuSgrGFzIzXPg7EfoxjJhMfvH41fMNNkJ9Lb26niYl13WmY/Hn+g/yDY3RxSG8D6WuxIQeuOoyYnYNAhDVA7wJkj+0OdEqmq3yp02vomSTo19eVmZJK7753bFNX0sYpmIZecTSCU7iiI4FL2BdxLNh36GatRcLVZq7ynO3wlj90AUquZTXyTM0S975py6xL8ITGJCLeRFPWWiYcSMnDdEUW65TBPIhJpV0fMyUKxuEunxDqB4Q1rn+4uldzR8PIUtrldf4W0BRt4vBt1xowcF+Izf9vHGlKDK8ZbwT4Ix1gO03oeJqBkjViz3ps8mG0hUAVLCs35lcIU0NbPbkp1iOruwnXFLUUNjnZ3dMoYZRjc3qeHG6FTclGqwRdtXNKNRWHeB15OTQQ6qtS0KWrz3zXElMJSHyvVdp/nX7oqxmapoRFQdQafBfISi65OQt9PAjRbPL03Q/YQPDf+aJ3WmEWvHiAnatUD5dz33I+vlcbqnBTq2N4/pF3s+yvu/2Z1NjtpLZi7QSmXh2ViypTwaeZrYSJeX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(39860400002)(396003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(6506007)(66476007)(66946007)(66556008)(41300700001)(6916009)(316002)(6512007)(6486002)(478600001)(33656002)(36756003)(5660300002)(8676002)(8936002)(4326008)(86362001)(2906002)(38100700002)(2616005)(1076003)(26005)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gqIL3K/djG6u3566Gyp185k60ob6GBBAlUdHw0M+o81iaiHdMo7EXN6+ldME?=
 =?us-ascii?Q?oxdoA8avWr01GXPmk6u14b462l3lb8ZYYnjQPSZjPH7xfusRRvFK/5FaNJjl?=
 =?us-ascii?Q?kRgQgIGM6MghBeAVdrUz3EEKZD4luAUmS73tf+3n/AOPdx4/xJxekcZvrNHh?=
 =?us-ascii?Q?NhprMN8NjHyXWLyWlJWnmuKjiZWlVBNGVjq97E8IR21hj6btJr0cD8eKUsnZ?=
 =?us-ascii?Q?5T8eRXJk70i5YKo+jzhUAp0sOcjsIh8Oe9KJ2PHHm3oUHEQJLo/DsRQtmwuR?=
 =?us-ascii?Q?et5YM02PPmL5jFyj+R+HLtFSsTqTcuffQWFR4auf4zbI5XPXfw/cuRyeGHSn?=
 =?us-ascii?Q?9Zoo/sMh0B7T6zqRmGJwmiHhiwwPgIlYs/EzvqBdRtzO+6CDzax3g0nP0LLj?=
 =?us-ascii?Q?tWU4gUbISNVTpht7l1O+E+iNPcRaDmLIZnn31VXXZr9VfZ58ja3bOAGSPDvl?=
 =?us-ascii?Q?W7T3he/xccLrjtMUZkrCG6S8Ro4CmjCObsd2WpDmuZEFq/YTX0vq4US8kpU8?=
 =?us-ascii?Q?elM+ebEdJqPKC2WbkchVV0Y+Ot6fSjHVS0MqrDz3gEkyJRxaDmlUcvomq8xL?=
 =?us-ascii?Q?gAGS/e8+1WxuMLBMhrEcM6jUTPOiCs05mEwxPt6vNoo5QnZcUxaOztMpDxBs?=
 =?us-ascii?Q?a0LW3RX5MvAVR8fXEyRlEm1YZVS+xOiMG39YILgYrjew1eRYaIrYvvUQaYZI?=
 =?us-ascii?Q?rmjuy35V1d57iH4ogbFd9NpbnrE2JAnMI37U8/CY1dQHaw31JKl3tJgh5zWo?=
 =?us-ascii?Q?6xR88CT1WU1smB45lJbEjA7++5ezbtEiIGcOcOsjcuZMKLPY9yJb7wlin4iV?=
 =?us-ascii?Q?HO4Ol726S+8DiZsd7QK8W/70GYnCv3w6TREizmVjcmq1MumfENIKcXp3Jl7l?=
 =?us-ascii?Q?2hhyQwbB62V1xfUCb1E5aV9slJpfCDsnD1WY55gk0YsZTxg4ldboKxAvIqTp?=
 =?us-ascii?Q?U9qoHBYdgwEJ94ieU869bGfHKdpuV9jMB3yeW7pu7HBjgbjX75/EIx/PQRV/?=
 =?us-ascii?Q?/aKEZBQYTa2a871lkjevIn2iqz8fDx27NQ6/PtbbTfzobeiXUxcNEiuJLz4o?=
 =?us-ascii?Q?ahrMF0J1IX8+goQRslHeAnQgBTLs2rX8WUT11bZd75nvpv3N8A8GfUH6vbfg?=
 =?us-ascii?Q?N3MDSRcWpoWp4zw8ScWeKujCJXAoRTost7OR2TXMJQcLHhIWit3XCEvMEBUo?=
 =?us-ascii?Q?QTUzi5sBYpNQ8smdKYd+KQRqFfhVnf3UIKX852XyoknwpS3ewglWXDN6GIC4?=
 =?us-ascii?Q?V3nOQgp02zRk3oWdiYM1OOMi8tNHzikbYZf7TAST7M5RLLCK6j332PgQj1Ya?=
 =?us-ascii?Q?4wsAq65UXTaiim66j74QT5em3x2uPYstVcodpFfvTiBCk8dPjGCxK05hokiw?=
 =?us-ascii?Q?71C1FL1aQl0gFVB+lM0yU6yK2fdTGHiVxbOpYZ7a7jTVCd23Rc8d6eMOCAHp?=
 =?us-ascii?Q?MBjrKGkjvaOhj1xl7FCMMmecR+HHLfvtZIb077WKMx8/dAkbsxqq/V0qf1FB?=
 =?us-ascii?Q?bGl1XRMAtZz2dI0yTszWEzV++SUk8bO5Y/hROii/sJ5yEC5fA75aZ+Hq0ldm?=
 =?us-ascii?Q?GcSuTWPaoeUWgIRygc36/HZmV3velLoSn9la9BpC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 013a2a38-1b2c-4d03-65cc-08dbcff7f934
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 16:33:34.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+G5pNKi6q4OluC+4/W5ztnOpmtwRpIKnUFpC+QSW+Qef8gPX6M9uR0I0YN6SeKp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 02:24:48PM -0600, Alex Williamson wrote:
> On Tue, 17 Oct 2023 16:42:17 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > +static int virtiovf_pci_probe(struct pci_dev *pdev,
> > +			      const struct pci_device_id *id)
> > +{
> > +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
> > +	struct virtiovf_pci_core_device *virtvdev;
> > +	int ret;
> > +
> > +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> > +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
> > +		ops = &virtiovf_acc_vfio_pci_tran_ops;
> 
> This is still an issue for me, it's a very narrow use case where we
> have a modern device and want to enable legacy support.  Implementing an
> IO BAR and mangling the device ID seems like it should be an opt-in,
> not standard behavior for any compatible device.  Users should
> generally expect that the device they see in the host is the device
> they see in the guest.  They might even rely on that principle.

I think this should be configured when the VF is provisioned. If the
user does not want legacy IO bar support then the VFIO VF function
should not advertise the capability, and they won't get driver
support.

I think that is a very reasonable way to approach this - it is how we
approached similar problems for mlx5. The provisioning interface is
what "profiles" the VF, regardless of if VFIO is driving it or not.

> We can't use the argument that users wanting the default device should
> use vfio-pci rather than virtio-vfio-pci because we've already defined
> the algorithm by which libvirt should choose a variant driver for a
> device.  libvirt will choose this driver for all virtio-net devices.

Well, we can if the use case is niche. I think profiling a virtio VF
to support legacy IO bar emulation and then not wanting to use it is
a niche case.

The same argument is going come with live migration. This same driver
will still bind and enable live migration if the virtio function is
profiled to support it. If you don't want that in your system then
don't profile the VF for migration support.

> This driver effectively has the option to expose two different profiles
> for the device, native or transitional.  We've discussed profile
> support for variant drivers previously as an equivalent functionality
> to mdev types, but the only use case for this currently is out-of-tree.
> I think this might be the opportunity to define how device profiles are
> exposed and selected in a variant driver.

Honestly, I've been trying to keep this out of VFIO...

The function is profiled when it is created, by whatever created
it. As in the other thread we have a vast amount of variation in what
is required to provision the function in the first place. "Legacy IO
BAR emulation support" is just one thing. virtio-net needs to be
hooked up to real network and get a MAC, virtio-blk needs to be hooked
up to real storage and get a media. At a minimum. This is big and
complicated.

It may not even be the x86 running VFIO that is doing this
provisioning, the PCI function may come pre-provisioned from a DPU.

It feels better to keep that all in one place, in whatever external
thing is preparing the function before giving it to VFIO. VFIO is
concerned with operating a prepared function.

When we get to SIOV it should not be VFIO that is
provisioning/creating functions. The owning driver should be doing
this and routing the function to VFIO (eg with an aux device or
otherwise)

This gets back to the qemu thread on the grace patch where we need to
ask how does the libvirt world see this, given there is no good way to
generically handle all scenarios without a userspace driver to operate
elements.

> Jason had previously suggested a devlink interface for this, but I
> understand that path had been shot down by devlink developers.  

I think we go some things support but supporting all things was shot
down.

> Another obvious option is sysfs, where we might imagine an optional
> "profiles" directory, perhaps under vfio-dev.  Attributes of
> "available" and "current" could allow discovery and selection of a
> profile similar to mdev types.

IMHO it is a far too complex problem for sysfs.

Jason
