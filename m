Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631235589F1
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiFWUSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiFWUSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:18:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272B6326E8;
        Thu, 23 Jun 2022 13:18:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbU8SD/u4WhdwF5ef64Cg5ORrsj9gAtOJrEpNUP9oeQvHmD1cjWIH6DQGEAgRLdppp5fYdjjPjnpVSqFU6b2EKzew2ve7fLNK52gdLa9XtoBFQoHugRzePR1l02MYzCyjUC0rEsC7lYOAHfDowySGMHmfDisSYUbBtuFvo8QjQTNyoyjUBhqZXbgno50XU9d++5Bk3w0joSjHpF23bFuwhKM7WOwVkOPWb8F9/s2lOnTo0ZzrPVHdirjSzdKgcZXwKvUOui2fiHEGn1mXmVx+S/pgcOHBReIng3b9f3NZ0z++LhIhxjBjsx97ga4rdRcbw3mmtCgcUMBthPKEcFJVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQCoq9bD5i37yPyXom0BrdNQk1E45iIGss/CSwF4A2w=;
 b=NYJEyId5Ecv9UxX3W+DabdGeXcrAcq9XML5yGtJpfDYpdpSlDJZn1iv6+dy/2BondDIM/n4sacHxAm3+OzWYgnWwDIfg5g4N9K3MPcsBxk2Kz1smmrvau3BF9MtKo3OFqfspHppVr5U1ltzgPhzY+et6fCn5A6BlkuhRej2nXQOi3LSZ6K7OFEbwAxqc2SJazbgN33RIRnLoZwpjOCz78uMrzCi5+nnQDC/l9h1L9yEpvnEWVkhJrodo2jF8uncVlLk87nuA6CCI0T9r1abWH3UP50/TbYrk1lgN9g9qOPu8t4CbKhzrrGq9neUYoPa2LzFMorSot661rr0AAsECmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQCoq9bD5i37yPyXom0BrdNQk1E45iIGss/CSwF4A2w=;
 b=jKsn9VUbbixoFs3BMAWbYAEcVe2h2abeIjOh3ooXGYEdyOKCFknN2Bg3GuWvZLAvfWKAR2U7AUQZcihh1tDz6pLNhw0sssAvziwFp0TUoAD6oiK0rSy3n+4/sliF82mi0D9TH7dHIDOBaPVPLpfD3tN+PpB971bQv1PJSUXIB4pGqlaAwzFmeQhyZ6TzI9AJGuq/1K4KGEoV3qt83tYz+Nub6iK9gLAE8KhlE5RrzPeSvV1JkPza1Yl58hLqmpzzq67JeUCTuzszouwDwWLLVTlbLxagqvWbHkTTwgDS7temgphAv1c+fiZFj/XF2kftTNrKqbnnpoD1if03WJ0r3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5438.namprd12.prod.outlook.com (2603:10b6:a03:3ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 20:18:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 20:18:46 +0000
Date:   Thu, 23 Jun 2022 17:18:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <20220623201844.GA48313@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:208:fc::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d63e37e1-fb77-4271-2173-08da5555935e
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkUcsl/Js6FBRGZerOi6sCQcNLIzoaR6M8UvVyWSr9hv/Jx/GE4pJLOLbJaWoKTx1q72aARMkq33gm6AiyV1/OV6hlBlNA1NsxMfTQdYjx6gC0WDlqVgpz9/DuPAWnV6AEhQ6MOQUsLssiMGKWI7p1o6nNQih6a13DpMzZkQEHOUFzqsefQLdl1EXCEDhM4ewA1fdILLgXY61Bio2DV47iUjPXftT5SAu/8wFWMSQ48RdYcWCJVn6cFRAAI7eSAC4m3mQMa2jIDWqSYxUtBk/bRmm7FHEBEWMQpJse7EI3/nxNGAUUy6Uzy24/B/W7slEovPibKOKrEIx0Pp1lKFUn2dRoZ6EaR6ZAjc29fQg3Pl+o16luq1tiJmzFv9YJx46U2I59QFnGah7MH5N2Z0M9Cuyl9C5cs02T1DXfpPxtF2DqYuIgzeAVecLivoFHUQ0bP/NMJIoUag2oux0dPgU0h4U6jRVJKjG+C221OSLfEDZ8IjTvX01BkpuWQZGBPcL8EDmVu3JenTknMtJq3mzDT+9mNAxbKTYenANQR+HHvrGDLYWa0SqPVOq4I0GH8H9cKKJjWeog9HtNkhdcNfclywrxz87YS7HfaRpYO7Cf8wZ8sb5p+/AuIWh/TJVIDp7Gmsg1E6TxhWsObChQD6rytjc8Np00R/uKdWTFwG6dVmIxZW8sqmhPMwAQ5AhSXLZHt6RWFrvyJohb9XC/SxXMFI6lfOjvmR6g9gIeyu2VT1Qbhr1QhEOrxS24JBWeiS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(54906003)(36756003)(4326008)(2906002)(6636002)(7416002)(316002)(26005)(41300700001)(6512007)(107886003)(86362001)(186003)(38100700002)(66946007)(6486002)(37006003)(478600001)(33656002)(2616005)(5660300002)(1076003)(66556008)(6862004)(8936002)(8676002)(66476007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ykQXz9BrWAzk4yHxoRxcIqrSZDBkLdVtR9SzNK+1RRmQ5Btsd7+BJbDNVAAy?=
 =?us-ascii?Q?9S93S0NDpkOGROsbLFQuSpsXJeVdHLBPd1rmQ/NVbZ70HnOHupfCvr8EQsKr?=
 =?us-ascii?Q?l7cT0+DipxD/a2VuAXOQeIaEeer9pHbwvHSJ9T/0SADN2M8OK4VyoTB3ebsL?=
 =?us-ascii?Q?9lypFXMCTPUHfCadl19qt9NJLHr9Sun1K7oP41w+tgDNxlxUmkz3F+1s6noC?=
 =?us-ascii?Q?hKbFwYwNLUAnAQXqU90Yp7xUzls0g3lSD/aE31uI1Jz43nwPrg7TFlnAVnvA?=
 =?us-ascii?Q?BEn0/HL8470YPwiAAHQrqsbeEeNJhK3ufFwgnS9rF0DrSPoOTWgzI4EjJheE?=
 =?us-ascii?Q?6UmRov7AV07UT25iwd0IMugxyMyhqjL7dc9Ob/YXvSq50Ccgu6SlFKCrn4bD?=
 =?us-ascii?Q?R6u1RPVvM5yLw1IbGD7mcrhmo7UtvtNQD5hoo7bLX9RhKv3hkeYyGSBztjSc?=
 =?us-ascii?Q?k6EQUyCpk7UO3v0bbhx9YqlKJwkSAtz8ElKv8bCZud01l0DZK1BbRuL3JlyB?=
 =?us-ascii?Q?Eq1sn5BZuJZBzdM0Yi0BzZszYhtOsfTtt1xViXzBBx+dnW5SXNF2aMh4XKgK?=
 =?us-ascii?Q?oJcWALyWvyxeeI4JYNISydPWhYQRTbXLf3xB4QcDcEX125UMSavViq4/VWsv?=
 =?us-ascii?Q?AUQ4yTO94GDx11bsMVgH0JZOvu9036Npy0viE5ONixGeqfGhkWVLaNuZ+aVT?=
 =?us-ascii?Q?vcL/9IYyJxE8DFWs10e3bExFJSIsnF/FhFUDk5nh3rZmsRqEdz54VWYsk64r?=
 =?us-ascii?Q?2PaJUN1CkkqAb63AIDlJngj5DOiWZkwdkBXoY1f5wq42nfSxAPw87J67PaPP?=
 =?us-ascii?Q?PSmxdYPxVvt44jEH2jajK+pYFYm1/Rr345w0Tr9WXTD0Yi5MR4q0Q3m4yHzR?=
 =?us-ascii?Q?lClM2DLmIc4WrVg1KgWPP6EXtPb+U4bN90M0Z6xF9qNOqK9qAkb+iOPkbMeV?=
 =?us-ascii?Q?YB0jLoJfZlfGZl0pGeX8Kpo5gdxVBsI5RU82QKN58MdLxlYg/Ue0TKQwIKhL?=
 =?us-ascii?Q?k6BYd8xpdjJPp6bzqMdpmg5uTv7gTQCaE+sVIb1JpYMgMfv88iT5etEwroPf?=
 =?us-ascii?Q?z+U1mjUapitIY/ZS7Fr6MtM7s1m22NYQbBIBF/UBfq/Iu4Q5+eXsfG+7EUGr?=
 =?us-ascii?Q?15JnxarUobKb7FjRXjfvf8869pAn2B034fZuoGtAma46Zo/VXD4BmverSoBB?=
 =?us-ascii?Q?nAByOfZq37cBH6gUsHcdZKkk73nzxqnZVT6bShqaBbfAyvr+ykkO3Y7IniFf?=
 =?us-ascii?Q?8qXYmbm+QsZDOXHUX2WAH8pDm0e5FHZQ+D9ILj8io9RGLR5n0JSACbVjxcTn?=
 =?us-ascii?Q?sd1ppa7OskA+mjlTIBRITxx+/WFM37XG+w/xFDj9FPuHy3aTwDwRWn6DOMKT?=
 =?us-ascii?Q?WsxSkUIBKcSWeqbQpwADFlDEkEmvvKxBysEmlQibT7r441F0yPtyGWPWjoyj?=
 =?us-ascii?Q?mbb8QTj293sl4aGz5hRDcxDbIqPTOtDEqHRXqjFFsp3eqp9m+dPlS6tI72fI?=
 =?us-ascii?Q?Z4Q3mSt77lx5MXymyHN4ZoJk0mSSifp70hMqV9F4JZrX+zJ7baxPIRjuWYHq?=
 =?us-ascii?Q?YNEuhPqCQcdavU2UMrJ4FOB8iAlsoX/SWDjY7hCT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d63e37e1-fb77-4271-2173-08da5555935e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:18:46.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VxHRcHhtM3mi05DP6nIFgfiv2r8voiyl+KpEqDlFRkCIAR0GpxeB8ock0x1fMSEM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5438
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 12:59:47AM +0530, Kirti Wankhede wrote:

> > @@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
> >   	type->kobj.kset = parent->mdev_types_kset;
> >   	type->parent = parent;
> >   	/* Pairs with the put in mdev_type_release() */
> > -	mdev_get_parent(parent);
> > +	get_device(parent->dev);
> >   	type->type_group_id = type_group_id;
> > 
> 
> Here device reference is held and release multiple times for each mdev_type.
> It should be held once from mdev_register_parent() and released from
> mdev_unregister_parent().

It doesn't make any sense to put a paired references in the
register/unregister on the struct device - the caller is already
required to hold a reference until unregister completes.

The reason this is here is because the type->parent is used in a few
places and is put back in release:

@@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)

        pr_debug("Releasing group %s\n", kobj->name);
        /* Pairs with the get in add_mdev_supported_type() */
-       mdev_put_parent(type->parent);
+       put_device(type->parent->dev);
        kfree(type);
 }

If this was a simple sysfs kobj with only a show/store we wouldn't
need to do anything as the natural kobj parentage holds a ref up to
the struct device - but this kobj is used internally, ie dependent
from mdev_device_create(), independently of the normal sysfs
life-cycle so that doesn't protect enough either.

Perhaps after this series things could be reworked to use the parent
instead of the type in more places and perhaps take a device reference
on the parent not the kobj in mdev_device_create() (which is screwy
already), but at least this patch is correct as is.

Jason
