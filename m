Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E2454776
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbhKQNi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:38:26 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:34784
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237726AbhKQNiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:38:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2a8qEReOQ6HBPeVVkMhEimrRD3qj2OhziNc24OsobqP8h1dtjRE/J0Cduzt4blNTRriGftr4QzJ7CwAtIBgKfNgHqX7RyUARSkY2PUVd5Ywvml1YleObEhFnKI0+JhGLmXM+zb72os9je661m0DA+ZoZ6E96ENH8qD7lEikjIWQPxZY6Vi71+4IZLDEv4uTUedRs8xZj5R4H4ZxkDHoWxVWE1WCO22oC4I2vD1Y7yl8K5XnGBSe5Aq47UuHwk1/N3REIKtxxWyQoGJdEd93jrW0RxDh9EQ2M2rsD4o4lVcNd8n4f4N8DSRaRZQAjfDqvy0B+v4sCyF1VHcejEj7mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RsCU+EPIijVxuTRaIxKQUK772pvK7BBuVVKScZJHZ8=;
 b=emmyFhylHA07tUOqLWrguwvt/7kI0V9LS9w0WZIwXjmBVRvROX00rhU2XhLNtR+rLXMd2apiPrWgNSLZwO23tdPbeQyWbNGEt1gq34aF9fi/g/KxA30rWSat4DKaT+ptQex9mBmUtHHU15d/1WUBsjmOp4vhZMIWkNi5jXfw3r00KC88Lnq7Ad5bequl2fe/GDLa+2UWceXPYkIfDrHT6MTW8HaSGZrTNsx+Xdyv7j0Rn3PP0O0uHZdlJL6YtyfJ++mp1y88uSJV7GxRSbNj17IcSdQUJI/lwSNkEA1qkTKVUoIOiQInrKNshoZBSyzZKRB4Hbtx/2V8VSyWxkmGcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RsCU+EPIijVxuTRaIxKQUK772pvK7BBuVVKScZJHZ8=;
 b=NnCad5aODnc3eJ8DV/sCQmxgnkYY7LNeBufI8fDi2idVZrfb8jcURdEWrx3yo7aD9ZU43K38J/RkfmD8Hg9L8sbschzKSx+pPSyjQJjPkioFvoIpQqFb89sXd5Ombi/nRKhWpzejfaM3Ud/5Lo7vzrSjJ0SHTUBrGQGhOZiU5RJfxKMXPWMzLV1MyvlpRseVXaHihuJgFUqmZXJty+TaieSYfwKdsEbYz1KH2mHxfGRHGcjy+hvAVYSAKaD/Zw4PhbZwePm5aiAYN1dbn/TLvxd2ijA7YdTs8zolH7PxCfDDEydM8xEIxf1Dal2sIRQMuSc2MRbOeCqW6R2CTknWMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 13:35:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 13:35:18 +0000
