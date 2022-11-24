Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD392637984
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKXM72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiKXM71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:59:27 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D043728720
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:59:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/8juvLPP17JTnl3nLspIdRLuMEIuevVcYnl/39BRgtJmxAR5FLPAeG440CiTCyPJYG3CuSlSmMNkvq7YmQUJUHpgcTJrOOr9I5SyqDtAKm2joBdS2HedJybtq4oH9yGEhZjEJLi/CLyM/K7tyXYUa2EUHq6vT8zRJwtEHHa4dI3U6fuKTeaErtT+BJN1UW/aCOSm138IQ636SYD5IiHR8MlYC/CMNnkiGpbzxgoanofSps1xqpMqmqZhgBV5EifuJkEfE5E+deXo7X4NxR525ko5s9Gjopz9GRsuvh56TyyZsbjWkk/TySdUWJD5g7JUe6Th36WGoa/8/yj51FvFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcVqGy3mvOjybeqxw9I24J5WC5MS4fJDCywyVXd+vgA=;
 b=kcLn8puWMLyKSAl7m2fJy5XkLSYlGbkzNcl0JrDIL2BfnO7It7lD/aopqbNUkMNaZTX9Nb2IxOiHNrBlASfpI9nWaIsdCwXITlFJIqoK7Ns4WkVOo3lCVDRWRX68Rr/yJ7GLh6YynTAPOjE2tKG7CeUAJA7rNtm7AMs1b8LxV1gTlGBuihEI6P4cX5OCMh/7MTxs8TrdKMlWxQrBLwHKZ1OSjo/764Kr3hj9HjMIHrX/XbQV8UZWSwaTByPVjqtHf3kntKC9pZL4y8IFCXaNY1zm1+4zYRKDoT1JsRoGXBZojaGAcxOfiOZjCQRbIE/ExNP7vtMbMURTTWGEOB83SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcVqGy3mvOjybeqxw9I24J5WC5MS4fJDCywyVXd+vgA=;
 b=O1gmW7Hb5AiWpgycnUeEnUbGtdiVBX6PGbDMZmOEc6n46MEuaM4YI5gsmS1f56RGviM33vzVyO+ukixh4fh6ffMVAeK+a9s6m03jZF+fVMiWzgNjgV0qUmQID3uOQg6j1Hro1UN5Q8IIfPwOSuJ2fPCUdnHjVIvSlRz6nwdEYxQlZuhW/zTgJEe/U/v1aeo+rgi7Z/OuU0EoLj2S2ofjDTdVKPsQK05H+yzZRFjYbFbzwqmqf4uGWdoHuF2C5Cgb5TJRCz0pvKa15RTlNuZ7uWP+Kdbxu8ei2Yqjk/VGJOy4woATXq8Su8K6N62/nQfv8XTQ+0IxzURqKXhx8L8/oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 12:59:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 12:59:25 +0000
Date:   Thu, 24 Nov 2022 08:59:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: Re: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and
 trigger irq disable
