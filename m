Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5492C5AB66E
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbiIBQY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 12:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiIBQYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 12:24:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512FDE71
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 09:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeGxOs/jQF2/Lh+RhMeoy92UNYL2Dqc2ncfUOdUV8prsdOOz4xCU1LhRTvxB3viL1HvfvsH3bi6VX7eTsLW8WnIqCrGdkmertqEkpPusOWa4gH8Bspykyjfxf80435f08lsvUDHu63++7ZFs+n9/MmIlc3QfjUMPPHMdvSmfdvTjGwXTDIJ+HMk5VgbTz4IMikjaEZzeZkPg9X4WfHBoY1ZXdCarfwUg05NP/VvZdK6/Y0Wod85QNf4Sii5PRSwPDUHhXq1C8qW86Q7NgFBqJkOfTbCvDFZSJLfnBzV1eowBw/ZpIXKE2nBqmisEUlnXg/cMzqnFPj8Pauhnsr8+Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy+wFApcXjHNP8OC085GDxP1HN4CLLxNuOJ7fswgrd0=;
 b=KpFdTGfEGEoF75tgY3agJ9HmYUmeGbP6uR3ZUHMZ2SPoPdABPZiwVdyOYfGrJ+6KEc3q4ihbmTrJLtfL2JsXYktHcKPuGeGXpdmzm2JWTDSA1/vmkmT5gdP6wO/fpNhxCno4JNyihUAdh1UuLgVs1C6Y/GLr66qK9CnMBTdBOpmkwVd2srTt07UorLcJvuJRoggrmsAs+EES5aVf7WuDWanlHBQcQSto4cPVi2la0BOTidDYffI7SR6dv8gn4Hb18r3X+9NCQwBTx+BjcJqal1yggiiA2cysGtHNRV+0LbYyjANZoWC9xkzWv24pToyJBbHt0M7C5Y3y8HBLXjVnzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy+wFApcXjHNP8OC085GDxP1HN4CLLxNuOJ7fswgrd0=;
 b=fnfUJ9TYN4yfk+cX5SQafY273rVr5skS7D3ud1C18pO+50brvsgpXmZton8E5oRlZETqK2RM46XT09ymSZg2mx/8+bKmqhVf5dfsNTfzVDi0wx0/m4s0q3cSqVcQHwuAm1YuFkyDA3CMtIupEJWx7AiVMG6XAI7NQ2oA3cpN4GVznRD7Wl8ma6RysaNaZOPikPrUl9xvHbRm2Ps+7lf9gyEUj+vcV2qHoKw2WecNV1ybR6k0L3BiOEvd1mODjzSmHaOasedhZo089bGFnZx0vW75R5ou9SDqinakS+sDWkfvpFuOfqRErgnyabHj1jklr4EME+QtqbhXGfhmRpi8XA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4541.namprd12.prod.outlook.com (2603:10b6:806:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 16:24:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 16:24:44 +0000
Date:   Fri, 2 Sep 2022 13:24:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Message-ID: <YxIuTF0qfy8c3cDj@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxFOPUaab8DZH9v8@nvidia.com>
 <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220902083934.7e6f6438.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902083934.7e6f6438.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:208:e8::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2308e39-0350-42ad-60e6-08da8cffa578
X-MS-TrafficTypeDiagnostic: SA0PR12MB4541:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXlfLqIw82gkjZprXrREdRPZcJSLNqPFJxKlJZYauUPt3DkD+ZdxLNZTfydGCcBx6zD3UsccR9pEUU5sOWKatBISbsbmVffnnpG2qU+224paVudCdgUVblTXwNf8LC5qi9vEpohDqAgtSg3Zk5ZYmtneNHQVQ13tBdy6E3jpXs+yse153cjrUUH41bfYlf4W54/dVv/fgJmtMtQLb9x94xg6QkTobP6w55pGqRhcKqfZbEWjnhU0vovHy88GVP1JoQYRAbstutz0IkxqPecaSf17wI2NyfuJohBn4vVyUGRezH/fPISmDtERuvQm7aYf9yDOPyfZYsBx7c6SCHnYNMzj4CitgVkS65Sqwe4QPJSKr4NYUSDKr6KdleGJ/UpJPDzNlxbpg5EjVVo6qQLnFV5p8f9GfITIJWTTMSMbNAciXdtxjw4JQroi/azfdCTlbfW7eCwnOFlz07HAoCcQqMshiMCFDXd1NYJ1UpsBRR6xi/cRcKD4Ppw0BUOkgxw7vOJs7Fg1XVcQUZurY5cJPYOvmc0ivjtvyCUX9wdqbaFrt1mwNwCaLYvTdoHB8w+93wlz3PalydrnnboSnBEgyHeyYFlyYsCgG+ZdPC1X7n3JjCuN5321J6YjhyhWZCS6/qLJVNSz+uedqjts0YDalz5BiXDu2tyq9lzsrRzRrkPJbIrlN+R0LgUsf3jTxcLbZnbA6r322rOkQoEOzh0V1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(316002)(6506007)(38100700002)(26005)(6512007)(83380400001)(36756003)(54906003)(6916009)(8676002)(4326008)(478600001)(6486002)(41300700001)(8936002)(5660300002)(186003)(2906002)(86362001)(66476007)(66556008)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P1kr2Gt1G51PmJc2NjiO4ES38W+mThrmQxm1KaBAa0ZIvDDG8J6qd1tsNAQP?=
 =?us-ascii?Q?AtOzXoaENwKFLldqFfWcuTxJrHNXYdLjWUKpMfJsQBCl/Go/8JsD6QGSy6Al?=
 =?us-ascii?Q?oW+zgJrfM2oS3FlB/6P8+sFFVXpn0c6JdTwGKqFS9l/cX5jktKct3Spoi0Cr?=
 =?us-ascii?Q?gJaMyif9A/gvyg4WrMjnsWsVvtUqVpQrd3G53m+8mxSFmdeDBRUFwmLQjI5h?=
 =?us-ascii?Q?otZ9Ti0gu/56ETXFlaoyDiDVgoDioKhev3U0TQZTZFiZhrOaq9iqLXcn5dpn?=
 =?us-ascii?Q?apelgQLzsZE7Br4s60x+sJdX72pF+tH6M/sgRFmdDbbbLdetKmAoMMF2r5fo?=
 =?us-ascii?Q?XfKm4cg16gDinpWqnnxNfLqKyEiKt+mq1ZxA1hnybKvg9JWPfPo9hF61XY62?=
 =?us-ascii?Q?xR7brKNfcl2ZiOn+D/XjHPNH94AsVwqRZOVcO6g0XyQYkoCIYZ5rXBFEpTu3?=
 =?us-ascii?Q?UrR6KxLDoqbAQ99H1OIUhXAebJEvtOyefjM0d95jIMhkoRHzEIbLwpqpccxs?=
 =?us-ascii?Q?t9BonEZLFlH+kcsgvewL9QHNUVMyphwV+a9GrpCivq3gugR/PgVJtUf8S0pA?=
 =?us-ascii?Q?EtFonZrSekmOk4exKrXoreWZiqrMZvoI809JQ6hr7unrHHi+T5FDZsLMF8qo?=
 =?us-ascii?Q?F4Qc16SeS83AttvIds6nmDv5djPyAwhtCjxL0dSKVTnItH/7c75rgmlriu9s?=
 =?us-ascii?Q?qU1cE/pyuWf8R8kmlLvx3ty/nYM14znW4PD0dioGXgQWL7uEnVHNIA9erohF?=
 =?us-ascii?Q?nFYsLS8uY9xGq2RLaIQIX/DDfKg9DOZvXyWsOK0ScClam/gN9t+hnpSikuU8?=
 =?us-ascii?Q?1Tc6LLkPdHY6Dt2wsDIg1X9He9rvARwdhkfbYqPFNp5LkyABEi8DRh4UczHU?=
 =?us-ascii?Q?WhC6fLcydGs2Q6UUYDYO0ePTbliY9AugPRXcdCuJcY4wTKgzjrSW9GTzfBy2?=
 =?us-ascii?Q?H+dCMah9NRBUYTyPEmMEXTQj/hhmgnfTLIoLbihoHc/PRJk+pg36KFrB86em?=
 =?us-ascii?Q?/iUGWF5vcshdYNj9BqFsst1fnwMxMI5OJsrjK2mg0ApN4jBCGJU3LYaM0Y3Z?=
 =?us-ascii?Q?bpRMgL3uA/Yr0iVo47xqcHyR2rjNCCPx4a9RU2AtHL9JNNIT7d43SuS3tFFu?=
 =?us-ascii?Q?wUXaCdsjTQWhs6geRp6bXr4+U7LqcCpgeK0cT6uap/uhAGW6TqelsG0ZYmel?=
 =?us-ascii?Q?4PKN4Na63evOthAvdqIJn1U32PF4s5J70cmCMTiWL+O/w6ceNvzuKScG6Lfm?=
 =?us-ascii?Q?kWg4Bb9z86PQbCRLzcG2S+vIscrAfVlGtCs7j+KHd8kvJFBQXIFb9ePLzFsI?=
 =?us-ascii?Q?6BiYU/3Hw2arEFKJOhID738faYjZKw7RrYmk9HCBwGa2hOqPQMhximD1DZHc?=
 =?us-ascii?Q?bQ//TeItmTLFuyjrAc+E8WRlR7AttdRSqhGIvQ+67bRVEG4U9Kga4bOIYV4m?=
 =?us-ascii?Q?LdEQYVa0IcLq7rdiiba+dt1dyOluYduZ5mMEDw4ZCjr1YcWklt01pU7ddV9t?=
 =?us-ascii?Q?4eV7Ko+ziniHx3BKHzTLhxRncUpELe1oRbF7x8lyqKWIquBK5lFjW5ELL4h2?=
 =?us-ascii?Q?WWzTRC05zeF+dL7knToRI2JkDUY7vVVcKOBsK72O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2308e39-0350-42ad-60e6-08da8cffa578
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:24:44.8575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sp5V6nGPFbz/7e1qGOUmvCH6/kzN+x8nEkUul7ryHmko9olfZJLu1oXFwYNAnIHb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4541
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 08:39:34AM -0600, Alex Williamson wrote:
> On Fri, 2 Sep 2022 03:51:01 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, September 2, 2022 8:29 AM
> > > 
> > > On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:  
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Wednesday, August 31, 2022 9:02 AM
> > > > >
> > > > > To vfio_container_detatch_group(). This function is really a container
> > > > > function.
> > > > >
> > > > > Fold the WARN_ON() into it as a precondition assertion.
> > > > >
> > > > > A following patch will move the vfio_container functions to their own .c
> > > > > file.
> > > > >
> > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > ---
> > > > >  drivers/vfio/vfio_main.c | 11 +++++------
> > > > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > > index bfa6119ba47337..e145c87f208f3a 100644
> > > > > --- a/drivers/vfio/vfio_main.c
> > > > > +++ b/drivers/vfio/vfio_main.c
> > > > > @@ -928,12 +928,13 @@ static const struct file_operations vfio_fops = {
> > > > >  /*
> > > > >   * VFIO Group fd, /dev/vfio/$GROUP
> > > > >   */
> > > > > -static void __vfio_group_unset_container(struct vfio_group *group)
> > > > > +static void vfio_container_detatch_group(struct vfio_group *group)  
> > > >
> > > > s/detatch/detach/  
> > > 
> > > Oops
> > >   
> > > > Given it's a vfio_container function is it better to have a container pointer
> > > > as the first parameter, i.e.:
> > > >
> > > > static void vfio_container_detatch_group(struct vfio_container *container,
> > > > 		struct vfio_group *group)  
> > > 
> > > Ah, I'm not so sure, it seems weird to make the caller do
> > > group->container then pass the group in as well.
> > > 
> > > This call assumes the container is the container of the group, it
> > > doesn't work in situations where that isn't true.  
> > 
> > Yes, this is a valid interpretation on doing this way.
> > 
> > Other places e.g. iommu_detach_group(domain, group) go the other way
> > even if internally domain is not used at all. I kind of leave that pattern
> > in mind thus raised this comment. But not a strong opinion.
> > 
> > > 
> > > It is kind of weird layering in a way, arguably we should have the
> > > current group stored in the container if we want things to work that
> > > way, but that is a big change and not that wortwhile I think.
> > > 
> > > Patch 7 is pretty much the same, it doesn't work right unless the
> > > container and device are already matched
> > >   
> > 
> > If Alex won't have a different preference and with the typo fixed,
> 
> I don't get it, if a group is detaching itself from a container, why
> isn't it vfio_group_detach_container().  Given our naming scheme,
> vfio_container_detach_group() absolutely implies the args Kevin
> suggests, even if they're redundant.  vfio_foo_* functions should
> operate on a a vfio_foo object.

Look at the overall picture. This series moves struct vfio_container
into a .c file and then pulls all of the code that relies on it into
the c file too.

With our current function layout that results in these cut points:

struct vfio_container *vfio_container_from_file(struct file *filep);
int vfio_container_use(struct vfio_group *group);
void vfio_container_unuse(struct vfio_group *group);
int vfio_container_attach_group(struct vfio_container *container,
				struct vfio_group *group);
void vfio_container_detach_group(struct vfio_group *group);
void vfio_container_register_device(struct vfio_device *device);
void vfio_container_unregister_device(struct vfio_device *device);
long vfio_container_ioctl_check_extension(struct vfio_container *container,
					  unsigned long arg);
int vfio_container_pin_pages(struct vfio_device *device, dma_addr_t iova,
			     int npage, int prot, struct page **pages);
void vfio_container_unpin_pages(struct vfio_device *device, dma_addr_t iova,
				int npage);
int vfio_container_dma_rw(struct vfio_device *device, dma_addr_t iova,
			  void *data, size_t len, bool write);

Notice almost none of them use container as a function argument. The
container is always implied by another object that is linked to the
container.

Yet these are undeniably all container functions because they are only
necessary when the container code is actually being used. Every one of
this functions is bypassed if iommmufd is used. I even have a patch
that just replaces them all with nops if container and type 1 is
compiled out.

So, this presents two possiblities for naming. Either we call
everything in container.c vfio_container because it is primarily
related to the container.c *system*, or we label each function
according to OOP via the first argument type (vfio_XX_YY_container
perhaps) and still place them in container.c.

Keep in mind I have plans to see a group.c and rename vfio_main.c to
device.c, so having a vfio_group or vfio_device function in
container.c seems to get confusing.

In other words, I prefer to think of the group of functions above as
the exported API of the vfio container system (ie container.c) - not in
terms of an OOP modeling of a vfio_container object.

Jason
