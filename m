Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52439A1D8
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFCNLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:11:16 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:50531
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229958AbhFCNLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 09:11:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oS7iFpBYmO3YwXill1blO7SqmirQnTBrmHmQXRUcy30hU61xHP41pKbnrrnhnpIP3+pCm+cmWOvPqfl6AQNvbaOeMjPyqEbUspEcGlpxMRianTPUf9ZlFR+KU69O48QiUxZKdXI8d0quSqSO4BNPu2xUJfjmGu2zVvHK54nqY0WQ8BkGiOHdIUjVeAka6jAPOCIaD2qmiUJ0s48NMB2K2WHFF0MK3X6rV2MWbJDdj5w7hmypgmr2Gm9Q57vrvW7eRUTZx/2bNhnRX7IsmEF3mMebeQwtJK/W2xsbI6/X3qcey1y4YEQ618SKn3hsT46VAXZdtR45vA4uwkuyG9b/lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2loWqHCgO4afu9bm317RWh0raaoD7gPQAfUUOCphTUg=;
 b=cOQzOq0kX7bzuOLADz+z5S78Lg3QPWacyq97ZqStZScgmzltINGH+dUzWlckcs7oXyRWhwt9CzFCZHoUgJQmc4menUT7FpuLoIY5DqD1sUCE0a0UqCmBQQKl5X5Nt3RTLu6Idw94IKsyATtAV5YA86NQEOH08VFIeJOcfN3/ish6fMuEARfUGV9RGevqPbvolyrU5S4jm34HycpZWU/VsFZzWnGJmICp0p/XylLh++NX9n2NsrKtmW7MJwjV6FniOZ76KzZlCyFBsrKqVVgEolSZ92q9Lq3nFCmn2Q85SCnQLslAvym3Kjf+xrNCeEsM+6vBSjKbynFcH+3qqWsZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2loWqHCgO4afu9bm317RWh0raaoD7gPQAfUUOCphTUg=;
 b=L83xY1BFffvcz28M23AbXqndCVChKFDbsZh09vfp9KhjXUDDDAiDSsg/UhY2j7oXkjIqbIgKxcyTPqB07Zz73ylFMji4IKZBPjkNLLicCwmLNxxN/4oi1VzJsciHy9AOFDeDHRGxa53Diwjbl5QL00DLjAWKAz7XTXZAOzR6E7LHTzATTPxfadRJXS9oJR6y5r6PEt85oxbn8C+SqIIvAE413LLK34GA5KogYEmJNWxBIJnN1rG5tveexix8J8xCGWCN0Rpp4Y4DFNObmmily87PqCvNfuKJWyQaL10mzmo4HXue8/sBW8ASVBRfmQ97AMagiokD5+ci65jbZVFz8Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 13:09:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 13:09:28 +0000
