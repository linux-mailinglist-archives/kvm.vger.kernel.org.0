Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB307CE7AE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjJRT26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjJRT2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:28:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B380FAB
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4O/MqTXB7LyRX20vFlHbz2ymxM423s2yAO7GDILsyUlNZYE7CCZrMiP41pERMYSt8DG39N6PTBQHSlMR66/aUiwufyB/UI5QVuOiDCsbN8MpIqCkj3I31hZkrVjwAnQdHdBnNYjh0a/67Obyj8mm9ZBswwLSPwr0O2tLyU9iD41+hcgKhfja5tkwA4h2ajQtEZyjpm0qrkLPRNcSffXCOZNe/mrvpSrUe7JJaEYYWhvBeOkwoE/VULuoS1pcdJCs0IgGNzF18D+dh1SpsiTXoTgYNMxN4DyCuudT19Uz+/SorCtHwkpbt1O8cghtGd+tuzJYxcU+2zoVOVhXWt2Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8QqNsRbul/tEDs8r1olWeoKF0q++UFZplwXHNdeLaM=;
 b=cGqCk8rfMyOY1bNZtJ2cz5V7JFgiHUGeGy8QbA1abKXT7gkm38c2W8X4WzqpuxsB/U2t4wa/4JZxwOI5QPwYgp3SBSKOG2DJrFTe5r4LrRSacYzeQrEsXYkSG/D7W+5uFEYS/05aVEmHdeiV7C/os2JRKVA1651eFQV5D5dX69lj9JvECc2tIswlhHG9x8NWmmfMK8Y2KPQNBFR5uoLaHR28tZzzwrSZwt31UQ+fbtqwG5/jN3Mq2tQcz5vbXia71dKtRr6O6LNkPBCdHJ0YWkEfYA7WmrUH27E7SrLkXxD3CzR0HfBRd7OczutJg22nSyvLxsW2P0aUxN3rTPZ2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8QqNsRbul/tEDs8r1olWeoKF0q++UFZplwXHNdeLaM=;
 b=EjUUG63DtnYs1d0TNE9jelbJPG7ykMlmf2sriqP9IrmerNasszqdOFYGWRRmfJ8n/Y+hzmh3C0pjqO00bIIIT173ifL6uu5pE5i4iWGm+Whfsf96gAo9eOJn7BxHAi5GW8lUvqhogWSn3SpFhb1eDAqEg1fjnUA5RS8lJbF8TdGQOtJp0Or4VFJ3fByniTgIw7nOxOeH3BjaniBC1msd6ASBbCCp+TOr8DQoJKd1NIT/14YRcC0CucJoBNm/5tdKr919HHfA99o85t1sESCupp7XFRkXomi4CGx/2S1NeBVx2of6R23xV7U2ey0xBH1kOMMmCnBTwWTK8VQYE887NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4535.namprd12.prod.outlook.com (2603:10b6:208:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 19:28:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 19:28:51 +0000
Date:   Wed, 18 Oct 2023 16:28:48 -0300
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
Message-ID: <20231018192848.GE3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231017142448.08673cdc.alex.williamson@redhat.com>
 <20231018163333.GZ3952@nvidia.com>
 <20231018122925.3fde9405.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018122925.3fde9405.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4535:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b769ecf-7ad1-4278-b931-08dbd0107582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxzng74YbmvQiNQqeguAgMHW6J9SS7qDxUEGuU3E0v8M6bO8jQtQcsMBZykJ3jw0N6R07MVVRFQ9yix9sNqst/IzBnjEaPK1Ch9M280cnwNLhxg/TelcYe3HbB++NJxhSygVW3zgw6lnqOk/Sn7JmkdtOFXR/w7fbbRfUw9l95mDyyNb7zRmat8725HaJ6AnQaGkjcOjXPo51DZVbY3CwIU0Gynky2KdeHUSOi+UfyG5jYDDH6MnkCEXTipmqVOM7BmfjzgfmqTINkZNVeqfXnTIrYC1le6HGsD43zrf2LQ7iNRdZrIMLmvxApq/Ru5Olaj2H9lCfrKkHGG47+oDgPDUI3l243ACZ5LRToXEciYrISOegxU+l3EcPtCfL8T6Ch1yedoRNbva+x7zaj9oYP1zH0uMYip42QJ/4Wbrx4+Hs/xlIC/jw6DGFqDVHlVYCWohZ2t4RG5UI0twKsOtjhWKnc1bjdjgG3+CN7V9S4hjN17V1y8yMvTVogYepkDEW6MVSTHm8xGs5tGBXuSp2Alu0xn+cFkt/Nrxkws6mvEd9DgCnbDmuWGno2ckX0bc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(36756003)(107886003)(2616005)(6506007)(26005)(1076003)(6666004)(8936002)(6512007)(83380400001)(8676002)(41300700001)(5660300002)(4326008)(2906002)(6486002)(478600001)(316002)(66556008)(66476007)(66946007)(6916009)(38100700002)(86362001)(33656002)(66899024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w3EWaJPCUyLOYx3gShLFIivsDf3ljLEnJrvNxXHI5k1py+7Hk0jIQ4nBpI+/?=
 =?us-ascii?Q?WT/RwhB+h469B0J9OlZePDm7xRR+r/RcZgB7gbFckrfN/I3A7AcEt28/MD7R?=
 =?us-ascii?Q?ENKfsBYKDlJFJqmrSjU/vn/LjeUqhYE51MGivxr9Jec7NKbI8sEwJrB97VHW?=
 =?us-ascii?Q?PX1Y/AyhPyXuCeDU//q3dds72oEGz4TxlNFl/BLUglCc8NcfHEoPBP60prMP?=
 =?us-ascii?Q?ZEiuBjRGylP0DJr9S5BAM8NTxrMzgajjTevCe1a51R07LSE60fIDZyaWZcwg?=
 =?us-ascii?Q?pV8S8ReVwDR9iez7mbXLz7KfuNoyLWXb9Qjf9EpjYJvOwdvez2Zl9HUjU7X6?=
 =?us-ascii?Q?7cyEnHvuUkSIHWXNNF3n9NE6EeBVlrO2IuMaw+69VC105+i40Ijkn+tN4HJv?=
 =?us-ascii?Q?2I0712rGhBeb+c6Pt+rtWM3uECxCmWMzfT786lPmai3f4xMBApPj+wMvOa4L?=
 =?us-ascii?Q?uV10cvoFgMdPiQB6mCfPW6QW4eDq+p+zQeWgZwmR01qkCaInmQXtCNFO61y7?=
 =?us-ascii?Q?K8A28xNbnnJyxV0t6SAPMd32NCrkNMNBos6Pp3uppIaTyAxgc2oOq8oGMhNw?=
 =?us-ascii?Q?TiupUQGyEulUW2Tal9fscNGdxQq3RSkJNRStNF/Ev0SvofxeFmfqqlNX4+OL?=
 =?us-ascii?Q?1nvfDjZfqgQZLuJESE8u4khWocc62gy45lD97fFeV14OylHbQoFnnzHxlHNm?=
 =?us-ascii?Q?XbcDBoxkBhlly6uo+b9yyuCVOrxQx4ZwSZ49oeM6GdlMMJMP05+WG73wrcV/?=
 =?us-ascii?Q?gBtVwMWScwEym9unk3fswpHixg/AzOlzvLeNz6/2kpnRm/NQ2PCWY8tO14oS?=
 =?us-ascii?Q?WMNjd/5xK3tzBFP8UjsIdEXhL/qPuHfEmGSUwvDfgSlhpSzPIEfXZtxAa4P9?=
 =?us-ascii?Q?hxV2JNKuRKXW23gf+A5cahiqgrRuip6wQer8I6a3wQg0VxfmGyN9y6kiTI1r?=
 =?us-ascii?Q?z5yhYPaguWbT0iiN4ZZ3Wk9LLYMnh5ao96nFBx7B7130TbGqrxb8uMb6w9v4?=
 =?us-ascii?Q?kk1kjzwZYbH79S9gnmwivUW0S54S+kNGRa8HAG2V8K23pvG8Rli9GQOlu9Hg?=
 =?us-ascii?Q?MkBVpkpPyhEfE+7xRwNhv2waFfv0dYk2YVWkivGXe3Nh3K2/ZNa072E1mWyK?=
 =?us-ascii?Q?76zpj5hvF0p8+96aLsISOQSTtW8aYTvY4LJVpSGB5QwtKOOrZiTe1c8raIts?=
 =?us-ascii?Q?/afnFkAUblcy++8czrqrH4TJ6cNNG93WVlBYNY5AhAoNo7d1diqUQ2bycc2i?=
 =?us-ascii?Q?CbqlI/5sKiQg/VRXHtUyc2uV9/STpL+oY8BW/B6qL4ybQN3ELKAv/JygH+OU?=
 =?us-ascii?Q?vn+B5GMmUnMW39Y9ugZ8A5nbouoz5nsOjROeUfUHYaLxfmmMXZp83GAcp/6P?=
 =?us-ascii?Q?6BTEwr3VgfWFO3v3Rnis1ZuuRpLMNff17HIkkCbZ/cAH0hW7Sa3RS9f+7nW5?=
 =?us-ascii?Q?bm6IF2b2wZS3PaFeFGnHJLSgyV8VmP6Vhbye7cmsejd5j0UMIUWy2/xL4ph5?=
 =?us-ascii?Q?+xiG5FGeb6CUPkX6+1xlwNhseRwp1cTuvhHqiebMIRwabd4V5Q8wn7khC3r5?=
 =?us-ascii?Q?7m7Pw3uOG8OS1dvgk6k5MNySGx4SJwFlMw2CXmww?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b769ecf-7ad1-4278-b931-08dbd0107582
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 19:28:51.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UpUhDL7JAb9zoxR5AXsEg77m68I3HxSzRI2VGCVOSLOK04You7hJ01dR9I+rUsJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4535
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 12:29:25PM -0600, Alex Williamson wrote:

> > I think this should be configured when the VF is provisioned. If the
> > user does not want legacy IO bar support then the VFIO VF function
> > should not advertise the capability, and they won't get driver
> > support.
> > 
> > I think that is a very reasonable way to approach this - it is how we
> > approached similar problems for mlx5. The provisioning interface is
> > what "profiles" the VF, regardless of if VFIO is driving it or not.
> 
> It seems like a huge assumption that every device is going to allow
> this degree of specification in provisioning VFs.  mlx5 is a vendor
> specific driver, it can make such assumptions in design philosophy.

I don't think it is a huge assumption.  Some degree of configuration
is already mandatory just to get basic functionality, and it isn't
like virtio can really be a full fixed HW implementation on the
control plane.

So the assumption is that some device SW that already must exist, and
already must be configurable just gains 1 more bit of
configuration. It does not seem like a big assumption to me at all.

Regardless, if we set an architecture/philosophy from the kernel side
vendors will align to it.

> > The same argument is going come with live migration. This same driver
> > will still bind and enable live migration if the virtio function is
> > profiled to support it. If you don't want that in your system then
> > don't profile the VF for migration support.
> 
> What in the virtio or SR-IOV spec requires a vendor to make this
> configurable?

The same part that describes how to make live migration work :)

> So nothing here is really "all in one place", it may be in the
> provisioning of the VF, outside of the scope of the host OS, it might
> be a collection of scripts or operators with device or interface
> specific tooling to configure the device.  Sometimes this configuration
> will be before the device is probed by the vfio-pci variant driver,
> sometimes in between probing and opening the device.

We don't have any in tree examples of between probing and opening -
I'd like to keep it that way..

> I don't see why it becomes out of scope if the variant driver itself
> provides some means for selecting a device profile.  We have evidence
> both from mdev vGPUs and here (imo) that we can expect to see that
> behavior, so why wouldn't we want to attempt some basic shared
> interface for variant drivers to implement for selecting such a profile
> rather than add to this hodgepodge

The GPU profiling approach is an artifact of the mdev sysfs. I do not
expect to actually do this in tree.. The function should be profiled
before it reaches VFIO, not after. This is often necessary anyhow
because a function can be bound to kernel driver in almost all cases
too.

Consistently following this approach prevents future problems where we
end up with different ways to profile/provision functions depending on
what driver is attached (vfio/in-kernel). That would be a mess.

> > > Another obvious option is sysfs, where we might imagine an optional
> > > "profiles" directory, perhaps under vfio-dev.  Attributes of
> > > "available" and "current" could allow discovery and selection of a
> > > profile similar to mdev types.  
> > 
> > IMHO it is a far too complex problem for sysfs.
> 
> Isn't it then just like devlink, not a silver bullet, but useful for
> some configuration? 

Yes, but that accepts the architecture that configuration and
provisioning should happen on the VFIO side at all, which I think is
not a good direction.

> AIUI, devlink shot down a means to list available
> profiles for a device and a means to select one of those profiles.

And other things, yes.

> There are a variety of attributes in sysfs which perform this sort of
> behavior.  Specifying a specific profile in sysfs can be difficult, and
> I'm not proposing sysfs profile support as a mandatory feature, but I'm
> also not a fan of the vendor specific sysfs approach that out of tree
> drivers have taken.

It is my belief we are going to have to build some good general
infrastructure to support SIOV. The action to spawn, provision and
activate a SIOV function should be a generic infrastructure of some
kind. We have already been through a precursor to all this with mlx5's
devlink infrastructure for SFs (which are basically SIOV functions),
so we have a pretty deep experience now.

mdev mushed all those steps into VFIO, but it belongs in different
layers. SIOV devices are not going to be exclusively consumed by VFIO.

If we have such a layer then it would be possible to also configure
VFIO "through the back door" of the provisioning layer in the kernel.

I think that is the closest we can get to some kind of generic API
here. The trouble is that it will not actually be generic because
provisioning is not generic or standardized. It doesn't eliminate the
need for having a user space driver component that actually
understands exactly what to do in order to fully provision something.

I don't know what to say about that from a libvirt perspective. Like
how does that world imagine provisioning network and storage
functions? All I know is at the openshift level it is done with
operators (aka user space drivers).

> The mdev type interface is certainly not perfect, but from it we've
> been able to develop mdevctl to allow persistent and complex
> configurations of mdev devices.  I'd like to see the ability to do
> something like that with variant drivers that offer multiple profiles
> without always depending on vendor specific interfaces.

I think profiles are too narrow an abstraction to be that broadly
useful beyond simple device types. Given the device variety we already
have I don't know if there is an alternative to a user space driver to
manage provisioning. Indeed that is how we see our actual deployments
already.

IOW I'm worried we invest a lot of effort in VFIO profiling for little
return.

Jason
