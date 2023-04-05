Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59B86D86C0
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbjDETVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjDETVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:21:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386DB4C12;
        Wed,  5 Apr 2023 12:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1IXgIpW8ZLAFdHsowMJVt67xxdhHmexjRC+LRK/F8g7x0Usv00FtP9AhZjoioReJdNP4JXh8J+vNnFwDpXEuf0PwaD584uk1xUb7lgNxylV9DcGIvMVSSlp8Hy91zIoMjG9gPuFc+NZmqBc0bVU3dxi2aHBpaX+LkSNwLt/HZG3RC37Nn+4EW8isxZBufIYu55CKxoutchhnJ88WGskP5xF+ve5gcEnmKr9G3CZGPUymCP1wU4kzu72wArbyiUe7WoNd2Hn13/apHTTVMiQoxZ8fVSTXJ4OjOkPNopmr3FGOuRawD8u4yyDcTMdZyqFsHxUZx6vXP8Uas7X/3lWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdw0LmH0tqeBKX64KBi3YUcWoFWx/PUDFHPRRT5LkSw=;
 b=lbRg3JxC6DWNFjH5s+Ud83az4vV2PwIq/3DvxuYV+qCkBJ3xO8kbfQfvq+/84CdIKGqIY1orgMpygXR2SYWYnwEZnnhvoMORdz36XXkZIp2+kRvcrKX6vYukE6iQlvXhahJ/lX9s/fVHYxO4sqZraz/6n1ds/iOhXxhce7kDuUVtNcONQkB1GDiP+1HkplM9vejp+GhcNm073Lu8lyhd5Cv4E2ZD8MWH1+w9AYHXJ3SMQZNHLud+3i5Ssx+cxIOdX2VIJQk5i+qf4eq9t/SMAwyl9henKERd3eLnOpx4MzmyY8UObRLvuvxuEoJHSJuRAANkh5zuuKrcQDrHNRuq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdw0LmH0tqeBKX64KBi3YUcWoFWx/PUDFHPRRT5LkSw=;
 b=asTCz9bcn3lOtZ87HOXy63W3P08QdwoLwko8rbwm9SqEEhjKQE1h45oPl9xqRJFbwWx/sMV43uINg7DetS0zA2tJBtej/lK1cE0F+lib1H1Gpyhoa7br8OYzZbtRLhxAkwpWqco1UVl6Ctx51NDjkO/EW2I8e4CL3S3LuI9LjV6Su1T9i6OavHighhpDrTbqlZja5nzlwQ6dvDUaWa9re8Ds9gUbuQj2melUzseH6MYxabqHWOH5jGg+Y123A4Q5WMTT3qQGGWq4s0PkmFmfSZuOSzoh4KWE5/U8goHoUi4j1sgXiLe6pd49fT4IjQLhU8m0e1jgGCJl9E/+k+fr7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6219.namprd12.prod.outlook.com (2603:10b6:a03:456::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 19:21:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 19:21:10 +0000
Date:   Wed, 5 Apr 2023 16:21:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZC3KJUxJa0O0M+9O@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
 <ZC2jsQuWiMYM6JZb@nvidia.com>
 <20230405105215.428fa9f5.alex.williamson@redhat.com>
 <ZC2un1LaTUR1OrrJ@nvidia.com>
 <20230405125621.4627ca19.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405125621.4627ca19.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0058.namprd20.prod.outlook.com
 (2603:10b6:208:235::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: d1705b4d-62b8-438d-944f-08db360ae9cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5vs7Snho8oKYH0k2jnENpurPEmra6vkIn7uW1BR8T+Ms13mXr5oz+LdlnJBNg4PvJl57AJBMiU7+ZlghgHLFK1C8aV2j7Yj3s34WmuUt4F0YEpgs4kqciFwLBJipraat4l0XhtONdf4UuDMyWLIrkPM11/Nta/WZvSHCAno1/nPoQJe1rLNXGjUKdayh+isI+cikm8Cx4ydsxTLY0FX4Sx2bUYJdNYR+jJm45sRnNk21bKp0c+CWqRcuI+yp4RSX6oMZhMls7BLqA6J5lhbAz7V3nWY1yNQFG9HQidzr3QLCJ6CweZw8FGwMvx9g15lP28ZGqFavJd6AsFHOJbI7TGEBw1wP22AF78JokbIBLyBHvft/Jx+DEvTIkJmQ/nVhGJE7i82SiH2BI89+g8ciwpz/d0F/i5I2cg2AJGb7jReBYUqH5lvPmaQnRFgvJL1j1qQ+eqs2BSuyZ7Wft7YnY7asqnWoh9IgnvlZzIRDR+mygiTyDS3AspYjTiZXkoI2N79v0jfhecbTuCCqlXM44YZ/SGSeO2vFe05ygx8t92NSlVRBqTucmsJ8T0GrrVZpJSv2g4vGFo3va3rWFTynE0pNT84YxcYYf6qrEmdFBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199021)(26005)(478600001)(2906002)(186003)(6512007)(2616005)(6506007)(36756003)(6486002)(83380400001)(6916009)(38100700002)(86362001)(5660300002)(316002)(7416002)(41300700001)(4326008)(8936002)(66476007)(66556008)(54906003)(66946007)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OSsdz1vMQ7s7khzz8QITyK/leW1inCNZxrOSR8cSN4rpoQzeIb4PhiF9AKxR?=
 =?us-ascii?Q?106T8PbP4tCZ3KcgTn1Gn1RMG1GBXVhFH6CKfOX2vEeAFAohzzNa0g4edzri?=
 =?us-ascii?Q?+dnN0o+3zdcvHXE8b8q5f54jchYFX8ayriN1183IXUo/RT8fTdf4SeByaXP3?=
 =?us-ascii?Q?Sr4wXoPuGalvf8wanJtkBKB3RN8vJliiDWe5kFmyytamPUGb6VT0XoGZfaBB?=
 =?us-ascii?Q?TxLiKHpyO/Ot4NAhPwAJxpFDheDB8nh1n+p5umUw15G0UeDpErhXUD1cNNHq?=
 =?us-ascii?Q?AI+gKkuBTmFEJ10z3naSUvsPXflhfGNsbmhDDe4qmz9+OKLHLgWUY1kv0+uU?=
 =?us-ascii?Q?yqK+qPXsPAeYCUrvRXfMjYFj4u9DmoAGVMkoLnBztuk0g/o7RQ8BnRYU1Q+K?=
 =?us-ascii?Q?19LLTbHlVz77/4t5Nh9RPgYx6ZfJChaFmmLl9B1M2YXCuvnHO49/Z+gEKJ3w?=
 =?us-ascii?Q?m5GzGG06NwOKEcEyarwBagTi/HCtArRifOOwKy34PSMyJ9psCZDULlTyAQQi?=
 =?us-ascii?Q?W8Ot7XGrv1jB/NwRwjQb7PvE10bglsnQIaDC1Yd7TWs+Nqc7lT4gEI5VO7z9?=
 =?us-ascii?Q?3FraFBJPDZO0FHKugtdVDmqOEAOe/l0zcTyPQAD5L5KjG4e7GWPYx+WagLRr?=
 =?us-ascii?Q?4uGmyKvWa/cQ1ybxDCyoFi3uOrLy3e5OE/kzLWqdPXctLkXWr1CDsCitW4ON?=
 =?us-ascii?Q?fWa2uJJxyP4/XXdQ9h1iZtaomY4q0eBBgljqxMzxN2L2u7+AINejkQIxjNrb?=
 =?us-ascii?Q?vwCoWpcrejF5IEdPwr0CeijD2rS//PN0IHrjiNc4PfMkEC6RpTIiFKHoVkFi?=
 =?us-ascii?Q?vqYJa06/0e0wOr6Xhb1CiMH7Fth6NKA6PLHVmPUdahZJ/UIMKVDNfZTbdgFJ?=
 =?us-ascii?Q?eNf1ddvKC9QDsfpqlNjyi8Te2YOmpLDMcBle+1CycWqZpoI5uV0Q5WtUN2Gr?=
 =?us-ascii?Q?plfsro7TOHJDhoUG+tay/PFybrlfxTkFwsmvJ8Gn+QJISOJTKl7RQr2SNS7q?=
 =?us-ascii?Q?jb2f61cK++5d1X1krJy5xygYMMfiUDqa6/1u8TULf8Ut2bXcykQySQ1r8fR1?=
 =?us-ascii?Q?OMS1wKJV6MTbdlrHQ8yF7wx98ccqRUfprt92tBuOq4mFCULDm7QHxRNIb3Z1?=
 =?us-ascii?Q?ulAfowYH1BJc6At+CnrRE9p5nfigbRqvSp7eJ0+CSee5TGRdEtNgQ4o9ZM1C?=
 =?us-ascii?Q?exuzbZ2N1CnDwDWLjmonB7OqXP6PCymOnSALUay9KVYvCZP4ku3vIfpqBk6Z?=
 =?us-ascii?Q?8v7nuSGF/cfa5T2CdLJllXg4X1QadAfY6Ibr1LkVUQAF2/0Uz0JcLXcUBbg/?=
 =?us-ascii?Q?ppTWfzAtMb+ZEbAgqvxlvUesQpC3fVVqaOUZIzkmPMqL/eG7vJV899LFQF8s?=
 =?us-ascii?Q?ZW7yToEB3WHjQSHqtr5P8AEtRkkcp6aDFmGYxgA1UcV94U5f28w3BIGNmXCn?=
 =?us-ascii?Q?++VUz3aOIZXjNh52mA9rnvjlf9o3FxTVezG8pkh9HNk+4dJU6OFJ2HfjSLlB?=
 =?us-ascii?Q?bRghDrIR+r0opfyXC8GcCJADguxT8o/zRz6Ys5vOc/UJ7ESjjbIS+UpWejKb?=
 =?us-ascii?Q?Ld1nVpPisF/D4vsxDVmh1+zGhbdobXRBp3Zj7Oqr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1705b4d-62b8-438d-944f-08db360ae9cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 19:21:10.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1Nwx3pRmuTboMDXXit9alk3OfWPa6eFraOCqUH66mmNNGIaNfglvanwsJIfZy49
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6219
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 12:56:21PM -0600, Alex Williamson wrote:
> Usability needs to be a consideration as well.  An interface where the
> result is effectively arbitrary from a user perspective because the
> kernel is solely focused on whether the operation is allowed,
> evaluating constraints that the user is unaware of and cannot control,
> is unusable.

Considering this API is only invoked by qemu we might be overdoing
this usability and 'no shoot in foot' view.

> > This is a good point that qemu needs to make a policy decision if it
> > is happy about the VFIO configuration - but that is a policy decision
> > that should not become entangled with the kernel's security checks.
> > 
> > Today qemu can make this policy choice the same way it does right now
> > - call _INFO and check the group_ids. It gets the exact same outcome
> > as today. We already discussed that we need to expose the group ID
> > through an ioctl someplace.
> 
> QEMU can make a policy decision today because the kernel provides a
> sufficiently reliable interface, ie. based on the set of owned groups, a
> hot-reset is all but guaranteed to work.  

And we don't change that with cdev. If qemu wants to make the policy
decision it keeps using the exact same _INFO interface to make that
decision same it has always made.

We weaken the actual reset action to only consider the security side.

Applications that want this exclusive reset group policy simply must
check it on their own. It is a reasonable API design.

> > If this is too awkward we could add a query to the kernel if the cdev
> > is "reset exclusive" - eg the iommufd covers all the groups that span
> > the reset set.
> 
> That's essentially what we have if there are valid dev-ids for each
> affected device in the info ioctl.

If you have dev-ids for everything, yes. If you don't, then you can't
make the same policy choice using a dev-id interface.

> I don't think it helps the user experience to create loopholes where
> the hot-reset ioctl can still work in spite of those missing
> devices.

I disagree. The easy straightforward design is that the reset ioctl
works if the process has security permissions. Mixing a policy check
into the kernel on this path is creating complexity we don't really
need.

I don't view it as a loophole, it is flexability to use the API in a
way that is different from what qemu wants - eg an app like dpdk may
be willing to tolerate a reset group that becomes unavailable after
startup. Who knows, why should we force this in the kernel?

> For example, we have a VFIO_DEVICE_GET_INFO ioctl that supports
> capability chains, we could add a capability that reports the group ID
> for the device.  

I was going to put that in an iommufd ioctl so it works with VDPA too,
but sure, lets assume we can get the group ID from a cdev fd.

> The hot-reset info ioctl remains as it is today, reporting group-ids
> and bdfs.

Sure, but userspace still needs to know how to map the reset sets into
dev-ids. Remember the reason we started doing this is because we don't
have easy access to the BDF anymore.

I like leaving this ioctl alone, lets go back to a dedicated ioctl to
return the dev_ids.

> The hot-reset ioctl itself is modified to transparently
> support either group fds or device fds.  The user can now map cdevs
> to group-ids and therefore follow the same rules as groups,
> providing at least one representative device fd for each group.

This looks like a very complex uapi compared to the empty list option,
but it seems like it would work.

Jason
