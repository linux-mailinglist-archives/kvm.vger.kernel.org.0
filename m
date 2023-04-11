Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5796DE411
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDKSkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKSkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 14:40:16 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096DAED;
        Tue, 11 Apr 2023 11:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx9CAI23jsxvds3ik7RXfjC2JMxuZwkFnmdFx/x/o5MNZEBLgpWd3RG1QBv7VVB16+o+Mtfvgh2H2rpwAXGfJ+lYdM2Rakq3+t1W7UWVZYMUAuenOzbULd7Rir97M35dn3zoF1WzBxh5Tm6AN0wy14Wc+QIo9HLIfF9SDDJnHTDAZf/+s5toK9fmWE1v6flmj+5UD6yEUY3slY4l5s6gonXh/s/pkDmFBh7+VB816HijH8uTMpe+huKaEUrmxKHCRC4xEpimnHclSptOq9kxVp02uNaP5vFA9ZhVpddaZaeErsoTGcvdOeZ8RUuvm0pGx4WeU2jai0stymAO8pQggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1AZx6ZK9HJiQ6Pjljy9mdrHc7Ls8nEIg8nTVnw2w0o=;
 b=L/So9MMbhig1eJAkOHq0QpbuZRt4yop6wA6s+ySFK/PtFq1j7w8vavVht7PG/db2wxGMi+UNQApphoLxzfCLuuIz5HnKrgQe9KWCqdFzQIObJ6HL2UBt8vAsOfKmqz59xTMgxtKnh4t7LVNUL2cYbigzmOSQga+3ElsZppfRDR9eUjRZPzQE78Y/SNYDj28xbbGNJ2NQIC88BZmR9rJiowKu1slspxxAloZGMXa0iz1BILfo05/ZiYqIRCGLRBaol5jxj4jvgxOXaVTKn+D9nvrVUiyzBdK16kU7D3at/lTCLJ9RC7X6CZFFTMc/u6NZboM5Tu77OAVe7majJggC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1AZx6ZK9HJiQ6Pjljy9mdrHc7Ls8nEIg8nTVnw2w0o=;
 b=Rw0hT1AdjTpmqU6blp3+5cbFpcID4WP3vcMq8AtNP1FcDVF762hB4jYATHiifZ1R6US0iMku7Y7xq5Xh8lZamtxdEvXEQdcbPyWRXsI6hizSZBMGUNM9gg9MJsyzHCOvxOkQanOKwrA6El82sgtGy6+clmaJHIMsTWTHXopDYS9J3QyarznbpMW/NhKmQqQUQpcTY4oDoJB0wSMRHLHKde8TkI8KyJmS3bhSMTPudLa/sGYJDvO3El/j90hNEyydf+JizvOenTQfFg5vyv57ztodRdLTyXEDGfUSTpuyWDlojGuh3tr9TGCVY46heJ1HLzbU3X/jEWB/aDQxflLqzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:40:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 18:40:10 +0000
