Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2D5E6989
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiIVRWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiIVRWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:22:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E461FACA00
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:22:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4uRvxTtXOuSONk6WqNJCUaH1Zi5QsIbrBv9xh6PR7ZDtRuAxnRkRCskdRN6H6CJQsMfohPlO/mrNVhhlhUXlpBWXx+DZDXoJYAheXrx4NL+rACWO9jH7jR00rw2Z86hwZzq4A2QuuX8A8d0eukLY9hXbiwiQay2qnwtjbV7yaTkgNrt7i7DSolU5NQUa95C86C8Sa4ElXijC2sdi9NjjlneriDoWrd/Qg2dkGAAY/zPcefU7jqpfUqKUDpvL1aNp2cF5GsbKs7LoI8oTJF1n85wQvOoNEmNYQkef5U5SV/oqt21vrDNcosOTK6CilsYCXvw40H4jNQdS8Ae0DTQ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QPfUk9wsl3/Ffd0X3PPHSErosgu7XCveKvDmTgipgGY=;
 b=Rm99gGEsOZzr1r/eI0bRA5C0hJnCM7W1L/F+A3qCVXlsmRHQKoggPWGZxzm09GB7jUvIhM0rU/mH3kyRf2e8JEeub6Z9ncCWTi6dltrQKgafXQlCzgoMb/6NY9KSsdKia/soA0Lv/D8YE3yE/vE9a5yIds1BH79cZ15ga+ICSxjkHystbC2DiDbWzyPMZ8DIFTiW6dVECwY1CJTtY99KzX8HJBAc6zMytxheVFUw6Z77h2IjM9gRLFHV5t+4qlw3mkgfZIEOH1UVTj4M83sc/DTAzSTBgNSvGEiEvGmLti4+BY+V8dbuESy4mGL2X1k3UpE3nI8u8pbrxRnLE7sL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPfUk9wsl3/Ffd0X3PPHSErosgu7XCveKvDmTgipgGY=;
 b=pqad6ij74oBrnG3TJGbW30VsIGBqVstpBnZfr3FqbLvvIEUQFcTa8CpLwomsD82Bft4CQDs+MMecW/+CltdoFEoPQ9H+MyJvfi+5JBVmF0vOr5Q/pXqSuPGGC6LnUqbjsELzdme0+I5bfgKPMF8Wu35qYEDK9Mcl8xxCh9oS1u2fc2wcIWbK9A1tSeAh1aroUH4GLR4Wunnu37taa9gl5uD+NQDLiHVOpH8rpoTOD4uPEzn3+3sKgcAvipByv0V8sI6h2Z9xcNA8BH8wMKRbuiGxtAKEIlW1Gtt8VUYDwCWM15tcq4teW1ma1nn/emPUmjk5dS3CHnoopKCmJV5ioQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB7089.namprd12.prod.outlook.com (2603:10b6:806:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 17:22:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 17:22:04 +0000
Date:   Thu, 22 Sep 2022 14:22:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Message-ID: <YyyZuwjmeOxEjh7e@nvidia.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yyuzrqe8PocywMld@nvidia.com>
 <20220922110930.0beadbc3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922110930.0beadbc3.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:208:32d::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SA0PR12MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: af9855cf-b197-4f73-d075-08da9cbef7a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MVHL1P5PXin18mGlD2u1w4BJuOXFoENJVgPphcvaN/hSyERLqBjL23KA4oonUjAMgK5cOSh8AMbL7ROZOEWT0ZvtOg8a1X3pcHs3xH2Hwl/FySH9rJzAL/F6y/W7eidIg0g8ks0ydtmreKEeNINu9vinLnCFtiy/XykNtLI+K0NBF+stoglR+C7yJpYt952r6oKbVOUa7Tsa6RSjqb1yllVL1FvUPHBkWQE7E1yAyVstdixH7ViqwUt0hFwwdtLGFVKYU8lCe+69b9c+jjRlVpbVm47Wle2UOY8qT33fhGGh7xN3sEdHFhsc9oA/IlOaI8F023szJ2tUVksmeacWY+X0x4pR2iq1w1sNdrQjGPFQxhTM9TmMPpYrQND/l3b0ZS0m3KJCXejov01CMFhFKPEHJHHS3xX2pFm3AY388CaRKHZjRX8M+VM8skc1RT7FEfxpFRD6HdPoD2GnKcxEKr/ObGX+ENEccIbmHlx7CFg0ldWD3lgwEW9pF0MCjdxQLoDKv3jRpewTl6cAA0tDhAD/cDHG6pQTaGNZWW0bDiJsjcuOCmrnupdBwbwe4VyXWiOdcHcLoYIJjppRBOJGdHghM4kLyiBD2dhH1o7PMLbeKSoxUF8pFByXTK6lc5fPW183DIpWm8fA0F8yFtMFwUnJzQzShO3vrqasy47U+CIP7hcGtB4f+pKRDDLrvy3bJJzjre6E9Vai89fm9uUBvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(478600001)(36756003)(5660300002)(54906003)(2616005)(316002)(26005)(8936002)(6512007)(41300700001)(86362001)(6506007)(8676002)(6486002)(6916009)(2906002)(186003)(83380400001)(38100700002)(66946007)(66556008)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?19pEYG+0P/nAZpAty01UvFa8jYl9DfnbRe/TgU5cTTsNT0sYFTdtFsXg7cX/?=
 =?us-ascii?Q?pPGmM+PFCQJtIk1cvav9OC+UvDPXl4Dnkkf4U5sMD4mNGyziv6FRVNjsY3t8?=
 =?us-ascii?Q?u/4W7ou/PKtV0AMv/wVqwe9jrmvU5rYAbxdFWtO1uzC//27C9HYJUv2dv1yu?=
 =?us-ascii?Q?mXVwRZoLk3e5aZ7hnf6CqIBp5kfbw0KZYoUJTGkJsZRU6C52/Wr7aAsqXMvh?=
 =?us-ascii?Q?MTF5+nKXEE+InIm1yCeKsz+9PWoDDBk0UZVGVn6GkMdgCFe8knzvBmmXZsgP?=
 =?us-ascii?Q?aFD+Dwr39ipWg5ZmMTaP1lBi1vRO4l4ox7Q8xYk9kiIbmPx6hrv6XrNxYrPH?=
 =?us-ascii?Q?tDC8vm/PpMzzIsWGiJ/reZXDbqdN9kXAEuN3OUxbMt6Kyxx9C9Ar6fKbhrRE?=
 =?us-ascii?Q?cid4JMh/nX+mnkZaIYyyI+QAkzjVvv6vL+F+jzETaW5EAE1f6Wk4ZgrAx55a?=
 =?us-ascii?Q?Jm7YPgsg4Q3mkW0iDQ9amtKn6CjfaL04pGw5BecWaD4m6ZqM1Kyhzzp9wzs1?=
 =?us-ascii?Q?xMxvm/S19HbeRfm0gxws5GR9WIA0BJcVO24XCeya0irxCRA2RiGuCRkkvBaJ?=
 =?us-ascii?Q?lx+DCv+JJa2VWsE0DswQwKIi+FGhg5/8PX3IcehsOceikG29SQWXMP3+LjPI?=
 =?us-ascii?Q?5jqA8YIfppmg2WpruYicPfCI57kVPkltIMv6SsgIwn9bB17Ga5cTIvI3iNtI?=
 =?us-ascii?Q?F9AdXOltNo85HIdgxXmIgH0U0hT78g64G61NNuMiALGOuC+loSgLeq0DsITM?=
 =?us-ascii?Q?BdkKOE8dCp8IvXyVFYLBN7vNLxtPKLS2LIqRNGdoRs1RS03NXnHYYEEXCDDj?=
 =?us-ascii?Q?P9co1MBGvPl3/iZagj7fHXKNu8DVRSWg1NE666DGtp6qGV+Yy7JlcRGfHMRq?=
 =?us-ascii?Q?9tctw+MfBXOpupu0o+VlzbNit3STq6phPaNryp7Yny43eGRwBNHV7BK/CCx1?=
 =?us-ascii?Q?I10JHRGHO3Rj5T1Et03B1VsA6pft+rRrSoiVJlmoNnavQQ8Vu7G4pwD2GSBd?=
 =?us-ascii?Q?/NXaWCGUNg0MSpF5Vz/xb0iVG3A+0OeVt1kyUP2efMaQcDo8eJ9DL2CUs6Pr?=
 =?us-ascii?Q?XxJbGy2t/ueaF1fvbhj5A+GwV/2JHP0Un+KOfgtggVyCyKg+W4iE1e2Bhheb?=
 =?us-ascii?Q?d/8QM6VNV8EFWWfuE9IU2d7FJUEm5tIjqHoIvYt+caU20VsEAO5kRrSTXHvw?=
 =?us-ascii?Q?OYqORs00Rdo8IcQG/GgHTbnxeXXPMRWNRuWwR7AzhtwCbiIyfBBvgMstjgbI?=
 =?us-ascii?Q?p/cI+4Oirnv9dsR1aR25wcgycTjBpt3C8DRfsSbTTBBssDTwjDk5i7FlLorK?=
 =?us-ascii?Q?MloLyzXq/UkQJlLWxdlp3R4jbRcBsa2cDJm+xNywjvk0FiNYChu1lkZWHGtL?=
 =?us-ascii?Q?FQSW0y++KfoNZ2wAgEhsxWgEQ14E2U+Rjx7BulNsJiSOBKWfkNJyC1TYHoM/?=
 =?us-ascii?Q?0vUR2YSvVRbtWQgI8Uvv8ZxaFL1ev1f4ZWROJDek5oAohax2m7mgO7NW5pnS?=
 =?us-ascii?Q?SLm9G7+wLd756f3Rl3bysoI+CYMP1/pV9D/DW0pbmugyUmSWx85zPSQQxvYb?=
 =?us-ascii?Q?vdoxTBhFjh2aO7l24+n1iY7ATv3Ts2ggV8Oobe5D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9855cf-b197-4f73-d075-08da9cbef7a6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 17:22:04.0688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9Z4t8KDVekebFg9Mptcdi2s8UeNCCbmVRcH/n7E6IbomzpoEfslH03tGBrFrISV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7089
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 11:09:30AM -0600, Alex Williamson wrote:
> On Wed, 21 Sep 2022 22:00:30 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Sep 21, 2022 at 08:07:42AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, September 21, 2022 8:42 AM
> > > >  drivers/vfio/Makefile    |   1 +
> > > >  drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
> > > >  drivers/vfio/vfio.h      |  56 ++++
> > > >  drivers/vfio/vfio_main.c | 708 ++-------------------------------------
> > > >  4 files changed, 765 insertions(+), 680 deletions(-)
> > > >  create mode 100644 drivers/vfio/container.c
> > > > 
> > > > 
> > > > base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589  
> > > 
> > > it's not the latest vfio/next:  
> > 
> > Ah, I did the rebase before I left for lpc..
> > 
> > There is a minor merge conflict with the stuff from the last week:
> > 
> > diff --cc drivers/vfio/Makefile
> > index d67c604d0407ef,d5ae6921eb4ece..00000000000000
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@@ -1,11 -1,10 +1,12 @@@
> >   # SPDX-License-Identifier: GPL-2.0
> >   vfio_virqfd-y := virqfd.o
> >   
> >  -vfio-y += container.o
> >  -vfio-y += vfio_main.o
> >  -
> >   obj-$(CONFIG_VFIO) += vfio.o
> >  +
> >  +vfio-y += vfio_main.o \
> >  +        iova_bitmap.o \
> > ++        container.o
> >  +
> >   obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> >   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > 
> > Alex, let me know if you want me to respin it
> 
> That's trivial, but you also have conflicts with Kevin's 'Tidy up
> vfio_device life cycle' series, which gets uglier than I'd like to
> fixup on commit.  Could one of you volunteer to rebase on the other?

Sure, I'll rebase this one, can you pick up Kevin's so I have a stable target?

Thanks,
Jason
