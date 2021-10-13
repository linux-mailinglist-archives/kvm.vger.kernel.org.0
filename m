Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E842C7D6
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhJMRo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:44:58 -0400
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:23708
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229714AbhJMRo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQcO9ewszUA2jMKdear5esQgSZ9VBfAUbbKosF8CJzNddWoIN484FkhTMF+i1jbSN5iDdgUNp8kNqVogynB7NP6ctegdKOGvHlZLQuTifpSwrwZR617CUoA6dPcHYufoaZiDSJZSKU4jQYdlylZ1itv+ee5foyprgX7KhzsfFediBgdMGxiGx74GjohbwygcSQOOf2lK6ixzp6ZIMFZP9Siq7g8TYkX6fdtYQ9oveCjq+OUChBZnQINBSfitAkJwNSC1hzNyu/P0oqCA6estJyr5nrYosOVZ4VBBaKyqDgo8MChadPKOrud8fNKVDwNcsskAVD0sUMDi4qE4CVMN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJ7MJUi3cntWhJWUbhZ7/fnn0O86VhBWswJdHSa60Bg=;
 b=oQ03R7CVHc+myuUxbShJH/O32GM5SF3ZBNgwLJcXFMtx//E7DZWBk+jy6tecz0HN87yJvIRMeI4QPyrjPm+CTncuM2pHJI2UvqBDvxO0WDKbgirRSmPZMrARfb0QNNdB4gsu67s6kY0XO3nlP93lbuFAizq1la5tU4NiWlcZ4hxBwv9+taqdMjhxdNcWJFf92fjQm/qKWuMRbaBvpcvGgfOyMKZXJEBjoIejiGM1dFvO//dsUF4CWo4bfSdB5zsH/HeBJR9wldNMXUtLtApLIexodGEvwpk74sVkdVQh5obAkMEJh65T2JLzHx+hD3q1XfP427GEK32EFDuxI+QBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ7MJUi3cntWhJWUbhZ7/fnn0O86VhBWswJdHSa60Bg=;
 b=OyP0q2REAXMNb++zGwABeCrM+yNuyMYuULVNjdil2MJ+uLkqBl0nMvBtPyK1HJc3QBXDntltdjGfPI2EyYSItHZfiX/BDZ18ofzhfjHhsuMTd5KV85swrER0p1DSDBzzYZk0GEyO+OJpvzxVK1gOgxPKVbKRbc0LMwd8x8uEyn3L1AxLOUASbajVTL6vWuaX3vUdr7wjmLWvo2MtsXJZgUyHi5kImoKkRuMzleSl0ANeBz+INtJEefHVhMJKeyod6e1UY31hjTOfDIjmhGEThuV+5c4fEDPOqLxu04h4UfgZdt8QR1Ws/nMjUBzvuQqSTFfoCalIHl0UNm7Olr9mJg==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 17:42:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 17:42:52 +0000