Date:   Thu, 3 Jun 2021 10:09:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603130927.GZ1002214@nvidia.com>
References: <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 13:09:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lon6F-0015NE-DA; Thu, 03 Jun 2021 10:09:27 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a548b7d-ebe0-44f3-e166-08d92690d1a6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5032757DD83961FF3F1A824DC23C9@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBcmjhS/JjN9+Q9oAM1HVRJc0p0EHBYfmP35e2wSVftADBmyQw8vms09QsNeeLH8MsX26gdM11eDVyXYAKoeC/1uGVGJ4wNMBhIVYb9CeYaRL5NSlArw0kBgUICq93ArzGWMe07XaMy7taReR7IMYTyk29glJUqwXx+hYCZafBuzuafDVB/U/zzdYuG0z7V2ahn5zyQIkT9vcJMXWzdNceHKauafCMwkzpK/NDx8u4Rdm6NyKVHVkiICB2hKYzsdGQyGi6KBk0lEtYjpb9JjLPk1RkXrFT+4UU8a33jVnfZJ5O7gncHACXQ7qgb8GsnOon0jrmumNw2gL/1AmA+6KhiSNCb4FKG31OchFAii1SxNjdr1QxTJDwhiviMBPM3xjxLmPrEt2LGGowquaRabBGpsVpueDxaVoYVWZtb7eWABLtxrlxhskDzHXui6fJxDSqltdm4ukZ0Ey1SKFfiNULpJ2EhppCUvHw4fm71TuNYmK38hBU3TPhfqNSXuk77H+rQ3iIHhT5tplawwwilzUwpvSflaZ9nMtNrgmRb8g7bGvf2Ea28Abggs2bBUlJFG+p76uP9Z6yvemog560kIC0ufP9k5+JPxVdFvXtpaLIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(186003)(2616005)(7416002)(6916009)(426003)(1076003)(66946007)(26005)(66476007)(66556008)(2906002)(4744005)(36756003)(38100700002)(5660300002)(9746002)(316002)(9786002)(478600001)(8936002)(8676002)(33656002)(86362001)(54906003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Dl2ChP/2IrZfw6pD1CFWHqNjFz58DsGDZgIPF8rTBhKn5dBBB0jMvu/q5h6f?=
 =?us-ascii?Q?Q5se0m8V3EAPVECuajQJOku7LzBtwWowKr6nkc5CCDFFRp+IB4Qu5cBUxg9s?=
 =?us-ascii?Q?2XFTPdEgnSxwcdvPP/lMax9foqatFBaYkqiAogUb/r7nDZoD464paKPFWSKU?=
 =?us-ascii?Q?v3DKZh9Od8PI1lwuJEw+ERLjWEmOpifuXDduzO15HanF1+PT+zipMDsYrylV?=
 =?us-ascii?Q?wROZYavVri4QEETM05T2qTbZh5XzDtthedABaHihfTP9a9yex0miQAfCqe86?=
 =?us-ascii?Q?hlBlCXyFJY6Hxr6V4G1BkBd/CGIX+GpXweOUWdKxIZFlx0lKHFSPL6+NOs3D?=
 =?us-ascii?Q?Jpf2fAnZ2F5l1szsC3sucxtmKgKL2gMHqwtzlyZc51ixkSE33u1Os1IEB1V1?=
 =?us-ascii?Q?Bk5GH3gUbKcuFeQ0OaLOFhiwGht1ubLmC1qAOiniyh9og64jEXB+5GXbW9Lk?=
 =?us-ascii?Q?QYyhXKQLOtwvnVwCEQX/8U6k33c2NuPGeTK2YGPkrXHTnFeBlG4ZMwdEuyn3?=
 =?us-ascii?Q?zxgzRSQp/WxMVMM+o3f2b5MyfFNtuMG1nQIa9sNp27iS5KAawLgrbQKCVwVd?=
 =?us-ascii?Q?+/MRMaPq4h4sk+mC/xEQTyF+eivwvFJZhwK6lXN5yaMyLR+tTYUpxW2Pqcsy?=
 =?us-ascii?Q?jBLTM7DtGtSV2ImbSBklwNp4RMAVFSOw1tagcFKOurXOY1eKi1jlY4cg984V?=
 =?us-ascii?Q?46URdp1u9dsVnWUEA0M/nPc85ELkgbSL03r8zvcBzBxgKHbkaPYhM0UAEQeI?=
 =?us-ascii?Q?eFQ/EDR9SOn7juXLano3xlidUy5b159Cp8A/7o6Noq/S+OZAYefC13yXpeSF?=
 =?us-ascii?Q?EQ0og69NiU328+XEC96M2wQFFB3j7mdEFkSSusaqk5HmADo3UqfUe0w4ygXF?=
 =?us-ascii?Q?16EeNUz5goCT9ynHwrV2n1Hb0YAn2SyXf0+50IAEgWeZ1j1gozSjWcuQJCTm?=
 =?us-ascii?Q?pPMbamXJiieprgbzSYw25B+cGdARp4IhvoiUTgzrvw5gM4Qxf3oqJW5e8BPW?=
 =?us-ascii?Q?QzNIIboCZ/F5hkVh89nVoPSiIDICYTPa73WuJdagnBZFm9fcaUXrukaoyRBs?=
 =?us-ascii?Q?SPt7JYsJamwgBf0S012b7CxI8Bczew6en3zLZoosUSzyvdB/lDLmCyxk2uPr?=
 =?us-ascii?Q?yRUuMVi+SS257W0qPOEZb7i6j8OxxEiveUxWI2hnhYmPjUvZ85ZSrYzwNsJW?=
 =?us-ascii?Q?XGl8XRXODS1aLeqb0sSnCXMiV9x9PS1od7kWLPlSYNOKYybhXi9wLcGUMJDz?=
 =?us-ascii?Q?/+HKiKw3fYt6ZTM3qSfICeRB0xFUDHdqFrL84xJekzmlrIjNuWgRNVhtycql?=
 =?us-ascii?Q?oj+S4aJyimBtyB+YlR7T2zmB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a548b7d-ebe0-44f3-e166-08d92690d1a6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 13:09:28.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4l7+FoaFW61bXmgbBMXpkUdVFijWz2mMjbed8P2Rq1DOuX9ruThmm7lbtQTe2hmi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 10:52:51AM +0800, Jason Wang wrote:

> Basically, we don't want to bother with pseudo KVM device like what VFIO
> did. So for simplicity, we rules out the IOMMU that can't enforce coherency
> in vhost-vDPA if the parent purely depends on the platform IOMMU:

VDPA HW cannot issue no-snoop TLPs in the first place.

virtio does not define a protocol to discover such a functionality,
nor do any virtio drivers implement the required platform specific
cache flushing to make no-snoop TLPs work.

It is fundamentally part of the virtio HW PCI API that a device vendor
cannot alter.

Basically since we already know that the virtio kernel drivers do not
call the cache flush instruction we don't need the weird KVM logic to
turn it on at all.

Enforcing no-snoop at the IOMMU here is redundant/confusing.

Jason
