Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739AB4C157E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiBWOfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbiBWOfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:35:44 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A683B45BF;
        Wed, 23 Feb 2022 06:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c18o4g8XBZ1iDSURzCyCEWHxagDJrIVpifqNEk37XQ2E2cD8D7J6Rl48WnPibYjgiQ4MvNMfn+AGzAY7e+XfwBkJF0i4YKyMW2EAMsHeJkFR2RJL0pU0uGuzit/FW7L2ZR/h8TbWZ/YFaJGcUzjYdmsL+mft8wlhhsmbXIvxqLtTazCZq7yhXofCX5oI8KDwPGag9z6GLBiKRgj8KOyzU4N7cHwclMunC6IIQdv2O9REIkt+LuisADfleqyB/9sk2CXaf406QzbGrwWvf/30spkG56ED9idM92/kybZI6Aoo/++37ObhH4CxsLG2RoutCgEtu4iZS313X1qDGM19Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WL1TS1p/lixYsoXYxqyDN4AyHHjts+sv8JrtimALgLQ=;
 b=BOrxhsmv7pK3561P6qu63TfXY3x12ONWoCWxlZUhQvMs0QSJAQxOqYYDL6s2UMzx/mON4BQJdoaZAfUqW0bd3v4GT5D8N9m7MO8zULUW9cEPPQhmHZtD0z2UcF6yoJfhsfBJr3sD7sRkMj7OgkkmlyrRNgqVAsF932VKDF1VINCBYx6iknt9+iVKMJ+QhBsUq3Gppu24xXV1pGHNdYCqIJFr0XzUdqCd+76d4pJwBHp/d93VFUpi+G4wbeGkts7O9qeRFFBy9X7wd5aGKrWVKrvxiUMj9YfHEo57Xr6cYY3FqvhKqHh+UvsqXm7q12vU11pZ6AixxguTxFsY5KpMug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL1TS1p/lixYsoXYxqyDN4AyHHjts+sv8JrtimALgLQ=;
 b=jV5M6oHtUdm3C0uc1/tdHRobumHls7qYy0ujdZzlstz4NTyzTQ6ndz7zOeLocmO2TZksGZYBDLDZjAAyIHIRvBLfNwwvEB4SGDMDxqKQAkc6pnBc/mYaHwJkOzPSIj5pFlXuoxOE2oPWiG5ezMkd95cIqfnDWIJ1umCNAlceU6QAeTVFZeWGNBoPBNHHlQ454iJ7D7tYAPLw2Y+PAn/oSHYzgRtvinR7a/bJUS6w5QH9EGLBj8/Dl2OCKjrgFVrghDWDeUOtZR4iMm8+XX1vpLcl1i7WMOw1DYBSEGKk408zmpRLndHNrO1lFBW0eVvZfW1ha6VZeSxZ/H5pYGzHcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4420.namprd12.prod.outlook.com (2603:10b6:5:2a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 14:35:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 14:35:12 +0000
Date:   Wed, 23 Feb 2022 10:30:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <20220223143011.GQ10061@nvidia.com>
References: <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
 <20220223134627.GO10061@nvidia.com>
 <YhY/a9wTjmYXsuwt@kroah.com>
 <20220223140901.GP10061@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223140901.GP10061@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:c0::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1bd182d-7367-4820-8905-08d9f6d9b328
X-MS-TrafficTypeDiagnostic: DM6PR12MB4420:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4420AF0B55B53FFB0F0813ECC23C9@DM6PR12MB4420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMwxsdhf5N1EGDt2mATS00qLr83KYwx3BKCWaOfMVeBoaENTt8MB+I2X4CekdV4C0+tNfpmoTNr6JRR0HytaMo+2zhZUCDDEJNPFB6o1sDiiW6rBmHafw7wFcmPmpkfix7z3BPBt41YwvYYcJrQe0RKh7Exr5+rhup1R0s6TAIhntpnd7+aLVVsWDCbRb7JWaFJYoT7OEbFam07nXIZcig5bWwdQNfwikNq12G2hljkprwt0j4kfLaDoeyKrp2vY/980j+pxni/lhVsMqMjLXUXCj7W95mrQJTIJgWwDrvcpIzROdmZtq601XcT/YIxv80ZmjO+BgYIcR3/g5spS2MBN4BsvsyrCNNEjVRFcD7LARLSywMhqQKxyTSfKPDAKwqCP8Ql89igAun3EsCzyDeh5Br35Wr4s9wRc12qBDMPE6Hj0sYKfsNWbtdef0tFRi0MNMx5EyWnWEYZ2Vjl8yczKpT87KUZWD/I8cANUgvxwq7jerzoKxhR3VomqO/8De0ywbgHtGlIJz+crZV1o7w4AwiXyYnTuLpqnHLP3A1J4043s7P2f2x0TbZFPQMEe7BEbvoX5B/veb20Bp19rGr+iXOrtE1VYI/0S7qGkBPgnNcRCTQEVqYADzEFP2oiCuqi5z5fyWVmz6xL/Be9m3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(2906002)(316002)(38100700002)(6512007)(1076003)(7416002)(54906003)(5660300002)(83380400001)(2616005)(33656002)(6916009)(8936002)(6506007)(4326008)(66476007)(8676002)(6486002)(66946007)(36756003)(86362001)(26005)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qnO0uq0QtCt3Odf1MSFlaGQzcEhkR98xPLHoVFtSBkIb+49DlqoaV9oSlATu?=
 =?us-ascii?Q?vDZTJFXQWBxGFxbwTVYSq15kf38ka2rrSiSAlUd1RtJ4IKEZFg4MgWAh6xYG?=
 =?us-ascii?Q?WTc+E2KmewOGzqvjrSt7n/RQfY55vK0mZ5g39Y1osXNNDUgcyPiyonfO/qsD?=
 =?us-ascii?Q?8nmOY6nigAEueLV0OmSGYUv67OTni8zwheQ4aIbo19ZYUZQLanSvjAN2pp1I?=
 =?us-ascii?Q?TVmbTBTh6GnMzKTjfuLC+ZqoQC2WkL5DpF2VUAhzPkx19COwgWZShT+uVhqN?=
 =?us-ascii?Q?t7Fb1gsFsigmAWcczp6l/btzyea53DWPTBsqz84ZhKmeZLiy5DvGKebtE1B7?=
 =?us-ascii?Q?V5kYhpoXTXsqcK+8T7in1lHv1I/GH5kl82oEDDaez4jPf1OA+B4bZbzy5dXY?=
 =?us-ascii?Q?iv0+HWKsyTyXzZPCuYe+gkwSlMW+6Xbe3/T7Ba0B1a6W+80sskYRdB09FIvY?=
 =?us-ascii?Q?Za7ExPqaHHrzIq4uqgJ0wUhgebFL/tWAcYYkF1+CEBT6lfyCONNdkG70XhF4?=
 =?us-ascii?Q?jYX1BkeWE0FkRWbOtUCtLvidf16BLim9FYf8wLorhy40PILca7xJG9b4s7Af?=
 =?us-ascii?Q?WL/VjIKvT/o2C+nzOhg/dzG2+ouq7Us+YareUL0T8c78kW7mbDn0UjD6k2H/?=
 =?us-ascii?Q?KB3K9jdPhHf7gxvv85utemeReq3VMdb3I2X857YwWm4H/oFdcq6vTHTqxuPR?=
 =?us-ascii?Q?iNn8HYkZC3iXYk3drUzo6N6q/1KMP+cdERaExYtJu5q6fv6jnzbWdFW7jn+/?=
 =?us-ascii?Q?bLURlxzwOf6XD7VKoozldtDXkdjMSP0qXLinkTNCWwcXRTOZEYkuJCB81/xZ?=
 =?us-ascii?Q?LIVjNgLKOQiaYNSEQAJfjykEILQnzZssHMJUlnJjeQ5VFsoS7nC6wSH9Uh/c?=
 =?us-ascii?Q?yPI7Sat4Liypp37s7pKKq7Wfl4ssHgJ1H8gOBdo5hXP9qDiDzudHdcEsj6mR?=
 =?us-ascii?Q?B6o/1fAcWktHkUMoMOl//2DV+B9eR9Bn7jzBxPeQz/pA7bv1/cyVYI7f0ath?=
 =?us-ascii?Q?57bBrTwujfOnGpObSPR3IGc3XQOLo2JUSVJVfrutlQVhI7DMTArU+Il2LQuC?=
 =?us-ascii?Q?Jbn15cYWG0+mV2V+FpKzTgED+r1GvC8UNXRnmnjd53ycjJl8Gu95BrEt1dA8?=
 =?us-ascii?Q?hXD7bCuf7NgvtZ6hdjXnnuE4voxNIRxDvHxPMOj+WIdP+fDFE/whhQNXSpiO?=
 =?us-ascii?Q?LIlP08DYhYyycHHwDqgi9/sdFWjFQ40B85bG1njvRhRbFqJz+JQjv6u+JbOj?=
 =?us-ascii?Q?CJo4wPyXdROyNh2og/JsQjFhVMyCpVNn09bQApvcRcS3+RYxaW+8UrHBvRPg?=
 =?us-ascii?Q?cA0+w/nKsNUF8HSrWhNW1hsU73QVx4voonKd7VUDgioFygclEiIsIdRdWgfo?=
 =?us-ascii?Q?UTOm1MXKZBVCXLckrIVc0kSUWtHUPwR5pDBazIGxofODfHYm3p4OGoOBzAjs?=
 =?us-ascii?Q?6xz0AFgKq7OfD3BsbQhUBTiw1s2BupcRlhhNE/oQcXDxn8A19lS0JGwdA3Mp?=
 =?us-ascii?Q?9FLwJ4xg1okQ8hl4k65gY+Yl2Il3Jk/QscVR6E2EDUmyDPhNciUD6HT5XHzL?=
 =?us-ascii?Q?zhkhpq3hdZTiDwEOzl8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bd182d-7367-4820-8905-08d9f6d9b328
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:35:12.5156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUOeJnORouauzivGz2xYR6zeCUS1sPuXL7xYEG/NDBZ1SxPplWPGv8TvWZndv52u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4420
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 10:09:01AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 23, 2022 at 03:06:35PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Feb 23, 2022 at 09:46:27AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:
> > > 
> > > > 1 - tmp->driver is non-NULL because tmp is already bound.
> > > >   1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
> > > > DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
> > > > its removal does not release someone else's DMA API (co-)ownership.
> > > 
> > > This is an uncommon locking pattern, but it does work. It relies on
> > > the mutex being an effective synchronization barrier for an unlocked
> > > store:
> > > 
> > > 				      WRITE_ONCE(dev->driver, NULL)
> > 
> > Only the driver core should be messing with the dev->driver pointer as
> > when it does so, it already has the proper locks held.  Do I need to
> > move that to a "private" location so that nothing outside of the driver
> > core can mess with it?
> 
> It would be nice, I've seen a abuse and mislocking of it in drivers

Though to be clear, what Robin is describing is still keeping the
dev->driver stores in dd.c, just reading it in a lockless way from
other modules.

Jason
