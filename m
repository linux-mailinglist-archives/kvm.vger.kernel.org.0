Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931E555A25C
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 22:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiFXUNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 16:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiFXUNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 16:13:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B13F1EEE1;
        Fri, 24 Jun 2022 13:13:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaDNfR5vlWvSP3G5rl8HV+Y7M+LBxv1gVvErjh+KUmE7AhMy7lfDCSjmwOyWoDX6A60QQn9xw0J+xngRVAEmR2/oZex+Ws0dsNQr6FUsygUu0PN4VesX7q+uiZyAhF9Db2AT7cTNk7By3TAEB4wVSsSM1bcQRQ/U9B+ZbJGcZJp76IhDiagETz54zDTMpLTtpZsMSForD8bRTXOq3y0ZGYG/xY/gcdq4zgSaz9Nm9fJoSqmVRxhhyffcY8mfiAx4n5qVwk92fDsy2+F1KENFjyee4IQ9byD83Q4UETJgqbT+p99n9QZ6UzTyV0Csbcn3XBJLP/DWXS4b4eTKLE6eUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzgnU+TMHr+pm9HolGrJT7h1uOTC9zJLZyYoG6PBbiU=;
 b=n68f5voOfZTVNPadJjMtBxT48HpQrOzynlO/17QMARgbm736EtL8d9KDJMXd1tzwHGiZ1hPUjZzjGqOkfeBnCBWvI0RR1tvnudnVBFx4WsDYLbAnq1EygoLa8jjHq2tMvBPjVpV661X6mKyjyYj0BwJ+h31cetxbvnUy9A2AvYBZ6cM7A7K2gm632QesIWyn5FFGGtoorBkXufs5xbn94YkMMfArf1k+4n0et7/dNfJ16rDvObFfSEpb0/lXFR4qCR56XZ21rHKTnB7XRyzxpQ37mLsadZfoINlUjEiVzgpkFd/zKqR9APOAv4cOVyQMr5Gp1KSHZ5SLWLBdC+0znQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzgnU+TMHr+pm9HolGrJT7h1uOTC9zJLZyYoG6PBbiU=;
 b=PVFurWXs1kaA+VNCKewAOYtKtjgXQ/ELvW3V7BuapIzcK2UYknuKxNcInPpgtAvjzjS3SOoM3Lde3udcFp4IwJPB1wMSZQF4FbG+kPa/otZd6vCjiCPm8YCxvo2Bx4p5s5gr3ZhWkhptgBN3ZmUgkLCJYkBvCwC1fcwBNxY5jyElml8mmaRPrq6W7h3RTKmw/fUMug9/2iJCqgBK1PObQZRU5ZViGC540RjA8kLFgEXewskbf5Vxrk2NETwdOcHZuzVdtTCIobAQ6XpRRDpWGWpop+P8Qt6mHJ3UORtyewKx6hFCU1iUwEbqB0oslcessvjEMUTYl4dpceVlYGI5fw==
Received: from DM6PR01CA0024.prod.exchangelabs.com (2603:10b6:5:296::29) by
 BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Fri, 24 Jun
 2022 20:13:06 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::c0) by DM6PR01CA0024.outlook.office365.com
 (2603:10b6:5:296::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Fri, 24 Jun 2022 20:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 20:13:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 20:13:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 13:13:00 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 13:12:58 -0700
Date:   Fri, 24 Jun 2022 13:12:56 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Christoph Hellwig <hch@infradead.org>, <kwankhede@nvidia.com>,
        <corbet@lwn.net>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <borntraeger@linux.ibm.com>,
        <svens@linux.ibm.com>, <zhenyuw@linux.intel.com>,
        <zhi.a.wang@intel.com>, <jani.nikula@linux.intel.com>,
        <joonas.lahtinen@linux.intel.com>, <rodrigo.vivi@intel.com>,
        <tvrtko.ursulin@linux.intel.com>, <airlied@linux.ie>,
        <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFT][PATCH v1 5/6] vfio/ccw: Add kmap_local_page() for memcpy