Date:   Tue, 11 Apr 2023 15:40:07 -0300
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDWph7g0hcbJHU1B@nvidia.com>
References: <ZC2un1LaTUR1OrrJ@nvidia.com>
 <20230405125621.4627ca19.alex.williamson@redhat.com>
 <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411111117.0766ad52.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a866088-089d-4a39-ba11-08db3abc2da5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFvwDq03eqcxCizTg82YCCKDHpB4DujoBzViOXMLogr53F4MlqOoCvFQNFUvwqQXtpUbR0qAlnnHgyVXS+HeBqn7uQbjjaakT7w+f1981y7N29OrIj5B/cHuVlhmwuHaTKbdoiGN1EnTZPXtH6cmIpbAMAhIQazRmu1aa0FCBIoK1WEVrHo/vmnTVtDbk5h5NKXBu2SGp3wjUldz/MZFiHZfdJPZl9UgICn93SjhzCVp2q3m55xbGJTTl4/gwR7eCa40cm9u/Qjs66IuBhsM24bhX6I/bbdmmm+2pBKs2dXfdJJ88a7TvsfDhxMqQXfh8d+jbg6qFx1Ye/DbgSEP6FDMYB9O+n95WF5GPMjy38x73OOY+AMm/MIeZgD6GL4t7CeyeHMWKw77JG04r6eZNifwEYap4hRHanEUMn9FwKyJdyuBJo8M+nQv5swRrR7ZBGGWvFLBTb41AFxngr9fpYGpduEIzd991dvuciioIrLg0IwlM0DrBun6nWiATkb7CHZTASHd2lDgHvqEHs8Zapva8mmzX6dCS24Y0NNc8+V3cszQHlIlefpre53shl53
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(8936002)(6666004)(66899021)(7416002)(6486002)(5660300002)(86362001)(66476007)(66946007)(8676002)(6916009)(4326008)(66556008)(478600001)(38100700002)(54906003)(2906002)(83380400001)(6506007)(6512007)(186003)(2616005)(316002)(41300700001)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrYmc9nXudrhT2OKTNSh4VouI+HL3f0yR447cEI3CFFrLJXehZwhP3EqxKvG?=
 =?us-ascii?Q?1U4rukMi7B6sP4ugRN3Dtrh9YvQ5AZH3Q0VrQCFZqF+K0T2kMJ+zA3zw6Y+T?=
 =?us-ascii?Q?JTco6mVCTpQeUzpeFRttv3A/n2wL14ZNG45m9Bwae7Q6DS1i82A4yH2Z6hij?=
 =?us-ascii?Q?bjeey1yH1BJHWL2ZMPa2j8d24CQtoeDnoolCCXz/b6VbS+Utnmx5EySJ3AZg?=
 =?us-ascii?Q?EIfxCxj6hbY2pMMoz35e94lXjrx+dZoCzGyOmKOhIZecqrP12TjUmI7ux/jI?=
 =?us-ascii?Q?t3+lAujiCDnPFKmYkO8CWz7mhcQll5pLC/twXKDB17O1bJVM2M7B895Nu8sp?=
 =?us-ascii?Q?5eBSPWqDqrFfDtHapQLzQpgtYosGW3oMzKHAQ36hhz9wJYsW/V58Dhe6fRrh?=
 =?us-ascii?Q?GDf+8dNkzVXJkbRm4DIGus5/g08RDicV18YnneEB4H+J0HOK503Vjkmt0gga?=
 =?us-ascii?Q?3xYlHKprna0OT4jNdouYv8ZM4AQjbB7avkbVqvMCA14NAszvkTybKAKykYWz?=
 =?us-ascii?Q?ohO8U+IiwaL8SQ64Ru7yoY3jE/XSAuHgZa7pLFH7Zrsfy3ICFWERpoH/IzHh?=
 =?us-ascii?Q?OJm+rZVAEiGN0DDhTJompL/mHU0QmjbSGSGiuVtpJ0eEk+bT9w6W8U9/8J6E?=
 =?us-ascii?Q?TYTkLLhO1BKSX9PNwG1bPWtzFF3Rsc62XR3owO/U/ZNYSe/HlkhLoQqO4beI?=
 =?us-ascii?Q?DdhKzxc7/i2IaUgl2dy9+2gOI1TRFD5Dll8nKX5VF7A4PlPsEkh41Fxt0PKf?=
 =?us-ascii?Q?Gvs6ziXX+1YSaqFPsw696+YdU8dvYbJPN7OE1cRQM6AvSVXUC3Q0bE0T73vN?=
 =?us-ascii?Q?zO6IZjQC1Pd6X3uCCMN3ctXgm/pYn8QpIZoI9/5eKRiU4ju3c39ByVrBFOwM?=
 =?us-ascii?Q?rBRxeVNBqnaX4SAbAPV41eJ/eIhtO6FzZ/Hx65nFtVtGgC26E3tXqtV8bI6g?=
 =?us-ascii?Q?ZwuxCbBF4RyNL0H8wXcc0k0QFr3q4K5SDZZfyE5FrqSPGfexPWKu3rRdGH/B?=
 =?us-ascii?Q?0xApKp4Q281Pd1fbS7fC5bE5VLni98fETezoTMYXcWvgcM3frRgUMNAY1exb?=
 =?us-ascii?Q?Ubg5NvluHr7IqMpgjVraXQGt9QtqoFENA7QJQxvKCOSPOdk35kyv/iigNAg/?=
 =?us-ascii?Q?0D7LB6E4yj2srI2Ssstk+G7ujdi0vuVwi/91t6UhJXxLHC+5aLDA8Xyu5VDN?=
 =?us-ascii?Q?7FyaYlajQpGhaOOm3FJlEpfoLIUIfah/2ETfOks5FLNF9zACT+qe0tzBo/DM?=
 =?us-ascii?Q?WC72SAmvwJ0MFQyuwUqj/+tgS3dddDj6kjSG5HXqErq80rDGT1nsl7ZQDxnP?=
 =?us-ascii?Q?ILCZYLzZ+4da/mWFMAxAFOktHFF0ckujZmtVKSz7lBEYqD6c8r6TAN+UZCn/?=
 =?us-ascii?Q?dVDRt4VQ8kJYSFJiRjsOAMIpknThlcTU2zcyGxSLcpXoyknZ+eW65Jzhj/qy?=
 =?us-ascii?Q?iYIvhHMGLIW1Bvk7m29A6Rq5sRI2mdas1DhH0LN15omECo4HPM+Iyhh1s+In?=
 =?us-ascii?Q?7mXQrrUOraCz5HGxFlWo0LkhS9sYRSsYzj1s9z2Ek1lwQ/SkMwdwU0SzPR9h?=
 =?us-ascii?Q?xNkxASB31QuijxQ8ZDijkzptUnRmsODtD4A+rLvC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a866088-089d-4a39-ba11-08db3abc2da5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:40:10.1106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQkJLuFki7GXzw5zinfQNM+5C4Y7qvIZdUJM9/6OmdHWYJXO7h7SNDdE1q3Y480k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 11:11:17AM -0600, Alex Williamson wrote:
> [Appears the list got dropped, replying to my previous message to re-add]

