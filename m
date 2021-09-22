Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC3F415434
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbhIVXv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:51:29 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:60112
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238541AbhIVXv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:51:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALcr3sSgKaQa3YNMqj9srWpa3ilRCaut4VK/taaV/8QbbK59H3D6UKepKotB3WkNM0CsfZ26vf3Mb1r9JPF5J1togNOzionJrwTD2buN3LKwTzQZvEV8kpV8jVn64EVtuKhovzu+7GDlP0Hb9OKy/9Dt1Z+28j97ypY475yj8+u+UKhSj+6MtWVbKsWW7shdmtHXHvHH0GyqnHG9PT1qOAFwmVNw0d8p+PFvVYA9Ubsu/OkMYkgX37Kj5QfD9v9C2RETtgk3JiSulIZB0XygANxP/ZIUgUvo02mRnYRYTyDquvJOAiuWGDhfgPIfPzNUqqjhKglKSCKHtip3qvOt0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SI/Gujebj/zu70i3oc5JbbL0gmgQmz/HEy/2o7L1T44=;
 b=SbDmHIw99xCwK8n4IbnpSUkfLblNI0phFwD+DoqFpobow5kGSg/+oCh160JlLDhIrZIVz819Fm2DG7WWGLArOq/KD2nGzjjKMsO+xAWwhxFiSqR3lESFKdspXlbKKY1CgHTyt4aXSFqOH+0VtTpQJYvvkXY9aAW+moVh3h39tXHI8ETiEck0l1pMdiANTmAUco7pQpeoPzgah5mimXvA+U8Z2T3CKDKiPd/4r+g6RZQCb1Ew6QEbmsEn3saIrnIEllXKHMT4Kt2nzhAiAskzuZdwGDgWkhyYsnkAfQ8SjWOw6FICcCBotJU9aBzHWLRcyZPG7/bdjfu96od4EZCN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI/Gujebj/zu70i3oc5JbbL0gmgQmz/HEy/2o7L1T44=;
 b=IHxp0NPkDtOKmwMwo5k7B3xv1tA9ZM8cjP5Y4kyvH66UYtOJ+OJ8m9EOJX0Y/myeuo3CUq6fZANrU/GT1NRnv/hPW6T6klSej+vAIUNqlavfdCpFFHrn/z1koY2FO1dx1riVhxYxWnQNTu2KlClBOSsaO3vSX3rQdRn23MtWCkhKSVjkIqs0u962FNVNDvHc11L3UoCZw12g0Z6iyprFbT/SUjzK1+QKnFkgPU5XhpTLRL3anxtHOerpwdenIn8dvXdJZc//nPB5PHF+WUYOEQCddEgDfefUG3O4Ci/7xBv5JPr9QFQe/20QzWtphpvWGYdG78648vVVjLR+KSAROg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5538.namprd12.prod.outlook.com (2603:10b6:208:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 22 Sep
 2021 23:49:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 23:49:55 +0000
