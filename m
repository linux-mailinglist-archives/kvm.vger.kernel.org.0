Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F34939A16C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFCMvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:51:12 -0400
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:50144
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229801AbhFCMvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:51:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5HHb4edAGYN8hZT5iiIEbCzRtOoeRg4rBtLrOxqkAqgJiKNYSX/Xv4OOLfTH7GM23OZLJzUrBhSrhG6b+ZNxrRR5lABrEr8U+krbHDQCd0yA6WvTLsn5E7QUdftsvI1rU+3ELAPO0xJcQ0MF7rAKLQtsO3IktxJB7s/8NmsJBCR5fM7Tu7i7Is4Ts8+O+1YD0EWZH/PO/R1Vb1VEW+p9aqxEZz9ZP6wXBjopep3LVtB6wdoygB55qovJHon3fN/gkOYGHSi9mMtVH94d1/S6x+AVZnkNjqJ11f7d1ARAQpUfxjKFCJJSihq7ryNuDTw1YMD40yzNcALZUfkZ0IYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zifp6LGBMcahPPa1/hfQc+nZIll8c0K6BEy0x3TQ0dg=;
 b=bg+EISICkZx4i6o6QC3b2YWdkzxFzHnEle9WvMSldNPq2/fBigaVuf5Ho4Unn6ly58nHB9eSANY+swa1v0akYadI1hNvjpn7zvCwHDU3A+cbbD4vkYri1bXAJGbvFddQXo4psqaYmfOQcKNCD6iKbhX2jjxMJvH6zPUEqX67KdgMXlBMmO25GAJmjy9hyMl6FphlzNoHvSdfei616jucnP6jKTE/iY9fvorhLdPet+q/onPICNHKzPPWMhq1AMzN58cRJdgzuqrHVxbbkzgXIDgWCvRBUSg2zJKMpSG3M6J45af8OyzEEIt8B9glGTn0+hboUyS9HI3sk/RfCy+F7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zifp6LGBMcahPPa1/hfQc+nZIll8c0K6BEy0x3TQ0dg=;
 b=eOfTLePvhwunsxPBiy1hspGckjWsVMCG0RJy+sT08SKoK24OZhTMWaBWk+lPwVc8YZZDRluy2OJBx2A0ZMahiY4bW0nI7Z6juhHlEkfY+WtJQlHNT/ip/zF8sBsR+sxyMe37cDuMGv3esk/dI2tBEPCpOsOIu/0slOJcD4qlnDSl9QBZcXI79Beg0UDAWdPy6SvVsr6BJ9Io3qL/cegl17QvdghVYu8QfHLt3Al9JMd9d6SvmHniMZGrA9PSg99nvB3bA1eKYCedQ9sxAFNxXH1iytgAvo1yzgENmozxd5Mayye3ySjHy0Q+MXI4gA/3Oxmadpldla0gJ7IO6kzIhA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 12:49:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 12:49:25 +0000
