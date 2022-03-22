Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B84E4250
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiCVOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiCVOwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:52:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D4085657
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:50:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAldbMAvUT0UoP0QBseXTFt89RagMsxsQcHZNWq3A5GaZCFrWF2OCnmM9PgfoIcLI0F6Cb7/yYHrtMTvmntj9dcjIsadfTMUN//AhmbttwUoZTkgY0xJiQKLy7iNHBCZlzUr/2gTPHJtjElUSk36dtQdS1oWgAjUlhZF5ZEc4uc0lVytghYD1J0xuYnW1IaYck9ubcs3TTYA/HgwX3nMryiM9mE5EDXM9xFJFYioG7Yqszxi/MqaEFmhv66RJWZ6USss1CuG4/qI5f2H3xRT7UZNO6ZNvod0QqXgj6qiZ1YRLVcwEE+faQFmuLGX97T6FqbsdVGDhIW23bEvzngnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2Dzw6yW5aqNSQuCODrQ73eonfdC7hIG3aX1y7+JHDM=;
 b=g7dhQjDimQZKNVn+oiKb1U2U7n/4PgX9njSGz90Oh+kB6eZxkTvL/PaO+2HY45Gb7sRLB5IN2GMDW7SUJuzVZTz0MfNs/KyGj2RfWIyEJviX3+0Ez2PEVyQsQ5wIGN3Lzhj5ODER2banSWUQcG2pZRPM3Xc+xoV14mnIVJJle4SPJKv7Ec32jUHOpc8L8Bqb0Up4ueZZMERyMNRL5M9OTlwutacG0vnmIjL97lsq+E7sGJ4JVFiBOhOCzaMot46AIIrIIejarKEnevzwWoMnHZETePn43TPW2ew0lAnV7340NKin0NqDqdjjt/0t8nreH0zNyg+HUicLstBA6B594A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2Dzw6yW5aqNSQuCODrQ73eonfdC7hIG3aX1y7+JHDM=;
 b=Sjiy8AoHELu1JceasJR2H5+r88pM46nznZpZIaYgHBzTWm6ESvAAXfCOKBQh3TAej1EAS37UAKGRBhWnivvaBJTa6EbnluynDphRKSrec1ucqHuoep72lzT0ZPlvoXj8g/VHoaDwagpsmGe4zLj+jJ+97+UI0ROLpldsvHMDghsBeEJa/SGJVXO90fWHAppXXCjFgUxmWyzsRGXZ6zUYh9ECOcRNKdavM7rX8rYnV9I8HDRK3DlWkL68CP0XlytzBWhjNHdJC1LleFZ0k3j63liDLTcOwyJYjJqFyNrbckuwvDjFO8PKx2vluffNcArS48KPgkZZaX38c2ViLfOI4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1425.namprd12.prod.outlook.com (2603:10b6:404:1f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Tue, 22 Mar
 2022 14:50:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 14:50:37 +0000
Date:   Tue, 22 Mar 2022 11:50:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 03/12] iommufd: File descriptor, context, kconfig and
 makefiles
