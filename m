Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592F05136C9
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348291AbiD1O0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbiD1O0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:26:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B709BAFB22
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeDO8NkpWKYr/za2W/9+EaVfvVHDvDd8+lI2kBPaFnuw7i0DZo9yzzz2tqPjU1BMPtU3KC1dsibCVPcNX24OJ/7SvdJ7UQKp51wtiq78KTt+LIyu48XmrSBpvhuHNap86UV4PKYVZIIFwefms8vUXgsUHNdKtCY3HedSmL7kRAYYs72f0sNMzKB/ltqp0Z/jlf6cQ4v9o1Qr84LT8H5jJqSZk9zZlK7y8mCQxA7aHAquYd/HA9s1nx/BO0JVGIibGsEnUAdAhPIEavIVQqfFqhcc8jwdHcQx1gAMpyKKCNFNm+OOKXUSjdqm/IWoHLOOBKqBwGL/q0ttyh6wCfdvlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXwEZsZkUzVi8TJfASyT8qJJpwpgyj67V63nNrOOLnc=;
 b=X3BuW2oT+VRCtIXQlZo6eDqNj6ohfoL6YEEiySx8VxqINRRkDiIUNaKEXHKSXDYcYVttp8A2eRyTznrena9PS050ziB+8FpWXQo/L9GuURSzWNVW5fC8U3LTo3kMY7PQAZIoa6IcF22qCNIRqOs1fECpouYd1K8CeEvUvk2xpjZyrRipESCqHnxKvHjWM+VgwCMZ8Y69X5P7TTWbWwRX/Sjg1xVx20ZcdUop9TTOkjDPjrqZq60etqr0zPD6qu6Q4m10HO8okzMnp91CGaHehfNhjMmvoM2Xapj2G9qiaW61R00I1unFhSlVbdPZdJBVr1coCBv0G5w1lqLD66o4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXwEZsZkUzVi8TJfASyT8qJJpwpgyj67V63nNrOOLnc=;
 b=Qu5FGYiTzm9WM4KF6JPiBF4/7b72/CWpAnwT7zVQrkYpFhMSL1n+hCEbIz5HlzLQ6kN0f9AEdoJ0vm2E8jevonHHLUyazcVxuq+yivKrJYlgUfvoPGGZh4NSkUK+u4GdIxtmRWREC8JSbMIU3/pHuHRT6zpqk9MjwuadAwR4vEmOEkAG/GhxoTgxnSvLNKOdBNl7UsxcFFD0knMaeBJlXKc5fby4Yton6gDtO87/okkUzBGz8Pnjz/mhM7of+B4CI2BoiS9JR+zuJl9Ggb2EEK27qtyaTV4M9Kur3WgdGfB8zpk+SW/B4U+TINQfjgyyhTE6/TPyq7FdvkwWf7ttWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Thu, 28 Apr 2022 14:23:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 14:23:00 +0000
Date:   Thu, 28 Apr 2022 11:22:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220428142258.GH8364@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <YkUvzfHM00FEAemt@yekko>
 <20220331125841.GG2120790@nvidia.com>
 <YmotBkM103HqanoZ@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmotBkM103HqanoZ@yekko>
