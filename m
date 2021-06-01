Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0D939795C
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 19:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhFARoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 13:44:18 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:5345
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231726AbhFARoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 13:44:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTOCzkkkaAa+INip6aQFO+CJPOw8Xh8OQBhvtPVN05e6M1UFpYF+YDlOJNPkhB0NN7UWWSGgxoj/Uff67lfRhA8oPZv2mEiBdeJY7dRNP+X6UgEdD2oBldUWsW1HkQy5j9A0A08rAdRKjWBr8Sth6PcvyEQkGezYCfVpr7JPYJKYU9Bn/DKOQLf71CjcFmKVYU3HWk6mCK2zziKmtgsH8S/0zJKBNiES1o4J0Adgm3KTI2LSJ9+Vbl4R3b1jODoH7nOy6nXN2NAhEH9J9Oxr8bjte3x0IvgVJji5BJYlaZNTUJOhug0zfmoqsdtPZnPu/w1zg/0J90EEmDVmbFQQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hr2TY6eU/Mcu8/7rqNH8TzR3VlHOrU+GVV7p0lZA2KY=;
 b=oKvZUveB6Kb3XZZYO8YN3rvO6oYU1CNsMXmVRJP/P+MkWlrihAhMpB1GC+SNpV1OLkutAAs0Qm0zqHSk5ET6SPtuS67CsbxeJyltiuUt5MEOAnPMKcFvQUuE+azNmGNI30xygT4XhfRF0Ui76LfewbgVUAYzr7dYoFPxutgW8lCm7NqyphKeeidqayZqTn6q8ENQltXX8Hvi8CtbpR7Ow259RejHiZczZul0WnB2wdsOzh+RW8onzDhUJtdeNsvgBNV1PNmymZP84sBnsp7EZfo2SXI+BHb3GCqkRKit/LPWZbHRJiCToMXVHAclPQDiuefdE6BMsAfn8vhSfSkG8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hr2TY6eU/Mcu8/7rqNH8TzR3VlHOrU+GVV7p0lZA2KY=;
 b=TmLuhLyHkTQn1u/pinFi50SJyYzLNCbn4+j6L2J4IebN6IFjOCoha87RuJRILCqKWuMzObiEbCacNFCRj2WMWDKOMRleaf67JCBufF3/ChCh+7Q9fkqfqGMzYKDWdBqwA79rYSjuIzMCfvgwj+/x4E7HAw4KPxcOPK6F1b/17+ysr4C6BecRumK85VdpPtXcxQXVATlRDdsXK21d4LgrBRhHNMIwzR+L/L6xvK/5yg67Vd/nFlQ9LAdfiEDE4NOs/IwSyYAVzuTqQDeYCJiemvxMUhiz7U8iWDpUvBhJRGnRGHahaVl/O63Rqg6ORhmdykioygNQHvap7p9uGBLHpQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:42:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 17:42:30 +0000