Message-ID: <Y39qrCtw0d0dfbLt@nvidia.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:208:178::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: ad030b86-9efb-4ad4-4841-08dace1bb69b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: paBXfEx+5sNVZZy3UbzJ9uB9TsQ6y/NpbjvOWcL/kpBwsyM2SGNe9TynbvgBw7QRx1zUlh674cFQAtu8glOhvSWShjwCZtJnEBvDRp8xoijbx/X4w5ooPkW6GlrpsEo1+t3ZmhquCpIhBoh6ErjHVmhqVZS7QF7XpRzwkACBnee6fvHOUscbS1WXTAHpVJxHpB12jnPFIvyn0Npzg7aDKGxbMouLJ6YgA5k/2hLOJJGCurklcU9nPOUxM08Rw7wJTgTsP9eX6SKYhRm4uyJD9cKzv0xqH19HScO4MJAeUXSufg1MDJbW6VOeQCiUo3PqDrKIJYOTQgDcTQbrX2P0s27UtH5AqEmsQZSHa889tlL+zDGyh1ejdqQoSaN4CQGecVaakyU+FgqkToG2So/x+UG51obcgF4c+B/DJi/A+5gIyjI23yvI+gT5bps00UgEwgOZrDnchZ0u/iJJbEcpApHjq3xmIfyRKzJsEvSrJQyLz+GQI/9edRNj6o1SSJWvn3tHZY04cxLSkPczlS+9sIs1Ea27jGSydaCaDFeng/eXtdW6SLq2TJy1myHgleXZnLrgwCW4/c52tKRoQkv64NB6oV23yyaCMGWi6ly0pShRBKTCTesv3mefF9LuadOc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199015)(36756003)(86362001)(15650500001)(7416002)(5660300002)(2906002)(186003)(83380400001)(6512007)(26005)(2616005)(38100700002)(41300700001)(478600001)(8936002)(6486002)(4326008)(6506007)(6916009)(8676002)(66556008)(66476007)(66946007)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wDYewyVVPQtB2ss1a/DxrNZ7qUGJz1Qs4JDcOC/NYdFplpBdnsskjX3PAQ9?=
 =?us-ascii?Q?vI9VM1Mn92FErkLG/qI6W/k0T1HX003BuQlIu35pdjp0TD8K1j0XstKfmhaZ?=
 =?us-ascii?Q?XNY2FqloVRyTG7FU2l4H4EmCvuIYFN4MvddwUIsRVJFOLvHD9jIZ+pyDGyh8?=
 =?us-ascii?Q?XO9Jo7pt6hYVq0ZwSGfp64EVz+USsFifs+obhsirm3qMw14JldIwzgFN1tcV?=
 =?us-ascii?Q?qam4wN8jH/Zqqyx+OudWfHbDkrpYIAvLdPgbi95jtQhyEZAvAojX4/GF8Pta?=
 =?us-ascii?Q?aLoqyb3udoTueFZJYqA9oDlFbAEerddI78t/KJrK/F6ob3iOgeht1tru5NLP?=
 =?us-ascii?Q?kTB+ZEp+6zBVkHnhlC6Q/LUEXbCQDyUF/4/hmyMQIhLPY0SG+7YdccXWmzjt?=
 =?us-ascii?Q?EPvrSZ7sco/kZaC4YSbWnPDjJlH3xPd2HJantWIjQ0yhPcZlrCuPOFqNurju?=
 =?us-ascii?Q?92ygzrtZ0k+0XGusru4E1Wfbey2zNuw1IX2bmxwfzUCjVYm4rjl3DJFOuJtC?=
 =?us-ascii?Q?sngD7DAaogdm6M4+bCVtDzrJquu3QCpu54kNlP6Pxo9KNNgyCWoguOsZ9jZL?=
 =?us-ascii?Q?WQXOwIT3sQg2kIsOOT9l6cVPrhoujKmgbTxFQKE6h6zEkayZS5hvzQK4+sBj?=
 =?us-ascii?Q?YkfLnV14e+BM0ESbhxv0W+TpgHE4uMzCpcwUkiOVbG21k09w6PLSWe1yY0Jr?=
 =?us-ascii?Q?0buvK2/kVdBD+d41RLXfLMFVe56poIMzKPVa3DbXLirYQ8JAlIlXluErY/j3?=
 =?us-ascii?Q?xlnqysocADFOgYQJaGhblMPRdrvsoWREzvCk90yK+RizTx3RtZ7Zwzd2BlvO?=
 =?us-ascii?Q?u1IJhia+4KdCG0uecXPRm7/P5n3w8Gdlq0sefcId5RKZ+GOr7/9vi5R6rpS/?=
 =?us-ascii?Q?PNiADSsmsk4SdDSkP5r5VeosKMxwZQDKLqK2BJDxbEWjybYlTcBPfYOwbrt2?=
 =?us-ascii?Q?tiP5Yi4E6yy4yy+foB9GI+mX8j31U24D5fc8z2x+ihXv0VhH03nMbHDPXvWo?=
 =?us-ascii?Q?86jw0XDIMFkyt8uYF/AOSnsOYunDdXEQ7gP5wicONTUmRD5RKt6kU+pKRYmi?=
 =?us-ascii?Q?B6bIHI5bf6U0MEIyf2uqbIPntyu+tpw2Ugy2VkRS8gXxtfxSSX1uZsj9Rv8b?=
 =?us-ascii?Q?F/dsPbSflJvbR17vuTk9i/j1L3LbQwBUpdi1PKZRICzWOxd1Yx1QT4G4PsJg?=
 =?us-ascii?Q?Bh3a37GSfBDbROL+5LQNKn4bX1iJqGHHLATC5jnMo8HOmHi7hQX2Tz7E4vrZ?=
 =?us-ascii?Q?2BVjdb1C5MRki25a/BMN1XorHRX318iiZRovDIUTS+nAp5VdMjjVErTKjIRW?=
 =?us-ascii?Q?9j7v0ZW/QeGwNOJH0NQdcoCwH/ocdPiSsT66olqjlINxOhLAem8jxSV/wSEr?=
 =?us-ascii?Q?70R7OIH9/DS6nKG9XHshrpCJOsXUfUHbsZIrtDlkZSBO1I7Ov5Er3Guz5RZF?=
 =?us-ascii?Q?ZAhFmd67+x59ixiafXXh+uh1MiqpJ3mk9oTlBjJnR9bjhJewpc96KBqI7ARh?=
 =?us-ascii?Q?uI7vtfOD+tKnu8b2/gwomeRRWIDGqNabs2iWme8LSDl8RarmVyembzIwxrSY?=
 =?us-ascii?Q?M0bWaXIgvBvNk+ZbgME=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad030b86-9efb-4ad4-4841-08dace1bb69b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 12:59:25.0820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74h4o8OxLVy0YcVUmy5Mhi6pLLN1ATwh5rn48R9XKdS0fFJFc9E7u4qkhqOOhT10
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6784
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 07:08:06AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, November 23, 2022 9:49 PM
> > 
> > From: Matthew Rosato <mjrosato@linux.ibm.com>
> > 
> > vfio_iommufd_bind() creates an access which has an unmap callback, which
> > can be called immediately. So dma_unmap() callback should tolerate the
> > unmaps that come before the emulated device is opened.
> > 
> > To achieve above, vfio_ap_mdev_dma_unmap() needs to validate that
> > unmap
> > request matches with one or more of these stashed values before
> > attempting unpins.
> > 
> > Currently, each mapped iova is stashed in its associated vfio_ap_queue;
> > Each stashed iova represents IRQ that was enabled for a queue. Therefore,
> > if a match is found, trigger IRQ disable for this queue to ensure that
> > underlying firmware will no longer try to use the associated pfn after
> > the page is unpinned. IRQ disable will also handle the associated unpin.
> > 
> > Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> > Cc: Halil Pasic <pasic@linux.ibm.com>
> > Cc: Jason Herne <jjherne@linux.ibm.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> > b/drivers/s390/crypto/vfio_ap_ops.c
> > index bb7776d20792..62bfca2bbe6d 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -1535,13 +1535,35 @@ static int vfio_ap_mdev_set_kvm(struct
> > ap_matrix_mdev *matrix_mdev,
> >  	return 0;
> >  }
> > 
> > +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova,
> > u64 length)
> > +{
> > +	struct ap_queue_table *qtable = &matrix_mdev->qtable;
> > +	u64 iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
> > +	u64 iova_pfn_start = iova >> PAGE_SHIFT;
> > +	struct vfio_ap_queue *q;
> > +	int loop_cursor;
> > +	u64 pfn;
> > +
> > +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
> > +		pfn = q->saved_iova >> PAGE_SHIFT;
> > +		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end) {
> > +			vfio_ap_irq_disable(q);
> > +			break;
> 
> does this need a WARN_ON if the length is more than one page?

The iova and length are the range being invalidated, the driver has no
control over them and length is probably multiple pages.

But this test doesn't look right?

   if (iova > q->saved_iova && q->saved_iova < iova + length)

Since the page was pinned we can assume iova and length are already
PAGE_SIZE aligned.

Jason