X-ClientProxiedBy: BL0PR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:207:3d::49) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0fd49bb-e250-4ab1-d0ec-08da292298e2
X-MS-TrafficTypeDiagnostic: DM4PR12MB6012:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6012447B53B36D3009EFD999C2FD9@DM4PR12MB6012.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RckdZitU+/jBx8RkjQUviY4js/EmErLUwywi9jz3lTSxYfRK9lp6PN2jFNdH6a9qib83DRfqhia7FHnJowfNcPZw31UaBzdAYWAjBBoCW9PN7baqoB43FQUTMcAyLWo+j6E0yIKeDuRCkAqzhNRmZYPmSjmuBg8fg/w/+xiHs4bCdGBrgRfo7gfZoWnWRglCYUusG4wWufyhlM07qbYrOjUR5QO38w1K+TMZs7CSiTdTeAcDX8pvN5xS/34O3q9ugnr71bhIJ5gmnte5lBOLVa1aQ3WRJ85Q+DJ1wHKWiYCY7N0yZdJ86/H9rDSGNFlET/m/pyWbns6q0ekMJ/sN+rBOOkJCENzyvosVARH21Gxo+h79m8LDjzaLFygXw3YMSrvkiXjFepK3jKIR5A+cjET4Gww4jkATr/+S/pAac8JO7h1xGvhiKvJ7MPKJg5jvM/WtDtvrV/M25M1ws0nJhsZXwXN1YYe1q3+1I7YzhSsV4BFqUcM0CpDP3Nm/ouDpW39FgJiXtdhlttCYptrZCzgZNZkvUt99ph8kcuSrg0XvWS2xe31iA51xPW/8cBKyknIPKIDxigrqVubY4pQLevQqS0MPfHj02lBdINW3glNeWe6c7LHl/txfuwQB5XHGVtOKZ3NfFCUlzs2dARtF8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(186003)(38100700002)(1076003)(508600001)(36756003)(8936002)(6486002)(86362001)(54906003)(6916009)(6512007)(33656002)(7416002)(2616005)(83380400001)(66556008)(66476007)(5660300002)(6506007)(2906002)(66946007)(8676002)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G1yD1d7H3W4feB5a6UxAnkFmiMnkF26fXizX05CJgQfqeHxL4hPU+rvd96F6?=
 =?us-ascii?Q?sYUSkvqFPC7d/ITrK21gNoyvYCuwpzNhPtUfz93N1LMOqUIZ4Id91yQtAwU0?=
 =?us-ascii?Q?X9bk1QXw7hLH2j9NMtlyjaxg6LIdx128+HiMIey/N5C4RZBANDAyIV7XdwC6?=
 =?us-ascii?Q?dxplE9kitruPH+XdgZoOeO3QUsdUTO+tQIa4fAQVQoo1Hupe1OM4nlKltfN4?=
 =?us-ascii?Q?lbEgrph0GXbqFk3RRir1+cIIPH8GuO9vfELqgJbuVJHPn+C8lgfdFv4plRWQ?=
 =?us-ascii?Q?1SEOZJXaGUvoPUpaEx7eOs82iXCX0RIHgSqJmvx/Imb36ZqTSref3s3Na452?=
 =?us-ascii?Q?1kPEwAZ3RRLM7voM0pj6CFAyf5FSoVMIVuNIyfeG+YsiEK1wJddE2Wf7+UF8?=
 =?us-ascii?Q?aM0nLy4ZrRG33wZJsVvzFSTwcYP0GrGm5rbMIwq+8Hi5bZ1zVbfpsRDkNRm9?=
 =?us-ascii?Q?jY58D/i9FigIDrR+7MkYlOeHRNV667/nXBaaMt5JgZVFLtxd0kNCNp812nZN?=
 =?us-ascii?Q?zNSbNXNQMnI1J5dOxtuoCnL+rHSeGf4zib2MLhbLe3YhU45LGv/9FlLC0rMb?=
 =?us-ascii?Q?J8XspZ700gk9caAF5+Jk/C9WiaxOhY4oxpklIuBTCqaj7qCFV37MzzA4NZnD?=
 =?us-ascii?Q?ZsZPe3Wzl5v+yIndVzBVvQWbAgeWbL4Dw1aWtNm4z0jTxP/aJdt2VOQ89dxm?=
 =?us-ascii?Q?UQTitH7ui2p0URhnGritgGog+I93OaOb2ULkULOUdkOMW0wjigtIIQTP2lqR?=
 =?us-ascii?Q?X/hQtbl6y0aqmdnY8AiUcaM+928G9XS4HxwZD3r8ybqPrz5+qnl9LeTakUFy?=
 =?us-ascii?Q?uv8D4bwIMOaIJFNbQRtwDNGUr/Dlcvb7KY4v6HfRypq48G7TLoLKCWJJt3Eh?=
 =?us-ascii?Q?D1kFL40YuLyMHYGYe/w3wrWSo+rD6ssSIZlOpUTjvdjLNC9Bme/3v4+CzRrH?=
 =?us-ascii?Q?3uagUYpoUlaknbaVvRuIbc7447iwKeV6vacx4tOEDoGj8Fz+UTszSP+sj+e7?=
 =?us-ascii?Q?tr6Ttac7LlM+gx/la7wL4nNTz5V5GaZ/xWej48GfaH+IutuioOXq+YXGPv0b?=
 =?us-ascii?Q?2BOxO2aqNcuadzAlo2rLb4iVVnwKo7rmJGjz92dNRyhfcv3BVp+io0lJQv1j?=
 =?us-ascii?Q?rAZV1uNS4oULayYGDuKitv1HFNjLLs4DTescipQufGwxbexWu0AcG67KYfq6?=
 =?us-ascii?Q?3bEjVv/uQDkrv9C15zg2tVI01x7VbXR6VM7Weji6/vKju8J4t8mQRqUSulD8?=
 =?us-ascii?Q?UzLXcsZyd+beDO3ve9C0TgoRdkR5k2kvKN3tLGXUIO/sQj667dafEE03SPiG?=
 =?us-ascii?Q?19/OERHu53w1E+MBx1HBJnCsX4cYTOB/4uI3TZ+VYuYSEuDjsjuUQaW5Rp7S?=
 =?us-ascii?Q?YMGcnQjodsIad9SkzDhS8RYlGDBjHg3KnECtx1kwcwYOXlLacen5Ius+1tHP?=
 =?us-ascii?Q?QyYuAVWqCAMbaXCQnp3lh8owpJM86XoIclOir+MJgJcvyYtt4qQSaFzgavf8?=
 =?us-ascii?Q?vfLoGlDDz13uOF1avJ1/vTXp2iDgZj8DOcdvGhtZ+CCD7V0BuKnPLM25iAmK?=
 =?us-ascii?Q?vVjKTVvP0acDFmKKqlzuOTWdg/i8kv1mPfxZNWraw4uGT1esWwxrhNX56m6J?=
 =?us-ascii?Q?0Zg6ATYZiHD8VV3QQNzphixXIR3fM7EaDNIhunScWGxrukGo98dfU+ZmWVoz?=
 =?us-ascii?Q?p9U2GToVB/TzW6PKQqPYV58XGfRYu1tNrgUPequP3GW+SH55urE04aszFUKj?=
 =?us-ascii?Q?/qgbxf6/MQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fd49bb-e250-4ab1-d0ec-08da292298e2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 14:22:59.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCzAMhx2yQuXXNFhA/GQk9pKuXy5p2UyQQZhpYvsPq6SInpoRQYq5AhoG/x0yDZM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 03:58:30PM +1000, David Gibson wrote:
