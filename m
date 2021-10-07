Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA5425219
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJGLhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 07:37:04 -0400
Received: from mail-mw2nam10on2049.outbound.protection.outlook.com ([40.107.94.49]:53824
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241054AbhJGLg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 07:36:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhi+J8tEEbaogUvICraxVgWcQmapjWf1ODdcPiXiIQpuiCdLWZAGsWsNDU77n7YUl5jbToPGvLRRXkJ2AAcvTG9KqTbPfvCgaIhhpq1Z8y5GqNVcDd9/sQ3flvBUbEDufqB20MKB8vryDHVy88cOwqoHJaN4SogeGaJ2YwI3P5B8+fdmgE/sBUy+hyzhxqHhdFVpy3PAj6KAIQnBdDU+0eAbRbJHyPg9eo7wKyyz+YXh9G2uPrPTDWqPYLoCyupMm8MP/H8dHQ93b9IaKaf1QOjK6nMQC4auo8WrAqe6PKeKIBLSzFZTHAry9XW3IwSExBdYNwYeJQfeIGic5Xjv0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWLXlnfFJQtlRTYQHvFRKelIZgspS1lPhQ2RKMOFVBE=;
 b=By00vImehvIMKfRGv/oArhTokz0bZNPd7KXeBvKQ7j9Qq7IEV48iEcKpuc4x7EG5feYN6iYcqSYwSXmXJcEnbwUzzLt0Ohdxv2tP7zU8rmWMqZIrOW8Q51yOQL7mbNjcm4UhIbTq/BnXU3ss18G0oHdbOIWugAr34L7d3+nQavFuCxRnhnU82jOc/3MZ3f1cPkbDN1O7Ae7WEVhjHv8e4gxXl1V8Kjk0gY8DBCNOv0FJQNGKl1kjcR3LiH9cynJmQZxjDU08OthALr2wb0RVfp1uIaXEMevR78yFFI9KNCVvB0Rb16YxWXDk+WkxIHXjnbyT+ghf5K1nNENzNfOx8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWLXlnfFJQtlRTYQHvFRKelIZgspS1lPhQ2RKMOFVBE=;
 b=AaGfoUvPJiLYELXHoe/OWr8aD+tvX4bx3qY+jW26YZB0GmVTKmY7Jp7ywV4mMbGCDRV4qXq8AlRvTk5dLkVgdfuZ5tny3XW7/wrYckglA8J+v707i7odoDq/+326BMk3riO2UmcpDxV6xYsdzzQbX60cDHI5UGe5tHlYAosV9USqY5WeWOB02ABf3D+wVPWDBd3p23KhH6S84B5ajkADau7LXAClo38jofH8iYBxnfR/FwFUoEUg0tZVsFTmNBbnjECnrNjsR+Gy+KIif1E9cGKAYcfXYIhb2SG9PLoJO8J/p6w1eRAXiOrPsHjbd/bdb3VKv/H0Gzbo6GQvq9allQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (52.135.46.150) by
 BL0PR12MB5538.namprd12.prod.outlook.com (52.135.46.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 11:35:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 11:35:04 +0000
Date:   Thu, 7 Oct 2021 08:35:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <20211007113503.GG2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
 <20210929122457.GP964074@nvidia.com>
 <YVUqpff7DUtTLYKx@yekko>
 <20211001124322.GN964074@nvidia.com>
 <YV5MAdzR6c2knowf@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV5MAdzR6c2knowf@yekko>
X-ClientProxiedBy: BL1PR13CA0352.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0352.namprd13.prod.outlook.com (2603:10b6:208:2c6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.11 via Frontend Transport; Thu, 7 Oct 2021 11:35:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mYRfz-00Br1M-3k; Thu, 07 Oct 2021 08:35:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 118ce535-a99f-4542-4586-08d989868177
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55381DD9745A58172F9A499BC2B19@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 132q1+jUJ2Jyv22Ec3ig1Ec67POvzJ/IJKtGO/680d7GUaob7oACSvcUrEeaYyRd4opE0l9shbKzs6lqqJI4HbaBGoey8LSvtYR+ENKZCwPPsSuXa6AU1IORr38kxwpwS3ff2oA1EdgPMmJ92eSCxJ2vmz1jsP/mw9nnHDKQqQVDLRNmQbWliP2GIJ3vKZhW4q1cl2tMip4nDiq+UI67yAomU+FWbJpa4y8WcM2kLHTbPLC2EFk/8z44wlDwngVTRVjd+5VNVe5mAyEtygl8NDCTvN6/8oZa9gTh6w9YWOwNlIm7Ni23SQDyg7foevTyx9JFDfWi/0jSG69AQ9pZmXSbPqVbNlikn1WvKRIntL/CaW32uCuSi73VNFEtx6epMI8KaIxDIKCcLQuzkaZHlKXST3L2Aewr/9j1guAfVFszoqDBkksLXAV/kjtJG28Wo43fmGgeF8/0eNlvtNH6ROLMAucKLVmMLz/arV6tTxxrKX/X2fzCr9ef58gUxr99BPp/wtBW6IMgWGuDyrSoMWzWSg5B4UGZxjQT0DMaABph4H5/ExdMJYcKqmYV+GR/zGnoZcxgf+TfXsKMU+HBR6uNf3Ld1ycF1zLno6N75hqAzDKYo6yNMcw2MQctzI6gZNkVb5+OE5C5qLNAj4cUJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(26005)(7416002)(2616005)(316002)(6916009)(2906002)(186003)(38100700002)(9746002)(9786002)(1076003)(5660300002)(426003)(4326008)(107886003)(86362001)(33656002)(508600001)(66556008)(66476007)(36756003)(83380400001)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gIG2qN5iNh+GeXhcpMF6XdWFsrDf6cXm5+JcmC2TFOspMHT0RFuwtdDPUJzi?=
 =?us-ascii?Q?UnzzyUrCzjlc3ubxW2UECfELh6DuTyB+d138Pfu9gf/VmdCE1TR9q/NKIcps?=
 =?us-ascii?Q?KGRDrbT5UnX834N5XPvL0Ut4xagOOHEf0eBVK7phpQVVAAa1qelF32c8z7cp?=
 =?us-ascii?Q?bomwzmoUGJioCT39YoSd3jTCkWhMrU5DhaE8RqS5Zdzmej7UglIb85Ktq2A6?=
 =?us-ascii?Q?swTbJ3JHhGVog9qo7R2ViSBkh/SXsCRU6rf9mkGTMgBgkDcmdYUhBo83cF7d?=
 =?us-ascii?Q?KWEn4oxjm46I3u4VrqG686Pq8iGEIiSoDK+CvVvFdlQy2JIMi3ss/R02VvlP?=
 =?us-ascii?Q?sAyLNfLPXQASHnKxTzXVCjgW8fxDMlGBMpW+UvyO1z5V0tKzVbCfq/lxIY0O?=
 =?us-ascii?Q?24WgLr2d/Vj2NVKqIjdGpA+mrwpO40azY5BEIYeHUSupc0inne1lyU61q3Cc?=
 =?us-ascii?Q?OpBlOgUcIjkkHnWRT9+mxy6N+wGUzdIOv3YMEUQn87frmy+iJBJX4s7Pi8x3?=
 =?us-ascii?Q?scY/ERddhhi++Sz8Sd7xUGwYLJtBRTSRQcLPCRp4VTX75EEpncNYmrDqMTnk?=
 =?us-ascii?Q?mPpt5tB5MOKIF9oTLSnEFyrWZQzKNptBRRlSS2YJA27o/WerO+//Teoo9E77?=
 =?us-ascii?Q?Ng33L85JoRxJCdwe/vFyyupuhPueftdda52v0yhtsmdveVZXXrpR1McQarfw?=
 =?us-ascii?Q?QXtRZWeFj5jY9s87h83EChafFCOZQ/xXfkRe5DMBjZKT5V1BZe4Amrcpgk1z?=
 =?us-ascii?Q?7h+7EgQaEYNRSeSV3VoVMb+l1OFa4t5BJEv+kmOct81bxpRH+yGC5SbMhkla?=
 =?us-ascii?Q?rpFC2wv/ONZmmSLqD8/nueMCJv9t/eJOGaPKkQNTJoiuPHE0zKWqZHVFcO0W?=
 =?us-ascii?Q?CBC2IeLuERFLeqb++XLN1sW3TWZMd2gtQIUhzhV+3k6I3V1Er/hieA2fRh3m?=
 =?us-ascii?Q?GE0uYrk4yFDn1brDb2s5xNTF4hzQFc76EpL7R122Ee8Pr0zbukFdN8Rk0yH+?=
 =?us-ascii?Q?LSRlNDy8oyoBMy6IrFZQzJr4FVzsTgGHC6df7AxMag+0uC6q6yJ23FUQPF5t?=
 =?us-ascii?Q?M+lxXb45l85/xh9zhguBtUmX8lju0ylf0I9DzqdPGVRf+OVs2Vq8uYlUtEad?=
 =?us-ascii?Q?ikJkUitZszM1KOoezU4isrXPiAtMCkfFVxjrcKN5sCC47JSiUANqSzBiSCDL?=
 =?us-ascii?Q?UCU1XWKghqWwVTOuoSY7Dj34gxwjtllEvAsOnXLCc8oUexyj1NGndgdlkLDr?=
 =?us-ascii?Q?ZpwnSvObSRw/ckAP2oyH7M84OdHaVNj4mGqw4SZUZDZG8zzdLig4dRvMHmzd?=
 =?us-ascii?Q?S9luaW3GO2aNNGnoNV5x9l3LEyP+pVkWCPGoL19z0BJv2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118ce535-a99f-4542-4586-08d989868177
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 11:35:04.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYmjPqrtzBRUzwWw0qk2a/3ny2x7yEtK7a3w7heq88DOOkMKSyvqquW2avURUbRM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 07, 2021 at 12:23:13PM +1100, David Gibson wrote:
> On Fri, Oct 01, 2021 at 09:43:22AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 30, 2021 at 01:10:29PM +1000, David Gibson wrote:
> > > On Wed, Sep 29, 2021 at 09:24:57AM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:
> > > > 
> > > > > > +struct iommufd_device {
> > > > > > +	unsigned int id;
> > > > > > +	struct iommufd_ctx *ictx;
> > > > > > +	struct device *dev; /* always be the physical device */
> > > > > > +	u64 dev_cookie;
> > > > > 
> > > > > Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
> > > > > unique, couldn't you just use the cookie directly as the index into
> > > > > the xarray?
> > > > 
> > > > ID is the kernel value in the xarray - xarray is much more efficient &
> > > > safe with small kernel controlled values.
> > > > 
> > > > dev_cookie is a user assigned value that may not be unique. It's
> > > > purpose is to allow userspace to receive and event and go back to its
> > > > structure. Most likely userspace will store a pointer here, but it is
> > > > also possible userspace could not use it.
> > > > 
> > > > It is a pretty normal pattern
> > > 
> > > Hm, ok.  Could you point me at an example?
> > 
> > For instance user_data vs fd in io_uring
> 
> Ok, but one of those is an fd, which is an existing type of handle.
> Here we're introducing two different unique handles that aren't an
> existing kernel concept.

I'm not sure how that matters, the kernel has many handles - and we
get to make more of them.. Look at xarray/idr users in the kernel, many of
those are making userspace handles.

> That said... is there any strong reason why user_data needs to be
> unique?  I can imagine userspace applications where you don't care
> which device the notification is coming from - or at least don't care
> down to the same granularity that /dev/iommu is using.  In which case
> having the kernel provided unique handle and the
> not-necessarily-unique user_data would make perfect sense.

I don't think the user_data 64 bit value should be unique, it is just
transported from  user to kernal and back again. It is *not* a handle,
it is a cookie.

Handles for the kernel/user boundary should come from xarrays that
have nice lookup properties - not from user provided 64 bit values
that have to be stored in red black trees..

Jason