Message-ID: <20220322145036.GG11336@nvidia.com>
References: <3-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <5f1e2f85e45d7cc5c7cade7042a681186d3d7bd3.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f1e2f85e45d7cc5c7cade7042a681186d3d7bd3.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR22CA0010.namprd22.prod.outlook.com
 (2603:10b6:208:238::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 106c6912-ac8c-4b64-9503-08da0c1353c3
X-MS-TrafficTypeDiagnostic: BN6PR12MB1425:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1425425895841AA33EE8DBD3C2179@BN6PR12MB1425.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBzfMVh+BesCF5gxZJX7HUmxgnkTbFi3uxehE1eY/c/NEzb6Z0oOOdWAlXuhEAPZGSbuiH/03h9ruVG+/E8W2tm0Rs501hpNyBPOTDDWYbQi7PWxo97kr2Le86qGSgwkIHL9TrmVT/xU0yovrjAmROJC5rCRlyZ/Aq4SdPmOiKp5I/e2rjB4R2zAjN1Z+S2qpprOqLKmaV63TxviaewXuDAbJnlXOt2RurbBH3HRp3i+asqBmcXo4JZ64jNg+Z0W2U4ofFaPKSeJzDmrFWz+EoPC2zbC45okgh1SR+7bPE2tEk5ZGpxmscv4KDOXGuM2r9MLV3UEE6fQgK7UiV6VaTEk0MWA2UU+Q49JTtEZ9TQmk2VYQuO4TVvhYRzJTBxnSmCGCe9qT3lP1E0vi63YQxazW0gWPaHDjJIfq4mr6+HAUvvE/d0jOvn/NpIJgFb9HT/IAt24hgYWzBYKn9HDuQ9JF2ye+/Y/QOG7snX+Hcwz2oFTTRQ1j13qk59cjXKGEe7J/DVazfjEVePjVMpLvfUFHSwzrlxNSaNd5mZykcI3QU4dtPn6zCETXVDE0O94g0CIQuNsqe9OTSJ/a1Ck8SFucuUL35tS6gdZ60Oz3eD/PKkyyQUReEMgmgMUN+ANZfkbtPHZthmBrnNR6SBJgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(26005)(7416002)(1076003)(2616005)(6916009)(508600001)(83380400001)(316002)(4326008)(66946007)(2906002)(6486002)(66476007)(66556008)(86362001)(8676002)(54906003)(36756003)(6512007)(6506007)(38100700002)(33656002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gz00Nbc0GBVGuxaV6Nshna2z+8U1UJxiVEzzkzuoQCKX9GrYxor2VY51DHnI?=
 =?us-ascii?Q?WqcEQOYf2FpoIgEN+gSRubwG5UHQpsUUQgjAGve0x0a484/OPe35ySP0rH9h?=
 =?us-ascii?Q?DHdDN9aFtqg011AvaoQQ4+YI292m6czzmDO6ZGsA3XSBC89qf+vmVEw01+25?=
 =?us-ascii?Q?L9i92s7/eciSiwQo8mkIZ1xfLsU/yb7HRXtFky0tQVKIJtizn+3SDdR5/cWD?=
 =?us-ascii?Q?VG9d80ptsUZYnxkd4FDR0RdMj2njUNZ6W1HrrPGdalHTkipQF212ZA+tuUZi?=
 =?us-ascii?Q?fffwTok5nk2bIMNFnhq/kIjqmj15YiiDo37EtaSl+IbqzEkpJ7U2D8aFjroa?=
 =?us-ascii?Q?6/3Gh6E1XU5t+gHg0nNn5NUzIbQur4xShN0lKuF0dAEGq+9dd2/ni7CYCHAM?=
 =?us-ascii?Q?hZQQWri33f2PeK+6C/wlBgWnOg2q2uR2fGf9Ppy2pzaLND7RrgUygRVI0iwL?=
 =?us-ascii?Q?Dp1q8UpS8dBW0ipe40cU+emjcNFU1tvKEEz2mHdHAczb7gLptwMyGPSEmCQ7?=
 =?us-ascii?Q?EGTpz8mFLlSeq3X2sl3FXtB98togJ4xj0pqFNaOGwgz5cf9EG4VVzwRa+kZU?=
 =?us-ascii?Q?DZbdczerhKmYgN7A9QYArXle72zI+SlL2vp3cswE3QUpqJJy7Ux/5Bvj4E1Z?=
 =?us-ascii?Q?a6hKQGHMdNieKsV0IOW2ZHZaQzlonLtle550tAKQSZyrygCaC4Su3GDbrnvn?=
 =?us-ascii?Q?xauwdNq3kli3oneRsNoqUBRuIQ5Sg22jpvqgLZWDEOvO/ltCexbAEJZmhgdy?=
 =?us-ascii?Q?3H5EhF0ub0i0Z0FwD2KwPgVh0t3fZsf8Hwjv5zMzxHkS2wP5ptGiwdJPXj+v?=
 =?us-ascii?Q?lU9OfyEOw6oEfmYpCmBMwAVEMvs8JhsWfndtplr+3bLd+JwaqllesOly4h9v?=
 =?us-ascii?Q?wbsWK2l5j16TedOCpjkKh/JCgwBTAlZnqQYoN3kuR0nZlYhKgiOK1DSpIZ3F?=
 =?us-ascii?Q?5ZX55SMNOQdKr8aGo3j7cQDaJTUTkt9z3R4/kSnILG8lX6q+uDqNVPJCWJzn?=
 =?us-ascii?Q?s+BNnZglgPmdib1xSLC4oLiyhVQ1jp4HeHpBTY9fxl/4o8OzMgSsNb6R0LtL?=
 =?us-ascii?Q?GF3rbsk4GXd1bwQOXdqPdv3eL+glu8RFspfRQNlZCCjH6DpqspnLIgOYpYbL?=
 =?us-ascii?Q?x2xYhM9jBJE5JjM+0L7GhlUThtI6whsHYA93UaWRxd0eyMjTSKqvozXj7WUG?=
 =?us-ascii?Q?11+bDXtNXElVzef8zHfCq1qmDKkkru36jXkiK5vVV0YduQsdrJojKptY4Vw3?=
 =?us-ascii?Q?/e2ZB07Y/14cs4dRIkuLeh19w/AU4e4B7ITZY02kYvwNiX8we/wknTaqftyY?=
 =?us-ascii?Q?czGk9XVlc4GaK2EhVBEZm7H5OsZEWx49JTjY2zXUgdeHwQSWoG2LSGdzxJPZ?=
 =?us-ascii?Q?hkKQ8g/WFXgZjs/k0roz5C3ZSK6DqxQlxoDD5wBonj08v2CViBVax68/Ne5S?=
 =?us-ascii?Q?OmOuCO08ARIe4EhQdZiFTCaeIFnYjGZS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106c6912-ac8c-4b64-9503-08da0c1353c3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 14:50:37.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2u4tYfHzYf1Fa9M1QcKYnYoSoZN64XhU1Ny1rB+T9UFGrM0jdivMCpnDavdmDWIA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 03:18:51PM +0100, Niklas Schnelle wrote:
> On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> > This is the basic infrastructure of a new miscdevice to hold the iommufd
> > IOCTL API.
> > 
> > It provides:
> >  - A miscdevice to create file descriptors to run the IOCTL interface over
> > 
> >  - A table based ioctl dispatch and centralized extendable pre-validation
> >    step
> > 
> >  - An xarray mapping user ID's to kernel objects. The design has multiple
> >    inter-related objects held within in a single IOMMUFD fd
> > 
> >  - A simple usage count to build a graph of object relations and protect
> >    against hostile userspace racing ioctls
> 
> For me at this point it seems hard to grok what this "graph of object
> relations" is about. Maybe an example would help? I'm assuming this is
> about e.g. the DEVICE -depends-on-> HW_PAGETABLE -depends-on-> IOAS  so
> the arrows in the picture of PATCH 02? 

Yes, it is basically standard reference relations, think
'kref'. Object A referenced B because A has a pointer to B in its
struct.

Therefore B cannot be destroyed before A without creating a dangling
reference.

> Or is it the other way around
> and the IOAS -depends-on-> HW_PAGETABLE because it's about which
> references which? From the rest of the patch I seem to understand that
> this mostly establishes the order of destruction. So is HW_PAGETABLE
> destroyed before the IOAS because a HW_PAGETABLE must never reference
> an invalid/destoryed IOAS or is it the other way arund because the IOAS
> has a reference to the HW_PAGETABLES in it? I'd guess the former but
> I'm a bit confused still.

Yes HW_PAGETABLE is first because it is responsible to remove the
iommu_domain from the IOAS and the IOAS cannot be destroyed with
iommu_domains in it.

> > +/*
> > + * The objects for an acyclic graph through the users refcount. This enum must
> > + * be sorted by type depth first so that destruction completes lower objects and
> > + * releases the users refcount before reaching higher objects in the graph.
> > + */
> 
> A bit like my first comment I think this would benefit from an example
> what lower/higher mean in this case. I believe a lower object must only
> reference/depend on higher objects, correct?

Maybe it is too confusing - I was debating using a try and fail
approach instead which achieves the same thing with a little different
complexity. It seems we may need to do this anyhow for nesting..

Would look like this:

	/* Destroy the graph from depth first */
	while (!xa_empty(&ictx->objects)) {
		unsigned int destroyed = 0;
		unsigned long index = 0;

		xa_for_each (&ictx->objects, index, obj) {
			/*
			 * Since we are in release elevated users must come from
			 * other objects holding the users. We will eventually
			 * destroy the object that holds this one and the next
			 * pass will progress it.
			 */
			if (!refcount_dec_if_one(&obj->users))
				continue;
			destroyed++;
			xa_erase(&ictx->objects, index);
			iommufd_object_ops[obj->type].destroy(obj);
			kfree(obj);
		}
		/* Bug related to users refcount */
		if (WARN_ON(!destroyed))
			break;
	}
	kfree(ictx);

> > +struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
> > +					  enum iommufd_object_type type)
> > +{
> > +	struct iommufd_object *obj;
> > +
> > +	xa_lock(&ictx->objects);
> > +	obj = xa_load(&ictx->objects, id);
> > +	if (!obj || (type != IOMMUFD_OBJ_ANY && obj->type != type) ||
> > +	    !iommufd_lock_obj(obj))
> 
> Looking at the code it seems iommufd_lock_obj() locks against
> destroy_rw_sem and increases the reference count but there is also an
> iommufd_put_object_keep_user() which only unlocks the destroy_rw_sem. I
> think I personally would benefit from a comment/commit message
> explaining the lifecycle.
> 
> There is the below comment in iommufd_object_destroy_user() but I think
> it would be better placed near the destroy_rwsem decleration and to
> also explain the interaction between the destroy_rwsem and the
> reference count.

I do prefer it near the destroy because that is the only place that
actually requires the property it gives. The code outside this layer
shouldn't know about this at all beyond folowing some rules about
iommufd_put_object_keep_user(). Lets add a comment there instead:

/**
 * iommufd_put_object_keep_user() - Release part of the refcount on obj
 * @obj - Object to release
 *
 * Objects have two protections to ensure that userspace has a consistent
 * experience with destruction. Normally objects are locked so that destroy will
 * block while there are concurrent users, and wait for the object to be
 * unlocked.
 *
 * However, destroy can also be blocked by holding users reference counts on the
 * objects, in that case destroy will immediately return EBUSY and will not wait
 * for reference counts to go to zero.
 *
 * This function releases the destroy lock and destroy will return EBUSY.
 *
 * It should be used in places where the users will be held beyond a single
 * system call.
 */

Thanks,
Jason
