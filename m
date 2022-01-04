Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9002484881
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiADT0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:26:19 -0500
Received: from mail-dm3nam07on2075.outbound.protection.outlook.com ([40.107.95.75]:12731
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230166AbiADT0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:26:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCVvas4y2ENvwlC73CfE+DfbiDU/oPZdTV7xcEg/934/6qlHUednn9CHSV0oObz6SwMQFYUOCqtowm26fzKdVWuWTCgqpdxXj6CWcfRiQKAOWm1B7Jwg/rvQgazjw7/ZhQLBfcwCLta/IRrLU0HnAxb9SXpdVKwYGFzDOMXkqowquGSm3YwU8wIAwCAdPUXbxqLS9W3+34YtAl2mgbOOKjUEUPDC4iVEW9hU7dHurQ8WFn1GzRZAMFksQi7wwzfRy+9D7qIVl6EF3Cyyp3Gyb94InNYicEXjiGOyJKK8AZPw5Hy+bX7IiFdMBk0xroiXH/qM7v3mDScBzWf9eLw76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JLYtMBMfl7ZZLijUBveo/GW7QLOIY3X36zPFaLkzO4=;
 b=lMgrx8SmHUa0ZjoiRfVMiMlHSpsNKZNQBJCB//Gf+5BonwB9xAitKr6LEiyvbdmkByd7a1uVSihsj2qOi116JCF4LhT1Zm4YxhK7HF8nQCQ/WCmm2W1T8mSO2kicXxOBqP07mVUbh5WYz3+dgHYJpo+q3/5VUyhq3+sbQeCk6G2PFF+ZDhWaF0LsgWJxDJxwu8M3DZ0DipW07qb77wgmZQcor/JgZrvS9YHa+1wxfpWxwfayXcqZEArSN5PSuUj9KieipCMrZ75R5MyX5CPt+aI3nJ/m2foLWTxGOb2MKSWmh9CKwZ9ciXSYvcjUuEfQtFwXAmMH7rDOYX9W4l2bfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JLYtMBMfl7ZZLijUBveo/GW7QLOIY3X36zPFaLkzO4=;
 b=sXqLcN2QZtIjsGJKMd675jhGZFQns6nbMJy0Jv+H3Uo/9nOaaX9+NdG5nrTREZq6TmqX4/IbEuId3homS5f9fqI5GINA3S3sz1KU5mCmB3yryyQHCmsjKl/jwwLGeE8sjFdFyFHE2zs9vTVyUIesTRCEVCUyImI3lPCEYz3pNlB1zoeBGI7z7F9OjJTbuRvSNKQNKK6OgG4L0l54Nq6DXuUQwknz3uM6V/bt6+1UKvOi7AnvJJgpGUS9polIvnOzCFpgDIqdGJvxX1JV544wcPDsIRfefNniCJQCKzSYJhiHhVTVIl7lnlp3D2GVKl4uvKLZ6wO+4GAzZ5EIkBB2QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4823.19; Tue, 4 Jan 2022 19:26:17 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 19:26:17 +0000
Date:   Tue, 4 Jan 2022 15:26:14 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20220104192614.GL2328285@nvidia.com>
References: <20220104015644.2294354-10-baolu.lu@linux.intel.com>
 <20220104170631.GA99771@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104170631.GA99771@bhelgaas>
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2caa469-a856-4979-eed0-08d9cfb813fc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5198:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5198D9E283FFA319834447B1C24A9@DM4PR12MB5198.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxtX26jma09qMgTYVhIUzXKeLhbuMgvx9hNgLRJZ8N7kRx7v3cSSb97vMx8yHFOiUH0nlmWW1MSwQZjll2VclKlTqtGYbtzHZuF1th33ChT1M0oc4kqcr7wh4xU34uFfLXD526ZPm+KwBnghINda0CJHWzBVqp+5VJa/7drnuRSnr5AF7cbxZ7LcXYlssSi637R7irF0x/IND9XlFGjkhjvwXpVD3ZgHXcghiHZ4Vl4sMg+FpRlApgVCw2cqraUnO0CEVdrqkEuf79egII6on5HBEC/iHtTYM+aNBEiOL5MI7tXa1OUmg8D0XI9Y8J+T5GikKGIk/w0mGvBssmJqW3cNbqVi26DolZPZrMfT5td/+sEdVsfEljx+h4ZD/onzmLrWwB+AwYiwLDP3refChmQdpXDqHEBl6jnNG8c7dIuGImeSKlLJAPxJLymxobIW5hD2bl7+1G8R7mMhQzk89KWWtV/fUHRJZmFWKMvK4O0UGra7hubmsT7n1ExjPZPHeQUwWZciONyyhvt/79oEpAMgq7deXiMBfn4BbAVyHGY/uPwyJTm8tLU3I7G8J/TeROwLIxpdA36W2cdZG/1UTivpjIyI4Sdhg+f/UXT5YVD3mOKYREWlXp0ShYbeWh75inYtJIuYbAkzUxck4dIK3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(8676002)(6486002)(2616005)(6916009)(6506007)(86362001)(36756003)(33656002)(5660300002)(66476007)(4744005)(1076003)(54906003)(8936002)(26005)(66946007)(7416002)(6512007)(316002)(66556008)(2906002)(38100700002)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rc0F8cFIxKhWm1RO+FvjTent0vGVOBeQtDSIxjM6+fbB64H9QWsSM67GUGQU?=
 =?us-ascii?Q?5U38JVTNDl2WTo4xjlDLMHK4KAmB6kqXMsCEXJuTI5G6BaDydD/xA7Nms49I?=
 =?us-ascii?Q?JZFE9BkVrEBh7NVTBe0Lmha7cIzT846a2yLVG5/8MOc0qq2xr92qkkO3x5v8?=
 =?us-ascii?Q?ufcmjm1XGPLWuw3MEh/83apeIGlqK/K61sUgHTIRugd6JCL9v9UcuOzKS00K?=
 =?us-ascii?Q?ce5PwkGVJHCUFwHzq7O76ATbXOfraiQRKRP6qU3RIhycxOeURMBxNq9jzrPh?=
 =?us-ascii?Q?GuqdIukt/pbKCfnSeIqozQX5JKBUQrG5tQm7kxlT3k3qz73aoZsGHKoyz09q?=
 =?us-ascii?Q?gg7Z1yewjM0RscVI6b23JchyLFuL4IJmsz9zc383Q4EaCfPmO1A9BuAY/dwj?=
 =?us-ascii?Q?Gr2SQRkAHUj+nMqWAPsWiXUigUD583J2DIEe4tpe9uqaW2EB23g42011pFNQ?=
 =?us-ascii?Q?5n7jIXwwwvDMsZIKLl5+IIqS5oaWhkrPLjIECqoUIhrCtb9FQcy6oYn8rTxG?=
 =?us-ascii?Q?RRxF1nR+Fcl93tvnk+WXo7BWzNr7Mkm4MCBwfas5gosVZetxJdLjgLXwA3qu?=
 =?us-ascii?Q?6kP1omTHSCHiJZNjI/4idCwMgYuTpwz769zA5KhWnTNnb+jeKoK1cAXEmk1P?=
 =?us-ascii?Q?Stqz9cmeKgFeS3kf44GGPthym5V7TnaE7VQWYG/3I9YTdlPoELXrbDEfaeJ3?=
 =?us-ascii?Q?bZDH2hFq1BQc/qiXrySp44qDfR/j/FLwxrwD76bIe6E68w4M0V5cRa9kSh5E?=
 =?us-ascii?Q?djzl4Csj9nDaOqIpoCuQy2ElQREeCJ3Df1+DYjLImsvlqLcduQtqJD95gxu9?=
 =?us-ascii?Q?nwdD99InpAdkSGZUuW+MHPZTJdhFQJBUlBk1wBN93tSqCLQnzzyNKNv92GOl?=
 =?us-ascii?Q?e53aQ09yCkV+FW24mad10vnzYkYYLIK6Sczd9Is5mh02fpf4x/7pq2CJqtNd?=
 =?us-ascii?Q?d5IpOxzgRp9IzoDuL6zo/nWiGMjymXfGHVmT/enY/AldG5gdDSC7HlTFqT7A?=
 =?us-ascii?Q?xkdWi8disXZMFWfIRF3as2LaDzmL0G/atL98a1CV4dujaZXcAArqBdMf/Vti?=
 =?us-ascii?Q?tbsk6+CKM1l/v4rneaPSRfC1hLtpdnpJA0e1ozaDYyXDQB+wn5u5YwruVecU?=
 =?us-ascii?Q?MEDVf6rBJMsKpxg3glXOubKVU0QDwId8wvJxVShezNP5NZmyHMcLfdi1GKVY?=
 =?us-ascii?Q?ocdE/hVN6mUiNkmD25F8i5Ie95V5xS0BK1bSdFMFeyuqa2TAa2Rk4NxHEe1T?=
 =?us-ascii?Q?an6TFM0WjzHrh7BlrH+C/88U0nIHsMGtqZl7AyDTU00lpuqCyapXTvr3hCWV?=
 =?us-ascii?Q?2RMUdHSnEiAtfHKuhX2ET+JfPmtLH1FwJdED/tiveO3gE8eOucbLx8BnGygE?=
 =?us-ascii?Q?FUEkoGrzH2jqoAKSp5Iw8ynBLv1Kh8T543hhYuX1aSaGWSWW9Qb0F0+FgSP/?=
 =?us-ascii?Q?MKeF0WzboyMePn/adsTWlKNYW+IJJCI91S39PH4vFD4qn7iSwLNkFa8QrBXJ?=
 =?us-ascii?Q?L54QeSonjSfGF+Q0a81mgG2M/x36lKhoW2w2+7LOnlStxIK/vpMfQOqbehOP?=
 =?us-ascii?Q?tr/pfm264qccuSnz8lo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2caa469-a856-4979-eed0-08d9cfb813fc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 19:26:16.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEFVfD1sGF4gxaCZ1aNHZfoR90qYkN+kI316YtokeeE9jkGidUsbIVcVNBKf3jWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5198
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 11:06:31AM -0600, Bjorn Helgaas wrote:

> > The existing vfio framework allows the portdrv driver to be bound
> > to the bridge while its downstream devices are assigned to user space.
> 
> I.e., the existing VFIO framework allows a switch to be in the same
> IOMMU group as the devices below it, even though the switch has a
> kernel driver and the other devices may have userspace drivers?

Yes, this patch exists to maintain current VFIO behavior which has this
same check.

I belive the basis for VFIO doing this is that the these devices
cannot do DMA, so don't care about the DMA API or the group->domain,
and do not expose MMIO memory so do not care about the P2P attack.

A comment in the code to this effect would be good, IMHO.

Jason
