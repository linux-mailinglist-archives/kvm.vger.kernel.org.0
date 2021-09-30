Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143AB41E3CA
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhI3WZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:25:43 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:7265
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229787AbhI3WZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:25:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZdo4Sbgm1QfBvexvLngKcY1Kfruzd7/x1N3oF3XYiPdVYz1Gn/FB7siPX5vXiK8m5M7qqrlFH+WjNIlOzx6OT6SCwPU1p5kTkCeFh3+LVu6gPDBv7IIUPXqIcAqUd81H0fzK2hMWVfF4aMrdhI83Q8bmJKHRwgwQIcZUpIEvajV2GvQEjqW8+v7xshlqeWXu8DxHGGp1+nMD8tRsOeYzYCxjR67520iHpo7bsiRXfHnybCkxRJJkzFMv88cKQyjM98q4YEnwR3xg1rQyJq5sg9qOlBQ77DAT2PF82Un9ULuFmVeV/8tzRoUjY3b2WAocOeqx/0ap/82Wc1JFd8spQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8rYvPryZQKrIM8tEkD4vvVoNxAafaUuLd5XFu4X+ZA=;
 b=f0uZ13GQdcHvWFDCHZGiXxbG496999RkLJzTdYkU8ePdHMHKt3xRyDjh7JgEiGzK86/SVjQUbwWqdQmfQjW6MkOkallx+sEIGA6B6yIqkyd6Xm6PpI0IPx3a0dmA9+Kf4nzGnbjuyj8OYwuJw1cG44FYSoTusyw6dXkD6yJb53I65i5JCKFZaXU7D9u/fds7cd1a3N+AuOx1JDaewDTm7qimx7aT3zIfjrWk+UV8VPnbGmwsHr3/pZcgyKR/89HFvyYb7OwjfCvGhaDTkQMFhIg3sjqMm0FA6zhr5WhCETiReKOxt891oxK151804tcgCFnL3vHCppSYOWCdU76mLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8rYvPryZQKrIM8tEkD4vvVoNxAafaUuLd5XFu4X+ZA=;
 b=oGeP9TP85U+ilU/nal3YOr1kf5Vn7uDTSjXQ3TuMLoNOfpw8jxD48yh7/q5xscCtBg4uyIX+fRu+911QSEMBkeSjKL5kRisjBm8nG0j1OE0vt7aMeApu5MTdlY0+PHWjokaCAgkykjTIMLClH5581aNhqFHNJEi9b4Luh7nHpyJUM2oxoE3bI3B9bkn6eFCEfPIsQ7npbuMEhhUwjAV432jEYaqh2oWQBeD9Xwgpa1el7eV5YMFTyPuVO4Y63vHwQW5VzJDF847uCeY6AtKavp82XVWOAJ/zPgp6gDqYA5RCHAb8segVXXh9EoHsT4nfQ6b4h5Hc/V3+/pY2lvFTJA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 22:23:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 22:23:57 +0000
