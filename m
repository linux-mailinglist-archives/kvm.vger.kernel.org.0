Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AC453320
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbhKPNtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:49:08 -0500
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:57216
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232201AbhKPNtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 08:49:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0rtIraVj3OG6aqeRaENyzYYmo/XGjfkBvSBYdnhX6zvMDMA4q/s1wkpwF9rgFyU1XizbiFuUNqf1Zk8RmO71aPcTvT1eiuuDZxyUnRllP2iHvQFpFgugG6BAd2BW/lh3IRWBZ8gTgc3Rewp1edLosPlpk3KIhvXK9zBttvgbgxr4A1Mwl27Q5BQ8+kyZPv5veWb7gCM6ex3ybLrPIjZbiz7Y4KAcjGj9aXb//ix0/vvS83HAa+04EB32CLGD/Y99OiRMWus/6EvThE8yQXY95DT+eYRgXStxFdQ4dMJmLyElSRofCgEGp5tnw7MSc6gDZahCuKX8zsq9V88Y/R66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6qlcVCuHYm0WHwIJgmeaN+bTIxjZAV22Ohfxb1fj44=;
 b=Y9oLe67cZ1ETpDA3IGQm1+nd2MP/suYq0XyQxoVviuyP3fYWYBVeh0tOfV1fGJ8IH6laFCFkgSgwhfHoqVvWcQXKNGQHtzqaOykO3Fw2C66xBGCWms36Fdo555ommY44sBCw1vLUlo6XoZ5M722Tij2OethL/cLVQ5rLeC/QDarplYqpL4hf3NKrUj6r6umX5ZgZgMM/YhQXWhGmq9TzGpLCEYKZxxUkOcCuUI4xqdWF1fgvz2QMsZJaxZolzwMm6lHVm/Hp2G5xIuOKpPEOMwHoRs8vgstNL84KbnYbFQeMplVPJ8AB2vutyJnNfNBlaYg0w69ZzO6d+Nmj6gXGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6qlcVCuHYm0WHwIJgmeaN+bTIxjZAV22Ohfxb1fj44=;
 b=t9PVQ8YsZ+FnV4gro64N9DwQ6rDK6NIfbDwZ5nnADE7ZFmqfSPg/8DlfDI2CTJ9sOAq/rxT+rwIqxdZ98WtQHDJrWFSRzSafTWy45mNxX8C5NP+7hGL4uxN8ha78/lC4p8n9mxjU9jgx4Ca/CYqTXZycPp0gJ1LiOJHdNTm12FDbADnXCuN3/KBQzOVjxRgIGm2U52k3rAEXBnkU4DcR/BLdmcg39ElNKAEu2qrAos8NIKxCOkFnErncx4A7upleQVkAH7AyL9qBaGh42knhr1+csDX3be60le7nXb3h73NiSoTQz/+QkLCWAdu/cL2q8FoIYhwxfpdIIGLwoz2RTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 13:46:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 13:46:05 +0000
