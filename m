Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83CD415CF8
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbhIWLny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:43:54 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:52961
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238930AbhIWLnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 07:43:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcDrhcZ5LVczmyEDTe/CHt61IvlMFZbdHn6D75nhVTtfZw2vav5tBgP9mxzjPLWsfiYLt6ixGx1Dz5t7+BPkA+kIrt2AUdyL6gryj4h1lZ+NQpSTstUTjqftR6PflphfO8hFy0HFjFh8vDzDrrt1VNdRIKhp3ipT3tYapQUKbIXbK3xYIz6D7PaicMAMYUD7KuDd0pB7QA8JuVwjLoNAPNWt1eZzLIcslzlEIteq5uzfVQvKRTiQ+CSLXo6cH22hPr/y3Z6zOPOidLQ0pbd6X81lyN09moX/L/n8wOefs3vdz15VdIX47k2uC2ysjaw/SB425kJYxfMdusA2QhLGwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vBJYojau7hiTKVLiT+3OLvavyVqVp/BBeBKyx7I+ORA=;
 b=AAwsG8almCUCZfhdd1/tVUwrI+wFD7jaT8ceWjzHhKpC6P150ZyUMSahYnp27ntyoFiE4/k0ncEVX22IisoZ7GfoaxZDaC8uxBxCd2LQmV7u9hQ7Afk4oQYXkI66lktmX5CzqT4clKhElClgWPnvx4+mGYpxzYVsUBNFSf042g+UkqBBUFtm9DKSezSKss3iuNk9LRP1YNkuZIC0kwSMWfLPdDFpq3FprQkrCeVFYq3HLsdeJoxhTtsT4/c9V3QulO2V/XxXxiwdYKvlhmJRXJZw7xh/Dm/VPKoZG/6BHdNHUJ4brqX2mg5r32TUzLjVT0dL6ziLQ10QBe2kZ3uPkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBJYojau7hiTKVLiT+3OLvavyVqVp/BBeBKyx7I+ORA=;
 b=iWDP2snV5pzbdguAKMB3ioMq5mSDMrFY/IwkCFrlM5vH7DDtYGpSvQJKeuoi4vVT62RZGf26ZfUFa75wBz6I3xwfZMplful0oX2aXM+cFUc6vMOHTiJAswZZp7yw/N0qGujhqis2AZHyrD2er9oANw/cOdXhxm+7UK0UvpfTEc0g5tzRiH7KOTGLZsw5NOX4NLKoozLTGHMuwgXLzJe8dtERj4fCcS9i33Cu9w7YzRzwh2mdxmBLGsrsQdGlUdBLDwTCaBm96pdXrtDWvr8xKV4piXOCIrxJGfgkkw0okpNW+6kJfzUG9vUPSNB3Oh+aDFI2iSyYjUvWMhnoMvEXPQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 11:42:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 11:42:20 +0000