Date:   Wed, 13 Oct 2021 14:42:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Message-ID: <20211013174251.GK2744544@nvidia.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <20211013170847.GA2954@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013170847.GA2954@lst.de>
X-ClientProxiedBy: BLAP220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAP220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 17:42:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maiHD-00EcBe-LQ; Wed, 13 Oct 2021 14:42:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4f77dd5-4e01-4ab0-5af2-08d98e70e1c4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51768E7D2E91A3ED11FE823BC2B79@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4J5Sj9bwzYF40BrptYCF3y1T4IojKvQj4vgmo/jwHjw1DJyFfSiuOFjlAV/aGhGixFOst9eISwZcrnyJD6NTV0+cQ0OXKFcmbNMxdRHb+pI/P+CdHCmOS9i5OfeeAu866qbOBDcg7KXBIH7H5G036N/5W9ok+MsO/fScW5lMrdsJujM442fUcmG7BL86BL3KAh/8/FDfJ8mTy616Q2Sy5BVGu8XHA0nO0aEGvVhGpUDncVNF3XmIhQuYFP2nen02Vasq3VkKbWh3jOZietmh6R/r+/USQPgWh4s2uHu/wQcKPKfWWKZfZ/2Sk55kf6Hb366SstE6+R1mSEkUqH9vL2/I6IdE29xJz64HAgdQxq+oF66AhC7eqPBAibcE3gWytfSVELHrM9sM0Mw0dnYrww6zD1FS4gSj4zlYL1pR3QZ1kSPWURdAXo5aV01G48k3stEvh8+5mHPN5CF5cLxmB2fAGBuu4ALr+gwmGVrJCxv7oTN9iLcK14JQnnNGy0PsjVBfieNJsgzkPY6Cta2p5whwQ4LyT9joklASe3JfCoa6hRI+qBZjDNu4Fk3y+d4AHDJwD42r1u00BHNzIrLphvLNXfcOf/f/9ZWwSooymtHKPfVPZeNl0H6tZkRS1MZmNJvOpsf334xRpnZVPvuqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2616005)(508600001)(4326008)(9786002)(9746002)(426003)(316002)(5660300002)(2906002)(86362001)(66476007)(33656002)(1076003)(38100700002)(66556008)(26005)(54906003)(66946007)(8936002)(110136005)(36756003)(4744005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hmd11KNRu2V6sWj8dbOx3z9UakpGGXSXyIe1E1d3EQG0KNFbn5Uo1YGc6ZuH?=
 =?us-ascii?Q?osABqVDpySVwbk9Alcor29FuBqQ9luI+9nnqRb1d6iZ9AFhXElBDqG9tPKoZ?=
 =?us-ascii?Q?U6oPmDrXk8THxKn5U+l9tVu8zYMSQnGXZUD6XQrrYT93fQsk6Pj4tBdMHoOt?=
 =?us-ascii?Q?XNjg3PCxqlI2ES7FP3lqhjswIY78zpy5+BWLJOztzetrXk/Z+ms9Z1WmqK/P?=
 =?us-ascii?Q?/Ubdxz+nRkqi1PudseLcV43nyM50ip/SAZZ/eI3kSPACxkQqDCQi0wwWEU7s?=
 =?us-ascii?Q?3ddG170WiYyAGGpvXULcmbvSNyX4w1+oQEH6+oW6T1U4kYlbQ3K+5xnZHPZg?=
 =?us-ascii?Q?f21gRq2C2ul2eVGfV2PEOVRx7FnbEU/ZUWP+kiLYPPRi/DWm39h4u+NjQ6VK?=
 =?us-ascii?Q?lVqIF9uXAWIURUcQ1/yXwepBvzNan44towhdVYRq16F4tA6Vq1BROiNIWBDC?=
 =?us-ascii?Q?cpZRJZB9XgcXl2aD7uUesBV/srH+gKBbeZMTodUWwDjG5NapPqZgygRP0p75?=
 =?us-ascii?Q?EGNAktTHnX7mcBh5bIHQZvjYGtqXgD6YnjzTiNTrPsQuBNKzknugHgXuXtRK?=
 =?us-ascii?Q?UJRQV6xq39YEg6NeucUVshBPv0TdbZzXpmkUPtgGfqIf7k8KCOX2OjLau4bb?=
 =?us-ascii?Q?IDbHoR6tf5VZybBd/c4mVRPZ/Nz+Lo5BBHTTiPMNO73h1daIdkRVpiastxoi?=
 =?us-ascii?Q?gnEMew8NNSxK/go+0QcnZI/WTmL0efW1MGuPjbekBaJiyPEgZqhOXuScAL2H?=
 =?us-ascii?Q?me3GwjXjYLagHWzMnPJQNkOg2KIVk8y09Hrt1WZgACpN+n4KJag8USUHPtH7?=
 =?us-ascii?Q?hHSB70IxvsCM2u7Y31KLxmiLXMKXGLIs1sy5YhqgMkWuTmQrNi5LS5jPlxEf?=
 =?us-ascii?Q?MnofDutSOC1TwZBOppHeK02kSiDn0MIskWb1fWspRykLZqvyLWrPIMfmKhwy?=
 =?us-ascii?Q?Ay9iLvtceEfU/66lrci+8DmQrUYZ/bt7aTOiPlYw+VqK0dKZEVWahu4lo9LA?=
 =?us-ascii?Q?+mZSxc7J2bsN7oARfOPifSTRLo0UC2f4VQssBy/RNwkuxfQeQXJBnv1bqs/f?=
 =?us-ascii?Q?nofpTQ8GE+n0qykhrP1vfBkH6d12654mBOmDvdxw3M0u98eADgqVRXJtZmP9?=
 =?us-ascii?Q?Bq8Q2JBF+00l0pvcOkiAqgySrTKGd0QtVAwTdT7sfX4e74w4/6NBX424RRGQ?=
 =?us-ascii?Q?jmMHSc2D12vE5JeKHGFb40vOvgbVxMgSn4hsYXIf66ZiBkOfHt0J2j64qmjw?=
 =?us-ascii?Q?8SnyS9CVUKOocXXr/dllBNGx0w8rLyEBlw41q9lG69VQn5gES0oCC66rPXiq?=
 =?us-ascii?Q?YmMn6gSRRCjjECKUkck+tZJ0lUyG9hRa3SSoCCpzN3qrbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f77dd5-4e01-4ab0-5af2-08d98e70e1c4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 17:42:52.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL38Gkn39DJP1jRil5MgPINaeE3KeWZi5l91R6F5ZQhFSLKA1RxtS0dtsDgOlTbr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 07:08:47PM +0200, Christoph Hellwig wrote:
> > +/* returns true if the get was obtained */
> > +static bool vfio_group_try_get(struct vfio_group *group)
> >  {
> > +	return refcount_inc_not_zero(&group->users);
> >  }
> 
> Do we even need this helper?  Just open coding the refcount_inc_not_zero
> would seem easier to read to me, and there is just a single caller
> anyway.

No we don't, I added it only to have symmetry with the
vfio_group_put() naming.

Alex, what is your taste here?

Thanks,
Jason