> On Thu, Mar 31, 2022 at 09:58:41AM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 31, 2022 at 03:36:29PM +1100, David Gibson wrote:
> > 
> > > > +/**
> > > > + * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
> > > > + * @size: sizeof(struct iommu_ioas_iova_ranges)
> > > > + * @ioas_id: IOAS ID to read ranges from
> > > > + * @out_num_iovas: Output total number of ranges in the IOAS
> > > > + * @__reserved: Must be 0
> > > > + * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
> > > > + *                   of out_num_iovas or the length implied by size.
> > > > + * @out_valid_iovas.start: First IOVA in the allowed range
> > > > + * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
> > > > + *
> > > > + * Query an IOAS for ranges of allowed IOVAs. Operation outside these ranges is
> > > > + * not allowed. out_num_iovas will be set to the total number of iovas
> > > > + * and the out_valid_iovas[] will be filled in as space permits.
> > > > + * size should include the allocated flex array.
> > > > + */
> > > > +struct iommu_ioas_iova_ranges {
> > > > +	__u32 size;
> > > > +	__u32 ioas_id;
> > > > +	__u32 out_num_iovas;
> > > > +	__u32 __reserved;
> > > > +	struct iommu_valid_iovas {
> > > > +		__aligned_u64 start;
> > > > +		__aligned_u64 last;
> > > > +	} out_valid_iovas[];
> > > > +};
> > > > +#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
> > > 
> > > Is the information returned by this valid for the lifeime of the IOAS,
> > > or can it change?  If it can change, what events can change it?
> > >
> > > If it *can't* change, then how do we have enough information to
> > > determine this at ALLOC time, since we don't necessarily know which
> > > (if any) hardware IOMMU will be attached to it.
> > 
> > It is a good point worth documenting. It can change. Particularly
> > after any device attachment.
> 
> Right.. this is vital and needs to be front and centre in the
> comments/docs here.  Really, I think an interface that *doesn't* have
> magically changing status would be better (which is why I was
> advocating that the user set the constraints, and the kernel supplied
> or failed outright).  Still I recognize that has its own problems.

