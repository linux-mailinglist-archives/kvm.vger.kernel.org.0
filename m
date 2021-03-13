Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C11339A3F
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhCMADT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:03:19 -0500
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:45121
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235934AbhCMADJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:03:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIfJl/Y/UJ11GnWL3KE/I92NNee0/bHJ8gio0kIsTpi+K9biWU0xLkwyVUudscrGv0gEGI2Z4jWSX/9vYtRVFxWX7Rj8uM3C5MGppuG0UkNp1g7FWR5nlsxGMDWLXoDy3J+GjZXJ5NJgxcxqCmkF3oKgqJZHKXEkpsvHgVaueJ6kzmklL6/x8Z0AKHmVbbh6BBlOGayr2KW4F7eXKnFO810dGXTmEu+/PUwDX38Mu4ZXQ+BV6vsoZNdLaULswu99mdVTKSvHqO6CFan7eOW5I9Lsd5oHQGeDMb22fn+NHzVWzmx1PSDTabYGujUPMqwJV9fLPGwyWZubojWW3n1f8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm8KfcSsaW7cgvMZ1Kiap4KWKCHfMC9em0ix1rpnBYo=;
 b=MLcflgVJNrTbOlSZo5cdJwtin7YylZ1czEQnFKrE/a/tP5sHyuDJgDg+QweegBzx79uIYxOPAFTkbVM2JirsmfsdmSTWMnjvIddu9MaJ/gvqPXml0EjMyX+VwqTJ99Lt9sRiKhd+EW1mPoe+TwOA+84bLkxbz4X+B7TBYT4B9pYqvAXtWM6VFK9dWdxKDLEiyt86vN8bMCEHmPHJB1t/pkfECW6a42f7foFDu9eAD1LESshcNmN2Cj1lPI/1F62CnuTteAdQzZ4J///x0ZAumwJOqpkfxYq86EWuMrx7pbxLuDA/51OB5Wx0IRnp8LzNZpFkWdlJikTUGJkV3hI7rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm8KfcSsaW7cgvMZ1Kiap4KWKCHfMC9em0ix1rpnBYo=;
 b=b5Ow+Noc47v5zNLob0LI8oVp+5QvGJKPcG+QkPKpeazODljA2KwWsiQuDRci1omOQdKmB1uZ/IUYYn1wadvCE3xHhBUo4DAjANFB/7aUd8O0x5FpyWKQK8Ee5uBrVha3WPpj/BDjgfpvKpk54k7x1cN7MGz8neHMff/XdvFx1jMVUPdPhTpPKW1zu3ywwERyeEdXEQRxFWRqJolJFujY1YOSr1EzmcxV5T2WT0an5c7LRUxYUyb5W0zv6fpOu3dF524Lpuv60u0n+cbYDp9824uGIhO7G+wCish0qHldcnnbgXB1gjWN9pFSw1H+mrqWPN1L6cgDVNKDvA3WitX1Rw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Sat, 13 Mar
 2021 00:03:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:03:07 +0000
