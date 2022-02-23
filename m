Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3818C4C1A3D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243511AbiBWRxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiBWRxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:53:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CB295;
        Wed, 23 Feb 2022 09:52:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJlq+dvsQnhP4bGhxlYn2AxoPg1CXFOAEsjV9Zj2n4QDbKiMfMRchPxKAQtiBWF/zLjky1zSCD4FYYNqGRMHua4K0TNgsAfRxbQF6zeMuFGnrXfaTbmjaBfXy/uj5uN0DTCq300GQJKvpheoQkOwX+p1LqnNtRzI1YKaPCzQ9BGZ9A8mGK4gSCjMBOqTmHTUr6BP1lkW2ySn7afBEs6J3/EF0ZV5ASG18/NYrhjQwlkJ/ofRXXuMyRu0732XFp0G90co0bmfwqJEZR/M+xpDIQAZlnxW8ywHcYB8wui08V7KprC2Kh3WNRw5OahrTb5fQYUaeewQ4pJ7wnrdRcx5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWWq+jlx6OU3Vr6fOuzHGPFEw1rhdT6586JlvciyfIw=;
 b=RxjPa/G094GfPYbia8GYvHneOPnx2Qu1+EmOyb6jutk9UkUu5k3GiMLoCZzJVy+6pl3oNxHqpiYsVIDRPeuBX83DHfyXrT61/7D1+PtcTJoRbzB8mDFMsC0bP0/svpdliQ5rK0FbsOiWWzd1vAjoiE6lzvrkmhAx+Q9RtZAGmu6BuBRwZ7GWxhUPA96rDHX9zDYIF4weKi++KG9tr9q2rVh/1ft7wNxwHFxhNDKOEaBYEZo24BToeYzp+zSPPFUuJdGbyQCx9ZQsQQlW2D0xZqsay9yT30dyM/H4B1EUmZQVWuo4Jy8zOLdy7XSqgBG/ukCQYk7Rfjg4QcJo5PgeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWWq+jlx6OU3Vr6fOuzHGPFEw1rhdT6586JlvciyfIw=;
 b=mDLGKw8tM5qse/RXMgLe5K2FiRigMhGWnoHZ4WbSRsRBofc+QZW5rcqQHZ8FhLCP3lutBNFXwQLBQW+HZN8IQH1sAKLxVfEzVRwHVt4OU/0Asp76solbu4GT0VomPrAJIjJBiJ/HmU8WXCGsm4nIVUtv0bXvvp8FAERMCNxuRg8tuYJ5U0OXRqV5lQ9gJY2mi62gMto9pmIZvZ16S3nx2Hs//QX2Kh1mo60qvMoX4e4Iutr7BqNKTMX2zsQua4i0a3Dj3vZse55qYZYedc4LJdkHOSQrxEut/S+OxLvuRCATjYZQci0qj5rmNcAlvJ9OxGDDJQDRagFmZDCOkNkn2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2460.namprd12.prod.outlook.com (2603:10b6:907:9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 17:52:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 17:52:38 +0000
Date:   Wed, 23 Feb 2022 13:52:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220223175236.GS10061@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
 <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
 <20220223005251.GJ10061@nvidia.com>
 <20220223093443.367ee531.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223093443.367ee531.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0440.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9255daaf-d3ad-48b9-3965-08d9f6f547bf