Message-ID: <YrYayPvA7XlCZLQ2@Asurada-Nvidia>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-6-nicolinc@nvidia.com>
 <Yqw+7gM3Lz96UFdz@infradead.org>
 <20220620025726.GA5219@nvidia.com>
 <YrAUZ7hXy2FcZcjl@infradead.org>
 <YrI2Ul/u6pRvt0rT@Asurada-Nvidia>
 <20220624135615.GO4147@nvidia.com>
 <YrYO/KAa2bqmxEIu@Asurada-Nvidia>
 <20220624193042.GB4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220624193042.GB4147@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18334a95-48f9-4aea-8e72-08da561df32b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3527:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BG9z1jxjs/MCm5kz344subvZiOvaZ9apsFIkixu7eRRYTTkhr/ieoQ9CV9nvlOwrGkHNfCCLvFpZZdCNBB6NjjjZY3kldnsB4Zk/qAlqPuaKtiHszeYdqSrdLgkkyln3uYaxzjhErRv6V99jACT9lO0BDiq4OHZRJApWiSKBfTV4loarQnyw4+DPBSOmKP/P5dt683ZAIjqguJ6JtGyUcg5Jtnf/7MqgckA4KI9Zy8377km0jzAtt+t8p3j8Hsn3zP5Fc4r1BI/Z4Wa6y+7EABG298C+Qw4WSzm+1MTyZwmqjNRdMtW1kaIF/o9djtrgVHMnyrImDo50IvEFLw5ZQ795iMLpcaYIBAj7iI5dbEj3bMVpGXOkt7jynnL65Ceh0SWAhQB0Sdn2mjd0VR62AUd+tT9ZI51QnL7WZvU9AXMOMYinyE4f507Gnzy5LLiU3OMe8goUBcXDZZqIgHNaNbeSfYp7k9y4QKOIZ4H0n31v0fBbE5Ls8ECGYfKawPYlH/K3LThhL1C6mWXxouGu2/2ZbTSaAQEzLIJdqx/G8ZvZoOUr2Pj+Ozo/nYuxO+DeCTuuiCRsii8FPxknCkbjo7xblCDko65yzjGlsOlK+0mhe/+1Zw779yG4ucG4CqAfT/inrFDXrAMNaUt0No8Gb5EI+4c4pX/ZwJ9qByGceSaozM8WNlM+SepwwL9L+s9ogMM+Ch+d2hCCuFmff2PV8F6Wkdz2qY8c0c0NSA8lbrodBy/VAzubxaylzp4k7Pe0yU2UE4mkUAVWvHs/vrmgQ6Ka72htZBgx25YHDKa3D37jruI5kfwJOwQwMnZpcySBafyJChclNjT/6RconPPrpA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(40470700004)(4326008)(70206006)(8676002)(40480700001)(356005)(82740400003)(70586007)(82310400005)(36860700001)(83380400001)(2906002)(55016003)(336012)(186003)(426003)(41300700001)(47076005)(7416002)(40460700003)(54906003)(5660300002)(26005)(8936002)(81166007)(7406005)(6636002)(33716001)(9686003)(86362001)(316002)(6862004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 20:13:05.8229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18334a95-48f9-4aea-8e72-08da561df32b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3527
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 04:30:42PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 24, 2022 at 12:22:36PM -0700, Nicolin Chen wrote:
> > On Fri, Jun 24, 2022 at 10:56:15AM -0300, Jason Gunthorpe wrote:
> > 
> > > > How about the updated commit log below? Thanks.
> > > > 
> > > > The pinned PFN list returned from vfio_pin_pages() is converted using
> > > > page_to_pfn(), so direct access via memcpy() will crash on S390 if the
> > > > PFN is an IO PFN, as we have to use the memcpy_to/fromio(), which uses
> > > > the special s390 IO access instructions.
> > > > 
> > > > As a standard practice for security purpose, add kmap_local_page() to
> > > > block any IO memory from ever getting into this call path.
> > > 
> > > The kmap_local_page is not about the IO memory, the switch to struct
> > > page is what is protecting against IO memory.
> > > 
> > > Use kmap_local_page() is just the correct way to convert a struct page
> > > into a CPU address to use with memcpy and it is a NOP on S390 because
> > > it doesn't use highmem/etc.
> > 
> > I thought the whole purpose of switching to "struct page *" was to use
> > kmap_local_page() for the memcpy call, and the combination of these two
> > does the protection. Do you mind explaining how the switching part does
> > the protection?
> 
> A 'struct page' (ignoring ZONE_DEVICE) cannot represent IO memory
> inherently because a 'struct page' is always a CPU coherent thing.
> 
> So, when VFIO returns only struct pages it also is promising that the
> memory is not IO.

Ah. The "switch to struct page" means the next patch that changes the
vfio_pin_pages, not the pfn_to_page in this patch.

> The kmap_local_page() arose because the code doing memcpy had to be
> updated to go from a struct page to a void * for use with memcpy and
> the kmap_local_page() is the correct API to use for that.
> 
> The existing code which casts a pfn to a void * is improper.

Yes.

If I understand everything correctly:

A PFN is not secure enough to promise that the memory is not IO. And
direct access via memcpy() that only handles CPU memory will crash on
S390 if the PFN is an IO PFN, as we have to use the memcpy_to/fromio()
that uses the special S390 IO access instructions. On the other hand,
a "struct page *" is always a CPU coherent thing that fits memcpy().

Also, casting a PFN to "void *" for memcpy() is not an proper practice,
kmap_local_page() is the correct API to call here, though S390 doesn't
use highmem, which means kmap_local_page() is a NOP.

There's a following patch changing the vfio_pin_pages() API to return
a list of "struct page *" instead of PFNs. It will block any IO memory
from ever getting into this call path, for such a security purpose. In
this patch, add kmap_local_page() to prepare for that.