Date:   Tue, 16 Nov 2021 09:46:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211116134603.GA2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
X-ClientProxiedBy: CH2PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:610:20::42) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR07CA0029.namprd07.prod.outlook.com (2603:10b6:610:20::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 13:46:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmymh-00AxYW-5s; Tue, 16 Nov 2021 09:46:03 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbd8b01e-5558-4acc-c81d-08d9a9076f7c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51754AA6A04CFF672FC40BBDC2999@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRD/lZ0p3DMHUJCL0jxXhzgGPN84HWlUiRM7xUuU6TwkYaxEjoJqJjPe+9WPWAn3ygDZIpF7Efo4rdNjovOiy5wGRPloA/A17uFSyO5bScjXqSNrVGloF/iznUejD/+awcDkhKxdaSKNYakT4eKVInmgfpXd+zpPKNgeLAyrFDujyIvktXsWPpdvwUc4I5rZ7N682Gr/F46HdKkqwpEjPMbsm4zffPVdEQStexF34ZRwsOj1dfhKVza4IjMkl0vgMtt/KUO79rkePOBOG0cTR+Ud79wu5+hVqsOA0hG3cAEYTFqOmYu41WtVBQjokHvZNxAHyXmJaqqzVnJauaBIEqJg5NVsnvE7l7DqCi7Z4ozzUobEjpLDiLl1J+9GVGY8D6tIOJoH18zp4ogT/efMrTOWHrdlQqq5WFWIfMGEsTCg2n++Y4YNbYpFa7zYRFpU5Fz4W/hiefFgvQB+bz6hcaWWGFndREo798pKbs5FAXq0yqOvpSyDrcf00FqluPzfbO49w4cd44nwvJfZ85w4ziP7VNOuB6/SEYuNXDuYzqVAm2Xa9YHCW0+UYPc2f8Q1K/k8YhrdSycZahQvtEbkm23UrGj/8Y4HvqomYrOO8UPLz5RK0DT2MiZ3HFizigVORTEEtIdYzH3f4VGFOxv53w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(186003)(26005)(8936002)(508600001)(426003)(66946007)(9746002)(6916009)(54906003)(1076003)(4326008)(316002)(8676002)(9786002)(33656002)(86362001)(2906002)(2616005)(53546011)(38100700002)(5660300002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4GkN5V39MZy1D7gQwFgk31rGpxuzM/p2qvt+OgcRzEi2uESVhPOi97diw0m?=
 =?us-ascii?Q?VYG/JOe5PaMSh7XFn6CMDvVrSYbeh2D+IzOq5ZaK5mpGakVa+QabMZBvNjC+?=
 =?us-ascii?Q?TOfQEO3/0K24DxaslqWgIj2OuoB8JTEH47xIEJMWwwpKx5rdZzYT6tO460Uo?=
 =?us-ascii?Q?E49Hl3olXDGji7rvvbbydkJVh5560lNE25NbA94e7jTb9JnN3kokudfqlqjP?=
 =?us-ascii?Q?4ZKCtgLwwAkWeBz0uJ6ojBMQv3jyid9E3wqkYIOpwTp4Sd/bomnV+IfIdY7S?=
 =?us-ascii?Q?FP8suNlY0FyM8iAqUBMstj3/lTzqovMOD6B+ID532hS6gIrOg5llymGmNYBj?=
 =?us-ascii?Q?gBDwYC5DTZEgPFSVP6m0TriCwecLhG/Wa84V+IRtTrl1KD5XAhb0DJ7TYYOI?=
 =?us-ascii?Q?gKCu2JaErM3jU2egQk+FKWpmuU9cM+8pqpP/NNrEmrZx4syv+K4OTBcQqPIl?=
 =?us-ascii?Q?51vAWeTTGFoscQ+k/f+qHO7vh2zxaac5F/KTEYbsQdeonmeIpg89KgkFFbk5?=
 =?us-ascii?Q?d9OyiO/m23p0Kt5H9ZupyBtaWLf66RCM0e8RyLSST0qEcSGHyw3XuS8DMD/n?=
 =?us-ascii?Q?QwMW0xXNXaCpAFYAxlo5hMesK058OabRwPCa797WyFm+ldIgxl0ID9NVbbm3?=
 =?us-ascii?Q?MAg5EodhVJNEpdYa1ykxFY0KnwY18JH8CBZt1BDoOJbajM1TgitOCX/yA0+y?=
 =?us-ascii?Q?3+Rf+gSvrNLL1LX4z1tNPJsoZ5n0AjHi8JDw6sMawp7ccUalTGcIlnQoD+IN?=
 =?us-ascii?Q?67Mmnhg9qOAuE6PUZ1G8FficMFG9c3l3diggg4jAf+MAFfn7ZUkBGZmGtZjO?=
 =?us-ascii?Q?eBeFgl5O8lk3sjq7sGdNzw6G3DLFkWplAjpHLd4ly5T5H6xD4XaRrvyx45gS?=
 =?us-ascii?Q?uHxuCTi9YuLyjYky17EVBz60MAZIOjkpoFw9RVAxrgbN9L8yxeIpmjflxTEM?=
 =?us-ascii?Q?/k75qLa1ilkrlmLiCRFz0tUZnXjfFwkonh6ci27QqmFU25lchtH+fgK06ch9?=
 =?us-ascii?Q?aWIQyXQCSec3YGSuVIlBuwRaIX8o7plOPIYv6vnFV6LJkzMMJ1iTbFrPLRVz?=
 =?us-ascii?Q?LuNiDQRf35CWFyof+kWJE6JKg8hLpw1TefTS5J81SEYcWAeBQWgDHyGBnjXX?=
 =?us-ascii?Q?G/wbvdc+gTvQEdB9fo2kGucS3TmIQi6aZjJkBSGAPHFx3vH9j7eZ7okXrsKE?=
 =?us-ascii?Q?BevrwI3+f+RpAziukyJVvUJ1NprCVKOKXmHQHU2x2XjfO1ykCQk7sD/ouQ8H?=
 =?us-ascii?Q?L7qj6EcNRbXRD7Gvd7SRabSJKo20I4R5qSJCa7SywZ3XE3nNyia8ArYcqJtZ?=
 =?us-ascii?Q?cGeUkWsndnEplacNOYsXqLjH5AYoHLvtcE04cmKzQNgUe6wPlnxWwlqrqAik?=
 =?us-ascii?Q?GRbt+mBe+VeEw6IauzSrOHdpboadlC2/Mt/8UoPxnybhWXTXM04BwFCSwekK?=
 =?us-ascii?Q?qhvWMj3K/A6fQnNGgMnDr2+2aOITp2JeaVA8IzsvXyJ9K95EXhFAdC+d6PqF?=
 =?us-ascii?Q?Xk7Xb2BAEZ9zaiK8+pvkhY8KaQvxtgHMZgRhquwkuTVizkjogeYJHNdgl+e+?=
 =?us-ascii?Q?pjNtMflJff7TntF5MD8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd8b01e-5558-4acc-c81d-08d9a9076f7c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 13:46:05.1363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k44YDJm+8YmF9DP8G8GwR49/7h+mzxXt82k8mvjRs6qISv7066ctMTr2JN0GasI5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 09:57:30AM +0800, Lu Baolu wrote:
> Hi Christoph,
> 
> On 11/15/21 9:14 PM, Christoph Hellwig wrote:
> > On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> > > +enum iommu_dma_owner {
> > > +	DMA_OWNER_NONE,
> > > +	DMA_OWNER_KERNEL,
> > > +	DMA_OWNER_USER,
> > > +};
> > > +
> > 
> > > +	enum iommu_dma_owner dma_owner;
> > > +	refcount_t owner_cnt;
> > > +	struct file *owner_user_file;
> > 
> > I'd just overload the ownership into owner_user_file,
> > 
> >   NULL			-> no owner
> >   (struct file *)1UL)	-> kernel
> >   real pointer		-> user
> > 
> > Which could simplify a lot of the code dealing with the owner.
> > 
> 
> Yeah! Sounds reasonable. I will make this in the next version.

It would be good to figure out how to make iommu_attach_device()
enforce no other driver binding as a kernel user without a file *, as
Robin pointed to, before optimizing this.

This fixes an existing bug where iommu_attach_device() only checks the
group size and is vunerable to a hot plug increasing the group size
after it returns. That check should be replaced by this series's logic
instead.

Jason