Date:   Thu, 3 Jun 2021 09:49:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603124923.GW1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <MWHPR11MB1886081DE676B0130D3D19258C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886081DE676B0130D3D19258C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:207:3d::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0045.namprd02.prod.outlook.com (2603:10b6:207:3d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 12:49:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lommp-001534-Gv; Thu, 03 Jun 2021 09:49:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d936492c-efa5-43cc-6250-08d9268e0446
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5521BBB06271F5D85C5E973EC23C9@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJOFTSgxEN6R2cJdd4nFUL0LYbHVZPifvHI7A6foUYDtVwucT4g7+Tvlf5HV0MNxPd3fu/CSgBrz+RxPj3n2gm8WiUYvq0NCNXQTMo5L7YBQOKSPiYOcdam4l8JZU6gOyKP1Yap1sVCLGBcaodHzfxKQJ0WNXR7TTlJrHkVJFVf1UTQa9E4BdgUSLgrjTt6pGEd6VJyfauuJWyepiHmrDrnnUEaQQfaVK2OXazHkWUl6Cqm8QtPBPZTBDGClzkpqxe2HDIfkXHZ16VqTJL2QkuqwOFIViCzaZ6vWlIJe6y6br83I0wjhxy2rra8/AgRSWYsRw0Le5NKwdns2OSmV9ZX16/71/46eGqWeeVM3yCknv+lNUmtAgEpWLe65L3R6oPNOP1ECiBZ0Ipr9PZHws2YyrO9Tm8lsJNyCqzW0qxPQNNEawXQ3PSLMGywLvfwN1xe8nlIGObCiFNmOiLMCBEULOMwmV34tuQLFpYTiyfPWK9kMdkfDW9rAi6tAjYZO7cv03w+SQg60QZ91ZBS4cmy2AIZ2Vn3b5cebiyBTbtGSZ+Qmz1M0pGKEPkI4Qoe5USgtI6fqYmQfCnCTAyZmfDDc5b6qrGMOl+EXc+QTldY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(1076003)(54906003)(316002)(7416002)(9746002)(9786002)(6916009)(8936002)(2906002)(8676002)(86362001)(36756003)(5660300002)(26005)(426003)(2616005)(38100700002)(66476007)(66946007)(33656002)(478600001)(66556008)(186003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NeXT+MO5lRSio/byZYGwc7jgC9OykFWmYgRPXBi2w5W74Fu2+unOwb05nIef?=
 =?us-ascii?Q?lYW6MwUDDB2p8Jp258PSluY0xIEk/r9/+xq1VLNxatkTWnkF5mF6t7Ol4Yvs?=
 =?us-ascii?Q?wcj/ysUnJdkYr9Mcx0wD6AjykNQeD7aZtCD7mcxU6eepzbiVZQzFMLdI1Igl?=
 =?us-ascii?Q?slL7FdSgVV0GTlkXzvoW68d2TXJ50NXhQkQ5vRt9pJ7VpEOBuHrt3R61DLRa?=
 =?us-ascii?Q?tSOjsoDGciBVKDwOtSjhW3BbKGZ0SO3NMNtL1DDXorAAYt7iNYXO+V9yF5ZA?=
 =?us-ascii?Q?mr7YpuJ+lDE6+owK7n/izt4MAnKzEbNECZMISFxdEKZpCglGbJfe7ExlLoG7?=
 =?us-ascii?Q?no7iG6IZ8LvbRG7mniU1SNR/zADfKMZkpbg0r4RhWIkfUer7sC61V+yBt9eM?=
 =?us-ascii?Q?OdAgusjZyf14M0xGlV2Dk2W3lH8L2YT66W+Bi4Ms2ZFNW4vWDG+uHbqB+lDv?=
 =?us-ascii?Q?bkLjNYEJKjs5t486p09UxrkPurQpbYsZWiRqylIL+Nki+uO8N0EcuiJh83mg?=
 =?us-ascii?Q?lvPhmD569O01yLjoT8MbHWL7KvvEdUnFWwuP1Alih0Q/Z/IMIjNXcDZlSt9u?=
 =?us-ascii?Q?HVBRdJGYpgQ8ZFi4/UKbFIfBgYBkjhFaxW9pQ9z95M2v4S4XQoWp9C4RlRxT?=
 =?us-ascii?Q?T+PpehIMzaG/F3wqJgSiZCk2pyxB5JpqCn/mMJxNVlywL5dpcayuRNde1nn3?=
 =?us-ascii?Q?c55C5t8oWGrXOzO9bLDDEQWGdUTpjFlvwnn5LjjAlQKIxlk1tucrCkwEh/to?=
 =?us-ascii?Q?waeM/cDLdJ4pHjHK/tiHTMaLvFcus5g603HjnyBDGAuFYmUCBx9T282Qb3Jv?=
 =?us-ascii?Q?YdwJbyRzPe2/zc4b+b6lCzMU4Y/vH7IPwO+J+fNIFcZ7zEr5lFrHp9xbTpl9?=
 =?us-ascii?Q?kOB8auFyTCN5iWULfXhbMYhAGfzSGOm3Y4groefzzt5NMxdTzmKOR9w1RF2r?=
 =?us-ascii?Q?LH/zP9d/GxbwvQ5bpwbS7gyLnj7oQKSjVzE6fT/e9MIs4m2oCfB3MZ8aZ6aY?=
 =?us-ascii?Q?B3jA8EZLGO3DZg6EBaZlrcy8heD3YxGr+PMMEbHj13rgpOsT1UJqhYalIiqG?=
 =?us-ascii?Q?vjqmpwrn1wmOPdFcV6UlCdpS7FnCVV3+0LdnjLNxqd+f0HsJw/gxHq85Cjlq?=
 =?us-ascii?Q?RttvY/nmim1yNtW1g5JNSV8bArRRGveev3mx1xBqgmnC3MBZrryC5BXBieTY?=
 =?us-ascii?Q?tYUSmja6xTxiL3M5StVFRQVkpd0nMGGOuI0asitGMn5bA8DBgnSF5KPdC4EA?=
 =?us-ascii?Q?wmHhhxztlkJLpW431eYGgrEwq2q22HVYFywWxRpUTC9ynjHtQzpdI9rwonRp?=
 =?us-ascii?Q?Av9m8CUMF3MWZeyBjeeHA+3K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d936492c-efa5-43cc-6250-08d9268e0446
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:49:25.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eyye7yD39Q/gehwOZuTI1CvalSvseCzzA/B6dZk0y2q8nq3W1NkUbd1jBtITeuy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 07:17:23AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Wednesday, June 2, 2021 2:15 PM
> > 
> [...] 
> > > An I/O address space takes effect in the IOMMU only after it is attached
> > > to a device. The device in the /dev/ioasid context always refers to a
> > > physical one or 'pdev' (PF or VF).
> > 
> > What you mean by "physical" device here isn't really clear - VFs
> > aren't really physical devices, and the PF/VF terminology also doesn't
> > extent to non-PCI devices (which I think we want to consider for the
> > API, even if we're not implemenenting it any time soon).
> 
> Yes, it's not very clear, and more in PCI context to simplify the 
> description. A "physical" one here means an PCI endpoint function
> which has a unique RID. It's more to differentiate with later mdev/
> subdevice which uses both RID+PASID. Naming is always a hard
> exercise to me... Possibly I'll just use device vs. subdevice in future
> versions.

Using PCI words:

A "physical" device is RID matching.

A "subdevice" is (RID, PASID) matching.

A "SW mdev" is performing DMA isolation in a device specific way - all
DMA's from the device are routed to the hypervisor's IOMMU page
tables.

Jason