X-MS-TrafficTypeDiagnostic: MW2PR12MB2460:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2460699903EDFF398401ED2DC23C9@MW2PR12MB2460.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fjZmyLm5pEnB4gEjK6hl0fmSIFYFnor7NTWbJn5VrpF7p7lJtjujsAz4XuMlJ8bPd/v3LvN3G57ziNlAEu6x3lnNS7uVTrSyLV5bvRHjzMjhHq524NL91A+99UfKz4DCtZewEZi6QJTeIcO9T9f4Xi2EgVWGCGeTRgMAHGP3Ty3v+IU4WhdnS/wwIHE7As58/Ql4QTYTf2bcdBsGV5q636ZW1xJOE3holGHL27+RZqvPCh22CmjEw9xAzt8DzhMtjvVW7uPpseQamz2trCo9Py+yKdk9ScqNtE1PAwhCmlleUPjK2/txEVxwkORxEy4kHYfZwijBftnzZMvA6TxOLzbNBnl906KMAneBFYyLGduqKzewBCmPlTT0D7UjtW08r0/EF/6cvKg6GhJ661rsmLvka70sPTGOMyRZMgb3GelypfVKY4HHDmolTMbMYvDEMAPd59UEgU5NDlT/6rvWYMqqtMEUMrpgztBuzVZwKCLKfsuXWk4F38dT9kkbaEMcsLm1m7LvpNorfOIUll+2al2o3fBaehlmse8knOXE/D38DB2X7z1JYsGOaWwsm4DBKC0fcz5393GkIgvCgXLz2G4o806cJ5F7KvC1C2eu36LLrTOjsyLasO+KOMyfgHlyVpph+GO4bXghVq+SprM3+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(316002)(7416002)(2906002)(5660300002)(8676002)(6916009)(4326008)(8936002)(2616005)(86362001)(36756003)(33656002)(38100700002)(6506007)(26005)(186003)(6512007)(6486002)(83380400001)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xJoOPvRDa+7U1xkmbUjUoQ2GcBkcIVhX54y4pZB0B7nstr0d8HHD6FL8Dc/U?=
 =?us-ascii?Q?20V7LYIomRE79y7r5rkmlnnUm8nr82BA8TYSgBo0DKlAl+qSHvrY8svqf9fS?=
 =?us-ascii?Q?xD+XJSyTMjnkfVEcSC4uRHuP+WjyX7ZzpBiPXwM6gy+QYsTJPNgo3TQ91id9?=
 =?us-ascii?Q?VH9pVcrRH0OmlsxGASN39t6iHMvl/t1flMjsuBLtoaPXLBQSzWSaP1Ybk2LQ?=
 =?us-ascii?Q?2vz/6izVYT3QqibxXLvEn1NvPKptFwrh8ctvinHYtHw2llNejuPRtn3XKwA2?=
 =?us-ascii?Q?zKYf+mXe7nLT8VERUTj8oJD+xKJ8LYA1YOYNJsBD6koJqmX5Vb6Qw111dBpt?=
 =?us-ascii?Q?QPdX3RD69GkK76hGHTNFlaZcJTJQnu3H+X92SHQxeUDxV0FVfH5s8EXAh8ar?=
 =?us-ascii?Q?cmersZFXZV0mo7mYGvfKemHUS44JSinc2no/hv7LC8sMx1hrYRaZ8mttpzfz?=
 =?us-ascii?Q?HiudRx/92sdEHbH3EI6gJuXcxMzh8Z2v2HRoAKpBY9zHruRWpb4dGXURiod9?=
 =?us-ascii?Q?5/FiT3zyE7jIibOBz8SjkrsqRLUzpX7z5AY7TWw7/XtC/NonCPJQIhFzdsdA?=
 =?us-ascii?Q?5gNf4pdi1G7p985j17kl35/91osK60tpgw0TwnBmeoY9sKc8HiblYNJZRzAT?=
 =?us-ascii?Q?IGz0y7JzFwYlxe4qs5drMz3C1aKubFtQZrZkvqaS1rMpU8ML9fKDPRqaOlXh?=
 =?us-ascii?Q?PuyS9gjJj0Px83VMxPezT5MArX0+Z2PGnWexQH+vjz+w+xpTB0XDWaFSZqNw?=
 =?us-ascii?Q?l9rRfZ/XVdUoMCKqUS0qsDhin03w0ZJFhZoOFhGhS/kdPtsrqzDfwHKrDcEQ?=
 =?us-ascii?Q?kHVWQlDr3EYXBlFiZFgWnZNGJSAjayAPnk2o+Cn0vhLJuJVN8iAMUhGjF/DU?=
 =?us-ascii?Q?GJ0TrBBIuZUTVo5vr/KV+giIceGoImfWuMHhjGT5ydMUYVWZqxTPU51imY2/?=
 =?us-ascii?Q?6ovPKYcxbLn43kESV9RNs+zDL19Ru2qMayMWITMW8XPA3TEdvNZnO+N3OY3g?=
 =?us-ascii?Q?lOYoTp+L1fMdnV35ut8nxPPkhLLsJfL5NxWeZjQIzTkL8DdDeW59YvOzK7Un?=
 =?us-ascii?Q?9zQv3vQTe4L2WkWx5tqAHQQrQlTt3CrLwud2Gnb5mg5mCmFE81PT25dwmcli?=
 =?us-ascii?Q?J4uE4dSzDfh+oKjLE/fRppypWqSzyG485wHjhWV9xg49B0tXDZubkWAuCwGS?=
 =?us-ascii?Q?TL+R28ez95qBIwhQdRK3ateHmenbG9J35wMVUOXchEYdrWyuHyykjiqf3Anq?=
 =?us-ascii?Q?q3iRg5OTO+BqhCDbFi6cwuA2HiScHxk7RWQ0qaztgr2MSyrG7/8cZAMajJV/?=
 =?us-ascii?Q?FIVMC3GpKt5gBrnVC+ES2DHHSNzBch9BBQu/2RkaWZDMYnbFDN+8rwsTmorL?=
 =?us-ascii?Q?fl/uwVUBbB2rjvjG/5+yqTYKiOvxSNvsumC4VAKWnEciFepjsfrw5iXlaSGF?=
 =?us-ascii?Q?JJMQr4tAYCH4v24DH/o9bJFjF68AZ1wxGDGgOkg/GRzEPnJlsZP13zkOMHH3?=
 =?us-ascii?Q?7K9X+mSM+qRSYd9cvefcgsIJjh2p5TqIJm16pGHV9v/scFxcgRbc84r9qqA+?=
 =?us-ascii?Q?nM9oTgCSvwiQFfqoRe4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9255daaf-d3ad-48b9-3965-08d9f6f547bf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 17:52:38.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIBvgv++M3qVUYIvvdyRWz1B7/eitoei0a7tZNVnn35IstX2CUMIxNuKgRhzRPQf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2460
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 09:34:43AM -0700, Alex Williamson wrote:
> On Tue, 22 Feb 2022 20:52:51 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:
> > 
> > > +	/*
> > > +	 * ACC VF dev BAR2 region consists of both functional register space
> > > +	 * and migration control register space. For migration to work, we
> > > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > > +	 * But from a security point of view, we restrict access to the
> > > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > > +	 * override functions).
> > > +	 *
> > > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > > +	 * HiSilicon hardware platforms are integrated end point devices
> > > +	 * and has no capability to perform PCIe P2P.  
> > 
> > If that is the case why not implement the RUNNING_P2P as well as a
> > NOP?
> > 
> > Alex expressed concerned about proliferation of non-P2P devices as it
> > complicates qemu to support mixes
> 
> I read the above as more of a statement about isolation, ie. grouping.
> Given that all DMA from the device is translated by the IOMMU, how is
> it possible that a device can entirely lack p2p support, or even know
> that the target address post-translation is to a peer device rather
> than system memory.  If this is the case, it sounds like a restriction
> of the SMMU not supporting translations that reflect back to the I/O
> bus rather than a feature of the device itself.  Thanks,

This is an interesting point..

Arguably if P2P addresses are invalid in an IOPTE then
pci_p2pdma_distance() should fail and we shouldn't have installed them
into the iommu in the first place.

Jason