Date:   Wed, 17 Nov 2021 09:35:17 -0400
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
Message-ID: <20211117133517.GJ2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <d79acc01-eeaf-e6ac-0415-af498c355a00@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d79acc01-eeaf-e6ac-0415-af498c355a00@linux.intel.com>
X-ClientProxiedBy: MN2PR12CA0031.namprd12.prod.outlook.com
 (2603:10b6:208:a8::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0031.namprd12.prod.outlook.com (2603:10b6:208:a8::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Wed, 17 Nov 2021 13:35:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mnL5p-00BQxf-Fe; Wed, 17 Nov 2021 09:35:17 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d486066-5db4-49ea-5459-08d9a9cf187d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51445DE0D12E19BE034F1FC5C29A9@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHy0s8YCB239Q9e49Vq2ru55qBN00gvpYOJhxPXpZMYyLEKDAQ1mKOxmFSN4Ohup/4xnN4FzjR2T7HRERFg2jjQ7AgWxcPZ7A4NkLwcNdLZzuQ5PrqHgKyWB/HfsuKF8Rjzv4iPndxntOf6CZymEEkSjcP1j03DmhBWve91jGSGPo6dhNhf9dId3S+SL5i4epi8m/a1KVWJdIYJd27xWMRLgpSQDbXbngOy5Oc58NRU0a+0uRjbqxlkXvSMNux34f5qJcKVUczD47pdU+X7g0r0N8DFnqUAWWjmy5/vzKpObXI6k1RaEiC4oeLhFzBHdB/Egtdn2oSfaCZHtDjg0/TaaKw1DjR4ieABmfIj6JS1ISVuRzprAlB7dGZwfeFVmsQvqd4E33/ZXOm4QGXcRam9thXiutow8xm6yI9qB8RP0ZWCltzLuzzluYx+Pws/RHvML0oOjmyHtPU4vW9my1uugEac0vo6i/YyGMan4NgTn4ith9+G1kO4Y1T3NtbO9Tjq3SUqJs48cSV5rL0rc0baJjxgmulDHqpzPj38pbPuS9Js6d5qpVzXAot2D/emkPBh4m88orBDWsRaDRIIE8l3rhkoQ5ITSRArjhyqtDXz/VAQLQCNiTGIeiZNQO9+NHkl0fszB0n7rDMHsKy/HmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(7416002)(53546011)(1076003)(2906002)(6916009)(508600001)(5660300002)(426003)(26005)(186003)(8676002)(38100700002)(33656002)(66946007)(66556008)(2616005)(8936002)(9746002)(9786002)(66476007)(316002)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TqhqSp7JrzWeadA8/37WIBnJ2gyG0aFICHIbx672RsUcuNNj/0qhbRTjaO8Y?=
 =?us-ascii?Q?zlk/b4n3l1+3ZF9FeOLmnMzhKjSJ6Z7t0UYBLH492wP8PS0DBXcS4GcmBkrq?=
 =?us-ascii?Q?AQAKveySsF/PAx4KT+S5kW7sOtz1xHLvyTMkZb7bgqCK3anMBdw3rgww9WUM?=
 =?us-ascii?Q?j2QJ/uVOUWe+1seHGvnnwFkpAkxV4gkUIv8bMd6N9kwFK1/zdDPkGOBBQzVX?=
 =?us-ascii?Q?qXknW6ieSB7aUOa+/nPtmEhKRow5FZHjxnvO4Q8ccT3uUv/38PwryEfw21z4?=
 =?us-ascii?Q?o/IJLxOTzyoCPBFCeA7UFdQ4RMoyygIB98v1OHW7HqvmAjDQZbvSPGC34coZ?=
 =?us-ascii?Q?xQrH5R7Rdf92+1eCT8EfzTq6as5gRTYTJIxPbMzS+6IX0uoPPcY+x+z8DUsr?=
 =?us-ascii?Q?MlwMErAFts2819nGWeI38Uz5tqbI+O4FO0QJ86zBOfzbm6kuH2tuzDMVLYxn?=
 =?us-ascii?Q?Qw3ajfvkdz1439DkC0oCRWT/uVXECN9+KMeF4wBlMIj6ZxBO5L1sfhrQhbib?=
 =?us-ascii?Q?Cjeq6mD7faD3y+hikZWdtOcZ4UYcmpSlZBZxYrdyH5eFJPLAXVNG8ygydqNB?=
 =?us-ascii?Q?Bw+wPjMxBAkhqxTa/yUkpeuZuE6X94mfJDzcxZWCuZYwhDtJQCMV/E2fQ90U?=
 =?us-ascii?Q?Ed2oDnzhYtDE8k70ev2fPXuLCy73L7FUc0aKcWSqqFZWDRt4z50yJIhVCrF/?=
 =?us-ascii?Q?OxBLKECKlPObQaiYkPAftjVnRd0KgK7E2ppPq5DC5+T5taWQYDfAdtQ8D3Jt?=
 =?us-ascii?Q?IbG8BdXzVOLl7NkG3N8+ft4oUrI5Eo8thGkoOp6incTQezHqOcFaqRwyZq+M?=
 =?us-ascii?Q?a80mgtU7o4ppUxAZ/WVdLVybsO7GPh7/EtRNh+LdYUhxbBd60hqRC9HrCwwd?=
 =?us-ascii?Q?jfWZirur3x2wNrL1trcrywBX12V23rqUEtGLwbgrTAfgj2xfrxo9kN9IXgiX?=
 =?us-ascii?Q?fiiG7wbciXZu011Y+kSPTujSdkrx9J8OQ39dj3bOnQkMw7faeFmDKWarV2tM?=
 =?us-ascii?Q?nSfsHdD7B6cPi67n3cnwfEpWKZj8bI69iSaSJYGS4AZdFkJn0XoO1LUYtHCy?=
 =?us-ascii?Q?66LVC0+SxwBTjUnMAfikkYar55Ya86c3+7ZSUzBR5fP4Undiy49HpwtGIdaE?=
 =?us-ascii?Q?AUjJmo05l/T8r7sG/VyuCyAlTM6wI36KcZ0xDKXNwLk/CRz7xRTXQeuLtZb5?=
 =?us-ascii?Q?xGezt+weiabmdD4Jh55m9+QAYbxWg9kK4tc2ngvTJ3H12LmaMi6NTsSL37eV?=
 =?us-ascii?Q?TZ4rSRByAIMdVNhHYxS5PgzWuo0GhJzee3TDu5ceGufgVAvxp1/9GF3obT32?=
 =?us-ascii?Q?fzcupJ8ngH4Lu1deFljDwU2/E73bPbq8D69zDFlvEVuXZo4docXeJbx/rbRb?=
 =?us-ascii?Q?zY/suhzeNzLKdmMRFSozCJIPRterdEMKHO4YL40onc+zW94nvDuFUbG01sk9?=
 =?us-ascii?Q?XNUBpp/nbJqinmUaxkYXNXrbeEO0snMasW98RGcsmEmGV7uv2qrdlTLvrzu4?=
 =?us-ascii?Q?8fG3LNUCdGIrZFlXoXyhdZmgxWo4MagYIqYwLWDYv6/4ZO2VxpcnpbwiwxwE?=
 =?us-ascii?Q?WKN7oqBxv5yc95fsK2Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d486066-5db4-49ea-5459-08d9a9cf187d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 13:35:18.5240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RbPVBxuHDWpwRKhJ1+M2rLsJRrBvez6dQh/BSwR6AFVHUEPb+2S8sd/3YeP8DpA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 01:22:19PM +0800, Lu Baolu wrote:
> Hi Jason,
> 
> On 11/16/21 9:46 PM, Jason Gunthorpe wrote:
> > On Tue, Nov 16, 2021 at 09:57:30AM +0800, Lu Baolu wrote:
> > > Hi Christoph,
> > > 
> > > On 11/15/21 9:14 PM, Christoph Hellwig wrote:
> > > > On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> > > > > +enum iommu_dma_owner {
> > > > > +	DMA_OWNER_NONE,
> > > > > +	DMA_OWNER_KERNEL,
> > > > > +	DMA_OWNER_USER,
> > > > > +};
> > > > > +
> > > > 
> > > > > +	enum iommu_dma_owner dma_owner;
> > > > > +	refcount_t owner_cnt;
> > > > > +	struct file *owner_user_file;
> > > > 
> > > > I'd just overload the ownership into owner_user_file,
> > > > 
> > > >    NULL			-> no owner
> > > >    (struct file *)1UL)	-> kernel
> > > >    real pointer		-> user
> > > > 
> > > > Which could simplify a lot of the code dealing with the owner.
> > > > 
> > > 
> > > Yeah! Sounds reasonable. I will make this in the next version.
> > 
> > It would be good to figure out how to make iommu_attach_device()
> > enforce no other driver binding as a kernel user without a file *, as
> > Robin pointed to, before optimizing this.
> > 
> > This fixes an existing bug where iommu_attach_device() only checks the
> > group size and is vunerable to a hot plug increasing the group size
> > after it returns. That check should be replaced by this series's logic
> > instead.
> 
> As my my understanding, the essence of this problem is that only the
> user owner of the iommu_group could attach an UNMANAGED domain to it.
> If I understand it right, how about introducing a new interface to
> allocate a user managed domain and storing the user file pointer in it.

For iommu_attach_device() the semantic is simple non-sharing, so there
is no need for the file * at all, it can just be NULL.

> Does above help here?

No, iommu_attach_device() is kernel only and should not interact with
userspace.

I'm also going to see if I can learn what Tegra is doing with
iommu_attach_group()

Jason