That is a neat idea, it could be a nice option, it lets userspace
further customize the kernel allocator.

But I don't have a use case in mind? The simplified things I know
about want to attach their devices then allocate valid IOVA, they
don't really have a notion about what IOVA regions they are willing to
accept, or necessarily do hotplug.

What might be interesting is to have some option to load in a machine
specific default ranges - ie the union of every group and and every
iommu_domain. The idea being that after such a call hotplug of a
device should be very likely to succeed.

Though I don't have a user in mind..

> > I added this:
> > 
> >  * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these ranges
> >  * is not allowed. out_num_iovas will be set to the total number of iovas and
> >  * the out_valid_iovas[] will be filled in as space permits. size should include
> >  * the allocated flex array.
> >  *
> >  * The allowed ranges are dependent on the HW path the DMA operation takes, and
> >  * can change during the lifetime of the IOAS. A fresh empty IOAS will have a
> >  * full range, and each attached device will narrow the ranges based on that
> >  * devices HW restrictions.
> 
> I think you need to be even more explicit about this: which exact
> operations on the fd can invalidate exactly which items in the
> information from this call?  Can it only ever be narrowed, or can it
> be broadened with any operations?

I think "attach" is the phrase we are using for that operation - it is
not a specific IOCTL here because it happens on, say, the VFIO device FD.

Let's add "detatching a device can widen the ranges. Userspace should
query ranges after every attach/detatch to know what IOVAs are valid
for mapping."

> > > > +#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
> > > 
> > > Since it can only copy a single mapping, what's the benefit of this
> > > over just repeating an IOAS_MAP in the new IOAS?
> > 
> > It causes the underlying pin accounting to be shared and can avoid
> > calling GUP entirely.
> 
> If that's the only purpose, then that needs to be right here in the
> comments too.  So is expected best practice to IOAS_MAP everything you
> might want to map into a sort of "scratch" IOAS, then IOAS_COPY the
> mappings you actually end up wanting into the "real" IOASes for use?

That is one possibility, yes. qemu seems to be using this to establish
a clone ioas of an existing operational one which is another usage
model.

I added this additionally:

 * This may be used to efficiently clone a subset of an IOAS to another, or as a
 * kind of 'cache' to speed up mapping. Copy has an effciency advantage over
 * establishing equivilant new mappings, as internal resources are shared, and
 * the kernel will pin the user memory only once.

> Seems like it would be nicer for the interface to just figure it out
> for you: I can see there being sufficient complications with that to
> have this slightly awkward interface, but I think it needs a rationale
> to accompany it.

It is more than complicates, the kernel has no way to accurately know
when a user pointer is an alias of an existing user pointer or is
something new because the mm has become incoherent.

It is possible that uncoordinated modules in userspace could
experience data corruption if the wrong decision is made - mm
coherence with pinning is pretty weak in Linux.. Since I dislike that
kind of unreliable magic I made it explicit.

Thanks,
Jason