Date:   Tue, 1 Jun 2021 14:42:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210601174229.GP1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0132.namprd02.prod.outlook.com
 (2603:10b6:208:35::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0132.namprd02.prod.outlook.com (2603:10b6:208:35::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 17:42:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lo8PN-00HXnt-Qq; Tue, 01 Jun 2021 14:42:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7e2deb5-0a2a-404d-dee4-08d92524a166
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5238D3BB11F98DB65DA70EA0C23E9@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NtwU2rFI/jxZXnVw7sOeb7Jk15Tl3JEmEOnkCachVrhvcTz1z1Gj5Z/yd8bex3SbhBUtwn8YyI9VxmjTtY2StSmqPETVCnMKRBgjuk6ieBdCo7yR7XqVKMwx6az+oMiN5zFixUVGcnBkPbE86eretvhoDRgcy5hUbk5LTOcV4KWhF0zXu2x1WLJ8Z7Cx+8TYwUTdsMCEScu3DlCw0sSxlzRyXRDpz4JFbHOawxIi4T5Xj8Wjp46YFA8GB0s80l+hiygzCrrYWtbG/jhIWKbaQGrpgbaqCYcyTg5eVzGSudT7sUTPMrZlrW2Ay/6qi6euIGdRO6lHpnL274RnLa9Mo/tplWMFJdyYiiD+PpPo5zWUZnJ2Lh8x8h3/goL0O9D2zn5/fNpOzIhxpRU/ISw9T99tqnp6iaZCJwd5gP0AwkoSH5asEimOJ02oRfqBQIXh2h3MwHqJr3yOjaNd7QJy7f9ZyldSpjhmP0kyzDgFbDCFqN2jvOuuRIpwpFAoPwDLLrz537HPsdOUtuwknXOAPasPsht7518BRxcaX7/tAPFS+muDdPsx2Gt6Br1dBbv+TFRl3H1aZ6E4mEgriYijiI6vGCnNSWt+oACeVKWv7Xw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(36756003)(5660300002)(8936002)(33656002)(4326008)(186003)(26005)(426003)(54906003)(66946007)(66556008)(66476007)(2906002)(86362001)(83380400001)(7416002)(478600001)(2616005)(1076003)(6916009)(9746002)(316002)(38100700002)(8676002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OAkTOpf8cB7hTsty+h5cz9ZCxEGYNc9xSQc3QKgV7aY7RqbHXdCp+1kvI/IN?=
 =?us-ascii?Q?97Uv6n7k3c9g6XHCM7YAp4rmW11o71KdpgSqXP8aW395YkAh+15uxyCc87o4?=
 =?us-ascii?Q?8WuGfB/GBWBwCSajjxUQuOAjvL8oYK3m+1xUxuBIXHQZQx1mZWLCn41MNmDO?=
 =?us-ascii?Q?FoJcQqTbd3EA457lNcO9+vMuKi9Yyvhdna4oL6lmavDfcK6n40ELXjUvITv/?=
 =?us-ascii?Q?pEddA+WHAnJgFX4aKqcY5QQYiX4kDByfSAmqUrDFSZZJso5/fRfmTCfLbjom?=
 =?us-ascii?Q?0ZFjM+WH0DOVrJZXHfPALgFNYBx86vXRLDwwRV2w2f4LDJZ325lNlU9+S5Cl?=
 =?us-ascii?Q?ZpzxAEgRIQVhxw2hJZpGdruO4i8ZH9PepH3kb1YT5/+9Z4VG6V6wO/3gasvX?=
 =?us-ascii?Q?jBlWWExEA07+w4NN0UJI6Ho+vlzjwcMTQVVyIfud2ShE9elxasvY7MuzfOb8?=
 =?us-ascii?Q?i9lfI0nFT7XpkgkqaihbTq1xVqHdc6M8h1HCCAtnnNOmQ8Ea5bOJXVImZIUY?=
 =?us-ascii?Q?/qYLQ+m4vZjZst3hT4fcD0gfYrRHVgWS+wSYJL3EuhJUI3TYTdaplrkGdwVZ?=
 =?us-ascii?Q?c7hUFvFQHuWBLTuQa1HygKKQPf5PHvXjLk/Bu4lWNqvt6iSAeo02pXFqEYaQ?=
 =?us-ascii?Q?x0DmVtF/3OvuYfvt2WIjMu/fiiTRdHLr9Q01wpDy+sFzACagRpKhvXwgnsw+?=
 =?us-ascii?Q?c8Lt/aLKqw2OKf6HMVCC+TmCb0rZ5QpUU3o4hbz8LCCZ3XuBEgT9I8TFUnpy?=
 =?us-ascii?Q?0Cn9cJnZlIQaofwEKOg944Ble3mqS3DWrwH8H/fyUN+ufAzCXCUi4y5aFgyN?=
 =?us-ascii?Q?a+FxBsIkVAGBP9wuHE+dq3y2Pr6Br1YmyNez5XZHCMlL7H4qTFrrwCXUu6tW?=
 =?us-ascii?Q?uTQOmaQoaJICeBLJGz7/49lYmuETzDHRdrQps4iLjE4GXKbdwZ3v5i9UVs3+?=
 =?us-ascii?Q?bBLkgb9NnlarVPGef6rFGRKfIOWUIGXvzWBOTwUFhoX+0sYuD+NzxHSvi/0K?=
 =?us-ascii?Q?Ik/wyzxjFQ91EHw6I/vfeH3mbnNsKQNY5w8XL274MAhXDWCLDqprKZVk5tos?=
 =?us-ascii?Q?L04VVoawlxpYofiLDIJ3Tn3NYoQoUaBKqnrRWibJ83ae6GHhpNroktMBubQK?=
 =?us-ascii?Q?fZ0KQa3tkR7KKuBuqh+EFGou9RXnNW77dPCjrR++t4JBZVCpQCImkGQvM+PN?=
 =?us-ascii?Q?YYJ7CJu4bD8RsLy9OdrR9956DS2XMkdZtTRwS5LyAYsXm6oKMDOV2iP4cok+?=
 =?us-ascii?Q?aqoIsl3NgTfN8cM+c1VQ/mJCm63y3gG2JKgc4DHFrCwoYTCCAFZrR6+SCTPV?=
 =?us-ascii?Q?mXXEmR15T2CYjRBWWLFJmdAl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e2deb5-0a2a-404d-dee4-08d92524a166
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 17:42:30.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvCbZ8E+l1qa4ClSVkhY0SWYeQ2tGhWa81fkE+71XL++A4O8D4NnQBk4XEOf6P78
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 08:10:14AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, May 29, 2021 1:36 AM
> > 
> > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > 
> > > IOASID nesting can be implemented in two ways: hardware nesting and
> > > software nesting. With hardware support the child and parent I/O page
> > > tables are walked consecutively by the IOMMU to form a nested translation.
> > > When it's implemented in software, the ioasid driver is responsible for
> > > merging the two-level mappings into a single-level shadow I/O page table.
> > > Software nesting requires both child/parent page tables operated through
> > > the dma mapping protocol, so any change in either level can be captured
> > > by the kernel to update the corresponding shadow mapping.
> > 
> > Why? A SW emulation could do this synchronization during invalidation
> > processing if invalidation contained an IOVA range.
> 
> In this proposal we differentiate between host-managed and user-
> managed I/O page tables. If host-managed, the user is expected to use
> map/unmap cmd explicitly upon any change required on the page table. 
> If user-managed, the user first binds its page table to the IOMMU and 
> then use invalidation cmd to flush iotlb when necessary (e.g. typically
> not required when changing a PTE from non-present to present).
> 
> We expect user to use map+unmap and bind+invalidate respectively
> instead of mixing them together. Following this policy, map+unmap
> must be used in both levels for software nesting, so changes in either 
> level are captured timely to synchronize the shadow mapping.

map+unmap or bind+invalidate is a policy of the IOASID itself set when
it is created. If you put two different types in a tree then each IOASID
must continue to use its own operation mode.

I don't see a reason to force all IOASIDs in a tree to be consistent??

A software emulated two level page table where the leaf level is a
bound page table in guest memory should continue to use
bind/invalidate to maintain the guest page table IOASID even though it
is a SW construct.

The GPA level should use map/unmap because it is a kernel owned page
table

Though how to efficiently mix map/unmap on the GPA when there are SW
nested levels below it looks to be quite challenging.

Jason