Date:   Thu, 23 Sep 2021 08:42:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210923114219.GG964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0439.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0439.namprd13.prod.outlook.com (2603:10b6:208:2c3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Thu, 23 Sep 2021 11:42:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTN7L-004OOW-Gu; Thu, 23 Sep 2021 08:42:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aa4a723-b75e-4f48-e703-08d97e8733aa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5379:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB537990CCEA274BFDCEE0E253C2A39@BL1PR12MB5379.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrmpmcx5CrrRtQEVEyrZgKtbwLWs6tKR86EMtr5M50MLZKMcYgLtqfHiwBTaq7H7K+2ddiJkCoEb7YMfTIy0/mFyU/0AZV+FBHBe/qr/aI1ciZYqqd07z1nuYsHwoMVzt/0sPp3xYE+uAVFIqePZIJGd1W1YA1bE51EpHUDVlwu3rAfBopnmfV+Uj5HK51F1ywtUbAa2NcxaX0Gh7nMkPXR+4J/JuQsqKSLMIaKXxrXofZQYYSZTAbYR86UgA8KIjRcuD+efcwwgfHaboORhjT19CioLXQXI3nXCoB4ZoHfWA8vfm8o6lXmdQm5VWjwTo0FeDQLkNM2kCLpKG+qrseFc3OVEu1Cft52KrY8+rBARZl8cVSQ8pnZ4fev1rAsro7Wq75S+mOnHpp0A1A7g+Yyp7+Paskz3+e+EOo9YYxkLOQpMkkObM6bMmFm12ir/NpyRIbrvfK1lWBJSzsoSRNcPoZmikvbsVHxZBO0hTK/tUunRh8Zl9eMwhJKjbRVSfP2v5uj7MDX/tpD4iR79hn3NYPWgUBLx2iq/SwVNqNChQtGb+24MoROPmY5Qm3qUQA+VQh1xnDtLouFYXEOZF5gMnY4gM/yOZyDMZIlNIQEiK7HSsQhqpaIlyOg2ZKgSyMDflPp/iFhWPD9XUI73wmdT/1Te6dCFYQmaZOS85QqVaD+u12PdHYVbC1hOj34F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(66556008)(2616005)(426003)(508600001)(9786002)(316002)(4326008)(186003)(66476007)(54906003)(8936002)(9746002)(26005)(8676002)(83380400001)(1076003)(5660300002)(7416002)(38100700002)(2906002)(6916009)(86362001)(66946007)(33656002)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EVPsLiMlQTFeedz6QO5VNUN7fe49S6QznlZVsYuL3HsgBNXyI64ZAQE73xTE?=
 =?us-ascii?Q?pFIgRPXqnUEeHx6nd4NKqf4uzORuHfntQ+tKG1avRYPb0DmizmoTfbtjiM2W?=
 =?us-ascii?Q?lh19c2OCBhHnlBwUvzWrJge6A6Sa0/aUiRMRNVT6Bao3T6wTkrDRKmaI+QNE?=
 =?us-ascii?Q?2h3hFHuD7ZqQqSskxZeLSeTtCWJZQNGNduekMRnOD7wQqU+HtTwEkIRuHwNN?=
 =?us-ascii?Q?fQq6Gw1XdeOwX6eFl23K42J95d3JVP/OT6ZBXp8JLEFumKjAFN5L3hAD2C77?=
 =?us-ascii?Q?UYwGxiVYCKuM5nuZ9eI9o0i1AHn0XWLn0qCd3ZdexOfZH3D5gZ/nVfPQxlrO?=
 =?us-ascii?Q?eGyqVyJ5gjaUcV9DS0I3ZQHjPytlCKh7qwZkdhlC9KCVkNpBioRFEXyiDgsF?=
 =?us-ascii?Q?+dienOTWX3x2zLxmq6w3KWvIHsLuYcDeeAdoLJgjxsv4ISMub8iSQqpKcyCh?=
 =?us-ascii?Q?tGvcZyziwGzVaYgYysihmnHLntnqK851V2BOt23+V8cRdlyP+HjITkC+nHk1?=
 =?us-ascii?Q?jNWwKTLICUYywNa9HzIkKY082SDqmV7aZT/OoA5GGGW84RWQNHqSPZsMugVN?=
 =?us-ascii?Q?vV3f5okaIpWq+BaIXziOklxGCI4LeoIboCqL+UazA3e7wCfzw76/3wiy5OUE?=
 =?us-ascii?Q?CNwtecrxtqgobst1GD9EN0OjjSemk2thDRaMPFqqicW3MeYFweCLgKyfy54k?=
 =?us-ascii?Q?c/91PjSDZDom6JSOnD4XcQaUjpumx8MJo2ODuHJHBnvMC3FGC3iRRy0uIGvz?=
 =?us-ascii?Q?DsHJFU358JQYQ/49K5qX4FU0+GlbORURPhNzX9q8xFxlWmmZFjIC1Ox7wVbg?=
 =?us-ascii?Q?LukW5tsiGic9N6jqkFYJ7Xr5AU+URVgZU3xwwzV0nHsW8TYnflEj8RTpDxKz?=
 =?us-ascii?Q?9Ur1OshbRaVcdFMNayqxoAYwaucJ/B0i2LpqG07RX74PBweuQKvTYVaOg2hd?=
 =?us-ascii?Q?ZQN8cV7pCt2htF7X71hRxGhsr9MNxCygVFn+sOPLx2jMF0yPbIbsq58LnNTE?=
 =?us-ascii?Q?Y4EXOwIA0+u9UxxP3rd1zab63F1vvJSU3VrMOcKPLS15TkeU4L5kq4yjNI/m?=
 =?us-ascii?Q?bHYfF6sRneyfObKt8499Yl38f8wQjfYovAHVjsI9cxTwVxZ8JzwbvDNe5Hiu?=
 =?us-ascii?Q?giM4gieHbSwBmWZJZbIKYuBKQ7sKd6nTHfg1kR6MFLttAf2PyvHCPf3cvxYo?=
 =?us-ascii?Q?ZjLHIvT5jS1FUYF9imZjHXBjK+S7b/FNBPYWraCjSRUXPABW7x9o9IRfvNvw?=
 =?us-ascii?Q?ZL3sSDJ+EpmbDBQMXFZ5ENZwW7UsKPrOdJYMrpnPaCkgeNpRQKWoyTMPtlS8?=
 =?us-ascii?Q?PPKP0mCW/SqqI6JOSytDzA70?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa4a723-b75e-4f48-e703-08d97e8733aa
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 11:42:20.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEN7b36ohiDo13Gl6rhUz3wycKOEZEtBUNjINf+MxRaLgTF6dH+JXulK2ZwascQ6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5379
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 03:38:10AM +0000, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Thursday, September 23, 2021 11:11 AM
> > 
> > >
> > > The required behavior for iommufd is to have the IOMMU ignore the
> > > no-snoop bit so that Intel HW can disable wbinvd. This bit should be
> > > clearly documented for its exact purpose and if other arches also have
> > > instructions that need to be disabled if snoop TLPs are allowed then
> > > they can re-use this bit. It appears ARM does not have this issue and
> > > does not need the bit.
> > 
> > Disabling wbinvd is one purpose. imo the more important intention
> > is that iommu vendor uses different PTE formats between snoop and
> > !snoop. As long as we want allow userspace to opt in case of isoch
> > performance requirement (unlike current vfio which always choose
> > snoop format if available), such mechanism is required for all vendors.
> > 
> 
> btw I'm not sure whether the wbinvd trick is Intel specific. All other
> platforms (amd, arm, s390, etc.) currently always claim OMMU_CAP_
> CACHE_COHERENCY (the source of IOMMU_CACHE). 

This only means they don't need to use the arch cache flush
helpers. It has nothing to do with no-snoop on those platforms.

> They didn't hit this problem because vfio always sets IOMMU_CACHE to
> force every DMA to snoop. Will they need to handle similar
> wbinvd-like trick (plus necessary memory type virtualization) when
> non-snoop format is enabled?  Or are their architectures highly
> optimized to afford isoch traffic even with snoop (then fine to not
> support user opt-in)?

In other arches the question is:
 - Do they allow non-coherent DMA to exist in a VM?
 - Can the VM issue cache maintaince ops to fix the decoherence?

The Intel functional issue is that Intel blocks the cache maintaince
ops from the VM and the VM has no way to self-discover that the cache
maintaince ops don't work. 

Other arches don't seem to have this specific problem...

The other warped part of this is that Linux doesn't actually support
no-snoop DMA through the DMA API. The users in Intel GPU drivers are
all hacking it up, so it may well be that on other arches Linux never
ask devices to issue no-snoop DMA because there is no portable way
for the driver to restore coherence on a DMA by DMA basis..

Jason