Date:   Fri, 12 Mar 2021 20:03:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210313000306.GI2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
 <20210310184011.GA2356281@nvidia.com>
 <20210312121611.07a313e3@omen.home.shazbot.org>
 <20210312194147.GH2356281@nvidia.com>
 <20210312130938.1e535e50@omen.home.shazbot.org>
 <20210312135844.5e97aac7@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312135844.5e97aac7@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0248.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0248.namprd13.prod.outlook.com (2603:10b6:208:2ba::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Sat, 13 Mar 2021 00:03:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKrkI-00DBgW-Dl; Fri, 12 Mar 2021 20:03:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b481d9d-fd1a-4035-85e1-08d8e5b361cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4235CE14E44BC267F057A129C26E9@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7BY4zabChksVGfKMu14E5r2mBnCQFwNOa/y1KrFobxdP3PKOU9X6dd+M8kAW27Q7ykF4vJBQ/OEWBm78XfCaLv6oRRooZ3lNCHnt6LrgxivrIuZje+3J0bBP9WW/AC2ka1IT39leebyCWAMLZnlRdz1Hy7P7rij9YKRzvhD9mSuFXzwkf2YsNObBK3PFHyFcCkBHJUFEHi7fWuxEehnjSR8cX9Kq+pKTTUDJOJmn2VqSEXZCim6agrEc6eAc/MnmWCW92ilfT3299uThWzk6k7rJR/8F2vlv485gtpjyaQnoifW5dQzfwP479fBmLJz87tmk8o3HLZF5VUGVKEvOAgSTfDWJsce53EIrfMXQKeeZsJVHhlc5cAc+gxnt4Ru7Spg9mg33YgWtmgrCcg2hSjfi0DmhRncUUb97bPwGYjO7MrVF1GAKIRjkILESQZ1Lyf3lv87tszS1c6PLBgrQaWs2sQ7vF4EAJtHgytgB6Nup551t5kd9MnKhRRJB3+A0xv25Xitnt4lnZiZlWwgPhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(5660300002)(2906002)(66556008)(33656002)(26005)(8676002)(186003)(66946007)(66476007)(36756003)(1076003)(426003)(9786002)(9746002)(478600001)(316002)(8936002)(4744005)(86362001)(4326008)(2616005)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V7G807XVR6kr2PJnVA7Gn2HHZe/TGQzJg1mjkk0Nsr/+YIr6wC2RcsOgXToA?=
 =?us-ascii?Q?1rSWZQIGaWKVvnYiGJ79AoU+/cnAP79/iannXmX7jns4sU6/0IXdx84juf7w?=
 =?us-ascii?Q?+qDlPTevFiJiMhTkNOYCjWMpQXfU7C06uAW0sTvdfuY26+61K1F+BqDpEK6A?=
 =?us-ascii?Q?a/7GPHDK4iV6TcN0hDj4b9l9kEIsTxwLjYQfWtWGpxaeUOIa3h18uDZ4Qn/6?=
 =?us-ascii?Q?0EYWLm5rWhR9lD4esnsAPOJuGjBgMqKJtYpVvNRFmtLyJiBmld0NcZZl3FKW?=
 =?us-ascii?Q?06lOB5HT9lHLvtUXPuqDHuRX8K1tY/hMCIm1oFo1no9HYs4qM7itElK4HG9c?=
 =?us-ascii?Q?OfNQflge2zOHR4Su/euYIj9PhMj4Xv/14EyJ761uoR8hFXqGXupobc5Rxnel?=
 =?us-ascii?Q?DKj6fkUcQGtmD5A7gLrEfexGf/4g2L0FSaQUiLPBqhAc8IrlrF6ZYgBrSFE2?=
 =?us-ascii?Q?XZ0JfsyaCLoLnOcCRaeZLavR3EfKlPSEFmSQ0Elv7iSbD233j+hczH1vXbAm?=
 =?us-ascii?Q?0CBVxZdpbM38ey2cRpf6YhI4mdFZ5K9EpPqlwi2zFItFdpkXGI3irG29GaOH?=
 =?us-ascii?Q?ds/GPpAqA6AhrUHWRA8r3mgV3BjGvTik2tdePKKiZ8Reps0xIVjlwBoVbfIg?=
 =?us-ascii?Q?lCJ7GnIC6kUORJEWwS8cqxvMzveUylYA6DCYvrofa0SOcTcihHi9KVqUwDTC?=
 =?us-ascii?Q?RfVxh5TiF5uJb6iRrWO3EK2id1Lil/sOwbuI1TI/pBziFfelMQrOBie+/xe3?=
 =?us-ascii?Q?89g4o7ptl+yqjr1FVx2wVpHVaSAQcOLAErtBUUiwcbNN22sHnavEm63J9TKo?=
 =?us-ascii?Q?3mzk85zhXqxNpRNOabeAVZ/z6iUUE/sYPI0flIf6iFgceiXyjbKTfxEfJdUV?=
 =?us-ascii?Q?A4zRnILz6KjfJMdb9bBi7H0QG1Ul7IbCBndyxnOKMQF4mIoNQpeocBM/pgvT?=
 =?us-ascii?Q?uQRlaXyA6/kY+Iyl19U4Ov7d/kmZmY/qq3ITJGS86Ovg4LA69Ww9yv6DH2Vv?=
 =?us-ascii?Q?olFc6la1emNBaMR9va3vDxq6rZH9f098XLqK0YTXdt3fpP5+15SY2RijWsY4?=
 =?us-ascii?Q?AGnPam4UkB8NJFqZLrRIjI4p3QU7BpkNU1pWffkx5Wwtu2oRQT9/nqy0WRzF?=
 =?us-ascii?Q?f332+JlSenQpE+kLrVo7ApkCHenyHmrgSOvpTgYEcktr01NZiAdiO6WzZtyO?=
 =?us-ascii?Q?VJrKZ3AwgHEzBNjG9HMdprfcAMH40RJTbasVxcZMB7RmQT5QSTnbrCcywS/O?=
 =?us-ascii?Q?ezL1XVqKg5pD1YO1580OYxslU3gdGEfiBbTd70q0UB6dkZjRcbyUPPM473a2?=
 =?us-ascii?Q?HOMNE9RBmRw1nHA8SzmuZrmY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b481d9d-fd1a-4035-85e1-08d8e5b361cf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:03:07.6851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMTHSjyjvQ9DFSGFC/dmqonwJK69D8U9pE3KLbQQfmMaYZc8uOntBiYr+9qUAva6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:58:44PM -0700, Alex Williamson wrote:

> Yeah, we can indeed use memalloc_nofs_save/restore().  It seems we're
> trying to allocate something for pfnmap tracking and that enables lots
> of lockdep specific tests.  Is it valid to wrap io_remap_pfn_range()
> around clearing this flag or am I just masking a bug?  Thanks,

Yes, I think it is fine. Those functions are ment to be used in a
no-fs kind of region exactly like this.

no-fs is telling the allocator not to do reclaim which is forbidden
under the locks here (as reclaim will also attempt to get these locks)

I would defer to Michal Hocko though, maybe cc him on the final patch
series version.

Jason
