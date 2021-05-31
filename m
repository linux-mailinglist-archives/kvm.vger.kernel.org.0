Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809833967A1
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 20:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhEaSO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 14:14:28 -0400
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:40256
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230288AbhEaSO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 14:14:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMrRBq7kQaCSTPBhWQ3iMBc+5jiJTXaNKdDCxTPmeRPgL3qoJa9h1GsDimhpJyDHb+BIqi7OaQ9vsw2eszCeEwfOiQbdqPKR3zJ8zuVB4vRY+QnwHMDHtArxzZ+u9gKIJDNxBjcQ92c6ZpCfvEtC/KpoYsSsu9HEQmJZ29Bx13rhWVrtcphm0JReNZZlUxxkrJdDBqr/G0AKE021i54Vs3u80KNlf0x9Yk5r5TYwRNgp59MHpbhHm5U3h7/gxIDjDXSAdAbiL7GeMyc637egl5r+E7F3+cHNqFmq6x7gxSgJgdVUrdK/qhYPZht3UjgtEN4RvsUMOEuIw3v3Ldfvug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF1QE1MToHriJPAqkPIyvgYFZfgekNjoqRsg0DNFx8g=;
 b=V42aSnyOIYMuy/DERgdde3DceafvUqogyoFZIObOvHpxuG1mSaXcK9q4zntDrLAtU6eQMBiX2iYuUQ7WxFxdm0eGLSdAK900iJvYywkY1pXaatQj6k/fblkLcCppBzilWHQICK1FlENkDnPAX1DN5IaRnjkHuQsoiDNFG4qPbnHNCDjZfPcJuiev/P5jhvM8vC1gqNB05khkoHd1vq/DgFsftl4qL5n+lPMWpxTkGu9wMAglr6p+1/sB+xb+iYYYon1NeC7fczDQu4T8rUGboow/DQUVw9SYOzA2cod7zdYQDimcgtNrsBU/qOquQQHVwSIDnIeJVpaDJMXlBTgxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF1QE1MToHriJPAqkPIyvgYFZfgekNjoqRsg0DNFx8g=;
 b=LESRi6aq/vWsF8pMzT8MjG++ecLVLJwAen/RK7nt1gOqEralUMq0szYvirpoL1wHSG52To1rapB4i+ncFwWS+SBcex/MK4LmQ+0aqvoqwLfC/CbYmzYgrgifvet54U1ht+HEG8okAOrZ11pNL9GQy5vGAu8y2zCQU9XBfptk6d9WakSV4CE1CYj6DD1XXSFVt+8JitCTlD7rjBwczzfaKdcebpCCxhF0gG1q5BMVlrhWaw3IxKSJtOFdx32fnXKeX1mu1U9HEz8DM7wtNElgHAgiPynuUErQrF6vdkyJ5b0lZSsnGNhb/QU1x3u1aMLTQsKk+wnd7CyeH7yg4btonQ==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Mon, 31 May
 2021 18:12:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 18:12:45 +0000