Date:   Wed, 22 Sep 2021 20:49:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210922234954.GB964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0012.prod.exchangelabs.com
 (2603:10b6:207:18::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0012.prod.exchangelabs.com (2603:10b6:207:18::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 23:49:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTBzu-004Bmn-EL; Wed, 22 Sep 2021 20:49:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2204d2ae-4619-4a17-2972-08d97e23adbd
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB553884160AA2FD5A71D3A48DC2A29@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /MydimfWj/NxvhWfpmqKmEQBnPRhfyYLb++1tSct7U3yhDrvyDBKDBAj1zLXZVId00A2zO63WVpp+i72O1RQb7ovmIrUHgVlLNoZdTS1LeLZTPSYmGPOySbnjr/jZymBtVu3eFn+TcEMXawZzwaLyZzttU6/uEjdrV6I25tyvSkdNUUhxDOfZfRIwVLkuPWjzVk2KHynwJapQhX7ZDQ1haEQbmpAPAn7Kbhze8n+EvU607v8lH6sBkfOxaTix2sz7cDcMj0qIbCy9xQsgxwcPZIT3TVmjGyilrBYnLFP2oV1BxWHxndRrctoU13zVoQpGvxue0fSDKF8e+/dsOAtuNBkKmSvG8EkEblD1iLfsU3TGOYu8HGmG8lyQ2MOfQBEXw/UFZrx06GUtDQP5qBdAdcqsWUh3XQYUik8IYWnGgP1x6y6i1g8QCH2gbJjPPnc0jAfUmSDh0Yf9UDDkirGiMkAnm1W1C4FWoZVMBruMIUW6CHLCz1DGkK1WZvAhXfbk67C3apr8pVk/souJ/5GgYoxjJvSljid64mdG1pUovK6s0XdJTM98MaaboMD7gvr0Ew4mplMbKMo3q5XEHece4i4B2QXG03nfIdEM5RDqHQ+l7XRuKv/u/GMLE9/o0fE2NQU/gdOqhgwhCl11GzPapvB1OfRn76SRRu6CuXowLzQ8N5UUk9QjAJ226AQRqWv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(9786002)(2616005)(107886003)(6916009)(1076003)(316002)(33656002)(66476007)(66556008)(4326008)(66946007)(9746002)(26005)(7416002)(8676002)(8936002)(508600001)(86362001)(2906002)(38100700002)(186003)(5660300002)(83380400001)(426003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgDqqVhhLafr3aF9ASZLcH52N0Ee+fXcR+ea2gBdlnsiG62iiyk+9fm5siqa?=
 =?us-ascii?Q?HaPfyaf+pb3OU70Hd+I+edqUNrvr8Dq89mfCW530Yz2GtbL54y8R8pr6dCaj?=
 =?us-ascii?Q?J19XnduxryeNeFGzTMpNtlaAshPT6BBskmc7xqww5c4mjY8v8/qLHeOWWP6x?=
 =?us-ascii?Q?wka1xANkKTxPkwH4nj6i8xdD5Sj0BC3zJNeqIjCizD3+B0jMkLOh7G+5qHgk?=
 =?us-ascii?Q?Bus06tXIVxrPox3kBprSmT+svIotxQv3mYgnRU6MiA2lfJqaL7HgHQk3b6A/?=
 =?us-ascii?Q?Lc5OJRyZIVDh85sEMPf/LqvvnuQ27F7K/RpHRhC9mGGlJLbnL1ew8IGUvZSh?=
 =?us-ascii?Q?Ocu8OJgIHWGkbsxaItA1A+pMdyB+PihMi2F2GQtg2LgItQfPNFjbTeZmvbbX?=
 =?us-ascii?Q?9G+3ef+bevqZ/ehB7zsRELXqVtbQhYKGb1Rhqbd1Zvc9t0zBSbP1VIwex1cg?=
 =?us-ascii?Q?Lxg08p+uXtbki0EjoxCRZyc9laV8hf1SQALp7vyMAvs4aUCWK1/KGftyyMqI?=
 =?us-ascii?Q?UqQ08Q7fQaTo641MGnvZLYg/vxnMtTIBzRGAUoonSEh135grs/tqw7tXPF2w?=
 =?us-ascii?Q?1QTh5HSxj/jpBuECgZuiRlBLGTezVwOQLfW1rcsNeW1Ship0yYVv7S7pbN3Y?=
 =?us-ascii?Q?QNeM0Y6EIoxmmZ2UqFJcIxEn7ke44Aq62+3NIV4ugHGnABzsc5Rbk2XZijYQ?=
 =?us-ascii?Q?ffD6KAelsq2USoUl6zMY7KrhZBaYPIjI6hqKKtBz/EEWgeRl88zTwCfR6oYV?=
 =?us-ascii?Q?lM8yoSL4iFZjCDmrz9RwBxzWLPpC4+CIYTQTt38h088TA7GuhH1mOvtUD6qJ?=
 =?us-ascii?Q?7kuovW2YE94EtoG60e+YzOrs2n+upkScTI8MZG8P4WxziDa9dv4JvDLTg1SY?=
 =?us-ascii?Q?DA5HsSZY99Kt2e0m80YHOZWrZNXvTkPaqNbdMA+YzVmB3F3Ojyne6SKnoxc8?=
 =?us-ascii?Q?Duy9W2w67z/O0sMNGndSAmNMXYWKbC6wD58eZdAPj1BoyuDekgQx+Bzb//e7?=
 =?us-ascii?Q?djAFst0RHAaIYrlvEJHW/BrViHBbzHJbidKXaHWLdvo+ZqjkKLmR2gAZz0vU?=
 =?us-ascii?Q?mvRgapSEKNEdZt42UldjS8+ccqZMOMD1bhCkC+xLO6EvkgXOKH/raEsK2yw7?=
 =?us-ascii?Q?lx7mEQuJkxHI7yl8j/lk5xT1FkqDWVeEtg+ynuLg13BjX6Pa/mU71r9EBSt7?=
 =?us-ascii?Q?IFC+JYOIpf/udK+8Js3EzLgp46F84zGYLhbjwMlLasHyZfSTQoX7wJV2Phw1?=
 =?us-ascii?Q?TTDDo803//ikszykjxPccVlSZSnQNVYAMrO9vJCPhBVEE+Yb4qhBpn7ntSHY?=
 =?us-ascii?Q?BNa0VkAOycjwQ1+0TDImB5iG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2204d2ae-4619-4a17-2972-08d97e23adbd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 23:49:55.6273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKHfGlZGLLE45vSyqz7DTnjyrcG5Pf1TwIIoMXdYUi0duFbwnTiEYScXfhVeXK7k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:24:07PM -0600, Alex Williamson wrote:
> On Sun, 19 Sep 2021 14:38:38 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > +struct iommu_device_info {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +#define IOMMU_DEVICE_INFO_ENFORCE_SNOOP	(1 << 0) /* IOMMU enforced snoop */
> 
> Is this too PCI specific, or perhaps too much of the mechanism rather
> than the result?  ie. should we just indicate if the IOMMU guarantees
> coherent DMA?  Thanks,

I think the name of "coherent DMA" for this feature inside the kernel
is very, very confusing. We already have something called coherent dma
and this usage on Intel has nothing at all to do with that.

In fact it looks like this confusing name has already caused
implementation problems as I see dma-iommu, is connecting
dev->dma_coherent to IOMMU_CACHE! eg in dma_info_to_prot(). This is
completely wrong if IOMMU_CACHE is linked to no_snoop.

And ARM seems to have fallen out of step with x86 as the ARM IOMMU
drivers are mapping IOMMU_CACHE to ARM_LPAE_PTE_MEMATTR_OIWB,
ARM_LPAE_MAIR_ATTR_IDX_CACHE

The SMMU spec for ARMv8 is pretty clear:

 13.6.1.1 No_snoop

 Support for No_snoop is system-dependent and, if implemented, No_snoop
 transforms a final access attribute of a Normal cacheable type to
 Normal-iNC-oNC-OSH downstream of (or appearing to be performed
 downstream of) the SMMU. No_snoop does not transform a final access
 attribute of any-Device.

Meaning setting ARM_LPAE_MAIR_ATTR_IDX_CACHE from IOMMU_CACHE does NOT
block non-snoop, in fact it *enables* it - the reverse of what Intel
is doing!

So this is all a mess.

Better to start clear and unambiguous names in the uAPI and someone
can try to clean up the kernel eventually.

The required behavior for iommufd is to have the IOMMU ignore the
no-snoop bit so that Intel HW can disable wbinvd. This bit should be
clearly documented for its exact purpose and if other arches also have
instructions that need to be disabled if snoop TLPs are allowed then
they can re-use this bit. It appears ARM does not have this issue and
does not need the bit.

What ARM is doing with IOMMU_CACHE is unclear to me, and I'm unclear
if/how iommufd should expose it as a controllable PTE flag. The ARM

Jason
