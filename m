Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A607CB217
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbjJPSGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjJPSGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:06:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582449B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:06:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtOoe0BHqMwblt+IXkHOi4WQ0mdS27jdr17Lyzy+VcdD4mMkxzKGlU2cluDFDWlguOkbOpwmOilCQtJLl57Jmf15bGhEvgKlEoSj5/HmhDkT/V8H3iRgpmxZEJ05hABAozGkMVjDEnA5JPP6mLEhb7j++2bg9jzI+2WiCrVUa2KFjm9N1FWs2jMQkusLpLo07owh0DL3VHYk8cU5QvFL9lKCUSeuLu92booei6OTbm2Y1uJwKuLSOTuMRD+St1TGpEifNP3PdRvuAnWU10LbdiOgToK9hmNrX5rRxh4Hz0pxcLEy81Fe2i6bnVMRSp/LCB4Tfn1EcYCYRuY5cMtP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtDwEKFtbOcdhQG7w944FZCwdW/VJmsqmY1KCdQp9yw=;
 b=FLOeh4hu/FWW4dHQnbkb90Xsy6QSvcrBDZFIEEMZM4WOECzEu+nWW1aA3mtmW4a7Olz5gwx0eEQcu4WmMpUTwp6BbOw0B4HcycLTpRq2SYcK95QveWuW5EXw14IjITAxt+DaRp0Wh9fQYJ3J3RE15LqQDZxS2EtI6+M2rJA8bwJymRmaf0R22r0USYLlXg8D7P3DO3ES52QXjxgOGkBTfU9n7dpHMOZQRDMX68ruFU2ZTtp/T+4U/H62GJLjGcsXjgrX+9K6myjCZx+I1h8rSPgfYjIdz+7QC+NYdYzCgVOYRm/Sa1ECvVCO/YyEeVFKMh91vRBZgxAbHhTmOTGSkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtDwEKFtbOcdhQG7w944FZCwdW/VJmsqmY1KCdQp9yw=;
 b=ZvJSZIMj/Q8+8p+54o7kTjmirjr0G3SY3geyRXDRaAUO8E3xiL6BV7MDQt4O2rzqQZNbCzRQpsz/dFkn0m6nqzmIsy/uRDFybjRx1TWoTTu2NXCe+hBm7LlcDT+96SzYLE4wRnNQbgGlNgDpacI7W8T+qKscLjKC9KiWT9gOYKHxU+9mxTSrcw0WMNAcTPQzbJK6zsCXYS0i8m6jrEX9UBvG2hoLo60CyGqXPKLiOP52Dt1WuTAdTOHulXXhYaCXXaTJMNwS4hSvr5uFzSxxjtrblneOWnGCmsTZDYdHg3WxDug0ia7GEeIDZFJW960ZG3wLuIl2+jjOuOVvagWCPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7516.namprd12.prod.outlook.com (2603:10b6:930:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 18:05:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 18:05:57 +0000
Date:   Mon, 16 Oct 2023 15:05:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231016180556.GW3952@nvidia.com>
References: <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
X-ClientProxiedBy: BLAPR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:208:32f::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7516:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf99ae3-2761-44a1-adbe-08dbce728bab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2+NEaU7aSFmkWLNJuM49VPfPCOX71HPsF/oDTO1A2gLgdLy9sQeqKGL999jm1dA19zUQMR+98QYY++eTSbMm++TkggLSkAXmwkDas0o0L/TWeMCM/+5qBjQuhYdzZG5YGrn3Br1jmElMZ+7/SfjemvMGsmDzdn8RF0mgpuQJ4PoXkpVnNQek2UOHo3YZM3jcwQoHAOkvcWgIf+gxkuO/Ltz5wB8DwEoqceC4jaNtmpRbCU1Nko7dwgqGkOheA1COZEDYns27KmqKweIkp5Ws6NzPvnPditmdbftvob1kczPpBlTozvhgFObQzdUBVa1XBOo/tX//CHknmlUzTRiVpDxwVMYmAMmxXX2Xq4Pbo9sUc9njL9gQb0ilS/inkvGzBkMvd1sHm1fYrhQlKtVWMtiFy0x0HPrdM3cKQxU2iZ42tY3P/A4o5tVIweNCzbka3dXdc2e4592n3KpjozfjwU3oR8UafWoZtRvWyygieyvY2MQP84YMv6+Vl+hzWHHAoEPUk53pNAX3EhUmU6543MVvxJsFYpC67hlwO33RQvMBcIqupSawrCrDliNdhCq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(136003)(346002)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(478600001)(6486002)(6916009)(316002)(66556008)(41300700001)(7416002)(8936002)(8676002)(4326008)(66476007)(54906003)(66946007)(5660300002)(6506007)(53546011)(38100700002)(6512007)(86362001)(2616005)(26005)(36756003)(1076003)(2906002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHlOcZq0tTr7fQxAC52J37mgug2u5Y5iteONDhqQHDx0X4XrXbLOB4+0naD4?=
 =?us-ascii?Q?6hgR5oJb9P/SZ0AQofmjV6J7CFeQnyQSl8oBx8rKrcnIVbnZS10N0WIqSrxe?=
 =?us-ascii?Q?AkfxCyiSYBER+I4rv37sXnIKcPv/F884Qm3JUlxbu+o5/94/+s4r9bTRKM8b?=
 =?us-ascii?Q?uApbhiYR8PV2BZ8P3JwaZN81kbywQcNinT+/zuxoHf9e8p4LwFSXlh3d1Tvg?=
 =?us-ascii?Q?yNFNHji1Rgr2dC04oKqIjOCYkexOLYRDo0kiwcYlTxmo5s5An/aZV0hPOGtr?=
 =?us-ascii?Q?s3MVMjPZ60kMqRc5Ve7uBh+/KM4x8hJaTsI/FQYQFPzRW+zhytcrumNlQj1R?=
 =?us-ascii?Q?/4/Oz4kF5LlU+z0QLOjBHjAVDf/5MltLMg3VqAATXuga/nNDubzqjwkPjtVj?=
 =?us-ascii?Q?pjlILkCy8N5p73dW76+VHDAhO+pRM2FXkm5Uaoq1yxXCEQ0r4uXdvCS8ErbA?=
 =?us-ascii?Q?DuBlu6LTH66KkEd2yQUk6AH6GkCGbagtQ8ApHX6A48Cm/6SE6i/u9VIImrPY?=
 =?us-ascii?Q?4TowbecwEZMLU2IYcFltPj+iaBVQ6gPVo4tZwqu7pQ7ExGGCyfXUka6jOO0s?=
 =?us-ascii?Q?CqihAS420JAcK45143DDsgpsFchgS8ApHsuZDVTTmh5yo1JdAb6wjnT4k/tk?=
 =?us-ascii?Q?pWx0NsQe6l5HAg03DP9WMhEFSaT5YUOwo3dt1IzTIlndlrphpZMTuo1mrpaT?=
 =?us-ascii?Q?ZwNY+U5obZaQxJoMjYrpkPUPCAN514B4nlzzGYhDLkUnJi5/rPrW+4R0chd8?=
 =?us-ascii?Q?2aFEpVDy/tyq6Fud4J5wee56qgnyj9pa9hVKtdyhCxWVS3QCyLJSCLPZ7jrk?=
 =?us-ascii?Q?LWFCbRKGHApWR3fI+whVah4BjRtUFxQpJAzG0CV2sjcO4W2Mh88yO4i2N965?=
 =?us-ascii?Q?WzVQldyee6ijbsEX9qC+JJyOYPuvevn5LyJpsBfT/dV944kSdMGr7rzMmmUP?=
 =?us-ascii?Q?VAT4YzrKecoU7IFY8V6xmHLf29wTHwC9WB4Mr3mGYb8g+8QZrDntFuUyTrP7?=
 =?us-ascii?Q?mNQ7dHLF9B3FvIP7R1jKIuryjN7locXwThQyThswfWUfXE13/pWHGtG29ytD?=
 =?us-ascii?Q?HfO9td5LOYg9TJ5FMnmN1Aobk+L6nfWnJTsN+eyyh9hw8xau4jMXTGAIpRmS?=
 =?us-ascii?Q?as2TAZiX0kF0AMb9ZxrnFE72BJygklglUQqSOrPrIVgA4GtH0aseHZUYsBhS?=
 =?us-ascii?Q?zT7ssG0RHp7npEvcz+fHbNVas/FvY2nNQhbrYI3FRIslEBitlWqFwdOL0gq1?=
 =?us-ascii?Q?7B0s9V1zxYGAuFzey6WcZ2SQ25ifPpNGt+6wTL6fqEw5UQXMstjBnAp/ZDv3?=
 =?us-ascii?Q?WvMPdqEcimp8/YzZxYUkWn27fcJ/r18wkZxcJxjQ1rHMq+zuKF7WVBQyK8E+?=
 =?us-ascii?Q?r+C0L/0NxPao+XUKk18SQlX4aaVNNjTrkqX/v+snYdGCJ+SQ8jZNdgqw1d2V?=
 =?us-ascii?Q?T43/dEbxBwHa5ePFaXlbT9pJ4R4dI9kcJjeXX2GjV0HpFhIcZTwvz9vl7Hvm?=
 =?us-ascii?Q?T10C45IH/u9BmI6A8+VxX4J5VMPSVKzL8uFrAjqp1Y6uWqsZlonwKixkLwpZ?=
 =?us-ascii?Q?kNOxG5A8SYyyUaj/cieBIdH49Hu0DiZghOXPEtAS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf99ae3-2761-44a1-adbe-08dbce728bab
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:05:56.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mmt8WHxqJ4EiuHdfP7Le2m32ICiCKrS7M169Q4GE8S8tviTpuC3YiepATDVSUHN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7516
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
> On 16/10/2023 17:34, Jason Gunthorpe wrote:
> > On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
> >>>> I think Jason is describing this would eventually be in a built-in
> >>>> portion of IOMMUFD, but I think currently that built-in portion is
> >>>> IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
> >>>> portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
> >>>> to get this iova bitmap support.  Thanks,
> >>>
> >>> Right, I'm saying Joao may as well make IOMMUFD_DRIVER right now for
> >>> this
> >>
> >> So far I have this snip at the end.
> >>
> >> Though given that there are struct iommu_domain changes that set a dirty_ops
> >> (which require iova-bitmap).
> > 
> > Drivers which set those ops need to select IOMMUFD_DRIVER..
> > 
> 
> My problem is more of the generic/vfio side (headers and structures of iommu
> core) not really IOMMU driver nor IOMMUFD.

As I said, just don't compile that stuff. If nothing else selects
IOMMFD_DRIVER then the core code has nothing to do.


> >> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> >> index 99d4b075df49..96ec013d1192 100644
> >> --- a/drivers/iommu/iommufd/Kconfig
> >> +++ b/drivers/iommu/iommufd/Kconfig
> >> @@ -11,6 +11,13 @@ config IOMMUFD
> >>
> >>           If you don't know what to do here, say N.
> >>
> >> +config IOMMUFD_DRIVER
> >> +       bool "IOMMUFD provides iommu drivers supporting functions"
> >> +       default IOMMU_API
> >> +       help
> >> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
> >> +         drivers.
> > 
> > It is not a 'user selectable' kconfig, just make it
> > 
> > config IOMMUFD_DRIVER
> >        tristate
> >        default n
> > 
> tristate? More like a bool as IOMMU drivers aren't modloadable

tristate, who knows what people will select. If the modular drivers
use it then it is forced to a Y not a M. It is the right way to use kconfig..

> >> --- a/drivers/vfio/Kconfig
> >> +++ b/drivers/vfio/Kconfig
> >> @@ -7,6 +7,7 @@ menuconfig VFIO
> >>         select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
> >>         select VFIO_DEVICE_CDEV if !VFIO_GROUP
> >>         select VFIO_CONTAINER if IOMMUFD=n
> >> +       select IOMMUFD_DRIVER
> > 
> > As discussed use a if (IS_ENABLED) here and just disable the
> > bitmap code if something else didn't enable it.
> > 
> 
> I'm adding this to vfio_main:
> 
> 	if (!IS_ENABLED(CONFIG_IOMMUFD_DRIVER))
> 		return -EOPNOTSUPP;

Seems right
 
> > VFIO isn't a consumer of it
> > 
> 
> (...) The select IOMMUFD_DRIVER was there because of VFIO PCI vendor drivers not
> VFIO core. 

Those driver should individually select IOMMUFD_DRIVER

for the 'disable bitmap code' I can add ifdef-ry in iova_bitmap.h to
> add scalfold definitions to error-out/nop if CONFIG_IOMMUFD_DRIVER=n when moving
> to iommufd/

Yes that could also be a good approach

> For your suggested scheme to work VFIO PCI drivers still need to select
> IOMMUFD_DRIVER as they require it

Yes, of course

Jason