Date:   Thu, 30 Sep 2021 19:23:55 -0300
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
Message-ID: <20210930222355.GH964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:208:257::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0041.namprd13.prod.outlook.com (2603:10b6:208:257::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.8 via Frontend Transport; Thu, 30 Sep 2021 22:23:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mW4T5-008DTq-Rv; Thu, 30 Sep 2021 19:23:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 660659d2-9d2f-4e8b-8ea8-08d98460fe49
X-MS-TrafficTypeDiagnostic: BL1PR12MB5364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5364EA843231E93F4B9B2BC8C2AA9@BL1PR12MB5364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WlCSvIhLy3PdGWTrMrMDSwohRiYaSuvQ7OP/2UKrWz8Dm+7y4gQSS1W2MlJGJnOoxLtzD+DRb/q62LCoxxmY9MPQUby8sJIqKQ+zbbP5bs1Kdc66XScNJchJKYWtb72+R71pHILQmguflmZEW2B9TaQfUK/amWaLtdfJSPopqNqESsbDYflhwdAEwY4jijhqpfnkxnXMPwE21X4J9tHeGEJZSMkTVShV9wt2XGy9/y9RTQg9oe0EL0yIAClCKjgQ9jME5eiAuV8ax7EjUsFuVZ5dUyYpAMhBOcyn9AdgfR5qE5CMT11he3VcHwKHyQWUOUDWpom3OIH0RWqAyWSRBc13MjT71DMNKDgP2zF8nItO3AwEa8Q1udRMUBqkB4xFtcPRv5B5omv418zyAjEegl+bhBwBEgig3uzlZX3kw7o/l931jcRI0q/3x/AiriDaP4Ur/Y1aiuswjT4QmVcpKcsgDEXFcrmd0SNKG3d3BNQGoAthS0Ww8Xhh8nq4p3QWXv4UYkjo9kBmsFvp7mcXbJ8PlU7Dof4VqHdgnAeGuirhcdFme3yJSZgAnnjaNuGLpWXhhH1JNaLETRXjc2MtHHepEZGKuXpj8piqhMHftOzUUv5nCTd9x/2xYycqQBA+vG/6j4iJS5cLG9pdQmAB3g7PTIxlvalOA4fqEC9mljDcYD0DqnjYduzVMqpalGZRvmYzZHTF1XhRXlz9XmAMiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(2616005)(4326008)(36756003)(38100700002)(66946007)(7416002)(6916009)(8936002)(2906002)(1076003)(66556008)(316002)(54906003)(83380400001)(8676002)(9786002)(186003)(26005)(5660300002)(86362001)(508600001)(426003)(33656002)(9746002)(107886003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?79NX4HWYP2dXDjiTOUCq5N1UCjFmRGk+GYjd1eTzU8ii/evP4zWAAH20KVwZ?=
 =?us-ascii?Q?okqL+KXgkuhEwj0rTYrBLyb8RkKc8rP3yeyf1PGPEVXZxPXtaupyUqf8/RPa?=
 =?us-ascii?Q?fIPNhbuCLtgL9EybbcFSvcTXvapEmroVEDkDKgf2ojwBCarSNGjB4DDQIVsQ?=
 =?us-ascii?Q?1+Fm+ofBAyDwSBX3xc5KTa/0cm5JDKRcnDrQimpVXNrbHF/P5A2139f2LaaN?=
 =?us-ascii?Q?YF8XrGo9kNZ+Zv3wTjadqLKolyiWD1ITeLea5MYnHzLfPc1mMZNWs8Pzyk8g?=
 =?us-ascii?Q?7QZsDDjibxC0Qn4KbppHvD4uzZoujrEjLrinlOoHEZJpD4yeFZmwVWWXf9uk?=
 =?us-ascii?Q?VSWXbZnRez5e8uiUoweedGxq93FXg+lNDBSvxTW+a2wxGSdzpRWX618r1GLn?=
 =?us-ascii?Q?u2w2+cDWsvAOJMJ5RtnutXHfJ5/zDN+PRZm74d49Xq4kMPNXFVi1lKFZ2hIY?=
 =?us-ascii?Q?1NjriIFRdEIJe0PYyNH5FnJjOK+tlCvu+W7wxT/rcwtMllfAsyfDcLWP+D4M?=
 =?us-ascii?Q?67pAUs2HtkN/WLjIrpHCt3f28BS/xZd+Qcp7F6xhIMbHp6MGdypbI5InzdFq?=
 =?us-ascii?Q?MXRevGtvM+b9eCPyxcnLBGONEUGQ6J+7eB6kKTHDYNbtKQOd+tWPch8iulKI?=
 =?us-ascii?Q?Okck62rmgj7SPG05PEj/wCwJC0MVyaOiayCOZkGy/lE3OJe/ULyL41RLJXlR?=
 =?us-ascii?Q?kNXeF2ry9XOIgfRG3kTwd19vU0zijoeGYBQlmZQHT5ZonJ0jtGeqd9IPD2SN?=
 =?us-ascii?Q?B7kj6inx+hFSAYH2bWAfq9nmoXhcmK0rWPVAGYWBUi/177w1bCS4On3ess7j?=
 =?us-ascii?Q?lnseJZTKOn2F+FKgTwT5/v/mFQpQIIXbm+IVz48Q0Y2Tnv/UU5lL9BYbYORM?=
 =?us-ascii?Q?kj9tSokhl03vgKZCCP6j9welweeE0xiHI1gAyADOoDw9mh/b3pCLJjEFE5p9?=
 =?us-ascii?Q?antJn149I3ocnfPLopCaHzpf9Bi+5y+mcb+7VbS1ggluXQ7cjK8br/HFWdSV?=
 =?us-ascii?Q?dXCy0N8kIJLPL4OoOVwpgqRg+mNFsVzlOBMjkbFcM6F3qEsvnGmOVVuTu5mH?=
 =?us-ascii?Q?GvuSUCM87U0LJ2zDMRM6zu0JFHVdS3CwtYPTM/iZ3qEVH9V1Wm6gMh8OTaB/?=
 =?us-ascii?Q?Bz0XH6e5lMiJNjMZ8oM5DtkhKqhb+COg332Dfj9cqmMs0y16ouS6Ros+CzVK?=
 =?us-ascii?Q?+GK01CK8+CgSZzQ5bU4xur6+YkTovBnw217T9NGKxAa5q7x0TWcMmy5Frsuy?=
 =?us-ascii?Q?KUA4aWTOR6xT7JQhNVN3fLZVxXqRnwXmhXyCdeiYjcOHB/LsA/saCRHu+w41?=
 =?us-ascii?Q?1Ju0BcgWxa3dFvvFDL7MRMFJhvqjj8ODtTdGa8Ha/+Lo6A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660659d2-9d2f-4e8b-8ea8-08d98460fe49
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 22:23:57.2444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yg24VqEsfKxnMglP6ZEfidJAgmWXRJzvAQsfCem0GIp4qdPMeQu2sMwoWlDVDZaC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:35:45AM +0000, Tian, Kevin wrote:

> > The Intel functional issue is that Intel blocks the cache maintaince
> > ops from the VM and the VM has no way to self-discover that the cache
> > maintaince ops don't work.
> 
> the VM doesn't need to know whether the maintenance ops 
> actually works.

Which is the whole problem.

Intel has a design where the device driver tells the device to issue
non-cachable TLPs.

The driver is supposed to know if it can issue the cache maintaince
instructions - if it can then it should ask the device to issue
no-snoop TLPs.

For instance the same PCI driver on non-x86 should never ask the
device to issue no-snoop TLPs because it has no idea how to restore
cache coherence on eg ARM.

Do you see the issue? This configuration where the hypervisor silently
make wbsync a NOP breaks the x86 architecture because the guest has no
idea it can no longer use no-snoop features.

Using the IOMMU to forcibly prevent the device from issuing no-snoop
makes this whole issue of the broken wbsync moot.

It is important to be really clear on what this is about - this is not
some idealized nice iommu feature - it is working around alot of
backwards compatability baggage that is probably completely unique to
x86.

> > Other arches don't seem to have this specific problem...
> 
> I think the key is whether other archs allow driver to decide DMA
> coherency and indirectly the underlying I/O page table format. 
> If yes, then I don't see a reason why such decision should not be 
> given to userspace for passthrough case.

The choice all comes down to if the other arches have cache
maintenance instructions in the VM that *don't work*

Jason