Date:   Mon, 31 May 2021 15:12:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210531181243.GY1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <PH0PR12MB5481C1B2249615257A461EEDDC3F9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481C1B2249615257A461EEDDC3F9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0229.namprd13.prod.outlook.com (2603:10b6:208:2bf::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend Transport; Mon, 31 May 2021 18:12:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lnmP5-00HD5i-V6; Mon, 31 May 2021 15:12:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efde8504-a71a-47d4-5295-08d9245fb04e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5190DCD9BA74A88EE3BE2CE0C23F9@BL1PR12MB5190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZoFOPzX0QcdMK6GCEFI5me7Vz+mdaNR2Q17eGouVCkzPVRtYDR/wqMgZ95pa3wSQt0LRYofpeC1ZmuGrAGFz+bcTmZDnJ4KUH5wQhhlmz8gKKm+JWvHgV0rAbdjEEZcUfJIiC8J7wFm/WFmp0MyXKcWsRcvna3oXLCqxS5BEQYjB9Knd0gD6bb4aCZE7sz+TViAkVnbBNTgNT6Mfsxpq5OKIU0ahUSb+YS0yph8bsZ7rx5+W1FyjCqbraUyn0PbREGuA4NliNNFZM2hJvJAY/uU7nxWrJ3BdNow+pdqu+cqpQyYYrZRKewUJpKlpW9WLRrw5q+yHv48rxJOPZ/3OXsI7Lc4AQ0h+g5q59yVUL7PAdYNtBOcIed20ECxyf4CNGUvQNL5lHsydQjluyepLR//srhMvxwOV+jSTsWXQBErgXfn4+EIrtlrjqKKIxSAuKe3ssJ9/fMtk1mZRoCWVRqmzAiyKhBQfIzy+AqsSwQQhYyUV+nj8T33p7jL/fz8VBbPy9KLjpUXL9KDhsUqlmdLTsnxv47VNWQdrYso0QVl7HCixupYIIzChU+aNu2WOZG38ZtpQskjXDINiLCDoIIUzxvILWVr5VOokJZJMVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(26005)(54906003)(8936002)(86362001)(9786002)(316002)(9746002)(5660300002)(37006003)(6636002)(33656002)(1076003)(7416002)(66476007)(4744005)(66556008)(478600001)(38100700002)(186003)(4326008)(426003)(2906002)(6862004)(66946007)(36756003)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b7Yd3SBS0mk0L+qTeZnTXkaG3CqhvuyWHE0veBcpoWIaRA5SflhYzZ8JMJsA?=
 =?us-ascii?Q?9eI9MDL91a61cPtWiG3wyRpCBs1le1lLgf+wVNl8L3xFpQaNsy/ixZyWE4Z4?=
 =?us-ascii?Q?i0npSYTPj9Br3R+qrisd2rFxvO/zF7qXFR5bD8Nt9vXGO6Hl5pjbmLwx0HkV?=
 =?us-ascii?Q?w1Lz/alxGQ5Cxd2PV6fmDqXi7wqEMh9/945i0x8JFdg6fgDJT5Q9lo+JjAZH?=
 =?us-ascii?Q?Cs45jarsml8FkDJZbgHklnDKw5fkLELw0LMaMFFBb6l8yXQN1CXvia2Fvp9G?=
 =?us-ascii?Q?Pnm5EZ0oapHb/wPgcX9puCq2jICYjGxJrFD0owzioWW367PzE4lToXAB6J5R?=
 =?us-ascii?Q?pIJGz7pJVSfsjL3Pjibx5+g2IPWfD+XVscqb5GiElYoaJ+kDmpWEHTQ93wVW?=
 =?us-ascii?Q?L2Hsv72tx/j3ve9hNQ6izHe0biHlKssXE8DpsBDucWBqwAqd+3Ymbvf4Cngc?=
 =?us-ascii?Q?7O0B85uO2NePnBXVXtKWFRBU91A45E7941+MbgGkqnUWfugKkldB+MKAi4Y/?=
 =?us-ascii?Q?ko70PTkCihnjJV/gGGM6Yvov8VkDJDmshCNu9cksU8I9Kr6pdbAyL6fcqLaI?=
 =?us-ascii?Q?nlIpkoWCce46ck0T+HIUuhaEX6YqcvIEgZ80fRbk8vFcVAVvk/oeUs1CrnRl?=
 =?us-ascii?Q?XXZfWTxbrKgGFWs9lNaQOK961lSlMlxOsl1hNvPDSahf5GafenP5B9Xy+GXA?=
 =?us-ascii?Q?f4+lhMv5B5KNyDDdX778ddD4vABaiRqFIZ32lm29cGkSe//alxyeI8kwS6xn?=
 =?us-ascii?Q?3ArHpXHANL4VHNOCaZ6CyI17at3nlQkedSjAzBYaIeBHUqWa568VpOYAKrzs?=
 =?us-ascii?Q?FLlN6/4KBO5yYUkzSy87wQmxVXj7cTA5ldSoenAG/RcWV6BK07mHuKRQ2c65?=
 =?us-ascii?Q?x9pM8YqHLM4FKOlvYpQRj83VgHjTRF1c3z9un0z5PZQx5j8YmVbSovJ75535?=
 =?us-ascii?Q?AWxbE8mhilO2jLdYpXdL2Uwutxzk+hnBZRiT6vG+wG8RtiLYq6sqTT7pfXnQ?=
 =?us-ascii?Q?5xCnNPiOzzWmqdpnJDwXdea9ktAKxDQI2hx5hlQBfPE8b1IHfFe2ZnLnRJ89?=
 =?us-ascii?Q?Ivvv0Djb3SStWfaAindL7dGHq02vGoqbilITDAWJEmi65aQsDkbankCm+rwq?=
 =?us-ascii?Q?tsg6LreQldjkHB4hvbSHpbYGWRbGC/3IQ6QxluhaNjyXGwOPQFEJYZmbC/wa?=
 =?us-ascii?Q?d36sZtmnLxuWN1Jlay2+zW/gK0ZKKBRxU1hL/9vFQ20YXOCM0v9kNrva15DY?=
 =?us-ascii?Q?wMWujSF9WTtgA+CrHWuurbNmT+uhu6Po/MJPaN398qyml9tM3jRsbt4IyVWI?=
 =?us-ascii?Q?qaosSZ6ChgS1Ksb+Q8nNZCRq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efde8504-a71a-47d4-5295-08d9245fb04e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 18:12:45.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vihKYf1dLWLw0b1ZqaPQCq8XHW8THdKJttYm1D5dLGfB6WkHThWiqxG/G3NJNfjP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 05:37:35PM +0000, Parav Pandit wrote:

> In that case, can it be a new system call? Why does it have to be under /dev/ioasid?
> For example few years back such system call mpin() thought was proposed in [1].

Reference counting of the overall pins are required

So when a pinned pages is incorporated into an IOASID page table in a
later IOCTL it means it cannot be unpinned while the IOASID page table
is using it.

This is some trick to organize the pinning into groups and then
refcount each group, thus avoiding needing per-page refcounts.

The data structure would be an interval tree of pins in general

The ioasid itself would have an interval tree of its own mappings,
each entry in this tree would reference count against an element in
the above tree

Then the ioasid's interval tree would be mapped into a page table tree
in HW format.

The redundant storages are needed to keep track of the refencing and
the CPU page table values for later unpinning.

Jason