Wowo this got mesed up alot, mutt drops the cc when replying for some
reason. I think it is fixed up now

> > Our cdev model says that opening a cdev locks out other cdevs from
> > independent use, eg because of the group sharing. Extending this to
> > include the reset group as well seems consistent.
> 
> The DMA ownership model based on the IOMMU group is consistent with
> legacy vfio, but now you're proposing a new ownership model that
> optionally allows a user to extend their ownership, opportunistically
> lock out other users, and wreaking havoc for management utilities that
> also have no insight into dev_sets or userspace driver behavior.

I suggested below that the owership require enough open devices - so
it doesn't "extend ownership opportunistically", and there is no
havoc.

Management tools already need to understand dev_set if they want to
offer reliable reset support to the VMs. Same as today.
 
> > There is some security concern here, but that goes both ways, a 3rd
> > party should not be able to break an application that needs to use
> > this RESET and had sufficient privileges to assert an ownership.
> 
> There are clearly scenarios we have now that could break.  For example,
> today if QEMU doesn't own all the IOMMU groups for a mult-function
> device, it can't do a reset, the remaining functions are available for
> other users. 

Sure, and we can keep that with this approach.

> As I understand the proposal, QEMU now gets to attempt to
> claim ownership of the dev_set, so it opportunistically extends its
> ownership and may block other users from the affected devices.

We can decide the policy for the kernel to accept a claim. I suggested
below "same as today" - it must hold all the groups within the
iommufd_ctx.

The main point is to make this claiming operation qemu needs to do
clearer and more explicit. I view this as better than trying to guess
if it successfully made the claim by inspecting the _INFO output.

> > I'd say anyone should be able to assert RESET ownership if, like
> > today, the iommufd_ctx has all the groups of the dev_set inside
> > it. Once asserted it becomes safe against all forms of hotplug, and
> > continues to be safe even if some of the devices are closed. eg hot
> > unplugging from the VM doesn't change the availability of RESET.
> > 
> > This comes from your ask that qemu know clearly if RESET works, and it
> > doesn't change while qemu is running. This seems stronger and clearer
> > than the current implicit scheme. It also doesn't require usespace to
> > do any calculations with groups or BDFs to figure out of RESET is
> > available, kernel confirms it directly.
> 
> As above, clarity and predictability seem lacking in this proposal.
> With the current scheme, the ownership of the affected devices is
> implied if they exist within an owned group, but the strength of that
> ownership is clear.  

Same logic holds here

Ownership is claimed same as today by having all groups representated
in the iommufd_ctx. This seems just as clear as today.

> > > seems this proposal essentially extends the ownership model to the
> > > greater of the dev_set or iommu group, apparently neither of which
> > > are explicitly exposed to the user in the cdev API.  
> > 
> > IIRC the group id can be learned from sysfs before opening the cdev
> > file. Something like /sys/class/vfio/XX/../../iommu_group
> 
> And in the passed cdev fd model... ?

IMHO we should try to avoid needing to expose group_id specifically to
userspace. We are missing a way to learn the "same ioas" restriction
in iommufd, and it should provide that directly based on dev_ids.

Otherwise if we really really need group_id then iommufd should
provide an ioctl to get it. Let's find a good reason first

> > We should also have an iommufd ioctl to report the "same ioas"
> > groupings of dev_ids to make it easy on userspace. I haven't checked
> > to see what the current qemu patches are doing with this..
> 
> Seems we're ignoring that no-iommu doesn't have a valid iommufd.

no-iommu doesn't and shouldn't have iommu_groups either. It also
doesn't have an IOAS so querying for same-IOAS is not necessary.

The simplest option for no-iommu is to require it to pass in every
device fd to the reset ioctl.

> > > How does a user determine when devices cannot be used independently
> > > in the cdev API?   
> > 
> > We have this problem right now. The only way to learn the reset group
> > is to call the _INFO ioctl. We could add a sysfs "pci_reset_group"
> > under /sys/class/vfio/XX/ if something needs it earlier.
> 
> For all the complaints about complexity, now we're asking management
> tools to not only take into account IOMMU groups, but also reset
> groups, and some inferred knowledge about the application and devices
> to speculate whether reset group ownership is taken by a given
> userspace??

No, we are trying to keep things pretty much the same as today without
resorting to exposing a lot of group related concepts.

The reset group is a clear concept that already exists and isn't
exposed. If we really need to know about it then it should be exposed
on its own, as a seperate discussion from this cdev stuff.

I want to re-focus on the basics of what cdev is supposed to be doing,
because several of the idea you suggested seem against this direction:

 - cdev does not have, and cannot rely on vfio_groups. We enforce this
   by compiling all the vfio_group infrastructure out. iommu_groups
   continue to exist.
   
   So converting a cdev to a vfio_group is not an allowed operation.

 - no-iommu should not have iommu_groups. We enforce this by compiling
   out all the no-iommu vfio_group infrastructure.

 - cdev APIs should ideally not require the user to know the group_id,
   we should try hard to design APIs to avoid this.

We have solved every other problem but reset like this, I would like
to get past reset without compromising the above.

Jason
